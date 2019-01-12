FROM ruby:2.5

RUN apt-get update && apt-get install -y \
  build-essential \
  libmad0-dev \
  sox \
  libsox-fmt-mp3 \
  ffmpeg \
  imagemagick libmagickcore-dev libmagickwand-dev

WORKDIR /app
ADD Gemfile* /app/
RUN bundle install

COPY . /app

CMD ["bundle", "exec", "./bot.rb"]
