require_relative 'questions_db_connection'
require_relative 'user'
require_relative 'question'
require_relative 'question_follow'
require_relative 'reply'

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

  def self.likers_for_question_id(question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
    SELECT id, fname, lname
    FROM users
    WHERE id IN (
      SELECT user_id
      FROM question_likes
      WHERE question_id = ?
    )
    SQL
    data.map {|datum| User.new(datum)}
  end

  def self.num_likes_for_question_id(question_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, question_id)
      SELECT COUNT(user_id) AS num_likes
      FROM question_likes
      WHERE question_id = ?
      GROUP BY question_id
    SQL
    data[0]['num_likes']
  end

  def self.liked_questions_for_user_id(user_id)
    data = QuestionsDBConnection.instance.execute(<<-SQL, user_id)
      SELECT id, title, body, author_id
      FROM questions
      WHERE id IN (
        SELECT question_id
        FROM question_likes
        WHERE user_id = ?
      )
    SQL
    data.map {|datum| Question.new(datum)}
  end

  def self.most_liked_questions(n)
    data = QuestionsDBConnection.instance.execute(<<-SQL, n)
      SELECT id, title, body, author_id
      FROM questions
      WHERE id IN (SELECT question_id
      FROM question_likes
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
