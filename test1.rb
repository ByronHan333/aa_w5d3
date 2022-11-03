# require_relative 'test'

# puts 'hello'

x = <<-SQL, id: id
    SELECT
      *
    FROM
      #{table}
    WHERE
      id = :id
SQL

puts x
