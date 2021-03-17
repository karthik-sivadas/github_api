# frozen_string_literal: true
class ApplicationController < ActionController::API
  rescue_from Octokit::Error, with: :render_error_response
  rescue_from Octokit::InvalidRepository, with: :render_invalid_repository_response

  private

  def render_error_response(error)
    render(json: { message: JSON.parse(error.response_body)["message"] }, status: :unprocessable_entity)
  end

  def render_invalid_repository_response(error)
    render(json: { message: error }, status: :unprocessable_entity)
  end
end
