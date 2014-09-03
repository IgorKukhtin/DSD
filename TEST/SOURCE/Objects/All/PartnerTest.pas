unit PartnerTest;

interface
uses dbTest, dbObjectTest, TestFramework, ObjectTest;

type
  TPartnerTest = class (TdbObjectTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TPartner = class(TObjectTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdatePartner(const Id: integer; Code: Integer;
        Address, ShortName, GLNCode: string;
        HouseNumber, CaseNumber, RoomNumber: string;
        StreetId:Integer;
        PrepareDayCount, DocumentDayCount: Double;
        JuridicalId, RouteId, RouteSortingId, PersonalTakeId, PriceListId, PriceListPromoId: integer;
        StartPromo, EndPromo: TDateTime): integer;
    constructor Create; override;
  end;
implementation

uses ZDbcIntfs, SysUtils, Storage, DBClient, XMLDoc, CommonData, Forms,
     UtilConvert, UtilConst, ZLibEx, zLibUtil, JuridicalTest, RouteSortingTest, Data.DB, RouteTest;

     { TPartnerTest }
 constructor TPartner.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Object_Partner';
  spSelect := 'gpSelect_Object_Partner';
  spGet := 'gpGet_Object_Partner';
end;

function TPartner.InsertDefault: integer;
var
  JuridicalId, RouteId, RouteSortingId, PersonalTakeId: Integer;
  PriceListId, PriceListPromoId: Integer;
  StartPromo, EndPromo: TDateTime;
  HouseNumber, CaseNumber, RoomNumber: string;
  StreetId:Integer;
begin
  JuridicalId := TJuridical.Create.GetDefault;
  RouteId := TRoute.Create.GetDefault;
  RouteSortingId := TRouteSorting.Create.GetDefault;
  PersonalTakeId := 0; //TPersonalTest.Create.GetDefault;

  StreetId := 0;
  PriceListId := 0;
  PriceListPromoId := 0;
  StartPromo := Date;
  EndPromo := Date;

  result := InsertUpdatePartner(0, -6, 'Addrress', 'ShortName', 'GLNCode',
     HouseNumber, CaseNumber, RoomNumber, StreetId,
     15, 15,
     JuridicalId, RouteId, RouteSortingId, PersonalTakeId,PriceListId, PriceListPromoId,
     StartPromo, EndPromo);
  inherited;
end;

function TPartner.InsertUpdatePartner(const Id: integer; Code: Integer;
        Address, ShortName, GLNCode: string;
        HouseNumber, CaseNumber, RoomNumber: string;
        StreetId:Integer;
        PrepareDayCount, DocumentDayCount: Double;
        JuridicalId, RouteId, RouteSortingId, PersonalTakeId, PriceListId, PriceListPromoId: integer;
        StartPromo, EndPromo: TDateTime): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, Id);
  FParams.AddParam('inAddress', ftString, ptInput, Address);
  FParams.AddParam('inCode', ftInteger, ptInput, Code);
  FParams.AddParam('inShortName', ftString, ptInput, ShortName);
  FParams.AddParam('inGLNCode', ftString, ptInput, GLNCode);
  FParams.AddParam('inHouseNumber', ftString, ptInput, HouseNumber);
  FParams.AddParam('inCaseNumber', ftString, ptInput, CaseNumber);
  FParams.AddParam('inRoomNumber', ftString, ptInput, RoomNumber);
  FParams.AddParam('inStreetId', ftInteger, ptInput, StreetId);
  FParams.AddParam('inPrepareDayCount', ftFloat, ptInput, PrepareDayCount);
  FParams.AddParam('inDocumentDayCount', ftFloat, ptInput, DocumentDayCount);
  FParams.AddParam('inJuridicalId', ftInteger, ptInput, JuridicalId);
  FParams.AddParam('inRouteId', ftInteger, ptInput, RouteId);
  FParams.AddParam('inRouteSortingId', ftInteger, ptInput, RouteSortingId);
  FParams.AddParam('inPersonalTakeId', ftInteger, ptInput, PersonalTakeId);
  FParams.AddParam('inPriceListId', ftInteger, ptInput, PriceListId);
  FParams.AddParam('inPriceListPromoId', ftInteger, ptInput, PriceListPromoId);
  FParams.AddParam('inStartPromo', ftDateTime, ptInput, StartPromo);
  FParams.AddParam('inEndPromo', ftDateTime, ptInput, EndPromo);
  result := InsertUpdate(FParams);
end;

procedure TPartnerTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'OBJECTS\Partner\';
  inherited;
end;
procedure TPartnerTest.Test;
var Id: integer;
    RecordCount: Integer;
    ObjectTest: TPartner;
begin
  ObjectTest := TPartner.Create;
  // Получим список
  RecordCount := ObjectTest.GetDataSet.RecordCount;
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
initialization
  TestFramework.RegisterTest('Объекты', TPartnerTest.Suite);

end.
