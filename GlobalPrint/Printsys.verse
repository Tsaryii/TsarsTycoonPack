using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using{Purchaseables}
using{Tooltips}
#Categories


AbstractClassesCategory<localizes><public>:message={"Anything Abstract Class based"}
InterfacesCategory<localizes><public>:message={"Anything Interface based"}
ClassesCategory<localizes><public>:message={"Anything Class based"}
PurchaseablesCategory<localizes><public>:message={"Anything Purchaseable based"}


LongPrint<public>(Message:string)<transacts>:void=
    Print(Message, ?Duration:=5.5)

var UniqueZoneDebugWM <public>:weak_map(session, logic) = map{}

print_system:=class(creative_device):

    @editable {Categories:=array{AbstractClassesCategory}} var UniqueZoneDebug : logic=false



    OnBegin<override>()<suspends>:void=
        if:
            set UniqueZoneDebugWM[GetSession()]=UniqueZoneDebug

