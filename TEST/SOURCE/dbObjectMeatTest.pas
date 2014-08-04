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
    procedure PriceList_Test;
    procedure ProfitLossGroup_Test;
    procedure ProfitLossDirection_Test;
    procedure ProfitLoss_Test;
    procedure InfoMoneyGroup_Test;
    procedure InfoMoneyDestination_Test;
    procedure InfoMoney_Test;
    procedure Member_Test;
    procedure Position_Test;
    procedure AssetGroup_Test;
    procedure Asset_Test;
    procedure ReceiptCost_Test;
    procedure ReceiptChild_Test;
    procedure Receipt_Test;
   end;


  TCurrencyTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    constructor Create; override;
  end;

  TPriceListTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdatePriceList(const Id, Code: Integer; Name: string;PriceWithVAT:Boolean;VATPercent:Double): integer;
    constructor Create; override;
  end;


  TProfitLossGroupTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateProfitLossGroup(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

  TProfitLossDirectionTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateProfitLossDirection(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

  TProfitLossTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateProfitLoss(const Id, Code : integer; Name: string; ProfitLossGroupId: Integer;
                                     ProfitLossDirectionId, InfoMoneyDestinationId, InfoMoneyId: integer): integer;
    constructor Create; override;
  end;

  TInfoMoneyGroupTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateInfoMoneyGroup(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

  TInfoMoneyDestinationTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateInfoMoneyDestination(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

  TInfoMoneyTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateInfoMoney(const Id, Code : integer; Name: string; InfoMoneyGroupId: Integer;
                                     InfoMoneyDestinationId: integer): integer;
    constructor Create; override;
  end;

  TMemberTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateMember(const Id, Code : integer; Name, INN: string): integer;
    constructor Create; override;
  end;

  TPositionTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdatePosition(const Id, Code : integer; Name: string): integer;
    constructor Create; override;
  end;

  TAssetGroupTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateAssetGroup(const Id: integer; Code: Integer;
        Name: string; ParentId: integer): integer;
    constructor Create; override;
  end;

  TAssetTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateAsset(const Id, Code: integer; Name: string; Release: TDateTime;
                               InvNumber,FullName,SerialNumber,PassportNumber,Comment : string;
                               AssetGroupId,JuridicalId,MakerId: Integer): integer;
    constructor Create; override;
  end;

  TReceiptCostTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateReceiptCost(const Id, Code : integer; Name: string): integer;
    constructor Create; override;
  end;

  TReceiptChildTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
   function InsertUpdateReceiptChild(const Id: integer; Value: Double; Weight, TaxExit: boolean;
                                     StartDate, EndDate: TDateTime; Comment: string;
                                     ReceiptId, GoodsId, GoodsKindId: integer): integer;
    constructor Create; override;
  end;

  TReceiptTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
   function InsertUpdateReceipt(const Id: integer; Name, Code, Comment: string;
                                Value, ValueCost, TaxExit, PartionValue, PartionCount, WeightPackage: Double;
                                StartDate, EndDate: TDateTime;
                                Main: boolean;
                                GoodsId, GoodsKindId, GoodsKindCompleteId, ReceiptCostId, ReceiptKindId: integer): integer;
    constructor Create; override;
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

{ TCurrencyTest }

constructor TCurrencyTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Currency';
  spSelect := 'gpSelect_Object_Currency';
  spGet := 'gpGet_Object_Currency';
end;

function TCurrencyTest.InsertDefault: integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, 0);
  FParams.AddParam('inCurrencyCode', ftInteger, ptInput, 920);
  FParams.AddParam('inCurrencyName', ftString, ptInput, 'GRN');
  FParams.AddParam('inFullName', ftString, ptInput, 'Гривна');
  result := InsertUpdate(FParams);
  inherited;
end;

{ TDataBaseUsersObjectTest }



procedure TdbObjectTest.PriceList_Test;
begin

end;




{ TPriceListTest }

constructor TPriceListTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_PriceList';
  spSelect := 'gpSelect_Object_PriceList';
  spGet := 'gpGet_Object_PriceList';
end;

function TPriceListTest.InsertDefault: integer;
begin
  result := InsertUpdatePriceList(0, -1, 'Прайс-лист',false,20);
  inherited;
end;

function TPriceListTest.InsertUpdatePriceList(const Id, Code: Integer;Name: string;PriceWithVAT:Boolean;VATPercent:Double): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inPriceWithVAT', ftBoolean, ptInput, PriceWithVAT);
  FParams.AddParam('inVATPercent', ftFloat, ptInput, VATPercent);
  result := InsertUpdate(FParams);
end;


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



{ TProfitLossGroupTest }
constructor TProfitLossGroupTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ProfitLossGroup';
  spSelect := 'gpSelect_Object_ProfitLossGroup';
  spGet := 'gpGet_Object_ProfitLossGroup';
end;

function TProfitLossGroupTest.InsertDefault: integer;
begin
  result := InsertUpdateProfitLossGroup(0, -4, 'Группы статей отчета о прибылях и убытках 1');
  inherited;
end;

function TProfitLossGroupTest.InsertUpdateProfitLossGroup(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.ProfitLossGroup_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TProfitLossGroupTest;
begin
  ObjectTest := TProfitLossGroupTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Группы статей отчета о прибылях и убытках 1'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;


{ TProfitLossDirectionTest }
constructor TProfitLossDirectionTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ProfitLossDirection';
  spSelect := 'gpSelect_Object_ProfitLossDirection';
  spGet := 'gpGet_Object_ProfitLossDirection';
end;

function TProfitLossDirectionTest.InsertDefault: integer;
begin
  result := InsertUpdateProfitLossDirection(0, -1, 'Аналитики статей отчета о прибылях и убытках - направление 1');
  inherited;
end;

function TProfitLossDirectionTest.InsertUpdateProfitLossDirection(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.ProfitLossDirection_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TProfitLossDirectionTest;
begin
  ObjectTest := TProfitLossDirectionTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка группы урп.счетов
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Аналитики статей отчета о прибылях и убытках - направление 1'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;


{TProfitLossTest}
 constructor TProfitLossTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ProfitLoss';
  spSelect := 'gpSelect_Object_ProfitLoss';
  spGet := 'gpGet_Object_ProfitLoss';
end;

function TProfitLossTest.InsertDefault: integer;
var
  ProfitLossGroupId: Integer;
  ProfitLossDirectionId: Integer;
 // InfoMoneyDestinationId: Integer;
 // InfoMoneyId: Integer;
begin
  ProfitLossGroupId := TProfitLossGroupTest.Create.GetDefault;
  ProfitLossDirectionId:= TProfitLossDirectionTest.Create.GetDefault;;
  result := InsertUpdateProfitLoss(0, -3, 'Управленческие счет 1', ProfitLossGroupId, ProfitLossDirectionId, 1, 1);
  inherited;
end;

function TProfitLossTest.InsertUpdateProfitLoss;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inProfitLossGroupId', ftInteger, ptInput, ProfitLossGroupId);
  FParams.AddParam('inProfitLossDirectionId', ftInteger, ptInput, ProfitLossDirectionId);
  FParams.AddParam('inInfoMoneyDestinationId', ftInteger, ptInput, InfoMoneyDestinationId);
  FParams.AddParam('inInfoMoneyId', ftInteger, ptInput, InfoMoneyId);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.ProfitLoss_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TProfitLossTest;
begin
  ObjectTest := TProfitLossTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Управленческие счет 1'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TInfoMoneyGroupTest }
constructor TInfoMoneyGroupTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_InfoMoneyGroup';
  spSelect := 'gpSelect_Object_InfoMoneyGroup';
  spGet := 'gpGet_Object_InfoMoneyGroup';
end;

function TInfoMoneyGroupTest.InsertDefault: integer;
begin
  result := InsertUpdateInfoMoneyGroup(0, -4, 'Группы управленческих аналитик 1');
  inherited;
end;

function TInfoMoneyGroupTest.InsertUpdateInfoMoneyGroup(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.InfoMoneyGroup_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TInfoMoneyGroupTest;
begin
  ObjectTest := TInfoMoneyGroupTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Группы управленческих аналитик 1'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;


{ TInfoMoneyDestinationTest }
constructor TInfoMoneyDestinationTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_InfoMoneyDestination';
  spSelect := 'gpSelect_Object_InfoMoneyDestination';
  spGet := 'gpGet_Object_InfoMoneyDestination';
end;

function TInfoMoneyDestinationTest.InsertDefault: integer;
begin
  result := InsertUpdateInfoMoneyDestination(0, -1, 'Управленческие аналитики - назначение');
  inherited;
end;

function TInfoMoneyDestinationTest.InsertUpdateInfoMoneyDestination(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.InfoMoneyDestination_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TInfoMoneyDestinationTest;
begin
  ObjectTest := TInfoMoneyDestinationTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка группы урп.счетов
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Управленческие аналитики - назначение'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TInfoMoneyTest}
 constructor TInfoMoneyTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_InfoMoney';
  spSelect := 'gpSelect_Object_InfoMoney';
  spGet := 'gpGet_Object_InfoMoney';
end;

function TInfoMoneyTest.InsertDefault: integer;
var
  InfoMoneyGroupId: Integer;
  InfoMoneyDestinationId: Integer;
begin
  InfoMoneyGroupId := TInfoMoneyGroupTest.Create.GetDefault;
  InfoMoneyDestinationId:= TInfoMoneyDestinationTest.Create.GetDefault;;
  result := InsertUpdateInfoMoney(0, -3, 'Управленческие аналитики 1', InfoMoneyGroupId, InfoMoneyDestinationId);
  inherited;
end;

function TInfoMoneyTest.InsertUpdateInfoMoney;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inInfoMoneyGroupId', ftInteger, ptInput, InfoMoneyGroupId);
  FParams.AddParam('inInfoMoneyDestinationId', ftInteger, ptInput, InfoMoneyDestinationId);

  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.InfoMoney_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TInfoMoneyTest;
begin
  ObjectTest := TInfoMoneyTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Управленческие аналитики 1'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;


{ TMemberTest }
constructor TMemberTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Member';
  spSelect := 'gpSelect_Object_Member';
  spGet := 'gpGet_Object_Member';
end;

function TMemberTest.InsertDefault: integer;
begin
  result := InsertUpdateMember(0, -1, 'Физические лица','123');
end;

function TMemberTest.InsertUpdateMember(const Id, Code: Integer;
  Name, INN : string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inINN', ftString, ptInput, INN);
  FParams.AddParam('inDriverCertificate', ftString, ptInput, '');
  FParams.AddParam('inComment', ftString, ptInput, '');
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.Member_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TMemberTest;
begin
  ObjectTest := TMemberTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка группы
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Физические лица'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

 { TPositionTest }
constructor TPositionTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Position';
  spSelect := 'gpSelect_Object_Position';
  spGet := 'gpGet_Object_Position';
end;

function TPositionTest.InsertDefault: integer;
begin
  result := InsertUpdatePosition(0, -1, 'Должности');
end;

function TPositionTest.InsertUpdatePosition(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.Position_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TPositionTest;
begin
  ObjectTest := TPositionTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка группы
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Должности'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TAssetGroupTest}
constructor TAssetGroupTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_AssetGroup';
  spSelect := 'gpSelect_Object_AssetGroup';
  spGet := 'gpGet_Object_AssetGroup';
end;

function TAssetGroupTest.InsertDefault: integer;
var
  ParentId: Integer;
begin
  ParentId:=0;
  result := InsertUpdateAssetGroup(0, -1, 'Группа основных средств', ParentId);
end;

function TAssetGroupTest.InsertUpdateAssetGroup;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inParentId', ftInteger, ptInput, ParentId);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.AssetGroup_Test;
var Id, Id2, Id3: integer;
    RecordCount: Integer;
    ObjectTest: TAssetGroupTest;
begin
 // тут наша задача проверить правильность работы с деревом.
 // а именно зацикливание.
  ObjectTest := TAssetGroupTest.Create;
  // Получим список объектов
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка объекта
 // добавляем группу 1
  Id := ObjectTest.InsertDefault;
  try
    // теперь делаем ссылку на себя и проверяем ошибку
    try
      ObjectTest.InsertUpdateAssetGroup(Id, -1, 'Тест Группа 1', Id);
      Check(false, 'Нет сообщение об ошибке');
    except

    end;
    // добавляем еще группу 2
    // делаем у группы 2 ссылку на группу 1
    Id2 := ObjectTest.InsertUpdateAssetGroup(0, -2, 'Тест Группа 2', Id);
    try
      // теперь ставим ссылку у группы 1 на группу 2 и проверяем ошибку
      try
        ObjectTest.InsertUpdateAssetGroup(Id, -1, 'Тест Группа 1', Id2);
        Check(false, 'Нет сообщение об ошибке');
      except

      end;
      // добавляем еще группу 3
      // делаем у группы 3 ссылку на группу 2
      Id3 := ObjectTest.InsertUpdateAssetGroup(0, -3, 'Тест Группа 3', Id2);
      try
        // группа 2 уже ссылка на группу 1
        // делаем у группы 1 ссылку на группу 3 и проверяем ошибку
        try
          ObjectTest.InsertUpdateAssetGroup(Id, -1, 'Тест Группа 1', Id3);
          Check(false, 'Нет сообщение об ошибке');
        except

        end;
        Check((GetRecordCount(ObjectTest) = RecordCount + 3), 'Количество записей не изменилось');
      finally
        ObjectTest.Delete(Id3);
      end;
    finally
      ObjectTest.Delete(Id2);
    end;
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TAssetTest}
constructor TAssetTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Asset';
  spSelect := 'gpSelect_Object_Asset';
  spGet := 'gpGet_Object_Asset';
end;

function TAssetTest.InsertDefault: integer;
var
  AssetGroupId: Integer;
  JuridicalId: Integer;
  MakerId: Integer;
begin
  AssetGroupId := TAssetGroupTest.Create.GetDefault;
  JuridicalId:=0;
  MakerId:=0;
  result := InsertUpdateAsset(0, -1, 'Основные средства', date, 'InvNumber', 'FullName', 'SerialNumber'
                            , 'PassportNumber', 'Comment', AssetGroupId,JuridicalId,MakerId);
end;

function TAssetTest.InsertUpdateAsset;
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

procedure TdbObjectTest.Asset_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TAssetTest;
begin
  ObjectTest := TAssetTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
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

{TReceiptCostTest}
constructor TReceiptCostTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ReceiptCost';
  spSelect := 'gpSelect_Object_ReceiptCost';
  spGet := 'gpGet_Object_ReceiptCost';
end;

function TReceiptCostTest.InsertDefault: integer;
begin
   result := InsertUpdateReceiptCost(0, -1, 'Затраты в рецептурах');
end;

function TReceiptCostTest.InsertUpdateReceiptCost;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.ReceiptCost_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TReceiptCostTest;
begin
  ObjectTest := TReceiptCostTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка объекта
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Затраты в рецептурах'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

 {TReceiptChildTest}
 constructor TReceiptChildTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ReceiptChild';
  spSelect := 'gpSelect_Object_ReceiptChild';
  spGet := 'gpGet_Object_ReceiptChild';
end;

function TReceiptChildTest.InsertDefault: integer;
var
  GoodsId, GoodsKindId: Integer;
begin
  GoodsId:= TGoodsTest.Create.GetDefault;
  GoodsKindId:= TGoodsKindTest.Create.GetDefault;

  result := InsertUpdateReceiptChild(0, 123,true, true, date, date, 'Составляющие рецептур - Значение', 2, GoodsId, GoodsKindId);
end;

function TReceiptChildTest.InsertUpdateReceiptChild;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('Value', ftFloat, ptInput, Value);
  FParams.AddParam('Weight', ftBoolean, ptInput, Weight);
  FParams.AddParam('TaxExit', ftBoolean, ptInput, TaxExit);
  FParams.AddParam('StartDate', ftDateTime, ptInput, StartDate);
  FParams.AddParam('EndDate', ftDateTime, ptInput, EndDate);
  FParams.AddParam('Comment', ftString, ptInput, Comment);
  FParams.AddParam('inReceiptId', ftInteger, ptInput, ReceiptId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.ReceiptChild_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TReceiptChildTest;
begin
  ObjectTest := TReceiptChildTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Составляющие рецептур
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Comment').AsString = 'Составляющие рецептур - Значение'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;


 {TReceiptTest}
 constructor TReceiptTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Receipt';
  spSelect := 'gpSelect_Object_Receipt';
  spGet := 'gpGet_Object_Receipt';
end;

function TReceiptTest.InsertDefault: integer;
var
  GoodsId, GoodsKindId, ReceiptCostId: Integer;
begin
  ReceiptCostId := TReceiptCostTest.Create.GetDefault;
  GoodsId:= TGoodsTest.Create.GetDefault;
  GoodsKindId:= TGoodsKindTest.Create.GetDefault;

  result := InsertUpdateReceipt(0, 'Рецептура 1', '123', 'Рецептуры', 1, 2, 80, 2, 1,1 , date, date, true, GoodsId, GoodsKindId, 1, ReceiptCostId, 1);
end;

function TReceiptTest.InsertUpdateReceipt;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('Name', ftString, ptInput, Name);
  FParams.AddParam('Code', ftString, ptInput, Code);
  FParams.AddParam('Comment', ftString, ptInput, Comment);
  FParams.AddParam('Value', ftFloat, ptInput, Value);
  FParams.AddParam('ValueCost', ftFloat, ptInput, ValueCost);
  FParams.AddParam('TaxExit', ftFloat, ptInput, TaxExit);
  FParams.AddParam('PartionValue', ftFloat, ptInput, PartionValue);
  FParams.AddParam('PartionCount', ftFloat, ptInput, PartionCount);
  FParams.AddParam('WeightPackage', ftFloat, ptInput, WeightPackage);
  FParams.AddParam('StartDate', ftDateTime, ptInput, StartDate);
  FParams.AddParam('EndDate', ftDateTime, ptInput, EndDate);
  FParams.AddParam('Main', ftBoolean, ptInput, Main);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);
  FParams.AddParam('inGoodsKindCompleteId', ftInteger, ptInput, GoodsKindCompleteId);
  FParams.AddParam('inReceiptCostId', ftInteger, ptInput, ReceiptCostId);
  FParams.AddParam('inReceiptKindId', ftInteger, ptInput, ReceiptKindId);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.Receipt_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TReceiptTest;
begin
  ObjectTest := TReceiptTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Рецептуре
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Рецептура 1'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization

  TestFramework.RegisterTest('Объекты', TdbObjectTest.Suite);

end.
