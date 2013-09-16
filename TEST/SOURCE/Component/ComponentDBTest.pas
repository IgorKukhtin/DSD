unit ComponentDBTest;

interface

uses
  TestFramework;

type

  TComponentDBTest = class (TTestCase)
  private
  protected
  published
    procedure ParamTest;
  end;

implementation

uses dsdDB, cxCalendar;

{ TComponentDBTest }

procedure TComponentDBTest.ParamTest;
var param: TdsdParam;
    edDate: TcxDateEdit;
    s: string;
begin
  param := TdsdParam.Create(nil);
  edDate := TcxDateEdit.Create(nil);
  param.Component := edDate;
  s := param.Value;
  edDate.Destroy;
//  edDate.Free;
  edDate := nil;
  s := param.Value;
  s := param.Component.Name;
end;


initialization
  TestFramework.RegisterTest('Компоненты', TComponentDBTest.Suite);

end.
