unit dsdTranslator;

interface

uses
  Windows, Forms, ActnList, Controls, Classes, DB, DBClient, dsdDataSetDataLink;

type

  TdsdTranslator  = class;

  TdsdTranslator  = class(TComponent)
  private
  protected
    FOnFormKeyDown : TKeyEvent;
    procedure OnFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
  end;

  procedure Register;

implementation

uses ParentForm, Dialogs, Menus, SysUtils, RegularExpressions;


procedure Register;
begin
  RegisterComponents('DSDComponent', [TdsdTranslator]);
end;

{ TdsdTranslator  }

constructor TdsdTranslator.Create(AOwner: TComponent);
begin
  inherited;
  if csDesigning in ComponentState then Exit;
  if Owner is TForm then
  begin
    FOnFormKeyDown :=  TForm(Owner).OnKeyDown;
    TForm(Owner).OnKeyDown := OnFormKeyDown;
  end;
end;

destructor TdsdTranslator.Destroy;
begin
  inherited;
end;

procedure TdsdTranslator.OnFormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin

  if (Shift = [ssCtrl]) and (GetKeyState(ord('L')) < 0) then
  begin
    if GetKeyState(ord('0')) < 0 then ShowMessage('CTRL+L+1 нажаты!');
  end;

  if Assigned (FOnFormKeyDown) then FOnFormKeyDown(Sender, Key, Shift);
end;

end.
