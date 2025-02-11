using { /Verse.org/Simulation }

#Defines the player profile data class and the map that stores it
player_profile_data <public> := class<final><persistable>:
    Version:int = 0
    CoreSaves  : [int]core_save = map{}


core_save <public> := class <final><persistable>:
    Rebirths <public> :int = 0
    AssociatedCurrencies <public>  : [int]int = map{}
    AssociatedUnlocks <public>  : []int = array{}
    Experience <public>  : int = 0

 
#Defines the map that stores the player profile data
var PlayerProfileDataMap:weak_map(player, player_profile_data) = map{}




#Creates a new player profile data object
MakePlayerProfileData<constructor>(Src:player_profile_data)<transacts> := player_profile_data:
    Version := Src.Version+1
    CoreSaves:=Src.CoreSaves

MakeCoreSave<constructor>(Src:core_save)<transacts> := core_save:
    Rebirths:=Src.Rebirths
    AssociatedCurrencies:= Src.AssociatedCurrencies
    AssociatedUnlocks:= Src.AssociatedUnlocks
    Experience := Src.Experience

ChangeCoreSave(Src:[int]core_save, id:int, coresave:core_save)<transacts>:[int]core_save=
    var temp: [int]core_save = Src
    if. set temp[id] = coresave; temp

    

RemoveRebirth(P:player, CoreSaveID:int)<transacts>:void=
    if:
        P.IsActive[]
        Map := PlayerProfileDataMap[P]
    then:
        if:
            EstablishedSave := Map.CoreSaves[CoreSaveID]
            
            NewSave := core_save:
                MakeCoreSave<constructor>(EstablishedSave)
                Rebirths:=EstablishedSave.Rebirths-1

            set PlayerProfileDataMap[P] = player_profile_data:
                MakePlayerProfileData<constructor>(Map)
                CoreSaves:=ChangeCoreSave(Map.CoreSaves, CoreSaveID, NewSave)

            



Rebirth(P:player, CoreSaveID:int)<transacts>:void=
    if:
        P.IsActive[]
        Map := PlayerProfileDataMap[P]
    then:
        if:
            EstablishedSave := Map.CoreSaves[CoreSaveID]
            
            NewSave := core_save:
                MakeCoreSave<constructor>(EstablishedSave)
                Rebirths:=EstablishedSave.Rebirths+1

            set PlayerProfileDataMap[P] = player_profile_data:
                MakePlayerProfileData<constructor>(Map)
                CoreSaves:=ChangeCoreSave(Map.CoreSaves, CoreSaveID, NewSave)

            

(CurrencyID:int).Delid(P:player, CoreSaveID:int)<transacts><decides>:void=
    
    if:
        P.IsActive[]
        Map := PlayerProfileDataMap[P]
    then:
        var DelidMap: [int]int = Map.CoreSaves[CoreSaveID].AssociatedCurrencies; set DelidMap[CurrencyID] = 0
        EstablishedSave := Map.CoreSaves[CoreSaveID]
        NewSave := core_save:
            MakeCoreSave<constructor>(EstablishedSave)
            AssociatedCurrencies := DelidMap


        set PlayerProfileDataMap[P] = player_profile_data:
            MakePlayerProfileData<constructor>(Map)
            CoreSaves:=ChangeCoreSave(Map.CoreSaves, CoreSaveID, NewSave)
        

DelidUnlocks(P:player, CoreSaveID:int)<transacts><decides>:void=
    var DelidMap: []int = array{}
    if:
        P.IsActive[]
        Map := PlayerProfileDataMap[P]

        EstablishedSave := Map.CoreSaves[CoreSaveID]
        NewSave := core_save:
            MakeCoreSave<constructor>(EstablishedSave)
            AssociatedUnlocks := DelidMap


        set PlayerProfileDataMap[P] = player_profile_data:
            MakePlayerProfileData<constructor>(Map)
            CoreSaves:=ChangeCoreSave(Map.CoreSaves, CoreSaveID, NewSave)

#Updates the associated currencies for a player
(P:player).UpdateAssociatedCurrencies<public>(CurrencyKey:int, CurrencyValue:int, CoreSaveID:int)<transacts>:void=
    if:
        P.IsActive[]
        Map := PlayerProfileDataMap[P]
        EstablishedSave := Map.CoreSaves[CoreSaveID]
        

        var PastCurrency : [int]int = Map.CoreSaves[CoreSaveID].AssociatedCurrencies
        set PastCurrency[CurrencyKey] = CurrencyValue

        NewSave := core_save:
            MakeCoreSave<constructor>(EstablishedSave)
            AssociatedCurrencies := PastCurrency

        set PlayerProfileDataMap[P] = player_profile_data:
            MakePlayerProfileData<constructor>(Map)
            CoreSaves:=ChangeCoreSave(Map.CoreSaves, CoreSaveID, NewSave)


UpdateAssociatedUnlocks(P:player, Index:int, CoreSaveID:int)<transacts>:void=
    if:
        P.IsActive[]
        Map := PlayerProfileDataMap[P]

        EstablishedSave := Map.CoreSaves[CoreSaveID]
        NewSave := core_save:
            MakeCoreSave<constructor>(EstablishedSave)
            AssociatedUnlocks := Map.CoreSaves[CoreSaveID].AssociatedUnlocks + array{(Index)}

        set PlayerProfileDataMap[P] = player_profile_data:
            MakePlayerProfileData<constructor>(Map)
            CoreSaves:=ChangeCoreSave(Map.CoreSaves, CoreSaveID, NewSave)
            
                


            
UpdateXP(P:player, XP:int, CoreSaveID:int)<transacts>:void=
    if:
        P.IsActive[]
        Map := PlayerProfileDataMap[P]

        EstablishedSave := Map.CoreSaves[CoreSaveID]
        NewSave := core_save:
            MakeCoreSave<constructor>(EstablishedSave)
            Experience := XP

        set PlayerProfileDataMap[P] = player_profile_data:
            MakePlayerProfileData<constructor>(Map)
            CoreSaves:=ChangeCoreSave(Map.CoreSaves, CoreSaveID, NewSave)
#Gets the associated currencies for a player
GetStats<public>(Agent:agent)<decides><transacts>:player_profile_data=
{
    var PlayerStats : player_profile_data = player_profile_data{}
    if:
        Player := player[Agent]
        PlayerStatsTable := PlayerProfileDataMap[Player]
        set PlayerStats = MakePlayerProfileData(PlayerStatsTable)
    then:
    PlayerStats
}
     
(Agent:agent).GetCoreStats<public>(CoreStatsID:int)<decides><transacts>:core_save=
    {
        var PlayerStats : player_profile_data = player_profile_data{}
        if:
            Player := player[Agent]
            PlayerStatsTable := PlayerProfileDataMap[Player]
            set PlayerStats = MakePlayerProfileData(PlayerStatsTable)
        then:
        PlayerStats.CoreSaves[CoreStatsID]
    }
         