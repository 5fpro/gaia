class TemplatesController < BaseController

  def taiwan
    @data = TaiwanImporter.new.read
    render :selects
  end
end
