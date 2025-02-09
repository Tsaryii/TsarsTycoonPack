using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using { /Fortnite.com/Characters }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/SpatialMath }
using {Tooltips}
using {Main.Abstractions.AbstractClasses}
currency<public>:=class<concrete><unique>():
    @editable var Details <public> : descriptor=descriptor{}
    @editable {ToolTip:=InitialValueTT} var InitialValue <public> : int=0
    @editable {ToolTip:=anyPersistableTT} var Persist <public>: logic=true

