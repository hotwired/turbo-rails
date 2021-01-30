class Company
  include ActiveModel::Model

  attr_accessor :id, :name

  def to_partial_path
    "companies/company"
  end
end
