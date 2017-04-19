unit dbBoutiqueProcedureTest;

interface

uses TestFramework, ZConnection, ZDataset, dbTest;

type
  TdbProcedureTest = class(TdbTest)
  published
    procedure CreateDefault;
    procedure CreateProtocol;
    procedure CreateObjectTools;
    procedure CreareSystem;
  end;

type
  TdbObjectHistoryProcedureTest = class(TdbTest)
  published
    procedure CreateCOMMON;
  end;

type
  TdbMovementProcedureTest = class(TdbTest)
  published
    procedure CreateCOMMON;
    procedure CreateIncome;
  end;

type
  TdbMovementItemProcedureTest = class(TdbTest)
  published
    procedure CreateCOMMON;
    procedure CreateIncome;
  end;

type
  TdbMovementItemContainerProcedureTest = class(TdbTest)
  published
    procedure CreateCOMMON;
  end;

type
  TdbObjectProcedureTest = class(TdbTest)
  published
    procedure CreateCOMMON;
    procedure CreateAccount;
    procedure CreateAccountDirection;
    procedure CreateAccountGroup;
    procedure CreateAccountKind;
    procedure CreateBrand;
    procedure CreateCompositionGroup;
    procedure CreateComposition;
    procedure CreateCountryBrand;
    procedure CreateCurrency;
    procedure CreateCity;
    procedure CreateClient;
    procedure CreateDiscountKind;
    procedure CreateDiscount;
    procedure CreateDiscountTools;
    procedure CreateFabrika;
    procedure CreateGoodsInfo;
    procedure CreateGoodsSize;
    procedure CreateGoodsGroup;
    procedure CreateGoods;
    procedure CreateGoodsItem;
    procedure CreateImportSettings;
    procedure CreateImportSettingsItems;
    procedure CreateInfoMoney;
    procedure CreateInfoMoneyDestination;
    procedure CreateInfoMoneyGroup;
    procedure CreateJuridicalGroup;
    procedure CreateJuridical;
    procedure CreateKassa;
    procedure CreateLabel;
    procedure CreateLineFabrica;
    procedure CreateMeasure;
    procedure CreateMember;
    procedure CreatePeriod;
    procedure CreatePartner;
    procedure CreatePartionGoods;
    procedure CreatePosition;
    procedure CreatePersonal;
    procedure CreateStatus;
    procedure CreateUnit;

  end;

implementation

uses zLibUtil;

const

  CommonProcedurePath = '..\DATABASE\Boutique\PROCEDURE\';

  { TdbProcedureTest }

