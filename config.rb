compass_config do |config|
  config.add_import_path "../bower_components"
  # Set this to the root of your project when deployed:
  config.http_path = "/"
  config.css_dir = "stylesheets"
  config.sass_dir = "stylesheets"
  config.images_dir = "images"
  config.javascripts_dir = "javascripts"
end

set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

set :markdown_engine, :redcarpet
set :markdown, fenced_code_blocks: true, smartypants: true, footnotes: true, autolink: true

after_configuration do
  bower_dir = JSON.parse(IO.read("#{root}/.bowerrc"))["directory"]
  Dir[File.join(bower_dir, '*')].each do |file|
    sprockets.append_path File.join("../#{file}")
  end
end

activate :livereload
activate :directory_indexes
activate :syntax, line_numbers: false

helpers do
  def resource(key)
    JSON.parse(open("./data/v2/#{key}.json").read)
  end
  def pretty_json(obj)
    JSON.pretty_generate(obj) +
      "\n"
  end
  def markdown(text)
    @renderer ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    @renderer.render(text)
  end
  def parameters(params)
    content_tag :dl do
      params.map do |key, desc|
        content_tag(:dt, content_tag(:code, key)) +
        content_tag(:dd, markdown(desc))
      end
    end
  end
end

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
end

