unit PosFactory;

interface

uses PosInterface, IniUtils;

type
  TPosFactory = class
    class function GetPos(POSTerminalCode: Integer): IPos;
  end;

implementation

uses Pos_ECRCommX_BPOS1Lib, Pos_PrivatBank_JSON, SysUtils;

{ TPosFactory }
class function TPosFactory.GetPos(POSTerminalCode: Integer): IPos;
begin
  if iniPosType(POSTerminalCode) = 'ECRCommX_BPOS1Lib' then
     result := TPos_ECRCommX_BPOS1Lib.Create(POSTerminalCode);
  if iniPosType(POSTerminalCode) = 'PrivatBank_JSON' then
     result := TPos_PrivatBank_JSON.Create(POSTerminalCode);
  if not Assigned(Result) then
     raise Exception.Create('Не правильно указан POS-терминала в Ini файле');
end;


end.
