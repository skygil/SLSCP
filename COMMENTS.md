# SLCSP
I have included the following files/folder in a zip file.   

* COMMENTS.md  
* data ( this is a folder with input files)  
  * plans.csv  
  * slscp.csv  
  * zips.csv  
* output (an empty folder that'll be populated once the script runs)  
* myScript.R 
* Dockerfile.txt  
  
You will want to extract these and put them in the directory of **/home/SLSCP**. Keep the subfolders in this zip file as they are called in the script. 

The file directory is set to **/home/SLSCP** in the script. If this needs to be changed, you will need to update the code in the myScript.R script to the file path you use.

# Creating the Docker Image and Running the code

1. Extract the files to **_home/SLSCP_**
2. Open the linux terminal and change the directory to **home/SLSCP** (this is where the docker file is located).   
`cd ~/SLSCP`      
3. Next, build the docker image. Note, this may take some time as it will need to load R package *dplyr* and it's package dependencies :  
 `docker build -t slscp/myimage .`
4. Run the image you just built.  
 `docker run -it --rm -v "$PWD":/home/SLSCP/output -w /home/SLSCP/output slscp/myimage `

5. When the image is at an end, you will see a message displayed in the terminal:
 *Script has successfully ran! Check the data/output folder for the output file 'Stdout'*   
6. Check the output file located in **R/SLSCP/output** for Stdout.csv  

# Alternative option for running the SLSCP Code
Here is an alternative to running the R code:

1. Type in the following code in the terminal  
`docker run -detach -p 8787:8787 -e PASSWORD=yourpassword --name my-rstudio rocker/rstudio`
2. RStudio can now be opened by going to [localhost:8787](http://localhost:8787/) in a web browser. 
3. The username will be **rstudio** and password will be the environment variable provided. In this case it's **yourpassword**.
![Alt text][RstudioLogin]  
![Alt text][RstudioExample]  

4. Next, you'll need to create the same file structure as in SLSCP in R studio. So you'll need two folders, one called **data** and the other called **output**
 This can be done by clicking on the new folder button in the right bottom pane.
5. Once you've created these folders, click on the upload button. This is also in the same pane as the New Folder.
6. From there, locate the SLSCP folder on your system, and upload the csv files to the data folder you just created in R studio.
7. Just as you did in step 6, you will need to upload **myScriptFinal.R** to the main directory. 
8. Open **myScriptFinal.R** by single clicking on the file in RStudio
9. There should be a pop up asking you to install *dplyr*, click install, or:  
    Comment out line 5, and  uncomment line 13 and lines 16 thru 24.   
    *Note: To comment/uncomment lines of code, select the code and then push ctrl+shift+C*
10. Next, you'll need to run the entire script. You can use the shorthand keyboard shortcut by pressing Ctrl+Alt+R, or you can select all the code and press the Run bottom in the first pane on the left.
11. Once the code has successfully ran, an output message in the console (left pane on the bottom) will print a message confirming the workflow is finished. Once done, navigate to the output folder (right bottom pane).
12. Now you can view *Stdout.csv* in this environment, or select the check box next to this file and click on the **More** button (tool bar in right bottom pane furthest on the right).
13. Once you click on **More** select 'Export'.
14. A pop up will appear confirming you'd like to download the file.
15. When you are finished with this environment, you'll need to stop the container. You can do this by typing the following in the linux terminal:
`docker rm --force my-rstudio`  

---
# Troubleshooting

## Output folder missing csv file
If you do not see the CSV file in the output folder, you will need to verify you have the file from the container in docker added to the output folder on your host system. This code should do this for you. If not, you may consider adding in code to the dockerfile that mounts the container for you.  

`docker run -it --rm -v "$PWD":/home/SLSCP/output -w /home/SLSCP/output slscp/myimage  ` 

If this still does not work, this [URL][DockerFileSharing] has alternative suggestions to share files back and forth from/to the host and the container in docker. 

## Struggling with docker
For issues or help with docker, you can visit the [docker reference site][Docker Reference Site].   

# Reference Material
[RstudioLogin]: https://github.com/aboland/ReproducibleResearch/blob/master/Docker/images/rstudio_login.png
[RstudioExample]: https://github.com/aboland/ReproducibleResearch/blob/master/Docker/images/rstudio_example.png
[DockerFileSharing]: https://www.9series.com/blog/easy-methods-to-share-files-from-host-to-docker/
[Docker Reference Site]:https://docs.docker.com/reference/

Helpful Reference sites:   
[Sharing and Running R code using Docker](https://aboland.ie/Docker.html)  
[Docker Reference Site](https://docs.docker.com/reference/)   
[DockerFileSharing](https://www.9series.com/blog/easy-methods-to-share-files-from-host-to-docker/)