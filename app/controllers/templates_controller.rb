class TemplatesController < BaseController

  def taiwan
    @data = TaiwanImporter.new.read
    render :selects
  end

  def selects_v2; end
end
