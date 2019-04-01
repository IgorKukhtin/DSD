unit CheckCash;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDocument, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu,
  cxStyles, cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB,
  cxDBData, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, dsdGuides,
  dsdDB, Vcl.Menus, dxBarExtItems, dxBar, cxClasses, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxButtonEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, cxLabel, cxTextEdit, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC, cxCurrencyEdit, dxBarBuiltInMenu, cxNavigator, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter, cxCheckBox;

type
  TCheckCashForm = class(TAncestorDocumentForm)
    edCashRegisterName: TcxTextEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    edPaidTypeName: TcxTextEdit;
    ChoiceCashRegister: TOpenChoiceForm;
    ChoicePaidType: TOpenChoiceForm;
    spUpdate_Movement_Check: TdsdStoredProc;
    actEditDocument: TMultiAction;
    dxBarButton1: TdxBarButton;
    actUpdate_Movement_Check: TdsdExecStoredProc;
    lblCashMember: TcxLabel;
    edCashMember: TcxTextEdit;
    lblBayer: TcxLabel;
    edBayer: TcxTextEdit;
    cxLabel6: TcxLabel;
    edFiscalCheckNumber: TcxTextEdit;
    chbNotMCS: TcxCheckBox;
    cxLabel7: TcxLabel;
    edDiscountCard: TcxTextEdit;
    edInvNumberOrder: TcxTextEdit;
    cxLabel9: TcxLabel;
    cxLabel10: TcxLabel;
    edBayerPhone: TcxTextEdit;
    cxLabel8: TcxLabel;
    edConfirmedKind: TcxTextEdit;
    List_UID: TcxGridDBColumn;
    edConfirmedKindClient: TcxTextEdit;
    cxLabel11: TcxLabel;
    actShowMessage: TShowMessageAction;
    spSelectPrint: TdsdStoredProc;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    PrintDialog: TExecuteDialog;
    macPrint: TMultiAction;
    cxLabel12: TcxLabel;
    edPartnerMedical: TcxTextEdit;
    cxLabel13: TcxLabel;
    edOperDateSP: TcxDateEdit;
    cxLabel14: TcxLabel;
    edInvNumberSP: TcxTextEdit;
    cxLabel16: TcxLabel;
    edMedicSP: TcxTextEdit;
    ExecuteDialogUpdateOperDate: TExecuteDialog;
    actUpdateOperDate: TdsdDataSetRefresh;
    spUpdateMovement_OperDate: TdsdStoredProc;
    macUpdateOperDate: TMultiAction;
    bbUpdateOperDate: TdxBarButton;
    cxLabel17: TcxLabel;
    edAmbulance: TcxTextEdit;
    colisSp: TcxGridDBColumn;
    spUpdate_SpParam: TdsdStoredProc;
    actUpdateSpParam: TdsdDataSetRefresh;
    ExecuteDialogSP: TExecuteDialog;
    macUpdateSpParam: TMultiAction;
    bb: TdxBarButton;
    cxLabel18: TcxLabel;
    edSPKind: TcxTextEdit;
    cxLabel19: TcxLabel;
    edInvNumber_PromoCode_Full: TcxTextEdit;
    edUnitName: TcxButtonEdit;
    GuidesUnit: TdsdGuides;
    edManualDiscount: TcxTextEdit;
    cxLabel20: TcxLabel;
    cxLabel21: TcxLabel;
    edTotalSummPayAdd: TcxTextEdit;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    colRemains: TcxGridDBColumn;
    colColor_calc: TcxGridDBColumn;
    cbSite: TcxCheckBox;
    cbDeadlines: TcxCheckBox;
    cbDelay: TcxCheckBox;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TCheckCashForm)

end.
