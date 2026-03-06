SKILLS_DIR := skills
SKILLS := $(notdir $(wildcard $(SKILLS_DIR)/*))
AGENTS ?= claude codex

DEST_DIR_claude := $(HOME)/.claude/skills
DEST_DIR_codex := $(HOME)/.codex/skills

CLAUDE_DIR := $(HOME)/.claude

.PHONY: install install-claude-config FORCE
install: install-claude-config $(addprefix install-agent-,$(AGENTS))

install-claude-config:
	cp claude/statusline.sh $(CLAUDE_DIR)/statusline.sh
	@echo "Installed statusline.sh to $(CLAUDE_DIR)/"

install-agent-%: FORCE
	@dest_dir='$(DEST_DIR_$*)'; \
	if [ -z "$$dest_dir" ]; then \
		echo "Unknown agent '$*'. Configure DEST_DIR_$* in Makefile."; \
		exit 1; \
	fi; \
	mkdir -p "$$dest_dir"; \
	for skill in $(SKILLS); do \
		mkdir -p "$$dest_dir/$$skill"; \
		cp -R "$(SKILLS_DIR)/$$skill/." "$$dest_dir/$$skill/"; \
		echo "Installed $$skill to $$dest_dir/$$skill/"; \
	done

FORCE:
