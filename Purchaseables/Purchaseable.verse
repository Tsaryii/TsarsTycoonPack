using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using {Tooltips}
using {Textures}

    
descriptor<public>:=class<concrete>():

    descriptorCT<localizes><public>:message={"Describes the most basic parts of an object such as: Name, Description & Icon."}

   @editable {ToolTip:=anyNameTT, Categories:=array{descriptorCT, anyNumberORString}} Name : string = "My Item Name Here"

   @editable_text_box {ToolTip:=anyDescriptionTT, MultiLine:=true, MaxLength:=300, Categories:=array{descriptorCT, anyFullLength}} Description : string = "Hello World! \nI am using Tsars Tycoon Pack"
   
   @editable {ToolTip:=PurchaseableIconTT, Categories:=array{descriptorCT, anyFullLength}}  Icon : texture = whiteplacholder

   GetName():string=Name
   GetDescription():string=Description
   GetIcon():texture=Icon

purchaseable<public>:=class<concrete>(descriptor):

    purchaseableCT<localizes><public>:message={"Describes the most basic parts of an object such as: Name, Description & Icon."}

    @editable {ToolTip:=anyCostTT, Categories:=array{purchaseableCT, anyNumberORString}} var Cost : float = 0.0
    @editable {ToolTip:=anyCostTT, Categories:=array{purchaseableCT, anyNumberORString}} var CostID : int = 1
    
