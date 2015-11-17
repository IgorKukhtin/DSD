unit ReasonDifferences;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorGuides, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dxSkinsdxBarPainter,
  dsdAction, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGrid, cxPC;

type
  TReasonDifferencesForm = class(TAncestorGuidesForm)
    actShowDel: TBooleanStoredProcAction;
    dxBarButton1: TdxBarButton;
    colCode: TcxGridDBColumn;
    colName: TcxGridDBColumn;
    actUpdateDataSet: TdsdUpdateDataSet;
    spInsertUpdate_Object_ReasonDifferences: TdsdStoredProc;
    colisErased: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TReasonDifferencesForm);
end.
