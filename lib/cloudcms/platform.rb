require 'oauth2'
require 'json'
require 'cloudcms/branch'

# ENV['OAUTH_DEBUG'] = 'true'

module Cloudcms
    class Platform
        attr_accessor :driver
        attr_accessor :data
        attr_accessor :project
        attr_accessor :repository
        attr_accessor :stack
        attr_accessor :datastores
        attr_accessor :application

        def initialize(driver, data)
            @driver = driver
            @data = data
            # puts 'platform data: ' + JSON.pretty_generate(@data)

            # preload:

            # read application
            response = @driver.connection.request :get, @driver.config['baseURL'] + "/applications/" + @driver.config['application'] + "?metadata=true&full=true"
            @application = response.parsed
            # puts 'application: ' + JSON.pretty_generate(@application)

            # find stack by application id
            response = @driver.connection.request :get, @driver.config['baseURL'] + "/stacks/find/application/" + @application['_doc'] + "?metadata=true&full=true"
            @stack = response.parsed
            # puts 'stack: ' + JSON.pretty_generate(@stack)

            # read project
            response = @driver.connection.request :get, @driver.config['baseURL'] + "/projects/" + @application["projectId"]
            @project = Project.new(@driver, self, @stack, response.parsed)
            # puts 'project: ' + JSON.pretty_generate(project)

            @repository = @project.repository

            return self
        end

        def list_repositories()
            repositories = Array.new
            response = @driver.connection.request :get, @driver.config['baseURL'] + "/repositories?metadata=true&full=true"
            i = 0
            while i < response.parsed['rows'].length
                repository = Repository.new(@driver, self, @project, response.parsed['rows'][i])
                repositories.push(repository)
                i += 1
            end
            return repositories
        end

        def read_repository(id)
            response = @driver.connection.request :get, @driver.config['baseURL'] + "/repositories/#{id}?metadata=true&full=true"
            return Repository.new(@driver, self, @project, response.parsed)
        end

        def read_domain(id)
            response = @driver.connection.request :get, @driver.config['baseURL'] + "/domains/#{id}?metadata=true&full=true"
            return response.parsed
        end

        def query_workflow_models(query)
            nodes = Array.new
            response = @driver.connection.request :post, @driver.config['baseURL'] + "/workflow/models/query", 
                :headers => {'Content-Type': 'application/json'}, 
                :body => query.to_json
            i = 0
            while i < response.parsed['rows'].length
                nodes.push(response.parsed['rows'][i])
                i += 1
            end
            return nodes
        end
    
        def create_workflow(modelId, object)
            response = @driver.connection.request :post, @driver.config['baseURL'] + "/workflow/instances?modelId=#{modelId}", 
                :headers => {'Content-Type': 'application/json'}, 
                :body => object.to_json

            # return JSON document describing the workflow instance
            return response.parsed
        end
    
        def add_workflow_resource(instanceId, node)
            response = @driver.connection.request :post, @driver.config['baseURL'] + "/workflow/instances/#{instanceId}/resources/add?reference=#{node.ref()}", 
                :headers => {'Content-Type': 'application/json'}

            return response.parsed
        end
    
        def start_workflow(instanceId)
            response = @driver.connection.request :post, @driver.config['baseURL'] + "/workflow/instances/#{instanceId}/start"

            return response.parsed
        end
    
    end
end
