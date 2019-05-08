require 'mysql2'

client = Mysql2::Client.new(host: 'db09', username: 'loki', password: 'v4WmZip2K67J6Iq7NXC', database: 'applicant_tests')
table = 'hle_dev_test_andriy_samoxin'
results = client.query("SELECT * FROM #{table}")
results.each do |row|
  before_parenth = row['candidate_office_name'][/(\w+\s*\w*)/]
  before_parenth.downcase! if before_parenth
  names = row['candidate_office_name'].sub(/(\w+\s*\w*)(,\s*)((\w+\s*){1,})/, "#{before_parenth} (\\3)").split /\//
  become_first = names.pop if names.size > 1
  names.map!(&:downcase) unless names.detect {|name| name.include?('(')}
  names.unshift(become_first).compact!
  names.map! { |name| name.gsub(/hwy/i, 'Highway') }
  names.map! { |name| name.gsub(/twp/i, 'Township') }
  names.map! { |name| name.gsub('.', '') }
  names.map! { |name| name.gsub("'", '') }
  names.insert(-2, 'and') if names.size > 2
  clean_name = "clean_name = '#{names.join(' ')}'"
  sentence = "sentence = 'The candidate is running for the #{names.join(' ')} office'"
  client.query("update #{table} set #{clean_name}, #{sentence} where id='#{row['id']}'")
end
