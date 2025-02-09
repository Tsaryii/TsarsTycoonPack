#Base Tool Tips
BasesTT<localizes><public>:message=
{"The list of all bases in your game."}


#Purchaseable Tool Tips
PurchaseableIconTT<localizes><public>:message=
{"The icon for this object, will be displayed in any relevant UI."}
    
PurchaseZoneTT<localizes><public>:message=
{"The zone in which this purchaseable can be bought."}


#Unique Zone Tool Tips
TransmitOnEntryTT<localizes><public>:message=
{"The triggers that will be activated when an agent enters the zone."}

TransmitOnExitTT<localizes><public>:message=
{"The triggers that will be activated when an agent exits the zone."}

BaseDependentTT<localizes><public>:message=
{"If true, the triggers and all other Zone dependent functions will only be activated if the agent who triggered them is in the base."}


DisableOnSuccessTT1<localizes><public>:message=
{"If true, the zone will be disabled & hidden after the player enters the zone"}

DisableOnSuccessTT2<localizes><public>:message=
{"If true, the zone will be disabled & hidden after any player in this base enters the zone"}



#Persistence Tool Tips

PersisterTT<localizes><public>:message=
{"A Device that manages the saving and loading of data. Should only be used once per base unless each base is identical."}


AllowPurchaseablePersistenceTT<localizes><public>:message=
{"If true, all purchaseable objects with persistence checked will be saved and loaded."}

AllowCurrencyPersistenceTT<localizes><public>:message=
{"If true, all currencies with persistence checked will be saved and loaded."}

AllowRebirthPersistenceTT<localizes><public>:message=
{"If true, all rebirths will be saved and loaded."}

PersistenceCoreTT<localizes><public>:message=
{"A Unique persistence identifier. For example, if you have two different base types, you can set this to 0 for the first base and 1 for the second base."}

MaximumCurrenciesToInitTT<localizes><public>:message=
{"The maximum number of currencies that will be initialized for each player. Turn this number down if you're experiencing performance issues."}

#Currency Tool Tips

CurrencyManagerTT<localizes><public>:message=
{"Can be used to add, remove, and modify currencies. ONE Manager can manage ALL bases unless you want different currencies for each base."}

InitialValueTT<localizes><public>:message=
{"The amount of this currency any player will start with."}