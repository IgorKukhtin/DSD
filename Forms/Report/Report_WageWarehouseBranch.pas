unit Report_WageWarehouseBranch;

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
  cxButtonEdit, ChoicePeriod, cxLabel, dxBarExtItems, cxCheckBox;

type
  TReport_WageWarehouseBranchForm = class(TParentForm)
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    MasterDS: TDataSource;
    MasterCDS: TClientDataSet;
    cxPropertiesStore: TcxPropertiesStore;
    dxBarManager: TdxBarManager;
    dxBarManagerBar1: TdxBar;
    ActionList: TActionList;
    bbRefresh: TdxBarButton;
    actRefresh: TdsdDataSetRefresh;
    spReport: TdsdStoredProc;
    CountMI_1: TcxGridDBColumn;
    actExportToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    DBViewAddOn: TdsdDBViewAddOn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    TotalCountStick_2: TcxGridDBColumn;
    PositionGuides: TdsdGuides;
    PeriodChoice: TPeriodChoice;
    bbDialogForm: TdxBarButton;
    RefreshDispatcher: TRefreshDispatcher;
    PersonalGuides: TdsdGuides;
    PositionName: TcxGridDBColumn;
    CountMovement_1: TcxGridDBColumn;
    bbPrintBy_Goods: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    FormParams: TdsdFormParams;
    TotalCountKg_1: TcxGridDBColumn;
    spGetDescSets: TdsdStoredProc;
    SaleJournal: TdsdOpenForm;
    actIsDay: TdsdDataSetRefresh;
    actPrint: TdsdPrintAction;
    bbPrint3: TdxBarButton;
    Panel1: TPanel;
    deStart: TcxDateEdit;
    deEnd: TcxDateEdit;
    edPersonal: TcxButtonEdit;
    cxLabel3: TcxLabel;
    edPosition: TcxButtonEdit;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    PersonalCode: TcxGridDBColumn;
    CountMovement1_3: TcxGridDBColumn;
    CountMI1_3: TcxGridDBColumn;
    TotalCountKg1_3: TcxGridDBColumn;
    CountMovement1_4: TcxGridDBColumn;
    actPrint1: TdsdPrintAction;
    cxLabel1: TcxLabel;
    edBranch: TcxButtonEdit;
    BranchGuides: TdsdGuides;
    BranchName: TcxGridDBColumn;
    bbIsDay: TdxBarControlContainerItem;
    UnitName: TcxGridDBColumn;
    bbIsMovement: TdxBarControlContainerItem;
    TotalCountKg1_4: TcxGridDBColumn;
    actRefreshMov: TdsdDataSetRefresh;
    bbisMonth: TdxBarControlContainerItem;
    actIsMonth: TdsdDataSetRefresh;
    vbKoef_11: TcxCurrencyEdit;
    Код: TcxLabel;
    vbKoef_12: TcxCurrencyEdit;
    vbKoef_13: TcxCurrencyEdit;
    cxLabel2: TcxLabel;
    vbKoef_41: TcxCurrencyEdit;
    vbKoef_42: TcxCurrencyEdit;
    vbKoef_22: TcxCurrencyEdit;
    vbKoef_43: TcxCurrencyEdit;
    cxLabel7: TcxLabel;
    cxLabel8: TcxLabel;
    vbKoef_31: TcxCurrencyEdit;
    vbKoef_32: TcxCurrencyEdit;
    vbKoef_33: TcxCurrencyEdit;
    cxLabel9: TcxLabel;
    TotalCountKg1_5: TcxGridDBColumn;
    cbIsDay: TcxCheckBox;
    gpGet_Koeff: TdsdStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
  private
  public
  end;

implementation

{$R *.dfm}



initialization
  RegisterClass(TReport_WageWarehouseBranchForm);

end.
