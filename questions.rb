require 'sqlite3'
require_relative 'question_db_connection'

class Question
    def initialize(options)
        @id = options['id']
        @title = options['title']
        @year = options['body']
        @playwright_id = options['author_id']
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
end