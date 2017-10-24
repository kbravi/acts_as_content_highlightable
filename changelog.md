# v 0.2.1
(Oct 24, 2017)

* Fixes bugs, and supports IE.

# v 0.2.0
(July, 10, 2017)

* Supports multiple content_highlightable columns per model
  ```
  acts_as_content_highlightable_on [:summary, :content]
  ```
* Added ActsAsContentHighlightabl.extract_text_from_html(text) method
  - can be used to extract text from HTML content.
* Extract `can_remove_highlight?(user)` method from controller to ContentHighlight model
  - Can customize removal permissions - better than just checking (highlight.user == current_user)
