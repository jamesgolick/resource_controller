module Urligence
  def smart_url(*objects)
    objects.reject! { |object| object.nil? }
    
    url_fragments = objects.collect do |obj|
      unless obj.is_a? Symbol
        obj.class.name.underscore.to_sym
      else
        obj
      end
    end
    
    # invoke method
    send url_fragments.join("_")+"_path", *objects.select { |obj| !obj.is_a? Symbol }
  end
end
