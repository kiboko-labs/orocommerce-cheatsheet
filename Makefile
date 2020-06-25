##
## Makefile
##

.PHONY: git
git: ## push to master
git:
	git add .
	git commit -m "$m"
	git push -u origin master

.PHONY: deploy
deploy: ## Deploy to dev0
deploy: git
	mkdocs gh-deploy