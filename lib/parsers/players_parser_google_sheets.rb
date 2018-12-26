require 'google/apis/sheets_v4'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'
require_relative '../players/player'
require_relative '../players/players'

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

  range = 'Ratings!A2:CB'
  response = service.get_spreadsheet_values(spreadsheet_id, range)
  response.values.each do |row|
    name = {}
    info = {}
    attributes = {}
    ceilings = {}
    
    id = row[header["id"]]
    
    name[:first] = row[header["first name"]]
    name[:last] = row[header["last name"]]
    
    info[:position] = row[header["pos"]]
    info[:team] = row[header["team"]]
    info[:country] = row[header["nat"]]


    if info[:position] == "G"
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

    params = {}
    params[:id] = id
    params[:name] = name
    params[:info] = info
    params[:attributes] = attributes
    params[:ceilings] = ceilings
    players.push Player.new(params)
  end
  
  players
end
