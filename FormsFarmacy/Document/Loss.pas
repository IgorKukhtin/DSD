unit Loss;

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
  cxSplitter;

type
  TLossForm = class(TAncestorDocumentForm)
    cxLabel3: TcxLabel;
    edUnit: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    GoodsCode: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actGoodsKindChoice: TOpenChoiceForm;
    spSelectPrint_Loss: TdsdStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    RefreshDispatcher: TRefreshDispatcher;
    actRefreshPrice: TdsdDataSetRefresh;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    PrintItemsSverkaCDS: TClientDataSet;
    cxLabel5: TcxLabel;
    edArticleLoss: TcxButtonEdit;
    GuidesArticleLoss: TdsdGuides;
    Price: TcxGridDBColumn;
    Remains_Amount: TcxGridDBColumn;
    Summ: TcxGridDBColumn;
    PriceIn: TcxGridDBColumn;
    SummIn: TcxGridDBColumn;
    bbComplete: TdxBarButton;
    spMovementComplete: TdsdStoredProc;
    actComplete: TdsdExecStoredProc;
    actLoadDeferredCheck: TMultiAction;
    actOpenChoiceDeferredCheck: TOpenChoiceForm;
    actExecSPAddDeferredCheck: TdsdExecStoredProc;
    dxBarButton1: TdxBarButton;
    spAddDeferredCheck: TdsdStoredProc;
    actLoadSend: TMultiAction;
    actOpenChoiceSend: TOpenChoiceForm;
    actExecSPAddSend: TdsdExecStoredProc;
    spAddSend: TdsdStoredProc;
    dxBarButton2: TdxBarButton;
    edComment: TcxTextEdit;
    cxLabel7: TcxLabel;
    spWriteRestFromPoint: TdsdStoredProc;
    actInsertMaskMIMaster: TdsdExecStoredProc;
    dxBarButton3: TdxBarButton;
    bbUpdateSummaFund: TdxBarButton;
    actMovementItemContainerCount: TdsdOpenForm;
    dxBarButton4: TdxBarButton;
    edCommentMarketing: TcxTextEdit;
    cxLabel4: TcxLabel;
    cbConfirmedMarketing: TcxCheckBox;
    spUpdate_ConfirmedMarketing: TdsdStoredProc;
    actUpdate_ConfirmedMarketing: TdsdExecStoredProc;
    dxBarButton5: TdxBarButton;
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    chAmount: TcxGridDBColumn;
    chExpirationDate: TcxGridDBColumn;
    chPartionDateKindName: TcxGridDBColumn;
    chOperDate_Income: TcxGridDBColumn;
    chInvnumber_Income: TcxGridDBColumn;
    chContainerId: TcxGridDBColumn;
    chFromName_Income: TcxGridDBColumn;
    chContractName_Income: TcxGridDBColumn;
    cxGridLevel1: TcxGridLevel;
    cxSplitter1: TcxSplitter;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    spSelect_MI_Child: TdsdStoredProc;
    DetailDS: TDataSource;
    DetailDCS: TClientDataSet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TLossForm);

end.
