unit SheetWorkTime;

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
  cxSplitter, cxTimeEdit;

type
  TSheetWorkTimeForm = class(TParentForm)
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
    cxGrid: TcxGrid;
    cxGridLevel: TcxGridLevel;
    actUpdateMasterDS: TdsdUpdateDataSet;
    spInsertUpdateMI: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbStatic: TdxBarStatic;
    GridToExcel: TdsdGridToExcel;
    bbGridToExel: TdxBarButton;
    CrossDBViewAddOn: TCrossDBViewAddOn;
    HeaderCDS: TClientDataSet;
    RefreshDispatcher: TRefreshDispatcher;
    cxGridDBBandedTableView: TcxGridDBBandedTableView;
    BandcolPersonalCode: TcxGridDBBandedColumn;
    BandcolPersonalName: TcxGridDBBandedColumn;
    BandcolPositionName: TcxGridDBBandedColumn;
    BandcolPersonalGroupName: TcxGridDBBandedColumn;
    TemplateColumn: TcxGridDBBandedColumn;
    TemplateColumn1: TcxGridDBBandedColumn;
    OpenWorkTimeKindForm: TOpenChoiceForm;
    MultiAction: TMultiAction;
    InsertAction: TdsdInsertUpdateAction;
    bbInsert: TdxBarButton;
    UpdateAction: TdsdInsertUpdateAction;
    bbUpdate: TdxBarButton;
    spInsertUpdate_SheetWorkTime_FromTransport: TdsdStoredProc;
    actInsertUpdate_SheetWorkTime_FromTransport: TdsdExecStoredProc;
    bbLoadFromTransport: TdxBarButton;
    actMISetErased: TdsdUpdateErased;
    actMISetUnErased: TdsdUpdateErased;
    spErasedMIMaster: TdsdStoredProc;
    bbMISetErased: TdxBarButton;
    bbMISetUnErased: TdxBarButton;
    isErased: TcxGridDBBandedColumn;
    actShowErased: TBooleanStoredProcAction;
    bbShowErased: TdxBarButton;
    cxSplitter1: TcxSplitter;
    cxGrid1: TcxGrid;
    cxGridDBBandedTableView1: TcxGridDBBandedTableView;
    ColPersonalCode: TcxGridDBBandedColumn;
    cxGridLevel1: TcxGridLevel;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    spSelectMI_Child: TdsdStoredProc;
    CrossDBViewAddOn_Child: TCrossDBViewAddOn;
    HeaderCDS_Child: TClientDataSet;
    actUpdateChildDS: TdsdUpdateDataSet;
    spInsertUpdateMI_Child: TdsdStoredProc;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSheetWorkTimeForm);

end.
