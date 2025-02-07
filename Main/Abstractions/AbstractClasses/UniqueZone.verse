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
                                        if. CheckValidity(inBase, Agent)? then. AgentEntersEvent.Signal(Agent); OnEntry(inBase, Agent)
                                block:
                                        Agent := Volume.AgentExitsEvent.Await()
                                        if. CheckValidity(inBase, Agent)? then. AgentExitsEvent.Signal(Agent); OnExit(inBase, Agent)
                

                }

        CheckValidity(inBase:base, Agent:agent)<transacts>:logic=
                if:
                        SUniqueZoneDebugWM := UniqueZoneDebugWM[GetSession()]?
                then:
                        if:
                                not Status? 
                        then:
                                ShortMessagePrint("{Descriptor.Name}: Transmittable Zone is disabled", "CV-001", SUniqueZoneDebugWM)
                                false
                        else:
                                ShortMessagePrint("{Descriptor.Name}: Transmittable Zone passed all checks", "CV-002", SUniqueZoneDebugWM)
                                true
                else:
                        if:
                                Status? 
                        then:
                                true
                        else:
                                false



                        
                        



        OnEntry(inBase:base, Agent:agent):void=
                for:
                        inTrigger:TransmitOnEntry
                        CheckValidity(inBase, Agent)?
                do:
                        inTrigger.Trigger(Agent)
        

        OnExit(inBase:base, Agent:agent):void=
                for:
                        outTrigger:TransmitOnExit
                        CheckValidity(inBase, Agent)?
                do:
                        outTrigger.Trigger(Agent)



purchase_zone<public>:=class<concrete>(transmitable_zone):


        @editable {ToolTip:=BaseDependentTT} var BaseDependent : logic = true

        CheckValidity<override>(inBase:base, Agent:agent)<transacts>:logic=
                #Error Checking
                if. SUniqueZoneDebugWM := UniqueZoneDebugWM[GetSession()]?
                then{
                        Print("Inside PurchaseZone CheckValidity", ?Duration:=5.5)
                if. not Status? then. ShortMessagePrint("{Descriptor.Name}: PurchaseZone is disabled", "CV-003", SUniqueZoneDebugWM)
                if:
                        Player := player[Agent]
                        not inBase.Players.Find[Player] and BaseDependent?
                then. LongErrorPrint("{Descriptor.Name}: Player is not in base", "CV-004", SUniqueZoneDebugWM)
                else. LongErrorPrint("{Descriptor.Name}: Internal Erorr when resolving Base Player Loc.", "CV-005", SUniqueZoneDebugWM)
                }
                                


                #Actual Check
                if:
                        Status?
                        Player2 := player[Agent]
                        not BaseDependent? or BaseDependent? and inBase.Players.Find[Player2]
                then:
                        true
                else:
                        false








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

