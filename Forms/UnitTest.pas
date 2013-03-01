unit UnitTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, cxControls, cxContainer, cxEdit, cxGroupBox,
  dxBevel, Vcl.StdCtrls, cxButtons, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, Data.DB, cxDBData, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, Datasnap.DBClient, cxClasses, cxGridLevel,
  cxGrid;

type
  TForm3 = class(TForm)
    cxButton1: TcxButton;
    dxBevel1: TdxBevel;
    cxGroupBox1: TcxGroupBox;
    cxGrid1Level1: TcxGridLevel;
    cxGrid1: TcxGrid;
    DataSource1: TDataSource;
    ClientDataSet1: TClientDataSet;
    cxGrid1DBTableView1: TcxGridDBTableView;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var Form3: TForm3;

implementation

{$R *.dfm}

end.
