unit JuridicalPriorities;

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
  TJuridicalPrioritiesForm = class(TAncestorDBGridForm)
    isErased: TcxGridDBColumn;
    spInsertUpdateJuridicalPriorities: TdsdStoredProc;
    dsdUpdateMaster: TdsdUpdateDataSet;
    spErasedUnErased: TdsdStoredProc;
    dsdSetErased: TdsdUpdateErased;
    dsdUnErased: TdsdUpdateErased;
    bbSetErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbSetErasedChild: TdxBarButton;
    bbUnErasedChild: TdxBarButton;
    bbdsdChoiceGuides: TdxBarButton;
    cxSplitter1: TcxSplitter;
    actOpenJuridical: TOpenChoiceForm;
    Code: TcxGridDBColumn;
    JuridicalName: TcxGridDBColumn;
    GoodsName: TcxGridDBColumn;
    actOpenGoods: TOpenChoiceForm;
    dxBarSubItem1: TdxBarSubItem;
    dxBarButton1: TdxBarButton;
    GoodsCode: TcxGridDBColumn;
    Priorities: TcxGridDBColumn;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    mactSetErased: TMultiAction;
    mactSetUnErased: TMultiAction;
    spSetUnErased: TdsdStoredProc;
    spSetErased: TdsdStoredProc;
    actSetErased: TdsdExecStoredProc;
    actSetUnErased: TdsdExecStoredProc;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TJuridicalPrioritiesForm);

end.
