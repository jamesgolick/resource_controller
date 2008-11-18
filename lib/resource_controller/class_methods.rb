module ResourceController
  module ClassMethods

    # Use this method in your controller to specify which actions you'd like it to respond to.
    #
    #   class PostsController < ResourceController::Base
    #     actions :all, :except => :create
    #   end
    def actions(*opts)
      config = {}
      config.merge!(opts.pop) if opts.last.is_a?(Hash)

      all_actions = (singleton? ? ResourceController::SINGLETON_ACTIONS : ResourceController::ACTIONS) - [:new_action] + [:new]
      
      actions_to_remove = []
      actions_to_remove += all_actions - opts unless opts.first == :all                
      actions_to_remove += [*config[:except]] if config[:except]
      actions_to_remove.uniq!

      actions_to_remove.each { |action| undef_method(action)}
    end

    def responds_to(*args)
      options = args.extract_options!

      (ACTIONS - [:edit, :new_action] + [:new]).each { |action| setup_action_response_for_format(action, *args) }
    end

    def setup_create_response_for_format(format)
      create.wants.send(format) { render format => object, :status => :created, :location => object_url }
      create.fails.wants.send(format) { render format => object.errors, :status => :unprocessable_entity }
    end

    def setup_index_response_for_format(format)
      index.wants.send(format) { render format => collection, :status => :ok }
    end

    def setup_show_response_for_format(format)
      show.wants.send(format) { render format => object, :status => :ok }
    end

    def setup_update_response_for_format(format)
      update.wants.send(format) { render :nothing => true, :status => :ok }
      update.fails.wants.send(format) { render format => object.errors, :status => :unprocessable_entity }
    end

    def setup_new_response_for_format(format)
      new_action.wants.send(format) { render format => object, :status => :ok }
    end

    def setup_destroy_response_for_format(format)
      destroy.wants.send(format) { render :nothing => true, :status => :ok }
      destroy.fails.wants.send(format) { render :nothing => true, :status => :not_found }
    end

    def setup_action_response_for_format(action, *formats)
      formats.each do |format|
        send("setup_#{action}_response_for_format", format)
      end
    end
    
  end
end
