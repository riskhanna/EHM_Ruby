require_relative './global'

class SeasonStats
  attr_accessor :season, :league, :type, :team, :teams, :stats
  
  def initialize(params)
    @season = params[:season]
    @league = params[:league]
    @type = params[:type]
    @team = params[:team]
    @teams = params[:teams] # only for consolidated season stats
    @stats = params[:stats]
  end

  def consolidatable?(season_stats)
    this.season == season_stats.season && 
      this.league == season_stats.league &&
      this.type == season_stats.type
  end

end
