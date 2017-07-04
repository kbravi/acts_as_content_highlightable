class <%= migration_class_name %> < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :content_highlights do |t|
      t.integer :user_id
      t.text :highlightable_type
      t.integer :highlightable_id
      t.text :highlightable_column
      t.text :content
      t.text :container_node_identifier_key
      t.text :container_node_identifier
      t.text :container_node_type
      t.integer :startnode_offset
      t.integer :endnode_offset
      t.boolean :selection_backward
      t.timestamps
    end

    add_index :content_highlights, :user_id
    add_index :content_highlights, :highlightable_id
    add_index :content_highlights, :highlightable_type
    add_index :content_highlights, :highlightable_column
  end
end
