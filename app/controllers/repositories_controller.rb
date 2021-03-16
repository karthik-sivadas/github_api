# frozen_string_literal: true
class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show, :update, :destroy]
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

  # PATCH/PUT /repositories/1
  def update
    if @repository.update(repository_params)
      render(json: @repository)
    else
      render(json: @repository.errors, status: :unprocessable_entity)
    end
  end

  # DELETE /repositories/1
  def destroy
    @repository.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_repository
    @repository = Repository.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def repository_params
    params.permit(:user, :name, :description, :private)
  end

  def render_error_response(error)
    render(json: { message: error }, status: :unprocessable_entity)
  end
end
