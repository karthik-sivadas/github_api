# frozen_string_literal: true
class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table(:users, id: :uuid) do |t|
      t.string(:name, null: false, index: { unique: true })
      t.string(:github_id, null: false, index: { unique: true })
      t.string(:email)
      t.string(:type)
      t.integer(:public_repos)
      t.integer(:total_private_repos)

      t.timestamps
    end
  end
end
