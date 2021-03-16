# frozen_string_literal: true
class CreateRepositories < ActiveRecord::Migration[6.1]
  def change
    create_table(:repositories, id: :uuid) do |t|
      t.string(:name, null: false, index: true)
      t.string(:github_id, null: false, index: { unique: true })
      t.string(:node_id, null: false)
      t.string(:full_name)
      t.boolean(:private)
      t.string(:description)
      t.string(:security)
      t.datetime(:github_created_at)
      t.datetime(:github_updated_at)
      t.string(:topics, array: true, default: [])
      t.references(:user, type: :uuid)

      t.timestamps
    end
  end
end
