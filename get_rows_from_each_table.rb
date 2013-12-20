require 'rubygems'
require 'dbi'

db_handler = DBI.connect('DBI:Mysql:database_name:localhost', 'user_name', 'password')

# Collect all Tables
sql_1 = db_handler.prepare('SHOW tables;')
sql_1.execute
tables = sql_1.map { |row| row[0]}
sql_1.finish
write_file = ''
tables.each do |table_name|
  sql_2 = db_handler.prepare("SELECT count(*) FROM #{table_name};")
  sql_2.execute
  sql_2.each do |row|
    write_file = write_file+"Table '#{table_name}' has '#{row[0]}' rows.\n"
  end
  sql_2.finish
end
db_handler.disconnect
File.open("db_rows_count.txt", 'w') { |file| file.write(write_file) }
