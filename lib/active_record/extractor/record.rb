require "active_record"

class ActiveRecord::Extractor::Record
  def initialize(table, columns, record)
    @table, @columns, @record = table, columns, record
  end

  def to_s
    "".tap do |str|
      str << if @table.has_primary_key?
               "#{@table.name}_#{@record["id"]}:"
             else
               "-"
             end
      str << "\n"
      @columns.each do |column|
        next unless @record[column.name]
        if string? column
          str << case
                 when blankline?(column, @record)
                   blankline(column, @record)
                 when multiline?(column, @record)
                   multiline(column, @record)
                 else
                   oneline(column, @record)
                 end
        else
          str << "  #{column.name}: #{@record[column.name]}"
        end
        str << "\n"
      end
    end
  end

  def string?(column)
    column.type == :string or column.type == :text
  end

  def blankline?(column, record)
    record[column.name].blank?
  end

  def blankline(column, record)
    "  #{column.name}: \"\""
  end

  def multiline?(column, record)
    !!(record[column.name] =~ /\n/)
  end

  def multiline(column, record)
    "".tap do |str|
      style = record[column.name] =~ /\n\z/ ? '|' : '|-'
      str << "  #{column.name}: #{style}"
      str << "\n"
      str << record[column.name].each_line.map{ |line| "    " << line.rstrip }.join("\n")
    end
  end

  def oneline(column, record)
    "  #{column.name}: #{record[column.name]}"
  end
end
