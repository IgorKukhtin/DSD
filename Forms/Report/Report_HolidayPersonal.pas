unit Report_HolidayPersonal;

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
  TReport_HolidayPersonalForm = class(TParentForm)
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
    actExportToExcel: TdsdGridToExcel;
    bbToExcel: TdxBarButton;
    DBViewAddOn: TdsdDBViewAddOn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
    Day_vacation: TcxGridDBColumn;
    GuidesPersonalServiceList: TdsdGuides;
    PeriodChoice: TPeriodChoice;
    bbDialogForm: TdxBarButton;
    RefreshDispatcher: TRefreshDispatcher;
    GuidesMember: TdsdGuides;
    PositionName: TcxGridDBColumn;
    Day_holiday: TcxGridDBColumn;
    bbPrintBy_Goods: TdxBarButton;
    dxBarStatic: TdxBarStatic;
    FormParams: TdsdFormParams;
    Month_work: TcxGridDBColumn;
    spGetDescSets: TdsdStoredProc;
    SaleJournal: TdsdOpenForm;
    actIsDetail: TdsdDataSetRefresh;
    actPrint: TdsdPrintAction;
    bbPrint3: TdxBarButton;
    Panel1: TPanel;
    deStart: TcxDateEdit;
    edMember: TcxButtonEdit;
    cxLabel3: TcxLabel;
    edPersonalServiceList: TcxButtonEdit;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    PersonalCode: TcxGridDBColumn;
    Day_diff: TcxGridDBColumn;
    actPrint1: TdsdPrintAction;
    cxLabel1: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    BranchName: TcxGridDBColumn;
    bbIsDay: TdxBarControlContainerItem;
    UnitName: TcxGridDBColumn;
    cbDetail: TcxCheckBox;
    InvNumber: TcxGridDBColumn;
    Day_calendar: TcxGridDBColumn;
    Day_real: TcxGridDBColumn;
    Day_Hol: TcxGridDBColumn;
    PersonalServiceListName: TcxGridDBColumn;
    isNotCompensation: TcxGridDBColumn;
    Day_Hol_year: TcxGridDBColumn;
    Day_real_year: TcxGridDBColumn;
    Day_calendar_year: TcxGridDBColumn;
    Day_Holiday_cl: TcxGridDBColumn;
    Day_Holiday_year_cl: TcxGridDBColumn;
  private
  public
  end;

implementation

{$R *.dfm}



initialization
  RegisterClass(TReport_HolidayPersonalForm);

end.
