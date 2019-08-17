require_relative '../global'

class Manager
  attr_reader :id, :name
  attr_accessor :strategy, :attributes, :info, :scouting_reports

  def initialize(params)
    @id = params[:id]
    @name = params[:name]
    @info = params[:info]
    @attributes = params[:attributes]
    @strategy = params[:strategy]
    @scouting_reports = params[:scouting_reports]
  end

  

end

