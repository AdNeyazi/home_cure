# frozen_string_literal: true

# Propshaft serves /assets/* only when the URL fingerprint matches the file digest.
# Browsers resolve CSS `@import "styles/foo.css"` relative to the parent stylesheet URL
# but without a digest (e.g. GET /assets/styles/foo.css). Those requests used to fail
# the digest check, so every imported sheet 404'd and almost no rules applied.
#
# Allow undigested URLs when no digest segment is present; invalid digests still 404.
module PropshaftServeUndigestedPaths
  def fresh?(digest)
    digest.nil? ? true : super
  end
end

Rails.application.config.to_prepare do
  next unless defined?(Propshaft::Asset)

  unless Propshaft::Asset.ancestors.include?(PropshaftServeUndigestedPaths)
    Propshaft::Asset.prepend(PropshaftServeUndigestedPaths)
  end
end
