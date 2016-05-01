task :tag_dreams => :environment do |t, args|
  CSV.foreach("db/csvs/dream_tagging.csv") do |row|
    dream = Dream.find_by_id(row[0])
    tag_name = row[2]
    if tag_name == "Delete"
      dream.destroy
    else
      tag = Tag.find_by_name(tag_name)
      dream.tags << tag
    end
  end
end