unit CheckVIP_Error;

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
  cxCurrencyEdit, cxButtonEdit, cxSplitter, Vcl.ExtCtrls;

type
  TCheckVIP_ErrorForm = class(TAncestorDBGridForm)
    cxGrid1: TcxGrid;
    cxGridDBTableView1: TcxGridDBTableView;
    cxGridLevel1: TcxGridLevel;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    spSelectMI: TdsdStoredProc;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    actShowErased: TBooleanStoredProcAction;
    dxBarButton1: TdxBarButton;
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    CashRegisterName: TcxGridDBColumn;
    TotalSumm: TcxGridDBColumn;
    CashMember: TcxGridDBColumn;
    dxBarButton2: TdxBarButton;
    dsdChoiceGuides: TdsdChoiceGuides;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    Price: TcxGridDBColumn;
    dxBarButton3: TdxBarButton;
    actCompleteCheck: TdsdChangeMovementStatus;
    spMovementSetErased: TdsdStoredProc;
    StatusCode: TcxGridDBColumn;
    PriceSale: TcxGridDBColumn;
    ChangePercent: TcxGridDBColumn;
    SummChangePercent: TcxGridDBColumn;
    AmountOrder: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    spConfirmedKind_Complete: TdsdStoredProc;
    actSetConfirmedKind_Complete: TdsdExecStoredProc;
    actSetConfirmedKind_UnComplete: TdsdExecStoredProc;
    bbConfirmedKind_Complete: TdxBarButton;
    spConfirmedKind_UnComplete: TdsdStoredProc;
    bbConfirmedKind_UnComplete: TdxBarButton;
    spMovementComplete: TdsdStoredProc;
    CommentError: TcxGridDBColumn;
    actSimpleCompleteList: TMultiAction;
    actCompleteList: TMultiAction;
    spCompete: TdsdExecStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    Color_CalcError: TcxGridDBColumn;
    actShowMessage: TShowMessageAction;
    spUpdate_MovementIten_PartionDateKind: TdsdStoredProc;
    spReLinkContainer: TdsdStoredProc;
    PartionDateKindName: TcxGridDBColumn;
    actReLinkContainer: TMultiAction;
    actUpdate_MovementIten_PartionDateKind: TMultiAction;
    actExecReLinkContainer: TdsdExecStoredProc;
    actExec_MovementIten_PartionDateKind: TdsdExecStoredProc;
    astChoicePartionDateKind: TOpenChoiceForm;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    Panel: TPanel;
    cxSplitter1: TcxSplitter;
    cxGrid2: TcxGrid;
    cxGridDBTableView2: TcxGridDBTableView;
    chAmount: TcxGridDBColumn;
    chExpirationDate: TcxGridDBColumn;
    chOperDate_Income: TcxGridDBColumn;
    chInvnumber_Income: TcxGridDBColumn;
    chContainerId: TcxGridDBColumn;
    chFromName_Income: TcxGridDBColumn;
    chContractName_Income: TcxGridDBColumn;
    chisErased: TcxGridDBColumn;
    cxGridLevel2: TcxGridLevel;
    spSelectMIChild: TdsdStoredProc;
    DataSource2: TDataSource;
    ClientDataSet2: TClientDataSet;
    FormParams: TdsdFormParams;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CheckVIP_ErrorForm: TCheckVIP_ErrorForm;

implementation

{$R *.dfm}

uses DataModul;

initialization
  RegisterClass(TCheckVIP_ErrorForm)

end.
