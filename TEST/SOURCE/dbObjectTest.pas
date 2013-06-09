unit dbObjectTest;

interface
uses TestFramework, Authentication, Db, XMLIntf, dsdDB;

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
    function InsertDefault: integer; virtual; abstract;
    procedure SetDataSetParam; virtual;
    procedure DeleteObject(Id: Integer);
  public
    function GetDefault: integer;
    function GetDataSet: TDataSet; virtual;
    function GetRecord(Id: integer): TDataSet;
    // Удаляется Объект и все подчиненные
    procedure Delete(Id: Integer); virtual;
    constructor Create; virtual;
    destructor Destoy;
  end;

  TdbObjectTest = class (TTestCase)
  protected
    // получение поличества записей
    function GetRecordCount(ObjectTest: TObjectTest): integer;
    // подготавливаем данные для тестирования
    procedure SetUp; override;
    // возвращаем данные для тестирования
    procedure TearDown; override;
  published
    procedure Bank_Test;
    procedure Branch_Test;
    procedure Business_Test;
    procedure Cash_Test;
    procedure Contract_Test;
    procedure ContractKind_Test;
    procedure Goods_Test;
    procedure GoodsGroup_Test;
    procedure GoodsKind_Test;
    procedure GoodsProperty_Test;
    procedure GoodsPropertyValue_Test;
    procedure JuridicalGroup_Test;
    procedure Juridical_Test;
    procedure Measure_Test;
    procedure PaidKind_Test;
    procedure Partner_Test;
    procedure PriceList_Test;
    procedure Route_Test;
    procedure RouteSorting_Test;
    procedure Unit_Test;
    procedure UnitGroup_Test;
    procedure User_Test;
    procedure BankAccount_Test;
  end;

  TBankTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    // Удаляется Объект и все подчиненные
    procedure Delete(Id: Integer); override;
    function InsertUpdateBank(const Id, Code: Integer; Name: string; MFO: string; JuridicalId: integer): integer;
    constructor Create; override;
  end;

  TCashTest = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    // Удаляется Объект и все подчиненные
    procedure Delete(Id: Integer); override;
    function InsertUpdateCash(const Id, Code : integer; CashName: string; CurrencyId: Integer;
                                     BranchId, PaidKindId: integer): integer;
    constructor Create; override;
  end;

  TContractTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateContract(const Id: integer; InvNumber, Comment: string): integer;
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
                               GoodsGroupId, MeasureId: Integer; Weight: Double; ItemInfoMoneyId: Integer): integer;
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
      // Удаляется Объект и все подчиненные
    procedure Delete(Id: Integer); override;
    function InsertUpdateGoodsPropertyValue(const Id: Integer; Name: string;
        Amount: double; BarCode, Article, BarCodeGLN, ArticleGLN: string;
        GoodsPropertyId, GoodsId, GoodsKindId: Integer): integer;
    constructor Create; override;
  end;

  TPartnerTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    // Удаляется Объект и все подчиненные
    procedure Delete(Id: Integer); override;
    function InsertUpdatePartner(const Id: integer; Code: Integer;
        Name, GLNCode: string; JuridicalId, RouteId, RouteSortingId: integer): integer;
    constructor Create; override;
  end;

  TJuridicalTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
      // Удаляется Объект и все подчиненные
   procedure Delete(Id: Integer); override;
   function InsertUpdateJuridical(const Id: integer; Code: Integer;
        Name, GLNCode: string; isCorporate: boolean; JuridicalGroupId, GoodsPropertyId: integer): integer;
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
    function InsertUpdatePriceList(const Id, Code: Integer; Name: string): integer;
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

  TBusinessTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateBusiness(const Id: integer; Code: Integer;
        Name: string): integer;
    constructor Create; override;
  end;

  TBranchTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
   // Удаляется Объект и все подчиненные
   procedure Delete(Id: Integer); override;
   function InsertUpdateBranch(const Id: integer; Code: Integer;
        Name: string; JuridicalId: integer): integer;
    constructor Create; override;
  end;

  TUnitGroupTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateUnitGroup(const Id: integer; Code: Integer;
        Name: string; ParentId: integer): integer;
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

  TUnitTest = class(TObjectTest)
    function InsertDefault: integer; override;
  public
    // Удаляется Объект и все подчиненные
    procedure Delete(Id: Integer); override;
    function InsertUpdateUnit(Id, Code: Integer; Name: String;
                              UnitGroupId, BranchId: integer): integer;
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

  TBankAccountTest = class(TObjectTest)
  function InsertDefault: integer; override;
  public
     // Удаляется Объект и все подчиненные
    procedure Delete(Id: Integer); override;
    function InsertUpdateBankAccount(Id, Code: Integer; Name: String;
                            JuridicalId, BankId, CurrencyId: Integer): integer;
    constructor Create; override;
  end;

  TUserTest = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdateUser(const Id: integer; UserName, Login, Password: string): integer;
    constructor Create; override;
  end;

implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     Classes, UtilConvert, ZLibEx;


{ TObjectTest }

constructor TObjectTest.Create;
begin
  FdsdStoredProc := TdsdStoredProc.Create(nil);
  FParams := TdsdParams.Create(TdsdParam);
end;

procedure TObjectTest.DeleteObject(Id: Integer);
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
begin
  DeleteObject(Id);
end;

destructor TObjectTest.Destoy;
begin
  FdsdStoredProc.Free
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

function TObjectTest.InsertUpdate(dsdParams: TdsdParams): Integer;
begin
  with FdsdStoredProc do begin
    StoredProcName := FspInsertUpdate;
    OutputType := otResult;
    Params.Assign(dsdParams);
    Execute;
    Result := StrToInt(ParamByName('ioId').Value);
  end;
end;

procedure TObjectTest.SetDataSetParam;
begin
  FdsdStoredProc.Params.Clear;
end;

{ TDataBaseObjectTest }
{------------------------------------------------------------------------------}
procedure TdbObjectTest.Cash_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TCashTest;
begin
  ObjectTest := TCashTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка кассы
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о кассе
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('name').AsString = 'Главная касса'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

    // Получим список касс
    Check((GetRecordCount(ObjectTest) = RecordCount + 1), 'Количество записей не изменилось');
  finally
    ObjectTest.Delete(Id);
  end;
end;
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

{ TCashTest }

constructor TCashTest.Create;
begin
  inherited Create;
  spInsertUpdate := 'gpInsertUpdate_Object_Cash';
  spSelect := 'gpSelect_Object_Cash';
  spGet := 'gpGet_Object_Cash';
end;

procedure TCashTest.Delete(Id: Integer);
begin
  inherited;
  with TCurrencyTest.Create do
  try
    Delete(GetDefault)
  finally
    Free;
  end;
  with TBranchTest.Create do
  try
    Delete(GetDefault)
  finally
    Free;
  end;
  with TPaidKindTest.Create do
  try
    Delete(GetDefault)
  finally
    Free;
  end;
end;

function TCashTest.InsertDefault: integer;
var CurrencyId, BranchId, PaidKindId: Integer;
begin
  with TCurrencyTest.Create do
  try
    CurrencyId := GetDefault
  finally
    Free;
  end;
  with TBranchTest.Create do
  try
    BranchId := GetDefault
  finally
    Free;
  end;
  with TPaidKindTest.Create do
  try
    PaidKindId := GetDefault
  finally
    Free;
  end;
  result := InsertUpdateCash(0, 1, 'Главная касса', CurrencyId, BranchId, PaidKindId);
end;

function TCashTest.InsertUpdateCash(const Id, Code: integer; CashName: string;
  CurrencyId, BranchId, PaidKindId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inCashName', ftString, ptInput, CashName);
  FParams.AddParam('inCurrencyId', ftInteger, ptInput, CurrencyId);
  FParams.AddParam('inBranchId', ftInteger, ptInput, BranchId);
  FParams.AddParam('inPaidKindId', ftInteger, ptInput, PaidKindId);
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
  result := InsertUpdateJuridicalGroup(0, 1, 'Группа юр лиц 1', 0);
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
  result := InsertUpdateGoodsProperty(0, 1, 'Классификатор свойств товаров');
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
  result := InsertUpdateRoute(0, 1, 'Маршрут');
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
  result := InsertUpdateRouteSorting(0, 1, 'Сортировка маршрутов');
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

procedure TBankTest.Delete(Id: Integer);
begin
  inherited;
  with TJuridicalTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
end;

function TBankTest.InsertDefault: integer;
var
  JuridicalId: Integer;
begin
  JuridicalId := TJuridicalTest.Create.GetDefault;
  result := InsertUpdateBank(0, 1, 'Банк', 'МФО', JuridicalId)
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

procedure TPartnerTest.Delete(Id: Integer);
begin
  inherited;
  with TJuridicalTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
  with TRouteTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
  with TRouteSortingTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
end;

function TPartnerTest.InsertDefault: integer;
var
  JuridicalId, RouteId, RouteSortingId: Integer;
begin
  JuridicalId := TJuridicalTest.Create.GetDefault;
  RouteId := TRouteTest.Create.GetDefault;
  RouteSortingId := TRouteSortingTest.Create.GetDefault;
  result := InsertUpdatePartner(0, 1, 'Контрагенты', 'GLNCode', JuridicalId, RouteId, RouteSortingId);
end;

function TPartnerTest.InsertUpdatePartner;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inGLNCode', ftString, ptInput, GLNCode);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inRouteId', ftInteger, ptInput, RouteId);
  FParams.AddParam('inRouteSortingId', ftInteger, ptInput, RouteSortingId);
  result := InsertUpdate(FParams);
