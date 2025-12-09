FROM ruby:latest

RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

RUN bundle install

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]

