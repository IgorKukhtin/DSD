unit Report_UnitRent_service;

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
  DataModul, dxBarExtItems, dsdAddOn, cxCheckBox, cxCurrencyEdit,
  cxGridBandedTableView, cxGridDBBandedTableView, Vcl.Grids, Vcl.DBGrids,
  cxSplitter, cxTimeEdit, ChoicePeriod, AncestorBase;

type
  TReport_UnitRent_serviceForm = class(TAncestorBaseForm)
    FormParams: TdsdFormParams;
    spSelect: TdsdStoredProc;
    dxBarManager: TdxBarManager;
    dxBarManagerBar: TdxBar;
    bbRefresh: TdxBarButton;
    MasterDS: TDataSource;
    MasterCDS: TClientDataSet;
    DataPanel: TPanel;
    edDateStart: TcxDateEdit;
    cxLabel2: TcxLabel;
    bbPrint: TdxBarButton;
    bbStatic: TdxBarStatic;
    bbGridToExel: TdxBarButton;
    RefreshDispatcher: TRefreshDispatcher;
    deEnd: TcxDateEdit;
    cxLabel7: TcxLabel;
    bbExecuteDialog: TdxBarButton;
    bbShowAll: TdxBarButton;
    cxLabel6: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    PeriodChoice: TPeriodChoice;
    ExecuteDialog: TExecuteDialog;
    ScrollBox: TScrollBox;
    CheckerboardAddOn: TCheckerboardAddOn;
    spGet_Object_UnitNext: TdsdStoredProc;
    actGet_Object_UnitNext: TdsdExecStoredProc;
    actGet_Object_UnitPrior: TdsdExecStoredProc;
    dxBarButton1: TdxBarButton;
    spGet_Object_UnitPrior: TdsdStoredProc;
    actUpdate: TdsdInsertUpdateAction;
    dxBarButton2: TdxBarButton;
    spInsertUpdate_Object_Position: TdsdStoredProc;
    actInsertUpdate_Object_Position: TdsdExecStoredProc;
    actInsertUpdate_Object_Position_All: TdsdRunAction;
    bbInsertUpdate_Object_Position_All: TdxBarButton;
    actGet_Object_Unit_Start: TdsdStoredProc;
    cxLabel1: TcxLabel;
    edServiceDate: TcxDateEdit;
    cbAllMonth: TcxCheckBox;
    cxLabel5: TcxLabel;
    ceInfoMoney: TcxButtonEdit;
    GuidesInfoMoney: TdsdGuides;
    actInsertCash: TdsdInsertUpdateAction;
    bbInsertCash: TdxBarButton;
    spGet_Cash_Last: TdsdStoredProc;
    actUpdateCash: TdsdInsertUpdateAction;
    bbUpdateCash: TdxBarButton;
    macUpdateCash: TMultiAction;
    actGet_Cash_Last: TdsdExecStoredProc;
    actInsertService: TdsdInsertUpdateAction;
    bbInsertService: TdxBarButton;
    spGet_Service_Last: TdsdStoredProc;
    macUpdateService: TMultiAction;
    actUpdateService: TdsdInsertUpdateAction;
    actGet_Service_Last: TdsdExecStoredProc;
    bbUpdateService: TdxBarButton;
    spInsert_Movement_Service: TdsdStoredProc;
    actInsert_Movement_Service: TdsdExecStoredProc;
    bbInsert_Movement_Service: TdxBarButton;
    edLeft: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    edTop: TcxCurrencyEdit;
    cxLabel16: TcxLabel;
    edWidth: TcxCurrencyEdit;
    edHeighttext: TcxLabel;
    edHeight: TcxCurrencyEdit;
    spGet_Object_Unit_position: TdsdStoredProc;
    spUpdatePosition_Left: TdsdStoredProc;
    spUpdatePosition_Top: TdsdStoredProc;
    spUpdatePosition_Width: TdsdStoredProc;
    spUpdatePosition_Height: TdsdStoredProc;
    actUpdatePosition_Height: TdsdExecStoredProc;
    actUpdatePosition_Left: TdsdExecStoredProc;
    actUpdatePosition_Top: TdsdExecStoredProc;
    actUpdatePosition_Width: TdsdExecStoredProc;
    bbUpdatePosition_Left: TdxBarButton;
    bbUpdatePosition_Top: TdxBarButton;
    bbUpdatePosition_Width: TdxBarButton;
    bbUpdatePosition_Height: TdxBarButton;
    actGet_Object_Unit_position: TdsdExecStoredProc;
    bbGet_Object_Unit_position: TdxBarButton;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_UnitRent_serviceForm);

end.
