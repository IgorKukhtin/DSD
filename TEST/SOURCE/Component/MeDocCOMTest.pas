unit MeDocCOMTest;

interface

uses DB, TestFramework;

type
  // ����� ��������� ��������� ������ TELOLAPSalers.
  TMedocCOMTest = class(TTestCase)
  protected
    // �������������� ������ ��� ������������
    procedure SetUp; override;
    // ���������� ������ ����� ������������}
    procedure TearDown; override;
  published
    // ��������� ��� ������
    procedure CreateMedocApplication;
    procedure GetOneTaxMedocDocument;
    procedure GetOneTaxCorrectiveMedocDocument;
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
  s: string;
begin
  MedocCom := TMedocCOM.Create;
  res := MedocCom.GetDocumentList('F1201007', StrToDate('01.03.2015'));
  if not res.Eof then begin
     Code := res.Fields.Item['CODE'].Value;
     Params := MedocCom.GetDocumentByCode(Code);
  end;
  if Assigned(Params) then
     for I := 0 to Params.Count - 1 do
         s := s + Params[i].Name + ' = ' + Params[i].AsString + ';';
  Check(false, s);
end;

procedure TMedocCOMTest.GetOneTaxCorrectiveMedocDocument;
var
  MedocCom: TMedocCOM;
  Code: integer;
  res: OleVariant;
  Params: TParams;
  i: integer;
  s: string;
begin
  MedocCom := TMedocCOM.Create;
  res := MedocCom.GetDocumentList('F1201207', StrToDate('01.03.2015'));
  if not res.Eof then begin
     Code := res.Fields.Item['CODE'].Value;
     Params := MedocCom.GetDocumentByCode(Code);
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

  TestFramework.RegisterTest('����������', TMedocCOMTest.Suite);


end.
