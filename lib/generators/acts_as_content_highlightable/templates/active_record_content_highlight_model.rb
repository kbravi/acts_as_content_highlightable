class ContentHighlight < ActiveRecord::Base
  belongs_to :highlightable, :polymorphic => true
  belongs_to :user

  validates_presence_of :user_id, :highlightable_id, :highlightable_type, :highlightable_column, :content
  validates_presence_of :container_node_identifier, :container_node_identifier_key, :container_node_type, :startnode_offset, :endnode_offset
  validates_inclusion_of :selection_backward, :in => [true, false]

  validates_uniqueness_of :container_node_identifier, :scope => [:container_node_type, :startnode_offset, :endnode_offset, :highlightable, :user_id]

  # This method shall be used to choose the highlights the user can see
  def self.highlights_to_show(highlightable, user, options={})
    # request = options[:request]
    highlightable.content_highlights
  end

  # This method is used to show details on the poptips with permissions to remove highlights
  def self.enrich_highlights(user)
    ContentHighlight.joins(:user).select("content_highlights.id as identifier, CONCAT('Highlight by ', users.id) as description, ARRAY[CASE user_id WHEN #{user.id} THEN 'me' ELSE 'others' END] as life_time_class_ends, CASE user_id WHEN #{user.id} THEN true ELSE false END as can_cancel, content, selection_backward as backward, startnode_offset as start_offset, endnode_offset as end_offset, container_node_identifier as common_ancestor_identifier, container_node_type as common_ancestor_node_type")
  end
end
