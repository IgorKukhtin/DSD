unit AsinoPharmaSP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dxSkinsdxBarPainter, dsdAddOn,
  dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, cxCurrencyEdit, cxCheckBox, frxClass, frxDBSet,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  ExternalLoad, cxSplitter;

type
  TAsinoPharmaSPForm = class(TAncestorDocumentForm)
    Queue: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint_GoodsSP: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    bbComplete: TdxBarButton;
    spMovementComplete: TdsdStoredProc;
    actComplete: TdsdExecStoredProc;
    actInsertMI: TdsdExecStoredProc;
    actRefreshMI: TdsdDataSetRefresh;
    bbInsertMI: TdxBarButton;
    bbStartLoad: TdxBarButton;
    actDoLoadDop: TExecuteImportSettingsAction;
    actGetImportSettingDop: TdsdExecStoredProc;
    macStartLoadDop: TMultiAction;
    bbStartLoadDop: TdxBarButton;
    macStartLoadHelsi: TMultiAction;
    bbStartLoadHelsi: TdxBarButton;
    GoodsNamePresent: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    edOperDateEnd: TcxDateEdit;
    cxLabel4: TcxLabel;
    edOperDateStart: TcxDateEdit;
    cxLabel3: TcxLabel;
    Panel: TPanel;
    Splitter: TcxSplitter;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    chGoodsCode: TcxGridDBColumn;
    chGoodsName: TcxGridDBColumn;
    chAmount: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    PanelChild: TPanel;
    PanelSecond: TPanel;
    cxGrid2: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    seGoodsCode: TcxGridDBColumn;
    seGoodsName: TcxGridDBColumn;
    seAmount: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    SplitterCh: TcxSplitter;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    ChildCDS: TClientDataSet;
    ChildDS: TDataSource;
    SecondDS: TDataSource;
    SecondCDS: TClientDataSet;
    spSelectChild: TdsdStoredProc;
    spSelectSecond: TdsdStoredProc;
    actInsertMIChild: TdsdExecStoredProc;
    spInsertMIChild: TdsdStoredProc;
    spInsertUpdateeMIChild: TdsdStoredProc;
    actGoodsMain: TOpenChoiceForm;
    dxBarButton1: TdxBarButton;
    spInsertUpdateeMISecond: TdsdStoredProc;
    spInsertMISecond: TdsdStoredProc;
    actInsertMISecond: TdsdExecStoredProc;
    dxBarButton2: TdxBarButton;
    actUpdateChildDS: TdsdUpdateDataSet;
    actUpdateSecondDS: TdsdUpdateDataSet;
    spErasedMIMaster_Child: TdsdStoredProc;
    spUnErasedMIMaster_Child: TdsdStoredProc;
    spUnErasedMIMaster_Second: TdsdStoredProc;
    spErasedMIMaster_Second: TdsdStoredProc;
    actErasedMIMaster_Child: TdsdUpdateErased;
    actUnErasedMIMaster_Child: TdsdUpdateErased;
    actErasedMIMaster_Second: TdsdUpdateErased;
    actUnErasedMIMaster_Second: TdsdUpdateErased;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    DBViewAddOnChild: TdsdDBViewAddOn;
    DBViewAddOnSecond: TdsdDBViewAddOn;
    chisErased: TcxGridDBColumn;
    seisErased: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TAsinoPharmaSPForm);

end.
