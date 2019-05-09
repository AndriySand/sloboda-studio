require 'mysql2'

client = Mysql2::Client.new(host: 'db09', username: 'loki', password: 'v4WmZip2K67J6Iq7NXC', database: 'applicant_tests')
table = 'hle_dev_test_andriy_samoxin'
results = client.query("SELECT * FROM #{table}")
results.each do |row|
  before_parenth = row['candidate_office_name'][/(\w+\s*\w*)/]
  before_parenth.downcase! if before_parenth
  names = row['candidate_office_name'].sub(/(\w+\s*\w*)(,\s*)((\w+\s*){1,})/, "#{before_parenth} (\\3)").split /\//
  become_first = names.pop if names.size > 1
  names.map(&:downcase!) unless names.detect { |name| name.include?('(') }
  become_first.strip! if become_first
  names.unshift(become_first).compact!
  [["'", '`'], ['.', ''], [/twp/i, 'Township'], [/hwy/i, 'Highway']].each do |old_val, new_val|
    names.map! { |name| name.gsub(old_val, new_val) }
  end
  names.insert(-2, 'and') if names.size > 2
  names.each_slice(2) do |f_name, l_name|
    first_word = l_name[/\w+/]
    l_name.sub!(/\w+\s/, '') if first_word && f_name[/\w+$/] == first_word.capitalize
  end if names.size > 1
  joined_names = names.join(' ')
  clean_name = "clean_name = '#{joined_names}'"
  sentence = "sentence = 'The candidate is running for the #{joined_names} office'"
  client.query("update #{table} set #{clean_name}, #{sentence} where id='#{row['id']}'")
end
