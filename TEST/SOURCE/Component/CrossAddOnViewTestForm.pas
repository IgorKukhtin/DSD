unit CrossAddOnViewTestForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, Data.DB, cxDBData, cxGridLevel, cxClasses,
  cxGridCustomView, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxGrid, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, dsdAddOn;

type
  TCrossAddOnViewTest = class(TForm)
    cxGrid1DBTableView1: TcxGridDBTableView;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    DataDataSource: TDataSource;
    DataDS: TClientDataSet;
    HorDS: TClientDataSet;
    DataDSName: TStringField;
    DataDSTemplate1: TStringField;
    DataDSTemplate2: TStringField;
    HorDSColumnName: TStringField;
    HorDSDocumentId: TIntegerField;
    HorDataSource: TDataSource;
    DBGrid1: TDBGrid;
    cxGrid1DBTableView1Column1: TcxGridDBColumn;
    CrossDBViewAddOn: TCrossDBViewAddOn;
    colTemplate: TcxGridDBColumn;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
