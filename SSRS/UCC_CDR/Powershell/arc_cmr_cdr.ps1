Copy-Item -Path '\\dr.lcl\fileshares\Applications\SSIS_CallManager\CAR_Files\cmr*'  -Destination '\\dr.lcl\fileshares\Applications\SSIS_CallManager\Archive' -Force 
Copy-Item -Path '\\dr.lcl\fileshares\Applications\SSIS_CallManager\CAR_Files\cdr*'  -Destination '\\dr.lcl\fileshares\Applications\SSIS_CallManager\Archive' -Force 


Remove-Item –path \\dr.lcl\fileshares\Applications\SSIS_CallManager\CAR_Files\cmr*
Remove-Item –path \\dr.lcl\fileshares\Applications\SSIS_CallManager\CAR_Files\cdr*
