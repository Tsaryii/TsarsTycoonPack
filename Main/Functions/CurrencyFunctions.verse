using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using {Tooltips}
using {Textures}
using {Persistence}
using {Classes}
(Player:player).RemoveCurrency<public>(inBase:base, CurrencyAmount:int, CurrencyID:int)<transacts><decides>:void=
        PersistenceCore := inBase.PersistentConfig.PersistenceCore
        Stats := Player.GetCoreStats[PersistenceCore]
        CurrencyValue := Stats.AssociatedCurrencies[CurrencyID]
        NewValue := CurrencyValue - CurrencyAmount
        Player.UpdateAssociatedCurrencies(CurrencyID, NewValue, PersistenceCore)
