# frozen_string_literal: true
class ListRepositoriesService < BaseService
  def initialize(params)
    @github_user = fetch_user(params[:user])
  end

  def execute
    repositories = github_client.repositories(@github_user.name)
    validate_and_create_repositories(repositories)
    @github_user.repositories
  end

  private

  def validate_and_create_repositories(repositories)
    # move the create repository to a asynchronous job
    user_repositories_id = @github_user.repositories.pluck(:github_id)

    repositories.each do |repository|
      next if user_repositories_id.include?(repository.id.to_s)

      create_repository(repository, @github_user)
    end
  end
end
