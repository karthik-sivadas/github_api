# frozen_string_literal: true
require 'rails_helper'

RSpec.describe(User, type: :model) do
  let!(:user) { create(:user) }

  context 'validations' do
    it { is_expected.to(validate_presence_of(:name)) }
    it { is_expected.to(validate_presence_of(:github_id)) }
  end

  context 'associations' do
    it { is_expected.to(have_many(:repositories)) }
  end
end
