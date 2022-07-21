unit Inventory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  dxBarBuiltInMenu, cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, cxNavigator, Data.DB, cxDBData, cxCurrencyEdit, cxContainer,
  Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ExternalLoad, dsdAction,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, Vcl.ActnList, cxPropertiesStore, cxButtonEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCheckBox,
  cxImageComboBox, cxSplitter;

type
  TInventoryForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    colPrice: TcxGridDBColumn;
    colSumm: TcxGridDBColumn;
    actUnitChoice: TOpenChoiceForm;
    actStorageChoice: TOpenChoiceForm;
    actAssetChoice: TOpenChoiceForm;
    spInsertUpdateMIAmount: TdsdStoredProc;
    actInsertUpdateMIAmount: TdsdExecStoredProc;
    bbInsertUpdateMIAmount: TdxBarButton;
    bbPrint1: TdxBarButton;
    spGetImportSettingId: TdsdStoredProc;
    actStartLoad: TMultiAction;
    actGetImportSettingId: TdsdExecStoredProc;
    actDoLoad: TExecuteImportSettingsAction;
    dxBarButton1: TdxBarButton;
    spInsertUpdate_MovementItem_Inventory_Set_Zero: TdsdStoredProc;
    actInsertUpdate_MovementItem_Inventory_Set_Zero: TdsdExecStoredProc;
    colRemains_Amount: TcxGridDBColumn;
    colDeficit: TcxGridDBColumn;
    colDeficitSumm: TcxGridDBColumn;
    colProicit: TcxGridDBColumn;
    colProicitSumm: TcxGridDBColumn;
    colDiff: TcxGridDBColumn;
    colDiffSumm: TcxGridDBColumn;
    colMIComment: TcxGridDBColumn;
    chbFullInvent: TcxCheckBox;
    actSelect: TdsdExecStoredProc;
    clisAuto: TcxGridDBColumn;
    actOpenInventoryPartionForm: TdsdOpenForm;
    bbInventoryPartion: TdxBarButton;
    Diff_calc: TcxGridDBColumn;
    DiffSumm_calc: TcxGridDBColumn;
    Diff_diff: TcxGridDBColumn;
    DiffSumm_diff: TcxGridDBColumn;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    spSelect_MI_Child: TdsdStoredProc;
    dsdDBViewAddOnChild: TdsdDBViewAddOn;
    colCountUser: TcxGridDBColumn;
    actRefreshChild: TdsdDataSetRefresh;
    bb: TdxBarButton;
    Num: TcxGridDBColumn;
    isLast: TcxGridDBColumn;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    spSelectBarCode: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    cxSplitter1: TcxSplitter;
    spInsert_MI_Inventory: TdsdStoredProc;
    Panel1: TPanel;
    edBarCode: TcxTextEdit;
    dsdEnterManager: TdsdEnterManager;
    ceAmount: TcxCurrencyEdit;
    actBarCodeScan: TMultiAction;
    actSpBarCodeScan: TdsdExecStoredProc;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    ceAmountAdd: TcxCurrencyEdit;
    cxLabel6: TcxLabel;
    edGoodsCode: TcxTextEdit;
    cxLabel7: TcxLabel;
    edGoodsName: TcxTextEdit;
    Remains_Save: TcxGridDBColumn;
    Remains_SumSave: TcxGridDBColumn;
    spPUSHInfo: TdsdStoredProc;
    actPUSHInfo: TdsdShowPUSHMessage;
    edComment: TcxTextEdit;
    cxLabel8: TcxLabel;
    spPUSHCompile: TdsdStoredProc;
    actPUSHCompile: TdsdShowPUSHMessage;
    actShowDeviated: TBooleanStoredProcAction;
    dxBarButton2: TdxBarButton;
    actOpenInventoryHouseholdInventory: TMultiAction;
    bbOpenInventoryHouseholdInventory: TdxBarButton;
    actExecGetInventoryHouseholdInventoryID: TdsdExecStoredProc;
    actOFInventoryHouseholdInventory: TdsdOpenForm;
    spGetInventoryHouseholdInventoryID: TdsdStoredProc;
    actPUSHInventBarcode: TdsdShowPUSHMessage;
    spPUSHInventBarcode: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TInventoryForm);

end.
