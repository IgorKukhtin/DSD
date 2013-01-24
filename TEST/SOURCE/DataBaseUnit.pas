unit DataBaseUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, ZDataset, ZAbstractDataset,
  ZAbstractTable, Data.DB, ZAbstractRODataset, ZSqlMetadata,
  ZAbstractConnection, ZConnection, ZStoredProcedure;

type
  TForm1 = class(TForm)
    ZConnection2: TZConnection;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

end.
