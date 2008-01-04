source :in, {
  :type => :database,
  :target => 'mephisto',
  :table  => 'assigned_sections'
},
[:article_id, :section_id]

source :in, {
  :type => :database,
  :target => 'mephisto',
  :table  => 'taggings',
  :select => 'taggable_id as article_id, tag_id',
  :conditions => "taggable_type = 'Content'"
},
[:article_id, :tag_id]

class SectionTagResolver
  def initialize(type)
    index = {:section => 3, :tag => 2}[type] || raise(ArgumentError.new("Unsupported type: #{type}"))
    @tags = FasterCSV.read("data/tags.txt").reject {|x| x[index] == "0" }.inject({}) {|a, v|
      a.update(v[index] => v[0])
    }
  end

  def resolve(value)
    return "" if value.nil?
    return @tags[value] 
  end
end
transform :section_id, :foreign_key_lookup, :resolver => SectionTagResolver.new(:section)
transform :tag_id, :foreign_key_lookup, :resolver => SectionTagResolver.new(:tag)

class TagIdProcessor < ETL::Processor::RowProcessor
  def process(row)
    row[:tag_id] = row[:section_id] unless row[:section_id].blank?
    row.update(:taggable_type => 'Post')
  end
end

before_write TagIdProcessor

destination :out, {
  :file => 'data/taggings.txt'
},
{
  :order => [:article_id, :tag_id, :taggable_type, :created_at],
  :virtual => {
    :created_at => Time.now.utc
  }
}

post_process :bulk_import, {
  :file     => 'data/taggings.txt',
  :truncate => true,
  :columns  => [:taggable_id, :tag_id, :taggable_type, :created_at],
  :target   => 'roboblog',
  :table    => 'taggings'
}
