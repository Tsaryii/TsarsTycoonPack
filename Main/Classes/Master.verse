using{/Fortnite.com/Devices}
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/SpatialMath }
using {Tooltips}
TycoonMaster:=class<concrete>(creative_device):

    @editable {ToolTip:=BasesTT, AllowReordering:=true} var Bases : []base = array{}