# frozen_string_literal: true
require 'rails_helper'

RSpec.describe("Topics", type: :request) do
  describe "PATCH /update" do
    context "with valid parameters" do
      let(:valid_update_attributes) do
        {
          topics: ["rails", "api"],
        }
      end

      it "updates the requested topic" do
        VCR.use_cassette("update_topics_success_reponse") do
          patch topic_url("github_api_test_app_1"), params: valid_update_attributes

          expect(response).to(have_http_status(:ok))
          expect(Repository.last.topics).to(match(["rails", "api"]))
        end
      end
    end

    context "with invalid parameters" do
      let(:invalid_update_attributes) do
        {
          name: " github_api_test_ap",
        }
      end

      it "renders a JSON response with errors for the topic" do
        VCR.use_cassette("update_topics_failure_reponse") do
          patch topic_url(" github_api_test_app"), params: invalid_update_attributes
          repository = Repository.where(name: invalid_update_attributes[:new_name])

          expect(JSON.parse(response.body)["message"]).to(include("\"karthik-sivadas/ github_api_test_app\" is invalid as a repository identifier. Use the user/repo (String) format, or the repository ID (Integer), or a hash containing :repo and :user keys."))
          expect(response).to(have_http_status(422))
          expect(repository.count).to(equal(0))
        end
      end
    end
  end
end
