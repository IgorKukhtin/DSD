unit dbProcedurePodiumTest;

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
    procedure CreatePriceListItem;
    procedure CreateDiscountPeriodItem;
  end;

type
  TdbReportProcedureTest = class(TdbTest)
  published
    procedure CreateReportProcedure;
  end;
type
  TdbMovementProcedureTest = class(TdbTest)
  published
    procedure CreateCOMMON;
    procedure CreateIncome;
    procedure CreateReturnOut;
    procedure CreateSale;
    procedure CreateReturnIn;
    procedure CreateSend;
    procedure CreateLoss;
    procedure CreateCurrency;
    procedure CreateInventory;
    procedure CreateGoodsAccount;
  end;

type
  TdbMovementItemProcedureTest = class(TdbTest)
  published
    procedure CreateCOMMON;
    procedure CreateIncome;
    procedure CreateReturnOut;
    procedure CreateSale;
    procedure CreateReturnIn;
    procedure CreateSend;
    procedure CreateLoss;
    procedure CreateInventory;
    procedure CreateGoodsAccount;
  end;

type
  TdbMovementItemContainerProcedureTest = class(TdbTest)
  published
    procedure CreateCOMMON;
    procedure CreateIncome;
    procedure CreateReturnOut;
    procedure CreateSale;
    procedure CreateReturnIn;
    procedure CreateSend;
    procedure CreateLoss;
    procedure CreateCurrency;
    procedure CreateInventory;
    procedure CreateGoodsAccount;
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
    procedure CreateDiscountPeriod;
    procedure CreateDiscountPeriodItem;
    procedure CreateFabrika;
    procedure CreateGoodsInfo;
    procedure CreateGoodsSize;
    procedure CreateGoodsGroup;
    procedure CreateGoods;
    procedure CreateGoodsItem;
    procedure CreateGoodsPrint;
    procedure CreateImportSettings;
    procedure CreateImportSettingsItems;
    procedure CreateInfoMoney;
    procedure CreateInfoMoneyDestination;
    procedure CreateInfoMoneyGroup;
    procedure CreateJuridicalGroup;
    procedure CreateJuridical;
    procedure CreateCash;
    procedure CreateLabel;
    procedure CreateLineFabrica;
    procedure CreateMeasure;
    procedure CreateMember;
    procedure CreatePeriod;
    procedure CreatePartner;
    procedure CreatePartionGoods;
    procedure CreatePartionMI;
    procedure CreatePosition;
    procedure CreatePriceList;
    procedure CreateProfitLoss;
    procedure CreatePersonal;
    procedure CreateStatus;
    procedure CreateUnit;
    procedure CreateBank;
    procedure CreateBankAccount;

  end;

implementation

uses zLibUtil;

