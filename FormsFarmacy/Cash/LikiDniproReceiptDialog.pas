unit LikiDniproReceiptDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ActnList, dsdAction,
  cxClasses, cxPropertiesStore, dsdAddOn, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.Menus,
  Vcl.StdCtrls, cxButtons, cxTextEdit, Vcl.ExtCtrls, dsdGuides, dsdDB,
  cxMaskEdit, cxButtonEdit, AncestorBase, dxSkinsCore, dxSkinsDefaultPainters,
  Vcl.ComCtrls, dxCore, cxDateUtils, cxDropDownEdit, cxCalendar, cxLabel,
  dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee,
  dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, System.Actions;

type
  TLikiDniproReceiptDialogForm = class(TAncestorBaseForm)
    cePartnerMedical: TcxButtonEdit;
    PartnerMedicalGuides: TdsdGuides;
    Label1: TLabel;
    Label2: TLabel;
    cxLabel13: TcxLabel;
    edCreated: TcxDateEdit;
    cxLabel14: TcxLabel;
    edRecipe_Number: TcxTextEdit;
    edMedicSP: TcxButtonEdit;
    MedicSPGuides: TdsdGuides;
    Label3: TLabel;
    edSPKind: TcxButtonEdit;
    SPKindGuides: TdsdGuides;
    spGet_SPKind: TdsdStoredProc;
    Panel1: TPanel;
    Panel2: TPanel;
    cxLabel22: TcxLabel;
    edMemberSP: TcxButtonEdit;
    GuidesMemberSP: TdsdGuides;
    spSelect_Object_MemberSP: TdsdStoredProc;
    spGet_Movement_InvNumberSP: TdsdStoredProc;
    edValid_From: TcxDateEdit;
    cxLabel1: TcxLabel;
    edValid_To: TcxDateEdit;
    cxLabel2: TcxLabel;
    edInstitution_Name: TcxTextEdit;
    rdDoctor_Name: TcxTextEdit;
    edPatient_Name: TcxTextEdit;
    Panel4: TPanel;
    bbCancel: TcxButton;
    bbOk: TcxButton;
    actFormClose: TdsdFormClose;
    procedure bbOkClick(Sender: TObject);
    procedure DiscountExternalGuidesAfterChoice(Sender: TObject);
  private
    { Private declarations }
  public
  end;

function ShowLikiDniproReceiptDialog : boolean;


implementation

{$R *.dfm}

uses IniUtils, RegularExpressions, LikiDniproReceipt, MainCash2;

procedure TLikiDniproReceiptDialogForm.bbOkClick(Sender: TObject);
  var Key :Integer;
begin
  if LikiDniproReceiptApi.Recipe.FRecipe_Type = 2 then
  begin

//    try StrToDate(edOperDateSP.Text)
//    except
//          ActiveControl:=edOperDateSP;
//          ShowMessage ('Ошибка.Значение <Дата рецепта> не определено');
//          ModalResult:=mrNone; // не надо закрывать
//          exit;
//    end;
//    if StrToDate(edOperDateSP.Text) < NOW - 30 then
//    begin ActiveControl:=edOperDateSP;
//          ShowMessage ('Ошибка.Значение <Дата рецепта> не может быть раньше чем <'+DateToStr(NOW - 30)+'>');
//          ModalResult:=mrNone; // не надо закрывать
//          exit;
//    end;
//    if StrToDate(edOperDateSP.Text) > NOW then
//    begin ActiveControl:=edOperDateSP;
//          ShowMessage ('Ошибка.Значение <Дата рецепта> не может быть позже чем <'+DateToStr(NOW)+'>');
//          ModalResult:=mrNone; // не надо закрывать
//          exit;
//    end;
//    if trim (edInvNumberSP.Text) = '' then
//    begin ActiveControl:=edInvNumberSP;
//          ShowMessage ('Ошибка.Значение <Номер рецепта> не определено');
//          ModalResult:=mrNone; // не надо закрывать
//          exit;
//    end;
//
//    try Key:= SPKindGuides.Params.ParamByName('Key').Value; except Key:= 0;end;
//    if Key = 0 then
//    begin
//          ActiveControl:=edSPKind;
//          ShowMessage ('Внимание.Значение <Вид соц.проекта> не установлено.');
//          ModalResult:=mrNone; // не надо закрывать
//          exit;
//    end;
//
//    if not Panel2.Visible and not CheckInvNumberSP(Key, edInvNumberSP.Text) then
//    begin ActiveControl:=edInvNumberSP;
//          ModalResult:=mrNone; // не надо закрывать
//          exit;
//    end;
//
//    if Panel2.Visible then
//    begin
//
//      if trim (edMedicSP.Text) = '' then
//      begin ActiveControl:=edMedicSP;
//            ShowMessage ('Ошибка.Значение <ФИО врача> не определено');
//            ModalResult:=mrNone; // не надо закрывать
//            exit;
//      end;
//      //
//
//      try Key:= GuidesMemberSP.Params.ParamByName('Key').Value; except Key:= 0;end;
//      if Key = 0 then
//      begin
//            ActiveControl:=edMemberSP;
//            ShowMessage ('Внимание.Значение <ФИО пациента> не установлено.');
//            ModalResult:=mrNone; // не надо закрывать
//            exit;
//      end;
//
//      try Key:= PartnerMedicalGuides.Params.ParamByName('Key').Value; except Key:= 0;end;
//      if Key = 0 then
//      begin
//            ActiveControl:=cePartnerMedical;
//            ShowMessage ('Внимание.Значение <Медицинское учреждение> не установлено.');
//            ModalResult:=mrOk; // ??? может не надо закрывать
//      end else ModalResult:=mrOk;
//    end
//    // а здесь уже все ОК
//    else ModalResult:=mrOk;
  end;

  ModalResult:=mrOk;
