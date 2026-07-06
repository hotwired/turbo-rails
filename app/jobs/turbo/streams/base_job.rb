class Turbo::Streams::BaseJob < ActiveJob::Base
  discard_on ActiveJob::DeserializationError
end
