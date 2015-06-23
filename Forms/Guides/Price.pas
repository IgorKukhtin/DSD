unit Price;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, Vcl.ExtCtrls, cxContainer, dsdGuides, cxTextEdit, cxMaskEdit,
  cxButtonEdit, cxCurrencyEdit;

type
  TPriceForm = class(TAncestorEnumForm)
    dxBarControlContainerItemUnit: TdxBarControlContainerItem;
    ceUnit: TcxButtonEdit;
    UnitGuides: TdsdGuides;
    FormParams: TdsdFormParams;
    dxBarButton1: TdxBarButton;
    actShowAll: TBooleanStoredProcAction;
    actShowDel: TBooleanStoredProcAction;
    dxBarButton2: TdxBarButton;
    clGoodsCode: TcxGridDBColumn;
    clGoodsName: TcxGridDBColumn;
    clPrice: TcxGridDBColumn;
    clDateChange: TcxGridDBColumn;
    clisErased: TcxGridDBColumn;
    spInsertUpdate: TdsdStoredProc;
    dsdUpdatePrice: TdsdUpdateDataSet;
    rdUnit: TRefreshDispatcher;
    clMCSValue: TcxGridDBColumn;
    clMCSDateChange: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PriceForm: TPriceForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TPriceForm)
end.