const

  CommonProcedurePath = '..\DATABASE\Boutique\PROCEDURE\';
  ReportsPath = '..\DATABASE\Boutique\REPORTS\';
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
procedure TdbObjectHistoryProcedureTest.CreatePriceListItem;
begin
  DirectoryLoad(CommonProcedurePath + 'ObjectHistory\PriceListItem\');
end;

procedure TdbObjectHistoryProcedureTest.CreateDiscountPeriodItem;
begin
  DirectoryLoad(CommonProcedurePath + 'ObjectHistory\DiscountPeriodItem\');
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

procedure TdbMovementProcedureTest.CreateReturnOut;
begin
  DirectoryLoad(CommonProcedurePath + 'Movement\ReturnOut\');
end;
procedure TdbMovementProcedureTest.CreateReturnIn;
begin
  DirectoryLoad(CommonProcedurePath + 'Movement\ReturnIn\');
end;
procedure TdbMovementProcedureTest.CreateSale;
begin
  DirectoryLoad(CommonProcedurePath + 'Movement\Sale\');
end;
procedure TdbMovementProcedureTest.CreateSend;
begin
  DirectoryLoad(CommonProcedurePath + 'Movement\Send\');
end;
procedure TdbMovementProcedureTest.CreateLoss;
begin
  DirectoryLoad(CommonProcedurePath + 'Movement\Loss\');
end;
procedure TdbMovementProcedureTest.CreateCurrency;
begin
  DirectoryLoad(CommonProcedurePath + 'Movement\Currency\');
end;
procedure TdbMovementProcedureTest.CreateInventory;
begin
  DirectoryLoad(CommonProcedurePath + 'Movement\Inventory\');
end;

procedure TdbMovementProcedureTest.CreateGoodsAccount;
begin
  DirectoryLoad(CommonProcedurePath + 'Movement\GoodsAccount\');
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

procedure TdbObjectProcedureTest.CreateBank;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\Bank\');
end;

procedure TdbObjectProcedureTest.CreateBankAccount;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\BankAccount\');
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

procedure TdbObjectProcedureTest.CreateDiscountPeriod;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\DiscountPeriod\');
end;
procedure TdbObjectProcedureTest.CreateDiscountPeriodItem;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\DiscountPeriodItem\');
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
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\GoodsItem - !!!\');
end;

 procedure TdbObjectProcedureTest.CreateGoodsPrint;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\GoodsPrint - !!!\');
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

procedure TdbObjectProcedureTest.CreateCash;
begin
   DirectoryLoad(CommonProcedurePath + 'OBJECTS\Cash\');
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
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\PartionGoods - !!!\');
end;

procedure TdbObjectProcedureTest.CreatePartionMI;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\PartionMI\');
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

procedure TdbObjectProcedureTest.CreatePriceList;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\PriceList\');
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\PriceListItem\');
end;

procedure TdbObjectProcedureTest.CreateProfitLoss;
begin
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\ProfitLoss\');
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\ProfitLossDirection\');
  DirectoryLoad(CommonProcedurePath + 'OBJECTS\ProfitLossGroup\');
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

procedure TdbMovementItemProcedureTest.CreateReturnOut;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItem\ReturnOut\');
end;
procedure TdbMovementItemProcedureTest.CreateReturnIn;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItem\ReturnIn\');
end;

procedure TdbMovementItemProcedureTest.CreateSale;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItem\Sale\');
end;
procedure TdbMovementItemProcedureTest.CreateSend;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItem\Send\');
end;
procedure TdbMovementItemProcedureTest.CreateLoss;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItem\Loss\');
end;
procedure TdbMovementItemProcedureTest.CreateInventory;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItem\Inventory\');
end;

procedure TdbMovementItemProcedureTest.CreateGoodsAccount;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItem\GoodsAccount\');
end;
{ TdbMovementItemContainerProcedureTest }

procedure TdbMovementItemContainerProcedureTest.CreateCOMMON;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItemContainer\_COMMON\');
end;
procedure TdbMovementItemContainerProcedureTest.CreateIncome;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItemContainer\Income\');
end;

procedure TdbMovementItemContainerProcedureTest.CreateReturnOut;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItemContainer\ReturnOut\');
end;
procedure TdbMovementItemContainerProcedureTest.CreateReturnIn;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItemContainer\ReturnIn\');
end;

procedure TdbMovementItemContainerProcedureTest.CreateSend;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItemContainer\Send\');
end;
procedure TdbMovementItemContainerProcedureTest.CreateLoss;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItemContainer\Loss\');
end;

procedure TdbMovementItemContainerProcedureTest.CreateCurrency;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItemContainer\Currency\');
end;
procedure TdbMovementItemContainerProcedureTest.CreateInventory;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItemContainer\Inventory\');
end;
procedure TdbMovementItemContainerProcedureTest.CreateSale;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItemContainer\Sale\');
end;

procedure TdbMovementItemContainerProcedureTest.CreateGoodsAccount;
begin
  DirectoryLoad(CommonProcedurePath + 'MovementItemContainer\GoodsAccount\');
end;

procedure TdbReportProcedureTest.CreateReportProcedure;
begin
  DirectoryLoad(ReportsPath);
end;

initialization

TestFramework.RegisterTest('Процедуры', TdbProcedureTest.Suite);
TestFramework.RegisterTest('Процедуры', TdbObjectHistoryProcedureTest.Suite);
TestFramework.RegisterTest('Процедуры', TdbMovementProcedureTest.Suite);
TestFramework.RegisterTest('Процедуры', TdbMovementItemProcedureTest.Suite);
TestFramework.RegisterTest('Процедуры', TdbMovementItemContainerProcedureTest.Suite);
TestFramework.RegisterTest('Процедуры', TdbObjectProcedureTest.Suite);
TestFramework.RegisterTest('Процедуры', TdbReportProcedureTest.Suite);

end.
