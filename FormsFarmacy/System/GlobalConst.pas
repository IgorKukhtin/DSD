unit GlobalConst;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDBGrid, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dxBarExtItems, dxBar, cxClasses, dsdDB,
  Datasnap.DBClient, dsdAction, Vcl.ActnList, cxPropertiesStore, cxGridLevel,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, cxPC, dxSkinsCore, dxSkinsDefaultPainters, dxSkinscxPCPainter,
  dxSkinsdxBarPainter;

type
  TGlobalConstForm = class(TAncestorDBGridForm)
    Name: TcxGridDBColumn;
    spUpdateGlobalConst: TdsdStoredProc;
    actUpdateDataSet: TdsdUpdateDataSet;
    ActualBankStatementDate: TcxGridDBColumn;
    ProtocolOpenForm: TdsdOpenForm;
    bbProtocolOpenForm: TdxBarButton;
    EnumName: TcxGridDBColumn;
    SiteDiscount: TcxGridDBColumn;
    isSiteDiscount: TcxGridDBColumn;
    Code: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

initialization

  RegisterClass(TGlobalConstForm)

end.
