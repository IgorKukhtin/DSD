unit AncestorDBGrid;

interface

uses
  DataModul, Winapi.Windows, AncestorData, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxPCdxBarPopupMenu, cxStyles,
  cxCustomData, cxFilter, cxData, cxDataStorage, cxEdit, Data.DB, cxDBData,
  Vcl.Menus, dsdAddOn, dsdAction, cxGridLevel, cxClasses, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, cxPC,
  Vcl.Controls, dxBarExtItems, dxBar, dsdDB, Datasnap.DBClient, System.Classes,
  Vcl.ActnList, cxPropertiesStore, dxSkinsCore, dxSkinsDefaultPainters,
  dxSkinsdxBarPainter, dxSkinscxPCPainter;

type
  TAncestorDBGridForm = class(TAncestorDataForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    DBViewAddOn: TdsdDBViewAddOn;
    actGridToExcel: TdsdGridToExcel;
    bbGridToExcel: TdxBarButton;
    PageControl: TcxPageControl;
    tsMain: TcxTabSheet;
    PopupMenu: TPopupMenu;
    Excel1: TMenuItem;
    N1: TMenuItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
