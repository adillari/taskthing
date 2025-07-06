# Taskthing

Taskthing is an open source kanban web application aiming for the following qualities:

- readable/clean code
- self-hostable(easily!)
- performant
- light on gems/javascript dependencies beyond standard Rails/Hotwire
- a majestic monolith that would make DHH proud(<https://signalvnoise.com/svn3/the-majestic-monolith/>)

## License

This project is licensed under the GNU Affero General Public License v3.0

Please understand [what that means](https://choosealicense.com/licenses/agpl-3.0/) if you intend to run your own instance.

### System dependencies

- ruby(see '.ruby-version' for version)
- sqlite3

#### To run in development

`bundle install`

`rails db:migrate`

`bin/dev` to start server process
`bin/jobs` to start jobs process

#### To run in production

Currently this project is meant to run entirely on one box.
That may change if the project actually gets more than 10 users.

Ensure `RAILS_MASTER_KEY` environment variable is configured

Ensure `RAILS_ENV` environment variable is configured to "production"

`bundle install`

`rails db:migrate`

`rails assets:clobber`

`rails assets:precompile`

`rails s -b localhost` to start server process
`bin/jobs` to start jobs process

Use a reverse proxy of your choosing to expose port 443/80 and route the traffic to port 3000

---

Taskthing - Open Source Kanban

Copyright (C) 2024-2025 Adil Lari
