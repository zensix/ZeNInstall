class Projectionscript < ActiveRecord::Base
	validates :name, :presence => true
	
	def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end  
end
