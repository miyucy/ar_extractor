namespace :db do
  namespace :fixtures do
    desc "Extract DB to YAML fixtures."
    task :extract => :environment do
      extractor = ActiveRecord::Extractor.new
      extractor.tables.each do |table|
        table.open do |f|
          table.records.each do |record|
            f.write record.to_s
          end
        end
      end
    end
  end
end
