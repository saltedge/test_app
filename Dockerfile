FROM ruby:2.5.8

RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update

RUN apt install -y postgresql-client-15

ENV APP_HOME /app
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile $APP_HOME/Gemfile
COPY Gemfile.lock $APP_HOME/Gemfile.lock

ARG BUNDLE_PATH

RUN bundle install --without=production -j 4