unit CheckDeferred;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxPCdxBarPopupMenu, cxImageComboBox, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxCurrencyEdit, cxButtonEdit, cxSplitter, cxContainer, cxTextEdit, cxMemo,
  cxDBEdit, Vcl.ExtCtrls, dxSkinBlack, dxSkinBlue, dxSkinBlueprint,
  dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TCheckDeferredForm = class(TAncestorDBGridForm)
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    actShowErased: TBooleanStoredProcAction;
    dxBarButton1: TdxBarButton;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    CashRegisterName: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    CashMember: TcxGridDBColumn;
    Bayer: TcxGridDBColumn;
    dxBarButton2: TdxBarButton;
    dsdChoiceGuides: TdsdChoiceGuides;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    dxBarButton3: TdxBarButton;
    actDeleteCheck: TdsdChangeMovementStatus;
    spMovementSetErased: TdsdStoredProc;
    StatusCode: TcxGridDBColumn;
    DiscountCardNumber: TcxGridDBColumn;
    DiscountExternalName: TcxGridDBColumn;
    PriceSale: TcxGridDBColumn;
    ChangePercent: TcxGridDBColumn;
    SummChangePercent: TcxGridDBColumn;
    BayerPhone: TcxGridDBColumn;
    NumberOrder: TcxGridDBColumn;
    ConfirmedKindName: TcxGridDBColumn;
    AmountOrder: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    ConfirmedKindClientName: TcxGridDBColumn;
    spConfirmedKind_Complete: TdsdStoredProc;
    actSetConfirmedKind_Complete: TdsdExecStoredProc;
    actSetConfirmedKind_UnComplete: TdsdExecStoredProc;
    bbConfirmedKind_Complete: TdxBarButton;
    spConfirmedKind_UnComplete: TdsdStoredProc;
    bbConfirmedKind_UnComplete: TdxBarButton;
    Color_Calc: TcxGridDBColumn;
    Color_CalcDoc: TcxGridDBColumn;
    actShowMessage: TShowMessageAction;
    InvNumberSP: TcxGridDBColumn;
    MedicSP: TcxGridDBColumn;
    SPKindName: TcxGridDBColumn;
    SPTax: TcxGridDBColumn;
    spUpdateMovementItemAmount: TdsdStoredProc;
    actUpdateMovementItemAmount: TdsdUpdateDataSet;
    cxSplitter1: TcxSplitter;
    actCheckCash: TdsdOpenForm;
    dxBarButton4: TdxBarButton;
    PartionDateKindName: TcxGridDBColumn;
    DateDelay: TcxGridDBColumn;
    ListPartionDateKindName: TcxGridDBColumn;
    actSmashCheck: TdsdExecStoredProc;
    spSmashCheck: TdsdStoredProc;
    dxBarButton5: TdxBarButton;
    actUpdateOperDate: TdsdExecStoredProc;
    bbUpdateOperDate: TdxBarButton;
    spUpdateOperDate: TdsdStoredProc;
    SummCard: TcxGridDBColumn;
    spMovementSetErasedSite: TdsdStoredProc;
    FormParams: TdsdFormParams;
    actDeleteCheckSite: TdsdChangeMovementStatus;
    dxBarButton6: TdxBarButton;
    actChoiceCancelReason: TOpenChoiceForm;
    TypeChech: TcxGridDBColumn;
    AccommodationName: TcxGridDBColumn;
    actPUSHSetErased: TdsdShowPUSHMessage;
    spPUSHSetErased: TdsdStoredProc;
    SPUpdate_NotMCS: TdsdStoredProc;
    actUpdateNotMCS: TdsdExecStoredProc;
    bbUpdateNotMCS: TdxBarButton;
    isNotMCS: TcxGridDBColumn;
    CommentCustomer: TcxGridDBColumn;
    Panel1: TPanel;
    cxDBMemo1: TcxDBMemo;
    isErrorRRO: TcxGridDBColumn;
    isAutoVIPforSales: TcxGridDBColumn;
    isMobileApplication: TcxGridDBColumn;
    isConfirmByPhone: TcxGridDBColumn;
    DateComing: TcxGridDBColumn;
    actExeceSputnikSMSParams: TdsdExecStoredProc;
    acteSputnikSendSMS: TdsdeSputnikSendSMS;
    speSputnikSMSParams: TdsdStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DataModul;

initialization
  RegisterClass(TCheckDeferredForm)

end.
