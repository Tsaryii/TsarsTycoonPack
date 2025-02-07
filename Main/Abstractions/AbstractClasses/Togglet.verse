using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using{Interfaces}
togglet:=class<abstract><public>(toggleable):
    var Status:logic=false

    Enable<override>()<transacts>:void={set Status=true, Print("Enabling")}
    Disable<override>():void={set Status=false}
    
