ActionController::Base.class_eval do
  $dummy_ac_base_ancestors_in_initializers = ancestors
  $dummy_ac_base_helpers_in_initializers = _helpers.ancestors
end
