using{/Fortnite.com/Devices}
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { Purchaseables}
using {Tooltips}
using {Abstractions.AbstractClasses}
using { GlobalPrint }
base<public>:=class<concrete>(creative_device):



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


    Init(inMaster:TycoonMaster):void=set maybeOwner=option{inMaster}

    OnBegin<override>()<suspends>:void=
        for:
            Purchaseable:PurchaseablesList
        do:
            spawn. Purchaseable.Init(Self)

        spawn{BaseClaimer.Init(Self)}
        spawn{asyncAwaitBaseClaim()}
        BaseClaimer.Enable(); 
        TestLeaveButton.InteractedWithEvent.Subscribe(FakeBaseLeave)
    
    FakeBaseLeave(Agent:agent):void={
        if:
            Player := player[Agent]
        then:
            Player.ManagePlayerLeaving()
    }
    asyncAwaitBaseClaim()<suspends>:void=
        loop:
            Agent := BaseClaimer.AgentEntersEvent.Await();
            case(Players.Length):
                0 =>
                    if:
                        Player := player[Agent]
                        Player.CanClaimBase[]
                    then:
                        Incorperate(Player)
                        set maybePrimaryPlayer = option{Player}
                _ =>
                    if:
                        Player := player[Agent]
                        Player.CanClaimBase[]
                    then:
                        Incorperate(Player)



    Incorperate(inPlayer:player):void=
        set Players += array{inPlayer}
        spawn{inPlayer.asyncAwaitLeave()}
        if:
            Owner := maybeOwner?
            PlayerStats := Owner.GetStats[inPlayer]
        then:
            set PlayerStats.maybeBase = option{Self}

        if:
            BaseClaimDebugWM[GetSession()]?
        then:
            LongSuccessPrint("A Player has joined the: {Descriptor.Name}!", "INC-001")


            
    (inPlayer:player).asyncAwaitLeave()<suspends>:void=loop{Player := GetPlayspace().PlayerRemovedEvent().Await().ManagePlayerLeaving()}     
               
            


    (inPlayer:player).ManagePlayerLeaving():void=
        if:
            inPlayer = inPlayer 
            PrimaryPlayer := maybePrimaryPlayer?
        then:
            set Players = Players.RemoveAllElements(inPlayer)
            if:
                inPlayer = PrimaryPlayer 
            then:
                if. Players.Length = 0 then. ResetBase()
                if. Players.Length >= 1 then. set maybePrimaryPlayer = option{Players[0]}
                if:
                    BaseLeaveDebugWM[GetSession()]?
                then:
                    LongMessagePrint("The PrimaryPlayer of {Descriptor.Name} has left", "AAL-001")
            else:
                if:
                    BaseLeaveDebugWM[GetSession()]?
                then:
                    LongMessagePrint("A Player has left the: {Descriptor.Name}!", "AAL-002")
        else:
            if:
                BaseLeaveDebugWM[GetSession()]?
            then:
                LongMessagePrint("{Descriptor.Name} has noticed a Player has left the experience and determined the player wasn't in their players list.", "AAL-003")
    ResetBase():void=
        LongMessagePrint("{Descriptor.Name}'s PrimaryPlayer has left! Initiating Base Reset", "RSB-001")
                
                
    

                



    (inPlayer:player).CanClaimBase()<transacts><decides>:void=
            Owner := maybeOwner?
            PlayerStats := Owner.GetStats[inPlayer]
            not PlayerStats.maybeBase?

            


    