unit AlternativeGroup;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxBarBuiltInMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, cxNavigator, Data.DB,
  cxDBData, dsdAction, Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses,
  dsdDB, Datasnap.DBClient, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, cxButtonEdit;

type
  TAlternativeGroupForm = class(TAncestorEnumForm)
    actShowDel: TBooleanStoredProcAction;
    actShowDelGoods: TBooleanStoredProcAction;
    colId: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    colisErased: TcxGridDBColumn;
    dxBarButton1: TdxBarButton;
    GridGoods: TcxGrid;
    GridGoodsTableView: TcxGridDBTableView;
    GridGoodsLevel: TcxGridLevel;
    GoodsCDS: TClientDataSet;
    GoodsDS: TDataSource;
    spSelect_AlternativeGroup_Goods: TdsdStoredProc;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarStatic1: TdxBarStatic;
    GridGodsColAlternativeGroupId: TcxGridDBColumn;
    GridGodsColGoodsId: TcxGridDBColumn;
    GridGodsColGoodsCode: TcxGridDBColumn;
    GridGodsColGoodsName: TcxGridDBColumn;
    GridGodsColisErased: TcxGridDBColumn;
    dsdDBViewAddOn1: TdsdDBViewAddOn;
    spInsertUpdate_AlternativeGroup: TdsdStoredProc;
    spInsertUpdate_AlternativeGroup_Goods: TdsdStoredProc;
    dsdUpdateDataSet_Object_AlternativeGroup: TdsdUpdateDataSet;
    dsdUpdateDataSet_AlternativeGroup_Goods: TdsdUpdateDataSet;
    OpenChoiceFormGoods: TOpenChoiceForm;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AlternativeGroupForm: TAlternativeGroupForm;

implementation

{$R *.dfm}
initialization
  RegisterClass(TAlternativeGroupForm)

end.
