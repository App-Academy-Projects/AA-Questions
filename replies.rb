require_relative 'questions'

class Reply
    attr_accessor :id, :question_id, :parent_reply_id, :author_id, :body
    def initialize(options)
        @id = options['id']
        @question_id = options['question_id']
        @parent_reply_id = options['parent_reply_id']
        @author_id = options['author_id']
        @body = options['body']
    end

    def self.find_by_id(id)
        replies = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            replies
        WHERE
            id = ?
        SQL
        return nil if replies.empty?
        replies.map { |reply| Reply.new(reply) }
    end

    def self.find_by_user_id(user_id)
        replies = QuestionsDatabase.instance.execute(<<-SQL, user_id)
        SELECT
            *
        FROM
            replies
        WHERE
            author_id = ?
        SQL
        return nil if replies.empty?
        replies.map { |reply| Reply.new(reply) }
    end

    def self.find_by_question_id(question_id)
        replies = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT
            *
        FROM
            replies
        WHERE
            question_id = ?
        SQL
        return nil if replies.empty?
        replies.map { |reply| Reply.new(reply) }
    end

    def author
        User.find_by_id(author_id)
    end

    def question
        Question.find_by_id(question_id)
    end

    def parent_reply
        Reply.find_by_id(parent_reply_id)
    end
end