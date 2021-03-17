# frozen_string_literal: true
require 'rails_helper'

RSpec.describe(Repository, type: :model) do
  let!(:repository) { create(:repository) }

  context 'validations' do
    it { is_expected.to(validate_presence_of(:name)) }
    it { is_expected.to(validate_presence_of(:github_id)) }
    it { is_expected.to(validate_presence_of(:node_id)) }
  end

  context 'associations' do
    it { is_expected.to(belong_to(:user)) }
  end
end
