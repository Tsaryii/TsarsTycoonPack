using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using{Interfaces}
togglet:=class<abstract><public>(iToggleable):
    var Status:logic=false

    Enable<override>()<transacts>:void={set Status=true, Print("Enabling")}
    Disable<override>()<transacts>:void={set Status=false}
    
