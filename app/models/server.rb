class Server < ActiveRecord::Base
	belongs_to  :architecture
	belongs_to  :etat
	belongs_to  :sites
	belongs_to  :systems
	belongs_to  :postinstallscripts
	belongs_to  :systeminstallscripts
	validates :name, :presence => true

	def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end  
end
