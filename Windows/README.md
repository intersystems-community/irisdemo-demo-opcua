# IRIS OPC UA for Windows versions of IRIS

This IRIS OPC UA connector can be used with Windows
versions of IRIS so long as the appropriate linked-libraries
are utilized, and for this purpose, the Windows/bin folder here 
contains two DLLS---IrisOPCUA.dll and open62541.dll---that can 
be placed in the iris/bin directory of most Windows versions of 
IRIS so as to allow the functions of the connector. 
In principle, once these two DLLs are placed within the iris/bin 
directory, the exact same ObjectScript code that is used here for 
these demos should also be usable within that instance of IRIS. 
However, because the files here within this Windows directory may 
be updated at different times from the rest of the code files within 
this repository, it is recommended that one use the Studio export XML
file in the Windows/Studio directory here when using the connector
on Windows, instead of using the 
ObjectScript files in the irisdemo-demo-opcua repository directly.
