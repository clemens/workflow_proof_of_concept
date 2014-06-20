class Order < ActiveRecord::Base
  include Flowster::Workflowable

  belongs_to :brand
  belongs_to :dealer

  delegate :workflow, to: :brand, allow_nil: true

  attr_accessor :current_user

  def accepted?
    accepted_at.present?
  end
  alias :accepted :accepted?

  def accepted=(accepted)
    self.accepted_at = Time.current if !accepted? && accepted.in?([1, '1', true, 'true'])
  end
end
