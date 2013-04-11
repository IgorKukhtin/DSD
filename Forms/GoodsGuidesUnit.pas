unit GoodsGuidesUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, dsdDataSetWrapperUnit, cxPropertiesStore;

type
  TGoodsGuidesForm = class(TForm)
    cxGridDBTableView: TcxGridDBTableView;
    cxGridLevel: TcxGridLevel;
    cxGrid: TcxGrid;
    clName: TcxGridDBColumn;
    DataSource: TDataSource;
    ClientDataSet: TClientDataSet;
    clLogin: TcxGridDBColumn;
    cxPropertiesStore: TcxPropertiesStore;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  GoodsGuidesForm: TGoodsGuidesForm;

implementation

{$R *.dfm}


end.
