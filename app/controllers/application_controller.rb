class ApplicationController < ActionController::API
  SUCCESS_RESPONSE = { success: true }.freeze
  FAILURE_RESPONSE = { success: false }.freeze

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  private

  def render_not_found
    render json: FAILURE_RESPONSE.merge(error: I18n.t('api.errors.not_found')), 
      status: :not_found
  end
end
