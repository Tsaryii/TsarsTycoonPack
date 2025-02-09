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
using {Persistence}
using {Currencies}

base<public>:=class<concrete>(creative_device, restorable):



    var maybeOwner:?TycoonMaster=false

    #Variables
    var Players<public>:[]player=array{}
    var maybePrimaryPlayer<public>:?player=false
    


    #Events
    var OnBaseClaim : event(player) = event(player){}


    #Editable Configs


    #Editable Variables
    @editable var TestLeaveButton <public> : button_device = button_device{}
    @editable var  Details <public> : descriptor = descriptor{Name:="My Base Name here"}
    @editable var  BaseClaimer <public> : transmitable_zone = transmitable_zone{}
    @editable {Categories:=array{ConfigsCategory}, ToolTip:=PersisterTT} var PersistentConfig <public> : persister = persister{}
    @editable {Categories:=array{ConfigsCategory}, ToolTip:=CurrencyManagerTT} var CurrencyConfig <public> : currency_manager = currency_manager{}
    @editable_container {AllowReordering:=true} var purchaseables <public> : []purchaseable = array{}


    ConfigsCategory <localizes><public>:message="Device Configs"



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
            Purchaseable:purchaseables
        do:
            spawn. Purchaseable.Init(Self)

        spawn{BaseClaimer.Init(Self)}
        spawn{AwaitBaseClaim()}
        spawn{PersistentConfig.Init(Self)}
        spawn{CurrencyConfig.Init(Self)}
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
                    LongMessagePrint("Player attempted to claim {Details.Name} but was denied", "ABC-001", SBaseClaimDebugWM)
            else if. Players.Length>=1 then:
                if:
                    Player := player[Agent]
                    Player.CanClaimBase[]
                then:
                    Incorperate(Player)
                else:
                    LongMessagePrint("Player attempted to claim {Details.Name} but was denied", "ABC-002", SBaseClaimDebugWM)
            Sleep(1.0)



    Incorperate(inPlayer:player):void=
        if:
            Owner := maybeOwner?
            PlayerStats := Owner.GetStats[inPlayer]
        then:
            set PlayerStats.maybeBase = option{Self}
            set Players += array{inPlayer}
            spawn{inPlayer.AwaitLeave()}
            LongSuccessPrint("A Player has joined the: {Details.Name}!", "INC-001", SBaseClaimDebugWM)
        else:
            LongErrorPrint("Failed to fetch owner when resolving player in {Details.Name}", "INC-002", SBaseClaimDebugWM)


            
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
                LongMessagePrint("The PrimaryPlayer of {Details.Name} has left", "AAL-001", SBaseLeaveDebugWM)
            else:
                LongMessagePrint("A Player has left the: {Details.Name}!", "AAL-002", SBaseLeaveDebugWM)
            if:
                Owner := maybeOwner?
                PlayerStats := Owner.GetStats[inPlayer]
            then:
                set PlayerStats.maybeBase = false
        else:
            ShortMessagePrint("{Details.Name} has noticed a Player has left the experience and determined the player wasn't in their players list.", "AAL-003", SBaseLeaveDebugWM)
                
    ResetBase():void=
        LongMessagePrint("{Details.Name}'s PrimaryPlayer has left! Initiating Base Reset", "RSB-001", SBaseLeaveDebugWM)
            
                
                
    

                



    (inPlayer:player).CanClaimBase()<transacts><decides>:void=
            Owner := maybeOwner?
            PlayerStats := Owner.GetStats[inPlayer]
            not PlayerStats.maybeBase?

    Restore<override>()<transacts>:void=
        BaseClaimer.Restore()
        for:
            Purchaseable:purchaseables
        do:
            Purchaseable.Restore()

            


    