require_relative 'questions_db_connection'
require_relative 'user'
require_relative 'question'
require_relative 'question_like'
require_relative 'question_follow'

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

  def self.find_by_user_id(user_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT id, user_id, question_id, parent_id, body
      FROM replies
      WHERE user_id = ?
    SQL
    data.map {|datum| Reply.new(datum)}
  end

  def self.find_by_question_id(question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT id, user_id, question_id, parent_id, body
      FROM replies
      WHERE question_id = ?
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

  def author
    User.find_by_id(self.user_id)
  end

  def question
    Question.find_by_id(self.question_id)
  end

  def parent_reply
    Reply.find_by_id(self.parent_id)
  end

  def child_replies
    data = QuestionsDBConnection.instance.execute(<<-SQL, self.id)
      SELECT id, user_id, question_id, parent_id, body
      FROM replies
      WHERE parent_id = ?
    SQL
    data.map {|datum| Reply.new(datum)}
  end

  def save
    if self.id
      update
    else
      insert
    end
  end

  def insert
    raise "#{self} already in database" if self.id
    QuestionsDBConnection.instance.execute(<<-SQL, self.body, self.user_id, self.parent_id, self.question_id)
      INSERT INTO
        replies (body, user_id, parent_id, question_id)
      VAULES
        (?, ?, ?, ?)
    SQL
    self.id = QuestionsDBConnection.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless self.id
    PlayDBConnection.instance.execute(<<-SQL, self.body, self.user_id, self.parent_id, self.question_id, self.id)
      UPDATE
        replies
      SET
        body = ?, user_id = ?, parent_id = ?, question_id = ?
      WHERE
        id = ?
    SQL
  end
end
