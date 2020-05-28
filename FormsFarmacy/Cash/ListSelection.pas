unit ListSelection;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinsDefaultPainters,
  cxControls, cxContainer, cxEdit, cxCustomListBox, cxListBox, Vcl.StdCtrls,
  cxButtons, Vcl.ExtCtrls;

type
  TListSelectionForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    bbCancel: TcxButton;
    bbOk: TcxButton;
    cxListBox1: TcxListBox;
    procedure cxListBox1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function ShowListSelection(ACaption : String; AList : Array of String;  ADefault : Integer) : Integer;

implementation

{$R *.dfm}

procedure TListSelectionForm.cxListBox1DblClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;


function ShowListSelection(ACaption : String; AList : Array of String;  ADefault : Integer) : Integer;
  var Form : TListSelectionForm; I : Integer;
begin
  Result := 0;

  Form := TListSelectionForm.Create(Screen.ActiveForm);
  try
    Form.Caption := ACaption;
    for I := Low(AList) to High(AList) do Form.cxListBox1.Items.Add(AList[I]);

    if (Low(AList) < ADefault) and (ADefault <= (High(AList) + 1)) then
      Form.cxListBox1.ItemIndex := ADefault - 1
    else Form.cxListBox1.ItemIndex := 0;

    if Form.ShowModal = mrOk then
      Result := Form.cxListBox1.ItemIndex + 1;
  finally
    Form.Free;
  end;

end;

end.
