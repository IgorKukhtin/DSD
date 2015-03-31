unit MeDocCOMTest;

interface

uses DB, TestFramework;

type
  // Класс тестирует поведение класса TELOLAPSalers.
  TMedocCOMTest = class(TTestCase)
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные после тестирования}
    procedure TearDown; override;
  published
    // запускаем КОМ объект
    procedure CreateMedocApplication;
    procedure GetMedocDocument;
    procedure GetOneMedocDocument;
  end;

implementation

uses MedocCOM, SysUtils, MEDOC_TLB, dialogs;

{ TMedocCOMTest }

procedure TMedocCOMTest.CreateMedocApplication;
var MedocCom: TMedocCOM;
begin
  MedocCom := TMedocCOM.Create;
end;

procedure TMedocCOMTest.GetMedocDocument;
var
  MedocCom: TMedocCOM;
  res: OleVariant;
  i: integer;
  rr, rrr: string;
  val: OleVariant;
begin
  MedocCom := TMedocCOM.Create;
  res := MedocCom.GetDocumentList(Date - 360, Date);
  while not res.Eof do begin
    for I := 0 to res.Fields.Count - 1 do begin
        val := res.Fields.Item[i].Value;
        rrr := val;
        rr := rr + ';  ' + res.Fields.Item[i].Name + ' = ' + rrr
    end;
    rr := rr + ' #$#$#$ ';
    res.Next;
  end;
end;

procedure TMedocCOMTest.GetOneMedocDocument;
var
  MedocCom: TMedocCOM;
  Code: integer;
  res: OleVariant;
  Params: TParams;
  i: integer;
  s: string;
begin
  MedocCom := TMedocCOM.Create;
  res := MedocCom.GetDocumentList(Date - 360, Date);
  if not res.Eof then begin
     Code := res.Fields.Item['CODE'].Value;
     Params := MedocCom.GetDocumentByCode(Code);
  end;
  for I := 0 to Params.Count - 1 do
      s := s + Params[i].Name + ' = ' + Params[i].AsString + ';';
  ShowMessage(s);
end;

procedure TMedocCOMTest.SetUp;
begin
  inherited;

end;

procedure TMedocCOMTest.TearDown;
begin
  inherited;

end;

initialization

  TestFramework.RegisterTest('Компоненты', TMedocCOMTest.Suite);


end.
