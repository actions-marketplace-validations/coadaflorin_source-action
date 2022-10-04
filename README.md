# AppScan Source CLI - GitHub action

This is an HCL AppScan Source GitHub action based on the AppScan Source CLI container. 
More details about the container can be found here: https://help.hcltechsw.com/appscan/Source/10.0.8/topics/configure_creating_containers_docker.html

This container leverages the AppScan Source command line interface (CLI). A detailed description of the capabilities of the CLI can be found here: 
https://help.hcltechsw.com/appscan/Source/10.0.8/topics/command_line_interface_commands.html 

### Important topics to know: 
* In order to scan a project you need to have an application already available. That can be a .war,.ear format or needs to be in an AppScan Source specific format (.paf). The application can be configured with the help of AppScan Source for Analysis. 

* This action leverages the ```script``` command. This allows you to execute a pre-configured script automatically. You will need to have this script file available in your repo so that the container can access it. More details about how the file can be configured can be found here: https://help.hcltechsw.com/appscan/Source/10.0.8/topics/command_line_interface_commands_script.html. 

* The action will load the script file and execute the instruction in there. Some of the most basic steps you need in order to run a scan are: 
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
The path ```/github/workspace/``` is where your code is loaded. Use the full path to your application config in there. 
  
**NOTE**: *In the script above we're using ```.appscan_source``` as a location to save scan file. This is a project specific location. You can use any location you chose, make sure to remember where you save your artefacts so we can retrieve them later.* 
