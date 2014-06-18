class Brand < ActiveRecord::Base
  has_many :orders

  def workflow
    Flowster.workflows[identifier.to_sym]
  end
end
