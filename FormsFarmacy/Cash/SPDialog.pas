unit SPDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AncestorDialog, Vcl.ActnList, dsdAction,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxDropDownEdit, cxCalendar, cxLabel;

type
  TSPDialogForm = class(TAncestorDialogForm)
    cePartnerMedical: TcxButtonEdit;
    PartnerMedicalGuides: TdsdGuides;
    Label1: TLabel;
    Label2: TLabel;
    cxLabel13: TcxLabel;
    edOperDateSP: TcxDateEdit;
    cxLabel14: TcxLabel;
    edInvNumberSP: TcxTextEdit;
    cxLabel17: TcxLabel;
    edAmbulance: TcxTextEdit;
    edMedicSP: TcxButtonEdit;
    MedicSPGuides: TdsdGuides;
    Label3: TLabel;
    edSPKind: TcxButtonEdit;
    SPKindGuides: TdsdGuides;
    spGet_SPKind_def: TdsdStoredProc;
    procedure bbOkClick(Sender: TObject);
    procedure DiscountExternalGuidesAfterChoice(Sender: TObject);
  private
    { Private declarations }
  public
     function DiscountDialogExecute(var APartnerMedicalId, ASPKindId: Integer; var APartnerMedicalName, AAmbulance, AMedicSP, AInvNumberSP, ASPKindName: String; var AOperDateSP : TDateTime; var ASPTax : Currency): boolean;
  end;


implementation
{$R *.dfm}
uses DiscountService;

procedure TSPDialogForm.bbOkClick(Sender: TObject);
var Key :Integer;
begin
    try StrToDate(edOperDateSP.Text)
    except
          ActiveControl:=edOperDateSP;
          ShowMessage ('������.�������� <���� �������> �� ����������');
          ModalResult:=mrNone; // �� ���� ���������
          exit;
    end;
    if StrToDate(edOperDateSP.Text) < NOW - 30 then
    begin ActiveControl:=edOperDateSP;
          ShowMessage ('������.�������� <���� �������> �� ����� ���� ������ ��� <'+DateToStr(NOW - 30)+'>');
          ModalResult:=mrNone; // �� ���� ���������
          exit;
    end;
    if StrToDate(edOperDateSP.Text) > NOW then
    begin ActiveControl:=edOperDateSP;
          ShowMessage ('������.�������� <���� �������> �� ����� ���� ����� ��� <'+DateToStr(NOW)+'>');
          ModalResult:=mrNone; // �� ���� ���������
          exit;
    end;
    if trim (edInvNumberSP.Text) = '' then
    begin ActiveControl:=edInvNumberSP;
          ShowMessage ('������.�������� <����� �������> �� ����������');
          ModalResult:=mrNone; // �� ���� ���������
          exit;
    end;
    if trim (edAmbulance.Text) = '' then
    begin ActiveControl:=edAmbulance;
          ShowMessage ('������.�������� <� �����������> �� ����������');
          ModalResult:=mrNone; // �� ���� ���������
          exit;
    end;
    if trim (edMedicSP.Text) = '' then
    begin ActiveControl:=edMedicSP;
          ShowMessage ('������.�������� <��� �����> �� ����������');
          ModalResult:=mrNone; // �� ���� ���������
          exit;
    end;
    //
    try Key:= SPKindGuides.Params.ParamByName('Key').Value; except Key:= 0;end;
    if Key = 0 then
    begin
          ActiveControl:=edSPKind;
          ShowMessage ('��������.�������� <��� ���.�������:> �� �����������.');
          ModalResult:=mrNone; // �� ���� ���������
    end;
    //
    try Key:= PartnerMedicalGuides.Params.ParamByName('Key').Value; except Key:= 0;end;
    if Key = 0 then
    begin
          ActiveControl:=cePartnerMedical;
          ShowMessage ('��������.�������� <����������� ����������> �� �����������.');
          ModalResult:=mrOk; // ??? ����� �� ���� ���������
    end
    // � ����� ��� ��� ��
    else ModalResult:=mrOk;

end;

function TSPDialogForm.DiscountDialogExecute(var APartnerMedicalId, ASPKindId: Integer; var APartnerMedicalName, AAmbulance, AMedicSP, AInvNumberSP, ASPKindName: String; var AOperDateSP : TDateTime; var ASPTax : Currency): boolean;
Begin
      edAmbulance.Text:= AAmbulance;
      edMedicSP.Text:= AMedicSP;
      edInvNumberSP.Text:= AInvNumberSP;
      edOperDateSP.Text:= DateToStr(aOperDateSP);
      edSPKind.Text:= AInvNumberSP;
      //
      PartnerMedicalGuides.Params.ParamByName('Key').Value      := APartnerMedicalId;
      PartnerMedicalGuides.Params.ParamByName('TextValue').Value:= '';
      if APartnerMedicalId > 0 then
      begin
          cePartnerMedical.Text:= APartnerMedicalName;
          PartnerMedicalGuides.Params.ParamByName('TextValue').Value:= APartnerMedicalName;
      end;
      //
      SPKindGuides.Params.ParamByName('Key').Value      := ASPKindId;
      SPKindGuides.Params.ParamByName('TextValue').Value:= '';
      FormParams.ParamByName('SPTax').Value:=ASPTax;

      if ASPKindId > 0 then
      begin
          edSPKind.Text:= ASPKindName;
          SPKindGuides.Params.ParamByName('TextValue').Value:= ASPKindName;
      end
      else spGet_SPKind_def.Execute;

      //
      Result := ShowModal = mrOK;
      //
      if Result then
      begin
        try APartnerMedicalId := PartnerMedicalGuides.Params.ParamByName('Key').Value;
        except
            APartnerMedicalId := 0;
            PartnerMedicalGuides.Params.ParamByName('Key').Value:= 0;
        end;
        APartnerMedicalName   := PartnerMedicalGuides.Params.ParamByName('TextValue').Value;
        AAmbulance:= trim (edAmbulance.Text);
        AMedicSP:= trim (edMedicSP.Text);
        AInvNumberSP:= trim (edInvNumberSP.Text);
        AOperDateSP:= StrToDate (edOperDateSP.Text);

        ASPTax:=FormParams.ParamByName('SPTax').Value;
        try ASPKindId := SPKindGuides.Params.ParamByName('Key').Value;
        except
            ASPKindId := 0;
            SPKindGuides.Params.ParamByName('Key').Value:= 0;
        end;
        ASPKindName   := SPKindGuides.Params.ParamByName('TextValue').Value;
      end
      else begin
              APartnerMedicalId   := 0;
              APartnerMedicalName := '';
              AAmbulance          := '';
              AMedicSP            := '';
              AInvNumberSP        := '';
              ASPTax              := 0;
              ASPKindId           := 0;
              ASPKindName         := '';
           end;
end;

procedure TSPDialogForm.DiscountExternalGuidesAfterChoice(Sender: TObject);
begin
  ActiveControl:= cePartnerMedical;
  inherited;
end;

End.
