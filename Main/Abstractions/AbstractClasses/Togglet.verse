using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using{Interfaces}
togglet:=class<abstract><public>(iToggleable):
    var Status:logic=false

    Enable<override>():void={set Status=true}
    Disable<override>():void={set Status=false}
    
