# =============================================================================
# MAIN COMMAND TARGETS
# =============================================================================
.DEFAULT_GOAL := help

.PHONY: help
help: ## Display a list of the public targets
# Find lines that starts with a word-character, contains a colon and then a
# doublehash (underscores are not word-characters, so this excludes private
# targets), then strip the hash and print.
	@grep -E -h "^\w.*:.*##" $(MAKEFILE_LIST) | sed -e 's/\(.*\):.*##\(.*\)/\1	\2/'

.PHONY: setup-git-remotes
setup-git-remotes: ## Setting up the git remotes inside web/profiles/ding2.
	cd web/profiles/ding2 && git remote add origin git@github.com:reload/ding2.git && git remote add upstream git@github.com:ding2/ding2.git && git fetch origin && git fetch upstream && git checkout master

vendor/bin/drush: composer.lock
	composer install

.PHONY: drush-make-download
drush-make-download: ## Get .make files from ding2/ding2. Requires SVN.
	git clone --depth 1 git@github.com:ding2/ding2.git ding-tmp
	rm -rf patches
	mv ding-tmp/project-core.make ding-tmp/project.make ding-tmp/patches .
	rm -rf ding-tmp

.PHONY: drush-make
drush-make: project-core.make vendor/bin/drush ## Get .make files from ding2/ding2 and install them.
	rm -rf web
	./vendor/bin/drush make --contrib-destination=profiles/ding2/ project-core.make web --working-copy
	./vendor/bin/drush make --contrib-destination=profiles/ding2/ project.make web --working-copy --no-core

.PHONY: drush-remake
drush-remake: project-core.make vendor/bin/drush ## Re-install .make files in an existing project. Notice: This only works in a project that already has a Drupal core.
	./vendor/bin/drush make --contrib-destination=profiles/ding2/ project-core.make web --working-copy --no-core
	./vendor/bin/drush make --contrib-destination=profiles/ding2/ project.make web --working-copy --no-core

.PHONY: install-example-content
install-example-content:
	docker-compose exec fpm sh -c "drush en -y ding_example_content ding_example_content_events ding_example_content_frontpage ding_example_content_groups ding_example_content_news ting_covers_placeholder"

.PHONY: reset
reset: _reset-container-state ## Stop all containers, reset their state and start up again.

.PHONY: up
up:  ## Take the whole environment up without altering the existing state of the containers.
	docker-compose up -d --remove-orphans

# =============================================================================
# HELPERS
# =============================================================================
# These targets are usually not run manually.

# Fetch and replace updated containers and db-dump images and run composer install.
.PHONY: _reset-container-state
_reset-container-state: _docker-pull
	./scripts/docker/docker-reset.sh

# We'd like to only pull for images once a day.
# To achive this we only pull if we can't find a ".last-pull-<date>" file that
# contains todays date in its name. If we can't find the file we do the pull and
# and touch the file. This way we only do a daily pull.
LAST_PULL_FILE:=.last-pull-$(shell date +%Y%m%d)
_docker-pull: $(LAST_PULL_FILE)
$(LAST_PULL_FILE):
    # We could not find the daily file, clear out any old files, do the pull
    # and generate the file.
	rm -f .last-pull-*
	docker-compose pull
	touch $(LAST_PULL_FILE)
