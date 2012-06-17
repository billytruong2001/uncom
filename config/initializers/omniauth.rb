Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['308862845872909'], ENV['764964a8e1ec0a7e871635e5342f7bd9'] #nguoiban@unitedviets.com
  provider :twitter, ENV['xIOSZxQiZ8fKgqvsf8KEvA'], ENV['yyvfA6IhoqTrZBHowNqoWKk10FlSzx4FJp6j49azLJo']
end