# frozen_string_literal: true
class SecurityController < ApplicationController
  rescue_from BaseService::GithubError, with: :render_error_response

  # POST /repositories
  def create
    render(json: SecurityService.new(security_params, "enable").execute)
  end

  # DELETE /security/repository_name
  def destroy
    render(json: SecurityService.new(security_params, "disable").execute)
  end

  private

  # Only allow a list of trusted parameters through.
  def security_params
    params.permit(:repository, topics: [])
  end

  def render_error_response(error)
    render(json: { message: error }, status: :unprocessable_entity)
  end
end
