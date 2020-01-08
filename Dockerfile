FROM ruby:2.7
ENV LANG=C.UTF-8 \
    TZ='Asia/Tokyo' \
    APP_DIR=/opt/myapp
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update -qq && apt-get install -y --no-install-recommends nodejs postgresql-client yarn
WORKDIR $APP_DIR
COPY Gemfile* $APP_DIR/
RUN bundle install
COPY . $APP_DIR
CMD set -e && rm -f tmp/pids/server.pid && rails server -b 0.0.0.0
