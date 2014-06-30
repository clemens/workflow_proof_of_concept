require 'ruote/util/filter'

Ruote::RuleSession.class_eval do
  def respond_to?(method)
    super(method, true) # Ruote assumes respond_to? behavior from Ruby < 2.0
  end
end
