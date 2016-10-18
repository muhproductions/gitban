FROM ruby:2.3

RUN apt update && apt install -y build-essential libsqlite3-dev libcurl4-openssl-dev
ENV APP_DIR /srv/gitban
ENV SECRET_KEY_BASE dummy
RUN mkdir $APP_DIR
WORKDIR $APP_DIR
ADD Gemfile* $APP_DIR/
RUN bundle install --jobs 8
ADD . $APP_HOME
RUN RAILS_ENV=production bundle exec rails assets:precompile

COPY rails_init.sh /usr/local/bin/
RUN ln -s usr/local/bin/rails_init.sh /
RUN mkdir -p /var/lib/gitban/db
ENTRYPOINT "rails_init.sh"
