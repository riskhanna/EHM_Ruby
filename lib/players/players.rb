# /usr/bin/env ruby

class Players < Array
  def sort_by_attribute!(attribute)
    self.sort_by! { |player| [-player.attributes[attributes]] }
  end
  
  def sort_by_attribute!(attribute)
    self.sort_by! { |player| [-player.attributes[attributes]] }
  end

  def sort_by_id!
    self.sort_by! { |player| [player.id] }
  end
  
  def sort_by_name!
    self.sort_by! { |player| [player.name[:last], player.name[:first]] }
  end

  def search(name)
    self.each do |player|
      return player if player.full_name == name
    end
  end

  def rw_s
    Players.new(self.select { |player| player.is_rw? })
  end

  def lw_s
    Players.new(self.select { |player| player.is_lw? })
  end

  def c_s
    Players.new(self.select { |player| player.is_c? })
  end

  def d_s
    Players.new(self.select { |player| player.is_d? })
  end

  def g_s
    Players.new(self.select { |player| player.is_g? })
  end
end
