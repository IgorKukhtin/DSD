unit ImageLink;

{ ------------------------------------------------------------------------------ }

interface

{ ------------------------------------------------------------------------------ }

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

{ ------------------------------------------------------------------------------ }

type
  TImageLinkFrame = class(TFrame)
    TextLabel: TLabel;
    Image: TImage;
    procedure FrameMouseLeave(Sender: TObject);
    procedure FrameMouseEnter(Sender: TObject);
    procedure TextLabelClick(Sender: TObject);
  end;

{ ------------------------------------------------------------------------------ }

implementation

{ ------------------------------------------------------------------------------ }

{$R *.dfm}

{ ============================================================================== }

procedure TImageLinkFrame.FrameMouseEnter(Sender: TObject);
begin
  self.TextLabel.Font.Color := $0049230C;
end;

{ ------------------------------------------------------------------------------ }

procedure TImageLinkFrame.FrameMouseLeave(Sender: TObject);
begin
  self.TextLabel.Font.Color := clBlack;
end;

{ ------------------------------------------------------------------------------ }

procedure TImageLinkFrame.TextLabelClick(Sender: TObject);
begin
  self.OnClick(self);
end;

{ ============================================================================== }

end.
