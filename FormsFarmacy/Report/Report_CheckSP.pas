unit Report_CheckSP;

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
  TReport_CheckSPForm = class(TAncestorReportForm)
    dxBarButton1: TdxBarButton;
    colIntenalSPName: TcxGridDBColumn;
    colAmount: TcxGridDBColumn;
    actGet_UserUnit: TdsdExecStoredProc;
    actRefreshStart: TdsdDataSetRefresh;
    clUnitName: TcxGridDBColumn;
    clBrandSPName: TcxGridDBColumn;
    clPriceSP: TcxGridDBColumn;
    actRefreshIsPartion: TdsdDataSetRefresh;
    clCountSP: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    actRefreshPartionPrice: TdsdDataSetRefresh;
    clKindOutSPName: TcxGridDBColumn;
    actPrint: TdsdPrintAction;
    bbPrint: TdxBarButton;
    clNumLine: TcxGridDBColumn;
    cxLabel3: TcxLabel;
    ceUnit: TcxButtonEdit;
    UnitGuides: TdsdGuides;
    cxLabel4: TcxLabel;
    edJuridical: TcxButtonEdit;
    JuridicalGuide: TdsdGuides;
    cxLabel5: TcxLabel;
    ceHospital: TcxButtonEdit;
    HospitalGuides: TdsdGuides;
    actPrint1: TdsdPrintAction;
    bbPrint1: TdxBarButton;
    clOperDate: TcxGridDBColumn;
    clInvNumberSP: TcxGridDBColumn;
    clMedicSPName: TcxGridDBColumn;
    clPartnerMedical_ContractName: TcxGridDBColumn;
    clPartnerMedical_Contract_StartDate: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Report_CheckSPForm: TReport_CheckSPForm;

implementation

{$R *.dfm}

initialization

  RegisterClass(TReport_CheckSPForm)
end.
