//Made by Daniel Waiger 31.07.2020 - On Fiji 1.53c with Bio-formats 6.6.0

//0. Reset windows and close any open images
roiManager("reset");
run("Close All");

//1. Loading Nuclear ROIs .zip from the ***DAPI*** folder
run("ROI Manager...");
showMessage("Select ROI .zip file from reference channel (i.e. DAPI)");
run("Open...");


//2. Seletcting a file from the target channel folder 
//and getting image name
showMessage("Select an image from channel of interest");
run("Open...");
orgName = getTitle();

//3. Selecting the output folder to save ROIs later
output_path = getDirectory("Choose output folder"); 
fileList = getFileList(output_path); 

//4. Selecting the image window and start processing segmentation images made by ilastik
selectWindow(orgName);
run("Duplicate...", "title=" + orgName + "copy");

//5. Making image background value lower than particle of interest.
showMessage("Background value check", "Make sure your background value is lower than foreground!");
run("Invert");

//6. Making an 8-bit from 32-bit (made by ilastik)
run("8-bit");

//7. Making whole nuclei to get their area
run("Fill Holes");


//8. Counting dots inside each roi repeatedly over all ROIs
	showMessage("Adjust particle size in the macro accroding to the acquisition settings");
	numberOfNuclei = roiManager("count");
	for(i=0; i<numberOfNuclei; i++){
		roiManager("Select", i);
			run("Set Measurements...", "area perimeter display redirect=None decimal=3");
			run("Analyze Particles...", "size=0-Infinity display include summarize add in_situ");
	}

//9.Saving ROIs to a .zip file
roiManager("save", output_path + orgName + ".zip")


//10. Show process and analysis complete

showMessage("ROI Extraction", orgName + " ROIs .zip file saved!");

//12. Saving Results from summary window to a .csv
selectWindow("Summary");
saveAs("Results",  output_path + orgName + ".csv");
