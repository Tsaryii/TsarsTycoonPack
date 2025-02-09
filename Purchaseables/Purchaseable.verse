using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using { /Fortnite.com/Devices }
using { /Fortnite.com/Characters }
using {Tooltips}
using {Textures}
using{Main.Classes}
using{Main.Abstractions.AbstractClasses}
using{Main.Abstractions.Interfaces}
using{GlobalPrint}

base_ownable<public>:=class(base_runtime):

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
purchaseable<public>:=class<concrete>(base_ownable, restorable):

    #Debug Variables
    var SOnPurchaseDebugWM:logic=false

    SetupDebug<internal>()<transacts>:void=
        if(OnPurchaseDebugWM[GetSession()]?):
            set SOnPurchaseDebugWM = true
    



    @editable var Details : descriptor = descriptor{}
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
            AwaitPurchase();


    #For use of the purchaseable object's children classes
    OnBegin()<suspends>:void={}
        


     

    #The main loop for the purchaseable object
    AwaitPurchase()<suspends>:void=
        loop:
            Agent:=PurchaseZone.AgentEntersEvent.Await(); 
            if:
                Player := player[Agent]
                CurrencyCosts.AttemptToChargePlayer[Player]
            then:
                PurchasedEvent.Signal(Agent)
                ShortSuccessPrint("{Details.Name} purchased", "AP-001", SOnPurchaseDebugWM)
                spawn{OnPurchase()}
            else:
                ShortErrorPrint("{Details.Name} could not be purchased", "AP-002", SOnPurchaseDebugWM)


    OnPurchase()<suspends>:void={}
              
    
    Restore<override>()<transacts>:void=
        PurchaseZone.Restore()
    
        

    
