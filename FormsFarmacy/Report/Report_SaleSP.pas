unit Report_SaleSP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn,
  ChoicePeriod, Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dsdGuides, cxButtonEdit, cxCurrencyEdit, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu,
  dxSkinsdxBarPainter, cxCheckBox;

type
  TReport_SaleSPForm = class(TAncestorReportForm)
    dxBarButton1: TdxBarButton;
    GoodsName: TcxGridDBColumn;
    Amount: TcxGridDBColumn;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    UnitName: TcxGridDBColumn;
    MemberSP: TcxGridDBColumn;
    PriceSP: TcxGridDBColumn;
    actRefreshIsPartion: TdsdDataSetRefresh;
    OperDateSP: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actRefreshPartionPrice: TdsdDataSetRefresh;
    MedicSP: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    NumLine: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    ceUnit: TcxButtonEdit;
    UnitGuides: TdsdGuides;
    cxLabel4: TcxLabel;
    edJuridical: TcxButtonEdit;
    JuridicalGuides: TdsdGuides;
    cxLabel5: TcxLabel;
    ceHospital: TcxButtonEdit;
    HospitalGuides: TdsdGuides;
    cxLabel6: TcxLabel;
    edGroupMemberSP: TcxButtonEdit;
    GroupMemberSPGuides: TdsdGuides;
    cbGroupMemberSP: TcxCheckBox;
    actRefresh1: TdsdDataSetRefresh;
    MedicFIO: TcxGridDBColumn;
    Contract_StartDate: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    Unit_Address: TcxGridDBColumn;
    License: TcxGridDBColumn;
    actPrintInvoice: TdsdPrintAction;
    bbPrintInvoice: TdxBarButton;
    cxLabel7: TcxLabel;
    edDateInvoice: TcxDateEdit;
    cxLabel8: TcxLabel;
    edInvoice: TcxTextEdit;
    CountSP: TcxGridDBColumn;
    cxLabel11: TcxLabel;
    cePercentSP: TcxCurrencyEdit;
    cbisInsert: TcxCheckBox;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    spSavePrintMovement: TdsdStoredProc;
    actSaveMovement: TdsdExecStoredProc;
    macPrintInvoice: TMultiAction;
    InvNumber_Invoice_Full: TcxGridDBColumn;
    GoodsCode: TcxGridDBColumn;
    isListSP: TcxGridDBColumn;
    spUpdateDS: TdsdStoredProc;
    actUpdateDS: TdsdUpdateDataSet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_SaleSPForm: TReport_SaleSPForm;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_SaleSPForm)
end.
