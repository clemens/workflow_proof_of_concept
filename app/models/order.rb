class Order < ActiveRecord::Base
  include Flowster::Workflowable

  belongs_to :brand
  belongs_to :dealer

  delegate :workflow, to: :brand, allow_nil: true

  attr_accessor :current_user
end
