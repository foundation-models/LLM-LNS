.PHONY: help install sync dev clean lint format test run-tsp run-mvc run-is run-sc run-miks run-bp test-mvc test-is test-sc test-all setup-env

# Load environment variables from .env file
ifneq (,$(wildcard .env))
    include .env
    export
endif

# Default target
help: ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## Create virtual environment and install dependencies
	uv venv
	uv sync

sync: ## Sync dependencies with pyproject.toml
	uv sync

dev: ## Install development dependencies
	uv sync --extra dev

clean: ## Remove virtual environment and cache files
	rm -rf .venv
	rm -rf __pycache__
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

lint: ## Run linting with flake8
	uv run flake8 src/

format: ## Format code with black
	uv run black src/

test: ## Run tests with pytest
	uv run pytest

# Project-specific run targets
run-tsp: ## Run TSP example
	uv run --env-file .env python src/Combinatorial\ Optimization\ Problems/Traveling\ Salesman\ Problem/tsp_eoh_change_prompt.py

run-mvc: ## Run MVC example
	uv run --env-file .env python src/MILP\ Problems/MVC_eoh_change_prompt_ACP.py

run-is: ## Run Independent Set example
	uv run --env-file .env python src/MILP\ Problems/IS_eoh_change_prompt_ACP.py

run-sc: ## Run Set Cover example
	uv run --env-file .env python src/MILP\ Problems/SC_eoh_change_prompt_ACP.py

run-miks: ## Run Maximum Independent K-Set example
	uv run --env-file .env python src/MILP\ Problems/MIKS_eoh_change_prompt_ACP.py

run-bp: ## Run Online Bin Packing example
	uv run --env-file .env python src/Combinatorial\ Optimization\ Problems/Online\ Bin\ Packing/bp_eoh_change_prompt.py

# Test system with different problem types
test-mvc: ## Test Minimum Vertex Cover problem
	uv run --env-file .env python src/MILP\ Problems/MVC_eoh_change_prompt_ACP.py

test-is: ## Test Independent Set problem
	uv run --env-file .env python src/MILP\ Problems/IS_eoh_change_prompt_ACP.py

test-sc: ## Test Set Cover problem
	uv run --env-file .env python src/MILP\ Problems/SC_eoh_change_prompt_ACP.py

test-all: ## Test all problem types (MVC, IS, SC, TSP)
	@echo "Testing Minimum Vertex Cover problem..."
	uv run --env-file .env python src/MILP\ Problems/MVC_eoh_change_prompt_ACP.py
	@echo "Testing Independent Set problem..."
	uv run --env-file .env python src/MILP\ Problems/IS_eoh_change_prompt_ACP.py
	@echo "Testing Set Cover problem..."
	uv run --env-file .env python src/MILP\ Problems/SC_eoh_change_prompt_ACP.py
	@echo "Testing Traveling Salesman Problem..."
	uv run --env-file .env python src/Combinatorial\ Optimization\ Problems/Traveling\ Salesman\ Problem/tsp_eoh_change_prompt.py

# Environment activation helper
shell: ## Activate the virtual environment shell
	@echo "To activate the environment, run:"
	@echo "source .venv/bin/activate"

# Check if uv is installed
check-uv: ## Check if uv is installed
	@command -v uv >/dev/null 2>&1 || { echo >&2 "uv is required but not installed. Please install it: curl -LsSf https://astral.sh/uv/install.sh | sh"; exit 1; }

# Environment setup
setup-env: ## Copy .env.example to .env for configuration
	@if [ ! -f .env ]; then \
		cp .env.example .env; \
		echo "Created .env file from .env.example"; \
		echo "Please edit .env with your actual Azure OpenAI credentials"; \
	else \
		echo ".env file already exists"; \
	fi

# Full setup from scratch
setup: check-uv install setup-env ## Complete setup: check uv, create environment, install dependencies, and setup env
	@echo "Setup complete! Edit .env with your credentials, then use 'make help' to see available commands."
