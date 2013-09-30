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
  end;

implementation

uses dsdDB, DBXJSON, Defaults, Forms;

{ TComponentAddOnTest }

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
