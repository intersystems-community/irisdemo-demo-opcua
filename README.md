# IRIS OPC UA Adapter Demos

This repository holds an example application in which IRIS uses 
OPC UA to access data and subsequently store that data in tables/globals.

## OPC UA Basics

OPC UA is a client-server protocol by which data and 
information can be transferred between machines.

Data intended for transmission via OPC UA is made available 
by OPC UA servers to which OPC UA clients can connect.
Clients connect to servers with TCP/IP by referencing
special URLs designating the OPC UA protocol (see below), 
and subsequently those clients 
can then request specific data values held on those servers
by referencing the "node" on which each 
data value is stored. 

Each OPC UA "node" on a server is identified by a "node id" and typically 
stores a single data element that might be any of one of various data types. 
Often such data elements are simple primitives 
such as strings, integers, booleans, and floats, 
but server nodes can also hold more complex data types as well
such as bytestrings that 
can literally hold data in virtually any format that a developer so chooses,
including code files and PDF documents.

A relatively common situation might involve an industrial machine 
for which data elements such as the temperature of the machine 
and the pressure inside the machine are made accessible by an OPC UA
server to computers 
on a local area network. 
In such a situation, instantaneous temperature and pressure values 
might be indexed upon the OPC UA server on nodes each named as 
"temperature" and "pressure". OPC UA clients could then connect 
to the server using the server's URL and subsequently request 
current values 
for each of the temperature and pressure nodes. The OPC UA server 
would typically the reply with the most recent values for the data 
along with timestamps indicating when those most recent
values had been posted to the server.

Although the general concepts behind OPC UA are simple, 
the protocol itself has myriad of different features 
that allow it to be used with great flexibility 
in many situations, making its specification quite detailed and complex. 
More information on OPC UA including the protocol's official specification
can be found at http://opcfoundation.org.

## The IRIS OPC UA Adapter Client

The OPC UA adapter for IRIS contained in this repository
serves to allow IRIS to act 
as an OPC UA client in order to access OPC UA servers 
and query those servers for information. 

Users of the adapter can construct "DataSource" classes 
in ObjectScript with properties that reference queryable OPC UA nodes 
upon a desired target server. Such "DataSource" classes are persistent within IRIS, 
and thus, when values are eventually accessed from the desired OPC UA server, 
those values are immediately stored within IRIS and made queryable 
using both ObjectScript as well as SQL.
In order to perform its function, each "DataSource" must class extend not only 
%Persistent but also OPCUA.DataSource.Definition,
and this allows the adapter to set up the necessary framework in order 
to gather and store the relevant data. 

Each property of a "DataSource" class is specified 
indicating both (1)
the node name for the node on which to find that data
as well as (2)
a special ObjectScript data type that is 
itself reflective of the data type of the underlying data. 
In the following example, data is sought from a node called 
"AirConditioner_1.Temperature", 
and placed in a property called "Temperature" 
(notably, allowing the data to subsequently be 
queried within IRIS both as an object property
as well as in a SQL column of the same name). 

```C#
Property Temperature As OPCUA.Types.DoubleDataValue(OPCUANODENAME = "AirConditioner_1.Temperature");
```

Importantly, the data type above is declared as OPCUA.Types.DoubleDataValue, 
which is a special data type that allows access to both 
the double value that is being sought as well as timestamps 
indicating when it was placed on the server. Currently, this
adapter supports the accessing of primitive strings and integers
as well, each of which must be accessed using similar 
data type-related ObjectScript classes.

## Polling Access vs. OPC UA Subscription

This IRIS client adapter can access OPC UA data using two fundamentally 
different methods: (1) a method we term "polling", and 
(2) a method that is most precisely referred to 
in OPC UA terminology as "subscription to monitored items".

The polling method, which is here implemented using an 
ObjectScript class OPCUA.Service.TCPPollingService, involves 
the repeated requesting of data corresponding to a certain 
set of data nodes in bulk. Specifically, using this polling method, 
data for each and every property of a DataSource class is 
requested from a server all at once. The client application 
then expects to receive data from the server for each and 
every node requested along with the relevant timestamps for 
each reported data element, effectively representing a snapshot
of the node values at that point in time. 
The returned results are then 
placed by the connector into a table/global within IRIS.

