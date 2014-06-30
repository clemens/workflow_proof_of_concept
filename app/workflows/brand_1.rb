$workflows ||= {}

$workflows[:'brand-1'] = Ruote.define do
  # or make it:
  # concurrence wait_for: 1 do
  #   participant 'customer', task: 'place'
  #   participant 'dealer',   task: 'place'
  # end

  participant 'buyer', task: 'place', allowed_roles: [:customer, :dealer] # precondition
  filter do
    field 'state', set: 'placed' # hook
  end

  participant 'dealer', task: 'pick'

  filter do
    field 'car_model_id', in: CarModel.pluck(:id) # validation
    field 'state',        set: 'in_progress'      # hook
  end

  concurrence wait_for: 1 do
    sequence do
      participant 'dealer', task: 'finish'
      filter do
        field 'finish_comment', empty: false # validation
        field 'state', set: 'in_review'      # hook
      end

      participant 'backoffice', task: 'accept' do
        filter do
          # field 'accepted', is: true # validation # FIXME
          field 'state', set: 'done' # hook
        end
      end
    end

    sequence do
      participant 'superdealer', task: 'complete'
      filter do
        field 'state', set: 'done' # hook
      end
    end
  end
end

# Flowster.define_workflow :'brand-1' do
#   state :initial
#   state :placed
#   state :in_progress
#   state :in_review
#   state :done

#   transition :place,    from: :initial,     to: :placed
#   transition :pick,     from: :placed,      to: :in_progress
#   transition :finish,   from: :in_progress, to: :in_review
#   transition :accept,   from: :in_review,   to: :done
#   transition :complete, from: :in_progress, to: :done

#   # place
#   preconditions :place do
#     field_value '{{ current_user.role_identifier }}', in: %w[dealer superdealer]
#   end

#   after :place do
#     transition_to_next_state
#     create_and_assign_order_number
#   end

#   # pick
#   preconditions :pick do
#     field_value '{{ current_user.role_identifier }}', in: %w[dealer superdealer]
#   end

#   before :pick do
#     set_attributes
#     validation required_fields: [:car_model_id]
#   end

#   after :pick do
#     transition_to_next_state
#     email to: 'office@example.com', template: :order_processing_started
#   end

#   # finish
#   preconditions :finish do
#     field_value '{{ current_user.role_identifier }}', equals: 'dealer'
#     field_value '{{ dealer_id }}', equals: '{{ current_user.dealer_id }}'
#   end

#   before :finish do
#     set_attributes
#     validation required_fields: [:finish_comment]
#   end

#   after :finish do
#     transition_to_next_state
#     email to: 'office@example.com', template: :order_finished
#   end

#   # accept
#   preconditions :accept do
#     field_value '{{ current_user.role_identifier }}', equals: 'backoffice'
#   end

#   before :accept do
#     set_attributes
#     validation required_fields: [:accepted], field_values: { accepted: { equals: true } }
#   end

#   after :accept do
#     transition_to_next_state
#     set_current_time '{{ order.accepted_at }}'
#     email to: '{{ dealer_email }}', template: :order_accepted
#   end

#   # complete
#   preconditions :complete do
#     field_value '{{ current_user.role_identifier }}', equals: 'superdealer'
#   end

#   before :complete do
#     set_attributes
#   end

#   after :complete do
#     transition_to_next_state
#     set_current_time '{{ completed_at }}'
#     email to: 'office@example.com', template: :order_completed
#   end
# end
