class JsCompiler
  class << self

    def compile(name, compress: true, controller: nil, assigns: {}, view_path: nil)
      assigns = default_assigns(name).merge(assigns)
      controller ||= default_controller(name)
      view_path ||= default_view_path(name)
      view = ActionView::Base.new(controller.view_paths, assigns)
      code = view.render(file: view_path)
      compress ? Uglifier.compile(code) : code
    end

    def to_file(name, compile_params: {})
      dist = Rails.root.join('public', 'dist', "#{name.to_s.downcase}.min.js")
      IO.write(dist, compile(name, compile_params.symbolize_keys))
      dist = Rails.root.join('public', 'dist', "#{name.to_s.downcase}.js")
      IO.write(dist, compile(name, compile_params.symbolize_keys.merge(compress: false)))
    end

    private

    def importer(name)
      "#{name.to_s.camelize}Importer".constantize.new
    end

    def default_controller(_name)
      TemplatesController
    end

    def default_assigns(name)
      {
        data: importer(name).read
      }
    end

    def default_view_path(_name)
      'templates/selects.js.erb'
    end
  end

end
