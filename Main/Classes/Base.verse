using{/Fortnite.com/Devices}
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { Purchaseables}
base<public>:=class<concrete>(creative_device):



    var Players<public>:[]player=array{}

    @editable_container {AllowReordering:=true} var PurchaseablesList : []purchaseable = array{}






    