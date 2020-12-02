# FIXME: Offer flag to opt out of these native routes
# FIXME: Consider prefixing these URLs with "turbo/"
Rails.application.routes.draw do
  get "recede_historical_location"  => "turbo/links/native_navigation#recede",  as: :turbo_recede_historical_location
  get "resume_historical_location"  => "turbo/links/native_navigation#resume",  as: :turbo_resume_historical_location
  get "refresh_historical_location" => "turbo/links/native_navigation#refresh", as: :turbo_refresh_historical_location
end
