require_relative 'questions_db_connection'
require_relative 'user'
require_relative 'question_like'
require_relative 'question_follow'
require_relative 'reply'

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

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def likers
    QuestionLike.likers_for_question_id(self.id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(self.id)
  end

  def followers
    QuestionFollow.followers_for_question_id(self.id)
  end

  def author
    User.find_by_id(self.author_id)
  end

  def replies
    Reply.find_by_question_id(self.id)
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
    QuestionsDBConnection.instance.execute(<<-SQL, self.title, self.body, self.author_id)
      INSERT INTO
        questions (title, body, author_id)
      VAULES
        (?, ?, ?)
    SQL
    self.id = QuestionsDBConnection.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless self.id
    PlayDBConnection.instance.execute(<<-SQL, self.title, self.body, self.author_id, self.id)
      UPDATE
        questions
      SET
        title = ?, body = ?, author_id = ?
      WHERE
        id = ?
    SQL
  end

end
