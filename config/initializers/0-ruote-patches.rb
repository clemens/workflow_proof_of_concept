require 'ruote/util/filter'

Ruote::RuleSession.class_eval do
  def respond_to?(method)
    super(method, true) # Ruote assumes respond_to? behavior from Ruby < 2.0
  end
end

RuoteKit.instance_eval do
  def run_worker(storage, join=true)
    RuoteKit.engine = Ruote::Dashboard.new(Ruote::Worker.new(storage))

    yield RuoteKit.engine if block_given? # added this

    RuoteKit.engine.join if join
  end
end
