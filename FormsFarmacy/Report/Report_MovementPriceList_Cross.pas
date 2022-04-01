unit Report_MovementPriceList_Cross;

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
  TReport_MovementPriceList_CrossForm = class(TParentForm)
    FormParams: TdsdFormParams;
    spSelect: TdsdStoredProc;
    dxBarManager: TdxBarManager;
    dxBarManagerBar: TdxBar;
    bbRefresh: TdxBarButton;
    cxPropertiesStore: TcxPropertiesStore;
    ActionList: TActionList;
    actRefresh: TdsdDataSetRefresh;
    MasterDS: TDataSource;
    MasterCDS: TClientDataSet;
    DataPanel: TPanel;
    edDateStart: TcxDateEdit;
    cxLabel2: TcxLabel;
    edJuridical1: TcxButtonEdit;
    cxLabel4: TcxLabel;
    GuidesJuridical1: TdsdGuides;
    cxGrid: TcxGrid;
    cxGridLevel: TcxGridLevel;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbStatic: TdxBarStatic;
    GridToExcel: TdsdGridToExcel;
    bbGridToExel: TdxBarButton;
    HeaderCDS: TClientDataSet;
    RefreshDispatcher: TRefreshDispatcher;
    cxGridDBBandedTableView: TcxGridDBBandedTableView;
    ObjectCode: TcxGridDBBandedColumn;
    GoodsName: TcxGridDBBandedColumn;
    Value1p: TcxGridDBBandedColumn;
    Value2p: TcxGridDBBandedColumn;
    isErased: TcxGridDBBandedColumn;
    actShowErased: TBooleanStoredProcAction;
    ExecuteDialog: TExecuteDialog;
    deEnd: TcxDateEdit;
    cxLabel7: TcxLabel;
    bbExecuteDialog: TdxBarButton;
    actShowAll: TBooleanStoredProcAction;
    bbShowAll: TdxBarButton;
    cxLabel1: TcxLabel;
    edJuridical2: TcxButtonEdit;
    cxLabel3: TcxLabel;
    edJuridical3: TcxButtonEdit;
    GuidesJuridical2: TdsdGuides;
    GuidesJuridical3: TdsdGuides;
    cxLabel5: TcxLabel;
    edContract1: TcxButtonEdit;
    GuidesContract1: TdsdGuides;
    cxLabel6: TcxLabel;
    edContract2: TcxButtonEdit;
    cxLabel8: TcxLabel;
    edContract3: TcxButtonEdit;
    GuidesContract3: TdsdGuides;
    GuidesContract2: TdsdGuides;
    Value3p: TcxGridDBBandedColumn;
    CrossDBViewReportAddOn: TCrossDBViewReportAddOn;
    dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_MovementPriceList_CrossForm);

end.
