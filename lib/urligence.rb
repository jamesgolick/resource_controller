module Urligence
  def smart_url(*objects)
    urligence(*objects.push(:url))
  end
  
  def smart_path(*objects)
    urligence(*objects.push(:path))
  end
  
  def hash_for_smart_url(*objects)
    urligence(*objects.unshift(:hash_for).push(:url))
  end
  
  def urligence(*objects)
    objects.reject! { |object| object.nil? }
    
    url_fragments = objects.collect do |obj|
      if obj.is_a? Symbol
        obj
      elsif obj.is_a? Array
        obj.first
      else
        obj.class.name.underscore.to_sym
      end
    end
    
    # invoke method
    send url_fragments.join("_"), *objects.flatten.select { |obj| !obj.is_a? Symbol }
  end
end
