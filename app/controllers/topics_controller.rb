# frozen_string_literal: true
class TopicsController < ApplicationController
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
end
