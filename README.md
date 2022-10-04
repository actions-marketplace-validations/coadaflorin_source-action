# AppScan Source CLI - GitHub action

This is an HCL AppScan Source GitHub action based on the AppScan Source CLI container. 
More details about the container can be found here: https://help.hcltechsw.com/appscan/Source/10.0.8/topics/configure_creating_containers_docker.html

This container leverages the AppScan Source command line interface (CLI). A detailed description of the capabilities of the CLI can be found here: 
https://help.hcltechsw.com/appscan/Source/10.0.8/topics/command_line_interface_commands.html 

This version of the action is set to work with AppScan Source 10.0.8. The goal is to always be on the latest version. 

### Important topics to know: 
* In order to scan a project you need to have an application already available. That can be a .war,.ear format or needs to be in an AppScan Source specific format (.paf). The application can be configured with the help of AppScan Source for Analysis. 

* This action leverages the ```script``` command. This allows you to execute a pre-configured script automatically. You will need to have this script file available in your repo so that the container can access it. More details about how the file can be configured can be found here: https://help.hcltechsw.com/appscan/Source/10.0.8/topics/command_line_interface_commands_script.html. 

## AppScan Source Script set-up 
The action will load the script file and execute the instruction in there. Some of the most basic steps you need in order to run a scan are: 
  1. ```login``` - his will perform the licensing check [login command documentation](https://help.hcltechsw.com/appscan/Source/10.0.8/topics/command_line_interface_commands_login.html) 
  2. ```openapplication``` - select the application configuration to use [openapplication command documentation](https://help.hcltechsw.com/appscan/Source/10.0.8/topics/command_line_interface_commands_openapplication.html) 
  3. ```scan``` - as the name implies it will run the scan and optionally save an HCL AppScan Source assessment file [scan command documentation](https://help.hcltechsw.com/appscan/Source/10.0.8/topics/command_line_interface_commands_scan.html?hl=scan) 
  4. ```report``` - which will generate a report for you [report command documentation](https://help.hcltechsw.com/appscan/Source/10.0.8/topics/command_line_interface_commands_report.html) 
  5. ```quit``` #release the license 
  
A sample of your script could look something like this:
  ```
  login
  oa /github/workspace/AltoroJ.war 
  scan /github/workspace/.appscan_source/docker_scan_altoroJ.ozasmt
  report "OWASP Top 10 2021" pdf-summary /github/workspace/.appscan_source/scan_report.pdf
  quit
  ```
The path ```/github/workspace/``` is where your code is loaded. Use the full path to your application config in there. If let's say you build something locally in ```<project>/build/libs```, the path you'll need to point in your config is ```/github/workspace/build/libs```. 

The ```login``` command without any username\password and configuration instructs the tool to run in standalone mode. 
  
**NOTE**: *In the script above we're using ```.appscan_source``` as a location to save scan file. This is a project specific location. You can use any location you chose, make sure to remember where you save your artefacts so we can retrieve them later.* 

Once your script is ready, we can now start looking at configuring out GitHub action. Keep in mind you can test the script locally before trying things in GitHub, but you'll need to adjust the paths later on. 

## GitHub action set-up 

After you configured the AppScan script, it's time to configure the AppScan Action to automatically run the scan for you. 

1. Configure your license system. There are several parameters that will be needed for this, but the most important one is the Server ID. Create a github secret and call it SERVER_ID. Follow this guide [here](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository)

2. Create your new action and use the following base configuration.
```yaml
name: "AppScan Source Action"
on:
  workflow_dispatch #manually trigger the action 
jobs:
  scan:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
        
      - name: Run AppScan Static Analyzer
        uses: coadaflorin/source-action@main
        with:
          script-file: source-cli.script   #the name & location of your script file relative to your repo
        env:
            AS_LICENSE_TYPE: 'CLS'
            AS_LICENSE_SERVER_ID: ${{secrets.SERVER_ID}}
            AS_INSTALL_MODE: 'standalone'
```     
The The list parameter you can set for your action can be found here [Supported configuration when creating an AppScan Source CLI container](https://help.hcltechsw.com/appscan/Source/10.0.8/topics/configure_docker_supported_configurations.html)


3. Configure the files you want to save at the end of your scan process. You 
```yaml
      - name: Archive scan results
        uses: actions/upload-artifact@v3
        with:
          name: appscan-source-results
          path: .appscan_source/```
