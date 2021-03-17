# frozen_string_literal: true
class SecurityService < BaseService
  def initialize(params, action)
    @repository_name = params[:repository]
    @action = action
  end

  def execute
    github_client.send("#{@action}_vulnerability_alerts", "#{github_client_user.name}/#{@repository_name}")

    update_attribute = { security: "#{@action}d" }
    repository = github_client_user.repositories.where(name: @repository_name).last
    if repository
      repository.update(update_attribute)
      repository
    else
      github_repository = github_client.repository("#{github_client_user.name}/#{@repository_name}")
      create_repository(github_repository, github_client_user, update_attribute)
    end
    update_attribute
  end
end
