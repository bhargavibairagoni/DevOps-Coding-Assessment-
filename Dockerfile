FROM ruby:3.1.2
# Install required dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  yarn \
  && rm -rf /var/lib/apt/lists/*
# Set working directory
WORKDIR /app
# Ensure correct bundler version is used
ENV BUNDLER_VERSION=2.3.6
# Install specific Bundler version
RUN gem install bundler -v $BUNDLER_VERSION
# Copy Gemfile and lockfile first (to leverage Docker cache)
COPY Gemfile Gemfile.lock ./
# Install dependencies
RUN bundle _${BUNDLER_VERSION}_ install
# Copy rest of app
COPY . .
# Precompile assets (optional for dev, recommended for prod)
# RUN bundle exec rake assets:precompile
# Expose port
EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]

