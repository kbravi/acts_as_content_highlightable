module ActsAsContentHighlightable
  module Model
    def acts_as_content_highlightable_on(column_names)
      column_names = [column_names].flatten
      if not column_names.all? {|column_name| self.column_names.include? column_name.to_s}
        raise ArgumentError, "acts_as_content_highlightable_on: One or more invalid attribute #{column_names}"
      end

      class_eval do
        has_many :content_highlights, :as => :highlightable
        before_save :prepare_for_content_highlights, :if => column_names.map{|column_name| "#{column_name}_changed?"}
      end

      class_eval %{
        def highlightable_columns
          return #{column_names.map(&:to_s)}
        end
        def prepare_for_content_highlights
          #{column_names}.each do |column_name|
            self[column_name.to_sym] = ActsAsContentHighlightable::HtmlNodeParser.new(self[column_name.to_sym]).assign_unique_node_identifiers("data-" + ActsAsContentHighlightable.unique_html_node_identifier_key).body_content
          end
        end
      }
    end
  end
end
