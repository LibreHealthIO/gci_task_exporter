require 'gitlab'
Gitlab.configure do |config|
  require 'dotenv'
  Dotenv.load
  config.endpoint       = 'https://gitlab.com/api/v4'
  config.private_token  = ENV['GITLAB_ACCESS_TOKEN']
end

def filter_list(list, values = [])
  list.delete_if { |v| values.include? v }
end

require 'yaml'
MENTOR_EMAILS = YAML.safe_load(File.open(File.expand_path('mentors.yml')))

def mentors_for_task(issue)
  mentors = issue['assignees'].map do |assignee|
    username = assignee['username']
    assignee = MENTOR_EMAILS[username]
    raise "Mentor #{username} is not in mentors.yml. Cannot proceed." unless assignee
    assignee
  end
  author = MENTOR_EMAILS[issue['author']['username']]
  mentors << author unless mentors.include? author
  mentors
end

def categories_for_task(tags)
  categories = []
  categories << 1 if tags.include?('coding') # Coding
  categories << 2 if %w[ui design]
                     .any? { |tag| tags.include? tag } # User Interface
  categories << 3 if tags.include?('documentation') # Documentation & Training
  categories << 4 if tags.include?('qa') # Quality Assurance
  categories << 5 if tags.include?('outreach') # Outreach/Research
  categories
end

require 'csv'
output = ARGV[0]
# change this to whatever yours is, librehealth/gci is 2016295
project_id = ENV['GITLAB_PROJECT_ID']
CSV.open(output, 'wb') do |csv|
  csv << %w[name description max_instances mentors tags is_beginner
            categories time_to_complete_in_days private_metadata]
  issues = Gitlab.issues(project_id, per_page: 75, state: 'opened')
  issues.each do |issue|
    issue = issue.to_h
    name =  issue['title'].to_s
    description = "See #{issue['web_url']}"
    mentors = mentors_for_task(issue)
    tags = issue['labels']
    categories = categories_for_task(tags)
    beginner = tags.include?('intro') ? 'yes' : 'no'
    time_to_complete = 3
    max_instances = 75 if ['once-per-student',
                           'multiple-per-student']
                          .any? { |tag| tags.include? tag }
    max_instances = 1 if tags.include?('only-once')
    tags = filter_list(issue['labels'],
                       ['coding', 'design', 'documentation',
                        "gci-#{Time.new.year}", 'intro',
                        'outreach', 'qa', 'ui'])
    csv << [name, description, max_instances, mentors.join(','),
            tags.join(','), beginner, categories.join(','),
            time_to_complete, nil]
  end
end
