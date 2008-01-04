source :in, {
  :type => :database,
  :target => 'mephisto',
  :table  => 'contents'
},
[:id, :title, :permalink, :body, :body_html, :created_at, :updated_at, :comments_count, :section_id, :type]

copy :permalink, :slug
copy :comments_count, :approved_comments_count

destination :out, {
  :file => 'data/posts.txt',
  :condition => lambda {|row| row[:type] == 'Article'}
}

post_process :bulk_import, {
  :file     => 'data/posts.txt',
  :truncate => true,
  :columns  => [:id, :title, :slug, :body, :body_html, :created_at, :updated_at, :approved_comments_count],
  :target   => 'roboblog',
  :table    => 'posts'
}
