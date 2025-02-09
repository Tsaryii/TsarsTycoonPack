using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }
using{Purchaseables}
using{Abstractions.Interfaces}
using{Tooltips}
using{Classes}
using{GlobalPrint}


transmitable_zone<public>:=class<concrete>(unique_zone):

        @editable {ToolTip:=TransmitOnEntryTT} var TransmitOnEntry : []trigger_device = array{}
        @editable {ToolTip:=TransmitOnExitTT} var TransmitOnExit : []trigger_device = array{}

        Init<override>(inBase:base)<suspends>:void={
                set Name = "{inBase.Details.Name}'s Unnamed Volume Device"
                loop:
                        race:
                                block:
                                        Agent := Volume.AgentEntersEvent.Await()
                                        validStatus := CheckValidity(inBase, Agent)
                                        if. validStatus? then. AgentEntersEvent.Signal(Agent); OnEntry(inBase, Agent)
                                        if. DisableOnSuccess? and validStatus? then. Disable()
                                block:
                                        Agent := Volume.AgentExitsEvent.Await()
                                        validStatus := CheckValidity(inBase, Agent)
                                        if. validStatus? then. AgentExitsEvent.Signal(Agent); OnExit(inBase, Agent)
                

                }

        CheckValidity(inBase:base, Agent:agent):logic=
                if:
                        SUniqueZoneDebugWM := UniqueZoneDebugWM[GetSession()]
                        SUniqueZoneDebugWM?
                then:
                        if:
                                not Status? 
                        then:
                                ShortMessagePrint("{Name}: Transmittable Zone is disabled", "CV-001", SUniqueZoneDebugWM)
                                false
                        else:
                                ShortSuccessPrint("{Name}: Transmittable Zone passed all checks", "CV-002", SUniqueZoneDebugWM)
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
                do:
                        inTrigger.Trigger(Agent)
        

        OnExit(inBase:base, Agent:agent):void=
                for:
                        outTrigger:TransmitOnExit
                do:
                        outTrigger.Trigger(Agent)



purchase_zone<public>:=class<concrete>(transmitable_zone):


        @editable {ToolTip:=BaseDependentTT} var BaseDependent : logic = true
        @editable {ToolTip:=DisableOnSuccessTT2} var DisableOnSuccess <override> : logic=false

        CheckValidity<override>(inBase:base, Agent:agent):logic=
                #Error Checking
                if:
                        SUniqueZoneDebugWM := UniqueZoneDebugWM[GetSession()]  
                        SUniqueZoneDebugWM?
                then{
                        
                if. not Status? then. ShortMessagePrint("{Name}: PurchaseZone is disabled", "CV-003", SUniqueZoneDebugWM)
                if:
                        Player := player[Agent]
                        BaseDependent? and not inBase.Players.Find[Player]
                then:
                        LongErrorPrint("{Name}: Player is not in base when base dependent", "CV-004", SUniqueZoneDebugWM)
                else if:
                        Player := player[Agent]
                        BaseDependent? and inBase.Players.Find[Player]
                        ShortSuccessPrint("Successfully purchased, from: {Name}", "CV-005", SUniqueZoneDebugWM)
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








unique_zone<public>:=class(togglet, base_runtime, restorable):

            var inited:logic=false
            var DefaultLoc:transform=transform{}

            var Name:string=""
            @editable {ToolTip:=PurchaseZoneTT}var Volume : volume_device = volume_device{}
            @editable {ToolTip:=DisableOnSuccessTT1} var DisableOnSuccess:logic=false

            AgentEntersEvent<public>:event(agent)=event(agent){}
            AgentExitsEvent<public>:event(agent)=event(agent){}
            Init<override>(inBase:base)<suspends>:void={
                        set Name = "{inBase.Details.Name}'s Volume Device"
                        set DefaultLoc = Volume.GetTransform(); set inited = true
                loop:
                        race:
                                block:
                                        Agent := Volume.AgentEntersEvent.Await()
                                        if. Status? then. AgentEntersEvent.Signal(Agent)
                                        if. DisableOnSuccess? and Status? then. Disable()
                                block:
                                        Agent := Volume.AgentExitsEvent.Await()
                                        if. Status? then. AgentExitsEvent.Signal(Agent)
                

                }

        Restore<override>()<transacts>:void=
                if:
                        inited?
                        Volume.TeleportTo[DefaultLoc]
                else:
                        if. Debug := UniqueZoneDebugWM[GetSession()]
                        then. ShortMessagePrint("Cannot Restore {Name} as it has not been initialized.", "RES-001", Debug)

        Disable<override>():void=
                (super:)Disable();
                DefaultLocTranslation := DefaultLoc.Translation
                UnderGroundLoc : transform = transform{
                        Translation := vector3{X:=DefaultLocTranslation.X, Y:=DefaultLocTranslation.Y, Z:=-1000.0}
                        Rotation := DefaultLoc.Rotation
                        Scale := DefaultLoc.Scale
                }
                spawn. Volume.MoveTo(UnderGroundLoc, 1.0)
                

        


                        
