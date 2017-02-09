unit MarginCategoryItemHistory;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorEnum, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles, cxCustomData, cxFilter,
  cxData, cxDataStorage, cxEdit, Data.DB, cxDBData, dxSkinsdxBarPainter,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, dsdDB, Vcl.Menus,
  dsdAddOn, dxBarExtItems, dxBar, cxClasses, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxGridLevel, cxGridCustomView, cxGrid, cxPC;

type
  TMarginCategoryItemHistoryForm = class(TAncestorEnumForm)
    FormParams: TdsdFormParams;
    colStartDate: TcxGridDBColumn;
    colPrice: TcxGridDBColumn;
    colMCSValue: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MarginCategoryItemHistoryForm: TMarginCategoryItemHistoryForm;

implementation

{$R *.dfm}

initialization
  RegisterClass(TMarginCategoryItemHistoryForm);
end.
