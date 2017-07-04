module ActsAsContentHighlightable
  module Model
    def acts_as_content_highlightable_on(column_name)
      if not self.column_names.include? column_name.to_s
        raise ArgumentError, "acts_as_content_highlightable_on: Invalid attribute #{column_name}"
      end

      class_eval do
        has_many :content_highlights, :as => :highlightable
      end

      class_eval %{
        before_save :name_html_nodes, :if => :#{column_name.to_s}_changed?
        def highlightable_column
          return "#{column_name.to_s}"
        end
        def name_html_nodes
          self.#{column_name.to_s} = ActsAsContentHighlightable::HtmlNodeParser.new(self.#{column_name.to_s}).assign_unique_node_identifiers("data-" + ActsAsContentHighlightable.unique_html_node_identifier_key).body_content
        end
      }
    end
  end
end
