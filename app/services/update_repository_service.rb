# frozen_string_literal: true
class UpdateRepositoryService < BaseService
  def initialize(params)
    @params = params
    @original_name = params[:name]
  end

  def execute
    github_repository = github_client.edit_repository("#{github_client_user.name}/#{@original_name}", update_attribute)
    raise BaseService::GithubError, github_repository.errors.first.message unless github_repository.id

    p github_repository.description
    update_or_create_repository(github_repository)
  end

  private

  def update_or_create_repository(github_repository)
    repository = github_client_user.repositories.where(name: @original_name).last
    if repository
      repository.update(update_attribute)
      repository
    else
      repository = create_repository(github_repository, github_client_user)
    end
  end

  def update_attribute
    { name: @params[:new_name],
      description: @params[:description] }.compact
  end
end
