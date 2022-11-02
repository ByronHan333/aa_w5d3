require_relative 'questions_database'





















# all_users = User.all()
# user = User.find_by_id(1)

# all_questions = Question.all()
# question = Question.find_by_id(1)

# all_questionfollows = QuestionFollow.all
# questionfollow = QuestionFollow.find_by_id(1)

# all_replies = Reply.all
# reply = Reply.find_by_id(1)

# all_likes = QuestionLike.all
# like = QuestionLike.find_by_id(1)

# p all_users
# p user
# p all_questions
# p question
# p all_questionfollows
# p questionfollow
# p all_replies
# p reply
# p all_likes
# p like


# class QuestionsDBConnection < SQLite3::Database
#   include Singleton

#   def initialize
#     super('questions.db')
#     self.type_translation = true
#     self.results_as_hash = true
#   end
# end

# data = QuestionsDBConnection.instance.execute("SELECT * FROM users")
# p data
