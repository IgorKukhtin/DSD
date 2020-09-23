unit DefaultsTest;

interface

uses dbTest, dsdDB;

type

  TDefaults = class (TdbTest)
  private
    FStoredProc: TdsdStoredProc;
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure ProcedureLoad; override;
    procedure Test; virtual;
  end;

implementation

uses UtilConst, TestFramework, Defaults, Forms, DB, Authentication, Storage,
     CommonData, UtilConvert, RoleTest, dbObjectTest, SysUtils, ObjectTest;

{ TDefaults }

procedure TDefaults.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Default\';
  inherited;
end;

procedure TDefaults.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', gc_AdminPassword, gc_User);
end;

procedure TDefaults.TearDown;
begin
  inherited;
  if Assigned(InsertedIdObjectList) then
     with TObjectTest.Create do
       while InsertedIdObjectList.Count > 0 do begin
          DeleteRecord(StrToInt(InsertedIdObjectList[0]));
          InsertedIdObjectList.Delete(0);
       end;
end;

procedure TDefaults.Test;
var DefaultKey: TDefaultKey;
    RoleId: Integer;
    KeyId: integer;
begin
//  DefaultKey := TDefaultKey.Create(TForm.Create(nil));
//  // Проверяем результат создания ключа и JSON
//  DefaultKey.Params.AddParam('FormClass', ftString, ptInput, 'TForm');
//  DefaultKey.Params.AddParam('MenuItem', ftString, ptInput, 'miIncome');
//
//  FStoredProc := TdsdStoredProc.Create(nil);
//  FStoredProc.OutputType := otResult;
//  // Мы добавляем новый ключ в базу
//  FStoredProc.StoredProcName := 'gpInsertUpdate_DefaultKey';
//  FStoredProc.Params.Clear;
//  FStoredProc.Params.AddParam('ioId', ftInteger, ptInputOutput, 0);
//  FStoredProc.Params.AddParam('inKey', ftString, ptInput, DefaultKey.Key);
//  FStoredProc.Params.AddParam('inKeyData', ftBlob, ptInput, gfStrToXmlStr(DefaultKey.JSONKey));
//  FStoredProc.Execute;
//  KeyId := FStoredProc.ParamByName('ioId').Value;
//
//  RoleId := TRole.Create.GetDefault;
//  // Потом добавляем значение данного ключа для любой роли
//  FStoredProc.StoredProcName := 'gpInsertUpdate_DefaultValue';
//  FStoredProc.Params.Clear;
//  FStoredProc.Params.AddParam('ioId', ftInteger, ptInput, 0);
//  FStoredProc.Params.AddParam('inDefaultKeyId', ftInteger, ptInput, KeyId);
//  FStoredProc.Params.AddParam('inUserKey', ftInteger, ptInput, RoleId);
//  FStoredProc.Params.AddParam('inDefaultValue', ftBlob, ptInput, gfStrToXmlStr(GetDefaultJSON(dtGuides, '1')));
//  FStoredProc.Execute;
//
//  // И стараемся получить дефолт для Админ
//  FStoredProc.StoredProcName := 'gpGet_DefaultValue';
//  FStoredProc.Params.Clear;
//  FStoredProc.Params.AddParam('inDefaultKey', ftString, ptInput, '');
//  FStoredProc.Params.AddParam('inUserKey', ftInteger, ptInput, 1);
//  FStoredProc.Execute;
//  // а потом удаляем ключ
//  FStoredProc.StoredProcName := 'gpDelete_DefaultKey';
//  FStoredProc.Params.Clear;
//  FStoredProc.Params.AddParam('inKey', ftString, ptInput, DefaultKey.Key);
//  FStoredProc.Execute;
end;

initialization

  TestFramework.RegisterTest('Defaults', TDefaults.Suite);

end.
