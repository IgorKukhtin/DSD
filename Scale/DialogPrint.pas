unit DialogPrint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AncestorDialogScale, StdCtrls, Mask, Buttons,
  ExtCtrls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus,
  dxSkinsCore, dxSkinsDefaultPainters, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxCurrencyEdit, dsdDB, Vcl.ActnList, dsdAction, cxPropertiesStore,
  dsdAddOn, cxButtons, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue, Vcl.ComCtrls, dxCore, cxDateUtils, cxMaskEdit,
  cxDropDownEdit, cxCalendar;

type
  TDialogPrintForm = class(TAncestorDialogScaleForm)
    PrintPanel: TPanel;
    PrintCountEdit: TcxCurrencyEdit;
    PrintCountLabel: TLabel;
    PrintIsValuePanel: TPanel;
    cbPrintMovement: TCheckBox;
    cbPrintAccount: TCheckBox;
    cbPrintTransport: TCheckBox;
    cbPrintQuality: TCheckBox;
    cbPrintPack: TCheckBox;
    cbPrintSpec: TCheckBox;
    cbPrintTax: TCheckBox;
    cbPrintPreview: TCheckBox;
    cbPrintPackGross: TCheckBox;
    cbPrintDiffOrder: TCheckBox;
    PanelDateValue: TPanel;
    LabelDateValue: TLabel;
    DateValueEdit: TcxDateEdit;
    PanelComment: TPanel;
    Label1: TLabel;
    PanelInvNumberPartner: TPanel;
    Label4: TLabel;
    CommentEdit: TEdit;
    InvNumberPartnerEdit: TEdit;
    PanelDiscountAmountPartner: TPanel;
    Label2: TLabel;
    rgDiscountAmountPartner: TRadioGroup;
    DiscountAmountPartnerEdit: TcxCurrencyEdit;
    btnSaveAll: TBitBtn;
    procedure cbPrintTransportClick(Sender: TObject);
    procedure cbPrintQualityClick(Sender: TObject);
    procedure cbPrintTaxClick(Sender: TObject);
    procedure cbPrintAccountClick(Sender: TObject);
    procedure cbPrintPackClick(Sender: TObject);
    procedure cbPrintSpecClick(Sender: TObject);
    procedure DateValueEditPropertiesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveAllClick(Sender: TObject);
    procedure bbOkClick(Sender: TObject);
    procedure DiscountAmountPartnerEditExit(Sender: TObject);
  private
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    function Execute(MovementDescId:Integer;CountMovement:Integer; isMovement, isAccount, isTransport, isQuality, isPack, isPackGross, isSpec, isTax : Boolean): Boolean; virtual;
  end;

var
   DialogPrintForm: TDialogPrintForm;

