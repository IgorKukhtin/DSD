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
  dxBarBuiltInMenu, cxNavigator, cxCurrencyEdit, cxContainer, Vcl.ComCtrls,
  dxCore, cxDateUtils, cxLabel, cxTextEdit, cxMaskEdit, cxCalendar;

type
  TSupplierFailuresForm = class(TAncestorDBGridForm)
    isErased: TcxGridDBColumn;
    spUpdate_SupplierFailures: TdsdStoredProc;
    bbSetErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbSetErasedChild: TdxBarButton;
    bbUnErasedChild: TdxBarButton;
    bbdsdChoiceGuides: TdxBarButton;
    cxSplitter1: TcxSplitter;
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
    mactUpdate_SupplierFailures: TMultiAction;
    bbUpdate_SupplierFailures: TdxBarButton;
    isSupplierFailures: TcxGridDBColumn;
    edSupplierFailures: TcxDateEdit;
    cxLabel2: TcxLabel;
    dxBarControlContainerItem1: TdxBarControlContainerItem;
    dxBarControlContainerItem2: TdxBarControlContainerItem;
    RefreshDispatcher: TRefreshDispatcher;
    ExecuteDialog: TExecuteDialog;
    dxBarButton5: TdxBarButton;
    actUpdate_SupplierFailures: TdsdExecStoredProc;
    OperDate: TcxGridDBColumn;
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
