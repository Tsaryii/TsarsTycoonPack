using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using {Tooltips}
using {Textures}
using {Persistence}
using {Classes}
using {Functions}
using{GlobalPrint}
#specifies anything with cost and currency ID
cost_field<public>:=class<concrete>:

    @editable {ToolTip:=anyCostTT} Cost : int = 1
    @editable {ToolTip:=anyCurrencyIDTT} CostID : int = 0


    Submit<public>(inBase:base, Player:player)<transacts><decides>:void=
    {
        Print("Got to submit")
        Player.HasEnoughCurrency[inBase]
        if.  ShortSuccessPrint("Item costing {Cost} with ID {CostID} parsed `HasEnoughCurrency` check.", "SBM-001", CurrencyCategoryWM[GetSession()]?)


        Player.RemoveCurrency[inBase, Cost, CostID]
        if. ShortSuccessPrint("Item costing {Cost} with ID {CostID} parsed `RemoveCurrency` check.", "SBM-002", CurrencyCategoryWM[GetSession()]?)
        
    }

    (Player:player).HasEnoughCurrency(inBase:base)<transacts><decides>:void=
        if. ShortMessagePrint("Establishing & Checking Currency Values", "HEC-001", CurrencyCategoryWM[GetSession()]?)
    
        Print("Checking Currency Values, Cost: {Cost}, CostID: {CostID}")
        PersistenceCore := inBase.PersistentConfig.PersistenceCore
        Stats := Player.GetCoreStats[PersistenceCore]
        Print("Got Stats")
        CurrencyValue := Stats.AssociatedCurrencies[CostID]
        Print("Got Currency Value")
        Print("Checking Currency Values, Cost: {Cost}, CostID: {CostID}, CurrencyValue: {CurrencyValue}")
        CurrencyValue >= Cost

    
    
    

