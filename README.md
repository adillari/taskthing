# Taskthing

Taskthing is an open-source kanban web application aiming for the following qualities:
- self-hostable
- performant
- readable and clean code
- light on gems/javascript dependencies
- a majestic monolith that would make DHH proud(https://signalvnoise.com/svn3/the-majestic-monolith/)

### Technical information

#### Ruby version:
- see .ruby-version
#### System dependencies
- Postgres 17
- Redis

#### To run in development:

`bundle install`

`rails db:migrate`

`bin/dev`

#### To run in production:

Currently this project is meant to run entirely on one box.
That may change if the project actually gets more than 10 users.

Ensure Postgres(default unix socket) and Redis(default network port) are running
Ensure `RAILS_MASTER_KEY` environment variable is configured

`bundle install`

`rails db:migrate`

`rails assets:clobber`

`rails assets:precompile`

`rails s -b localhost`

Use a reverse proxy of your choosing to expose port 443/80 and route the traffic to port 3000
