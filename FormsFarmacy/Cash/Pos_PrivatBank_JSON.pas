unit Pos_PrivatBank_JSON;

interface

uses Winapi.Windows, Winapi.ActiveX, System.Variants, System.SysUtils, System.Win.ComObj,
     PosInterface;

type
  TPos_PrivatBank_JSON = class(TInterfacedObject, IPos)
  private
    FPOS : Variant;
    FLastPosError : String;
    FLastPosRRN : String;
    FCancel : Boolean;
    FMsgDescriptionProc : TMsgDescriptionProc;
    FPOSTerminalCode : integer;

    procedure SetMsgDescriptionProc(Value: TMsgDescriptionProc);
    function GetMsgDescriptionProc: TMsgDescriptionProc;
    function GetLastPosError : string;
  protected
    function WaitPosResponsePrivat() : Integer;
    function Payment(ASumma : Currency) : Boolean;
    procedure Cancel;
  public
    constructor Create(APOSTerminalCode : Integer);
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
  end;

implementation

uses IniUtils;

constructor TPos_PrivatBank_JSON.Create(APOSTerminalCode : Integer);
begin
  inherited Create;
  FPOSTerminalCode := APOSTerminalCode;
end;

procedure TPos_PrivatBank_JSON.SetMsgDescriptionProc(Value: TMsgDescriptionProc);
begin
  FMsgDescriptionProc := Value;
end;

function TPos_PrivatBank_JSON.GetMsgDescriptionProc: TMsgDescriptionProc;
begin
  Result := FMsgDescriptionProc;
end;

function TPos_PrivatBank_JSON.GetLastPosError : string;
begin
  Result := FLastPosError;
end;

procedure TPos_PrivatBank_JSON.AfterConstruction;
var
  ClassID : TCLSID;
  aResult : hResult;
begin
  inherited AfterConstruction;

  FPOS := Unassigned;
  FCancel := False;
  aResult := CLSIDFromProgID(PWideChar(WideString('ECRCommX.BPOS1Lib')), ClassID);
  if aResult <> S_OK then
    raise Exception.Create('Не установлена ECRCommX библиотека~ для POS-терминала.')
  else FPOS := CreateOLEObject('ECRCommX.BPOS1Lib');
end;

procedure TPos_PrivatBank_JSON.BeforeDestruction;
begin
  FPOS := Unassigned;
  inherited BeforeDestruction;
end;

function TPos_PrivatBank_JSON.WaitPosResponsePrivat() : Integer;
begin
  while FPOS.LastResult = 2 do
  begin
    if FCancel then
    begin
      if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc('Прервано пользователем...');
      FPOS.Cancel;
      Result := -1;
      Exit;
    end;
    if Assigned(FMsgDescriptionProc) then FMsgDescriptionProc(FPOS.LastStatMsgDescription);
  end;

  Result := FPOS.LastResult;

  if FPOS.LastResult = 1 then
  begin
    FLastPosError := IntToStr(FPOS.LastErrorCode) + ' ( ' + FPOS.LastErrorDescription + ' )';
  end;
end;

function TPos_PrivatBank_JSON.Payment(ASumma : Currency) : Boolean;
var
  Summa : Integer;
begin
  Result := False;
  Summa := StrToInt(FloatToStr(ASumma * 100));
  FPOS.SetErrorLang(2);                                                    // Язык сообщений. 2-Укр
  try
    FPOS.CommOpen(iniPosPortNumber(FPOSTerminalCode), iniPosPortSpeed(FPOSTerminalCode));
    if WaitPosResponsePrivat() = 0 then
    begin
      FPOS.Purchase( Summa, 0, 0 );
      if WaitPosResponsePrivat() <> 0 then Exit;

      FLastPosRRN := FPOS.RRN;

      FPOS.Confirm;
      if WaitPosResponsePrivat() = 0 then
        Result := True;
    end
    else begin
      FPOS.Cancel;
      Result := False;
    end;
  finally
   FPOS.CommClose;
  end;
end;

procedure TPos_PrivatBank_JSON.Cancel;
begin
  FCancel := True;
end;

end.
