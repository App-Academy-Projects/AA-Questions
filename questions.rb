require_relative 'question_db_connection'
require_relative 'user'

class Question
    attr_accessor :id, :title, :body, :author_id
    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    def self.all
        data = QuestionsDatabase.instance.execute("SELECT * FROM questions")
        data.map { |datum| Question.new(datum) }
    end

    def self.find_by_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            questions
        WHERE
            id = ?
        SQL
        return nil if question.empty?
        Question.new(question.first)
    end

    def self.find_by_author_id(author_id)
        questions = QuestionsDatabase.instance.execute(<<-SQL, author_id)
        SELECT
            *
        FROM
            questions
        WHERE
            author_id = ?
        SQL
        return nil if questions.empty?
        questions.map { |question| Question.new(question) }
    end

    def author
        User.find_by_id(author_id)
    end

    def authored_replies
        Reply.find_by_user_id(author_id)
    end

    def replies
        Reply.find_by_question_id(id)
    end

    def self.most_followed(n)
        QuestionFollow.most_followed_questions(n)
    end
end