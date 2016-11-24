# coding: utf-8
require 'dotenv'
Dotenv.load

require 'gitlab'
Gitlab.configure do |config|
  config.endpoint       = 'https://gitlab.com/api/v3'
  config.private_token  = ENV['GITLAB_ACCESS_TOKEN']
end

def filter_list(list, values = [])
  list.delete_if { |v| values.include? v }
end

require 'csv'
output = 'librehealth_gci_tasks.csv'
CSV.open(output, 'wb') do |csv|
  csv << %w(name description max_instances mentors tags is_beginner categories time_to_complete_in_days private_metadata)
  issues = Gitlab.issues(2_016_295, per_page: 32, state: 'opened')
  issues.each do |issue|
    issue = issue.to_h
    name =  issue['title']
    description = "See #{issue['web_url']}"
    mentor = issue['author']['username']
    tags = issue['labels']
    categories = []
    categories << 2 if %w(ui design).any? { |tag| tags.include? tag } # User Interface
    categories << 3 if tags.include?('documentation') # Documentation & Training
    categories << 4 if tags.include?('qa') # Quality Assurance
    categories << 5 if tags.include?('outreach') # Outreach/Research
    beginner = tags.include?('intro') ? 'yes' : 'no'
    time_to_complete = 3
    max_instances = 75  if ['once-per-student',
                            'multiple-per-student'].any? { |tag| tags.include? tag }
    max_instances = 1 if tags.include?('once-only')
    tags = filter_list(issue['labels'],
                       ['design', 'documentation',
                        'gci-2016', 'intro', 'outreach', 'qa', 'ui'])
    csv << [name, description, max_instances, mentor, tags.join(','), beginner, categories.join(','),time_to_complete,nil]
  end
end
