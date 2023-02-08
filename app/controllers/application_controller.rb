class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def render_unprocessable_entity_response(exception)
    # require 'pry'; binding.pry
    render json: { message: "Record Invalid", errors: [detail: exception.message, status: "422"] }, status: :unprocessable_entity
  end

  def render_not_found_response(exception)
    # require 'pry'; binding.pry
    render json: { message: "Record not found", errors: [detail: exception.message, status: "404"] }, status: :not_found
  end
end
