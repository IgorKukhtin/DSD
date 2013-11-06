unit UserGuides;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dsdGuides,
  cxTextEdit, cxMaskEdit, cxButtonEdit;

type
  TUserGuidesFrame = class(TFrame)
    edUser: TcxButtonEdit;
    UserGuides: TdsdGuides;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
