class TagDatabaseSource < ETL::Control::DatabaseSource
  def query
    query = <<-EOS
    SELECT name, 0 as tag_id, id as section_id FROM sections
    UNION
    SELECT name, id as tag_id, 0 as section_id FROM tags
    EOS
  end
end
source :in, {
  :type => TagDatabaseSource,
  :target => 'mephisto',
  :table  => 'tags'
},
[:name, :tag_id, :section_id]

destination :out, {
  :file => 'data/tags.txt'
},
{
  :order => [:id, :name, :tag_id, :section_id],
  :virtual => {
    :id => :surrogate_key,
  }
}

post_process :bulk_import, {
  :file     => 'data/tags.txt',
  :truncate => true,
  :columns  => [:id, :name],
  :target   => 'enki',
  :table    => 'tags'
}
