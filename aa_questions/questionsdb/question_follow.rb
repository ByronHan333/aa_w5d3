require_relative 'questions_db_connection'
require_relative 'user'
require_relative 'question'
require_relative 'question_like'
require_relative 'reply'

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

  def self.followers_for_question_id(question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
    SELECT id, fname, lname
    FROM users
    WHERE id in
      (SELECT user_id
      FROM question_follows
      WHERE question_id = ?)
    SQL
    data.map {|datum| User.new(datum)}
  end

  def self.followed_questions_for_user_id(user_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT id, title, body, author_id
      FROM questions
      WHERE id IN (SELECT question_id
      FROM question_follows
      WHERE user_id = ?)
    SQL
    data.map {|datum| Question.new(datum)}
  end

  def self.most_followed_questions(n)
    data = QuestionsDBConnection.instance.execute(<<-SQL, n)
    SELECT id, title, body, author_id
    FROM questions
    WHERE id IN
      (SELECT question_id
      FROM question_follows
      GROUP BY question_id
      ORDER BY COUNT(user_id) DESC
      LIMIT ?)
    SQL
    data.map {|datum| Question.new(datum)}
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end




end
