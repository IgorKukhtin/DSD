unit CalculationPartialSale;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorReport, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxContainer, Vcl.ComCtrls, dxCore, cxDateUtils, dsdAddOn, ChoicePeriod,
  Vcl.Menus, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxLabel, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxCalendar, Vcl.ExtCtrls, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  cxButtonEdit, dsdGuides, dxBarBuiltInMenu, cxNavigator, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  cxCurrencyEdit;

type
  TCalculationPartialSaleForm = class(TAncestorReportForm)
    FormParams: TdsdFormParams;
    JuridicalName: TcxGridDBColumn;
    ExecuteDialog: TExecuteDialog;
    bbExecuteDialog: TdxBarButton;
    FromName: TcxGridDBColumn;
    Summa: TcxGridDBColumn;
    actFormPartialSale: TMultiAction;
    actExecFormPartialSale: TdsdExecStoredProc;
    dxBarButton1: TdxBarButton;
    spFormPartialSale: TdsdStoredProc;
    actReport_Sale_PartialSale: TdsdOpenForm;
    dxBarButton2: TdxBarButton;
    actReport_Sale_PartialSaleAll: TdsdOpenForm;
    bbReport_Sale_PartialSaleAll: TdxBarButton;
    actReport_Income_PartialSale: TdsdOpenForm;
    dxBarButton3: TdxBarButton;
    actReport_Sale_PartialReturnInAll: TdsdOpenForm;
    dxBarButton4: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
initialization

  RegisterClass(TCalculationPartialSaleForm);

end.
