DBT_PROFILE_FOLDER = ~/.dbt/profiles.yml
DBT_PROJECT_FOLDER = transform/atp_tennis_dw
ENV = dev

# Define colors
GREEN  := \033[0;32m
YELLOW := \033[1;33m
BLUE   := \033[1;34m
NC     := \033[0m # No Color

.PHONY: help load_data dbt_run

## Show this help message
help:
	@printf "\n$(BLUE)Available targets:$(NC)\n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-20s$(NC) %s\n", $$1, $$2}'
	@echo ""
	@echo 'recommended flow load_data -> add_dbt_profile -> dbt_run'

load_data: ### Load data for atp matches
	@echo "loading data to ${BACKEND}"
	uv run load_data/atp_matches.py --environment ${ENV}

dbt_run: ### Run the DBT project
	uv run dbt run --project-dir ${DBT_PROJECT_FOLDER} --target ${ENV}

dbt_generate_docs: ### Generate DBT docs
	uv run dbt docs generate --project-dir ${DBT_PROJECT_FOLDER}

dbt_serve_docs: ### Serve DBT docs
	uv run dbt docs serve --project-dir ${DBT_PROJECT_FOLDER}

evidence_run: ### Create local Evidence Server
	npm --prefix ./reports install
	npm --prefix ./reports run sources
	npm --prefix ./reports run dev

add_dbt_profile: ### Add DBT profile for this project
	@echo "Checking if DBT profile already exists..."
	@if grep -q '^${DBT_PROJECT_FOLDER}:' ${DBT_PROFILE_FOLDER}; then \
		echo "DBT profile already exists. Skipping append."; \
	else \
		echo "Appending DBT profile to profiles.yml..."; \
		echo "atp_tennis_dw:" >> ${DBT_PROFILE_FOLDER}; \
		echo "  outputs:" >> ${DBT_PROFILE_FOLDER}; \
		echo "    prod:" >> ${DBT_PROFILE_FOLDER}; \
		echo "      type: duckdb" >> ${DBT_PROFILE_FOLDER}; \
		echo "      path: \"md:my_db?motherduck_token={{env_var('MOTHERDUCK_TOKEN')}}\"" >> ${DBT_PROFILE_FOLDER}; \
		echo "      threads: 1" >> ${DBT_PROFILE_FOLDER}; \
		echo "    dev:" >> ${DBT_PROFILE_FOLDER}; \
		echo "      type: duckdb" >> ${DBT_PROFILE_FOLDER}; \
		echo "      path: atp_matches_pipeline.duckdb" >> ${DBT_PROFILE_FOLDER}; \
		echo "      threads: 1" >> ${DBT_PROFILE_FOLDER}; \
		echo "" >> ${DBT_PROFILE_FOLDER}; \
		echo "  target: dev" >> ${DBT_PROFILE_FOLDER}; \
		echo "" >> ${DBT_PROFILE_FOLDER}; \
	fi
