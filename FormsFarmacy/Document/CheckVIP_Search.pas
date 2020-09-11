unit CheckVIP_Search;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, CheckDeferred_Search, cxGraphics,
  cxControls, cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore,
  dxSkinsDefaultPainters, dxSkinscxPCPainter, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxImageComboBox, cxCurrencyEdit, dxSkinsdxBarPainter, dsdDB, Vcl.Menus,
  dsdAddOn, dxBarExtItems, dxBar, cxClasses, Datasnap.DBClient, dsdAction,
  Vcl.ActnList, cxPropertiesStore, cxSplitter, cxGridLevel,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGridCustomView,
  cxGrid, cxPC;

type
  TCheckVIP_SearchForm = class(TCheckDeferred_SearchForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TCheckVIP_SearchForm)

end.
