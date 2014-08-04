unit dbObjectMeatTest;

interface
uses dbObjectTest, Classes, TestFramework, Authentication, Db, XMLIntf, dsdDB, dbTest, ObjectTest;

type

  TdbObjectTest = class (TdbTest)
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;

    function GetRecordCount(ObjectTest: TObjectTest): integer;

  published
//    procedure DocumentTaxKind_Test;
   end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, ZLibEx, zLibUtil,UnitsTest, JuridicalTest, BusinessTest;


{ TDataBaseObjectTest }
{------------------------------------------------------------------------------}
function TdbObjectTest.GetRecordCount(ObjectTest: TObjectTest): integer;
begin
  Result := ObjectTest.GetDataSet.RecordCount;
end;
{------------------------------------------------------------------------------}



{------------------------------------------------------------------------------}

{------------------------------------------------------------------------------}
procedure TdbObjectTest.TearDown;
begin
  inherited;
  if Assigned(InsertedIdObjectList) then
     with TObjectTest.Create do
       while InsertedIdObjectList.Count > 0 do begin
          DeleteRecord(StrToInt(InsertedIdObjectList[0]));
          InsertedIdObjectList.Delete(0);
       end;
end;
{------------------------------------------------------------------------------}
procedure TdbObjectTest.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;
{------------------------------------------------------------------------------}



{ TDataBaseUsersObjectTest }





{=================}
{TTaxKindTest}
{
constructor TTaxKindTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_DocumentTaxKind';
  spSelect := 'gpSelect_Object_DocumentTaxKind';
  spGet := 'gpGet_Object_DocumentTaxKind';
end;

function TTaxKindTest.InsertDefault: integer;
begin
  result := InsertUpdateDocumentTaxKind(0, -3, 'Тип формирования налогового документа');
  inherited;
end;

function TTaxKindTest.InsertUpdateDocumentTaxKind;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.DocumentTaxKind_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TDocumentTaxKindTest;
begin
  ObjectTest := TDocumentTaxKindTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Тип формирования налогового документа'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;
}
{==================================}



 


initialization

  TestFramework.RegisterTest('Объекты', TdbObjectTest.Suite);

end.
