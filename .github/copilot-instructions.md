# Project Guidelines

## Architecture
- This is a Rails 8.1 app using Hotwire, Stimulus, Tailwind, Propshaft, and import maps rather than a Node-based frontend bundler.
- Keep server-side work in standard Rails locations under `app/`; keep frontend behavior in Stimulus controllers under `app/javascript/controllers`.
- Production is Docker-first and Kamal-managed. Check `Dockerfile` and `config/deploy.yml` before changing runtime, deployment, ports, volumes, or environment variables.
- The app uses Solid Queue, Solid Cache, and Solid Cable. Production database wiring is multi-database SQLite; review `config/database.yml`, `config/queue.yml`, `config/cache.yml`, and `config/cable.yml` before changing persistence or background job behavior.

## Build And Test
- Initial setup: `docker compose run --rm app bin/setup` (installs gems, sets up DB, seeds)
- Local development: `docker compose up -d  `
- Run tests: `docker compose run --rm app rspec`
- Run the full local CI workflow before broad or cross-cutting changes: `docker compose run --rm app bin/ci`
- Lint and security checks are first-class in this repo. Use `docker compose run --rm app bin/rubocop`, `docker compose run --rm app bin/brakeman --quiet --no-pager --exit-on-warn --exit-on-error`, `docker compose run --rm app bin/bundler-audit`, and `docker compose run --rm app bin/importmap audit` when your change touches relevant areas.

## Conventions
- Prefer Rails generators and conventional structure over custom wiring.
- Follow the existing minimal Rails style. Avoid introducing new frameworks, service layers, or JavaScript build tooling unless the task requires it.
- When adding frontend interactivity, extend Stimulus controller patterns already used in `app/javascript/controllers/index.js` and `app/javascript/controllers/application.js`.
- When adding routes or UI entry points, check `config/routes.rb` and `app/views/layouts/application.html.erb`; the app currently has only a health route and no established feature modules yet.
- Tests use Minitest with fixtures and parallelization configured in `test/test_helper.rb`. Add or update Minitest coverage for behavior changes.
- Keep generated asset output out of source edits. Source Tailwind changes belong in `app/assets/tailwind/application.css`; compiled assets land in `app/assets/builds`.

## Pitfalls
- `bin/dev` installs `foreman` if needed and expects both the Rails server and Tailwind watcher from `Procfile.dev`.
- Local and container Ruby versions should stay aligned with `.ruby-version` and the `RUBY_VERSION` value in `Dockerfile`.
- Do not commit secrets or rely on missing credentials being present. Production and some deploy flows expect `config/master.key` or `RAILS_MASTER_KEY`, while encrypted credentials live in `config/credentials.yml.enc`.
- `config/initializers/content_security_policy.rb` is currently commented out. Be deliberate if a change depends on CSP behavior.

## Commit message prefixes:
- feat: for code adding a new feature
- fix: for syntax errors or logic fixes
- refactor: for changes that improve code layout and readability
- chore: for maintenance, config updates, or version bumps (e.g., gems)
