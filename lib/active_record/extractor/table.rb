require "active_record"

class ActiveRecord::Extractor::Table
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def records
    sql  = "SELECT * FROM %s"
    sql << " ORDER BY id" if has_primary_key?

    connection.select_all(sql % name).map do |record|
      ActiveRecord::Extractor::Record.new self, columns, record
    end
  end

  def columns
    @columns ||= connection.columns(name)
  end

  def has_primary_key?
    columns.select { |column| column.name == "id" }
  end

  def fixture_path
    File.expand_path File.join("spec", "fixtures", "#{name}.yml"), Rails.root
  end

  def open
    FileUtils.mkdir_p File.dirname(fixture_path)
    File.open(fixture_path, "wb") do |f|
      yield f
    end
  end

  private

  def connection
    ActiveRecord::Base.connection
  end
end
