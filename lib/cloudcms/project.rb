require 'cloudcms/node'

module Cloudcms
    class Project
        attr_accessor :driver
        attr_accessor :data
        attr_accessor :platform
        attr_accessor :stack
        attr_accessor :domain
        attr_accessor :repository
        attr_accessor :datastores
        attr_accessor :branchesByTitle
        attr_accessor :branchesById
        attr_accessor :branches
        attr_accessor :master

        def initialize(driver, platform, stack, data)
            @driver = driver
            @data = data
            @platform = platform
            @stack = stack
            
            # read datastores from stack
            response = @driver.connection.request :get, @driver.config['baseURL'] + "/stacks/" + @stack['_doc'] + "/datastores"
            @datastores = response.parsed
            # puts '@datastores: ' + JSON.pretty_generate(@datastores)

            i = 0
            while i < @datastores['rows'].length
                if (@datastores['rows'][i]['_doc'] == 'content')
                    @repository = @platform.read_repository(@datastores['rows'][i]['datastoreId'])
                    # puts '@repository: ' + JSON.pretty_generate(@repository)
                end

                if (@datastores['rows'][i]['_doc'] == 'principals')
                    #  this is the projects domain
                    @domain = @platform.read_domain(@datastores['rows'][i]['datastoreId'])
                end

                i += 1
            end

            return self
        end

    end
end
