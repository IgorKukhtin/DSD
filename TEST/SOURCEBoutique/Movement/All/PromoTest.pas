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
    function InsertUpdatePromo(ioId: Integer; // ���� ������� <�������� �������>
          inInvNumber:      String     ; // ����� ���������
          inOperDate:       TDateTime  ; // ���� ���������
          inPromoKindId,                 // ��� �����
          inPriceListId:    Integer    ; // ����� ����
          inStartPromo,    // ���� ������ �����
          inEndPromo,      // ���� ��������� �����
          inStartSale,     // ���� ������ �������� �� ��������� ����
          inEndSale,       // ���� ��������� �������� �� ��������� ����
          inOperDateStart, // ���� ������ ����. ������ �� �����
          inOperDateEnd:    TDateTime  ; // ���� ��������� ����. ������ �� �����
          inCostPromo:      Real       ; // ��������� ������� � �����
          inComment:        String     ; // ����������
          inAdvertisingId,   // ��������� ���������
          inUnitId,          // �������������
          inPersonalTradeId, // ������������� ������������� ������������� ������
          inPersonalId:     Integer     // ������������� ������������� �������������� ������
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
var ioId: Integer; // ���� ������� <�������� �������>
    inInvNumber:      String     ; // ����� ���������
    inOperDate:       TDateTime  ; // ���� ���������
    inPromoKindId,                 // ��� �����
    inPriceListId:    Integer    ; // ����� ����
    inStartPromo,    // ���� ������ �����
    inEndPromo,      // ���� ��������� �����
    inStartSale,     // ���� ������ �������� �� ��������� ����
    inEndSale,       // ���� ��������� �������� �� ��������� ����
    inOperDateStart, // ���� ������ ����. ������ �� �����
    inOperDateEnd:    TDateTime  ; // ���� ��������� ����. ������ �� �����
    inCostPromo:      Real       ; // ��������� ������� � �����
    inComment:        String     ; // ����������
    inAdvertisingId,   // ��������� ���������
    inUnitId,          // �������������
    inPersonalTradeId, // ������������� ������������� ������������� ������
    inPersonalId:     Integer;     // ������������� ������������� �������������� ������
begin
  ioId := 0;                      // ���� ������� <�������� �������>
  inInvNumber := '';              // ����� ���������
  inOperDate := Date;             // ���� ���������
  inPromoKindId := TPromoKind.Create.GetDefault;     // ��� �����
  inPriceListId := TPriceList.Create.GetDefault;     // ����� ����
  inStartPromo := Date;           // ���� ������ �����
  inEndPromo := Date+7;           // ���� ��������� �����
  inStartSale := Date;            // ���� ������ �������� �� ��������� ����
  inEndSale := Date + 7;          // ���� ��������� �������� �� ��������� ����
  inOperDateStart := Date - 30;   // ���� ������ ����. ������ �� �����
  inOperDateEnd := Date - 20;     // ���� ��������� ����. ������ �� �����
  inCostPromo := 100;             // ��������� ������� � �����
  inComment := 'Test Promo';      // ����������
  inAdvertisingId := TAdvertising.Create.GetDefault;// ��������� ���������
  inUnitId := TUnit.Create.GetDefault;              // �������������
  inPersonalTradeId := TPersonal.Create.GetDefault; // ������������� ������������� ������������� ������
  inPersonalId := inPersonalTradeId;                // ������������� ������������� �������������� ������);
  //
  result := InsertUpdatePromo(ioId, // ���� ������� <�������� �������>
          inInvNumber,       // ����� ���������
          inOperDate,        // ���� ���������
          inPromoKindId,     // ��� �����
          inPriceListId,     // ����� ����
          inStartPromo,      // ���� ������ �����
          inEndPromo,        // ���� ��������� �����
          inStartSale,       // ���� ������ �������� �� ��������� ����
          inEndSale,         // ���� ��������� �������� �� ��������� ����
          inOperDateStart,   // ���� ������ ����. ������ �� �����
          inOperDateEnd,     // ���� ��������� ����. ������ �� �����
          inCostPromo,       // ��������� ������� � �����
          inComment,         // ����������
          inAdvertisingId,   // ��������� ���������
          inUnitId,          // �������������
          inPersonalTradeId, // ������������� ������������� ������������� ������
          inPersonalId)      // ������������� ������������� �������������� ������
end;

function TPromo.InsertUpdatePromo(ioId: Integer; // ���� ������� <�������� �������>
          inInvNumber:      String     ; // ����� ���������
          inOperDate:       TDateTime  ; // ���� ���������
          inPromoKindId,                 // ��� �����
          inPriceListId:    Integer    ; // ����� ����
          inStartPromo,    // ���� ������ �����
          inEndPromo,      // ���� ��������� �����
          inStartSale,     // ���� ������ �������� �� ��������� ����
          inEndSale,       // ���� ��������� �������� �� ��������� ����
          inOperDateStart, // ���� ������ ����. ������ �� �����
          inOperDateEnd:    TDateTime  ; // ���� ��������� ����. ������ �� �����
          inCostPromo:      Real       ; // ��������� ������� � �����
          inComment:        String     ; // ����������
          inAdvertisingId,   // ��������� ���������
          inUnitId,          // �������������
          inPersonalTradeId, // ������������� ������������� ������������� ������
          inPersonalId:     Integer     // ������������� ������������� �������������� ������
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
  // ������� ��������
  MovementPromo := TPromo.Create;
  Id := MovementPromo.InsertDefault;
  // �������� ���������
  try
  // ��������������
  finally
    MovementPromo.Delete(Id);
  end;
end;

initialization

  TestFramework.RegisterTest('���������', TPromoTest.Suite);

end.
