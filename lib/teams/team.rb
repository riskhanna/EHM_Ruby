require_relative '../global'
require 'date'


class Team
  attr_reader :name, :league, :abbreviation
  attr_accessor :id, :roster, :contracts, :rights, :management, :farm, :lines, :coach_assignments, :staff_assignments, :schedule

  def initialize(params)
    @name = params[:name]
    @league = params[:league]
    @id = params[:id]
    @roster = params[:roster]
    @abbreviation = params[:abbreviation]
    @contracts = params[:contracts]
    @rights = params[:rights]
    @management = params[:management]
    @farm = params[:farm]
    @lines = params[:lines] || {}
  end

  def debug_lines
    puts @lines.map {|k,v| [k, v.map {|pos,player| [pos, player.full_name]}.to_h] }.to_h
  end

  def make_lines
    @lines = {}
    @lines.merge! make_even_strength_lines
    #@lines.merge! make_power_play_lines
    #@lines.merge! make_penalty_kill_lines
    @lines.merge! make_goalie_lines
  end

  def make_even_strength_lines
    line_ranks = {
      :ev_1 => {:lw => [], :c => [], :rw => [], :ld => [], :rd => []},
      :ev_2 => {:lw => [], :c => [], :rw => [], :ld => [], :rd => []},
      :ev_3 => {:lw => [], :c => [], :rw => [], :ld => [], :rd => []},
      :ev_4 => {:lw => [], :c => [], :rw => []}
    }

    final_lines = {
      :ev_1 => {},
      :ev_2 => {},
      :ev_3 => {},
      :ev_4 => {}
    }

    (0..17).each do |x|
      populate_line_ranks(line_ranks, final_lines)
      append_largest_delta_to_lines(line_ranks, final_lines) 
      clear_line_ranks(line_ranks)
    end

    final_lines
  end


  def populate_line_ranks(line_ranks, final_lines)
    used_players = []
    final_lines.each do |line, positions|
      used_players += positions.values
    end

    line_ranks.each do |line, positions|
      tactic = head_coach.strategy[line][:tactic]
      positions.each do |position, ranks|
        (roster[:skaters] - used_players).each do |skater|
          # position adjustments added first to keep that position
          # coach_perceived_attributes = skater.position_adjusted_attributes(position) + head_coach.scouting_reports[skater] + skater.teammate_adjusted_attributes(final_lines[line].values)
          coach_perceived_attributes = skater.position_adjusted_attributes(position) + skater.attributes + skater.teammate_adjusted_attributes(final_lines[line].values)
          ### TODO: factor in energy, depending on if its a big game or regular game
          rank = get_ev_lineup_score(position, tactic, coach_perceived_attributes) * (head_coach.strategy[line][:shift_length] - 5) / 100.0 
          ranks.push( {skater => rank} )
        end
        ranks.sort_by! { |x| x[x.keys.first] }.reverse!
      end
    end
  end


  def append_largest_delta_to_lines(line_ranks, final_lines)
    line, position = get_max_line_rank_delta(line_ranks)
    player = line_ranks[line][position].first.keys.first
    #warn player.full_name
    final_lines[line][position] = player
    line_ranks[line].delete(position)
    #warn final_lines.map {|k,v| [k, v.map {|pos,player| [pos, player.full_name]}.to_h] }.to_h
  end


  def clear_line_ranks(line_ranks)
    line_ranks.each do |line, positions|
      positions.each do |position, ranks|
        line_ranks[line][position] = []
      end
    end
  end


  def get_ev_lineup_score(position, tactic, coach_perceived_attributes)
    attribute_weights = GLOBAL::EV_LINE_TACTICS[tactic][position]
    score = 0
    attribute_weights.each do |attribute, weight|
      score += coach_perceived_attributes[attribute] * weight / 100.0
    end
    (3*score + coach_perceived_attributes.overall)/4
  end


  def get_max_line_rank_delta(line_ranks)
    max_delta = -1
    max_delta_line = nil
    max_delta_position = nil
    h = {}
    line_ranks.each do |line, positions|
      h[line] = {}
      positions.each do |position, ranks|
        first_rank = ranks[0].values.first || 0
        second_rank = ranks[1].values.first || 0
        third_rank = ranks[2].values.first || 0
        fourth_rank = ranks[3].values.first || 0
        h[line][position] = (first_rank - second_rank) + (first_rank - third_rank)/2 + (first_rank - fourth_rank)/4
        if h[line][position] > max_delta
          max_delta = h[line][position]
          max_delta_line = line
          max_delta_position = position
        end
      end
    end
    #warn h
    [max_delta_line, max_delta_position]
  end

  def make_power_play_lines
    rank = {
      :pp_1 => {:lw => [], :c => [], :rw => [], :ld => [], :rd => []},
      :pp_2 => {:lw => [], :c => [], :rw => [], :ld => [], :rd => []}
    }
  
  end
  
  
  def make_penalty_kill_lines
    rank = {
      :sh_1 => {:lw => [], :c => [], :ld => [], :rd => []},
      :sh_2 => {:lw => [], :c => [], :ld => [], :rd => []}
    }
  end
  
  
  def make_goalie_lines
    ranks = []
    roster[:goalies].each do |goalie|
      coach_perceived_overall = goalie.attributes.overall
      #coach_perceived_overall = goalie_coach.scouting_reports[goalie].overall
      next_game_big_modifier = (next_game && next_game.is_big_game?) ? (goalie.attributes[:energy] + 100)/200 : goalie.attributes[:energy]/100
      second_of_back_to_back_big_modifier = (upcoming_back_to_back? && game_after_next.is_big_game?) ? make_backup_more_likely_to_play : 1 #TODO make_backup_more_likely_to_play
      ranks.push( {goalie => (coach_perceived_overall * next_game_big_modifier * second_of_back_to_back_big_modifier)} )
    end
    ranks.sort_by! { |x| x[x.keys.first] }.reverse!
    { :goalies => { :starter => ranks[0].keys.first, :backup => ranks[1].keys.first}}
  end

  
  def next_game
    #look at @schedule, find the first game that does not have a result
  end

  def game_after_next
    #look at @schedule, find the second game that does not have a result
  end

  def date_diff_next_two_games
    !game_after_next || !next_game ? nil : game_after_next.date - next_game.date
  end

  def upcoming_back_to_back?
    date_diff_next_two_games == 1
  end

  def head_coach
    management[:coaches][:head_coach]
  end

  def offense_coach
    management[:coaches][:head_coach]
  end

  def defense_coach
    management[:coaches][:head_coach]
  end

  def goalie_coach
    coach_assignments[:goalie]
  end

  def power_play_coach
    coach_assignments[:power_play]
  end

  def penalty_kill_coach
    coach_assignments[:penalty_kill]
  end

  def fitness_coach
    coach_assignments[:fitness]
  end
end
