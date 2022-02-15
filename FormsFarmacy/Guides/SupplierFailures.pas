unit SupplierFailures;

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
  dxBarBuiltInMenu, cxNavigator, cxCurrencyEdit;

type
  TSupplierFailuresForm = class(TAncestorDBGridForm)
    isErased: TcxGridDBColumn;
    spInsertUpdateSupplierFailures: TdsdStoredProc;
    spErasedUnErased: TdsdStoredProc;
    dsdSetErased: TdsdUpdateErased;
    dsdUnErased: TdsdUpdateErased;
    bbSetErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbSetErasedChild: TdxBarButton;
    bbUnErasedChild: TdxBarButton;
    bbdsdChoiceGuides: TdxBarButton;
    cxSplitter1: TcxSplitter;
    Code: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton1: TdxBarButton;
    GoodsCode: TcxGridDBColumn;
    ContractName: TcxGridDBColumn;
    GoodsJuridicalCode: TcxGridDBColumn;
    GoodsJuridicalName: TcxGridDBColumn;
    AreaName: TcxGridDBColumn;
    actShowAll: TBooleanStoredProcAction;
    dxBarButton2: TdxBarButton;
    actProtocolOpenForm: TdsdOpenForm;
    dxBarButton3: TdxBarButton;
    DateUpdate: TcxGridDBColumn;
    UserUpdate: TcxGridDBColumn;
    mactSetErasedAll: TMultiAction;
    dxBarButton4: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TSupplierFailuresForm);

end.
