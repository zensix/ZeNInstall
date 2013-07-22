class System < ActiveRecord::Base
	belongs_to  :famille
	belongs_to  :ipxescript
	belongs_to  :architecture
	validates :name, :presence => true
	
	def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end  
end
