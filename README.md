# XcodeProj Configuration Tool

Modify xcodeproj via the YAML configuration file

## How to use

Dependence: [xcodeproj](https://www.bing.com/ck/a?!&&p=53a8e6046d8c3dbbJmltdHM9MTY3MzY1NDQwMCZpZ3VpZD0yMjJmYjEwNC0xZTQ1LTY3NzgtMTI0NS1hMzZjMWYyMzY2YmMmaW5zaWQ9NTE4Mw&ptn=3&hsh=3&fclid=222fb104-1e45-6778-1245-a36c1f2366bc&psq=ruby+xcodeproj&u=a1aHR0cHM6Ly9ydWJ5Z2Vtcy5vcmcvZ2Vtcy94Y29kZXByb2ovdmVyc2lvbnMvMS4yMS4w&ntb=1)

### Execute

Command line: `ruby xcodeproj_config.rb.rb XCDPEPROJ_PATH CONFIG_FILE`

```shell
ruby xcodeproj_config.rb.rb '/Users/jerry/Desktop/XcodProjTest/Test.xcodeproj' Example.yaml
```

### Config file

```yaml
build_setting:
  project:                                              # Setup build setting to sepcified target
    LD_RUNPATH_SEARCH_PATHS:                            # Name of setting
      - $(inherited)                                    # Value of `LD_RUNPATH_SEARCH_PATHS` for all configuration
      - TestPaht
  targets:                                              # Setup build setting to sepcified target
    XcodProjTest:                                       # target name
      LD_RUNPATH_SEARCH_PATHS:                          # Name of setting
        Debug:                                          # Value of `LD_RUNPATH_SEARCH_PATHS` for debug configuration
          - $(inherited)                                
          - Test
      ONLY_ACTIVE_ARCH: NO                              # Value of `ONLY_ACTIVE_ARCH` for release configuration
build_phase:
  create_run_scripts:
    test_script: "echo 1233"                            # Add run script phase to all target
    test_script_1:                                      # Name of run script name
      tragets: 
        - XcodProjTest                                  # Add run script phase to specified target
      script: "echo 1233"
  add_resources:                                        # Add resources file to project
    - "/Users/jerry/Desktop/XcodProjTest/BuildSetting.yaml"
    - tragets:                                          # Add resources file to specified target
      - XcodProjTest
      file: "/Users/jerry/Desktop/XcodProjTest/BuildSetting.json"
  add_source:                                           # Add sources file
    - "/Users/jerry/Desktop/XcodProjTest/aa.c"          # Add source file to all target
    - tragets:
      - XcodProjTest                                    # Add source file to specified target
      file: "/Users/jerry/Desktop/XcodProjTest/bb.c"
```