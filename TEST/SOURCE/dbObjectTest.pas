unit dbObjectTest;

interface
uses Classes, TestFramework, Authentication, Db, XMLIntf, dsdDB, dbTest;

type

  TObjectTest = class
  private
    FspInsertUpdate: string;
    FspSelect: string;
    FspGet: string;
  protected
    FdsdStoredProc: TdsdStoredProc;
    FParams: TdsdParams;
    property spGet: string read FspGet write FspGet;
    property spSelect: string read FspSelect write FspSelect;
    property spInsertUpdate: string read FspInsertUpdate write FspInsertUpdate;
    function InsertUpdate(dsdParams: TdsdParams): Integer;
    procedure InsertUpdateInList(Id: integer); virtual;
    function InsertDefault: integer; virtual;
    procedure SetDataSetParam; virtual;
    procedure DeleteRecord(Id: Integer); virtual;
  public
    function GetDefault: integer;
    function GetDataSet: TDataSet; virtual;
    function GetRecord(Id: integer): TDataSet;
    procedure Delete(Id: Integer); virtual;
    constructor Create; virtual;
    destructor Destoy;
  end;

  TdbObjectTestNew = class (TdbTest)
  protected
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  end;

  TdbObjectTest = class (TdbTest)
  protected
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;

    function GetRecordCount(ObjectTest: TObjectTest): integer;

  published
    procedure Bank_Test;
    procedure Branch_Test;
    procedure CarModel_Test;
    procedure Car_Test;
    procedure Contract_Test;
    procedure ContractKind_Test;
    procedure Goods_Test;
    procedure GoodsGroup_Test;
    procedure GoodsKind_Test;
    procedure GoodsProperty_Test;
    procedure GoodsPropertyValue_Test;
    procedure JuridicalGroup_Test;
    procedure Measure_Test;
    procedure PaidKind_Test;
    procedure Partner_Test;
    procedure PriceList_Test;
    procedure Route_Test;
    procedure RouteSorting_Test;
    procedure User_Test;
    procedure AccountGroup_Test;
    procedure AccountDirection_Test;
    procedure ProfitLossGroup_Test;
    procedure ProfitLossDirection_Test;
    procedure ProfitLoss_Test;
    procedure InfoMoneyGroup_Test;
    procedure InfoMoneyDestination_Test;
    procedure InfoMoney_Test;
    procedure Member_Test;
    procedure Position_Test;
    procedure Personal_Test;
    procedure AssetGroup_Test;
    procedure Asset_Test;
    procedure ReceiptCost_Test;
    procedure ReceiptChild_Test;
    procedure Receipt_Test;
   end;

  TBankTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateBank(const Id, Code: Integer; Name: string; MFO: string; JuridicalId: integer): integer;
    constructor Create; override;
  end;

  TContractTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateContract(const Id: integer; InvNumber, Comment: string;
                                        SigningDate, StartDate, EndDate: TDateTime ): integer;
    constructor Create; override;
  end;

  TCurrencyTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    constructor Create; override;
  end;

  TGoodsTest = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateGoods(Id, Code: Integer; Name: String;
                               Weight: Double;
                               GoodsGroupId, MeasureId, TradeMarkId,ItemInfoMoneyId,BusinessId,FuelId: Integer): integer;
    constructor Create; override;
  end;

  TGoodsPropertyTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateGoodsProperty(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

  TGoodsPropertyValueTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateGoodsPropertyValue(const Id: Integer; Name: string;
        Amount: double; BarCode, Article, BarCodeGLN, ArticleGLN: string;
        GoodsPropertyId, GoodsId, GoodsKindId: Integer): integer;
    constructor Create; override;
  end;

  TPartnerTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdatePartner(const Id: integer; Code: Integer;
        Name, GLNCode: string; PrepareDayCount, DocumentDayCount: Double;
        JuridicalId, RouteId, RouteSortingId, PersonalTakeId: integer): integer;
    constructor Create; override;
  end;

  TJuridicalGroupTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateJuridicalGroup(const Id, Code: Integer; Name: string; JuridicalGroupId: integer): integer;
    constructor Create; override;
  end;

  TPriceListTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdatePriceList(const Id, Code: Integer; Name: string;PriceWithVAT:Boolean;VATPercent:Double): integer;
    constructor Create; override;
  end;

  TRouteTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateRoute(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

  TRouteSortingTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateRouteSorting(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

  TPaidKindTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdatePaidKind(const Id: integer; Code: Integer;
        Name: string): integer;
    constructor Create; override;
  end;

  TContractKindTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateContractKind(const Id: integer; Code: Integer;
        Name: string): integer;
    constructor Create; override;
  end;

  TBranchTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
   function InsertUpdateBranch(const Id: integer; Code: Integer;
        Name: string): integer;
    constructor Create; override;
  end;

  TGoodsGroupTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateGoodsGroup(const Id: integer; Code: Integer;
        Name: string; ParentId: integer): integer;
    constructor Create; override;
  end;

  TGoodsKindTest = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateGoodsKind(Id, Code: Integer; Name: String): integer;
    constructor Create; override;
  end;

  TMeasureTest = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    function InsertUpdateMeasure(Id, Code: Integer; Name: String): integer;
    constructor Create; override;
  end;

  TCarModelTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateCarModel(Id, Code: Integer; Name: String): integer;
    constructor Create; override;
  end;

  TCarTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateCar(const Id, Code : integer; Name, RegistrationCertificateId: string; CarModelId: Integer): integer;
    constructor Create; override;
  end;

  TUserTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateUser(const Id: integer; UserName, Login, Password: string): integer;
    constructor Create; override;
  end;

  TAccountGroupTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateAccountGroup(const Id, Code: Integer; Name: string): integer;
    constructor Create; override;
  end;

  TAccountDirectionTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
    function InsertUpdateAccountDirection(const Id, Code: Integer; Name: string): integer;
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

  TPersonalTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
   function InsertUpdatePersonal(const Id: integer; Code: Integer; Name: string;
    MemberId, PositionId, UnitId, JuridicalId, BusinessId: integer; DateIn, DateOut: TDateTime): integer;
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
    function InsertUpdateAsset(const Id, Code : integer; Name, InvNumber: string; AssetGroupId: Integer): integer;
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

  var
      // Список добавленных Id
    InsertedIdObjectList: TStringList;


 implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, ZLibEx, zLibUtil,

     UnitsTest, JuridicalTest, BusinessTest;


{ TObjectTest }

constructor TObjectTest.Create;
begin
  FdsdStoredProc := TdsdStoredProc.Create(nil);
  FParams := TdsdParams.Create(nil, TdsdParam);
end;

procedure TObjectTest.DeleteRecord(Id: Integer);
const
   pXML =
  '<xml Session = "">' +
    '<lpDelete_Object OutputType="otResult">' +
       '<inId DataType="ftInteger" Value="%d"/>' +
    '</lpDelete_Object>' +
  '</xml>';
begin
  TStorageFactory.GetStorage.ExecuteProc(Format(pXML, [Id]))
end;

procedure TObjectTest.Delete(Id: Integer);
var Index: Integer;
begin
  if InsertedIdObjectList.Find(IntToStr(Id), Index) then begin
     // здесь мы разрешаем удалять ТОЛЬКО вставленные в момент теста данные
     DeleteRecord(Id);
     InsertedIdObjectList.Delete(Index);
  end
  else
     raise Exception.Create('Попытка удалить запись, вставленную вне теста!!!');
end;

destructor TObjectTest.Destoy;
var i: integer;
begin
  FdsdStoredProc.Free;
end;

function TObjectTest.GetDataSet: TDataSet;
begin
  with FdsdStoredProc do begin
    if (DataSets.Count = 0) or not Assigned(DataSets[0].DataSet) then
       DataSets.Add.DataSet := TClientDataSet.Create(nil);
    StoredProcName := FspSelect;
    OutputType := otDataSet;
    FParams.Clear;
    SetDataSetParam;
    Params.Assign(FParams);
    Execute;
    result := DataSets[0].DataSet;
  end;
end;

function TObjectTest.GetDefault: integer;
begin
  if GetDataSet.RecordCount > 0 then
     result := GetDataSet.FieldByName('Id').AsInteger
  else
     result := InsertDefault;
end;

function TObjectTest.GetRecord(Id: integer): TDataSet;
begin
  with FdsdStoredProc do begin
    DataSets.Add.DataSet := TClientDataSet.Create(nil);
    StoredProcName := FspGet;
    OutputType := otDataSet;
    Params.Clear;
    Params.AddParam('ioId', ftInteger, ptInputOutput, Id);
    Execute;
    result := DataSets[0].DataSet;
  end;
end;

function TObjectTest.InsertDefault: integer;
begin
end;

function TObjectTest.InsertUpdate(dsdParams: TdsdParams): Integer;
var OldId: integer;
begin
  with FdsdStoredProc do begin
    StoredProcName := FspInsertUpdate;
    OutputType := otResult;
    Params.Assign(dsdParams);
    Execute;
    Result := StrToInt(ParamByName('ioId').Value);
    if OldId <> Result then
       InsertUpdateInList(Result)
  end;
end;

procedure TObjectTest.InsertUpdateInList(Id: integer);
begin
  InsertedIdObjectList.Add(IntToStr(Id));
end;

procedure TObjectTest.SetDataSetParam;
begin
  FdsdStoredProc.Params.Clear;
end;

{ TDataBaseObjectTest }
{------------------------------------------------------------------------------}
function TdbObjectTest.GetRecordCount(ObjectTest: TObjectTest): integer;
begin
  Result := ObjectTest.GetDataSet.RecordCount;
end;
{------------------------------------------------------------------------------}
procedure TdbObjectTest.GoodsPropertyValue_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TGoodsPropertyValueTest;
begin
  ObjectTest := TGoodsPropertyValueTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка объекта
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о юр лице
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'GoodsPropertyValue'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;

procedure TdbObjectTest.Goods_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TGoodsTest;
begin
  ObjectTest := TGoodsTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка объекта
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о юр лице
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Товар 1'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;
{------------------------------------------------------------------------------}
procedure TdbObjectTest.User_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TUserTest;
begin
  ObjectTest := TUserTest.Create;
  // Получим список пользователей
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка пользователя
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о пользователе
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('name').AsString = 'UserName'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
    // Проверка на дублируемость
    try
      ObjectTest.InsertUpdateUser(0, 'UserName', 'Login', 'Password');
      Check(false, 'Нет сообщения об ошибке InsertUpdate_Object_User Id=0');
    except

    end;
    // Изменение пользователя

    // Получим список пользователей
    Check((GetRecordCount(ObjectTest) = RecordCount + 1), 'Количество записей не изменилось');
  finally
    ObjectTest.Delete(Id);
  end;
end;
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
end;

{ TUserTest }

constructor TUserTest.Create;
begin
  inherited Create;
  spInsertUpdate := 'gpInsertUpdate_Object_User';
  spSelect := 'gpSelect_Object_User';
  spGet := 'gpGet_Object_User';
end;

function TUserTest.InsertDefault: integer;
begin
  result := InsertUpdateUser(0, 'UserName', 'Login', 'Password');
end;

function TUserTest.InsertUpdateUser(const Id: integer; UserName, Login, Password: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inUserName', ftString, ptInput, UserName);
  FParams.AddParam('inLogin', ftString, ptInput, Login);
  FParams.AddParam('inPassword', ftString, ptInput, Password);
  result := InsertUpdate(FParams);
end;

{ TJuridicalGroupTest }
constructor TJuridicalGroupTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_JuridicalGroup';
  spSelect := 'gpSelect_Object_JuridicalGroup';
  spGet := 'gpGet_Object_JuridicalGroup';
end;

function TJuridicalGroupTest.InsertDefault: integer;
begin
  result := InsertUpdateJuridicalGroup(0, -1, 'Группа юр лиц 1', 0);
end;

function TJuridicalGroupTest.InsertUpdateJuridicalGroup(const Id, Code: Integer;
  Name: string; JuridicalGroupId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inJuridicalGroupId', ftInteger, ptInput, JuridicalGroupId);
  result := InsertUpdate(FParams);
end;

{ TGoodsPropertyTest }

constructor TGoodsPropertyTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_GoodsProperty';
  spSelect := 'gpSelect_Object_GoodsProperty';
  spGet := 'gpGet_Object_GoodsProperty';
end;

function TGoodsPropertyTest.InsertDefault: integer;
begin
  result := InsertUpdateGoodsProperty(0, -1, 'Классификатор свойств товаров');
end;

function TGoodsPropertyTest.InsertUpdateGoodsProperty(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

  {TRouteTest }
constructor TRouteTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Route';
  spSelect := 'gpSelect_Object_Route';
  spGet := 'gpGet_Object_Route';
end;

function TRouteTest.InsertDefault: integer;
begin
  result := InsertUpdateRoute(0, -1, 'Маршрут');
end;

function TRouteTest.InsertUpdateRoute(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

  {TRouteSortingTest }
constructor TRouteSortingTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_RouteSorting';
  spSelect := 'gpSelect_Object_RouteSorting';
  spGet := 'gpGet_Object_RouteSorting';
end;

function TRouteSortingTest.InsertDefault: integer;
begin
  result := InsertUpdateRouteSorting(0, -1, 'Сортировка маршрутов');
end;

function TRouteSortingTest.InsertUpdateRouteSorting(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

    {TBankTest }
 constructor TBankTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Bank';
  spSelect := 'gpSelect_Object_Bank';
  spGet := 'gpGet_Object_Bank';
end;

function TBankTest.InsertDefault: integer;
var
  JuridicalId: Integer;
begin
  JuridicalId := TJuridical.Create.GetDefault;
  result := InsertUpdateBank(0, -1, 'Банк', 'МФО', JuridicalId)
end;

function TBankTest.InsertUpdateBank;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inMFO', ftString, ptInput, MFO);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  result := InsertUpdate(FParams);
end;

    { TPartnerTest }
 constructor TPartnerTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Partner';
  spSelect := 'gpSelect_Object_Partner';
  spGet := 'gpGet_Object_Partner';
end;

function TPartnerTest.InsertDefault: integer;
var
  JuridicalId, RouteId, RouteSortingId, PersonalTakeId: Integer;
begin
  JuridicalId := TJuridical.Create.GetDefault;
  RouteId := TRouteTest.Create.GetDefault;
  RouteSortingId := TRouteSortingTest.Create.GetDefault;
  PersonalTakeId := 0; //TPersonalTest.Create.GetDefault;
  result := InsertUpdatePartner(0, -6, 'Контрагенты', 'GLNCode', 15, 15, JuridicalId, RouteId, RouteSortingId, PersonalTakeId);
end;

function TPartnerTest.InsertUpdatePartner;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inGLNCode', ftString, ptInput, GLNCode);
  FParams.AddParam('inPrepareDayCount', ftFloat, ptInput, PrepareDayCount);
  FParams.AddParam('inDocumentDayCount', ftFloat, ptInput, DocumentDayCount);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inRouteId', ftInteger, ptInput, RouteId);
  FParams.AddParam('inRouteSortingId', ftInteger, ptInput, RouteSortingId);
  FParams.AddParam('inPersonalTakeId', ftInteger, ptInput, PersonalTakeId);
  result := InsertUpdate(FParams);
end;
{ TDataBaseUsersObjectTest }

procedure TdbObjectTest.JuridicalGroup_Test;
var Id, Id2, Id3: integer;
    RecordCount: Integer;
    ObjectTest: TJuridicalGroupTest;
begin
 // тут наша задача проверить правильность работы с деревом.
 // а именно зацикливание.
  ObjectTest := TJuridicalGroupTest.Create;
  // Получим список объектов
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка объекта
 // добавляем группу 1
  Id := ObjectTest.InsertDefault;
  try
    // теперь делаем ссылку на себя и проверяем ошибку
    try
      ObjectTest.InsertUpdateJuridicalGroup(Id, 1, 'Группа 1', Id);
      Check(false, 'Нет сообщение об ошибке');
    except

    end;
    // добавляем еще группу 2
    // делаем у группы 2 ссылку на группу 1
    Id2 := ObjectTest.InsertUpdateJuridicalGroup(0, 2, 'Группа 2', Id);
    try
      // теперь ставим ссылку у группы 1 на группу 2 и проверяем ошибку
      try
        ObjectTest.InsertUpdateJuridicalGroup(Id, 1, 'Группа 1', Id2);
        Check(false, 'Нет сообщение об ошибке');
      except

      end;
      // добавляем еще группу 3
      // делаем у группы 3 ссылку на группу 2
      Id3 := ObjectTest.InsertUpdateJuridicalGroup(0, 3, 'Группа 3', Id2);
      try
        // группа 2 уже ссылка на группу 1
        // делаем у группы 1 ссылку на группу 3 и проверяем ошибку
        try
          ObjectTest.InsertUpdateJuridicalGroup(Id, 1, 'Группа 1', Id3);
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

procedure TdbObjectTest.PriceList_Test;
begin

end;

procedure TdbObjectTest.Bank_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TBankTest;
begin
  ObjectTest := TBankTest.Create;
  // Проверили выполнение Get для 0 записи
  ObjectTest.GetRecord(0);
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка Банка
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о банке
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Банк'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;

procedure TdbObjectTest.Contract_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TContractTest;
begin
  ObjectTest := TContractTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка юр лица
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о юр лице
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('InvNumber').AsString = '123456'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;

procedure TdbObjectTest.Route_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TRouteTest;
begin
  ObjectTest := TRouteTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка юр лица
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о маршруте
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Маршрут'), 'Не сходятся данные Id = ' + IntToStr(Id));

  finally
    ObjectTest.Delete(Id);
  end;
end;

procedure TdbObjectTest.RouteSorting_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TRouteSortingTest;
begin
  ObjectTest := TRouteSortingTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка юр лица
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о сортировке маршрута
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Сортировка маршрутов'), 'Не сходятся данные Id = ' + IntToStr(Id));

  finally
    ObjectTest.Delete(Id);
  end;
end;

procedure TdbObjectTest.Partner_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TPartnerTest;
begin
  ObjectTest := TPartnerTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка контрагента
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о контрагенте
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('GLNCode').AsString = 'GLNCode'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TContractTest }
 constructor TContractTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Contract';
  spSelect := 'gpSelect_Object_Contract';
  spGet := 'gpGet_Object_Contract';
end;

function TContractTest.InsertDefault: integer;
begin
  result := InsertUpdateContract(0, '123456', 'comment', date,date,date);
end;

function TContractTest.InsertUpdateContract(const Id: integer; InvNumber,
  Comment: string; SigningDate, StartDate, EndDate: TDateTime): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inComment', ftString, ptInput, Comment);

  FParams.AddParam('inSigningDate', ftDateTime, ptInput, SigningDate);
  FParams.AddParam('inStartDate', ftDateTime, ptInput, StartDate);
  FParams.AddParam('inEndDate', ftDateTime, ptInput, EndDate);

  result := InsertUpdate(FParams);
end;


{ TGoodsTest }

constructor TGoodsTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Goods';
  spSelect := 'gpSelect_Object_Goods';
  spGet := 'gpGet_Object_Goods';
end;

function TGoodsTest.InsertDefault: integer;
begin
  result := InsertUpdateGoods(0, -1, 'Товар 1', 1.0, 0, 0, 0, 0, 0, 0)
end;

function TGoodsTest.InsertUpdateGoods(Id, Code: Integer; Name: String;
                                      Weight: Double;
                                      GoodsGroupId, MeasureId, TradeMarkId,ItemInfoMoneyId,BusinessId,FuelId: Integer): integer;

begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inWeight', ftFloat, ptInput, Weight);
  FParams.AddParam('inGoodsGroupId', ftInteger, ptInput, GoodsGroupId);
  FParams.AddParam('inMeasureId', ftInteger, ptInput, MeasureId);
  FParams.AddParam('inTradeMarkId', ftInteger, ptInput, TradeMarkId);
  FParams.AddParam('inItemInfoMoneyId', ftInteger, ptInput, ItemInfoMoneyId);
  FParams.AddParam('inBusinessId', ftInteger, ptInput, BusinessId);
  FParams.AddParam('inFuelId', ftInteger, ptInput, FuelId);
  result := InsertUpdate(FParams);
end;

{ TGoodsPropertyValueTest }
constructor TGoodsPropertyValueTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_GoodsPropertyValue';
  spSelect := 'gpSelect_Object_GoodsPropertyValue';
  spGet := 'gpGet_Object_GoodsPropertyValue';
end;

function TGoodsPropertyValueTest.InsertDefault: integer;
var
  GoodsPropertyId, GoodsId, GoodsKindId: Integer;
begin
  GoodsId := TGoodsTest.Create.GetDefault;
  GoodsPropertyId := TGoodsPropertyTest.Create.GetDefault;
  GoodsKindId := 0;
  result := InsertUpdateGoodsPropertyValue(0, 'GoodsPropertyValue', 10,
         'BarCode', 'Article', 'BarCodeGLN', 'ArticleGLN',
         GoodsPropertyId, GoodsId, GoodsKindId)
end;

function TGoodsPropertyValueTest.InsertUpdateGoodsPropertyValue(
  const Id: Integer; Name: string; Amount: double; BarCode, Article, BarCodeGLN,
  ArticleGLN: string; GoodsPropertyId, GoodsId, GoodsKindId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inAmount', ftFloat, ptInput, Amount);
  FParams.AddParam('inBarCode', ftString, ptInput, BarCode);
  FParams.AddParam('inArticle', ftString, ptInput, Article);
  FParams.AddParam('inBarCodeGLN', ftString, ptInput, BarCodeGLN);
  FParams.AddParam('inArticleGLN', ftString, ptInput, ArticleGLN);

  FParams.AddParam('inGoodsPropertyId', ftInteger, ptInput, GoodsPropertyId);
  FParams.AddParam('inGoodsId', ftInteger, ptInput, GoodsId);
  FParams.AddParam('inGoodsKindId', ftInteger, ptInput, GoodsKindId);

  result := InsertUpdate(FParams);
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

{TPaidKindTest}
constructor TPaidKindTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_PaidKind';
  spSelect := 'gpSelect_Object_PaidKind';
  spGet := 'gpGet_Object_PaidKind';
end;

function TPaidKindTest.InsertDefault: integer;
begin
  result := InsertUpdatePaidKind(0, -3, 'Вид Формы оплаты');
end;

function TPaidKindTest.InsertUpdatePaidKind;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.PaidKind_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TPaidKindTest;
begin
  ObjectTest := TPaidKindTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка Вида Формы оплаты
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Виде Формы оплаты
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Вид Формы оплаты'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TContractKindTest}
constructor TContractKindTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_ContractKind';
  spSelect := 'gpSelect_Object_ContractKind';
  spGet := 'gpGet_Object_ContractKind';
end;

function TContractKindTest.InsertDefault: integer;
begin
  result := InsertUpdateContractKind(0, -1, 'Вид договора');
end;

function TContractKindTest.InsertUpdateContractKind;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.ContractKind_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TContractKindTest;
begin
  ObjectTest := TContractKindTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка Вида договора
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Вида договора
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Вид договора'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

 {TBranchTest}
 constructor TBranchTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Branch';
  spSelect := 'gpSelect_Object_Branch';
  spGet := 'gpGet_Object_Branch';
end;

function TBranchTest.InsertDefault: integer;
begin
  result := InsertUpdateBranch(0, -1, 'Филиал');
  //FInsertedId := result;
end;

function TBranchTest.InsertUpdateBranch;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.Branch_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TBranchTest;
begin
  ObjectTest := TBranchTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка Филиала
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Филиале
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Филиал'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

 {TGoodsGroupTest}
constructor TGoodsGroupTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_GoodsGroup';
  spSelect := 'gpSelect_Object_GoodsGroup';
  spGet := 'gpGet_Object_GoodsGroup';
end;

function TGoodsGroupTest.InsertDefault: integer;
var
  ParentId: Integer;
begin
  ParentId:=0;
  result := InsertUpdateGoodsGroup(0, -1, 'Группа товара', ParentId);
end;

function TGoodsGroupTest.InsertUpdateGoodsGroup;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inParentId', ftInteger, ptInput, ParentId);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.GoodsGroup_Test;
var Id, Id2, Id3: integer;
    RecordCount: Integer;
    ObjectTest: TGoodsGroupTest;
begin
 // тут наша задача проверить правильность работы с деревом.
 // а именно зацикливание.
  ObjectTest := TGoodsGroupTest.Create;
  // Получим список объектов
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка объекта
 // добавляем группу 1
  Id := ObjectTest.InsertDefault;
  try
    // теперь делаем ссылку на себя и проверяем ошибку
    try
      ObjectTest.InsertUpdateGoodsGroup(Id, 1, 'Группа 1', Id);
      Check(false, 'Нет сообщение об ошибке');
    except

    end;
    // добавляем еще группу 2
    // делаем у группы 2 ссылку на группу 1
    Id2 := ObjectTest.InsertUpdateGoodsGroup(0, 2, 'Группа 2', Id);
    try
      // теперь ставим ссылку у группы 1 на группу 2 и проверяем ошибку
      try
        ObjectTest.InsertUpdateGoodsGroup(Id, 1, 'Группа 1', Id2);
        Check(false, 'Нет сообщение об ошибке');
      except

      end;
      // добавляем еще группу 3
      // делаем у группы 3 ссылку на группу 2
      Id3 := ObjectTest.InsertUpdateGoodsGroup(0, 3, 'Группа 3', Id2);
      try
        // группа 2 уже ссылка на группу 1
        // делаем у группы 1 ссылку на группу 3 и проверяем ошибку
        try
          ObjectTest.InsertUpdateGoodsGroup(Id, 1, 'Группа 1', Id3);
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

{TGoodsKindTest}
constructor TGoodsKindTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_GoodsKind';
  spSelect := 'gpSelect_Object_GoodsKind';
  spGet := 'gpGet_Object_GoodsKind';
end;

function TGoodsKindTest.InsertDefault: integer;
begin
  result := InsertUpdateGoodsKind(0, -1, 'Вид товара');
end;

function TGoodsKindTest.InsertUpdateGoodsKind;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.GoodsKind_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TGoodsKindTest;
begin
  ObjectTest := TGoodsKindTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка Вида товара
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Виде товара
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Вид товара'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TMeasureTest}
constructor TMeasureTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Measure';
  spSelect := 'gpSelect_Object_Measure';
  spGet := 'gpGet_Object_Measure';
end;

function TMeasureTest.InsertDefault: integer;
begin
  result := InsertUpdateMeasure(0, 1, 'Единица измерения');
end;

function TMeasureTest.InsertUpdateMeasure;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.Measure_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TMeasureTest;
begin
  ObjectTest := TMeasureTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка Единицы измерения
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Единице измерения
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Единица измерения'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{TGoodsPropertyTest}
procedure TdbObjectTest.GoodsProperty_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TGoodsPropertyTest;
begin
  ObjectTest := TGoodsPropertyTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка классификатора свойств товаров
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о классификаторе свойств товаров
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Классификатор свойств товаров'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

  finally
    ObjectTest.Delete(Id);
  end;
end;

{TCarModelTest}
constructor TCarModelTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_CarModel';
  spSelect := 'gpSelect_Object_CarModel';
  spGet := 'gpGet_Object_CarModel';
end;

function TCarModelTest.InsertDefault: integer;
begin
  result := InsertUpdateCarModel(0, -1, 'Марка автомобиля');
end;

function TCarModelTest.InsertUpdateCarModel;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.CarModel_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TCarModelTest;
begin
  ObjectTest := TCarModelTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка Марки автомобиля
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Единице измерения
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Марка автомобиля'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

 {TCarTest}
 constructor TCarTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Car';
  spSelect := 'gpSelect_Object_Car';
  spGet := 'gpGet_Object_Car';
end;

function TCarTest.InsertDefault: integer;
var
  CarModelId: Integer;
begin
  CarModelId := TCarModelTest.Create.GetDefault;
  result := InsertUpdateCar(0, -1, 'Автомобиль', 'АЕ НЕ', CarModelId);
end;

function TCarTest.InsertUpdateCar;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('RegistrationCertificateId', ftString, ptInput, RegistrationCertificateId);
  FParams.AddParam('inCarModelId', ftInteger, ptInput, CarModelId);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.Car_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TCarTest;
begin
  ObjectTest := TCarTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка Автомобиля
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Филиале
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Автомобиль'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

{ TAccountGroupTest }
constructor TAccountGroupTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_AccountGroup';
  spSelect := 'gpSelect_Object_AccountGroup';
  spGet := 'gpGet_Object_AccountGroup';
end;

function TAccountGroupTest.InsertDefault: integer;
begin
  result := InsertUpdateAccountGroup(0, -4, 'Группа управленческих счетов 1');
end;

function TAccountGroupTest.InsertUpdateAccountGroup(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.AccountGroup_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TAccountGroupTest;
begin
  ObjectTest := TAccountGroupTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка группы урп.счетов
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Группа управленческих счетов 1'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;


{ TAccountDirectionTest }
constructor TAccountDirectionTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_AccountDirection';
  spSelect := 'gpSelect_Object_AccountDirection';
  spGet := 'gpGet_Object_AccountDirection';
end;

function TAccountDirectionTest.InsertDefault: integer;
begin
  result := InsertUpdateAccountDirection(0, -4, 'Аналитики управленческих счетов 1');
end;

function TAccountDirectionTest.InsertUpdateAccountDirection(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.AccountDirection_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TAccountDirectionTest;
begin
  ObjectTest := TAccountDirectionTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка группы урп.счетов
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Аналитики управленческих счетов 1'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

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

{TPersonalTest}
 constructor TPersonalTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Personal';
  spSelect := 'gpSelect_Object_Personal';
  spGet := 'gpGet_Object_Personal';
end;

function TPersonalTest.InsertDefault: integer;
var
  MemberId: Integer;
  PositionId: Integer;
  UnitId: Integer;
  JuridicalId: Integer;
  BusinessId: Integer;
begin
  MemberId := TMemberTest.Create.GetDefault;
  PositionId := TPositionTest.Create.GetDefault;
  UnitId := TUnit.Create.GetDefault;
  JuridicalId := TJuridical.Create.GetDefault;
  BusinessId := TBusiness.Create.GetDefault;
  result := InsertUpdatePersonal(0, -3, 'Сотрудник', MemberId, PositionId, UnitId, JuridicalId, BusinessId, Date,Date);
end;

function TPersonalTest.InsertUpdatePersonal;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inMemberId', ftInteger, ptInput, MemberId);
  FParams.AddParam('inPositionId', ftInteger, ptInput, PositionId);
  FParams.AddParam('inUnitId', ftInteger, ptInput, UnitId);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inBusinessId', ftInteger, ptInput, BusinessId);
  FParams.AddParam('inDateIn', ftDateTime, ptInput, DateIn);
  FParams.AddParam('inDateOut', ftDateTime, ptInput, DateOut);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.Personal_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TPersonalTest;
begin
  ObjectTest := TPersonalTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Code').AsInteger = -3), 'Не сходятся данные Id = ' + IntToStr(Id));
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
      ObjectTest.InsertUpdateAssetGroup(Id, 1, 'Группа 1', Id);
      Check(false, 'Нет сообщение об ошибке');
    except

    end;
    // добавляем еще группу 2
    // делаем у группы 2 ссылку на группу 1
    Id2 := ObjectTest.InsertUpdateAssetGroup(0, 2, 'Группа 2', Id);
    try
      // теперь ставим ссылку у группы 1 на группу 2 и проверяем ошибку
      try
        ObjectTest.InsertUpdateAssetGroup(Id, 1, 'Группа 1', Id2);
        Check(false, 'Нет сообщение об ошибке');
      except

      end;
      // добавляем еще группу 3
      // делаем у группы 3 ссылку на группу 2
      Id3 := ObjectTest.InsertUpdateAssetGroup(0, 3, 'Группа 3', Id2);
      try
        // группа 2 уже ссылка на группу 1
        // делаем у группы 1 ссылку на группу 3 и проверяем ошибку
        try
          ObjectTest.InsertUpdateAssetGroup(Id, 1, 'Группа 1', Id3);
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
begin
  AssetGroupId := TAssetGroupTest.Create.GetDefault;
  result := InsertUpdateAsset(0, -1, 'Основные средства', 'АЕ2323', AssetGroupId);
end;

function TAssetTest.InsertUpdateAsset;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inAssetGroupId', ftInteger, ptInput, AssetGroupId);
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

{ TdbObjectTestNew }

procedure TdbObjectTestNew.SetUp;
begin
  inherited;
  TAuthentication.CheckLogin(TStorageFactory.GetStorage, 'Админ', 'Админ', gc_User);
end;

procedure TdbObjectTestNew.TearDown;
begin
  inherited;
  if Assigned(InsertedIdObjectList) then
     with TObjectTest.Create do
       while InsertedIdObjectList.Count > 0 do begin
          DeleteRecord(StrToInt(InsertedIdObjectList[0]));
          InsertedIdObjectList.Delete(0);
       end;
end;

initialization
  InsertedIdObjectList := TStringList.Create;
  InsertedIdObjectList.Sorted := true;

  TestFramework.RegisterTest('Объекты', TdbObjectTest.Suite);

end.
