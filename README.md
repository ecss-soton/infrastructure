# ECSS Infrastructure

A meta repository storing config files for the running of all ECSS related services on our VM.

## Why?

The main reason for this repository is to version control our docker-compose.yaml file. This file is what is
responsible for the majority of our infrastructure and this respository allows us to version control
that infrastructure. It is our attempt at IaC (Infrastructure as Code)

## What does this repo contain

- Infrastructure configuration
  - [docker-compose.yaml](docker-compose.yaml) The docker compose file to run portainer and caddy
  - [stack.yaml](stack.yaml) - The main docker-compose file for our infrastructure
- Configs for services that we run
  - [Caddyfile](Caddyfile) - The config for our reverse proxy
- Environment variables
  - [env/web_main.env.example](env/web_main.env.example) - Example env file for the main website
  - [env/web_sotonverify.env.example](env/web_sotonverify.env.example) - Example env file for the sotonverify website
  - [env/web_teamreg.env.example](env/web_teamreg.env.example) - Example env file for the hackathon team registration website
  - [env/bot_sotonverify.env.example](env/bot_sotonverify.env.example) - Example env file for the sotonverify bot
- A script to update the infrastructure
  - [update.sh](update.sh) - A simple script to pull the latest changes and restart the infrastructure

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

You'll want to change our FQDN (society.ecs.soton.ac.uk) to your own.

3. Run the infrastructure

```bash
docker compose up -d
```

### Updating the infrastructure

1. Run the update script

```bash
chmod +x scripts/update.sh && ./scripts/update.sh
```


