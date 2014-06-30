class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :handle_tenant

  def index
  end

private

  def handle_tenant
    raise 'no valid tenant' unless request.subdomain.present? && @brand = Brand.find_by_identifier(request.subdomain)
    prepend_view_path Rails.root.join("app/views/#{brand.identifier}")
  end

  def current_user
    OpenStruct.new(role_identifier: params[:role] || 'dealer', dealer_id: (params[:dealer_id] || 1).to_i)
  end
  helper_method :current_user

  def default_url_options
    { role: current_user.role_identifier, dealer_id: current_user.dealer_id }
  end

  attr_reader :brand

end
