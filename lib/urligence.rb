module Urligence
  def smart_url(*objects)
    objects.reject! { |object| object.nil? }
    
    # if last arg is a symbol, give him the index path
    collection_action = objects.pop if objects.last.is_a? Symbol
        
    # collect namespaces indicated by symbol
    namespaces = []
    while objects.first.is_a? Symbol do
      namespaces << objects.shift
    end
    
    # build url method invocation 
    url_fragments = []
    url_fragments << namespaces unless namespaces.empty?
    url_fragments << objects.collect { |object| object.class.name.underscore }
    url_fragments << collection_action if collection_action
    url_fragments.flatten!
    
    # invoke method
    send url_fragments.join("_")+"_path", *objects
  end
end
