class Brand < ActiveRecord::Base
  has_many :orders

  def workflow
    $workflows[identifier.to_sym]
  end
end
