#!/usr/bin/env ruby
require 'cloudcms'

begin
    cloudcms = Cloudcms::Cloudcms.new()
    platform = cloudcms.connect()
    puts "connected to api server at: #{cloudcms.config['baseURL']}"
    # puts 'platform: ' + JSON.pretty_generate(platform.data)
    puts "platform id: #{platform.data['_doc']}"
    puts "project title: #{platform.project.data['title']}"

    # list repositories
    repositories = platform.list_repositories
    # puts 'list_repositories: ' + JSON.pretty_generate(repositories)

    arbitrary_repository = platform.read_repository(repositories[0].data["_doc"])
    # puts 'read_repository: ' + JSON.pretty_generate(arbitrary_repository.data)

    # content repository for the project we are connected to using the application id in gitana.json
    repository = platform.project.repository

    branches = repository.list_branches
    # puts 'branches: ' + JSON.pretty_generate(branches[0].data)

    arbitrary_branch = repository.read_branch(branches[0].data["_doc"])
    # puts 'arbitrary_branch: ' + JSON.pretty_generate(arbitrary_branch)

    master = repository.read_branch("master")
    # puts 'master.data: ' + JSON.pretty_generate(master.data)

    # master = repository.master
    # puts 'master.data: ' + JSON.pretty_generate(master.data)
    # puts 'platform.repository: ' + JSON.pretty_generate(platform.repository)
    # puts 'platform.repository.data: ' + JSON.pretty_generate(platform.repository.data)

    nodes = master.query_nodes({_type: 'n:node'}, 0, 5)

    nodes.each do |node|
        puts 'node: ' + JSON.pretty_generate(node)
    end

    node = master.read_node(nodes[0].data["_doc"])
    # puts 'node: ' + JSON.pretty_generate(node.data)

    new_node = {
        winner: 'Javi',
        players: [
            {
                name: 'Javi',
                decks: [
                    'Dinosaurs',
                    'Plants'
                ],
                points: 24,
                place: 1
            },
            {
                name: 'Seth',
                decks: [
                    'Spies',
                    'Zombies'
                ],
                points: 20,
                place: 2
            }
        ]
    } 
    
    node = master.create_node(new_node)
    puts 'create_node: ' + JSON.pretty_generate(node.data)

    node.data['newprop'] = 199
    node.update

    node.reload
    puts 'reload: ' + JSON.pretty_generate(node.data)
    
    # 
    # test workflow creation
    # 

    # create a node
    workflowResourceNode = master.create_node({'title': 'test workflow'})

    # find workflow model
    workflowModels = repositories = platform.query_workflow_models({'id': 'simple-publish'})
    # puts 'workflowModels'
    # workflowModels.each do |workflowModel|
        # puts 'workflowModel: ' + JSON.pretty_generate(workflowModel)
    # end

    # create a workflow instance from the model
    workflowInstance = platform.create_workflow(workflowModels[0]['_doc'], {
        payloadType: 'content',
        payloadData: {
            repositoryId: platform.project.repository.data['_doc'],
            branchId: platform.project.repository.master.data['_doc']
        }
    })

    # add a node to the workflow instance
    platform.add_workflow_resource(workflowInstance['_doc'], workflowResourceNode)

    # start the workflow instance
    platform.start_workflow(workflowInstance['_doc'])

# rescue StandardError => err
#     puts('Error: ')
#     puts(err)
end



# # Read Node
# node = branch.read_node('<node_id>')

# # Create node
# obj = {
#     'title': 'Twelfth Night',
#     'description': 'An old play'
# }
# newNode = branch.create_node(obj)

# # Query nodes
# query = {
#     '_type': 'store:book'
# }
# pagination = {
#     'limit': 2
# }
# queried_nodes = branch.query_nodes(query, pagination)

# # Search/Find nodes
# find = {
#     'search': 'Shakespeare',
#     'query': {
#         '_type': 'store:book'
#     }
# }
# searched_nodes = branch.find_nodes(find)
