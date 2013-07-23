class Log < ActiveRecord::Base

 def self.search(search)
    if search
      where('message LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
end
