# GCI Task Exporter for Gitlab Issues

This is a simple file we used for [GCI 2016](https://codein.withgoogle.com) to export our tasks to CSV.

To run it:

``` shell
$ bundle install
$ ruby bin/task_exporter.rb
```

This will output to the current working directory. Simply change the `output` variable to the desired output.

There is a sample file [here](https://gitlab.com/librehealth/gci_task_exporter/blob/master/librehealth_gci_tasks.csv).

The format was taken from the [codein API Client](https://code.googlesource.com/codein/api)'s [sample csv](https://code.googlesource.com/codein/api/+/master/sample.csv). Thus it can be imported using that code.

To use this, you must get a [Gitlab API access token](https://gitlab.com/profile/personal_access_tokens).

Copy `.env.example` to `.env` and place your token there. `.env` is ignored by git.