The second method improves upon the first in some ways by 
using the OPC UA Subscription framework. Using this second method, 
a request is made of a OPC UA server to track the changes made to 
each node corresponding to a property of the relevant DataSource class. 
Periodically, the client then queries the OPC UA server asking 
if there have been any changes since last querying. 
Upon receipt of this information, this IRIS OPC UA adapter 
then arranges any such changes into one or more new rows 
that are then added to the table/global within the database.
If a particular value has not changed, then the previous value is
inserted instead. If no values have changed, then the row is 
typically omitted altogether. (Some settings can be adjusted to
control this behavior.)

## Running the Demos

The demos in this repository can be run using only a few steps:

* Download the relevant code from GitHub.
* Run "./build.sh" in order to build the IRIS Docker image.
* Run "./run.sh all" in order to start the two Docker containers 
used by the demo, one of which runs IRIS. 
(If the "all" parameter is omitted, then the "mockserver" container will not be started. See below.)
* Login to the IRIS Management Portal at http://localhost:52783/csp/sys/UtilHome.csp 
with username "SuperUser" and password "sys".
* Navigate to the IRIS Production Examples.OPCUADS.Production. 
* Enable any of the BusinessServices found at the left hand side of the screen. 
Each is itself a separate demo, each 
intended to place incoming OPC-UA data on a different global/table within IRIS.

At this time, it is intended that there be four 
OPC UA BusinessService demonstrations available 
within this repository now or in the near future:

* Local Polling Example (Examples.OPCUADS.PollingExample.cls) - This 
example sees IRIS use the OPC UA adapter to connect to an 
OPC UA server running locally in a separate container, 
here called "mockserver". The "mockserver" application reads data 
from a .csv file and makes that data available on nodes queryable 
by clients connecting to it. 
IRIS then repeatedly requests data from the "mockserver"
using the polling mechanism described above
and, each time, receives a response with the requested data snapshot
which is immediately deposited on a table/global "Examples.OPCUADS.PollingExample".
* Local Subscription Example (Examples.OPCUADS.SubscriptionExample.cls) - This 
example also sees IRIS use the OPC-UA adapter to connect to the "mockserver", 
though here the data is obtained using the Subscription method instead of the Polling method.
The data is deposited on a table/global "Examples.OPCUADS.SubscriptionExample".
* Internet Polling Example (Examples.OPCUADS.InternetPollingExample.cls) - This 
example sees IRIS use the OPC UA adapter to connect to 
a publicly available OPC UA server on the Internet at 
opc.tcp://opcuaserver.com:48010. 
Data is then requested from that server using the polling method and deposited
on a table/global "Examples.OPCUADS.InternetPollingExample". 
* Internet Subscription Example (Examples.OPCUADS.InternetSubscriptionExample.cls) - This 
example again sees IRIS use the OPC UA adapter to connect to 
the publicly available OPC UA server on the Internet at 
opc.tcp://opcuaserver.com:48010. 
Data is requested from that server using the subscription method 
and again stored within IRIS on a table/global.

## Future Work

Future work regarding this adapter may include work on:

* Security - Currently, this adapter does not support encrypted data transmission. 
Future work may involve the use of SSH and username/password authentication.
* Expanded Type Set - Currently, 
this adapter supports only a small number of primitive data types 
while OPC UA is defined so as to support quite a few others. 
Future work may involve modifying the adapter 
so that it can download other more complex data types as well.

## Caution

This OPC UA adapter for the IRIS is implemented using a native-code 
linked-library compiled specifically for use in Ubuntu containers. 
While the ObjectScript code included in this repository may work 
with many versions of IRIS, the linked-library itself will not. 
This OPC UA adapter is thus not necessarily usable outside of 
the context of these demos at this time. 
It is not clear whether or not functionality 
supporting this adapter will be available in future versions of IRIS.

