# frozen_string_literal: true
class RepositoriesController < ApplicationController
  rescue_from BaseService::GithubError, with: :render_error_response

  # GET /repositories
  def index
    @repositories = ListRepositoriesService.new(repository_params).execute
    render(json: @repositories)
  end

  # POST /repositories
  def create
    @repository = CreateGithubRepositoryService.new(repository_params).execute

    if @repository.github_id
      render(json: @repository, status: :created, location: @repository)
    else
      render(json: @repository.errors, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /repositories/repository_name
  def update
    repository = UpdateRepositoryService.new(repository_params).execute

    if repository
      render(json: repository)
    else
      render(json: repository.errors, status: :unprocessable_entity)
    end
  end

  # DELETE /repositories/repository_name
  def destroy
    render(json: DeleteRepositoryService.new(repository_params).execute)
  end

  private

  # Only allow a list of trusted parameters through.
  def repository_params
    params.permit(:user, :name, :private, :new_name, :description)
  end

  def render_error_response(error)
    render(json: { message: error }, status: :unprocessable_entity)
  end
end
