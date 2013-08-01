unit Sale;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ParentForm, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dsdDB, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, Datasnap.DBClient, Vcl.ActnList, dsdAction,
  cxPropertiesStore, dxBar, Vcl.ExtCtrls, cxContainer, cxLabel, cxTextEdit,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxButtonEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, dsdGuides, Vcl.Menus, cxPCdxBarPopupMenu, cxPC, frxClass, frxDBSet,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxCheckBox, cxCurrencyEdit;

type
  TSaleForm = class(TParentForm)
    dsdFormParams: TdsdFormParams;
    spSelectMovementItem: TdsdStoredProc;
    dxBarManager: TdxBarManager;
    dxBarManagerBar: TdxBar;
    bbRefresh: TdxBarButton;
    cxPropertiesStore: TcxPropertiesStore;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    DataPanel: TPanel;
    spGet: TdsdStoredProc;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    cxPageControl1: TcxPageControl;
    cxTabSheet1: TcxTabSheet;
    cxTabSheet2: TcxTabSheet;
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colAmountSumm: TcxGridDBColumn;
    cxGridLevel: TcxGridLevel;
    spSelectMovementContainerItem: TdsdStoredProc;
    cxGridEntryDBTableView: TcxGridDBTableView;
    cxGridEntryLevel: TcxGridLevel;
    cxGridEntry: TcxGrid;
    colDebetAccountName: TcxGridDBColumn;
    colDebetAmount: TcxGridDBColumn;
    EntryCDS: TClientDataSet;
    EntryDS: TDataSource;
    colKreditAccountName: TcxGridDBColumn;
    colKreditAmount: TcxGridDBColumn;
    actUpdateDataSet: TdsdUpdateDataSet;
    spInsertUpdateMovementItem: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    frxDBDataset: TfrxDBDataset;
    colDebetAccountGroupCode: TcxGridDBColumn;
    colDebetAccountGroupName: TcxGridDBColumn;
    colDebetAccountDirectionCode: TcxGridDBColumn;
    colDebetAccountDirectionName: TcxGridDBColumn;
    colDebetAccountCode: TcxGridDBColumn;
    colKreditAccountGroupCode: TcxGridDBColumn;
    colKreditAccountGroupName: TcxGridDBColumn;
    colKreditAccountDirectionCode: TcxGridDBColumn;
    colKreditAccountDirectionName: TcxGridDBColumn;
    colKreditAccountCode: TcxGridDBColumn;
    colGoodsGroupName: TcxGridDBColumn;
    colByObjectCode: TcxGridDBColumn;
    colByObjectName: TcxGridDBColumn;
    colGoodsName: TcxGridDBColumn;
    colAmountPartner: TcxGridDBColumn;
    colCountForPrice: TcxGridDBColumn;
    colHeadCount: TcxGridDBColumn;
    colPartionGoods: TcxGridDBColumn;
    colGoodsKindName: TcxGridDBColumn;
    colGoodsKindName_comlete: TcxGridDBColumn;
    colAccountOnComplete: TcxGridDBColumn;
    colAssetName: TcxGridDBColumn;
    cxCurrencyEdit2: TcxCurrencyEdit;
    edVATPercent: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    edTo: TcxButtonEdit;
    cxLabel4: TcxLabel;
    cxLabel3: TcxLabel;
    edFrom: TcxButtonEdit;
    edOperDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    cxLabel1: TcxLabel;
    edPriceWithVAT: TcxCheckBox;
    edInvNumber: TcxTextEdit;
    InsertUpdateMovement: TdsdStoredProc;
    edInvNumberPartner: TcxTextEdit;
    cxLabel5: TcxLabel;
    dsdGuidesFrom: TdsdGuides;
    dsdGuidesTo: TdsdGuides;
    edPaidKind: TcxButtonEdit;
    dsdGuidesPaidKind: TdsdGuides;
    cxLabel6: TcxLabel;
    edContract: TcxButtonEdit;
    cxLabel9: TcxLabel;
    dsdGuidesContract: TdsdGuides;
    edCar: TcxButtonEdit;
    cxLabel10: TcxLabel;
    dsdGuidesCar: TdsdGuides;
    edPersonalDriver: TcxButtonEdit;
    cxLabel11: TcxLabel;
    dsdGuidesPersonalDriver: TdsdGuides;
    edRoute: TcxButtonEdit;
    cxLabel12: TcxLabel;
    dsdGuidesRoute: TdsdGuides;
    edRouteSorting: TcxButtonEdit;
    cxLabel13: TcxLabel;
    dsdGuidesRouteSorting: TdsdGuides;
    cxLabel14: TcxLabel;
    edPersonal: TcxButtonEdit;
    dsdGuidesPersonal: TdsdGuides;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSaleForm);

end.