implementation
{$R *.dfm}
uses UtilScale, DMMainScale, Data.DB;
{------------------------------------------------------------------------------}
function TDialogPrintForm.Execute(MovementDescId:Integer;CountMovement:Integer; isMovement, isAccount, isTransport, isQuality, isPack, isPackGross, isSpec, isTax : Boolean): Boolean; //Проверка корректного ввода в Edit
begin
     // для ScaleCeh только одна печать
     if (SettingMain.isCeh = TRUE)or((MovementDescId<>zc_Movement_Sale)and(MovementDescId<>zc_Movement_SendOnPrice))
     then cbPrintMovement.Checked:= TRUE
     else cbPrintMovement.Checked:= isMovement;
     //
     if SettingMain.isOperDatePartner = TRUE
     then ParamsMovement.ParamByName('isOperDatePartner').AsBoolean:= TRUE
     else ParamsMovement.ParamByName('isOperDatePartner').AsBoolean:= DMMainScaleForm.gpGet_Scale_Movement_OperDatePartner(ParamsMovement);
     PanelDateValue.Visible:= ParamsMovement.ParamByName('isOperDatePartner').AsBoolean = TRUE;
     //
     PanelInvNumberPartner.Visible:= (SettingMain.isCeh = FALSE) and (ParamsMovement.ParamByName('isInvNumberPartner').AsBoolean = true);
     InvNumberPartnerEdit.Text:= ParamsMovement.ParamByName('InvNumberPartner').AsString;
     CommentEdit.Text:='';
     PanelComment.Visible:= (SettingMain.isCeh = FALSE) and (ParamsMovement.ParamByName('isComment').AsBoolean = true) and (ParamsMovement.ParamByName('MovementDescId').AsInteger <> zc_Movement_Loss);

     PanelDiscountAmountPartner.Visible:= // если НЕ док. поставшика
                                          (ParamsMovement.ParamByName('isDocPartner').AsBoolean = FALSE)
                                      // если нужен док. поставшика
                                      and (ParamsMovement.ParamByName('isInvNumberPartner').AsBoolean = TRUE)
                                      // если проверка док. поставшика
                                      and (ParamsMovement.ParamByName('isInvNumberPartner_check').AsBoolean = TRUE)
                                     ;
     btnSaveAll.Visible:= // если НЕ док. поставшика
                          (ParamsMovement.ParamByName('isDocPartner').AsBoolean = FALSE)
                      // если нужен док. поставшика
                      and (ParamsMovement.ParamByName('isInvNumberPartner').AsBoolean = TRUE)
                      // если проверка док. поставшика
                      and (ParamsMovement.ParamByName('isInvNumberPartner_check').AsBoolean = TRUE)
                     ;
     if btnSaveAll.Visible then
     begin
         bbOk.Left:= 10;
         bbCancel.Left:= 217;
     end
     else
     begin
         bbOk.Left:= 44;
         bbCancel.Left:= 167;
     end;
     //
     rgDiscountAmountPartner.ItemIndex:= -1;
     DiscountAmountPartnerEdit.Text:= '0';
     //
     Self.Height:= 458; //384;
     if not PanelInvNumberPartner.Visible then Self.Height:= Self.Height - PanelInvNumberPartner.Height;
     if not PanelComment.Visible then Self.Height:= Self.Height - PanelComment.Height;
     if not PanelDateValue.Visible then Self.Height:= Self.Height - PanelDateValue.Height;
     if not PanelDiscountAmountPartner.Visible then Self.Height:= Self.Height - PanelDiscountAmountPartner.Height;
     //
     cbPrintPackGross.Checked:= FALSE;
     cbPrintDiffOrder.Checked:= FALSE;//(MovementDescId=zc_Movement_Sale)or(MovementDescId=zc_Movement_SendOnPrice);
     //
     cbPrintAccount.Enabled:=(SettingMain.isCeh = FALSE);//or(MovementDescId=zc_Movement_Sale)or(MovementDescId<>zc_Movement_SendOnPrice);
     cbPrintTransport.Enabled:=cbPrintAccount.Enabled;
     cbPrintQuality.Enabled:=cbPrintAccount.Enabled;
     cbPrintPack.Enabled:=cbPrintAccount.Enabled;
     cbPrintSpec.Enabled:=cbPrintAccount.Enabled;
     cbPrintTax.Enabled:=cbPrintAccount.Enabled;
     cbPrintDiffOrder.Enabled:=cbPrintAccount.Enabled;
     //cbPrintPackGross.Enabled:=cbPrintAccount.Enabled;
     //
     cbPrintAccount.Checked:=(isAccount) and (cbPrintAccount.Enabled);
     cbPrintTransport.Checked:=(isTransport) and (cbPrintTransport.Enabled);
     cbPrintQuality.Checked:=(isQuality) and (cbPrintQuality.Enabled);
     cbPrintPack.Checked:=(isPack) and (cbPrintPack.Enabled);
     cbPrintSpec.Checked:=(isSpec) and (cbPrintSpec.Enabled);
     cbPrintTax.Checked:=(isTax) and (cbPrintTax.Enabled);
     //
     cbPrintPreview.Checked:=GetArrayList_Value_byName(Default_Array,'isPrintPreview') = AnsiUpperCase('TRUE');
     if SettingMain.isCeh = FALSE
     then PrintCountEdit.Text:=IntToStr(CountMovement)
     else PrintCountEdit.Text:=GetArrayList_Value_byName(Default_Array,'PrintCount');
     //
     DateValueEdit.Text:= DateToStr(ParamsMovement.ParamByName('OperDatePartner').AsDateTime);
     PanelDateValue.Visible:= ParamsMovement.ParamByName('isOperDatePartner').AsBoolean = TRUE;
     //
     ActiveControl:=PrintCountEdit;
     //
     if ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Income
     then LabelDateValue.Caption:='Дата у поставщика'
     else LabelDateValue.Caption:='Дата у покупателя';
     //
     Result:=(ShowModal=mrOk);
