require 'active_support/inflector'
class ModelBase

  def self.table
    self.to_s.tableize
  end

  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM #{self.table}")
    self.parse_all(data)
  end

  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT *
      FROM #{self.table}
      WHERE id = ?
    SQL
    self.parse_all(data)
  end

  def self.parse_all(data)
    data.map { |attrs| self.new(attrs) }
  end

  def attrs
    #turn an instance of any object into hash of key=>value
    h = {}
    self.instance_variables.each do |v_name|
      key = v_name[1..-1]
      h[key] = self.instance_variable_get(v_name)
    end
    h

    # is equivalent of writing:
    # h = Hash[self.instance_variables.map do |name|
    #   [name.to_s[1..-1], self.instance_variable_get(name)]
    # end]
  end

  def where(hash)

    data = QuestionsDBConnection.instance.execute(<<-SQL)
      SELECT *
      FROM #{self.table}
      WHERE id = ?
      AND 
    SQL
  end

  def find_by

  end

  def initialize

  end

  def save

  end

  def create

  end

  def update

  end
end
