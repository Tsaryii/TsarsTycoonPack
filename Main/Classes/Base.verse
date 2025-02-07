using{/Fortnite.com/Devices}
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { Purchaseables}
using {Tooltips}
using {Abstractions}
using {AbstractClasses}
using {Interfaces}
using {GlobalPrint}

base<public>:=class<concrete>(creative_device, restorable):



    var maybeOwner:?TycoonMaster=false

    #Variables
    var Players<public>:[]player=array{}
    var maybePrimaryPlayer<public>:?player=false
    


    #Events
    var OnBaseClaim : event(player) = event(player){}

    #Editable Variables
    @editable var  Descriptor <public> : descriptor = descriptor{Name:="My Base Name here"}
    @editable var  BaseClaimer <public> : transmitable_zone = transmitable_zone{}
    @editable var TestLeaveButton <public> : button_device = button_device{}
    @editable_container {AllowReordering:=true} var PurchaseablesList <public> : []purchaseable = array{}



    #Debug Variables
    var SBaseClaimDebugWM:logic=false
    var SBaseLeaveDebugWM:logic=false

    SetupDebug<internal>()<transacts>:void=
        if. BaseClaimDebugWM[GetSession()]?
        then. set SBaseClaimDebugWM = true
    
        if. BaseLeaveDebugWM[GetSession()]?     
        then. set SBaseLeaveDebugWM = true
            

    Init(inMaster:TycoonMaster):void=set maybeOwner=option{inMaster}

    OnBegin<override>()<suspends>:void=
        for:
            Purchaseable:PurchaseablesList
        do:
            spawn. Purchaseable.Init(Self)

        spawn{BaseClaimer.Init(Self)}
        spawn{AwaitBaseClaim()}
        BaseClaimer.Enable(); 
        TestLeaveButton.InteractedWithEvent.Subscribe(FakeBaseLeave)
        SetupDebug()



    
    FakeBaseLeave(Agent:agent):void={
        if:
            Player := player[Agent]
        then:
            Player.ManagePlayerLeaving()
    }
    AwaitBaseClaim()<suspends>:void=
        loop:
            Agent := BaseClaimer.AgentEntersEvent.Await();
            
            if. Players.Length=0 then:
                if:
                    Player := player[Agent]
                    Player.CanClaimBase[]
                then:
                    Incorperate(Player)
                    set maybePrimaryPlayer = option{Player}
                else:
                    LongMessagePrint("Player attempted to claim {Descriptor.Name} but was denied", "ABC-001", SBaseClaimDebugWM)
            else if. Players.Length>=1 then:
                if:
                    Player := player[Agent]
                    Player.CanClaimBase[]
                then:
                    Incorperate(Player)
                else:
                    LongMessagePrint("Player attempted to claim {Descriptor.Name} but was denied", "ABC-002", SBaseClaimDebugWM)
            Sleep(1.0)



    Incorperate(inPlayer:player):void=
        if:
            Owner := maybeOwner?
            PlayerStats := Owner.GetStats[inPlayer]
        then:
            set PlayerStats.maybeBase = option{Self}
            set Players += array{inPlayer}
            spawn{inPlayer.AwaitLeave()}
            LongSuccessPrint("A Player has joined the: {Descriptor.Name}!", "INC-001", SBaseClaimDebugWM)
        else:
            LongErrorPrint("Failed to fetch owner when resolving player in {Descriptor.Name}", "INC-002", SBaseClaimDebugWM)


            
    (inPlayer:player).AwaitLeave()<suspends>:void=loop{Player := GetPlayspace().PlayerRemovedEvent().Await().ManagePlayerLeaving()}     
               
            


    (inPlayer:player).ManagePlayerLeaving():void=
        if:
            Players.Find[inPlayer] 
            PrimaryPlayer := maybePrimaryPlayer?
        then:
            set Players = Players.RemoveAllElements(inPlayer)
            if:
                inPlayer = PrimaryPlayer 
            then:
                if. Players.Length = 0 then. ResetBase()
                else if. Players.Length >= 1 then. set maybePrimaryPlayer = option{Players[0]}
                LongMessagePrint("The PrimaryPlayer of {Descriptor.Name} has left", "AAL-001", SBaseLeaveDebugWM)
            else:
                LongMessagePrint("A Player has left the: {Descriptor.Name}!", "AAL-002", SBaseLeaveDebugWM)
            if:
                Owner := maybeOwner?
                PlayerStats := Owner.GetStats[inPlayer]
            then:
                set PlayerStats.maybeBase = false
        else:
            ShortMessagePrint("{Descriptor.Name} has noticed a Player has left the experience and determined the player wasn't in their players list.", "AAL-003", SBaseLeaveDebugWM)
                
    ResetBase():void=
        LongMessagePrint("{Descriptor.Name}'s PrimaryPlayer has left! Initiating Base Reset", "RSB-001", SBaseLeaveDebugWM)
            
                
                
    

                



    (inPlayer:player).CanClaimBase()<transacts><decides>:void=
            Owner := maybeOwner?
            PlayerStats := Owner.GetStats[inPlayer]
            not PlayerStats.maybeBase?

    Restore<override>()<transacts>:void=
        BaseClaimer.Restore()
        for:
            Purchaseable:PurchaseablesList
        do:
            Purchaseable.Restore()

            


    