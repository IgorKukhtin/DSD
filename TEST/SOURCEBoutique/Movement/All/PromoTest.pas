unit PromoTest;

interface

uses dbTest, dbMovementTest, ObjectTest;

type
  TPromoTest = class (TdbMovementTestNew)
  published
    procedure ProcedureLoad; override;
    procedure Test; override;
  end;

  TPromo = class(TMovementTest)
  private
    function InsertDefault: integer; override;
  public
    function InsertUpdatePromo(ioId: Integer; // Ключ объекта <Документ продажи>
          inInvNumber:      String     ; // Номер документа
          inOperDate:       TDateTime  ; // Дата документа
          inPromoKindId,                 // Вид акции
          inPriceListId:    Integer    ; // Прайс лист
          inStartPromo,    // Дата начала акции
          inEndPromo,      // Дата окончания акции
          inStartSale,     // Дата начала отгрузки по акционной цене
          inEndSale,       // Дата окончания отгрузки по акционной цене
          inOperDateStart, // Дата начала расч. продаж до акции
          inOperDateEnd:    TDateTime  ; // Дата окончания расч. продаж до акции
          inCostPromo:      Real       ; // Стоимость участия в акции
          inComment:        String     ; // Примечание
          inAdvertisingId,   // Рекламная поддержка
          inUnitId,          // Подразделение
          inPersonalTradeId, // Ответственный представитель коммерческого отдела
          inPersonalId:     Integer     // Ответственный представитель маркетингового отдела
           ): integer;
    constructor Create; override;
  end;

implementation

uses UtilConst, dbObjectMeatTest, dbObjectTest,
     SysUtils, Db, TestFramework, PromoKindTest, PriceListTest,
     AdvertisingTest, UnitsTest, PersonalTest ;

{ TPromo }

constructor TPromo.Create;
begin
  inherited;
  spInsertUpdate := 'gpInsertUpdate_Movement_Promo';
  spSelect := 'gpSelect_Movement_Promo';
  spGet := 'gpGet_Movement_Promo';
end;

function TPromo.InsertDefault: integer;
var ioId: Integer; // Ключ объекта <Документ продажи>
    inInvNumber:      String     ; // Номер документа
    inOperDate:       TDateTime  ; // Дата документа
    inPromoKindId,                 // Вид акции
    inPriceListId:    Integer    ; // Прайс лист
    inStartPromo,    // Дата начала акции
    inEndPromo,      // Дата окончания акции
    inStartSale,     // Дата начала отгрузки по акционной цене
    inEndSale,       // Дата окончания отгрузки по акционной цене
    inOperDateStart, // Дата начала расч. продаж до акции
    inOperDateEnd:    TDateTime  ; // Дата окончания расч. продаж до акции
    inCostPromo:      Real       ; // Стоимость участия в акции
    inComment:        String     ; // Примечание
    inAdvertisingId,   // Рекламная поддержка
    inUnitId,          // Подразделение
    inPersonalTradeId, // Ответственный представитель коммерческого отдела
    inPersonalId:     Integer;     // Ответственный представитель маркетингового отдела
begin
  ioId := 0;                      // Ключ объекта <Документ продажи>
  inInvNumber := '';              // Номер документа
  inOperDate := Date;             // Дата документа
  inPromoKindId := TPromoKind.Create.GetDefault;     // Вид акции
  inPriceListId := TPriceList.Create.GetDefault;     // Прайс лист
  inStartPromo := Date;           // Дата начала акции
  inEndPromo := Date+7;           // Дата окончания акции
  inStartSale := Date;            // Дата начала отгрузки по акционной цене
  inEndSale := Date + 7;          // Дата окончания отгрузки по акционной цене
  inOperDateStart := Date - 30;   // Дата начала расч. продаж до акции
  inOperDateEnd := Date - 20;     // Дата окончания расч. продаж до акции
  inCostPromo := 100;             // Стоимость участия в акции
  inComment := 'Test Promo';      // Примечание
  inAdvertisingId := TAdvertising.Create.GetDefault;// Рекламная поддержка
  inUnitId := TUnit.Create.GetDefault;              // Подразделение
  inPersonalTradeId := TPersonal.Create.GetDefault; // Ответственный представитель коммерческого отдела
  inPersonalId := inPersonalTradeId;                // Ответственный представитель маркетингового отдела);
  //
  result := InsertUpdatePromo(ioId, // Ключ объекта <Документ продажи>
          inInvNumber,       // Номер документа
          inOperDate,        // Дата документа
          inPromoKindId,     // Вид акции
          inPriceListId,     // Прайс лист
          inStartPromo,      // Дата начала акции
          inEndPromo,        // Дата окончания акции
          inStartSale,       // Дата начала отгрузки по акционной цене
          inEndSale,         // Дата окончания отгрузки по акционной цене
          inOperDateStart,   // Дата начала расч. продаж до акции
          inOperDateEnd,     // Дата окончания расч. продаж до акции
          inCostPromo,       // Стоимость участия в акции
          inComment,         // Примечание
          inAdvertisingId,   // Рекламная поддержка
          inUnitId,          // Подразделение
          inPersonalTradeId, // Ответственный представитель коммерческого отдела
          inPersonalId)      // Ответственный представитель маркетингового отдела
