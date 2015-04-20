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
    procedure GetOneTaxMedocDocument;
    procedure GetOneTaxCorrectiveMedocDocument;
    procedure GetItemOneTaxMedocDocument;
    procedure GetItemOneTaxCorrectiveMedocDocument;
  end;

implementation

uses MedocCOM, SysUtils, MEDOC_TLB, dialogs;

{ TMedocCOMTest }

procedure TMedocCOMTest.CreateMedocApplication;
var MedocCom: TMedocCOM;
begin
  MedocCom := TMedocCOM.Create;
end;

procedure TMedocCOMTest.GetOneTaxMedocDocument;
var
  MedocCom: TMedocCOM;
  Code: integer;
  res: OleVariant;
  Params: TParams;
  i: integer;
  s, Form: string;
begin
  MedocCom := TMedocCOM.Create;
  res := MedocCom.GetDocumentList('F1201007', StrToDate('01.03.2015'));
  if not res.Eof then begin
     Params := MedocCom.GetDocumentByCode(res.Fields['CODE'].Value, res.Fields['FORM'].Value);
  end;
  s := Form;
  if Assigned(Params) then
     for I := 0 to Params.Count - 1 do
         s := s + Params[i].Name + ' = ' + Params[i].AsString + ';';
  Check(false, s);
end;

procedure TMedocCOMTest.GetItemOneTaxCorrectiveMedocDocument;
begin

end;

procedure TMedocCOMTest.GetItemOneTaxMedocDocument;
var
  MedocCom: TMedocCOM;
  res: OleVariant;
  i: integer;
  s: string;
  dddd: string;
  DataSet: IZDataset;
begin
  MedocCom := TMedocCOM.Create;
  res := MedocCom.GetDocumentList('F1201007', StrToDate('01.03.2015'));
  if not res.Eof then begin
     DataSet := MedocCom.GetDocumentItemByCode(res.Fields['CODE'].Value);
  end;
  while not DataSet.EOF do begin
     for I := 0 to DataSet.Fields.Count - 1 do begin
         dddd := DataSet.Fields[i].Value;
         s := s + DataSet.Fields[i].Name + ' = ' + dddd + ';';
     end;
     s := s + #10#13;
     DataSet.Next;
  end;
  Check(false, s);
end;

procedure TMedocCOMTest.GetOneTaxCorrectiveMedocDocument;
var
  MedocCom: TMedocCOM;
  res: OleVariant;
  Params: TParams;
  i: integer;
  s: string;
begin
  MedocCom := TMedocCOM.Create;
  res := MedocCom.GetDocumentList('F1201207', StrToDate('01.03.2015'));
  if not res.Eof then begin
     Params := MedocCom.GetDocumentByCode(res.Fields.Item['CODE'].Value, res.Fields.Item['FORM'].Value);
  end;
  if Assigned(Params) then
     for I := 0 to Params.Count - 1 do
         s := s + Params[i].Name + ' = ' + Params[i].AsString + ';';
  Check(false, s);
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
