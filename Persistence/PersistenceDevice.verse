using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using { /Fortnite.com/Characters }
using { /Verse.org/Random }
using { /UnrealEngine.com/Temporary/SpatialMath }
using {Tooltips}
using {Main.Abstractions.Interfaces}
using {Main.Classes}
using{GlobalPrint}
persister<public>:=class<concrete>(creative_device, base_runtime):

    @editable {ToolTip:=AllowPurchaseablePersistenceTT} var AllowPurchaseablePersistence<public>:logic=true
    @editable {ToolTip:=AllowCurrencyPersistenceTT} var AllowCurrencyPersistence<public>:logic=true
    @editable {ToolTip:=AllowRebirthPersistenceTT} var AllowRebirthPersistence<public>:logic=true
    @editable {ToolTip:=PersistenceCoreTT} var PersistenceCore<public>:type{t:int where t >= 0, t <=100} = 0

    var maybeOwner:?base=false


    Init<override>(inBase:base)<suspends>:void=
        set maybeOwner = option. inBase
        SetupDebug()
        spawn{ManagePlayerPersistence()};
        


    ManagePlayerPersistence()<suspends>:void=
        Playspace:=GetPlayspace()
        for:
            Player:Playspace.GetPlayers()
        do:
            Player.SetupPersistence()
        loop. Playspace.PlayerAddedEvent().Await().SetupPersistence()
            
            
    #Debug Variables
    var SPersistenceSetupWM:logic=false

    SetupDebug<internal>()<transacts>:void=
        if(PersistenceSetupWM[GetSession()]?):
            Print("Debug Setup")
            set SPersistenceSetupWM = true
    



    #Change this value if you're using more than 100 persistence cores
    MaxPersistenceCores:int=100

    (Player:player).SetupPersistence()<transacts>:void=
        Print("Setting Up Persistence")
        if:
            not PlayerProfileDataMap[Player]
            set PlayerProfileDataMap[Player] = player_profile_data{}
        then:
            if(Owner := maybeOwner?):
                DelidPersistlessCurrencies(Player, Owner, "SP-002")
                Print("Debug Setup")
                var DelidMap : [int]int = map{}
                for:
                    Index -> Currency:Owner.CurrencyConfig.CurrencyList
                    set DelidMap[Index] = Currency.InitialValue
                do:
                    ShortMessagePrint("Setting up persistence for currency {Currency.Details.Name} ID: {Index} with core: {PersistenceCore}", "SP-001", SPersistenceSetupWM)
                    
                if:
                    PlayerData := GetStats[Player]
                    
                
                then:
                    Source := player_profile_data:
                        MakePlayerProfileData<constructor>(PlayerData)
                        CoreSaves:=ChangeCoreSave(PlayerData.CoreSaves, PersistenceCore, core_save{AssociatedCurrencies:=DelidMap})
                    if. set PlayerProfileDataMap[Player] = Source
            else:
                Print("No Owner")
                
        else:
            Print("Idb")
            if(Owner := maybeOwner?):
                ShortMessagePrint("Playe already has a profile data, skipping setup & trimming disabled currencies", "SP-003", SPersistenceSetupWM)
                DelidPersistlessCurrencies(Player, Owner, "SP-004")
                
            
                        
    DelidPersistlessCurrencies(Player:player, Owner:base, SP:string)<transacts>:void=
            for:
                Index -> Currency:Owner.CurrencyConfig.CurrencyList
                PlayerData := GetStats[Player]
            do:
                if(not Currency.Persist?):
                    if. (Index).Delid[Player, PersistenceCore]
                    ShortMessagePrint("Currency {Currency.Details.Name} had persistence disabled, removing any saved values", "{SP}", SPersistenceSetupWM)
                    


    