procedure TdbProcedureTest.CreareSystem;
begin
 DirectoryLoad(CommonProcedurePath + 'System\');
end;

procedure TdbProcedureTest.CreateDefault;
begin
  DirectoryLoad(CommonProcedurePath + 'Default\');
end;



procedure TdbProcedureTest.CreateProtocol;
begin
  DirectoryLoad(CommonProcedurePath + 'Protocol\');
end;


procedure TdbProcedureTest.CreateObjectTools;
begin
  DirectoryLoad(CommonProcedurePath + 'ObjectsTools\');
end;

{ TdbObjectHistoryProcedureTest }
procedure TdbObjectHistoryProcedureTest.CreateCOMMON;
begin
  DirectoryLoad(CommonProcedurePath + 'ObjectHistory\_COMMON\');
end;

{ TdbMovementProcedureTest }
procedure TdbMovementProcedureTest.CreateCOMMON;
begin
  DirectoryLoad(CommonProcedurePath + 'Movement\_COMMON\');
end;


procedure TdbMovementProcedureTest.CreateIncome;
begin
  DirectoryLoad(CommonProcedurePath + 'Movement\Income\');
end;

{ TdbObjectProcedureTest }
procedure TdbObjectProcedureTest.CreateAccountDirection;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\AccountDirection\');
end;

procedure TdbObjectProcedureTest.CreateAccountGroup;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\AccountGroup\');
end;

procedure TdbObjectProcedureTest.CreateAccountKind;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\AccountKind\');
end;

procedure TdbObjectProcedureTest.CreateBrand;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\Brand\');
end;

procedure TdbObjectProcedureTest.CreateAccount;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\Account\');
end;

procedure TdbObjectProcedureTest.CreateCity;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\City\');
end;

procedure TdbObjectProcedureTest.CreateClient;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\Client\');
end;

procedure TdbObjectProcedureTest.CreateCOMMON;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\_COMMON\');
end;

procedure TdbObjectProcedureTest.CreateComposition;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\Composition\');
end;

procedure TdbObjectProcedureTest.CreateCompositionGroup;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\CompositionGroup\');
end;

procedure TdbObjectProcedureTest.CreateCountryBrand;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\CountryBrand\');
end;

procedure TdbObjectProcedureTest.CreateDiscount;
begin
 DirectoryLoad(CommonProcedurePath + 'OBJECTS\Discount\');
end;

procedure TdbObjectProcedureTest.CreateDiscountKind;
begin
   DirectoryLoad(CommonProcedurePath + 'OBJECTS\DiscountKind\');
end;

procedure TdbObjectProcedureTest.CreateDiscountTools;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\DiscountTools\');
end;

procedure TdbObjectProcedureTest.CreateFabrika;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\Fabrika\');
end;

procedure TdbObjectProcedureTest.CreateGoods;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\Goods\');
end;

procedure TdbObjectProcedureTest.CreateGoodsGroup;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\GoodsGroup\');
end;

procedure TdbObjectProcedureTest.CreateGoodsInfo;
begin
 DirectoryLoad(CommonProcedurePath + 'OBJECTS\GoodsInfo\');
end;

procedure TdbObjectProcedureTest.CreateGoodsItem;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\GoodsItem\');
end;

procedure TdbObjectProcedureTest.CreateGoodsSize;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\GoodsSize\');
end;

procedure TdbObjectProcedureTest.CreateImportSettingsItems;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\ImportSettingsItems\');
end;

procedure TdbObjectProcedureTest.CreateInfoMoney;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\InfoMoney\');
end;

procedure TdbObjectProcedureTest.CreateInfoMoneyDestination;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\InfoMoneyDestination\');
end;

procedure TdbObjectProcedureTest.CreateInfoMoneyGroup;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\InfoMoneyGroup\');
end;

procedure TdbObjectProcedureTest.CreateJuridical;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\Juridical\');
end;

procedure TdbObjectProcedureTest.CreateJuridicalGroup;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\JuridicalGroup\');
end;

procedure TdbObjectProcedureTest.CreateKassa;
begin
   DirectoryLoad(CommonProcedurePath + 'OBJECTS\Kassa\');
end;

procedure TdbObjectProcedureTest.CreateLabel;
begin
   DirectoryLoad(CommonProcedurePath + 'OBJECTS\Label\');
end;

procedure TdbObjectProcedureTest.CreateLineFabrica;
begin
   DirectoryLoad(CommonProcedurePath + 'OBJECTS\LineFabrica\');
end;

procedure TdbObjectProcedureTest.CreateMeasure;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\Measure\');
end;

procedure TdbObjectProcedureTest.CreateMember;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\Member\');
end;

procedure TdbObjectProcedureTest.CreatePartionGoods;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\PartionGoods\');
end;

procedure TdbObjectProcedureTest.CreatePartner;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\Partner\');
end;

procedure TdbObjectProcedureTest.CreatePeriod;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\Period\');
end;

procedure TdbObjectProcedureTest.CreatePersonal;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\Personal\');
end;

procedure TdbObjectProcedureTest.CreatePosition;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\Position\');
end;

procedure TdbObjectProcedureTest.CreateStatus;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\Status\');
end;

procedure TdbObjectProcedureTest.CreateUnit;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\Unit\');
end;

procedure TdbObjectProcedureTest.CreateCurrency;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\Currency\');
end;

procedure TdbObjectProcedureTest.CreateImportSettings;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\ImportSettings\');
end;

{ TdbMovementItemProcedureTest }

procedure TdbMovementItemProcedureTest.CreateCOMMON;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItem\_COMMON\');
end;

procedure TdbMovementItemProcedureTest.CreateIncome;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItem\Income\');
end;
{ TdbMovementItemContainerProcedureTest }

procedure TdbMovementItemContainerProcedureTest.CreateCOMMON;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItemContainer\_COMMON\');
end;

initialization

TestFramework.RegisterTest('Процедуры', TdbProcedureTest.Suite);
TestFramework.RegisterTest('Процедуры', TdbObjectHistoryProcedureTest.Suite);
TestFramework.RegisterTest('Процедуры', TdbMovementProcedureTest.Suite);
TestFramework.RegisterTest('Процедуры', TdbMovementItemProcedureTest.Suite);
TestFramework.RegisterTest('Процедуры', TdbMovementItemContainerProcedureTest.Suite);
TestFramework.RegisterTest('Процедуры', TdbObjectProcedureTest.Suite);

end.
