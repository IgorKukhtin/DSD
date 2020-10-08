unit LoadBoatFormTest;

interface

uses
  TestFramework, Forms;

type

  TLoadFormTest = class (TTestCase)
  private
    function GetForm(FormClass: string): TForm;
  protected
    // �������������� ������ ��� ������������
    procedure SetUp; override;
  published
    procedure MainFormTest;
    procedure LoadServiceFormTest;
    procedure LoadTranslateWordFormTest;
    procedure LoadLanguageFormTest;
    procedure FormTest;
  end;

implementation

uses CommonData, Storage, FormStorage, Classes, Authentication, SysUtils,
     cxPropertiesStore, cxStorage, DBClient, dsdDB, ActionTest, MainForm,
     UtilConst;

{ TLoadFormTest }

procedure TLoadFormTest.FormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTestForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTestForm');
end;

function TLoadFormTest.GetForm(FormClass: string): TForm;
begin
  if GetClass(FormClass) = nil then
     raise Exception.Create('�� ��������������� �����: ' + FormClass);
  Application.CreateForm(TComponentClass(GetClass(FormClass)), Result);
end;

procedure TLoadFormTest.MainFormTest;
var ActionDataSet: TClientDataSet;
    StoredProc: TdsdStoredProc;
    i: integer;
    Action: ActionTest.TAction;
begin
  // ����� �� ��������� ���������� Action
  // �������� ��� Action �� ����
  ActionDataSet := TClientDataSet.Create(nil);
  StoredProc := TdsdStoredProc.Create(nil);
  MainFormInstance := TMainForm.Create(nil);
  Action := ActionTest.TAction.Create;
  try
    StoredProc.DataSet := ActionDataSet;
    StoredProc.StoredProcName := 'gpSelect_Object_Action';
    StoredProc.Execute;
    // ������� ���, ��� ���
    with MainFormInstance.ActionList do
      for I := 0 to ActionCount - 1 do
          if not ActionDataSet.Locate('Name', Actions[i].Name, []) then
             Action.InsertUpdateAction(0, 0, Actions[i].Name);
  finally
    Action.Free;
    StoredProc.Free;
    ActionDataSet.Free;
    MainFormInstance.Free;
  end;
end;

procedure TLoadFormTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, '�����', gc_AdminPassword, gc_User);
end;

procedure TLoadFormTest.LoadServiceFormTest;
begin
//
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TObjectDescForm'));
  TdsdFormStorageFactory.GetStorage.Load('TObjectDescForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TObjectForm'));
  TdsdFormStorageFactory.GetStorage.Load('TObjectForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRoleForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRoleForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TRoleEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TRoleEditForm');
//
//
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserEditForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TActionForm'));
  TdsdFormStorageFactory.GetStorage.Load('TActionForm');
//
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TUserProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TUserProtocolForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TProtocolForm'));
  TdsdFormStorageFactory.GetStorage.Load('TProtocolForm');

  TdsdFormStorageFactory.GetStorage.Save(GetForm('TMovementDescDataForm'));
  TdsdFormStorageFactory.GetStorage.Load('TMovementDescDataForm');

end;

procedure TLoadFormTest.LoadTranslateWordFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTranslateWordForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTranslateWordForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TTranslateWordEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TTranslateWordEditForm');

end;

procedure TLoadFormTest.LoadLanguageFormTest;
begin
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLanguageForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLanguageForm');
  TdsdFormStorageFactory.GetStorage.Save(GetForm('TLanguageEditForm'));
  TdsdFormStorageFactory.GetStorage.Load('TLanguageEditForm');
end;


initialization
  TestFramework.RegisterTest('�������� ����', TLoadFormTest.Suite);


end.
