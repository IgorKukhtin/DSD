unit UnitGetCash;

interface

uses MainCash2, CashInterface;

function GetCash : ICash;
procedure Add_Log_RRO(AMessage: String);

implementation

function GetCash : ICash;
begin
  Result := MainCashForm.GetCash;
end;

procedure Add_Log_RRO(AMessage: String);
begin
  MainCash2.Add_Log_RRO(AMessage);
end;

end.
