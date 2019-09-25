class Entry < ActiveRecord::Base
  belongs_to :category
  has_many :comments
  validates_presence_of :title
  validates_presence_of :text
  
  def to_param
    "#{id}-#{title.gsub(/[^a-z1-9]+/i, '-')}"
  end
  
  def saneText()
     text.gsub(/\n/, '<br>')
 	end
 	
 	def summaryText()
		text.gsub(/<\/?[^>]*>/, "")[0..500]
	end
end
