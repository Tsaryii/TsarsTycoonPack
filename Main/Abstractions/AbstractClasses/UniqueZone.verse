using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using{Purchaseables}
using{Abstractions.Interfaces}
using{Tooltips}
using{Classes}
using{GlobalPrint}


transmitable_zone<public>:=class<concrete>(unique_zone):

        @editable {ToolTip:=TransmitOnEntryTT} var TransmitOnEntry : []trigger_device = array{}
        @editable {ToolTip:=TransmitOnExitTT} var TransmitOnExit : []trigger_device = array{}

        Init<override>(inBase:base)<suspends>:void={
                loop:
                        race:
                                block:
                                        Agent := Volume.AgentEntersEvent.Await()
                                        if. CheckValidity[inBase, Agent] then. AgentEntersEvent.Signal(Agent); OnEntry(inBase, Agent)
                                block:
                                        Agent := Volume.AgentExitsEvent.Await()
                                        if. CheckValidity[inBase, Agent] then. AgentExitsEvent.Signal(Agent); OnExit(inBase, Agent)
                

                }

        CheckValidity(inBase:base, Agent:agent)<transacts><decides>:void=
                if:
                        Status?
                        Player := player[Agent]
                then:
                        true
                else if:
                        UniqueZoneDebugWM[GetSession()]?
                then:
                        if. not Status? then. Print("ERR for {Name}: PurchaseZone is disabled")



        OnEntry(inBase:base, Agent:agent):void=
                for:
                        inTrigger:TransmitOnEntry
                        CheckValidity[inBase, Agent]
                do:
                        inTrigger.Trigger(Agent)
        

        OnExit(inBase:base, Agent:agent):void=
                for:
                        outTrigger:TransmitOnExit
                        CheckValidity[inBase, Agent]
                do:
                        outTrigger.Trigger(Agent)



purchase_zone<public>:=class<concrete>(transmitable_zone):


        @editable {ToolTip:=BaseDependentTT} var BaseDependent : logic = true

        CheckValidity<override>(inBase:base, Agent:agent)<transacts><decides>:void=
                if:
                        Status?
                        Player := player[Agent]
                        not BaseDependent? or inBase.Players.Find[Player]
                then:
                        true
                else if:
                        UniqueZoneDebugWM[GetSession()]?
                then:
                        if. not Status? then. Print("ERR for {Name}: PurchaseZone is disabled")
                        if:
                                Player := player[Agent]
                                not inBase.Players.Find[Player] and BaseDependent?
                        then. Print("ERR for {Name}: Player Not Found in base whilst BaseDependent is true")






unique_zone<public>:=class(togglet, isubBaseInitAsync):

            @editable {ToolTip:=anyNameTT} var Name : string = "Unnamed Volume Device"
            @editable {ToolTip:=PurchaseZoneTT}var Volume : volume_device = volume_device{}

            AgentEntersEvent:event(agent)=event(agent){}
            AgentExitsEvent:event(agent)=event(agent){}
            Init<override>(inBase:base)<suspends>:void={
                if:
                        Name = "Unnamed Volume Device"
                then:
                        set Name = "{inBase.Name}'s Unnamed Volume Device"
                loop:
                        race:
                                block:
                                        Agent := Volume.AgentEntersEvent.Await()
                                        if. Status? then. AgentEntersEvent.Signal(Agent)
                                block:
                                        Agent := Volume.AgentExitsEvent.Await()
                                        if. Status? then. AgentExitsEvent.Signal(Agent)
                

                }

