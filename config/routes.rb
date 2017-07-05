Rails.application.routes.draw do
  mount ActsAsContentHighlightable::Engine => "/" if ActsAsContentHighlightable.mount
end

ActsAsContentHighlightable::Engine.routes.draw do
  scope module: "acts_as_content_highlightable" do
    post 'content_highlights/add'
    post 'content_highlights/remove'
  end
end
