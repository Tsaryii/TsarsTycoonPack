using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Colors }
using{Purchaseables}
using{Tooltips}
#Categories


AbstractClassesCategory<localizes><public>:message={"Abstract Classes"}
InterfacesCategory<localizes><public>:message={"Interfaces"}
ClassesCategory<localizes><public>:message={"Classes"}
PurchaseablesCategory<localizes><public>:message={"Purchaseables"}
BasesCategory<localizes><public>:message={"Bases"}
PersistenceSetupCategory<localizes><public>:message={"Persistence"}
CurrencyCategory<localizes><public>:message={"Currencies"}


var UniqueZoneDebugWM <public>:weak_map(session, logic) = map{}
var BaseClaimDebugWM <public>:weak_map(session, logic) = map{}
var BaseLeaveDebugWM <public>:weak_map(session, logic) = map{}
var OnPurchaseDebugWM <public>:weak_map(session, logic) = map{}
var PersistenceSetupWM <public>:weak_map(session, logic) = map{}
var CurrencyCategoryWM <public>:weak_map(session, logic) = map{}

print_system:=class(creative_device):

    @editable {Categories:=array{AbstractClassesCategory}} var UniqueZoneDebug : logic=false
    @editable {Categories:=array{BasesCategory}} var BaseClaimDebug : logic=false
    @editable {Categories:=array{BasesCategory}} var BaseLeaveDebug : logic=false
    @editable {Categories:=array{PurchaseablesCategory}} var OnPurchaseDebug : logic=false
    @editable {Categories:=array{PersistenceSetupCategory}} var PersistenceSetup : logic=false
    @editable {Categories:=array{CurrencyCategory}} var CurrencyDebug : logic=false


    OnBegin<override>()<suspends>:void=
        if:
            set UniqueZoneDebugWM[GetSession()]=UniqueZoneDebug
            set BaseClaimDebugWM[GetSession()]=BaseClaimDebug
            set BaseLeaveDebugWM[GetSession()]=BaseLeaveDebug
            set OnPurchaseDebugWM[GetSession()]=OnPurchaseDebug
            set PersistenceSetupWM[GetSession()]=PersistenceSetup
            set CurrencyCategoryWM[GetSession()]=CurrencyDebug
        then:
            Print("Successfully set debug values --> initiating print system")







#Long Print

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

#Short prints

ShortSuccessPrint<public>(Message:string, Code:string, Logic:logic)<transacts>:void=
    if:
        Logic?
    then:
        Print("SUCCESS: {Message} | Code: {Code}", ?Duration:=2.5, ?Color:=NamedColors.Green)

ShortMessagePrint<public>(Message:string, Code:string, Logic:logic)<transacts>:void=
    if:
        Logic?
    then:
        Print("NOTICE: {Message} | Code: {Code}", ?Duration:=2.5, ?Color:=NamedColors.Yellow)

ShortErrorPrint<public>(Message:string, ErrorCode:string, Logic:logic)<transacts>:void=
    if:
        Logic?
    then:
        Print("ERROR: {Message} | ErrorCode: {ErrorCode}", ?Duration:=2.5, ?Color:=NamedColors.Red)