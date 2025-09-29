.PHONY: help install sync dev clean lint format test run-tsp run-mvc

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
	uv run python src/Combinatorial\ Optimization\ Problems/Traveling\ Salesman\ Problem/tsp_eoh_change_prompt.py

run-mvc: ## Run MVC example
	uv run python src/MILP\ Problems/MVC_eoh_change_prompt_ACP.py

# Environment activation helper
shell: ## Activate the virtual environment shell
	@echo "To activate the environment, run:"
	@echo "source .venv/bin/activate"

# Check if uv is installed
check-uv: ## Check if uv is installed
	@command -v uv >/dev/null 2>&1 || { echo >&2 "uv is required but not installed. Please install it: curl -LsSf https://astral.sh/uv/install.sh | sh"; exit 1; }

# Full setup from scratch
setup: check-uv install ## Complete setup: check uv, create environment, and install dependencies
	@echo "Setup complete! Use 'make help' to see available commands."
