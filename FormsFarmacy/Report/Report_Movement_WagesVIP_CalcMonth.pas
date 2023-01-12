unit Report_Movement_WagesVIP_CalcMonth;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxButtonEdit, Vcl.ExtCtrls, cxSplitter, cxDropDownEdit,
  dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter, dxSkinsdxBarPainter,
  dxBarBuiltInMenu, cxNavigator, cxCalendar, cxCurrencyEdit;

type
  TReport_Movement_WagesVIP_CalcMonthForm = class(TAncestorDBGridForm)
    dsdUpdateMaster: TdsdUpdateDataSet;
    dsdSetErased: TdsdUpdateErased;
    dsdUnErased: TdsdUpdateErased;
    bbSetErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbSetErasedChild: TdxBarButton;
    bbUnErasedChild: TdxBarButton;
    bbdsdChoiceGuides: TdxBarButton;
    cxSplitter1: TcxSplitter;
    actOpenUnit: TOpenChoiceForm;
    OperDate: TcxGridDBColumn;
    actOpenUser: TOpenChoiceForm;
    dxBarButton1: TdxBarButton;
    HoursWork: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    dxBarButton2: TdxBarButton;
    TotalAmount: TcxGridDBColumn;
    AmountAccrued: TcxGridDBColumn;
    ApplicationAward: TcxGridDBColumn;
    FormParams: TdsdFormParams;
    UserCode: TcxGridDBColumn;
    UserName: TcxGridDBColumn;
    PayrollTypeVIPName: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_Movement_WagesVIP_CalcMonthForm);

end.
