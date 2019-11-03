require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require_relative '../players/player'
require_relative '../players/players'
require_relative '../players/player_attributes'
require_relative '../teams/team'
require_relative '../managers/manager'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
APPLICATION_NAME = 'Google Sheets API EHM Players Parser'.freeze
CREDENTIALS_PATH = 'credentials.json'.freeze
# The file token.yaml stores the user's access and refresh tokens, and is
# created automatically when the authorization flow completes for the first
# time.
TOKEN_PATH = 'token.yaml'.freeze
SCOPE = Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
def authorize
  client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
  user_id = 'default'
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    url = authorizer.get_authorization_url(base_url: OOB_URI)
    puts 'Open the following URL in the browser and enter the ' \
         "resulting code after authorization:\n" + url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI
    )
  end
  credentials
end


def initialize_api
  service = Google::Apis::SheetsV4::SheetsService.new
  service.client_options.application_name = APPLICATION_NAME
  service.authorization = authorize
  service
end

def parse_players_from_google_sheet
  service = initialize_api
  spreadsheet_id = '16Sf-359Kqx4gCW4qLLxiYEEUy5BYMsMe8CveZ3F3BQc'
  header_range = 'Ratings!A1:CB1'
  header_response = service.get_spreadsheet_values(spreadsheet_id, header_range)
  header = {}
  header_response.values[0].each_with_index do |att,i|
    header[att.downcase] = i
  end

  players = Players.new
  players_hash = {}

  range = 'Ratings!A2:CC'
  response = service.get_spreadsheet_values(spreadsheet_id, range)
  response.values.each do |row|
    name = {}
    info = {}
    
    id = row[header["id"]].to_i
    
    name[:first] = row[header["first name"]]
    name[:last] = row[header["last name"]]
    
    info[:position] = row[header["pos"]].downcase.to_sym
    info[:rights] = row[header["team"]]
    info[:team] = info[:rights] if row[header["league"]] == "NHL"
    info[:country] = row[header["nat"]]
    info[:chemistry] = {}

    attributes = PlayerAttributes.new({}, info[:position])
    ceilings = {}

    if info[:position] == :g
      attributes[:glove] = row[header["shot / glove"]].to_i
      attributes[:blocker] = row[header["play / block"]].to_i
      attributes[:pads] = row[header["chck / pads"]].to_i
      attributes[:angles] = row[header["mark / angles"]].to_i
      attributes[:agility] = row[header["hit / agil"]].to_i
      attributes[:rebounds] = row[header["fos / rbnds"]].to_i
    else
      attributes[:shooting] = row[header["shot / glove"]].to_i
      attributes[:playmaking] = row[header["play / block"]].to_i
      attributes[:checking] = row[header["chck / pads"]].to_i
      attributes[:marking] = row[header["mark / angles"]].to_i
      attributes[:hitting] = row[header["hit / agil"]].to_i
      attributes[:faceoffs] = row[header["fos / rbnds"]].to_i
      begin
        info[:position_adjustments] = {
          :c => row[header["c ability"]].to_i || 1,
          :rw => row[header["rw ability"]].to_i || 1,
          :lw => row[header["lw ability"]].to_i || 1,
          :rd => row[header["rd ability"]].to_i || 1,
          :ld => row[header["ld ability"]].to_i || 1
        }
      rescue
        warn name
        warn row[header["C Ability"]]
        warn row[header["RW Ability"]]
      end
    end
    
    attributes[:potential] = row[header["pot"]].to_i
    attributes[:consistency] = row[header["con"]].to_i
    attributes[:stickhandling] = row[header["stha"]].to_i
    attributes[:skating] = row[header["skate"]].to_i
    attributes[:endurance] = row[header["endur"]].to_i
    attributes[:penalty] = row[header["pen"]].to_i
    attributes[:leadership] = row[header["ldr"]].to_i
    attributes[:strength] = row[header["str"]].to_i
    attributes[:clutch] = row[header["clutch"]].to_i
    attributes[:fight] = row[header["fight"]].to_i
    attributes[:injury_resistance] = row[header["inj res"]].to_i
    attributes[:greed] = row[header["greed"]].to_i
    attributes[:energy] = 100

    params = {}
    params[:id] = id
    params[:name] = name
    params[:info] = info
    params[:attributes] = attributes
    params[:ceilings] = ceilings
    player = Player.new(params)
    players.push(player)
    players_hash[id] = player
  end

  header_range = 'Chemistry!A1:G1'
  header_response = service.get_spreadsheet_values(spreadsheet_id, header_range)
  header = {}
  header_response.values[0].each_with_index do |att,i|
    header[att.downcase] = i
  end

  range = 'Chemistry!A2:G'
  response = service.get_spreadsheet_values(spreadsheet_id, range)
  response.values.each do |row|
    player1 = players_hash[row[header["id1"]].to_i]
    player2 = players_hash[row[header["id2"]].to_i]
    score = row[header["chemistry"]].to_i
    unless !player1 || !player2
      player1.info[:chemistry][player2] = score
      player2.info[:chemistry][player1] = score
    end
  end
  
  [players, players_hash]
