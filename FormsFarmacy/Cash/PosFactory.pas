unit PosFactory;

interface

uses PosInterface;
type
  TPosFactory = class
    class function GetPos(PosType: string): IPos;
  end;

implementation

uses Pos_ECRCommX_BPOS1Lib, SysUtils;

{ TPosFactory }
class function TPosFactory.GetPos(PosType: string): IPos;
begin
  if PosType = 'ECRCommX_BPOS1Lib' then
     result := TPos_ECRCommX_BPOS1Lib.Create;
  if not Assigned(Result) then
     raise Exception.Create('Не правильно указан POS-терминала в Ini файле');
end;


end.
