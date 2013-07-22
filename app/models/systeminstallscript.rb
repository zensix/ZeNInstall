class Systeminstallscript < ActiveRecord::Base
	belongs_to  :famille
	validates :name, :presence => true
	
	def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end  
end
