unit ReportSoldParams;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxLabel, cxCalendar, cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxCurrencyEdit, dsdAction, dsdAddOn, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxTextEdit, cxMaskEdit, cxDropDownEdit, dxBarExtItems,
  dxBar, cxBarEditItem, Vcl.Menus, cxClasses, dsdDB, Datasnap.DBClient,
  Vcl.ActnList, cxPropertiesStore, cxGridLevel, cxGridCustomView, cxGrid, cxPC,
  ChoicePeriod;

type
  TReportSoldParamsForm = class(TAncestorEnumForm)
    dxBarButton1: TdxBarButton;
    bclblMonth: TdxBarControlContainerItem;
    bcdePlanDate: TdxBarControlContainerItem;
    lblMonth: TcxLabel;
    dePlanDate: TcxDateEdit;
    actShowAll: TBooleanStoredProcAction;
    colId: TcxGridDBColumn;
    colUnitId: TcxGridDBColumn;
    colUnitCode: TcxGridDBColumn;
    colUnitName: TcxGridDBColumn;
    colPlanDate: TcxGridDBColumn;
    colPlanAmount: TcxGridDBColumn;
    rdDate: TRefreshDispatcher;
    spInsertUpdate_Object_ReportSoldParams: TdsdStoredProc;
    actReportSoldParams: TdsdUpdateDataSet;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReportSoldParamsForm)

end.
