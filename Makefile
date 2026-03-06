CLAUDE_SKILLS_DIR := $(HOME)/.claude/skills

.PHONY: install
install: install-git-commit

.PHONY: install-git-commit
install-git-commit:
	mkdir -p $(CLAUDE_SKILLS_DIR)/git-commit
	cp skills/git-commit/SKILL.md $(CLAUDE_SKILLS_DIR)/git-commit/SKILL.md
	@echo "Installed git-commit skill to $(CLAUDE_SKILLS_DIR)/git-commit/"
