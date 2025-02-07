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
                if:
                        Descriptor.Name = "Unnamed Volume Device"
                then:
                        set Descriptor.Name = "{inBase.Descriptor.Name}'s Unnamed Volume Device"
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
                if. not Status? then. ShortMessagePrint("{Descriptor.Name}: PurchaseZone is disabled", "CV-001", UniqueZoneDebugWM[GetSession()]?)
                Status?
                Player := player[Agent]

                        
                        



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
                #Error Checking
                if. not Status? then. ShortMessagePrint("{Descriptor.Name}: PurchaseZone is disabled", "CV-002", UniqueZoneDebugWM[GetSession()]?)
                if:
                        Player := player[Agent]
                        not inBase.Players.Find[Player] and BaseDependent?
                then. LongErrorPrint("{Descriptor.Name}: Player is not in base", "CV-003", UniqueZoneDebugWM[GetSession()]?)
                else. LongErrorPrint("{Descriptor.Name}: Internal Erorr when resolving Base Player Loc.", "CV-004", UniqueZoneDebugWM[GetSession()]?)
                Print("Length: {inBase.Players.Length}")


                #Actual Check
                Status?
                Player2 := player[Agent]
                not BaseDependent? or BaseDependent? and inBase.Players.Find[Player2]








unique_zone<public>:=class(togglet, isubBaseInitAsync):

           
            @editable {ToolTip:=PurchaseZoneTT}var Volume : volume_device = volume_device{}
            @editable {ToolTip:=anyNameTT} var Descriptor : descriptor = descriptor{Icon:=false}
            AgentEntersEvent<public>:event(agent)=event(agent){}
            AgentExitsEvent<public>:event(agent)=event(agent){}
            Init<override>(inBase:base)<suspends>:void={
                if:
                        Descriptor.Name = "Unnamed Volume Device"
                then:
                        set Descriptor.Name = "{inBase.Descriptor.Name}'s Unnamed Volume Device"
                loop:
                        race:
                                block:
                                        Agent := Volume.AgentEntersEvent.Await()
                                        if. Status? then. AgentEntersEvent.Signal(Agent)
                                block:
                                        Agent := Volume.AgentExitsEvent.Await()
                                        if. Status? then. AgentExitsEvent.Signal(Agent)
                

                }

