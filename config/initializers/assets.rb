# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

Rails.application.config.assets.precompile += %w( start_page.css )
Rails.application.config.assets.precompile += %w( start_page.js )
Rails.application.config.assets.precompile += %w( payments.js )

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

Rails.application.config.assets.configure do |env|
  env.context_class.class_eval do
    include ActionView::Helpers
    include ActionView::Context
    include Rails.application.routes.url_helpers
  end
end
