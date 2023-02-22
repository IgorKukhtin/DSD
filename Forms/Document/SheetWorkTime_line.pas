unit SheetWorkTime_line;

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
  cxSplitter;

type
  TSheetWorkTime_lineForm = class(TParentForm)
    FormParams: TdsdFormParams;
    spSelectMI: TdsdStoredProc;
    dxBarManager: TdxBarManager;
    dxBarManagerBar: TdxBar;
    bbRefresh: TdxBarButton;
    cxPropertiesStore: TcxPropertiesStore;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    MasterDS: TDataSource;
    MasterCDS: TClientDataSet;
    DataPanel: TPanel;
    edOperDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    edUnit: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesUnit: TdsdGuides;
    actUpdateDayDS: TdsdUpdateDataSet;
    spInsertUpdateMI1: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbStatic: TdxBarStatic;
    GridToExcel: TdsdGridToExcel;
    bbGridToExel: TdxBarButton;
    HeaderCDS: TClientDataSet;
    RefreshDispatcher: TRefreshDispatcher;
    actOpenWorkTimeKindForm1: TOpenChoiceForm;
    MultiAction: TMultiAction;
    actInsert: TdsdInsertUpdateAction;
    bbInsert: TdxBarButton;
    actUpdate: TdsdInsertUpdateAction;
    bbUpdate: TdxBarButton;
    spInsertUpdate_SheetWorkTime_FromTransport: TdsdStoredProc;
    actInsertUpdate_SheetWorkTime_FromTransport: TdsdExecStoredProc;
    bbLoadFromTransport: TdxBarButton;
    actMISetErased: TdsdUpdateErased;
    actMISetUnErased: TdsdUpdateErased;
    spErasedMIMaster: TdsdStoredProc;
    bbMISetErased: TdxBarButton;
    bbMISetUnErased: TdxBarButton;
    actShowErased: TBooleanStoredProcAction;
    bbShowErased: TdxBarButton;
    actInsertMask: TdsdInsertUpdateAction;
    bbInsertMask: TdxBarButton;
    cbCheckedHead: TcxCheckBox;
    edCheckedHead_date: TcxDateEdit;
    edCheckedHead: TcxTextEdit;
    cbCheckedPersonal: TcxCheckBox;
    edCheckedPersonal_date: TcxDateEdit;
    edCheckedPersonal: TcxTextEdit;
    spGet: TdsdStoredProc;
    spUpdate_CheckedHead: TdsdStoredProc;
    spUpdate_CheckedPersonal: TdsdStoredProc;
    actUpdate_CheckedHead: TdsdExecStoredProc;
    actUpdate_CheckedPersonal: TdsdExecStoredProc;
    macUpdateCheckedHead: TMultiAction;
    macUpdateCheckedPersonal: TMultiAction;
    bbUpdateCheckedHead: TdxBarButton;
    bbUpdateCheckedPersonal: TdxBarButton;
    TotalCDS: TClientDataSet;
    TotalDS: TDataSource;
    actRefreshGet: TdsdDataSetRefresh;
    MovementItemProtocolOpenForm: TdsdOpenForm;
    bbMovementItemProtocolOpenForm: TdxBarButton;
    Get_byProtocol: TdsdStoredProc;
    macMovementItemProtocolOpenForm: TMultiAction;
    actGet_byProtocol: TdsdExecStoredProc;
    actOpenProtocolMember: TdsdOpenForm;
    actOpenProtocolPersonal: TdsdOpenForm;
    bbOpenProtocolMember: TdxBarButton;
    bbOpenProtocolPersonal: TdxBarButton;
    cxGrid2: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel2: TcxGridLevel;
    ShortName_1: TcxGridDBColumn;
    Color_Calc_1: TcxGridDBColumn;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    DayDS: TDataSource;
    DayCDS: TClientDataSet;
    dsdDBViewAddOn: TdsdDBViewAddOn;
    dsdDBViewAddOn_days: TdsdDBViewAddOn;
    spSelectMI_days: TdsdStoredProc;
    cxSplitter1: TcxSplitter;
    actOpenWorkTimeKindForm2: TOpenChoiceForm;
    spInsertUpdateMI2: TdsdStoredProc;
    spInsertUpdateMI: TdsdStoredProc;
    cxGrid3: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    cxGridLevel3: TcxGridLevel;
    cxSplitter2: TcxSplitter;
    dsdDBViewAddOn_total: TdsdDBViewAddOn;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSheetWorkTime_lineForm);

end.
