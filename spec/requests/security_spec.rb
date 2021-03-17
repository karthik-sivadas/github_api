# frozen_string_literal: true
require 'rails_helper'

RSpec.describe("Securities", type: :request) do
  describe "POST /create" do
    context "with valid parameters" do
      let(:valid_create_attributes) do
        {
          repository: "github_api_test_app_1",
        }
      end

      it "enable security alert" do
        VCR.use_cassette("create_security_success_reponse") do
          post('/security', params: valid_create_attributes)
          repository = Repository.where(name: valid_create_attributes[:repository])

          expect(response).to(have_http_status(200))
          expect(repository.count).to(equal(1))
          expect(repository.last.security).to(match("enabled"))
        end
      end
    end

    context "with invalid parameters" do
      let(:invalid_create_attributes) do
        {
          repository: "github_api_test_ap",
        }
      end

      it "does not enable security alert" do
        VCR.use_cassette("create_security_failure_reponse") do
          post('/security', params: invalid_create_attributes)

          expect(JSON.parse(response.body)["message"]).to(include("Not Found"))
          expect(response).to(have_http_status(422))
          expect(Repository.where(name: invalid_create_attributes[:name]).count).to(equal(0))
        end
      end
    end
  end

  describe "DELETE /destroy" do
    it "disables security alert" do
      VCR.use_cassette("delete_security_reponse") do
        user = create(:user, name: "karthik-sivadas")
        create(:repository, name: "github_api_test_app_1", user: user)
        delete(security_url("github_api_test_app_1"))
        expect(Repository.last.security).to(match("disabled"))
      end
    end
  end
end
