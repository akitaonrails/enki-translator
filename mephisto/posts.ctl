source :in, {
  :type => :database,
  :target => 'mephisto',
  :table  => 'contents',
  :join  => 'INNER JOIN assigned_sections ON assigned_sections.article_id = contents.id',
  :select => 'contents.*, permalink as slug, comments_count as approved_comments_count',
  :conditions => ["type = 'Article'", "section_id = 1"]
},
[:id, :title, :slug, :excerpt, :excerpt_html, :body, :body_html, :published_at, :created_at, :updated_at, :approved_comments_count]

class PostsProcessor < ETL::Processor::RowProcessor
  def process(row)
    row[:body] = row[:body].gsub(/<macro:code lang="(.*)">/, '--- \1').gsub(/<\/macro:code>/, '---')
    row.except(:permalink, :comments_count)
  end
end

before_write PostsProcessor

destination :out, {
  :type => :database,
  :truncate => true,
  :columns  => [:id, :title, :slug, :excerpt, :excerpt_html, :body, :body_html, :published_at, :created_at, :updated_at, :approved_comments_count],
  :target   => 'enki',
  :table    => 'posts'
}

