require_relative 'questions_db_connection'
require_relative 'question'
require_relative 'question_like'
require_relative 'question_follow'
require_relative 'reply'

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

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(self.id)
  end

  def authored_questions
    Question.find_by_author_id(self.id)
  end

  def authored_replies
    Reply.find_by_user_id(self.id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(self.id)
  end

  def average_karma
    data = QuestionsDBConnection.instance.execute(<<-SQL, self.id)
      SELECT 1.0*COUNT(*)/COUNT(DISTINCT(ql.question_id)) as karma
      FROM
      questions q LEFT JOIN question_likes ql ON q.id = ql.question_id
      WHERE author_id = ?
    SQL
    data[0]['karma']

    # num_questions_asked_hash = QuestionsDBConnection.instance.execute(<<-SQL, self.id)
    #   SELECT COUNT(id) as num_questions
    #   FROM questions
    #   WHERE author_id = ?
    #   GROUP BY author_id
    # SQL
    # num_questions_asked = num_questions_asked_hash[0]['num_questions']
    # total_num_liked_hash = QuestionsDBConnection.instance.execute(<<-SQL, self.id)
    #   SELECT COUNT(id) AS total_num_likes
    #   FROM question_likes
    #   WHERE question_id IN (
    #     SELECT id
    #     FROM questions
    #     WHERE author_id = ?
    #   )
    # SQL
    # total_likes = total_num_liked_hash[0]['total_num_likes']
    # 1.0*total_likes/num_questions_asked
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
    QuestionsDBConnection.instance.execute(<<-SQL, self.fname, self.lname)
      INSERT INTO
        users (fname, lname)
      VAULES
        (?, ?)
    SQL
    self.id = QuestionsDBConnection.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless self.id
    PlayDBConnection.instance.execute(<<-SQL, self.fname, self.lname, self.id)
      UPDATE
        users
      SET
        fname = ?, lname = ?
      WHERE
        id = ?
    SQL
  end

end
