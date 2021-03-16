# frozen_string_literal: true
class CreateGithubRepositoryService < BaseService
  def initialize(params)
    @repository_name = params[:name]
    @private = params[:private]
    @repository_description = params[:description]
  end

  def execute
    create_repository_on_github
  end

  private

  def create_repository_on_github
    repository = github_client.create_repository(@repository_name, private: @private,
                                                 description: @repository_description)
    raise BaseService::GithubError, repository.message unless repository.id

    create_repository(repository, github_client_user)
  end
end
