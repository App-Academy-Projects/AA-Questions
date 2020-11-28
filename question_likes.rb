require_relative 'question_db_connection'

class QuestionLike
    def initialize(options)
        @id = options['id']
        @user_id  = options['user_id']
        @question_id  = options['question_id']
    end
end