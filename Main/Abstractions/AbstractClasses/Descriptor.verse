using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using {Tooltips}
using {Textures}
#Describes the most basic parts of an object such as: Name, Description & Icon. 
descriptor<public>:=class<concrete>():

    

    @editable {ToolTip:=anyNameTT} var Name : string = "My Item Name Here"
 
    @editable_text_box {ToolTip:=anyDescriptionTT, MultiLine:=true, MaxLength:=300} Description : string = "Hello World! \nI am using Tsars Tycoon Pack"

    @editable {ToolTip:=PurchaseableIconTT}  Icon : ?texture = option{whiteplacholder}

