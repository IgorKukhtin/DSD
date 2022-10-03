unit OrderExternalJournal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorJournal, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  dsdAddOn, ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Datasnap.DBClient, dsdAction, Vcl.ActnList,
  cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGridCustomView, cxGrid, cxPC, cxCheckBox, cxCurrencyEdit,
  cxButtonEdit, dsdGuides, frxClass, frxDBSet, dxSkinsCore,
  dxSkinsDefaultPainters, dxBarBuiltInMenu, cxNavigator, dxSkinscxPCPainter,
  dxSkinsdxBarPainter;

type
  TOrderExternalJournalForm = class(TAncestorJournalForm)
    FromName: TcxGridDBColumn;
    ToName: TcxGridDBColumn;
    TotalCount: TcxGridDBColumn;
    bbTax: TdxBarButton;
    PrintHeaderCDS: TClientDataSet;
    PrintItemsCDS: TClientDataSet;
    spSelectPrint: TdsdStoredProc;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    bbPrintTax_Us: TdxBarButton;
    bbPrintTax_Client: TdxBarButton;
    bbPrint_Bill: TdxBarButton;
    PrintItemsSverkaCDS: TClientDataSet;
    TotalSumm: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    Comment: TcxGridDBColumn;
    MasterInvNumber: TcxGridDBColumn;
    isZakazToday: TcxGridDBColumn;
    isDostavkaToday: TcxGridDBColumn;
    OperDate_Zakaz: TcxGridDBColumn;
    OperDate_Dostavka: TcxGridDBColumn;
    isDeferred: TcxGridDBColumn;
    spUpdate_isDeferred_Yes: TdsdStoredProc;
    spUpdate_isDeferred_No: TdsdStoredProc;
    spUpdateisDeferredNo: TdsdExecStoredProc;
    spUpdateisDeferredYes: TdsdExecStoredProc;
    macUpdateisDeferredNo: TMultiAction;
    macUpdateisODeferredYes: TMultiAction;
    bbDeferredYes: TdxBarButton;
    bbDeferredNo: TdxBarButton;
    LetterSubject: TcxGridDBColumn;
    isUseSubject: TcxGridDBColumn;
    actReport_SupplierFailuresAll: TdsdOpenForm;
    bbReport_SupplierFailuresAll: TdxBarButton;
    TotaSummWithNDS: TcxGridDBColumn;
    isSupplierFailures: TcxGridDBColumn;
    ProvinceCityName: TcxGridDBColumn;
    actReport_JuridicalItog: TdsdOpenForm;
    bbReport_JuridicalItog: TdxBarButton;
    spUpdate_isSupplierFailures: TdsdStoredProc;
    actUpdate_SetSupplierFailures: TdsdExecStoredProc;
    bbUpdate_SetSupplierFailures: TdxBarButton;
    spUpdate_isSupplierFailures_Clear: TdsdStoredProc;
    actUpdate_SetSupplierFailures_Clear: TdsdExecStoredProc;
    bbUpdate_SetSupplierFailures_Clear: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization
  RegisterClass(TOrderExternalJournalForm);
end.
