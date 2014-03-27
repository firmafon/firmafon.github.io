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
    JSON.pretty_generate(obj)
  end
  def markdown(text)
    @renderer ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    @renderer.render(text)
  end
  def parameter_list(params)
    params.map do |key, desc_or_params|
      "<dt><code>#{key}</code></dt>" +
      if desc_or_params.is_a?(String)
        "<dd>#{markdown desc_or_params}</dd>"
      else
        "<dd><dl>#{parameter_list desc_or_params}</dl></dd>"
      end
    end.join("\n")
  end
  def parameters(params)
    <<-MARKDOWN
**Parameters:**

<dl class="highlight">#{parameter_list params}</dl>
MARKDOWN
  end
  def response(json)
    <<-MARKDOWN
**Response:**

```json
#{pretty_json json}
```
MARKDOWN
  end
end

configure :build do
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash
end

