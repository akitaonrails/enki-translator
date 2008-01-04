source :in, {
  :type => :database,
  :target => 'mephisto',
  :table  => 'contents',
  :select => 'contents.*, article_id as post_id',
  :conditions => "type = 'Comment'"
},
[:id, :post_id, :author, :author_url, :author_email, :author_openid_authority, :body, :body_html, :created_at, :updated_at]

destination :out, {
  :type     => :database,
  :truncate => true,
  :target   => 'roboblog',
  :table    => 'comments'
}
