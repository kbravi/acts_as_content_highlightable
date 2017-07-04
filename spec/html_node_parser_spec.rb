require "spec_helper"

RSpec.describe ActsAsContentHighlightable::HtmlNodeParser do

  context "with empty input" do
    before(:example) do
      @html_node_parser = ActsAsContentHighlightable::HtmlNodeParser.new("")
    end

    it "returns empty string" do
      expect(@html_node_parser.body_content).to eq("")
    end
  end

  context "with any input" do
    before(:example) do
      text_input = "hello"
      html_input = "Good morning! <em>hello there.<i>Great to meet you</i>How are you?</em>"
      broken_html_input = "Good morning! <em>hello there.<i>Great to meet you. How are you?</em>"
      @html_node_parser1 = ActsAsContentHighlightable::HtmlNodeParser.new(text_input)
      @html_node_parser2 = ActsAsContentHighlightable::HtmlNodeParser.new(html_input)
      @html_node_parser3 = ActsAsContentHighlightable::HtmlNodeParser.new(broken_html_input)
    end

    it "sets parsed html" do
      expect(@html_node_parser1.parsed.class).to eq(Nokogiri::HTML::Document)
    end

    it "returns inner html on body_content" do
      expect(@html_node_parser1.respond_to? :body_content).to eq(true)
      expect(@html_node_parser1.body_content).to eq("<p>hello</p>")
      expect(@html_node_parser2.body_content).to eq("<p>Good morning! <em>hello there.<i>Great to meet you</i>How are you?</em></p>")
    end

    it "auto fixes missing html tags" do
      expect(@html_node_parser3.body_content).to eq("<p>Good morning! <em>hello there.<i>Great to meet you. How are you?</i></em></p>")
    end
  end

  context "with input string" do
    before(:example) do
      html_input = "Good morning! <em>hello there.<i>Great to meet you</i>How are you?</em>"
      @html_node_parser = ActsAsContentHighlightable::HtmlNodeParser.new(html_input)
      @node_identifier_key = ActsAsContentHighlightable.unique_html_node_identifier_key
      @html_node_parser.assign_unique_node_identifiers("data-#{@node_identifier_key}")
    end

    it "applies unique identifiers to every text node" do
      expect(@html_node_parser.body_content).to match(/^<p data-#{@node_identifier_key}=*/)
      expect(@html_node_parser.body_content).to match(/<\/p>$/)
      expect(@html_node_parser.body_content).to match(/<em data-#{@node_identifier_key}=*/)
      expect(@html_node_parser.body_content).to match(/<\/em>/)
      expect(@html_node_parser.body_content).to match(/<i data-#{@node_identifier_key}=*/)
      expect(@html_node_parser.body_content).to match(/<\/i>/)
    end
  end

  context "with input with assigned node_identifier_key" do
    before(:example) do
      html_input = "Good morning! <em>hello there.<i>Great to meet you</i>How are you?</em>"
      @html_node_parser = ActsAsContentHighlightable::HtmlNodeParser.new(html_input)
      @node_identifier_key = ActsAsContentHighlightable.unique_html_node_identifier_key
      @html_node_parser.assign_unique_node_identifiers("data-#{@node_identifier_key}")
    end
    it "should not change the node identifiers when applied again" do
      current_content = @html_node_parser.body_content
      @html_node_parser_new = ActsAsContentHighlightable::HtmlNodeParser.new(current_content)
      @html_node_parser_new.assign_unique_node_identifiers("data-#{@node_identifier_key}")
      expect(@html_node_parser_new.body_content).to eq(current_content)
    end
  end

end
