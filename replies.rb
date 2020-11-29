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

    def save
        if id
            QuestionsDatabase.instance.execute(<<-SQL, question_id, parent_reply_id, author_id, body, id)
            UPDATE
                replies
            SET
                question_id = ?, parent_reply_id = ?, author_id = ?, body = ?
            WHERE
                replies.id = ?
            SQL
        else
            QuestionsDatabase.instance.execute(<<-SQL, question_id, parent_reply_id, author_id, body)
            INSERT INTO
                replies (question_id, parent_reply_id, author_id, body)
            VALUES
                (?, ?, ?, ?)
            SQL
            @id = QuestionsDatabase.last_insert_row_id
        end
    end

    def self.all
        replies = QuestionsDatabase.instance.execute("SELECT * FROM replies")
        replies.map { |reply| Reply.new(reply) }
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

    def child_replies
        Reply.all.select { |reply| reply.parent_reply_id == id }
    end
end