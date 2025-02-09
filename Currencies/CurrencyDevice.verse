using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using { /Fortnite.com/Characters }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/SpatialMath }
using {Tooltips}
using {Main.Classes}
using {Main.Abstractions.Interfaces}
currency_manager<public>:=class<concrete>(creative_device, base_runtime):

    @editable var CurrencyList <public> : []currency = array{}

    var maybeOwner:?base=false


    Init<override>(inBase:base)<suspends>:void=set maybeOwner = option. inBase

