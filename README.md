# ActsAsContentHighlightable

Highlight Html Text content (inspired by Medium's highlight feature)
* jQuery free
* Associate highlights to the user
* Show highlights based on what users can see
* Read-only mode

# Sample
![How it works](http://i.imgur.com/xHBCBht.gif)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'acts_as_content_highlightable'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install acts_as_content_highlightable
```

## Usage

#### 1. Install
This will copy the model and migration files for ContentHighlight model

```
rails generate acts_as_content_highlightable:install
```

#### 2. Migrate
Migrate your database to create the content_highlights table

```
bundle exec rake db:migrate
```

#### 3. Set your model as content_highlightable
Add `acts_as_content_highlightable_on` to the model and choose the column that has the HTML content that you want to highlight.

```
Class Post < ApplicationRecord
  validates :summary, :presence => true
  acts_as_content_highlightable_on :summary
  # summary is a column on Post model that stores HTML text content
end
```

#### 4. Add javascript files and stylesheets to your application
Add this to your application.js file
```
//= require content_highlight
```
and this to your application.css file
```
*= require content_highlight
```

#### 5. Retroactively tag text nodes
This gem creates a `before_save` callback to tag every html node in the content (e.g. `:summary`) with a data attribute `data-chnode="<unique_random_hex>"`. This is essential to save, persist and display highlights. To retroactively tag the nodes, use some variant of the following code
```
Post.all.each{|post| post.prepare_for_content_highlights && post.save}
```
Please note that the data in your content column will be altered by this gem - it adds data attributes to text nodes of the html content. If your content is plain text, it will be converted into html text. See examples below
```
<!--Example 1 (plain text) -->
Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts. Separated they live in Bookmarksgrove right at the coast of the Semantics, a large language ocean. A small river named Duden flows by their place and supplies it with the necessary regelialia. It is a paradisematic country, in which roasted parts of sentences fly into your mouth.

<!--Example 2 (html text) -->
<p>Far far away, behind the word mountains, far from the countries <em>Vokalia and Consonantia</em>, there live the blind texts. Separated they live in Bookmarksgrove right at the coast of the Semantics, a large language ocean.</p>
<p>A small river named Duden flows by their place and supplies <b>it with the necessary <i>regelialia</i>. It is a paradisematic country, in which roasted parts of sentences fly into your mouth.</p>

<!--Example 3 (already tagged html text) -->
<p data-chnode="aba2519">Far far away, behind the word mountains, far from the countries <em data-chnode="c13d177">Vokalia and Consonantia</em>, there live the blind texts. Separated they live in Bookmarksgrove right at the coast of the Semantics, a large language ocean.</p>
<p data-chnode="98dbae1">A small river named Duden flows by their place and supplies <b data-chnode="d1a2419">it with the necessary <i data-chnode="123ddb3">regelialia</i>. It is a paradisematic country, in which roasted parts of sentences fly into your mouth.</p>
```
becomes
```
<!--Example 1 (plain text - wrapped in <p> tag and added node identifier) -->
<p data-chnode="d1a2419">Far far away, behind the word mountains, far from the countries Vokalia and Consonantia, there live the blind texts. Separated they live in Bookmarksgrove right at the coast of the Semantics, a large language ocean. A small river named Duden flows by their place and supplies it with the necessary regelialia. It is a paradisematic country, in which roasted parts of sentences fly into your mouth.</p>

<!--Example 2 (html text - added node identifiers) -->
<p data-chnode="aba2519">Far far away, behind the word mountains, far from the countries <em data-chnode="c13d177">Vokalia and Consonantia</em>, there live the blind texts. Separated they live in Bookmarksgrove right at the coast of the Semantics, a large language ocean.</p>
<p data-chnode="98dbae1">A small river named Duden flows by their place and supplies <b data-chnode="d1a2419">it with the necessary <i data-chnode="123ddb3">regelialia</i>. It is a paradisematic country, in which roasted parts of sentences fly into your mouth.</p>

<!--Example 3 (already tagged html text - node identifiers preserved)-->
<p data-chnode="aba2519">Far far away, behind the word mountains, far from the countries <em data-chnode="c13d177">Vokalia and Consonantia</em>, there live the blind texts. Separated they live in Bookmarksgrove right at the coast of the Semantics, a large language ocean.</p>
<p data-chnode="98dbae1">A small river named Duden flows by their place and supplies <b data-chnode="d1a2419">it with the necessary <i data-chnode="123ddb3">regelialia</i>. It is a paradisematic country, in which roasted parts of sentences fly into your mouth.</p>
```

#### 6. Invoke the Content Highlighter in your view
Here is a sample posts/show view
```
<div id="post_summary">
  <%= @post.summary.html_safe%>
</div>

<script type="text/javascript">
  setTimeout(function(){
    var worker = new contentHighlightWorker(document.getElementById('post_summary'), {
      nodeIdentifierKey: "<%=ActsAsContentHighlightable.unique_html_node_identifier_key%>",
      highlightableType: "Post",
      highlightableId: "1",
      readOnly: false
    });
    worker.init();
  }, 10);
</script>

```

## Advanced
Here are some of many customizations that are possible:
#### 1. Show selective highlights
Use the `ContentHighlight#highlights_to_show` method to selectively show certain highlights based on current_user, cookies, request, etc.

#### 2. Enrich Highlights
`ContentHighlight#enrich_highlights` lets us modify the `description`, set permissions to remove `can_cancel`, and change css classes to distinguish the user's vs others' highlights `lifetime_class_ends`

#### 3. Custom Styling
Check out [content_highlight.css](./vendor/assets/stylesheets/content_highlight.css)

#### 4. More Javascript options
`highlightableType` and `highlightableId` are required. Highlights can be set `readOnly` - no addition or removal. You may never need more but check out the [content_highlight.js](./vendor/assets/javascripts/content_highlight.js) file for more configuration options.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

## Dependency

* [Nokogiri](https://github.com/sparklemotion/nokogiri) for HTML parsing
* Text selection is supported by [Rangy](https://www.github.com/timdown/rangy)
* [Rangy's Core module](https://github.com/timdown/rangy/blob/master/src/core/core.js)
* [Rangy's Class Applier Module](https://github.com/timdown/rangy/blob/master/src/modules/rangy-classapplier.js)


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kbravi/acts_as_content_highlightable. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

