using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using {Tooltips}
using {Textures}

#Describes the most basic parts of an object such as: Name, Description & Icon. 
descriptor<public>:=class<concrete>():

    

   @editable {ToolTip:=anyNameTT} Name : string = "My Item Name Here"

   @editable_text_box {ToolTip:=anyDescriptionTT, MultiLine:=true, MaxLength:=300} Description : string = "Hello World! \nI am using Tsars Tycoon Pack"
   
   @editable {ToolTip:=PurchaseableIconTT}  Icon : texture = whiteplacholder

#specifies anything with cost and currency ID
cost_field<public>:=class<concrete>():

    @editable {ToolTip:=anyCostTT} Cost : float = 0.0
    @editable {ToolTip:=anyCurrencyIDTT} CostID : int = 1


    AttemptToChargePlayer(Player:player)<transacts><decides>:void={}


#The most basic class for a purchaseable object
purchaseable<public>:=class<concrete>(descriptor):


    @editable var CurrencyCosts : cost_field = cost_field{}



    
