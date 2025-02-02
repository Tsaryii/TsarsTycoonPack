using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using {Tooltips}
using {Textures}
using{Categories}
purchaseable<public>:=class<concrete>():

    @editable {ToolTip:=anyNameTT} var Name : string = "My Item Name Here"

    @editable_text_box {ToolTip:=anyDescriptionTT, MultiLine:=true, MaxLength:=300} var Description : string = "Hello World! \nI am using Tsars Tycoon Pack"
   
    @editable {ToolTip:=PurchaseableIconTT} var Icon : texture = whiteplacholder

    