end;


procedure TDialogPrintForm.FormCreate(Sender: TObject);
begin
  inherited;
  Self.OnResize:= nil;
end;

function TDialogPrintForm.Checked: boolean; //Проверка корректного ввода в Edit
var str_pok_post:String;
    execParams:TParams;
begin
     Result:=false;
     //
     if ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Income
     then str_pok_post:='поставщика'
     else str_pok_post:='покупателя';

     // если ЭТО док. поставшика
     if (ParamsMovement.ParamByName('isDocPartner').AsBoolean = TRUE)
        // еи НЕ заполнили
        and (trim(InvNumberPartnerEdit.Text) = '')
     then begin
               ShowMessage('Ошибка.Необходимо заполнить Документ Поставщика №.');
               ActiveControl:=InvNumberPartnerEdit;
               exit;
     end;
     //
     if (PanelInvNumberPartner.Visible = TRUE) and (InvNumberPartnerEdit.Text <> '') then
     begin
          Result:= DMMainScaleForm.gpUpdate_Scale_MovementString(ParamsMovement.ParamByName('MovementId').AsInteger
                                                               , 'zc_MovementString_InvNumberPartner'
                                                               , InvNumberPartnerEdit.Text
                                                                );
          if not Result then exit;
     end;
     if (PanelComment.Visible = TRUE) and (CommentEdit.Text <> '') then
     begin
          Result:= DMMainScaleForm.gpUpdate_Scale_MovementString(ParamsMovement.ParamByName('MovementId').AsInteger
                                                               , 'zc_MovementString_Comment'
                                                               , CommentEdit.Text
                                                                );
          if not Result then exit;
     end;
     //
     Result:=false;
     //
     if PanelDateValue.Visible = TRUE then
     begin
         try ParamsMovement.ParamByName('OperDatePartner').AsDateTime:= StrToDate(DateValueEdit.Text)
         except if ParamsMovement.ParamByName('isOperDatePartner').AsBoolean = true
                then begin
                     ShowMessage('Ошибка.Дата у '+str_pok_post+' сформирована неверно.');
                     exit;
                end
                // еще раз
                else ParamsMovement.ParamByName('isOperDatePartner').AsBoolean:= DMMainScaleForm.gpGet_Scale_Movement_OperDatePartner(ParamsMovement);
         end;
         //
         if ParamsMovement.ParamByName('MovementDescId').AsInteger = zc_Movement_Income
         then begin
               if (ParamsMovement.ParamByName('OperDatePartner').AsDateTime > ParamsMovement.ParamByName('OperDate').AsDateTime)
                  and (ParamsMovement.ParamByName('MovementId_find').AsInteger = 0)
               then begin
                           ShowMessage('Ошибка.Дата у '+str_pok_post+' = <'+DateToStr(ParamsMovement.ParamByName('OperDatePartner').AsDateTime)+'> не может быть позже даты документа = <'+DateToStr(ParamsMovement.ParamByName('OperDate').AsDateTime)+'>.');
                           exit;
               end;
               if ParamsMovement.ParamByName('OperDatePartner').AsDateTime + 14 < ParamsMovement.ParamByName('OperDate').AsDateTime
               then begin
                           ShowMessage('Ошибка.Дата у '+str_pok_post+' = <'+DateToStr(ParamsMovement.ParamByName('OperDatePartner').AsDateTime)+'> не может быть раньше даты документа = <'+DateToStr(ParamsMovement.ParamByName('OperDate').AsDateTime)+'> более чем на 14 дней.');
                           exit;
               end;
         end
         else begin
               if (ParamsMovement.ParamByName('OperDatePartner').AsDateTime < ParamsMovement.ParamByName('OperDate').AsDateTime)
                  and (ParamsMovement.ParamByName('MovementId_find').AsInteger = 0)
               then begin
                           ShowMessage('Ошибка.Дата у '+str_pok_post+' = <'+DateToStr(ParamsMovement.ParamByName('OperDatePartner').AsDateTime)+'> не может быть раньше даты документа = <'+DateToStr(ParamsMovement.ParamByName('OperDate').AsDateTime)+'>.');
                           exit;
               end;
               if ParamsMovement.ParamByName('OperDatePartner').AsDateTime > 14 + ParamsMovement.ParamByName('OperDate').AsDateTime
               then begin
                           ShowMessage('Ошибка.Дата у '+str_pok_post+' = <'+DateToStr(ParamsMovement.ParamByName('OperDatePartner').AsDateTime)+'> не может быть позже даты документа = <'+DateToStr(ParamsMovement.ParamByName('OperDate').AsDateTime)+'> более чем на 14 дней.');
                           exit;
               end;
         end;
     end;
     //
     try ParamsMovement.ParamByName('DiscountAmountPartner').AsFloat:= StrToFloat(DiscountAmountPartnerEdit.Text)
     except ParamsMovement.ParamByName('DiscountAmountPartner').AsFloat:= 0;
     end;
     if (rgDiscountAmountPartner.ItemIndex = -1) and (ParamsMovement.ParamByName('DiscountAmountPartner').AsFloat > 0)
     then begin
               ShowMessage('Ошибка.Для скидки по весу '+DiscountAmountPartnerEdit.Text+'% необходимо выбрать вид скидки.');
               ActiveControl:= rgDiscountAmountPartner;
               exit;
     end;
     if (rgDiscountAmountPartner.ItemIndex >= 0) and (ParamsMovement.ParamByName('DiscountAmountPartner').AsFloat = 0)
     then begin
               ShowMessage('Ошибка.Для скидки '+rgDiscountAmountPartner.Items[rgDiscountAmountPartner.ItemIndex]+' необходимо заполнить % скидки по весу.');
               ActiveControl:= DiscountAmountPartnerEdit;
               exit;
     end;
     //
     ParamsMovement.ParamByName('isDiscount_q').AsBoolean:= rgDiscountAmountPartner.ItemIndex = 0;
     ParamsMovement.ParamByName('isDiscount_t').AsBoolean:= rgDiscountAmountPartner.ItemIndex = 1;
     //
     if (ParamsMovement.ParamByName('DiscountAmountPartner').AsFloat > 0) or(rgDiscountAmountPartner.ItemIndex >=0) then
     begin
          Result:= DMMainScaleForm.gpUpdate_Scale_Movement_ChangePercentAmount(ParamsMovement);
          if not Result then exit;
     end;

     //
     try Result:=(StrToInt(PrintCountEdit.Text)>0) and (StrToInt(PrintCountEdit.Text)<11);
     except Result:=false;
     end;
     //
     if not Result then ShowMessage('Ошибка.Значение <Кол-во копий> не попадает в диапазон от <1> до <10>.');
     //
     //
     if (ParamsMovement.ParamByName('isOperDatePartner').AsBoolean = true)
     and (SettingMain.isOperDatePartner = FALSE)
     then
         if MessageDlg('Документ будет сформирован'+#10+#13+'с Датой ' +str_pok_post+ ' =  <'+DateToStr(ParamsMovement.ParamByName('OperDatePartner').AsDateTime)+'>.'+#10+#13+'Продолжить?',mtConfirmation,mbYesNoCancel,0) <> 6
         then begin
            Result:=false;
            exit;
         end
         else begin
                  execParams:=nil;
                  ParamAddValue(execParams,'inMovementId',ftInteger,ParamsMovement.ParamByName('MovementId').AsInteger);
                  ParamAddValue(execParams,'inDescCode',ftString,'zc_MovementDate_OperDatePartner');
                  ParamAddValue(execParams,'inValueData',ftDateTime,ParamsMovement.ParamByName('OperDatePartner').AsDateTime);
                  //
                  DMMainScaleForm.gpUpdate_Scale_MovementDate(execParams);
         end;
end;
{------------------------------------------------------------------------------}
procedure TDialogPrintForm.DateValueEditPropertiesChange(Sender: TObject);
begin
  inherited;
  if SettingMain.isOperDatePartner = TRUE
  then DateValueEdit.Text:= DateToStr(ParamsMovement.ParamByName('OperDatePartner').AsDateTime);
end;
{------------------------------------------------------------------------------}
procedure TDialogPrintForm.DiscountAmountPartnerEditExit(Sender: TObject);
begin
  if (trim(DiscountAmountPartnerEdit.Text) = '') OR (trim(DiscountAmountPartnerEdit.Text) = '0')
  then rgDiscountAmountPartner.ItemIndex:= -1;
end;
{------------------------------------------------------------------------------}
procedure TDialogPrintForm.cbPrintTransportClick(Sender: TObject);
begin
     if cbPrintTransport.Checked
     then
         if  (ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_Sale)
          and(ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_SendOnPrice)
         then cbPrintTransport.Checked:=false;
end;
{------------------------------------------------------------------------------}
procedure TDialogPrintForm.cbPrintQualityClick(Sender: TObject);
begin
     if cbPrintQuality.Checked
     then
         if  (ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_Sale)
          and(ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_SendOnPrice)
          and(ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_Loss)
         then cbPrintQuality.Checked:=false;
end;
{------------------------------------------------------------------------------}
procedure TDialogPrintForm.cbPrintTaxClick(Sender: TObject);
begin
     if cbPrintTax.Checked
     then
         if  (ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_Sale)
          or (GetArrayList_Value_byName(Default_Array,'isTax') <> AnsiUpperCase('TRUE'))
         then cbPrintTax.Checked:=false;
end;
{------------------------------------------------------------------------------}
procedure TDialogPrintForm.bbOkClick(Sender: TObject);
begin
  ParamsMovement.ParamByName('isOpen_ActDiff').AsBoolean:= FALSE;
  inherited;
end;
{------------------------------------------------------------------------------}
procedure TDialogPrintForm.btnSaveAllClick(Sender: TObject);
begin
    ParamsMovement.ParamByName('isOpen_ActDiff').AsBoolean:= TRUE;
    //
    if Checked
    then ModalResult:=mrOk;
end;
{------------------------------------------------------------------------------}
procedure TDialogPrintForm.cbPrintAccountClick(Sender: TObject);
begin
     if cbPrintAccount.Checked
     then
         if  (ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_Sale)
         then cbPrintAccount.Checked:=false;
end;
{------------------------------------------------------------------------------}
procedure TDialogPrintForm.cbPrintPackClick(Sender: TObject);
begin
     if cbPrintPack.Checked
     then
         if  (ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_Sale)and(ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_SendOnPrice)
         then cbPrintPack.Checked:=false;
end;
{------------------------------------------------------------------------------}
procedure TDialogPrintForm.cbPrintSpecClick(Sender: TObject);
begin
     if cbPrintSpec.Checked
     then
         if  (ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_Sale)and(ParamsMovement.ParamByName('MovementDescId').AsInteger<>zc_Movement_SendOnPrice)
         then cbPrintSpec.Checked:=false;
end;
{------------------------------------------------------------------------------}
end.
