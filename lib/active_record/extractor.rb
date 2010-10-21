require "active_record"

class ActiveRecord::Extractor
  IGNORE_TABLES = %w(schema_migrations sessions)

  def initialize
    ActiveRecord::Base.establish_connection
  end

  def tables
    @tables ||= (connection.tables - IGNORE_TABLES).map{ |name| Table.new name }
  end

  def extract
    tables.each do |table|
    end
  end

  private

  def connection
    ActiveRecord::Base.connection
  end
end
