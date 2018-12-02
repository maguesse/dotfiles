.PHONY: all
all: dotfiles ## Install the dotfiles

.PHONY: dotfiles
dotfiles: ## Installs the dotfiles, isn't it ?
	@for file in $(shell find $(CURDIR) -name ".*" -not -name ".gitignore" -not -name ".*.swp" -not -name ".git"); do \
		f=$$(basename $$file); \
		echo ln -sf $$file $(HOME)/$$f;\
	done; 

.PHONY: help
help: ## This help
	@grep -E '[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS=":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
