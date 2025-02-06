using{/Fortnite.com/Devices}
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/SpatialMath }
using {Tooltips}
using {Abstractions.AbstractClasses}


TycoonMaster:=class<concrete>(creative_device):
    var VPlayerStats <public> : [player]vplayerstats =map{}

    @editable_container {ToolTip:=BasesTT, AllowReordering:=true} var Bases : []base = array{}
    @editable var ZoneTest : unique_zone = unique_zone{} 


    OnBegin<override>()<suspends>:void=
        spawn{asyncManageVStats()}  
        for:
            inBase:Bases
        do:
            inBase.Init(Self)



    asyncManageVStats()<suspends>:void=
        Playspace := GetPlayspace()
        for:
            Player:Playspace.GetPlayers()
        do:
            Player.InitVStats()

        loop{Playspace.PlayerAddedEvent().Await().InitVStats()}
            

    


    (Player:player).InitVStats():void=if. set VPlayerStats[Player]=vplayerstats{}
       
    GetStats(Player:player)<transacts><decides>:vplayerstats={return VPlayerStats[Player]}