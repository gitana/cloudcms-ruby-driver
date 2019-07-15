module Cloudcms
    class Node
        attr_accessor :driver
        attr_accessor :data
        attr_accessor :platform
        attr_accessor :project
        attr_accessor :repository
        attr_accessor :branche

        def initialize(driver, platform, project, repository, branch, data)
            @driver = driver
            @data = data
            @platform = platform
            @project = project
            @repository = repository
            @branch = branch
            
            self.reload
            
            return self
        end

        def reload()
            response = @driver.connection.request :get, @driver.config['baseURL'] + "/repositories/#{@repository.data['_doc']}/branches/#{@branch.data['_doc']}/nodes/#{@data['_doc']}?metadata=true&full=true"
            @data = response.parsed
            return self
        end

        def update()
            response = @driver.connection.request :put, @driver.config['baseURL'] + "/repositories/#{@repository.data['_doc']}/branches/#{@branch.data['_doc']}/nodes/#{@data['_doc']}", 
                :headers => {'Content-Type': 'application/json'}, 
                :body => @data.to_json
            return self
        end

        def delete()
            response = @driver.connection.request :delete, @driver.config['baseURL'] + "/repositories/#{@repository.data['_doc']}/branches/#{@branch.data['_doc']}/nodes/#{@data['_doc']}"
            return
        end
    end
end
