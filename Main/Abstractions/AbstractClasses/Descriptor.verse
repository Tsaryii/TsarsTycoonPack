using { /Verse.org/Simulation }
using { /Verse.org/Assets }
using {Tooltips}
using {Textures}
#Describes the most basic parts of an object such as: Name, Description & Icon. 
descriptor<public>:=class<concrete>:

    

    @editable {ToolTip:=anyNameTT} var Name <public> : string = "My Item Name Here"
 
    @editable_text_box {ToolTip:=anyDescriptionTT, MultiLine:=true, MaxLength:=300} var Description <public> : string = "Hello World! \nI am using Tsars Tycoon Pack"

    @editable {ToolTip:=PurchaseableIconTT}  var Icon <public> : ?texture = option{whiteplacholder}

