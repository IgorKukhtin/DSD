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

uses dsdDB, DBXJSON, Defaults, Forms, CrossAddOnViewTestForm, SysUtils;

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
      HorDS.AppendRecord(['Супер поле  1', 1]);
      HorDS.AppendRecord(['Супер поле 23', 2]);
      DataDS.CreateDataSet;
      DataDS.Open;
      Application.ProcessMessages;
      Sleep(1000);
    finally
      Free;
    end;
end;

procedure TComponentAddOnTest.DefaultsKeyTest;
var DefaultKey: TDefaultKey;
    Param: TdsdParam;
    KeyParam: TdsdParam;
    FJSONObject: TJSONObject;
begin
  DefaultKey := TDefaultKey.Create(TForm.Create(nil));
  // Проверяем результат создания ключа и JSON
  DefaultKey.Param.Value := 'miIncome';

  KeyParam := TdsdParam.Create(nil);
  KeyParam.Component := DefaultKey;

  Check(KeyParam.Value = 'TForm;miIncome', 'Значение KeyParam.Value = "' + KeyParam.Value + '" вместо "TForm;miIncome"');

  FJSONObject := TJSONObject.ParseJSONValue(DefaultKey.JSONKey) as TJSONObject;
  if not Assigned(FJSONObject) then
     Check(false, 'FJSONObject = nil');
  if not Assigned(FJSONObject.Get('FormClass')) then
     Check(false, 'FJSONObject.Get(''FormClass'') = nil');

  Check(FJSONObject.Get('FormClass').JSONValue.Value = 'TForm', FJSONObject.Get('FormClass').JSONString.Value + '   Вместо TForm');

end;

initialization
  TestFramework.RegisterTest('AddOn', TComponentAddOnTest.Suite);

end.
