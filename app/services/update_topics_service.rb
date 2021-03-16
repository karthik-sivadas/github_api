# frozen_string_literal: true
class UpdateTopicsService < BaseService
  def initialize(params)
    @repository_name = params[:repository]
    @topics = params[:topics]
  end

  def execute
    repository_topics = github_client.replace_all_topics("#{github_client_user.name}/#{@repository_name}", @topics)
    raise BaseService::GithubError, repository_topics.message unless repository_topics.names

    repository = github_client_user.repositories.where(name: @repository_name).last
    if repository
      repository.update(topics: repository_topics.names)
      repository
    else
      github_repository = github_client.repository("#{github_client_user.name}/#{@repository_name}")
      raise BaseService::GithubError, github_repository.message unless github_repository.id

      create_repository(github_repository, github_client_user)
    end
  end
end
