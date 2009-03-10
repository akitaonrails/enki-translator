source :in, {
  :type => :database,
  :target => 'mephisto',
  :table  => 'contents',
  :select => 'contents.*, article_id as post_id',
  :conditions => "type = 'Comment'"
},
[:id, :post_id, :author, :author_url, :author_email, :body, :body_html, :created_at, :updated_at]

class CommentsProcessor < ETL::Processor::RowProcessor
  def process(row)
	  row[:author] ||= ''
	  row[:author_url] ||= ''
	  row[:author_email] ||= ''
		row
  end
end

before_write CommentsProcessor

destination :out, {
  :type     => :database,
  :truncate => true,
	:columns  => [:id, :post_id, :author, :author_url, :author_email, :body, :body_html, :created_at, :updated_at] ,
  :target   => 'enki',
  :table    => 'comments'
}



