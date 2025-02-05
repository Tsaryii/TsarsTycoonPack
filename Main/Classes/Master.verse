using{/Fortnite.com/Devices}
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/SpatialMath }
using {Tooltips}
using {Abstractions.AbstractClasses}
TycoonMaster:=class<concrete>(creative_device):

    @editable_container {ToolTip:=BasesTT, AllowReordering:=true} var Bases : []base = array{}
    @editable var ZoneTest : unique_zone = unique_zone{}