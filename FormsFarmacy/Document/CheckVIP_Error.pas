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
  cxCurrencyEdit, cxButtonEdit;

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
    colInvNumber: TcxGridDBColumn;
    colOperDate: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    colCashRegisterName: TcxGridDBColumn;
    colTotalSumm: TcxGridDBColumn;
    colCashMember: TcxGridDBColumn;
    dxBarButton2: TdxBarButton;
    dsdChoiceGuides: TdsdChoiceGuides;
    colGoodsName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    dxBarButton3: TdxBarButton;
    actCompleteCheck: TdsdChangeMovementStatus;
    spMovementSetErased: TdsdStoredProc;
    colStatusCode: TcxGridDBColumn;
    colPriceSale: TcxGridDBColumn;
    colChangePercent: TcxGridDBColumn;
    colSummChangePercent: TcxGridDBColumn;
    colAmountOrder: TcxGridDBColumn;
    colGoodsCode: TcxGridDBColumn;
    spConfirmedKind_Complete: TdsdStoredProc;
    actSetConfirmedKind_Complete: TdsdExecStoredProc;
    actSetConfirmedKind_UnComplete: TdsdExecStoredProc;
    bbConfirmedKind_Complete: TdxBarButton;
    spConfirmedKind_UnComplete: TdsdStoredProc;
    bbConfirmedKind_UnComplete: TdxBarButton;
    spMovementComplete: TdsdStoredProc;
    colCommentError: TcxGridDBColumn;
    actSimpleCompleteList: TMultiAction;
    actCompleteList: TMultiAction;
    spCompete: TdsdExecStoredProc;
    N2: TMenuItem;
    N3: TMenuItem;
    Color_CalcError: TcxGridDBColumn;
    actShowMessage: TShowMessageAction;
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
