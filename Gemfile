source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.1'

gem 'pg', '~> 0.18'

gem 'puma', '3.8.2'
# https://github.com/puma/puma/issues/1308

gem 'httparty'
gem 'bulk_insert'
gem 'aws-sdk', '~> 2'
gem "actionmailer_inline_css", git: 'https://github.com/premailer/actionmailer_inline_css.git', branch: 'master'
gem 'enumerize'

gem 'active_model_serializers', '~> 0.10.0'
gem 'rack-cors'

gem 'resque' #, "~> 1.22.0"
gem 'resque-scheduler'

gem 'base62-rb'

gem "sentry-raven"

gem 'exception_notification'
gem 'slack-notifier'

gem "mechanize"

gem 'paypal-sdk-rest'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.5'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-rails-console', require: false
  # gem "capistrano-resque"
  gem 'capistrano3-puma'
  gem 'capistrano3-nginx'
end

group :test do
  gem 'factory_girl_rails', '~> 4.0'
  gem 'shoulda-matchers', git: 'https://github.com/thoughtbot/shoulda-matchers.git', branch: 'rails-5'
  gem 'faker'
  gem 'database_cleaner'
end
