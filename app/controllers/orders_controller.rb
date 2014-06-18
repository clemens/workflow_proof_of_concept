class OrdersController < ApplicationController
  def new
    render template: "orders/states/#{order.state}"
  end

  def show
  end

  def transition
    transition = params[:transition]

    render text: "Whoops, transition #{transition} impossible", status: :not_found and return unless order.respond_to?(transition) && order.can_transition?(transition)

    if order.send(transition, params[:order]) && order.save
      redirect_to order
    else
      render template: "orders/states/#{order.state}"
    end
  end

private

  def order
    @order ||= begin
      order = if params[:id].present?
        brand.orders.find(params[:id])
      else
        Order.new(state: 'initial', brand: brand)
      end

      order.current_user = current_user

      order
    end
  end
  helper_method :order

end
