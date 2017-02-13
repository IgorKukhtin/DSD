unit ComponentAddOnTest;

interface

uses
  TestFramework;

type

  TComponentAddOnTest = class (TTestCase)
  private
  protected
  published
    procedure DefaultsKeyTest;
    procedure CrossViewAddOnTest;
  end;

implementation

uses DB, dsdDB, DBXJSON, Defaults, Forms, CrossAddOnViewTestForm, SysUtils;

{ TComponentAddOnTest }

procedure TComponentAddOnTest.CrossViewAddOnTest;
begin
  with TCrossAddOnViewTest.Create(nil) do
    try
      Show;
      Application.ProcessMessages;
      Sleep(1000);
      HorDS.CreateDataSet;
      HorDS.Open;
      HorDS.AppendRecord(['����� ����  1', 1]);
      HorDS.AppendRecord(['����� ���� 23', 2]);
      DataDS.CreateDataSet;
      DataDS.Open;
      DataDS.AppendRecord(['�����', 1, 4]);
      DataDS.AppendRecord(['�����', 2, 6]);
      Application.ProcessMessages;
    //  Sleep(1000);
    finally
  //    Free;
    end;
end;

procedure TComponentAddOnTest.DefaultsKeyTest;
var DefaultKey: TDefaultKey;
    Param: TdsdParam;
    KeyParam: TdsdParam;
    FJSONObject: TJSONObject;
begin
  DefaultKey := TDefaultKey.Create(TForm.Create(nil));
  // ��������� ��������� �������� ����� � JSON
  DefaultKey.Params.AddParam('FormClass', ftString, ptInput, 'TForm');
  DefaultKey.Params.AddParam('MenuItem', ftString, ptInput, 'miIncome');
 
  Check(DefaultKey.Key = 'TForm;miIncome', '�������� KeyParam.Value = "' + DefaultKey.Key + '" ������ "TForm;miIncome"');

  FJSONObject := TJSONObject.ParseJSONValue(DefaultKey.JSONKey) as TJSONObject;
  if not Assigned(FJSONObject) then
     Check(false, 'FJSONObject = nil');
  if not Assigned(FJSONObject.Get('FormClass')) then
     Check(false, 'FJSONObject.Get(''FormClass'') = nil');

  Check(FJSONObject.Get('FormClass').JSONValue.Value = 'TForm', FJSONObject.Get('FormClass').JSONString.Value + '   ������ TForm');

end;

initialization
  TestFramework.RegisterTest('AddOn', TComponentAddOnTest.Suite);

end.
