.PHONY: skills-verify
skills-verify: ## Validate manifest, frontmatter, and tracked inventory
	node scripts/skills-bundle.mjs verify

.PHONY: skills-package
skills-package: ## Build the OTA bundle (REVISION required, e.g. make skills-package REVISION=123)
	node scripts/skills-bundle.mjs package --revision $(REVISION)
