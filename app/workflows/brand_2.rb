Flowster.define_workflow :'brand-2' do
  state :initial
  state :placed
  state :in_progress
  state :in_review
  state :done

  transition :place, from: :initial, to: :placed
  transition :pick, from: :placed, to: :in_progress
  transition :finish, from: :in_progress, to: :in_review
  transition :accept, from: :in_review, to: :done

  # place
  preconditions :place do
    field_value '{{ current_user.role_identifier }}', in: %w[dealer superdealer]
  end

  after :place do
    transition_to_next_state
    create_and_assign_order_number
  end

  # pick
  preconditions :pick do
    field_value '{{ current_user.role_identifier }}', in: %w[dealer superdealer]
  end

  before :pick do
    set_attributes
    validation required_fields: [:car_model_id]
  end

  after :pick do
    transition_to_next_state
    email to: 'office@example.com', template: :order_processing_started
  end

  # finish
  preconditions :finish do
    field_value '{{ current_user.role_identifier }}', equals: 'dealer'
    field_value '{{ dealer_id }}', equals: '{{ current_user.dealer_id }}'
  end

  before :finish do
    set_attributes
    validation required_fields: [:finish_comment]
  end

  after :finish do
    transition_to_next_state
    email to: 'office@example.com', template: :order_finished
  end

  # accept
  preconditions :accept do
    field_value '{{ current_user.role_identifier }}', equals: 'backoffice'
  end

  before :accept do
    set_attributes
    validation required_fields: [:accepted], field_values: { accepted: { equals: true } }
  end

  after :accept do
    transition_to_next_state
    set_current_time '{{ accepted_at }}'
    email to: '{{ dealer_email }}', template: :order_accepted
  end
end
