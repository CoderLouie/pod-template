module Pod
    
    class ConfigureSwift
        attr_reader :configurator
        
        def self.perform(options)
            new(options).perform
        end
        
        def initialize(options)
            @configurator = options.fetch(:configurator)
        end
        
        def perform
            
#            configurator.add_pod_to_podfile "Alamofire"
#            configurator.add_pod_to_podfile "SwifterSwift"
#            configurator.add_pod_to_podfile "Then"
#            configurator.add_pod_to_podfile "SnapKit"
#            configurator.add_pod_to_podfile "Reusable"
#            configurator.add_pod_to_podfile "SwiftyUserDefaults"
            
            test = configurator.ask_with_answers("Would you like to include a test target in your library", ["Yes", "No"]).to_sym
            
            if test == :yes
                configurator.set_test_framework "xctest", "swift", "swift"
            end
            
            Pod::ProjectManipulator.new({
                                        :configurator => @configurator,
                                        :xcodeproj_path => "templates/swift/Example/PROJECT.xcodeproj",
                                        :platform => :ios,
                                        :remove_demo_project => false,
                                        :prefix => ""
                                        }).run
                                        
                                        # There has to be a single file in the Classes dir
                                        # or a framework won't be created
                                        
                                        `mv ./templates/swift/Example/* ./`
                                        
                                        # remove podspec for osx
                                        `rm ./NAME-osx.podspec`
        end
    end
    
end
