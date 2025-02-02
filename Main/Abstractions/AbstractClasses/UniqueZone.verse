using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using{Abstractions.Interfaces}
using{Tooltips}
purchase_zone<public>:=class<concrete>(unique_zone):

        @editable {ToolTip:=TransmitOnEntryTT} var TransmitOnEntry : []trigger_device = array{}
        @editable {ToolTip:=TransmitOnExitTT} var TransmitOnExit : []trigger_device = array{}

        OnBegin<override>()<suspends>:void={
                loop:
                        race:
                                block:
                                        Agent := Volume.AgentEntersEvent.Await()
                                        if. Status? then. AgentEntersEvent.Signal(Agent); OnEntry(?Agent:=Agent)
                                block:
                                        Agent := Volume.AgentExitsEvent.Await()
                                        if. Status? then. AgentExitsEvent.Signal(Agent); OnExit(?Agent:=Agent)
                

                }

        OnEntry(?Agent:agent):void=
                for:
                        inTrigger:TransmitOnEntry
                do:
                        inTrigger.Trigger(Agent)
        

        OnExit(?Agent:agent):void=
                for:
                        outTrigger:TransmitOnExit
                do:
                        outTrigger.Trigger(Agent)


unique_zone<public>:=class(togglet, iBeginAsync):

            @editable {ToolTip:=PurchaseZoneTT}var Volume : volume_device = volume_device{}

            AgentEntersEvent:event(agent)=event(agent){}
            AgentExitsEvent:event(agent)=event(agent){}
            OnBegin<override>()<suspends>:void={
                loop:
                        race:
                                block:
                                        Agent := Volume.AgentEntersEvent.Await()
                                        if. Status? then. AgentEntersEvent.Signal(Agent)
                                block:
                                        Agent := Volume.AgentExitsEvent.Await()
                                        if. Status? then. AgentExitsEvent.Signal(Agent)
                

                }

