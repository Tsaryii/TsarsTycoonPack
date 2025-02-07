using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using { /Fortnite.com/Devices }
using {Tooltips}
using {Textures}
using{Main.Classes}
using{Main.Abstractions.AbstractClasses}
using{Main.Abstractions.Interfaces}
using{GlobalPrint}

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

    #Debug Variables
    var SOnPurchaseDebugWM:logic=false

    SetupDebug<internal>()<transacts>:void=
        if. OnPurchaseDebugWM[GetSession()]?
        then. set SOnPurchaseDebugWM = true
    



    @editable var Descriptor : descriptor = descriptor{}
    @editable var CurrencyCosts : cost_field = cost_field{}
    @editable var PurchaseZone : purchase_zone = purchase_zone{}


    PurchasedEvent : event(agent) = event(agent){}

    #Initializes the purchaseable object
    Init<override>(inBase:base)<suspends>:void=
        (super:)Init(inBase)
        spawn{PurchaseZone.Init(inBase)};
        PurchaseZone.Enable(); 
        SetupDebug();
        sync:
            OnBegin()
            asyncAwaitPurchase();


    #For use of the purchaseable object's children classes
    OnBegin()<suspends>:void={}
        


     

    #The main loop for the purchaseable object
    asyncAwaitPurchase()<suspends>:void=
        loop:
            Agent:=PurchaseZone.AgentEntersEvent.Await(); 
            if:
                Player := player[Agent]
                CurrencyCosts.AttemptToChargePlayer[Player]
            then:
                Print("Purchasing")
                PurchasedEvent.Signal(Agent)
                ShortSuccessPrint("{Descriptor.Name} purchased", "AAP-001", SOnPurchaseDebugWM)
            else:
                Print("Failed to purchase")
                ShortErrorPrint("{Descriptor.Name} could not be purchased", "AAP-002", SOnPurchaseDebugWM)
                
    
        

    
