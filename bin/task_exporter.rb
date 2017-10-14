# coding: utf-8
require 'dotenv'
Dotenv.load

require 'gitlab'
Gitlab.configure do |config|
  config.endpoint       = 'https://gitlab.com/api/v4'
  config.private_token  = ENV['GITLAB_ACCESS_TOKEN']
end

def filter_list(list, values = [])
  list.delete_if { |v| values.include? v }
end
require 'yaml'
MENTOR_EMAILS = YAML.load(File.open(File.expand_path('mentors.yml')))

require 'csv'
output = ARGV[0]
# change this to whatever yours is, librehealth/gci is 2016295
project_id = 2_016_295
CSV.open(output, 'wb') do |csv|
  csv << %w(name description max_instances mentors tags is_beginner categories time_to_complete_in_days private_metadata) # rubocop:disable Metrics/LineLength
  issues = Gitlab.issues(project_id, per_page: 32, state: 'opened')
  issues.each do |issue|
    issue = issue.to_h
    name =  "LibreHealth: #{issue['title']}"
    description = "See #{issue['web_url']}"
    mentor = MENTOR_EMAILS[issue['author']['username']]
    tags = issue['labels']
    categories = []
    categories << 2 if %w(ui design)
                       .any? { |tag| tags.include? tag } # User Interface
    categories << 3 if tags.include?('documentation') # Documentation & Training
    categories << 4 if tags.include?('qa') # Quality Assurance
    categories << 5 if tags.include?('outreach') # Outreach/Research
    beginner = tags.include?('intro') ? 'yes' : 'no'
    time_to_complete = 3
    max_instances = 75 if ['once-per-student',
                           'multiple-per-student']
                          .any? { |tag| tags.include? tag }
    max_instances = 1 if tags.include?('only-once')
    tags = filter_list(issue['labels'],
                       ['design', 'documentation',
                        'gci-2016', 'intro', 'outreach', 'qa', 'ui'])
    csv << [name, description, max_instances, mentor, tags.join(','),
            beginner, categories.join(','), time_to_complete, nil]
  end
end
