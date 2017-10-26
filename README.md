# GCI Task Exporter for Gitlab Issues

This is a simple file we used for [Google Code-In](https://codein.withgoogle.com) to export our tasks to CSV.

We needed to export our [Gitlab Issues](https://gitlab.com/librehealth/gci/issues) in order to import them into the GCI system.

To run it:

``` shell
$ bundle install
$ bundle exec ruby bin/task_exporter.rb /path/to/output.csv
```

This will output to the the file specified as the first command-line argument passed.

The format was taken from the [codein API Client](https://code.googlesource.com/codein/api)'s [sample csv](https://code.googlesource.com/codein/api/+/master/sample.csv). Thus it can be imported using that code.

To use this, you must get a [Gitlab API access token](https://gitlab.com/profile/personal_access_tokens).

Copy `.env.example` to `.env` and place your token and project id there. `.env` is ignored by git.

Your project id can be found in the General Project Settings, as of the time of writing this, it was the first section of the settings for the project.

Copy `mentors.yml.example` to `mentors.yml` and add the gitlab usernames as the key and the value should be their GCI mentor email.

# How mentors are determined

Mentors are all assignees **PLUS** the author of the issue if they are not an assignee already.