end;

procedure TLikiDniproReceiptDialogForm.DiscountExternalGuidesAfterChoice(Sender: TObject);
begin
  ActiveControl:= cePartnerMedical;
  inherited;
end;

function ShowLikiDniproReceiptDialog : boolean;
  var LikiDniproReceiptDialog : TLikiDniproReceiptDialogForm;
begin

  if LikiDniproReceiptApi.PositionCDS.IsEmpty then
  begin
    ShowMessage('Медикаменты не найдены.');
    Exit;
  end;

  LikiDniproReceiptDialog := TLikiDniproReceiptDialogForm.Create(Screen.ActiveControl);
  try
    LikiDniproReceiptDialog.edRecipe_Number.Text := LikiDniproReceiptApi.Recipe.FRecipe_Number;
    LikiDniproReceiptDialog.edCreated.Date := LikiDniproReceiptApi.Recipe.FRecipe_Created;
    if LikiDniproReceiptApi.Recipe.FRecipe_Valid_From = Null then
    begin
      LikiDniproReceiptDialog.cxLabel1.Visible := False;
      LikiDniproReceiptDialog.edValid_From.Visible := False;
    end else LikiDniproReceiptDialog.edValid_From.Date := LikiDniproReceiptApi.Recipe.FRecipe_Valid_From;
    if LikiDniproReceiptApi.Recipe.FRecipe_Valid_From = Null then
    begin
      LikiDniproReceiptDialog.cxLabel2.Visible := False;
      LikiDniproReceiptDialog.edValid_To.Visible := False;
    end else LikiDniproReceiptDialog.edValid_To.Date := LikiDniproReceiptApi.Recipe.FRecipe_Valid_To;

    LikiDniproReceiptDialog.edInstitution_Name.Text := LikiDniproReceiptApi.Recipe.FInstitution_Name;
    LikiDniproReceiptDialog.rdDoctor_Name.Text := LikiDniproReceiptApi.Recipe.FDoctor_Name;
    LikiDniproReceiptDialog.edPatient_Name.Text := LikiDniproReceiptApi.Recipe.FPatient_Name;

    if LikiDniproReceiptApi.Recipe.FRecipe_Type = 2 then
    begin
      LikiDniproReceiptDialog.spGet_SPKind.Execute;
    end else
    begin
      LikiDniproReceiptDialog.edSPKind.Visible := False;
      LikiDniproReceiptDialog.Label3.Caption := 'Рецепт за полную стоимость.';
      LikiDniproReceiptDialog.Label3.Font.Size := Round(LikiDniproReceiptDialog.Label3.Font.Size * 1.5);
      LikiDniproReceiptDialog.Label3.Font.Color := clRed;
      LikiDniproReceiptDialog.cePartnerMedical.Visible := False;
      LikiDniproReceiptDialog.edValid_To.Visible := False;
      LikiDniproReceiptDialog.edMedicSP.Visible := False;
      LikiDniproReceiptDialog.edMemberSP.Visible := False;
    end;

    Result := LikiDniproReceiptDialog.ShowModal = mrOk;
  finally
    LikiDniproReceiptDialog.Free;
  end;
end;

End.
