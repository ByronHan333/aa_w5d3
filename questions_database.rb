require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  def intialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class User
  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM users;")
    data.map {|datum| User.new(datum)}
  end

  def initialize(datum)
    @id = datum['id']
    @fname = datum['fname']
    @lname = datum['lname']
  end
end

class Question
  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM questions;")
    data.map {|datum| User.new(datum)}
  end

  def initialize(datum)
    @id = datum['id']
    @title = datum['title']
    @body = datum['body']
    @author_id = datum['author_id']
  end
end

class QuestionFollow
  def self.all
    data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows;")
    data.map {|datum| User.new(datum)}
  end

  def initialize(datum)
    @id = datum['id']
    @user_id = datum['user_id']
    @question_id = datum['question_id']
  end
end

class Reply
  def self.all
      data = QuestionsDatabase.instance.execute("SELECT * FROM question_follows;")
      data.map {|datum| User.new(datum)}
  end

  def initialize(datum)
      @id = datum['id']
      @user_id = datum['user_id']
      @question_id = datum['question_id']
  end
end


