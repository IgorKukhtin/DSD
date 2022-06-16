unit CheckDeferred_Search;

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
  cxCurrencyEdit, cxButtonEdit, cxSplitter;

type
  TCheckDeferred_SearchForm = class(TAncestorDBGridForm)
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
    cxSplitter1: TcxSplitter;
    DateDelay: TcxGridDBColumn;
    PartionDateKindName: TcxGridDBColumn;
    ListPartionDateKindName: TcxGridDBColumn;
    SummCard: TcxGridDBColumn;
    spMovementSetErasedSite: TdsdStoredProc;
    FormParams: TdsdFormParams;
    actDeleteCheckSite: TdsdChangeMovementStatus;
    actChoiceCancelReason: TOpenChoiceForm;
    dxBarButton4: TdxBarButton;
    TypeChech: TcxGridDBColumn;
    AccommodationName: TcxGridDBColumn;
    spPUSHSetErased: TdsdStoredProc;
    actPUSHSetErased: TdsdShowPUSHMessage;
    SPUpdate_NotMCS: TdsdStoredProc;
    actUpdateNotMCS: TdsdExecStoredProc;
    bbUpdateNotMCS: TdxBarButton;
    isNotMCS: TcxGridDBColumn;
    CommentCustomer: TcxGridDBColumn;
    isErrorRRO: TcxGridDBColumn;
    isAutoVIPforSales: TcxGridDBColumn;
    isMobileApplication: TcxGridDBColumn;
    cxGridDBTableViewColumn1: TcxGridDBColumn;
    DateComing: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses DataModul;

initialization
  RegisterClass(TCheckDeferred_SearchForm)

end.