end



def get_teams(players)
  teams = {}

  det_params = {}
  det_params[:name] = "Detroit Red Wings"
  det_params[:abbreviation] = "DET"
  det_params[:league] = "NHL"
  det_params[:rights] = players.select {|x| x.info[:rights] == det_params[:abbreviation]}
  
  roster = {}
  roster[:skaters] = players.select {|x| x.info[:team] == det_params[:abbreviation] && x.is_skater?}
  roster[:goalies] = players.select {|x| x.info[:team] == det_params[:abbreviation] && x.is_g?}
  roster[:injured] = []
  roster[:suspended] = []
  det_params[:roster] = roster

  hc = Manager.new( { 
    :id => 1, 
    :name =>  "Scotty Bowman",
    :strategy => {
      :ev_1 => {:tactic => :passing_plays, :shift_length => 70},
      :ev_2 => {:tactic => :passing_plays, :shift_length => 70},
      :ev_3 => {:tactic => :neutral_zone_trap, :shift_length => 40},
      :ev_4 => {:tactic => :neutral_zone_trap, :shift_length => 20}
    }
  })

  det_params[:management] = { :coaches => { :head_coach => hc } }

  det = Team.new(det_params)
  teams[:det] = det



  que_params = {}
  que_params[:name] = "Quebec Nordiques"
  que_params[:abbreviation] = "QUE"
  que_params[:league] = "NHL"
  que_params[:rights] = players.select {|x| x.info[:rights] == que_params[:abbreviation]}
  
  roster = {}
  roster[:skaters] = players.select {|x| x.info[:team] == que_params[:abbreviation] && x.is_skater?}
  roster[:goalies] = players.select {|x| x.info[:team] == que_params[:abbreviation] && x.is_g?}
  roster[:injured] = []
  roster[:suspended] = []
  que_params[:roster] = roster

  hc = Manager.new( { 
    :id => 2, 
    :name =>  "Marc Crawford",
    :strategy => {
      :ev_1 => {:tactic => :passing_plays, :shift_length => 80},
      :ev_2 => {:tactic => :passing_plays, :shift_length => 70},
      :ev_3 => {:tactic => :hit_and_grind, :shift_length => 30},
      :ev_4 => {:tactic => :neutral_zone_trap, :shift_length => 20}
    }
  })

  que_params[:management] = { :coaches => { :head_coach => hc } }

  que = Team.new(que_params)
  teams[:que] = que



  nyr_params = {}
  nyr_params[:name] = "New York Rangers"
  nyr_params[:abbreviation] = "NYR"
  nyr_params[:league] = "NHL"
  nyr_params[:rights] = players.select {|x| x.info[:rights] == nyr_params[:abbreviation]}
  
  roster = {}
  roster[:skaters] = players.select {|x| x.info[:team] == nyr_params[:abbreviation] && x.is_skater?}
  roster[:goalies] = players.select {|x| x.info[:team] == nyr_params[:abbreviation] && x.is_g?}
  roster[:injured] = []
  roster[:suspended] = []
  nyr_params[:roster] = roster

  hc = Manager.new( { 
    :id => 3, 
    :name =>  "Colin Campbell",
    :strategy => {
      :ev_1 => {:tactic => :passing_plays, :shift_length => 80},
      :ev_2 => {:tactic => :passing_plays, :shift_length => 50},
      :ev_3 => {:tactic => :dump_and_chase, :shift_length => 40},
      :ev_4 => {:tactic => :hit_and_grind, :shift_length => 30}
    }
  })

  nyr_params[:management] = { :coaches => { :head_coach => hc } }

  nyr = Team.new(nyr_params)
  teams[:nyr] = nyr


  nj_params = {}
  nj_params[:name] = "New Jersey Devils"
  nj_params[:abbreviation] = "NJ"
  nj_params[:league] = "NHL"
  nj_params[:rights] = players.select {|x| x.info[:rights] == nj_params[:abbreviation]}
  
  roster = {}
  roster[:skaters] = players.select {|x| x.info[:team] == nj_params[:abbreviation] && x.is_skater?}
  roster[:goalies] = players.select {|x| x.info[:team] == nj_params[:abbreviation] && x.is_g?}
  roster[:injured] = []
  roster[:suspended] = []
  nj_params[:roster] = roster

  hc = Manager.new( { 
    :id => 4, 
    :name =>  "Jacques Lemaire",
    :strategy => {
      :ev_1 => {:tactic => :neutral_zone_trap, :shift_length => 60},
      :ev_2 => {:tactic => :neutral_zone_trap, :shift_length => 60},
      :ev_3 => {:tactic => :passing_plays, :shift_length => 50},
      :ev_4 => {:tactic => :neutral_zone_trap, :shift_length => 30}
    }
  })

  nj_params[:management] = { :coaches => { :head_coach => hc } }

  nj = Team.new(nj_params)
  teams[:nj] = nj


  buf_params = {}
  buf_params[:name] = "Buffalo Sabres"
  buf_params[:abbreviation] = "BUF"
  buf_params[:league] = "NHL"
  buf_params[:rights] = players.select {|x| x.info[:rights] == buf_params[:abbreviation]}
  
  roster = {}
  roster[:skaters] = players.select {|x| x.info[:team] == buf_params[:abbreviation] && x.is_skater?}
  roster[:goalies] = players.select {|x| x.info[:team] == buf_params[:abbreviation] && x.is_g?}
  roster[:injured] = []
  roster[:suspended] = []
  buf_params[:roster] = roster

  hc = Manager.new( { 
    :id => 5, 
    :name =>  "Ted Nolan",
    :strategy => {
      :ev_1 => {:tactic => :passing_plays, :shift_length => 70},
      :ev_2 => {:tactic => :neutral_zone_trap, :shift_length => 50},
      :ev_3 => {:tactic => :neutral_zone_trap, :shift_length => 50},
      :ev_4 => {:tactic => :hit_and_grind, :shift_length => 30}
    }
  })

  buf_params[:management] = { :coaches => { :head_coach => hc } }

  buf = Team.new(buf_params)
  teams[:buf] = buf


  pit_params = {}
  pit_params[:name] = "Pittsburgh Penguins"
  pit_params[:abbreviation] = "PIT"
  pit_params[:league] = "NHL"
  pit_params[:rights] = players.select {|x| x.info[:rights] == pit_params[:abbreviation]}
  
  roster = {}
  roster[:skaters] = players.select {|x| x.info[:team] == pit_params[:abbreviation] && x.is_skater?}
  roster[:goalies] = players.select {|x| x.info[:team] == pit_params[:abbreviation] && x.is_g?}
  roster[:injured] = []
  roster[:suspended] = []
  pit_params[:roster] = roster

  hc = Manager.new( { 
    :id => 6, 
    :name =>  "Eddie Johnston",
    :strategy => {
      :ev_1 => {:tactic => :passing_plays, :shift_length => 70},
      :ev_2 => {:tactic => :passing_plays, :shift_length => 70},
      :ev_3 => {:tactic => :passing_plays, :shift_length => 50},
      :ev_4 => {:tactic => :dump_and_chase, :shift_length => 10}
    }
  })

  pit_params[:management] = { :coaches => { :head_coach => hc } }

  pit = Team.new(pit_params)
  teams[:pit] = pit

  teams.each do |k,team|
    team.make_lines
  end

  teams
end

