unit SendPartionDate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxCurrencyEdit, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdAddOn, dsdGuides, dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGridCustomView, cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, dxSkinsdxBarPainter, cxSplitter, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue,
  cxCheckBox;

type
  TSendPartionDateForm = class(TAncestorDocumentForm)
    lblUnit: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    AmountRemains: TcxGridDBColumn;
    ChangePercent: TcxGridDBColumn;
    PrintItemsCDS: TClientDataSet;
    PrintHeaderCDS: TClientDataSet;
    cxLabel7: TcxLabel;
    edComment: TcxTextEdit;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    chAmount: TcxGridDBColumn;
    ContainerId: TcxGridDBColumn;
    PartionDateKindName: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    DetailDCS: TClientDataSet;
    DetailDS: TDataSource;
    cxSplitter1: TcxSplitter;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    GuidesGroupMemberSP: TdsdGuides;
    actPrintCheck: TdsdPrintAction;
    PrintDialog: TExecuteDialog;
    macPrintCheck: TMultiAction;
    bbOpenPartionDateKind: TdxBarButton;
    actGet_SP_Prior: TdsdExecStoredProc;
    bbInsertMI: TdxBarButton;
    cxLabel10: TcxLabel;
    edInsertName: TcxButtonEdit;
    GuidesInsert: TdsdGuides;
    cxLabel12: TcxLabel;
    edInsertdate: TcxDateEdit;
    cxLabel11: TcxLabel;
    edUpdateName: TcxButtonEdit;
    cxLabel13: TcxLabel;
    edUpdateDate: TcxDateEdit;
    GuidesUpdate: TdsdGuides;
    chisErased: TcxGridDBColumn;
    ExpirationDate: TcxGridDBColumn;
    spInsertUpdateMIChild: TdsdStoredProc;
    actUpdateDetailDS: TdsdUpdateDataSet;
    spInsertMI: TdsdStoredProc;
    actInsertMI: TdsdExecStoredProc;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshUnit: TdsdDataSetRefresh;
    OperDate_Income: TcxGridDBColumn;
    Invnumber_Income: TcxGridDBColumn;
    FromName_Income: TcxGridDBColumn;
    ContractName_Income: TcxGridDBColumn;
    actOpenFormIncome: TdsdOpenForm;
    bbOpenFormIncome: TdxBarButton;
    minExpirationDate: TcxGridDBColumn;
    actOpenPartionDateKind: TdsdOpenForm;
    cxLabel9: TcxLabel;
    edChangePercent: TcxCurrencyEdit;
    cxLabel3: TcxLabel;
    edChangePercentMin: TcxCurrencyEdit;
    bbMIChildProtocolOpenForm: TdxBarButton;
    MovementId_Income: TcxGridDBColumn;
    cxLabel4: TcxLabel;
    cxGridDBTableView1Column1: TcxGridDBColumn;
    cbTransfer: TcxCheckBox;
    edChangePercentLess: TcxCurrencyEdit;
    cxLabel5: TcxLabel;
    ChangePercentLess: TcxGridDBColumn;
    Amount_3: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSendPartionDateForm);

end.
