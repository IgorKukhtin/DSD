unit Report_Layout_OutOrder;

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
  TReport_Layout_OutOrderForm = class(TAncestorDBGridForm)
    GoodsCode: TcxGridDBColumn;
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
    InvNumber: TcxGridDBColumn;
    OperDate: TcxGridDBColumn;
    actOpenUser: TOpenChoiceForm;
    dxBarButton1: TdxBarButton;
    GoodsName: TcxGridDBColumn;
    UnitCode: TcxGridDBColumn;
    UnitName: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    dxBarButton2: TdxBarButton;
    OperDatePrice: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    OperDatePriceLink: TcxGridDBColumn;
    JuridicalNameLink: TcxGridDBColumn;
    JuridicalMainName: TcxGridDBColumn;
    AmountLayout: TcxGridDBColumn;
    Remains: TcxGridDBColumn;
    MCSValue: TcxGridDBColumn;
    InvnNumberIncome: TcxGridDBColumn;
    OperDateIncome: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReport_Layout_OutOrderForm);

end.
