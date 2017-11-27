class BaseController < ApplicationController
  before_action :set_meta

  def index; end

  def selects
    @data = TaiwanImporter.new.read
    render 'templates/selects'
  end
end
