require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
    include Singleton

    def initialize
        super('questions.db')
        self.type_translation = true
        self.results_as_hash = true
    end

end

class User
    attr_accessor :fname, :lname
    def self.all
        user = QuestionsDatabase.instance.execute("SELECT * FROM users")
        user.map { |col| User.new(col) }
    end

    def self.find_by_id(id)
        id = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                users
            WHERE
                id = ?
        SQL
        # id is an array containing a hash with keys as 'options' 
        # [{"id"=>4, "fname"=>"Milner", "lname"=>"Chen"}]
        return nil unless id.length > 0
        User.new(id.first)
    end

    def initialize(options)
        @id = options['id']
        @fname = options['fname']
        @lname = options['lname']
    end

    def create
        raise "#{self} already in database" if @id
        QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname)
            INSERT INTO
                users(fname, lname)
            VALUES
                (?, ?)
        SQL
        @id = QuestionsDatabase.instance.last_insert_row_id
    end

    def update
        raise "#{self} not in database" unless @id
        QuestionsDatabase.instance.execute(<<-SQL, @fname, @lname, @id)
            UPDATE
                users
            SET
                fname = ?, lname = ?
            WHERE
                id = ?
        SQL
    end

end

class Question
    attr_accessor :title, :body, :associated_author_id

    def self.all
        question = QuestionsDatabase.instance.execute("SELECT * FROM questions")
        question.map { |col| Question.new(col) }
    end

    def self.find_by_id(id)
        id = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                questions
            WHERE
                id = ?
        SQL
        return nil unless id.length > 0
        Question.new(id.first)
    end


    # [{"id"=>4, "fname"=>"Milner", "lname"=>"Chen"}]
    def self.find_by_author_id(author_id)
        author_id = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT
                *
            FROM
                questions
            WHERE
                associated_author_id = ?
        SQL
        return nil unless author_id.length > 0
        Question.new(author_id.first)
    end



    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @associated_author_id = options['associated_author_id']
    end

    def create
        raise "#{self} already in database" if @id
        QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @associated_author_id)
            INSERT INTO
                questions(title, body, associated_author_id)
            VALUES
                (?, ?, ?)
        SQL
        @id = QuestionsDatabase.instance.last_insert_row_id
    end

    def update
        raise "#{self} not in database" unless @id
        QuestionsDatabase.instance.execute(<<-SQL, @title, @body, @associated_author_id, @id)
            UPDATE
                questions
            SET
                title = ?, body = ?, associated_author_id = ?
            WHERE
                id = ?
        SQL
    end
end