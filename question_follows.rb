require_relative 'question_db_connection'

class QuestionFollow
    attr_accessor :id, :question_id, :user_id
    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @user_id = options['user_id']
    end

    def self.followers_for_question_id(question_id)
        followers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT
            users.*
        FROM
            users
        JOIN
            question_follows ON users.id = user_id
        WHERE
            question_follows.question_id = ?
        SQL
        return nil if followers.empty?
        followers.map { |follower| User.new(follower) }
    end
end