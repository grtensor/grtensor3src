#
# grload_maplet
#
# - scan the metric in the paths provided and show their names
#   as well as their info line
#

grload_maplet := proc()

global grOptionMetricPath, grOptionqloadPath;

local maplet1, metricName, fullname, startDir; 

uses Maplets[Elements];

if assigned(grOptionMetricPath) then
    startDir := grOptionMetricPath;
elif assigned(grOptionqloadPath) then
    startDir := grOptionqloadPath;
else
    startDir := currentdir();
end if:


# Define the get file Maplet application. Define an abnormal
# shutdown as one that returns FAIL.
maplet1 := Maplet( 'abnormalshutdown' = "FAIL",
    FileDialog['FD1'](
        'directory' = startDir,

        # Specify the Maplet application title.
        'title' = "Read File",
        
        # The text appears on the approve button.
        'approvecaption' = "OK",

        # Return the value referenced by FD1 
        # when "OK" is clicked.
        'onapprove' = Shutdown( ['FD1'] ),

        # Return FAIL when "Cancel" is clicked.
        'oncancel' = Shutdown( "FAIL" )
    )
):

# Assign result to the value returned by the Maplet application.
result := Maplets[Display](maplet1);

# Check that result is a string. If it is a string,
# result is opened.
if type( result, ['string'] ) then
	fullname := op(result):
	metricName := FileTools:-Basename(FileTools:-Filename(fullname)):
	metricName := convert(metricName, name):
	printf("Loading as %s from %s", metricName, fullname):
    grF_loadMetric( metricName, fullname):
end if;

end proc: