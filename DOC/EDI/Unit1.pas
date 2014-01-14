unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  qrddlgs, QRDesign;

type
  TForm1 = class(TForm)
    QRepDesigner1: TQRepDesigner;
    ReportDesignerDialog1: TReportDesignerDialog;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.FormCreate(Sender: TObject);
begin
ReportDesignerDialog1.NewReport('')
end;

end.
