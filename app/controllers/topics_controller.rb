# frozen_string_literal: true
class TopicsController < ApplicationController
  rescue_from BaseService::GithubError, with: :render_error_response

  # PATCH/PUT /topics/repository_name
  def update
    repository = UpdateTopicsService.new(topics_params).execute

    if repository
      render(json: repository)
    else
      render(json: repository.errors, status: :unprocessable_entity)
    end
  end

  private

  # Only allow a list of trusted parameters through.
  def topics_params
    params.permit(:repository, topics: [])
  end

  def render_error_response(error)
    render(json: { message: error }, status: :unprocessable_entity)
  end
end
