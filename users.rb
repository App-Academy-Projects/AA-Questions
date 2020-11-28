require_relative 'questions'

class User
    attr_accessor :id, :fname, :lname
    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def save
        if id
            QuestionsDatabase.instance.execute(<<-SQL, fname, lname, id)
            UPDATE
                users
            SET
                fname = ?, lname = ?
            WHERE
                users.id = ?
            SQL
        else
            QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
            INSERT INTO
                users (fname, lname)
            VALUES
                (?, ?)
            SQL
            @id = QuestionsDatabase.last_insert_row_id
        end
    end

    def self.find_by_id(id)
        user = QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            *
        FROM
            users
        WHERE
            id = ?
        SQL
        return nil if user.empty?
        User.new(user.first)
    end

    def self.find_by_name(fname, lname)
        users = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
        SELECT
            *
        FROM
            users
        WHERE
            fname = ? AND lname = ?
        SQL
        return nil if users.empty?
        users.map { |user| User.new(user) }
    end

    def authored_questions
        return Question.find_by_author_id(id)
    end

    def followed_questions
        QuestionFollow.followed_questions_for_user_id(id)
    end

    def liked_questions
        QuestionLike.liked_questions_for_user_id(id)
    end

    def average_karma
        QuestionsDatabase.instance.execute(<<-SQL, id)
        SELECT
            CAST(COUNT(question_likes.id) AS FLOAT) / COUNT(DISTINCT(questions.id)) AS avg_karma
        FROM
            questions
        LEFT OUTER JOIN
            question_likes ON questions.id = question_likes.question_id
        WHERE
            questions.author_id = ?
        SQL
    end
end