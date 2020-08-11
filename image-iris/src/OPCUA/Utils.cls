Include (%callout, OPCUA.Constants, Ensemble)


/// Miscellaneous utility functions used in conjunction with
/// the OPC-UA connector.
Class OPCUA.Utils
{


/// Used to load the dynamic library containing the native code
/// for the OPC-UA connector. This function must be called prior
/// to calling many of the methods 
/// of the <class>OPCUA.Client</class> class.
ClassMethod Initialize() As %Status
{
    try {

        #; See ##class(OPCUA.Class).GetStatusCodeName()

        set tOpcuaStatusCode = 0 // Status = "Good"

		set tRetval=$ZF(-6,$$$IrisOPCUALibrary,$$$zfGetStatusCodeNameB,"",$LB(tOpcuaStatusCode))

        If $List(tRetval,1)=0 return $$$OK // Library is already initialized

    } catch (e) {
        $$$LOGINFO("IrisOPCUA may not be loaded : "_$SYSTEM.Status.GetErrorText(e.AsStatus()))
    }

    #dim tSC as %Status = $$$OK
    #dim tPathname as %String = ""

    try {

        set tPathname = ^OPCUA.Library.Pathname
        $$$LOGINFO("Attempting to load IrisOPCUA with pathname "_tPathname)

        do $ZF(-4,5,$$$IrisOPCUALibrary,tPathname)

    } catch (e) {
        set tSC = e.AsStatus()
        $$$LOGERROR("Error thrown during IrisOPCUA handle assignment : "_$SYSTEM.Status.GetErrorText(tSC))
    }

    set tSC = $$$OK

    try {

		set tRetval=$ZF(-6,$$$IrisOPCUALibrary,$$$zfGetStatusCodeNameB,"",$LB(0))

        If $List(tRetval,1)'=0 Set tSC=##class(OPCUA.Client).DecodeError(tRetval)

        if $$$ISERR(tSC) {
            $$$LOGERROR("Unable to load IrisOPCUA : Error returned : "_$SYSTEM.Status.GetErrorText(tSC))
        } Else {    
            $$$LOGINFO("IrisOPCUA loaded successfully")
        }

    } catch (e) {
        set tSC = e.AsStatus()
        $$$LOGERROR("Unable to load IrisOPCUA : Error thrown : "_$SYSTEM.Status.GetErrorText(tSC))
    }

    Quit tSC
}



/// Used to specify the pathname of a dynamic library, usually
/// one named as <i>irisopcua.so</i>, 
/// that contains the native code for the OPC-UA connector.
ClassMethod Install(pPathname as %String) As %Status
{
    #dim tSC as %Status = $$$OK

    try {    

        set ^OPCUA.Library.Pathname = pPathname

    } catch (e) {
        set tSC = e.AsStatus()
    }

    Quit tSC
}

}
