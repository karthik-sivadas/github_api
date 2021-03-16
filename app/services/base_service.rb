# frozen_string_literal: true
class BaseService
  class GithubError < StandardError; end

  private

  def github_client
    @github_client ||= Octokit::Client.new(netrc: true)
  end

  def github_client_user
    github_client_user_name = github_client.user.login
    @github_client_user ||= User.where(name: github_client_user_name).last
  end

  def fetch_user(user_name)
    user = User.where(name: user_name).last
    return user if user

    user_details = github_client.user(user_name)
    return user_details unless user_details.id

    create_user(user_details)
  end

  def create_user(user_details)
    User.create(name: user_details.login,
                github_id: user_details.id,
                email: user_details.email,
                user_type: user_details.type,
                public_repos: user_details.public_repos,
                total_private_repos: user_details.total_private_repos)
  end

  def create_repository(repository, github_user)
    respository_topics = github_client.topics(repository.full_name)[:names]
    Repository.create(github_id: repository.id,
                      node_id: repository.node_id,
                      name: repository.name,
                      full_name: repository.full_name,
                      private: repository.private,
                      user: github_user,
                      github_created_at: repository.created_at,
                      github_updated_at: repository.updated_at,
                      topics: respository_topics)
  end
end
