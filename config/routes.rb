Rails.application.routes.draw do
  mount ActsAsContentHighlightable::Engine => "/" if ActsAsContentHighlightable.mount
end

ActsAsContentHighlightable::Engine.routes.draw do
  post 'content_highlights/add'
  post 'content_highlights/remove'
end
