
unit EnterBuyerForSite;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinsDefaultPainters,
  Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, dsdDB;

type
  TEnterBuyerForSiteForm = class(TForm)
    bbCancel: TcxButton;
    bbOk: TcxButton;
    edMaskNumber: TcxMaskEdit;
    Label1: TLabel;
    pn1: TPanel;
    pn2: TPanel;
    spGet_BuyerForSiteId: TdsdStoredProc;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FBuyerForSiteId : Integer;
  public
    { Public declarations }
  end;

function InputEnterBuyerForSite(var ABuyerForSiteId : Integer; var ABuyerForSite : String) : boolean;

implementation

{$R *.dfm}

procedure TEnterBuyerForSiteForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
  var nCode : Integer;
begin
  if ModalResult = mrOk then
  begin
    if Length(edMaskNumber.Text) < 2 then
    begin
      ShowMessage('Количество символов должно быть не менее 2.');
      Action := caNone;
      Exit;
    end;

    if not TryStrToInt(Copy(edMaskNumber.Text, 1, Length(edMaskNumber.Text) - 1), nCode) then
    begin
      ShowMessage('Ошибка преобразования кода.');
      Action := caNone;
      Exit;
    end;

    spGet_BuyerForSiteId.ParamByName('inCode').Value := nCode;
    spGet_BuyerForSiteId.ParamByName('outId').Value := 0;
    spGet_BuyerForSiteId.Execute;

    if spGet_BuyerForSiteId.ParamByName('outId').Value = 0 then
    begin
      ShowMessage('Покупатель с кодом ' + IntToStr(nCode) + ' не найден.');
      Action := caNone;
      Exit;
    end;

    FBuyerForSiteId := spGet_BuyerForSiteId.ParamByName('outId').Value;
  end;
end;

procedure TEnterBuyerForSiteForm.FormCreate(Sender: TObject);
begin
  FBuyerForSiteId := 0;
end;

function InputEnterBuyerForSite(var ABuyerForSiteId : Integer; var ABuyerForSite : String) : boolean;
  var EnterBuyerForSiteForm : TEnterBuyerForSiteForm;
begin
  EnterBuyerForSiteForm := TEnterBuyerForSiteForm.Create(Screen.ActiveControl);
  try
    EnterBuyerForSiteForm.edMaskNumber.Text := ABuyerForSite;
    Result := EnterBuyerForSiteForm.ShowModal = mrOk;
    if Result then
    begin
      ABuyerForSite := EnterBuyerForSiteForm.edMaskNumber.Text;
      ABuyerForSiteId := EnterBuyerForSiteForm.FBuyerForSiteId;
    end;
  finally
    EnterBuyerForSiteForm.Free;
  end;
end;

end.