end;

    { TJuridicalTest }
 constructor TJuridicalTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Juridical';
  spSelect := 'gpSelect_Object_Juridical';
  spGet := 'gpGet_Object_Juridical';
end;

procedure TJuridicalTest.Delete(Id: Integer);
begin
  inherited;
  with TJuridicalGroupTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
  with TGoodsPropertyTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
end;

function TJuridicalTest.InsertDefault: integer;
var
  JuridicalGroupId, GoodsPropertyId: Integer;
begin
  JuridicalGroupId := TJuridicalGroupTest.Create.GetDefault;
  GoodsPropertyId := TGoodsPropertyTest.Create.GetDefault;
  result := InsertUpdateJuridical(0, 1, 'Юр. лицо', 'GLNCode', true, JuridicalGroupId, GoodsPropertyId)
end;

function TJuridicalTest.InsertUpdateJuridical;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inGLNCode', ftString, ptInput, GLNCode);
  FParams.AddParam('isCorporate', ftBoolean, ptInput, isCorporate);
  FParams.AddParam('inJuridicalGroupId', ftInteger, ptInput, JuridicalGroupId);
  FParams.AddParam('inGoodsPropertyId', ftInteger, ptInput, GoodsPropertyId);
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

procedure TdbObjectTest.Juridical_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TJuridicalTest;
begin
  ObjectTest := TJuridicalTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка юр лица
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о юр лице
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('GLNCode').AsString = 'GLNCode'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

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
      Check((FieldByName('Name').AsString = 'Маршрут'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

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
      Check((FieldByName('Name').AsString = 'Сортировка маршрутов'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);

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
  result := InsertUpdateContract(0, '123456', 'comment');
end;

function TContractTest.InsertUpdateContract(const Id: integer; InvNumber,
  Comment: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inInvNumber', ftString, ptInput, InvNumber);
  FParams.AddParam('inComment', ftString, ptInput, Comment);
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
  result := InsertUpdateGoods(0, 1, 'Товар 1', 0, 0, 1.0, 0)
end;

function TGoodsTest.InsertUpdateGoods(Id, Code: Integer; Name: String;
  GoodsGroupId, MeasureId: Integer; Weight: Double; ItemInfoMoneyId: Integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inGoodsGroupId', ftInteger, ptInput, GoodsGroupId);
  FParams.AddParam('inMeasureId', ftInteger, ptInput, MeasureId);
  FParams.AddParam('inWeight', ftFloat, ptInput, Weight);
  FParams.AddParam('inItemInfoMoneyId', ftInteger, ptInput, ItemInfoMoneyId);
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

procedure TGoodsPropertyValueTest.Delete(Id: Integer);
begin
  inherited;
  with TGoodsTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
  with TGoodsPropertyTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
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

{ TUnitTest }

constructor TUnitTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Unit';
  spSelect := 'gpSelect_Object_Unit';
  spGet := 'gpGet_Object_Unit';
end;

procedure TUnitTest.Delete(Id: Integer);
begin
  inherited;
  with TUnitGroupTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
  with TBranchTest.Create do
  try
    Delete(GetDefault);
  finally
    Free;
  end;
end;

function TUnitTest.InsertDefault: integer;
var
  UnitGroupId,BranchId: Integer;
begin
  BranchId := TBranchTest.Create.GetDefault;
  UnitGroupId := TUnitGroupTest.Create.GetDefault;
  result := InsertUpdateUnit(0, 1, 'Подразделение', BranchId, UnitGroupId);
end;

function TUnitTest.InsertUpdateUnit(Id, Code: Integer; Name: String;
  UnitGroupId, BranchId: integer): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inUnitGroupId', ftInteger, ptInput, UnitGroupId);
  FParams.AddParam('inBranchId', ftInteger, ptInput, BranchId);

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
  result := InsertUpdatePriceList(0, 1, 'Прайс-лист');
end;

function TPriceListTest.InsertUpdatePriceList(const Id, Code: Integer;
  Name: string): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
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
  result := InsertUpdatePaidKind(0, 3, 'Вид Формы оплаты');
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
  result := InsertUpdateContractKind(0, 1, 'Вид договора');
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

{TBusinessTest}
constructor TBusinessTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Business';
  spSelect := 'gpSelect_Object_Business';
  spGet := 'gpGet_Object_Business';
end;

function TBusinessTest.InsertDefault: integer;
begin
  result := InsertUpdateBusiness(0, 1, 'Бизнес');
end;

function TBusinessTest.InsertUpdateBusiness;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.Business_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TBusinessTest;
begin
  ObjectTest := TBusinessTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка Бизнеса
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Бизнесе
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Бизнес'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
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

procedure TBranchTest.Delete(Id: Integer);
begin
  inherited;
  with TJuridicalTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;
end;

function TBranchTest.InsertDefault: integer;
var
  JuridicalId: Integer;
begin
  JuridicalId := TJuridicalTest.Create.GetDefault;
  result := InsertUpdateBranch(0, 1, 'Филиал', JuridicalId);
end;

function TBranchTest.InsertUpdateBranch;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
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

  {TUnitGroupTest}
 constructor TUnitGroupTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_UnitGroup';
  spSelect := 'gpSelect_Object_UnitGroup';
  spGet := 'gpGet_Object_UnitGroup';
end;

function TUnitGroupTest.InsertDefault: integer;
var
  ParentId: Integer;
begin
  ParentId:=0;
  result := InsertUpdateUnitGroup(0, 1, 'Группа подразделения', ParentId);
end;

function TUnitGroupTest.InsertUpdateUnitGroup;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inParentId', ftInteger, ptInput, ParentId);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.UnitGroup_Test;
var Id, Id2, Id3: integer;
    RecordCount: Integer;
    ObjectTest: TUnitGroupTest;
begin
 // тут наша задача проверить правильность работы с деревом.
 // а именно зацикливание.
  ObjectTest := TUnitGroupTest.Create;
  // Получим список объектов
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка объекта
 // добавляем группу 1
  Id := ObjectTest.InsertDefault;
  try
    // теперь делаем ссылку на себя и проверяем ошибку
    try
      ObjectTest.InsertUpdateUnitGroup(Id, 1, 'Группа 1', Id);
      Check(false, 'Нет сообщение об ошибке');
    except

    end;
    // добавляем еще группу 2
    // делаем у группы 2 ссылку на группу 1
    Id2 := ObjectTest.InsertUpdateUnitGroup(0, 2, 'Группа 2', Id);
    try
      // теперь ставим ссылку у группы 1 на группу 2 и проверяем ошибку
      try
        ObjectTest.InsertUpdateUnitGroup(Id, 1, 'Группа 1', Id2);
        Check(false, 'Нет сообщение об ошибке');
      except

      end;
      // добавляем еще группу 3
      // делаем у группы 3 ссылку на группу 2
      Id3 := ObjectTest.InsertUpdateUnitGroup(0, 3, 'Группа 3', Id2);
      try
        // группа 2 уже ссылка на группу 1
        // делаем у группы 1 ссылку на группу 3 и проверяем ошибку
        try
          ObjectTest.InsertUpdateUnitGroup(Id, 1, 'Группа 1', Id3);
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


{Unit_Test}
procedure TdbObjectTest.Unit_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TUnitTest;
begin
  ObjectTest := TUnitTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка Подразделения
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Подразделении
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Подразделение'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
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
  result := InsertUpdateGoodsGroup(0, 1, 'Группа товара', ParentId);
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
  result := InsertUpdateGoodsKind(0, 1, 'Вид товара');
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


 {TBankAccountTest}
 constructor TBankAccountTest.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_BankAccount';
  spSelect := 'gpSelect_Object_BankAccount';
  spGet := 'gpGet_Object_BankAccount';
end;

procedure TBankAccountTest.Delete(Id: Integer);
begin
  inherited;
  with TJuridicalTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;
  with TBankTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;
  with TCurrencyTest.Create do
  try
    Delete(GetDefault);
  finally
    Free
  end;
end;

function TBankAccountTest.InsertDefault: integer;
var
  JuridicalId, BankId, CurrencyId: Integer;
begin
  JuridicalId := TJuridicalTest.Create.GetDefault;
  BankId:= TBankTest.Create.GetDefault;
  CurrencyId:= TCurrencyTest.Create.GetDefault;

  result := InsertUpdateBankAccount(0, 1, 'Расчетный счет', JuridicalId, BankId, CurrencyId);
end;

function TBankAccountTest.InsertUpdateBankAccount;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inName', ftString, ptInput, Name);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inBankId', ftInteger, ptInput, BankId);
  FParams.AddParam('inCurrencyId', ftInteger, ptInput, CurrencyId);
  result := InsertUpdate(FParams);
end;

procedure TdbObjectTest.BankAccount_Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TBankAccountTest;
begin
  ObjectTest := TBankAccountTest.Create;
  // Получим список
  RecordCount := GetRecordCount(ObjectTest);
  // Вставка Филиала
  Id := ObjectTest.InsertDefault;
  try
    // Получение данных о Филиале
    with ObjectTest.GetRecord(Id) do
      Check((FieldByName('Name').AsString = 'Расчетный счет'), 'Не сходятся данные Id = ' + FieldByName('id').AsString);
  finally
    ObjectTest.Delete(Id);
  end;
end;

initialization
  TestFramework.RegisterTest('Справочники', TdbObjectTest.Suite);

end.
ё