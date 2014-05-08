unit ProductionSeparate;

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
  cxSplitter;

type
  TProductionSeparateForm = class(TParentForm)
    dsdFormParams: TdsdFormParams;
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
    edInvNumber: TcxTextEdit;
    cxLabel1: TcxLabel;
    edOperDate: TcxDateEdit;
    cxLabel2: TcxLabel;
    edFrom: TcxButtonEdit;
    edTo: TcxButtonEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    dsdGuidesFrom: TdsdGuides;
    dsdGuidesTo: TdsdGuides;
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
    cxGridLevel: TcxGridLevel;
    spSelectMIContainer: TdsdStoredProc;
    cxGridEntryDBTableView: TcxGridDBTableView;
    cxGridEntryLevel: TcxGridLevel;
    cxGridEntry: TcxGrid;
    colDebetAccountName: TcxGridDBColumn;
    colDebetAmount: TcxGridDBColumn;
    EntryCDS: TClientDataSet;
    EntryDS: TDataSource;
    colKreditAccountName: TcxGridDBColumn;
    colKreditAmount: TcxGridDBColumn;
    actUpdateMasterDS: TdsdUpdateDataSet;
    spInsertUpdateMIMaster: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
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
    colHeadCount: TcxGridDBColumn;
    colGoodsKindName_comlete: TcxGridDBColumn;
    colAccountOnComplete: TcxGridDBColumn;
    colGoodsCode: TcxGridDBColumn;
    colInfoMoneyCode: TcxGridDBColumn;
    colInfoMoneyName: TcxGridDBColumn;
    colInfoMoneyCode_Detail: TcxGridDBColumn;
    colInfoMoneyName_Detail: TcxGridDBColumn;
    cxGridChild: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    colChildGoodsCode: TcxGridDBColumn;
    colChildGoodsName: TcxGridDBColumn;
    colChildAmount: TcxGridDBColumn;
    colChildHeadCount: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitterChild: TcxSplitter;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    colGoodsCode_Parent: TcxGridDBColumn;
    colGoodsName_Parent: TcxGridDBColumn;
    colGoodsKindName_Parent: TcxGridDBColumn;
    colMIId_Parent: TcxGridDBColumn;
    colObjectCostId: TcxGridDBColumn;
    colPrice_comlete: TcxGridDBColumn;
    coChildlId: TcxGridDBColumn;
    dsdGridToExcel: TdsdGridToExcel;
    bbGridToExel: TdxBarButton;
  private
  public
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TProductionSeparateForm);

end.
