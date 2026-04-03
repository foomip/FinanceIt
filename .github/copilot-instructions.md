# Project Guidelines

## Architecture
- This is a Rails 8.1 app using Hotwire, Stimulus, Tailwind, Propshaft, and import maps rather than a Node-based frontend bundler.
- Keep server-side work in standard Rails locations under `app/`; keep frontend behavior in Stimulus controllers under `app/javascript/controllers`.
- Production is Docker-first and Kamal-managed. Check `Dockerfile` and `config/deploy.yml` before changing runtime, deployment, ports, volumes, or environment variables.
- The app uses Solid Queue, Solid Cache, and Solid Cable. Production database wiring is multi-database SQLite; review `config/database.yml`, `config/queue.yml`, `config/cache.yml`, and `config/cable.yml` before changing persistence or background job behavior.
- This app uses rspec for all tests.
- This app uses LightService for organizing complex business logic.
- Pundit is used for authorization.

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
- bug: for code that fixes a bug or unintended behavior
- refactor: for changes that improve code layout and readability
- chore: for maintenance, config updates, or version bumps (e.g., gems)
- doc: for documentation updates, including comments and README changes

## LightService for business logic
- Use LightService organizers for complex operations that involve multiple steps or interactions between models. This keeps controllers thin and focused on HTTP concerns.
- Documentation for generating LightService organizers:
```
Usage:
  bin/rails generate light_service:organizer NAME [options]

Options:
  [--skip-namespace]                       # Skip namespace (affects only isolated engines)
                                           # Default: false
  [--skip-collision-check]                 # Skip collision check
                                           # Default: false
  [--dir=DIR]                              # Path to write organizers to
                                           # Default: organizers
  [--tests], [--no-tests], [--skip-tests]  # Generate tests (currently only RSpec supported)
                                           # Default: true

Runtime options:
  -f, [--force]                                      # Overwrite files that already exist
  -p, [--pretend], [--no-pretend], [--skip-pretend]  # Run but do not make any changes
  -q, [--quiet], [--no-quiet], [--skip-quiet]        # Suppress status output
  -s, [--skip], [--no-skip], [--skip-skip]           # Skip files that already exist

Description:
  Will create the boilerplate for an organizer. Pass it an organizer name, e.g.
    thing_maker, or ThingMaker   - will create ThingMaker in app/organizers/thing_maker.rb
    thing/maker, or Thing::Maker - will create Thing::Maker in app/organizers/thing/maker.rb

Options:
  Skip rspec test creation with --no-tests
  Write organizers to a specified dir with --dir="workflows". Default is "organizers" in app/organizers

Full Example:
  rails g light_service:organizer My::Awesome::Organizer
```
- Documentation for generating LightService actions:
```
Usage:
  bin/rails generate light_service:action NAME [expects:one,thing promises:something,else] [options]

Options:
  [--skip-namespace]                                   # Skip namespace (affects only isolated engines)
                                                       # Default: false
  [--skip-collision-check]                             # Skip collision check
                                                       # Default: false
  [--dir=DIR]                                          # Path to write actions to
                                                       # Default: actions
  [--tests], [--no-tests], [--skip-tests]              # Generate tests (currently only RSpec supported)
                                                       # Default: true
  [--roll-back], [--no-roll-back], [--skip-roll-back]  # Add a roll back block
                                                       # Default: true

Runtime options:
  -f, [--force]                                      # Overwrite files that already exist
  -p, [--pretend], [--no-pretend], [--skip-pretend]  # Run but do not make any changes
  -q, [--quiet], [--no-quiet], [--skip-quiet]        # Suppress status output
  -s, [--skip], [--no-skip], [--skip-skip]           # Skip files that already exist

Description:
  Will create the boilerplate for an action. Pass it an action name, e.g.
    foo_bar, or FooBar   - will create FooBar in app/actions/foo_bar.rb
    foo/bar, or Foo::Bar - will create Foo::Bar in app/actions/foo/bar.rb

Expects & Promises:
  Specify a list of expected context keys by passing expects and a comma separated
  list of keys. Adds keys to the `expects` list, creates convenience variables in
  the action, and generates a stub context in generated specs.

    expects:foo,bar,baz

  Specify promised context keys in the same manner as 'expects' above. This adds
  keys to the `promises` list, and creates stub expectations in generated specs.

    promises:quux,quark

Options:
  Skip rspec test creation with --no-tests
  Skip ActionRollback creation with --no-roll-back
  Write actions to a specified dir with --dir="services". Default is "actions" in app/actions

Full Example:
  rails g light_service:action My::Awesome::Action expects:foo,bar promises:baz,qux
```
- Prefer nouns for organizer names and verbs for action names, but be guided by what makes the most sense for the behavior you're modeling. An organizer is a workflow or process, while an action is a discrete step or operation within that workflow.
