# GCI Task Exporter for Gitlab Issues

This is a simple file we used for [GCI 2016](https://codein.withgoogle.com) to export our tasks to CSV.

We needed to export our [Gitlab Issues](https://gitlab.com/librehealth/gci/issues) in order to import them into the GCI system.

To run it:

``` shell
$ bundle install
$ ruby bin/task_exporter.rb /path/to/output.csv
```
Be sure to change the `project_id` variable in `bin/task_exporter.rb` to your project's id.

This will output to the the file specified as the first command-line argument passed.

There is a sample file [here](https://gitlab.com/librehealth/gci_task_exporter/blob/master/librehealth_gci_tasks.csv).

The format was taken from the [codein API Client](https://code.googlesource.com/codein/api)'s [sample csv](https://code.googlesource.com/codein/api/+/master/sample.csv). Thus it can be imported using that code.

To use this, you must get a [Gitlab API access token](https://gitlab.com/profile/personal_access_tokens).

Copy `.env.example` to `.env` and place your token there. `.env` is ignored by git.

Copy `mentors.yml.example` to `mentors.yml` and add the gitlab usernames as the key and the value should be their GCI mentor email.
