using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using { /Fortnite.com/Devices }
using {Tooltips}
using {Textures}
using{Main.Classes}
using{Main.Abstractions.AbstractClasses}
using{Main.Abstractions.Interfaces}

base_ownable<public>:=class(isubBaseInitAsync):

    var MaybeOwner<public>:?base=false


    SetOwner(inOwner:base):void=
        set MaybeOwner=option{inOwner}

    GetOwner():base=
        if:
            Owner := MaybeOwner?
        then:
            Owner
        else:
            return base{}

    Init<override>(inBase:base)<suspends>:void={SetOwner(inBase); return}


#The most basic class for a purchaseable object
purchaseable<public>:=class<concrete>(base_ownable):


    @editable var Descriptor : descriptor = descriptor{}
    @editable var CurrencyCosts : cost_field = cost_field{}
    @editable var PurchaseZone : purchase_zone = purchase_zone{}

    Init<override>(inBase:base)<suspends>:void=
        (super:)Init(inBase)
        PurchaseZone.Init(inBase); PurchaseZone.Enable()
    
        

    
