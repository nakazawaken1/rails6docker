# how to create rails6 environment

## require files

	rails6/
		.dcokerignore
		docker-compose.yml
		Dockerfile
		Gemfile

### .dockerignore

	.git
	.rspec
	log
	tmp
	vender/assets
	node_modules

### docker-compose.yml

	version: '3'
	services:
	db:
		image: postgres
		volumes:
			- ./tmp/db:/var/lib/postgresql/data
	web:
		build: .
		volumes:
			- .:/opt/myapp
		ports:
			- "3333:3000"
		depends_on:
			- db

### Dockerfile

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

### Gemfile

	source 'https://rubygems.org'
	gem 'rails', '~>6'


## operations

### create folder

	mkdir rails6

### make 4 files

	cd rails6
	vi .dockerignore
	vi docker-compose.yml
	vi Dockerfile
	vi Gemfile

### create rails project

	docker-compose run web rails new . --force --no-deps --database=postgresql

### configure database

add 3 lines to config/database.yml default: section

	default: &default
		host: db
		username: postgres
		password:

### build docker images

	docker-compose build

### create database

	docker-compose run web rake db:create

### start docker

	docker-compose up

### view in browser

	http://localhost:3333

### exit containers

	CTRL+C