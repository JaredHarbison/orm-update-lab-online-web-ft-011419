require_relative "../config/environment.rb"

class Student
  attr_reader :id 
  attr_accessor :name, :grade 

  def initialize(id = nil, name, grade)
    @id = id
    @name = name
    @grade = grade 
  end 
  
  def self.create_table
    sql =  <<-SQL
      CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade INTEGER
        )
        SQL
    DB[:conn].execute(sql)
  end 
  
  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end 
  
  def save 
    if self.id
      self.update
    else
      sql = <<-SQL 
      INSERT INTO students (name, grade)
      VALUES (?, ?) 
      SQL
      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end 
  end 

  def update
    sql = "UPDATE students SET name = ?, grade = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end
  
  def self.create(name, grade)
    student = Student.new(name, grade)
    student.save
    student
  end 
  
  def self.new_from_db(row)
    new_student = self.new 
    new_student.id 
    new_student.name 
    new_student.grade 
    new_student
  end 
    
  def self.find_by_name
    
  end 
  
  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
