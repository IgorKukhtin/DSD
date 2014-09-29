unit Contract;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorGuides, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, dxSkinsCore, cxStyles, cxCustomData,
  cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, Vcl.Menus,
  dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB, Datasnap.DBClient,
  dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel, cxGridCustomView,
  cxGrid, cxPC, cxPCdxBarPopupMenu;

type
  TContractForm = class(TAncestorGuidesForm)
    clName: TcxGridDBColumn;
    clComment: TcxGridDBColumn;
    clJuridicalBasisName: TcxGridDBColumn;
    clJuridicalName: TcxGridDBColumn;
    clisErased: TcxGridDBColumn;
    colDeferment: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization
  RegisterClass(TContractForm);


end.
