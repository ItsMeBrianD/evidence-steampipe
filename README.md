# Evidence + Steampipe = 🚀

This repository contains an example of configuring a [Postgres](https://www.postgresql.org/) database and a [Steampipe](https://steampipe.io/) database using `[postgres_fwd](https://www.postgresql.org/docs/14/postgres-fdw.html)` - then exploring it using [Evidence](https://evidence.dev).

Steampipe is a postgres-based tool that connects to external APIs and lets you query them with SQL, creating an ergonomic method of getting data from over 100 popular APIs.

Evidence is a Business Intelligence as Code framework, using markdown + sql to make it easy to build rich reports and analyses.

## Project Setup

### Prerequisites

Note that the scripts included in this project were tested on Linux, they may work on MacOS but will not work on Windows.

1. Ensure [docker](https://docs.docker.com/get-docker/) and [docker-compose](https://docs.docker.com/compose/install/) are installed
2. Ensure [node](https://nodejs.org/en/download) is installed (at least v16)
   1. If you are using linux, I recommend using [nvm](https://github.com/nvm-sh/nvm) to install node
3. The scripts in this project make a few assumptions
   1. They assume they are being run on Linux
      1. This may work on MacOS, if `bash` is installed (`zsh` is the default)
      2. This may work on Windows, if run within `WSL2`
   2. `bash`, `sudo` and `psql` are installed


### Bootstrapping the databases

1. Run `./scripts/prepare.sh`
   1. Creates `./postgres`
   2. Creates `./steampipe`
      1. Changes ownership of `./steampipe` to userid `9193`
      2. This step asks for sudo premissions, it is the only sudo step in the project.
2. Copy `steampipe.env.example` -> `steampipe.env`
   1. Add your [Github Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens)
3. Start the databases with `docker compose up`
   1. Wait for both steampipe and postgres to become available
      1. Postgres will log: `database system is ready to accept connections`
      2. Steampipe will log: `Steampipe service is running`
4. Run `./scripts/add-remote-schemas.sh`
   1. Installs the `github` plugin in steampipe
   2. Executes `./scripts/sql/remote-schema.sql`
      1. Enables `postgres_fdw`
      2. Sets up the connection to steampipe
      3. Imports the github schema
   3. Executes `./scripts/sql/test-query.sql`
      1. Verifies that the `evidence-dev` organization can be selected from `postgres` (not `steampipe`)

### Run the evidence project

1. Run `npm install`
2. Run `npm run dev`
3. Open [http://localhost:3000](http://localhost:3000)

