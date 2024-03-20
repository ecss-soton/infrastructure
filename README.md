# ECSS Infrastructure

A meta repository storing config files for the running of all ECSS related services on our VM.

## Why?

The main reason for this repository is to version control our docker-compose.yaml file. This file is what is
responsible for the majority of our infrastructure and this respository allows us to version control
that infrastructure. It is our attempt at IaC (Infrastructure as Code)

## What does this repo contain

- Infrastructure configuration
  - [docker-compose.yaml](docker-compose.yaml) The docker compose file to run portainer and caddy
- Configs for services that we run
  - [Caddyfile](Caddyfile) - The config for our reverse proxy
- Environment variables
  - [env/web_main.env.example](env/web_main.env.example) - Example env file for the main website
  - [env/web_sotonverify.env.example](env/web_sotonverify.env.example) - Example env file for the sotonverify website
  - [env/web_teamreg.env.example](env/web_teamreg.env.example) - Example env file for the hackathon team registration website
  - [env/bot_sotonverify.env.example](env/bot_sotonverify.env.example) - Example env file for the sotonverify bot
- A script to update the infrastructure
  - [install.sh](install.sh) - Script to install the infrastructure from scratch
  - [update.sh](update.sh) - Script to pull the latest changes and restart the infrastructure
  - [prune.sh](prune.sh) - Script to prune various docker objects (containers, images, volumes)
  - [backup-env.sh](backup-env.sh) - Script to backup the env files
  - [restore-env.sh](restore-env.sh) - Script to restore the env files
  - [hydrate-db.sh](hydrate-db.sh) - Script to hydrate the mongodb database from the main web github repo
  - [backup-db.sh](backup-db.sh) - Script to backup the mongodb database

## How to use

### Prerequisites

- Docker v25+

### Running the infrastructure

1. Clone the repository

```bash
git clone https://github.com/ecss-soton/infrastructure.git && cd infrastructure
```

2. Copy the example env files and fill them in with the production values

```bash
cp env/web_main.env.example env/web_main.env && cp env/web_sotonverify.env.example env/web_sotonverify.env && cp env/web_teamreg.env.example env/web_teamreg.env && cp env/bot_sotonverify.env.example env/bot_sotonverify.env
```

3. Configure the Caddyfile

You'll want to change our FQDN (society.ecs.soton.ac.uk + sotonverify.link) to your own.

3. Run the infrastructure

```bash
docker compose up -d
```

### Updating the infrastructure

1. Run the update script

```bash
chmod +x scripts/update.sh && ./scripts/update.sh
```

## Domains

- [society.ecs.soton.ac.uk](https://society.ecs.soton.ac.uk) - The main ECSS website
- [sotonverify.link](https://sotonverify.link) - The sotonverify website

Both websites redirect www. to the non-www version
