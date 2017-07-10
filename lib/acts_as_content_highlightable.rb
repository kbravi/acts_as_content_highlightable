require "active_record"
require "active_support/core_ext"
require "acts_as_content_highlightable/version"
require "acts_as_content_highlightable/html_node_parser"
require "acts_as_content_highlightable/model"
require "acts_as_content_highlightable/engine"

module ActsAsContentHighlightable

  mattr_accessor :unique_html_node_identifier_key
  self.unique_html_node_identifier_key = "chnode"

  mattr_accessor :mount
  self.mount = true

  def self.extract_text_from_html(text)
    return nil unless text.is_a? String
    return ActsAsContentHighlightable::HtmlNodeParser.new(text).body_text
  end

  ActiveSupport.on_load(:active_record) do
    extend ActsAsContentHighlightable::Model
  end
end
