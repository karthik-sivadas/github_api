# frozen_string_literal: true
class DeleteRepositoryService < BaseService
  def initialize(params)
    @name = params[:name]
  end

  def execute
    deletion_status = github_client.delete_repository("#{github_client_user.name}/#{@name}")
    repository = github_client_user.repositories.where(name: @name).last
    repository.destory if deletion_status && repository
    { deleted: deletion_status }
  end
end
