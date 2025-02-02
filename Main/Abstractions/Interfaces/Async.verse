
using{Classes}
iBeginAsync<public>:=interface():
    OnBegin<public>()<suspends>:void

isubBaseInitAsync<public>:=interface():
    Init<public>(inBase:base)<suspends>:void