using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using{Purchaseables}
using{Tooltips}
#Categories


AbstractClassesCategory<localizes><public>:message={"Anything Abstract Class based"}
InterfacesCategory<localizes><public>:message={"Anything Interface based"}
ClassesCategory<localizes><public>:message={"Anything Class based"}
PurchaseablesCategory<localizes><public>:message={"Anything Purchaseable based"}
BasesCategory<localizes><public>:message={"Anything Base based"}



LongSuccessPrint<public>(Message:string, Code:string, Logic:logic)<transacts>:void=
    if:
        Logic?
    then:
        Print("SUCCESS: {Message} | Code: {Code}", ?Duration:=5.5, ?Color:=NamedColors.Green)

LongMessagePrint<public>(Message:string, Code:string, Logic:logic)<transacts>:void=
    if:
        Logic?
    then:
        Print("NOTICE: {Message} | Code: {Code}", ?Duration:=5.5, ?Color:=NamedColors.Yellow)

LongErrorPrint<public>(Message:string, ErrorCode:string, Logic:logic)<transacts>:void=
    if:
        Logic?
    then:
        Print("ERROR: {Message} | ErrorCode: {ErrorCode}", ?Duration:=5.5, ?Color:=NamedColors.Red)

var UniqueZoneDebugWM <public>:weak_map(session, logic) = map{}
var BaseClaimDebugWM <public>:weak_map(session, logic) = map{}
var BaseLeaveDebugWM <public>:weak_map(session, logic) = map{}

print_system:=class(creative_device):

    @editable {Categories:=array{AbstractClassesCategory}} var UniqueZoneDebug : logic=false
    @editable {Categories:=array{BasesCategory}} var BaseClaimDebug : logic=false
    @editable {Categories:=array{BasesCategory}} var BaseLeaveDebug : logic=false


    OnBegin<override>()<suspends>:void=
        if:
            set UniqueZoneDebugWM[GetSession()]=UniqueZoneDebug
            set BaseClaimDebugWM[GetSession()]=BaseClaimDebug
            set BaseLeaveDebugWM[GetSession()]=BaseLeaveDebug
        then:
            Print("Successfully set debug values --> initiating print system")

