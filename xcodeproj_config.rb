require 'rubygems'
require 'xcodeproj'
require 'yaml'

project = Xcodeproj::Project.open(ARGV[0])

config = YAML.load(File.read(ARGV[1]))
build_setting = config["build_setting"]

project_setting = build_setting["project"]
if (project_setting != nil) 
    project_setting.each do |key, value|
        if (value.class == Hash)
            value.each do |cfgName, val|
                project.build_settings(cfgName)[key] = val
            end
        else
            project.build_configurations.each do |configuration|
                configuration.build_settings[key] = value
            end 
        end
    end
end

targets_setting = build_setting["targets"]
if (targets_setting != nil)
    project.targets.each do |target|
        target_setting = targets_setting[target.name]
        if (target_setting != nil)
            target_setting.each do |key, value|
                if (value.class == Hash)
                    value.each do |cfgName, val|
                        target.build_settings(cfgName)[key] = val
                    end
                else
                    target.build_configurations.each do |configuration|
                        configuration.build_settings[key] = value
                    end 
                end
            end
        end
    end
end

phases_config = config["build_phase"]
if (phases_config != nil) 
    # run_script
    run_script_phases = phases_config["create_run_scripts"]
    if (run_script_phases != nil)
        run_script_phases.each do |name, phase|
            if (phase.class == Hash)
                phases_target = phase["tragets"]
                script = phase["script"]
                phases_target.each do |target_name|
                    project.targets.each do |target|
                        if (target_name == target.name)
                            run_script_phase = target.new_shell_script_build_phase(name)
                            run_script_phase.shell_script = script != nil ? script : ""
                            break
                        end
                    end
                end
            else 
                project.targets.each do |target|
                    run_script_phase = target.new_shell_script_build_phase(name)
                    run_script_phase.shell_script = phase
                end
            end
        end
    end

    # add resources
    resources = phases_config["add_resources"]
    if (resources != nil) 
        resources.each do | resource | 
            if (resource.class == Hash)
                phases_target = resource["tragets"]
                file = resource["file"]
                phases_target.each do |target_name|
                    project.targets.each do |target|
                        if (target_name == target.name)
                            file_ref = project.main_group.new_reference(file)
                            target.add_resources([file_ref])  
                            break
                        end
                    end
                end
            else
                project.targets.each do |target|
                    file_ref = project.main_group.new_reference(resource)
                    target.add_resources([file_ref])  
                end
            end
        end
    end

    # add source
    sources = phases_config["add_source"]
    if (sources != nil) 
        sources.each do | source | 
            if (source.class == Hash)
                phases_target = source["tragets"]
                file = source["file"]
                phases_target.each do |target_name|
                    project.targets.each do |target|
                        if (target_name == target.name)
                            file_ref = project.main_group.new_reference(file)
                            if (file.end_with?('.h') == false)
                                target.add_file_references([file_ref])
                            end  
                            break
                        end
                    end
                end
            else
                project.targets.each do |target|
                    file_ref = project.main_group.new_reference(source)
                    if (source.end_with?('.h') == false)
                        target.add_file_references([file_ref])
                    end
                end
            end
        end
    end
end
project.save()