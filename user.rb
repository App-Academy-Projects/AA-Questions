require_relative 'questions'

class User
    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end
end