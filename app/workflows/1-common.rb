class FieldValuePrecondition < Flowster::Precondition
  def initialize(transition, field, options = {})
    super(transition, options)
    @field = field
  end

  def passes?(workflowable, *args)
    value = get_value(workflowable, @field)

    if @options[:equals]
      value == get_value(workflowable, @options[:equals])
    elsif @options[:in]
      get_values(workflowable, @options[:in]).include?(value)
    end
  end

private

  def get_value(workflowable, field)
    if field.is_a?(String) && field =~ /\{\{ (.+) \}\}/
      eval("workflowable.#{$1}") # my heart goes BOOM
    else
      field
    end
  end

  def get_values(workflowable, values)
    values.map { |value| get_value(workflowable, value) }
  end

end

Flowster::Preconditions.register :field_value, FieldValuePrecondition

class SetAttributesHook < Flowster::Hook
  def execute(workflowable, attributes = {})
    attributes.each do |key, value|
      workflowable.send("#{key}=", value)
    end
  end
end

class ValidationHook < Flowster::Hook
  def execute(workflowable, *args)
    @options.each do |validation, configuration|
      send(:"validate_#{validation}", workflowable, configuration) or raise("validation error with #{validation} (#{configuration.inspect}) on #{workflowable.inspect}")
    end
  end

  def validate_required_fields(workflowable, fields)
    fields.all? do |field|
      value = workflowable.send(field)
      !(value.nil? || value.to_s.strip == '')
    end
  end

  def validate_field_values(workflowable, configuration)
    configuration.all? do |field, validations|
      value = workflowable.send(field)

      validations.all? do |type, value_or_options|
        case type
        when :equals then value == value_or_options
        else
          raise("validate_field_values: unknown validation type :#{type}")
        end
      end
    end
  end
end

class EmailHook < Flowster::Hook
  def execute(workflowable, *args)
    puts "Sending email with template #{@options[:template]} to #{@options[:to]} ..."
  end
end

class CreateAndAssignOrderNumberHook < Flowster::Hook
  def execute(workflowable, *args)
    workflowable.number = rand(1_000..9_999)
    puts "Assigning order number #{workflowable.number} to #{workflowable.inspect} ..."
  end
end

class SetCurrentTimeHook < Flowster::Hook
  def execute(workflowable, *args)
    # field = @options # FIXME
    field = :accepted_at
    workflowable.send(:"#{field}=", Time.now)
    puts "Setting #{field} of #{workflowable.inspect} to current time ..."
  end
end

Flowster::Hooks.register :set_attributes, SetAttributesHook
Flowster::Hooks.register :validation, ValidationHook
Flowster::Hooks.register :email, EmailHook
Flowster::Hooks.register :create_and_assign_order_number, CreateAndAssignOrderNumberHook
Flowster::Hooks.register :set_current_time, SetCurrentTimeHook
