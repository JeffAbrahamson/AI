SKILLS_DIR := skills
SKILLS := $(notdir $(wildcard $(SKILLS_DIR)/*))
AGENTS ?= claude codex

DEST_DIR_claude := $(HOME)/.claude/skills
DEST_DIR_codex := $(HOME)/.codex/skills

CLAUDE_DIR := $(HOME)/.claude

.PHONY: install test install-claude-config FORCE
install: test $(if $(filter claude,$(AGENTS)),install-claude-config) $(addprefix install-agent-,$(AGENTS))

test:
	@if [ -z "$(SKILLS)" ]; then \
		echo "No tests."; \
		exit 0; \
	fi; \
	fail=0; \
	for skill in $(SKILLS); do \
		if [ ! -f "$(SKILLS_DIR)/$$skill/SKILL.md" ]; then \
			echo "Missing $(SKILLS_DIR)/$$skill/SKILL.md"; \
			fail=1; \
		fi; \
	done; \
	if [ $$fail -eq 0 ]; then \
		echo "All skill tests passed."; \
		exit 0; \
	fi; \
	exit 1

install-claude-config:
	cp claude/statusline.sh $(CLAUDE_DIR)/statusline.sh
	@echo "Installed statusline.sh to $(CLAUDE_DIR)/"
	@settings="$(CLAUDE_DIR)/settings.json"; \
	current=$$(cat "$$settings" 2>/dev/null || echo '{}'); \
	updated=$$(printf '%s' "$$current" | jq '. + {"statusLine": {"type": "command", "command": "bash $(CLAUDE_DIR)/statusline.sh"}}'); \
	printf '%s\n' "$$updated" > "$$settings"; \
	echo "Configured statusLine in $$settings"

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
