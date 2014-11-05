# Client Proposals #

Client proposals at Immense Networks

## Basic Usage ##

* Clients live in clients/
* Proposals live in clients/{client}
* layout.jade (in root dir) defines the layout of the generated proposal
* style.less (in root dir) defines the style of the generated proposal
* `grunt client:{client}[:create]` to create a new client w/ proposal
* `grunt client:{client}:create-proposal` to create a new proposal
* `grunt compile:{client}:{proposal}` to compile a proposal to HTML

## TODO ##

* MD -> HTML -> PDF compilation grunt task
* default grunt task should watch -> compile
* Client-specific layouts/styles
