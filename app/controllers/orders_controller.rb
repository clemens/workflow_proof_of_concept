class OrdersController < ApplicationController
  def show
    apply_errors(order)
  end

  def new
  end

  def create
    order.save
    redirect_to order
  end

  def transition
    # FIXME
    # render text: "Whoops, transition #{transition} impossible", status: :not_found and return if something

    # We first assign the params and *afterwards* merge it into the workitem so we have proper data types.
    order.assign_attributes(order_params)

    workitem = RuoteKit.storage_participant[Ruote::FlowExpressionId.from_id(params[:fei])]
    workitem.fields = workitem.fields.merge(order.attributes.slice(*order_params.keys))

    if order.save
      RuoteKit.storage_participant.proceed(workitem)
      redirect_to order
    else
      render :show
    end
  end

private

  def order_params
    params[:order] ||= {}
    params[:order].permit(:car_model_id)
  end

  def order
    @order ||= begin
      order = if params[:id].present?
        brand.orders.find(params[:id])
      else
        Order.new(state: 'initial', brand: brand)
      end

      order
    end
  end
  helper_method :order

  def workitems
    @workitems ||= RuoteKit.storage_participant.query(wfid: order.workflow_id).select do |workitem|
      (allowed_roles = workitem.params['allowed_roles']).blank? ||
        allowed_roles.include?(current_user.role_identifier)
    end
  end
  helper_method :workitems

  def apply_errors(order)
    if workitem = workitems.detect { |workitem| workitem.fields['errors'].present? } # really?
      workitem.fields['errors'].each do |error|
        # error is an array containing the validation filter itself and deviations
        # example: [{"field"=>"car_model_id", "in"=>[1, 2]}, "car_model_id", nil]
        # TODO how to do multiple validations at once?
        validation, field = error.first(2)

        type = validation.key?('in') ? :inclusion : :invalid # TODO lookup
        order.errors.add(field, type)
      end
    end
  end

end
