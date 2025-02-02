using{/Fortnite.com/Devices}
using { /Verse.org/Simulation }
using { /Verse.org/Random }
using { /Fortnite.com/Characters }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { Purchaseables}
base:=class<concrete>(creative_device):

    @editable_container {AllowReordering:=true}var PurchaseablesList : []purchaseable = array{}





    