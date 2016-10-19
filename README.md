![GitBanLogo](logo.png?raw=true)

[![Code Climate](https://codeclimate.com/github/muhproductions/gitban/badges/gpa.svg)](https://codeclimate.com/github/muhproductions/gitban)
[![security](https://hakiri.io/github/muhproductions/gitban/master.svg)](https://hakiri.io/github/muhproductions/gitban/master)
[![Dependency Status](https://gemnasium.com/badges/github.com/muhproductions/gitban.svg)](https://gemnasium.com/github.com/muhproductions/gitban)

[![GitHub issues](https://img.shields.io/github/issues/muhproductions/gitban.svg)](https://github.com/muhproductions/gitban/issues)
[![GitHub forks](https://img.shields.io/github/forks/muhproductions/gitban.svg)](https://github.com/muhproductions/gitban/network)
[![GitHub stars](https://img.shields.io/github/stars/muhproductions/gitban.svg)](https://github.com/muhproductions/gitban/stargazers)

## Installation
Current development takes place in the master branch. So just go ahead and clone the project.

`git clone https://github.com/muhproductions/gitban.git`

Please make sure **bundler** is installed.

## Setup
Since **GitBan** is a common Rails application just proceed as expected:

`bundle install` to install all required gems.

`RAILS_ENV=production bundle exec rails db:migrate` to run the migrations.

`RAILS_ENV=production bundle exec rails assets:precompile` to compile all assets

So configure **GitBan** you have to use a set of environment variables.

### Variables

The following variables are necessary to start rails:

- SECRET_KEY_BASE: the secret key..
- GITLAB_URL: the url used by omniauth for locate your gitlab
- GITLAB_APP_ID: the gitlab omniauth application id
- GITLAB_SECRET_ID: the gitlab omniauth secret id
- DATABASE_PATH: the location of your database directory

The following variables are nexessary to sync from gitlab

- URL: the gitlab api url
- TOKEN: the token to authenticate against the gitlab api
- DATABASE_PATH: the location of your database directory

## Usage

### Synchronize

The main feature of **GitBan** is the easy sync of Gitlab issues with their dependencies (Assignee, Milestone, Project) into the GitBan database. In order to start the sync use the following command:

    URL=https://your-gitlab.example \
    RAILS_ENV=production \
    TOKEN=secret_token \
    DATABASE_PATH=/var/lib/gitban/db \
    bundle exec rails sync:issues`

This will start the rake task and import all new issues and updates existing ones.

### Boards and Columns
In order to use **GitBan** you have to create a new Kanban board. Therefore just create a new board and columns (which you have to assign to the created board)

### Allocate Tasks
After you have created a board with the desired columns you can allocate new tasks via the *Tasks* Navbar item.
