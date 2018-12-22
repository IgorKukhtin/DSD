unit RecalcMCSSheduler;

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
  dxBarBuiltInMenu, cxNavigator;

type
  TRecalcMCSShedulerForm = class(TAncestorDBGridForm)
    Value: TcxGridDBColumn;
    spErased: TdsdStoredProc;
    bbSetErased: TdxBarButton;
    bbUnErased: TdxBarButton;
    bbSetErasedChild: TdxBarButton;
    bbUnErasedChild: TdxBarButton;
    bbdsdChoiceGuides: TdxBarButton;
    cxSplitter1: TcxSplitter;
    Ord: TcxGridDBColumn;
    HeaderCDS: TClientDataSet;
    CrossDBViewAddOn: TCrossDBViewAddOn;
    actInsert: TdsdInsertUpdateAction;
    actUpdate: TdsdInsertUpdateAction;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    Color_cal: TcxGridDBColumn;
    actSetErased: TMultiAction;
    actUnErased: TMultiAction;
    actExecSetErased: TdsdExecStoredProc;
    actExecUnErased: TdsdExecStoredProc;
    spUnErased: TdsdStoredProc;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TRecalcMCSShedulerForm);

end.
