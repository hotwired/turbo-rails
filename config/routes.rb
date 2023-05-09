# FIXME: Offer flag to opt out of these native routes
Rails.application.routes.draw do
  get "recede_historical_location"  => "turbo/native/navigation#recede",  as: :turbo_recede_historical_location
  get "resume_historical_location"  => "turbo/native/navigation#resume",  as: :turbo_resume_historical_location
  get "refresh_historical_location" => "turbo/native/navigation#refresh", as: :turbo_refresh_historical_location
end if Turbo.draw_routes
