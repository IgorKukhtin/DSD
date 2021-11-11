unit UnitGetCash;

interface

uses Vcl.Dialogs, CashInterface, Cash_Emulation, Cash_FP3530T_NEW, IniUtils;

function GetCash : ICash;
procedure Add_Log_RRO(AMessage: String);

implementation

var Cash : ICash;

function GetCash : ICash;
begin
  if not Assigned(Cash) then
  begin
    if iniCashType = 'FP3530T_NEW' then
       Cash := TCashFP3530T_NEW.Create;
    if iniCashType = 'Emulation' then
       Cash := TCashEmulation.Create;
  end;
  result := Cash;
end;

procedure Add_Log_RRO(AMessage: String);
begin
  ShowMessage(AMessage);
end;

initialization

  Cash := Nil;

end.
