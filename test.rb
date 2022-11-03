require_relative './questionsdb/question_follow'
require_relative './questionsdb/model_base'



# questions = QuestionFollow.followed_questions_for_user_id(1)
# questions.each {|i| print "#{i.body}\n"}



# questions = QuestionFollow.most_followed_questions(1)
# # users = questions[0].followers
# q1 = questions[0]
# q2 = questions[1]

# print "#{q.body}\n"
# users.each {|i| print "#{i.fname}\n"}

# r1 = Question.most_followed(1)[0]
# r2 = Question.most_followed(1)[0]

# print "#{r1.body}\n"
# print "#{r2.body}\n"

# users = QuestionLike.likers_for_question_id(4)
# users.each {|u| puts u.fname}

# qs = Question.most_liked(2)
# qs.each {|u| puts u.body}

# q = qs[0]
# # p q.num_likes
# l1 = q.likers[0]
# p l1.liked_questions

# users = User.find_by_id(2)
# # p users[0]
# p users[0].instance_variables
# p users[0].instance_variable_get(:@id)

# p :@id[1..-1]

# h = Hash[users[0].instance_variables.map do |name|
#   # print "#{name.to_s[1..-1]}, #{users.instance_variable_get(name)}\n"
#   [name.to_s[1..-1], users[0].instance_variable_get(name)]
# end]

# p h

def unpack_hash(hash)
  x = *hash
end
h1 = {author_id: 2}
h2 = {lname: "Oberyn", fname: "Martell"}
h1.join()
p unpack_hash(h1)











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
