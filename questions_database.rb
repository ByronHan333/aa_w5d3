require 'sqlite3'
require 'singleton'

class QuestionsDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class User
  attr_accessor :id, :fname, :lname
  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM users")
    data.map {|datum| User.new(datum)}
  end

  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT id, fname, lname
      FROM users
      WHERE id = ?
    SQL
    data.map {|datum| User.new(datum)}
  end

  def self.find_by_name(fname,lname)
    data = QuestionsDBConnection.instance.execute(<<-SQL, fname, lname)
      SELECT id, fname, lname
      FROM users
      WHERE fname = ?, lname = ?
    SQL
    data.map {|datum| User.new(datum)}
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    Question.find_by_author_id(self.id)
  end

  def authored_replies
    Reply.find_by_user_id(self.id)
  end

end

class Question
  attr_accessor :id, :title, :body, :author_id
  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM questions;")
    data.map {|datum| Question.new(datum)}
  end

  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT id, title, body, author_id
      FROM questions
      WHERE id = ?
    SQL
    data.map {|datum| Question.new(datum)}
  end

  def self.find_by_author_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT id, title, body, author_id
      FROM questions
      WHERE author_id = ?
    SQL
    data.map {|datum| Question.new(datum)}
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end
end

class QuestionFollow
  attr_accessor :id, :user_id, :question_id
  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM question_follows;")
    data.map {|datum| QuestionFollow.new(datum)}
  end

  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT id, user_id, question_id
      FROM question_follows
      WHERE id = ?
    SQL
    data.map {|datum| QuestionFollow.new(datum)}
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end

class Reply
  attr_accessor :id, :user_id, :question_id, :parent_id, :body
  def self.all
      data = QuestionsDBConnection.instance.execute("SELECT * FROM replies;")
      data.map {|datum| Reply.new(datum)}
  end

  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT id, user_id, question_id, parent_id, body
      FROM replies
      WHERE id = ?
    SQL
    data.map {|datum| Reply.new(datum)}
  end

  def initialize(options)
      @id = options['id']
      @body = options['body']
      @user_id = options['user_id']
      @parent_id = options['parent_id']
      @question_id = options['question_id']
  end




end

class QuestionLike
  attr_accessor :id, :user_id, :question_id

  def self.all
    data = QuestionsDBConnection.instance.execute("SELECT * FROM question_likes;")
    data.map {|datum| QuestionLike.new(datum)}
  end

  def self.find_by_id(id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, id)
      SELECT id, user_id, question_id
      FROM question_likes
      WHERE id = ?
    SQL
    data.map {|datum| QuestionLike.new(datum)}
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end
