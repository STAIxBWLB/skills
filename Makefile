.PHONY: skills-verify
skills-verify: ## Validate manifest, frontmatter, tracked inventory, and the vmem tool contract
	node scripts/skills-bundle.mjs verify
	node scripts/check-vmem-tools.mjs

.PHONY: skills-package
skills-package: ## Build the OTA bundle (REVISION required, e.g. make skills-package REVISION=123)
	node scripts/skills-bundle.mjs package --revision $(REVISION)

.PHONY: skills-eval
skills-eval: ## Run behavior evals in isolated temp workspaces (manual; needs an env credential, see evals/README.md)
	node evals/run.mjs $(EVAL_ARGS)
