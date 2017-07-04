module ActsAsContentHighlightable
  class ContentHighlightsController < ApplicationController
    before_action :set_highlighter_user
    before_action :get_and_require_highlightable, :only => [:add]

    def add
      content_highlight = @highlightable.content_highlights.new({
        :user => @highlighter_user,
        :highlightable_column => @highlightable.highlightable_column,
        :content => params[:content],
        :container_node_identifier_key => params[:common_ancestor_identifier_key],
        :container_node_identifier => params[:common_ancestor_identifier],
        :container_node_type => params[:common_ancestor_node_type],
        :startnode_offset => params[:start_offset],
        :endnode_offset => params[:end_offset],
        :selection_backward => params[:backward]
      })
      content_highlight.save
      show_highlights = ContentHighlight.highlights_to_show(@highlightable, @highlighter_user, {request: request}).enrich_highlights(@highlighter_user)
      render :json => show_highlights.as_json
    end

    def remove
      content_highlight = @highlightable.content_highlights.where(:id => params[:content_highlight_id]).first
      if content_highlight.present? and (content_highlight.user == @highlighter_user)
        remove_highlights = @highlightable.content_highlights.where(:id => content_highlight.id).enrich_highlights(@highlighter_user).as_json
        content_highlight.destroy
      else
        remove_highlights = Array.new
      end
      render :json => remove_highlights
    end

    private
    def get_and_require_highlightable
      highlightable_model = params[:highlightable_type].to_s.constantize
      @highlightable = highlightable_model.respond_to?(:find_by_id) && highlightable_model.respond_to?(:highlightable_column) && highlightable_model.find_by_id(params[:highlightable_id])
      return false if @highlightable.blank?
    end

    def set_highlighter_user
      @highlighter_user ||= (self.respond_to?(:current_user) && self.current_user) || (self.respond_to?(:current_resource_owner, true) && self.send(:current_resource_owner)) || nil
    end
  end
end
