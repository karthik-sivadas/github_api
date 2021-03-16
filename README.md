# Github API application

This application can be used to:
- List repository of a specific user
- Create a repository
- Update a repository name and description
- Delete a repository
- Edit Topics of a repository
- Enable and Disbale security alert of a repository

# Installation

```
bundle install
bundle exec rails db:setup
```

In order for the octokit gem to work you need to setup `~/.netrc` file

```
machine api.github.com
  login github_user_name
  password github_personal_token
```

To start the server
```
bundle exec rails s
```

# API Documentation

[Postman Documentation](https://documenter.getpostman.com/view/5628204/Tz5tWue7)

