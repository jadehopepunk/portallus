# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  DEFAULT_HTML_FIELD_OPTIONS = { "wrap" => "virtual", "rows" => 20 }.freeze unless const_defined?(:DEFAULT_HTML_FIELD_OPTIONS)

  @@written_js_link = false

  def html_field(model_name, field_name, field_data, options = {})
        options = DEFAULT_HTML_FIELD_OPTIONS.merge(options.stringify_keys)
    options['id'] = model_name + '_' + field_name;
    options['name'] = model_name + '[' + field_name + ']';

    script =
      '<script language="javascript" type="text/javascript">' +
      'tinyMCE.init({' +
      'relative_urls : false,' +
      'language    : "en",' +
      'mode        : "exact",' +
      'elements    : "' + options['name'] +'",' +
      'theme       : "advanced",' +
      'width     : "100%",' +
      'theme_advanced_toolbar_location    : "top",' +
      'theme_advanced_buttons3_add_before : "tablecontrols,separator",' +
      'content_css : "/stylesheets/portallus.css",' +
      'plugins : "railsimage"' +
      '});' +
      '</script>'

        script + content_tag("textarea", field_data, options)
  end

  def user?
    !@session[:user].nil?
  end

  def user
    @session[:user]
  end

  def debug_ajax
    return "
      <script>
        Ajax.Responders.register({
        // log the beginning of the requests
        onCreate: function(request, transport) {
        new Insertion.Bottom('debug', '<p><strong>[' + new Date().toString() + '] accessing ' + request.url + '</strong></p>')
        },

        // log the completion of the requests
        onComplete: function(request, transport) {
        new Insertion.Bottom('debug',
        '<p><strong>http status: ' + transport.status + '</strong></p>' +
        '&lt;pre>' + transport.responseText.escapeHTML() + '&lt;/pre>')
        }
        });
      </script>


      <div id=\"debug\">
      </div>
    "
  end

end
