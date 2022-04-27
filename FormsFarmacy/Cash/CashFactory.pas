unit CashFactory;

interface
uses CashInterface;
type
  TCashFactory = class
    class function GetCash(CashType: string): ICash;
  end;

implementation

uses Cash_FP3530T, Cash_FP3530T_NEW, Cash_FP320, Cash_IKC_E810T, Cash_IKC_C651T,
     Cash_MINI_FP54, Cash_Emulation, Cash_VchasnoKasa, SysUtils;
{ TCashFactory }
class function TCashFactory.GetCash(CashType: string): ICash;
begin
  if CashType = 'FP3530T' then
     result := TCashFP3530T.Create;
  if CashType = 'FP3530T_NEW' then
     result := TCashFP3530T_NEW.Create;
  if CashType = 'FP320' then
     result := TCashFP320.Create;
  if CashType = 'IKC-E810T' then
     result := TCashIKC_E810T.Create;
  if CashType = 'IKC-C651T' then
     result := TCashIKC_C651T.Create;
  if CashType = 'MINI_FP54' then
     result := TCashMINI_FP54.Create;
  if CashType = 'Emulation' then
     result := TCashEmulation.Create;
  if CashType = 'VchasnoKasa' then
     result := TCashVchasnoKasa.Create;
  if not Assigned(Result) then
     raise Exception.Create('Не правильно указан тип кассы в Ini файле');
(*CashSamsung:=TCashSamsung.Create(GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'ComPort','COM2:'));
  with CashSamsung do begin
       test:=GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'Cashtest','1')='0';
       DelayForSoldPC:=StrToInt(GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'DelayForSoldPC','20'));
       DelayBetweenLine:=StrToInt(GetDefaultValue_fromFile(ifDefaults,Self.ClassName,'DelayBetweenLine','500'));
       SoldInEightReg:=SoldEightReg;
  end;*)
  
end;

end.
