
# Fix some issue with Capybara and no host found
# See: http://blog.deepwoodsbrigade.com/post/33863795046/missing-host-to-link-to-please-provide-the-host
[ApplicationController, ActionController::Base, ActionView::TestCase::TestController, ActionDispatch::Routing::RouteSet].each do |klass|
   klass.class_eval do
     def default_url_options(options = {})
       {
         host: 'example.com',
         port: Capybara.server_port
       }.merge(options)
     end
   end
end

