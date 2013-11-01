unit AncestorDBGrid;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorData, dxBarExtItems, dxBar,
  cxClasses, dsdDB, Data.DB, Datasnap.DBClient, Vcl.ActnList, dsdAction,
  cxPropertiesStore, dsdAddOn, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxDBData, cxGridLevel, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid, DataModul;

type
  TAncestorDBGridForm = class(TAncestorDataForm)
    cxGrid: TcxGrid;
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    DBViewAddOn: TdsdDBViewAddOn;
    dsdGridToExcel: TdsdGridToExcel;
    bbGridToExcel: TdxBarButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
