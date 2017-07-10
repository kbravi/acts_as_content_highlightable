require "spec_helper"

RSpec.describe ActsAsContentHighlightable do
  before(:all) do
    ActiveRecord::Migration.verbose = false
    ActiveRecord::Base.establish_connection(:adapter => "postgresql", :database => "acts_as_content_highlightable_test")

    def migration_version
      if ActiveRecord::VERSION::MAJOR >= 5
        "[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]"
      end
    end

    def migration_class_name
      "CreateContentHighlights"
    end

    migration_config = OpenStruct.new(migration_class_name: migration_class_name, migration_version: migration_version)
    migration_template = ERB.new(File.read(File.expand_path(File.dirname(__FILE__) + '/../lib/generators/acts_as_content_highlightable/templates/active_record_content_highlights_migration.rb'))).result(migration_config.instance_eval { binding })
    eval(migration_template)
    migration_class_name.constantize.new.change

    load(File.expand_path(File.dirname(__FILE__) + '/../lib/generators/acts_as_content_highlightable/templates/active_record_content_highlight_model.rb'))
    load(File.expand_path(File.dirname(__FILE__) + '/test_schema.rb'))
    load(File.expand_path(File.dirname(__FILE__) + '/test_models.rb'))
  end

  after(:all) do
    ActiveRecord::Base.connection.tables.each do |table|
      ActiveRecord::Base.connection.drop_table(table)
    end
    ActiveRecord::Base.remove_connection
  end

  it "has a version number" do
    expect(ActsAsContentHighlightable::VERSION).not_to be nil
  end

  context "when a model acts as content highlightable" do
    before(:each) do
      @post = Post.new(:summary => "Good morning! <em>hello there.<i>Great to meet you</i>How are you?</em>")
    end

    it "responds to highlightable_columns" do
      expect(@post.respond_to? :highlightable_columns).to eq(true)
      expect(@post.highlightable_columns).to eq(["summary"])
    end

    it "responds to content_highlights association" do
      expect(@post.respond_to? :content_highlights).to eq(true)
      expect(@post.content_highlights.count).to eq(0)
    end

    it "applies identifiers to every text node before save" do
      expect(@post.summary).to eq("Good morning! <em>hello there.<i>Great to meet you</i>How are you?</em>")
      @post.save
      expect(@post.summary).to_not eq("Good morning! <em>hello there.<i>Great to meet you</i>How are you?</em>")

      @node_identifier_key = ActsAsContentHighlightable.unique_html_node_identifier_key
      expect(@post.summary).to match(/^<p data-#{@node_identifier_key}=*/)
      expect(@post.summary).to match(/<\/p>$/)
      expect(@post.summary).to match(/<em data-#{@node_identifier_key}=*/)
      expect(@post.summary).to match(/<\/em>/)
      expect(@post.summary).to match(/<i data-#{@node_identifier_key}=*/)
      expect(@post.summary).to match(/<\/i>/)
    end
  end
end
