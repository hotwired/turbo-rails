class Admin::CompaniesController < Admin::BaseController
  def show
    @company = Company.new(id: 1, name: "Basecamp")
  end
end
