unit Report_TransportFuel;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, dsdDB, cxPropertiesStore, dxBar,
  Vcl.ActnList, dsdAction, ParentForm, DataModul, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, dxSkinscxPCPainter, dxSkinsdxBarPainter, dsdAddOn,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxCurrencyEdit, dsdGuides,
  cxButtonEdit, ChoicePeriod, cxLabel, frxClass, frxDBSet, cxCheckBox,
  dxBarExtItems;

type
  TReport_TransportFuelForm = class(TParentForm)
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    spSelect: TdsdStoredProc;
    StartAmount: TcxGridDBColumn;
    actExportToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    InAmount: TcxGridDBColumn;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Panel1: TPanel;
    CarCode: TcxGridDBColumn;
    CarName: TcxGridDBColumn;
    FuelCode: TcxGridDBColumn;
    FuelName: TcxGridDBColumn;
    StartSumm: TcxGridDBColumn;
    InSumm: TcxGridDBColumn;
    EndAmount: TcxGridDBColumn;
    EndSumm: TcxGridDBColumn;
    OutAmount: TcxGridDBColumn;
    PeriodChoice: TPeriodChoice;
    bbDialogForm: TdxBarButton;
    edCar: TcxButtonEdit;
    RefreshDispatcher: TRefreshDispatcher;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    cxLabel2: TcxLabel;
    GuidesCar: TdsdGuides;
    dsdPrintAction: TdsdPrintAction;
    bbPrint: TdxBarButton;
    cxLabel4: TcxLabel;
    GuidesFuel: TdsdGuides;
    ceFuel: TcxButtonEdit;
    cxLabel1: TcxLabel;
    cxLabel3: TcxLabel;
    CarModelName: TcxGridDBColumn;
    cxLabel5: TcxLabel;
    edBranch: TcxButtonEdit;
    GuidesBranch: TdsdGuides;
    BranchName: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    dxBarStatic: TdxBarButton;
    FromName: TcxGridDBColumn;
    PersonalName: TcxGridDBColumn;
    cbPartner: TcxCheckBox;
    actRefreshPartner: TdsdDataSetRefresh;
    outSumm_Juridical: TcxGridDBColumn;
    actPrintDetail: TdsdPrintAction;
    bbPrintDetail: TdxBarButton;
    outSumm_virt: TcxGridDBColumn;
    outSumm_ZP_pl: TcxGridDBColumn;
    cbPrice: TcxCheckBox;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    outSumm_Income: TcxGridDBColumn;
    actRefreshCar: TdsdDataSetRefresh;
    FormParams: TdsdFormParams;
    cbisCar: TcxCheckBox;
  private
  public
  end;

implementation

{$R *.dfm}



initialization
  RegisterClass(TReport_TransportFuelForm);

end.
