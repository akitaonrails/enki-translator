source :in, {
  :type => :database,
  :target => 'mephisto',
  :table  => 'contents',
  :conditions => "type = 'Comment'"
},
[:id, :article_id, :author, :author_url, :author_email, :author_openid_authority, :body, :body_html, :created_at, :updated_at, :type]

copy :article_id, :post_id

destination :out, {
  :file => 'data/comments.txt'
}

post_process :bulk_import, {
  :file     => 'data/comments.txt',
  :truncate => true,
  :columns  => [:id, :post_id, :author, :author_url, :author_email, :author_openid_authority, :body, :body_html, :created_at, :updated_at],
  :target   => 'roboblog',
  :table    => 'comments'
}
