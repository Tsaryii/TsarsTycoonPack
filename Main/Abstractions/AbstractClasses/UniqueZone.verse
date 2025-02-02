using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using{Abstractions.Interfaces}

unique_zone<public>:=class(togglet, iBeginAsync):

            @editable var Volume : volume_device = volume_device{}

            AgentEntersEvent:event(agent)=event(agent){}
            AgentExitsEvent:event(agent)=event(agent){}

            Enable<override>():void={}
            Disable<override>():void={}

            OnBegin<override>()<suspends>:void={
                

    }