end;

function TPromo.InsertUpdatePromo(ioId: Integer; // Ключ объекта <Документ продажи>
          inInvNumber:      String     ; // Номер документа
          inOperDate:       TDateTime  ; // Дата документа
          inPromoKindId,                 // Вид акции
          inPriceListId:    Integer    ; // Прайс лист
          inStartPromo,    // Дата начала акции
          inEndPromo,      // Дата окончания акции
          inStartSale,     // Дата начала отгрузки по акционной цене
          inEndSale,       // Дата окончания отгрузки по акционной цене
          inOperDateStart, // Дата начала расч. продаж до акции
          inOperDateEnd:    TDateTime  ; // Дата окончания расч. продаж до акции
          inCostPromo:      Real       ; // Стоимость участия в акции
          inComment:        String     ; // Примечание
          inAdvertisingId,   // Рекламная поддержка
          inUnitId,          // Подразделение
          inPersonalTradeId, // Ответственный представитель коммерческого отдела
          inPersonalId:     Integer     // Ответственный представитель маркетингового отдела
             ): integer;
begin
  FParams.Clear;
  FParams.AddParam('ioId', ftInteger, ptInputOutput, ioId);
  FParams.AddParam('inInvNumber', ftString, ptInput, inInvNumber);
  FParams.AddParam('inOperDate', ftDateTime, ptInput, inOperDate);
  FParams.AddParam('inPromoKindId', ftInteger, ptInput, inPromoKindId);
  FParams.AddParam('inPriceListId', ftInteger, ptInput, inPriceListId);

  FParams.AddParam('inStartPromo', ftDateTime, ptInput, inStartPromo);
  FParams.AddParam('inEndPromo', ftDateTime, ptInput, inEndPromo);
  FParams.AddParam('inStartSale', ftDateTime, ptInput, inStartSale);
  FParams.AddParam('inEndSale', ftDateTime, ptInput, inEndSale);
  FParams.AddParam('inOperDateStart', ftDateTime, ptInput, inOperDateStart);
  FParams.AddParam('inOperDateEnd', ftDateTime, ptInput, inOperDateEnd);

  FParams.AddParam('inCostPromo', ftFloat, ptInput, inCostPromo);
  FParams.AddParam('inComment', ftString, ptInput, inComment);

  FParams.AddParam('inAdvertisingId', ftInteger, ptInput, inAdvertisingId);
  FParams.AddParam('inUnitId', ftInteger, ptInput, inUnitId);
  FParams.AddParam('inPersonalTradeId', ftInteger, ptInput, inPersonalTradeId);
  FParams.AddParam('inPersonalId', ftInteger, ptInput, inPersonalId);

  result := InsertUpdate(FParams);
end;

{ TPromoTest }

procedure TPromoTest.ProcedureLoad;
begin
  ScriptDirectory := ProcedurePath + 'Movement\Promo\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItem\Promo\';
  inherited;
  ScriptDirectory := ProcedurePath + 'MovementItemContainer\Promo\';
  inherited;
end;

procedure TPromoTest.Test;
var MovementPromo: TPromo;
    Id: Integer;
begin
  inherited;
  // Создаем документ
  MovementPromo := TPromo.Create;
  Id := MovementPromo.InsertDefault;
  // создание документа
  try
  // редактирование
  finally
    MovementPromo.Delete(Id);
  end;
end;

initialization

  TestFramework.RegisterTest('Документы', TPromoTest.Suite);

end.
