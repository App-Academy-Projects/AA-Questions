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
end