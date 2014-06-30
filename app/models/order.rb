class Order < ActiveRecord::Base
  belongs_to :brand
  belongs_to :dealer

  after_create :start_workflow

  def accepted?
    accepted_at.present?
  end
  alias :accepted :accepted?

  def accepted=(accepted)
    self.accepted_at = Time.current if !accepted? && accepted.in?([1, '1', true, 'true'])
  end

private

  def start_workflow
    update_column(:workflow_id, RuoteKit.engine.launch(brand.workflow, order_id: id))
  end

end
