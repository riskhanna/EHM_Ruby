#! /user/bin/env ruby

class PlayerAttributes < Hash
  attr_accessor :position  

  def initialize(hash, position)
    @position = position
    hash.each do |k,v|
      self[k] = v
    end
  end

  def overall
    if position == :g
      goalie_overall
    else
      skater_overall
    end
  end


  def goalie_overall
    (1.5*self[:consistency] + self[:glove] + self[:blocker] + self[:pads] + self[:angles] + self[:agility] + self[:rebounds] + self[:endurance]/2.0 + self[:skating]/2.0 + self[:stickhandling]/2.0 + self[:strength]/2.0 + self[:leadership]/4.0 + self[:clutch]/4.0) / 10.0 - 1
  end


  def skater_overall
    total = 0.0
    
    if offense_ability > defense_ability
      if position == :d
        total += 3.0*offense_ability + 3.0*defense_ability
      else
        total += 4.5*offense_ability + 1.5*defense_ability
      end
    else
      if position == :d
        total += 1.5*offense_ability + 4.5*defense_ability
      else
        total += 3.0*offense_ability + 3.0*defense_ability
      end
    end

    total += self[:consistency] + self[:skating] + self[:strength] + self[:endurance]/2.0 + self[:leadership]/4.0 + self[:clutch]/4.0
    
    total / 10.0 - 1
  end


  def offense_ability
    (self[:shooting] + self[:playmaking] + self[:stickhandling]) / 3.0
  end


  def defense_ability
    (self[:marking] + self[:checking] + self[:hitting]) / 3.0
  end


  def +(other)
    h = {}
    attributes = (self.keys + other.keys).unique
    attributes.each do |attribute|
      h[attribute] = (self[attribute] || 0) + (other[attribute] || 0)
    end
    PlayerAttributes.new(h, self.position)
  end

  
  def +=(other)
    self = (self + other)
  end
end

