class Product < ActiveRecord::Base
	has_many :line_items
	validates :title, :description, :image_url, :presence => true
	validates :title, :uniqueness =>true
	validates :price, :numericality => {:greater_than_or_equal_to => 0.05}
	validates :price, :format => {
		:with		=> %r{^\d*\.\d[5]?$}
	}
	validates :image_url, :format => {
		:with		=> %r{\.(gif|jpg|png)$}i,
		:message	=> 'must be a URL for GIF, JPG or PNG image.'
	}
	
	before_destroy :ensure_not_referenced_by_any_line_item
	
	private
	# ensure that there are no line items referencing this product
		def ensure_not_referenced_by_any_line_item
			if line_items.empty?
				return true
			else
				errors.add(:base, 'Line Items present')
				return false
			end
		end
	
end
