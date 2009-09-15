# Let My Controller Go

This is a very simple plugin. Its sole purpose is to make current controller object available globabbly.

## Getting Real

Yeah, I know, MVC is the "Only True Way&#0153;". But sometimes, just sometimes, you need your `link_to` or html helpers working in the model.

For example, sometimes the cleanest way to implement something is to have `to_html` in the model (widgets anyone?).
Doing this will most probably require generating some urls, and you need a controller for that.
Usually I solved this by passing controller to the to_html function, but it always felt wrong.

Another example is when you are working on an API. You somtimes would like to have an option to add actual URIs of related services inside an xml.
Like in
    <articles>
        <article>
            <title>Let my controller go</title>
            <href>http://example.com/articles/123</href>
            <created_at>2009-05-24T19:09:06Z</created_at>
        </article>
    </articles>

Now how will you implement that? It would be nice if `@articles.to_xml` just worked, but then how will you generate the href url?
`url_for` is not available in models.

Solution? just make it global and let the purists tear their hairs out! :)

This plugin solves the issues above by making the current controller available from a global function `current_controller`.
(actually it uses Thread local storage, so it will work even in multithreaded Rails environment)

## Installation

    script/plugin install git://github.com/astrails/let_my_controller_go.git

OR

    braid add -p git://github.com/astrails/let_my_controller_go.git

## Usage

When the plugin is installed you can implement the above as

    class Article < ActiveRecord::Base
      def href
        current_controller.url_for(self)
      end
      
      def to_xml(opts = {})
         super opts.merge(:methods => :href, :only => [:title, :created_at])
      end
    end

Then `Articles.all.to_xml` will produce what you need (when running in a context of a web request, i.e. it won't work from the console).

## Sources

Sources are at [GitHub](http://github.com/astrails/let_my_controller_go).

