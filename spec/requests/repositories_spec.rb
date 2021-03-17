# frozen_string_literal: true
require 'rails_helper'

RSpec.describe("/repositories", type: :request) do
  let(:valid_create_attributes) do
    {
      description: "Github API rails app",
      private: true,
      name: "github_api_test_app",
    }
  end

  let(:invalid_create_attributes) do
    {
      description: "Github API rails app",
      private: true,
      nam: "github_api_test_app",
    }
  end

  describe "GET /index" do
    it "renders a successful response" do
      VCR.use_cassette("list_repositories_success_reponse") do
        get '/repositories?user=karthik-sivadas', as: :json

        expect(response).to(be_successful)
      end
    end

    it "renders a failure response" do
      VCR.use_cassette("list_repositories_failure_reponse") do
        get '/repositories?user=karthik-sivada', as: :json

        expect(response).to(have_http_status(422))
        expect(JSON.parse(response.body)["message"]).to(include("Not Found"))
      end
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Repository" do
        VCR.use_cassette("create_repositories_success_reponse") do
          post(repositories_url, params: valid_create_attributes)
          repository = Repository.where(name: valid_create_attributes[:name])

          expect(response).to(have_http_status(:created))
          expect(repository.count).to(equal(1))
          expect(repository.last.description).to(match("Github API rails app"))
        end
      end
    end

    context "with invalid parameters" do
      it "does not create a new Repository" do
        VCR.use_cassette("create_repositories_failure_reponse") do
          post(repositories_url, params: invalid_create_attributes)

          expect(JSON.parse(response.body)["message"]).to(include("Repository creation failed."))
          expect(response).to(have_http_status(422))
          expect(Repository.where(name: valid_create_attributes[:name]).count).to(equal(0))
        end
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:valid_update_attributes) do
        {
          description: "This is an updated description",
          new_name: "github_api_test_app_1",
        }
      end

      it "updates the requested repository" do
        VCR.use_cassette("update_repositories_success_reponse") do
          patch repository_url("github_api_test_app"), params: valid_update_attributes
          repository = Repository.where(name: valid_update_attributes[:new_name])

          expect(response).to(have_http_status(:ok))
          expect(repository.last.name).to(match("github_api_test_app_1"))
          expect(repository.last.description).to(match("This is an updated description"))
        end
      end
    end

    context "with invalid parameters" do
      let(:invalid_update_attributes) do
        {
          description: "This is an updated description",
          new_name: " github_api_test_app_1",
        }
      end

      it "renders a JSON response with errors for the repository" do
        VCR.use_cassette("update_repositories_failure_reponse") do
          patch repository_url(" github_api_test_app"), params: invalid_update_attributes
          repository = Repository.where(name: invalid_update_attributes[:new_name])

          expect(JSON.parse(response.body)["message"]).to(include("\"karthik-sivadas/ github_api_test_app\" is invalid as a repository identifier. Use the user/repo (String) format, or the repository ID (Integer), or a hash containing :repo and :user keys."))
          expect(response).to(have_http_status(422))
          expect(repository.count).to(equal(0))
        end
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested repository" do
      VCR.use_cassette("delete_repositories_reponse") do
        user = create(:user, name: "karthik-sivadas")
        create(:repository, name: "github_api_test_app_1", user: user)
        delete(repository_url("github_api_test_app_1"))
        expect(Repository.count).to(equal(0))
      end
    end
  end
end
