require_relative 'question_db_connection'

class QuestionLike
    attr_accessor :id, :user_id, :question_id
    def initialize(options)
        @id = options['id']
        @user_id  = options['user_id']
        @question_id  = options['question_id']
    end

    def self.likers_for_question_id(question_id)
        likers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT
            users.*
        FROM
            users
        JOIN
            question_likes ON users.id = user_id
        WHERE
            question_id = ?
        SQL
        return nil if likers.empty?
        likers.map { |liker| User.new(liker) }
    end
end