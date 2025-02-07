using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using {Tooltips}
using {Textures}
#specifies anything with cost and currency ID
cost_field<public>:=class<concrete>:

    @editable {ToolTip:=anyCostTT} Cost : float = 0.0
    @editable {ToolTip:=anyCurrencyIDTT} CostID : int = 1


    AttemptToChargePlayer<public>(Player:player)<transacts><decides>:void={}

