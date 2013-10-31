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
    procedure ShowStoredProcParamTest;
  end;

implementation

uses dsdDB, SysUtils, DateUtils, cxCalendar, Storage, DB, Dialogs,
     Authentication, CommonData;

{ TComponentDBTest }

procedure TComponentDBTest.ParamTest;
var param: TdsdParam;
    edDate: TcxDateEdit;
    s: string;
    D: Variant;
begin
  D := EndOfTheMonth(Date)-0.5;
  Check(D = EndOfTheMonth(Date), '');
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

type
  TAccessdsdStoredProc = class(TdsdStoredProc)
     function GetXML: string;
  end;

procedure TComponentDBTest.ShowStoredProcParamTest;
var SaveUserFormSettingsStoredProc: TdsdStoredProc;
begin
  gc_User :=  TUser.Create('1');
  SaveUserFormSettingsStoredProc := TdsdStoredProc.Create(nil);
  SaveUserFormSettingsStoredProc.StoredProcName := 'gpInsertUpdate_Object_UserFormSettings';
  SaveUserFormSettingsStoredProc.OutputType := otResult;
  SaveUserFormSettingsStoredProc.Params.AddParam('inFormName', ftString, ptInput, '');
  SaveUserFormSettingsStoredProc.Params.AddParam('inUserFormSettingsData', ftBlob, ptInput, '');
 // ShowMessage(ConvertXMLParamToStrings(TAccessdsdStoredProc(SaveUserFormSettingsStoredProc).GetXML));
end;

{ TAccessdsdStoredProc }

function TAccessdsdStoredProc.GetXML: string;
begin
  result := inherited GetXML;
end;

initialization
  TestFramework.RegisterTest('Компоненты', TComponentDBTest.Suite);

end.
