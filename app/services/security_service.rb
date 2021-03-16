# frozen_string_literal: true
class SecurityService < BaseService
  def initialize(params, action)
    @repository_name = params[:repository]
    @action = action
  end

  def execute
    security_status = github_client.send("#{@action}_vulnerability_alerts" , "#{github_client_user.name}/#{@repository_name}")
    raise BaseService::GithubError, security_status unless security_status

    update_attribute = { security:  "#{@action}d"}
    repository = github_client_user.repositories.where(name: @repository_name).last
    if repository
      repository.update(update_attribute)
      repository
    else
      github_repository = github_client.repository("#{github_client_user.name}/#{@repository_name}")
      raise BaseService::GithubError, github_repository.message unless github_repository.id

      create_repository(github_repository, github_client_user, update_attribute)
    end
    update_attribute
  end
end
