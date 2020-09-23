unit AssetTest;

interface
  uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TAssetTest = class(TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

   TAsset = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateAsset(const Id, Code: integer; Name: string; Release: TDateTime;
                               InvNumber,FullName,SerialNumber,PassportNumber,Comment : string;
                               AssetGroupId,JuridicalId,MakerId: Integer): integer;
    constructor Create; override;
  end;


implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, DB, CarModelTest,
     InfoMoneyGroupTest, InfoMoneyDestinationTest, AssetGroupTest;

{TAssetTest}
constructor TAsset.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Asset';
  spSelect := 'gpSelect_Object_Asset';
  spGet := 'gpGet_Object_Asset';
end;

function TAsset.InsertDefault: integer;
var
  AssetGroupId: Integer;
  JuridicalId: Integer;
  MakerId: Integer;
begin
  AssetGroupId := TAssetGroup.Create.GetDefault;
  JuridicalId:=0;
  MakerId:=0;
  result := InsertUpdateAsset(0, -1, 'Основные средства', date, 'InvNumber', 'FullName', 'SerialNumber'
                            , 'PassportNumber', 'Comment', AssetGroupId,JuridicalId,MakerId);
end;

function TAsset.InsertUpdateAsset;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('Release', ftDateTime, ptInput, Release);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inFullName', ftString, ptInput, FullName);
  FParams.AddParam('inSerialNumber', ftString, ptInput, SerialNumber);
  FParams.AddParam('inPassportNumber', ftString, ptInput, PassportNumber);
  FParams.AddParam('inComment', ftString, ptInput, Comment);

  FParams.AddParam('inAssetGroupId', ftInteger, ptInput, AssetGroupId);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inMakerId', ftInteger, ptInput, MakerId);

  result := InsertUpdate(FParams);
end;

procedure TAssetTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Asset\';
  inherited;
end;

procedure TAssetTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TAsset;
begin
  ObjectTest := TAsset.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
  // Вставка объекта
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Основные средства'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  TestFramework.RegisterTest('Объекты', TAssetTest.Suite);

end.
