require_relative './global'

class CareerStats < Array
  

  def consolidated_stats #combines stats from different teams in same season
    consolidated = CareerStats.new

    this.each do |season_stats|
      
    end
    
  end

  def career_high(league, season_type, stat)
    this.select {|x| x.league == league && x.type == season_type}
  end

  def career_totals(league, season_type, stat)



end
