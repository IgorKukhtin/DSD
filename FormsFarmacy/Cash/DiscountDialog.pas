unit DiscountDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, Vcl.ActnList, dsdAction,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters,
  System.Actions;

type
  TDiscountDialogForm = class(TAncestorDialogForm)
    ceDiscountExternal: TcxButtonEdit;
    DiscountExternalGuides: TdsdGuides;
    Label1: TLabel;
    edCardNumber: TcxTextEdit;
    Label2: TLabel;
    procedure bbOkClick(Sender: TObject);
    procedure DiscountExternalGuidesAfterChoice(Sender: TObject);
  private
    { Private declarations }
  public
     function DiscountDialogExecute(var ADiscountExternalId: Integer; var ADiscountExternalName, ADiscountCardNumber: String): boolean;
  end;


implementation
{$R *.dfm}
uses DiscountService;

procedure TDiscountDialogForm.bbOkClick(Sender: TObject);
var Key :Integer;
    lMsg:String;
begin
  try Key:= DiscountExternalGuides.Params.ParamByName('Key').Value; except Key:= 0;end;
  //
  if Key > 0
  then
      if trim (edCardNumber.Text) <> '' then
      begin
           //������� "������" ���������-Main ***20.07.16
           DiscountServiceForm.pGetDiscountExternal (Key, trim (edCardNumber.Text));
           // �������� ����� + �������� "�������" ���������-Main
           if DiscountServiceForm.gCode = 1 then
           begin
             if DiscountServiceForm.fCheckCard (lMsg
                                               ,DiscountServiceForm.gURL
                                               ,DiscountServiceForm.gService
                                               ,DiscountServiceForm.gPort
                                               ,DiscountServiceForm.gUserName
                                               ,DiscountServiceForm.gPassword
                                               ,trim (edCardNumber.Text)
                                               ,Key
                                               )
             then ModalResult := mrOk;
           end
           else if DiscountServiceForm.gCode > 0 then ModalResult := mrOk;
      end
      else begin ActiveControl:=edCardNumber;ShowMessage ('������.�������� <� ���������� �����> �� ����������');end
  else begin ActiveControl:=ceDiscountExternal;
             ShowMessage ('��������.�������� <������> �� �����������.');
             ModalResult:=mrOk; // ??? ����� �� ���� ���������
       end;

end;

function TDiscountDialogForm.DiscountDialogExecute(var ADiscountExternalId: Integer; var ADiscountExternalName, ADiscountCardNumber: String): boolean;
Begin
      edCardNumber.Text:= ADiscountCardNumber;
      //
      DiscountExternalGuides.Params.ParamByName('Key').Value      := ADiscountExternalId;
      DiscountExternalGuides.Params.ParamByName('TextValue').Value:='';
      if ADiscountExternalId > 0 then
      begin
          ceDiscountExternal.Text:= ADiscountExternalName;
          DiscountExternalGuides.Params.ParamByName('TextValue').Value:=ADiscountExternalName;
      end;
      //
      Result := ShowModal = mrOK;
      if Result then
      begin
        try ADiscountExternalId := DiscountExternalGuides.Params.ParamByName('Key').Value;
        except
            ADiscountExternalId := 0;
            DiscountExternalGuides.Params.ParamByName('Key').Value:= 0;
        end;
        ADiscountExternalName := DiscountExternalGuides.Params.ParamByName('TextValue').Value;
        ADiscountCardNumber   := trim (edCardNumber.Text);
      end
      else begin
            ADiscountExternalId   := 0;
            ADiscountExternalName := '';
            ADiscountCardNumber   := '';
           end;
end;

procedure TDiscountDialogForm.DiscountExternalGuidesAfterChoice(Sender: TObject);
begin
  ActiveControl:= edCardNumber;
  inherited;
end;

End.
