require 'cloudcms/node'

module Cloudcms
    class Branch
        attr_accessor :driver
        attr_accessor :data
        attr_accessor :platform
        attr_accessor :project
        attr_accessor :repository
        attr_accessor :branchesByTitle
        attr_accessor :branchesById
        attr_accessor :branches
        attr_accessor :master

        def initialize(driver, platform, project, repository, data)
            @driver = driver
            @data = data
            @platform = platform
            @project = project
            @repository = repository
            
            return self
        end

        def query_nodes(query = {}, skip = 0, limit = 25)
            nodes = Array.new
            response = @driver.connection.request :post, @driver.config['baseURL'] + "/repositories/#{@repository.data['_doc']}/branches/#{@data['_doc']}/nodes/query?metadata=true&full=true&skip=#{skip}&limit=#{limit}", 
                :headers => {'Content-Type': 'application/json'}, 
                :body => query.to_json
            i = 0
            while i < response.parsed['rows'].length
                nodes.push(response.parsed['rows'][i])
                i += 1
            end
            return nodes
        end

        def read_node(id)
            response = @driver.connection.request :get, @driver.config['baseURL'] + "/repositories/#{@repository.data['_doc']}/branches/#{@data['_doc']}/nodes/#{id}?metadata=true&full=true"
            return Node.new(@driver, @platform, @project, @repository, self, response.parsed)
        end

        def create_node(json_objec)
            response = @driver.connection.request :post, @driver.config['baseURL'] + "/repositories/#{@repository.data['_doc']}/branches/#{@data['_doc']}/nodes", 
                :headers => {'Content-Type': 'application/json'}, 
                :body => json_objec.to_json

            return Node.new(@driver, @platform, @project, @repository, self, response.parsed)
        end
    end
end
