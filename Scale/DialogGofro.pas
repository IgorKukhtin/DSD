unit DialogGofro;

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
  dxSkinXmas2008Blue, Vcl.ComCtrls, dxCore, cxDateUtils, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxCalendar, Data.DB, Datasnap.DBClient, dsdCommon,
  cxCheckBox;

type
  TDialogGofroForm = class(TAncestorDialogScaleForm)
    infoPanelSpace_2: TPanel;
    infoPanel_1: TPanel;
    infoPanelGoodsCode_1: TPanel;
    LabelGoodsCode_1: TLabel;
    infoPanelGoodsName_1: TPanel;
    LabelGoodsName_1: TLabel;
    ActionList: TActionList;
    actExec: TAction;
    EditGoodsCode_1: TcxCurrencyEdit;
    EditGoodsName_1: TcxButtonEdit;
    infoPanelAmount_1: TPanel;
    LabelAmount_1: TLabel;
    EditAmount_1: TcxCurrencyEdit;
    infoPanelSpace_1: TPanel;
    infoPanel_2: TPanel;
    infoPanelGoodsCode_2: TPanel;
    LabelGoodsCode_2: TLabel;
    EditGoodsCode_2: TcxCurrencyEdit;
    infoPanelGoodsName_2: TPanel;
    LabelGoodsName_2: TLabel;
    EditGoodsName_2: TcxButtonEdit;
    infoPanelAmount_2: TPanel;
    LabelAmount_2: TLabel;
    EditAmount_2: TcxCurrencyEdit;
    infoPanelSpace_last: TPanel;
    infoPanelSpace_8: TPanel;
    infoPanelSpace_7: TPanel;
    infoPanelSpace_6: TPanel;
    infoPanelSpace_5: TPanel;
    infoPanelSpace_4: TPanel;
    infoPanelSpace_3: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    EditGoodsCode_3: TcxCurrencyEdit;
    Panel3: TPanel;
    Label2: TLabel;
    EditGoodsName_3: TcxButtonEdit;
    Panel4: TPanel;
    Label3: TLabel;
    EditAmount_3: TcxCurrencyEdit;
    Panel5: TPanel;
    Panel6: TPanel;
    Label4: TLabel;
    EditGoodsCode_4: TcxCurrencyEdit;
    Panel7: TPanel;
    Label5: TLabel;
    EditGoodsName_4: TcxButtonEdit;
    Panel8: TPanel;
    Label6: TLabel;
    EditAmount_4: TcxCurrencyEdit;
    Panel9: TPanel;
    Panel10: TPanel;
    Label7: TLabel;
    EditGoodsCode_8: TcxCurrencyEdit;
    Panel11: TPanel;
    Label8: TLabel;
    EditGoodsName_8: TcxButtonEdit;
    Panel12: TPanel;
    Label9: TLabel;
    EditAmount_8: TcxCurrencyEdit;
    Panel13: TPanel;
    Panel14: TPanel;
    Label10: TLabel;
    EditGoodsCode_7: TcxCurrencyEdit;
    Panel15: TPanel;
    Label11: TLabel;
    EditGoodsName_7: TcxButtonEdit;
    Panel16: TPanel;
    Label12: TLabel;
    EditAmount_7: TcxCurrencyEdit;
    Panel17: TPanel;
    Panel18: TPanel;
    Label13: TLabel;
    EditGoodsCode_6: TcxCurrencyEdit;
    Panel19: TPanel;
    Label14: TLabel;
    EditGoodsName_6: TcxButtonEdit;
    Panel20: TPanel;
    Label15: TLabel;
    EditAmount_6: TcxCurrencyEdit;
    Panel21: TPanel;
    Panel22: TPanel;
    Label16: TLabel;
    EditGoodsCode_5: TcxCurrencyEdit;
    Panel23: TPanel;
    Label17: TLabel;
    EditGoodsName_5: TcxButtonEdit;
    Panel24: TPanel;
    Label18: TLabel;
    EditAmount_5: TcxCurrencyEdit;
    infoPanel_box: TPanel;
    Panel26: TPanel;
    Label19: TLabel;
    EditGoodsCode_box: TcxCurrencyEdit;
    Panel27: TPanel;
    Label20: TLabel;
    EditGoodsName_box: TcxButtonEdit;
    Panel28: TPanel;
    Label21: TLabel;
    EditAmount_box: TcxCurrencyEdit;
    infoPanel_pd: TPanel;
    Panel30: TPanel;
    Label22: TLabel;
    EditGoodsCode_pd: TcxCurrencyEdit;
    Panel31: TPanel;
    Label23: TLabel;
    EditGoodsName_pd: TcxButtonEdit;
    Panel32: TPanel;
    Label24: TLabel;
    EditAmount_pd: TcxCurrencyEdit;
    infoPanel_ugol: TPanel;
    Panel34: TPanel;
    Label25: TLabel;
    EditGoodsCode_ugol: TcxCurrencyEdit;
    Panel35: TPanel;
    Label26: TLabel;
    EditGoodsName_ugol: TcxButtonEdit;
    Panel36: TPanel;
    Label27: TLabel;
    EditAmount_ugol: TcxCurrencyEdit;
    infoPanelSpace_poddon: TPanel;
    procedure EditGoodsCode_pdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsName_pdPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditGoodsCode_1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCode_3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCode_4KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCode_5KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCode_6KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCode_7KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCode_8KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCode_boxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCode_ugolKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCode_2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditAmount_pdKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditAmount_boxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditAmount_ugolKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditAmount_1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditAmount_2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditAmount_3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditAmount_4KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditAmount_5KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditAmount_6KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditAmount_7KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditAmount_8KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCode_pdExit(Sender: TObject);
    procedure EditGoodsCode_boxExit(Sender: TObject);
    procedure EditGoodsCode_ugolExit(Sender: TObject);
    procedure EditAmount_1Exit(Sender: TObject);
    procedure EditAmount_2Exit(Sender: TObject);
    procedure EditAmount_3Exit(Sender: TObject);
    procedure EditAmount_4Exit(Sender: TObject);
    procedure EditAmount_5Exit(Sender: TObject);
    procedure EditAmount_6Exit(Sender: TObject);
    procedure EditAmount_7Exit(Sender: TObject);
    procedure EditAmount_8Exit(Sender: TObject);
  private
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    function Execute (var execParamsMI:TParams) : boolean;
  end;

var
   DialogGofroForm: TDialogGofroForm;

implementation
uses UtilScale, GuideGofro, dmMainScale, DialogStringValue;
{$R *.dfm}
{------------------------------------------------------------------------------}
function TDialogGofroForm.Execute(var execParamsMI:TParams): boolean;
begin
     EditGoodsCode_pd.Text:= execParamsMI.ParamByName('GoodsCode_gofro_pd').AsString;
     EditGoodsName_pd.Text:= execParamsMI.ParamByName('GoodsName_gofro_pd').AsString;
     EditAmount_pd.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_pd').AsFloat);
     //
     EditGoodsCode_box.Text:= execParamsMI.ParamByName('GoodsCode_gofro_box').AsString;
     EditGoodsName_box.Text:= execParamsMI.ParamByName('GoodsName_gofro_box').AsString;
     EditAmount_box.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_box').AsFloat);
     //
     EditGoodsCode_ugol.Text:= execParamsMI.ParamByName('GoodsCode_gofro_ugol').AsString;
     EditGoodsName_ugol.Text:= execParamsMI.ParamByName('GoodsName_gofro_ugol').AsString;
     EditAmount_ugol.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_ugol').AsFloat);
     //
     EditGoodsCode_1.Text:= execParamsMI.ParamByName('GoodsCode_gofro_1').AsString;
     EditGoodsName_1.Text:= execParamsMI.ParamByName('GoodsName_gofro_1').AsString;
     EditAmount_1.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_1').AsFloat);
     //
     EditGoodsCode_2.Text:= execParamsMI.ParamByName('GoodsCode_gofro_2').AsString;
     EditGoodsName_2.Text:= execParamsMI.ParamByName('GoodsName_gofro_2').AsString;
     EditAmount_2.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_2').AsFloat);
     //
     EditGoodsCode_3.Text:= execParamsMI.ParamByName('GoodsCode_gofro_3').AsString;
     EditGoodsName_3.Text:= execParamsMI.ParamByName('GoodsName_gofro_3').AsString;
     EditAmount_3.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_3').AsFloat);
     //
     EditGoodsCode_4.Text:= execParamsMI.ParamByName('GoodsCode_gofro_4').AsString;
     EditGoodsName_4.Text:= execParamsMI.ParamByName('GoodsName_gofro_4').AsString;
     EditAmount_4.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_4').AsFloat);
     //
     EditGoodsCode_5.Text:= execParamsMI.ParamByName('GoodsCode_gofro_5').AsString;
     EditGoodsName_5.Text:= execParamsMI.ParamByName('GoodsName_gofro_5').AsString;
     EditAmount_5.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_5').AsFloat);
     //
     EditGoodsCode_6.Text:= execParamsMI.ParamByName('GoodsCode_gofro_6').AsString;
     EditGoodsName_6.Text:= execParamsMI.ParamByName('GoodsName_gofro_6').AsString;
     EditAmount_6.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_6').AsFloat);
     //
     EditGoodsCode_7.Text:= execParamsMI.ParamByName('GoodsCode_gofro_7').AsString;
     EditGoodsName_7.Text:= execParamsMI.ParamByName('GoodsName_gofro_7').AsString;
     EditAmount_7.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_7').AsFloat);
     //
     EditGoodsCode_8.Text:= execParamsMI.ParamByName('GoodsCode_gofro_8').AsString;
     EditGoodsName_8.Text:= execParamsMI.ParamByName('GoodsName_gofro_8').AsString;
     EditAmount_8.Text:= FloatToStr(execParamsMI.ParamByName('Amount_gofro_8').AsFloat);
     //
     ActiveControl:= EditGoodsCode_pd;
     result:=(ShowModal=mrOk);
     //
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditGoodsCode_pdExit(Sender: TObject);
var lParams:TParams;
begin
     if (EditGoodsCode_pd.Value > 0)
     then begin
         Create_ParamsGoodsLine(lParams);
         if DMMainScaleForm.gpGet_Scale_Goods_gofro(lParams,StrToInt(EditGoodsCode_pd.Text))
         then begin
             ParamsMI.ParamByName('GoodsId_gofro_pd').AsInteger   := lParams.ParamByName('GoodsId').AsInteger;
             ParamsMI.ParamByName('GoodsCode_gofro_pd').AsInteger := lParams.ParamByName('GoodsCode').AsInteger;
             ParamsMI.ParamByName('GoodsName_gofro_pd').AsString  := lParams.ParamByName('GoodsName').AsString;
             //
             EditGoodsCode_pd.Text:= ParamsMI.ParamByName('GoodsCode_gofro_pd').AsString;
             EditGoodsName_pd.Text:= ParamsMI.ParamByName('GoodsName_gofro_pd').AsString;
         end
         else begin
                  ActiveControl:= EditGoodsCode_pd;
                  ParamsMI.ParamByName('GoodsId_gofro_pd').AsInteger:= 0;
                  ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_pd.Text+'> не найден.');
         end;
         lParams.Free;
     end
     else begin
             ParamsMI.ParamByName('GoodsId_gofro_pd').AsInteger   := 0;
             ParamsMI.ParamByName('GoodsCode_gofro_pd').AsInteger := 0;
             ParamsMI.ParamByName('GoodsName_gofro_pd').AsString  := '';
             //
             EditGoodsCode_pd.Text:= '';
             EditGoodsName_pd.Text:= '';
     end;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditGoodsCode_boxExit(Sender: TObject);
var lParams:TParams;
begin
     if (EditGoodsCode_box.Value > 0)
     then begin
         Create_ParamsGoodsLine(lParams);
         if DMMainScaleForm.gpGet_Scale_Goods_gofro(lParams,StrToInt(EditGoodsCode_box.Text))
         then begin
             ParamsMI.ParamByName('GoodsId_gofro_box').AsInteger   := lParams.ParamByName('GoodsId').AsInteger;
             ParamsMI.ParamByName('GoodsCode_gofro_box').AsInteger := lParams.ParamByName('GoodsCode').AsInteger;
             ParamsMI.ParamByName('GoodsName_gofro_box').AsString  := lParams.ParamByName('GoodsName').AsString;
             //
             EditGoodsCode_box.Text:= ParamsMI.ParamByName('GoodsCode_gofro_box').AsString;
             EditGoodsName_box.Text:= ParamsMI.ParamByName('GoodsName_gofro_box').AsString;
         end
         else begin
                  ActiveControl:= EditGoodsCode_box;
                  ParamsMI.ParamByName('GoodsId_gofro_box').AsInteger:= 0;
                  ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_box.Text+'> не найден.');
         end;
         lParams.Free;
     end
     else begin
             ParamsMI.ParamByName('GoodsId_gofro_box').AsInteger   := 0;
             ParamsMI.ParamByName('GoodsCode_gofro_box').AsInteger := 0;
             ParamsMI.ParamByName('GoodsName_gofro_box').AsString  := '';
             //
             EditGoodsCode_box.Text:= '';
             EditGoodsName_box.Text:= '';
     end;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditGoodsCode_ugolExit(Sender: TObject);
var lParams:TParams;
begin
     if (EditGoodsCode_ugol.Value > 0)
     then begin
         Create_ParamsGoodsLine(lParams);
         if DMMainScaleForm.gpGet_Scale_Goods_gofro(lParams,StrToInt(EditGoodsCode_ugol.Text))
         then begin
             ParamsMI.ParamByName('GoodsId_gofro_ugol').AsInteger   := lParams.ParamByName('GoodsId').AsInteger;
             ParamsMI.ParamByName('GoodsCode_gofro_ugol').AsInteger := lParams.ParamByName('GoodsCode').AsInteger;
             ParamsMI.ParamByName('GoodsName_gofro_ugol').AsString  := lParams.ParamByName('GoodsName').AsString;
             //
             EditGoodsCode_ugol.Text:= ParamsMI.ParamByName('GoodsCode_gofro_ugol').AsString;
             EditGoodsName_ugol.Text:= ParamsMI.ParamByName('GoodsName_gofro_ugol').AsString;
         end
         else begin
                  ActiveControl:= EditGoodsCode_ugol;
                  ParamsMI.ParamByName('GoodsId_gofro_ugol').AsInteger:= 0;
                  ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_ugol.Text+'> не найден.');
         end;
         lParams.Free;
     end
     else begin
             ParamsMI.ParamByName('GoodsId_gofro_ugol').AsInteger   := 0;
             ParamsMI.ParamByName('GoodsCode_gofro_ugol').AsInteger := 0;
             ParamsMI.ParamByName('GoodsName_gofro_ugol').AsString  := '';
             //
             EditGoodsCode_ugol.Text:= '';
             EditGoodsName_ugol.Text:= '';
     end;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditAmount_1Exit(Sender: TObject);
var lParams:TParams;
begin
     if (EditGoodsCode_1.Value > 0)
     then begin
         Create_ParamsGoodsLine(lParams);
         if DMMainScaleForm.gpGet_Scale_Goods_gofro(lParams,StrToInt(EditGoodsCode_1.Text))
         then begin
             ParamsMI.ParamByName('GoodsId_gofro_1').AsInteger   := lParams.ParamByName('GoodsId').AsInteger;
             ParamsMI.ParamByName('GoodsCode_gofro_1').AsInteger := lParams.ParamByName('GoodsCode').AsInteger;
             ParamsMI.ParamByName('GoodsName_gofro_1').AsString  := lParams.ParamByName('GoodsName').AsString;
             //
             EditGoodsCode_1.Text:= ParamsMI.ParamByName('GoodsCode_gofro_1').AsString;
             EditGoodsName_1.Text:= ParamsMI.ParamByName('GoodsName_gofro_1').AsString;
         end
         else begin
                  ActiveControl:= EditGoodsCode_1;
                  ParamsMI.ParamByName('GoodsId_gofro_1').AsInteger:= 0;
                  ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_1.Text+'> не найден.');
         end;
         lParams.Free;
     end
     else begin
             ParamsMI.ParamByName('GoodsId_gofro_1').AsInteger   := 0;
             ParamsMI.ParamByName('GoodsCode_gofro_1').AsInteger := 0;
             ParamsMI.ParamByName('GoodsName_gofro_1').AsString  := '';
             //
             EditGoodsCode_1.Text:= '';
             EditGoodsName_1.Text:= '';
     end;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditAmount_2Exit(Sender: TObject);
var lParams:TParams;
begin
     if (EditGoodsCode_2.Value > 0)
     then begin
         Create_ParamsGoodsLine(lParams);
         if DMMainScaleForm.gpGet_Scale_Goods_gofro(lParams,StrToInt(EditGoodsCode_2.Text))
         then begin
             ParamsMI.ParamByName('GoodsId_gofro_2').AsInteger   := lParams.ParamByName('GoodsId').AsInteger;
             ParamsMI.ParamByName('GoodsCode_gofro_2').AsInteger := lParams.ParamByName('GoodsCode').AsInteger;
             ParamsMI.ParamByName('GoodsName_gofro_2').AsString  := lParams.ParamByName('GoodsName').AsString;
             //
             EditGoodsCode_2.Text:= ParamsMI.ParamByName('GoodsCode_gofro_2').AsString;
             EditGoodsName_2.Text:= ParamsMI.ParamByName('GoodsName_gofro_2').AsString;
         end
         else begin
                  ActiveControl:= EditGoodsCode_2;
                  ParamsMI.ParamByName('GoodsId_gofro_2').AsInteger:= 0;
                  ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_2.Text+'> не найден.');
         end;
         lParams.Free;
     end
     else begin
             ParamsMI.ParamByName('GoodsId_gofro_2').AsInteger   := 0;
             ParamsMI.ParamByName('GoodsCode_gofro_2').AsInteger := 0;
             ParamsMI.ParamByName('GoodsName_gofro_2').AsString  := '';
             //
             EditGoodsCode_2.Text:= '';
             EditGoodsName_2.Text:= '';
     end;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditAmount_3Exit(Sender: TObject);
var lParams:TParams;
begin
     if (EditGoodsCode_3.Value > 0)
     then begin
         Create_ParamsGoodsLine(lParams);
         if DMMainScaleForm.gpGet_Scale_Goods_gofro(lParams,StrToInt(EditGoodsCode_3.Text))
         then begin
             ParamsMI.ParamByName('GoodsId_gofro_3').AsInteger   := lParams.ParamByName('GoodsId').AsInteger;
             ParamsMI.ParamByName('GoodsCode_gofro_3').AsInteger := lParams.ParamByName('GoodsCode').AsInteger;
             ParamsMI.ParamByName('GoodsName_gofro_3').AsString  := lParams.ParamByName('GoodsName').AsString;
             //
             EditGoodsCode_3.Text:= ParamsMI.ParamByName('GoodsCode_gofro_3').AsString;
             EditGoodsName_3.Text:= ParamsMI.ParamByName('GoodsName_gofro_3').AsString;
         end
         else begin
                  ActiveControl:= EditGoodsCode_3;
                  ParamsMI.ParamByName('GoodsId_gofro_3').AsInteger:= 0;
                  ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_3.Text+'> не найден.');
         end;
         lParams.Free;
     end
     else begin
             ParamsMI.ParamByName('GoodsId_gofro_3').AsInteger   := 0;
             ParamsMI.ParamByName('GoodsCode_gofro_3').AsInteger := 0;
             ParamsMI.ParamByName('GoodsName_gofro_3').AsString  := '';
             //
             EditGoodsCode_3.Text:= '';
             EditGoodsName_3.Text:= '';
     end;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditAmount_4Exit(Sender: TObject);
var lParams:TParams;
begin
     if (EditGoodsCode_4.Value > 0)
     then begin
         Create_ParamsGoodsLine(lParams);
         if DMMainScaleForm.gpGet_Scale_Goods_gofro(lParams,StrToInt(EditGoodsCode_4.Text))
         then begin
             ParamsMI.ParamByName('GoodsId_gofro_4').AsInteger   := lParams.ParamByName('GoodsId').AsInteger;
             ParamsMI.ParamByName('GoodsCode_gofro_4').AsInteger := lParams.ParamByName('GoodsCode').AsInteger;
             ParamsMI.ParamByName('GoodsName_gofro_4').AsString  := lParams.ParamByName('GoodsName').AsString;
             //
             EditGoodsCode_4.Text:= ParamsMI.ParamByName('GoodsCode_gofro_4').AsString;
             EditGoodsName_4.Text:= ParamsMI.ParamByName('GoodsName_gofro_4').AsString;
         end
         else begin
                  ActiveControl:= EditGoodsCode_4;
                  ParamsMI.ParamByName('GoodsId_gofro_4').AsInteger:= 0;
                  ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_4.Text+'> не найден.');
         end;
         lParams.Free;
     end
     else begin
             ParamsMI.ParamByName('GoodsId_gofro_4').AsInteger   := 0;
             ParamsMI.ParamByName('GoodsCode_gofro_4').AsInteger := 0;
             ParamsMI.ParamByName('GoodsName_gofro_4').AsString  := '';
             //
             EditGoodsCode_4.Text:= '';
             EditGoodsName_4.Text:= '';
     end;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditAmount_5Exit(Sender: TObject);
var lParams:TParams;
begin
     if (EditGoodsCode_5.Value > 0)
     then begin
         Create_ParamsGoodsLine(lParams);
         if DMMainScaleForm.gpGet_Scale_Goods_gofro(lParams,StrToInt(EditGoodsCode_5.Text))
         then begin
             ParamsMI.ParamByName('GoodsId_gofro_5').AsInteger   := lParams.ParamByName('GoodsId').AsInteger;
             ParamsMI.ParamByName('GoodsCode_gofro_5').AsInteger := lParams.ParamByName('GoodsCode').AsInteger;
             ParamsMI.ParamByName('GoodsName_gofro_5').AsString  := lParams.ParamByName('GoodsName').AsString;
             //
             EditGoodsCode_5.Text:= ParamsMI.ParamByName('GoodsCode_gofro_5').AsString;
             EditGoodsName_5.Text:= ParamsMI.ParamByName('GoodsName_gofro_5').AsString;
         end
         else begin
                  ActiveControl:= EditGoodsCode_5;
                  ParamsMI.ParamByName('GoodsId_gofro_5').AsInteger:= 0;
                  ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_5.Text+'> не найден.');
         end;
         lParams.Free;
     end
     else begin
             ParamsMI.ParamByName('GoodsId_gofro_5').AsInteger   := 0;
             ParamsMI.ParamByName('GoodsCode_gofro_5').AsInteger := 0;
             ParamsMI.ParamByName('GoodsName_gofro_5').AsString  := '';
             //
             EditGoodsCode_5.Text:= '';
             EditGoodsName_5.Text:= '';
     end;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditAmount_6Exit(Sender: TObject);
var lParams:TParams;
begin
     if (EditGoodsCode_6.Value > 0)
     then begin
         Create_ParamsGoodsLine(lParams);
         if DMMainScaleForm.gpGet_Scale_Goods_gofro(lParams,StrToInt(EditGoodsCode_6.Text))
         then begin
             ParamsMI.ParamByName('GoodsId_gofro_6').AsInteger   := lParams.ParamByName('GoodsId').AsInteger;
             ParamsMI.ParamByName('GoodsCode_gofro_6').AsInteger := lParams.ParamByName('GoodsCode').AsInteger;
             ParamsMI.ParamByName('GoodsName_gofro_6').AsString  := lParams.ParamByName('GoodsName').AsString;
             //
             EditGoodsCode_6.Text:= ParamsMI.ParamByName('GoodsCode_gofro_6').AsString;
             EditGoodsName_6.Text:= ParamsMI.ParamByName('GoodsName_gofro_6').AsString;
         end
         else begin
                  ActiveControl:= EditGoodsCode_6;
                  ParamsMI.ParamByName('GoodsId_gofro_6').AsInteger:= 0;
                  ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_6.Text+'> не найден.');
         end;
         lParams.Free;
     end
     else begin
             ParamsMI.ParamByName('GoodsId_gofro_6').AsInteger   := 0;
             ParamsMI.ParamByName('GoodsCode_gofro_6').AsInteger := 0;
             ParamsMI.ParamByName('GoodsName_gofro_6').AsString  := '';
             //
             EditGoodsCode_6.Text:= '';
             EditGoodsName_6.Text:= '';
     end;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditAmount_7Exit(Sender: TObject);
var lParams:TParams;
begin
     if (EditGoodsCode_7.Value > 0)
     then begin
         Create_ParamsGoodsLine(lParams);
         if DMMainScaleForm.gpGet_Scale_Goods_gofro(lParams,StrToInt(EditGoodsCode_7.Text))
         then begin
             ParamsMI.ParamByName('GoodsId_gofro_7').AsInteger   := lParams.ParamByName('GoodsId').AsInteger;
             ParamsMI.ParamByName('GoodsCode_gofro_7').AsInteger := lParams.ParamByName('GoodsCode').AsInteger;
             ParamsMI.ParamByName('GoodsName_gofro_7').AsString  := lParams.ParamByName('GoodsName').AsString;
             //
             EditGoodsCode_7.Text:= ParamsMI.ParamByName('GoodsCode_gofro_7').AsString;
             EditGoodsName_7.Text:= ParamsMI.ParamByName('GoodsName_gofro_7').AsString;
         end
         else begin
                  ActiveControl:= EditGoodsCode_7;
                  ParamsMI.ParamByName('GoodsId_gofro_7').AsInteger:= 0;
                  ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_7.Text+'> не найден.');
         end;
         lParams.Free;
     end
     else begin
             ParamsMI.ParamByName('GoodsId_gofro_7').AsInteger   := 0;
             ParamsMI.ParamByName('GoodsCode_gofro_7').AsInteger := 0;
             ParamsMI.ParamByName('GoodsName_gofro_7').AsString  := '';
             //
             EditGoodsCode_7.Text:= '';
             EditGoodsName_7.Text:= '';
     end;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditAmount_8Exit(Sender: TObject);
var lParams:TParams;
begin
     if (EditGoodsCode_8.Value > 0)
     then begin
         Create_ParamsGoodsLine(lParams);
         if DMMainScaleForm.gpGet_Scale_Goods_gofro(lParams,StrToInt(EditGoodsCode_8.Text))
         then begin
             ParamsMI.ParamByName('GoodsId_gofro_8').AsInteger   := lParams.ParamByName('GoodsId').AsInteger;
             ParamsMI.ParamByName('GoodsCode_gofro_8').AsInteger := lParams.ParamByName('GoodsCode').AsInteger;
             ParamsMI.ParamByName('GoodsName_gofro_8').AsString  := lParams.ParamByName('GoodsName').AsString;
             //
             EditGoodsCode_8.Text:= ParamsMI.ParamByName('GoodsCode_gofro_8').AsString;
             EditGoodsName_8.Text:= ParamsMI.ParamByName('GoodsName_gofro_8').AsString;
         end
         else begin
                  ActiveControl:= EditGoodsCode_8;
                  ParamsMI.ParamByName('GoodsId_gofro_8').AsInteger:= 0;
                  ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_8.Text+'> не найден.');
         end;
         lParams.Free;
     end
     else begin
             ParamsMI.ParamByName('GoodsId_gofro_8').AsInteger   := 0;
             ParamsMI.ParamByName('GoodsCode_gofro_8').AsInteger := 0;
             ParamsMI.ParamByName('GoodsName_gofro_8').AsString  := '';
             //
             EditGoodsCode_8.Text:= '';
             EditGoodsName_8.Text:= '';
     end;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditGoodsCode_pdKeyDown(Sender: TObject;  var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
     if (EditGoodsCode_pd.Value > 0)
     then ActiveControl:= EditAmount_pd
     else ActiveControl:= EditGoodsCode_box;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditGoodsCode_boxKeyDown(Sender: TObject;  var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
     if (EditGoodsCode_box.Value > 0)
     then ActiveControl:= EditAmount_box
     else ActiveControl:= EditGoodsCode_ugol;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditGoodsCode_ugolKeyDown(Sender: TObject;  var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
     if (EditGoodsCode_ugol.Value > 0)
     then ActiveControl:= EditAmount_ugol
     else ActiveControl:= EditGoodsCode_1;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditGoodsCode_1KeyDown(Sender: TObject;  var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
     if (EditGoodsCode_1.Value > 0)
     then ActiveControl:= EditAmount_1
     else ActiveControl:= EditGoodsCode_2;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditGoodsCode_2KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
     if (EditGoodsCode_2.Value > 0)
     then ActiveControl:= EditAmount_2
     else ActiveControl:= EditGoodsCode_3;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditGoodsCode_3KeyDown(Sender: TObject;  var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
     if (EditGoodsCode_3.Value > 0)
     then ActiveControl:= EditAmount_3
     else ActiveControl:= EditGoodsCode_4;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditGoodsCode_4KeyDown(Sender: TObject;  var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
     if (EditGoodsCode_4.Value > 0)
     then ActiveControl:= EditAmount_4
     else ActiveControl:= EditGoodsCode_5;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditGoodsCode_5KeyDown(Sender: TObject;  var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
     if (EditGoodsCode_5.Value > 0)
     then ActiveControl:= EditAmount_5
     else ActiveControl:= EditGoodsCode_6;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditGoodsCode_6KeyDown(Sender: TObject;  var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
     if (EditGoodsCode_6.Value > 0)
     then ActiveControl:= EditAmount_6
     else ActiveControl:= EditGoodsCode_7;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditGoodsCode_7KeyDown(Sender: TObject;  var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
     if (EditGoodsCode_7.Value > 0)
     then ActiveControl:= EditAmount_7
     else ActiveControl:= EditGoodsCode_8;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditGoodsCode_8KeyDown(Sender: TObject;  var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
     if (EditGoodsCode_8.Value > 0)
     then ActiveControl:= EditAmount_8
     else ActiveControl:= bbOK
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditAmount_pdKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  if Key = 13 then ActiveControl:= EditGoodsCode_box
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditAmount_boxKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  if Key = 13 then ActiveControl:= EditGoodsCode_ugol
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditAmount_ugolKeyDown(Sender: TObject;  var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then ActiveControl:= EditGoodsCode_1
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditAmount_1KeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  if Key = 13 then ActiveControl:= EditGoodsCode_2
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditAmount_2KeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  if Key = 13 then ActiveControl:= EditGoodsCode_3
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditAmount_3KeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  if Key = 13 then ActiveControl:= EditGoodsCode_4
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditAmount_4KeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  if Key = 13 then ActiveControl:= EditGoodsCode_5
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditAmount_5KeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  if Key = 13 then ActiveControl:= EditGoodsCode_6
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditAmount_6KeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  if Key = 13 then ActiveControl:= EditGoodsCode_7
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditAmount_7KeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  if Key = 13 then ActiveControl:= EditGoodsCode_8
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditAmount_8KeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
  if Key = 13 then ActiveControl:= bbOk;
end;
{------------------------------------------------------------------------------}
procedure TDialogGofroForm.EditGoodsName_pdPropertiesButtonClick(Sender: TObject; AButtonIndex: Integer);
var ParamsGuide_local :TParams;
begin
  Create_ParamsGuide(ParamsGuide_local);
  //
  ParamsGuide_local.ParamByName('GuideId').AsInteger:= ParamsMI.ParamByName('GoodsId_gofro_pd').AsInteger;
  ParamsGuide_local.ParamByName('GuideCode').AsInteger:= ParamsMI.ParamByName('GoodsCode_gofro_pd').AsInteger;
  ParamsGuide_local.ParamByName('GuideName').asString:= ParamsMI.ParamByName('GoodsName_gofro_pd').AsString;
  //
  if GuideGofroForm.Execute(ParamsGuide_local)
  then begin
     EditGoodsCode_pd.Text:= ParamsGuide_local.ParamByName('GuideCode').AsString;
     EditGoodsName_pd.Text:= ParamsGuide_local.ParamByName('GuideName').AsString;
     //
     ParamsMI.ParamByName('GoodsId_gofro_pd').AsInteger:=   ParamsGuide_local.ParamByName('GuideId').AsInteger;
     ParamsMI.ParamByName('GoodsCode_gofro_pd').AsInteger:= ParamsGuide_local.ParamByName('GuideCode').AsInteger;
     ParamsMI.ParamByName('GoodsName_gofro_pd').AsString:= ParamsGuide_local.ParamByName('GuideName').asString;
     //
     ActiveControl:=EditGoodsCode_box;
  end;
  //
  ParamsGuide_local.Free;
end;
{------------------------------------------------------------------------------}
function TDialogGofroForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:= false;
     //
     //Поддон - Определить кол-во
     try ParamsMI.ParamByName('Amount_gofro_pd').AsFloat := StrToFloat(EditAmount_pd.Text);
     except
          ParamsMI.ParamByName('Amount_gofro_pd').AsFloat := 0;
     end;
     if ParamsMI.ParamByName('Amount_gofro_pd').AsFloat < 0 then
     begin
          ShowMessage ('Введите значение <Кол-во Поддоны>.');
          exit;
     end;
     //
     //Ящик - Определить кол-во
     try ParamsMI.ParamByName('Amount_gofro_box').AsFloat := StrToFloat(EditAmount_box.Text);
     except
          ParamsMI.ParamByName('Amount_gofro_box').AsFloat := 0;
     end;
     if ParamsMI.ParamByName('Amount_gofro_box').AsFloat < 0 then
     begin
          ShowMessage ('Введите значение <Кол-во Ящики>.');
          exit;
     end;
     //
     //Гофро-уголок - Определить кол-во
     try ParamsMI.ParamByName('Amount_gofro_ugol').AsFloat := StrToFloat(EditAmount_ugol.Text);
     except
          ParamsMI.ParamByName('Amount_gofro_ugol').AsFloat := 0;
     end;
     if ParamsMI.ParamByName('Amount_gofro_ugol').AsFloat < 0 then
     begin
          ShowMessage ('Введите значение <Кол-во Гофро-Уголок>.');
          exit;
     end;
     //
     //Гофро-ящик-1 - Определить кол-во
     try ParamsMI.ParamByName('Amount_gofro_1').AsFloat := StrToFloat(EditAmount_1.Text);
     except
          ParamsMI.ParamByName('Amount_gofro_1').AsFloat := 0;
     end;
     if ParamsMI.ParamByName('Amount_gofro_1').AsFloat < 0 then
     begin
          ShowMessage ('Введите значение <Кол-во Гофро-ящик-1>.');
          exit;
     end;
     //
     //Гофро-ящик-2 - Определить кол-во
     try ParamsMI.ParamByName('Amount_gofro_2').AsFloat := StrToFloat(EditAmount_2.Text);
     except
          ParamsMI.ParamByName('Amount_gofro_2').AsFloat := 0;
     end;
     if ParamsMI.ParamByName('Amount_gofro_2').AsFloat < 0 then
     begin
          ShowMessage ('Введите значение <Кол-во Гофро-ящик-2>.');
          exit;
     end;
     //
     //Гофро-ящик-3 - Определить кол-во
     try ParamsMI.ParamByName('Amount_gofro_3').AsFloat := StrToFloat(EditAmount_3.Text);
     except
          ParamsMI.ParamByName('Amount_gofro_3').AsFloat := 0;
     end;
     if ParamsMI.ParamByName('Amount_gofro_3').AsFloat < 0 then
     begin
          ShowMessage ('Введите значение <Кол-во Гофро-ящик-3>.');
          exit;
     end;
     //
     //Гофро-ящик-4 - Определить кол-во
     try ParamsMI.ParamByName('Amount_gofro_4').AsFloat := StrToFloat(EditAmount_4.Text);
     except
          ParamsMI.ParamByName('Amount_gofro_4').AsFloat := 0;
     end;
     if ParamsMI.ParamByName('Amount_gofro_4').AsFloat < 0 then
     begin
          ShowMessage ('Введите значение <Кол-во Гофро-ящик-4>.');
          exit;
     end;
     //
     //Гофро-ящик-5 - Определить кол-во
     try ParamsMI.ParamByName('Amount_gofro_5').AsFloat := StrToFloat(EditAmount_5.Text);
     except
          ParamsMI.ParamByName('Amount_gofro_5').AsFloat := 0;
     end;
     if ParamsMI.ParamByName('Amount_gofro_5').AsFloat < 0 then
     begin
          ShowMessage ('Введите значение <Кол-во Гофро-ящик-5>.');
          exit;
     end;
     //
     //Гофро-ящик-6 - Определить кол-во
     try ParamsMI.ParamByName('Amount_gofro_6').AsFloat := StrToFloat(EditAmount_6.Text);
     except
          ParamsMI.ParamByName('Amount_gofro_6').AsFloat := 0;
     end;
     if ParamsMI.ParamByName('Amount_gofro_6').AsFloat < 0 then
     begin
          ShowMessage ('Введите значение <Кол-во Гофро-ящик-6>.');
          exit;
     end;
     //
     //Гофро-ящик-7 - Определить кол-во
     try ParamsMI.ParamByName('Amount_gofro_7').AsFloat := StrToFloat(EditAmount_7.Text);
     except
          ParamsMI.ParamByName('Amount_gofro_7').AsFloat := 0;
     end;
     if ParamsMI.ParamByName('Amount_gofro_7').AsFloat < 0 then
     begin
          ShowMessage ('Введите значение <Кол-во Гофро-ящик-7>.');
          exit;
     end;
     //
     //Гофро-ящик-8 - Определить кол-во
     try ParamsMI.ParamByName('Amount_gofro_8').AsFloat := StrToFloat(EditAmount_8.Text);
     except
          ParamsMI.ParamByName('Amount_gofro_8').AsFloat := 0;
     end;
     if ParamsMI.ParamByName('Amount_gofro_8').AsFloat < 0 then
     begin
          ShowMessage ('Введите значение <Кол-во Гофро-ящик-8>.');
          exit;
     end;
     //
     //
     // 0.1.1.Поддон - Проверка
     if (EditGoodsCode_pd.Value > 0) and (ParamsMI.ParamByName('GoodsId_gofro_pd').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_pd.Text+'> не найден.');
               ActiveControl:= EditGoodsCode_pd;
               exit;
         end;
     // 0.1.2.Поддон - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_pd').AsFloat > 0) and (ParamsMI.ParamByName('GoodsId_gofro_pd').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Не определен Товар с кол-вом = <'+FloatToStr(ParamsMI.ParamByName('Amount_gofro_pd').AsFloat)+'>.');
               ActiveControl:= EditGoodsCode_pd;
               exit;
         end;
     // 0.1.3.Поддон - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_pd').AsFloat = 0) and (ParamsMI.ParamByName('GoodsId_gofro_pd').AsInteger > 0)
     then begin
               ShowMessage('Ошибка.Не определено кол-во для Товара = <'+EditGoodsName_pd.Text+'>.');
               ActiveControl:= EditAmount_pd;
               exit;
         end;
     //
     // 0.2.1.ящик - Проверка
     if (EditGoodsCode_pd.Value > 0) and (ParamsMI.ParamByName('GoodsId_gofro_box').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_box.Text+'> не найден.');
               ActiveControl:= EditGoodsCode_box;
               exit;
         end;
     // 0.2.2.ящик - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_box').AsFloat > 0) and (ParamsMI.ParamByName('GoodsId_gofro_box').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Не определен Товар с кол-вом = <'+FloatToStr(ParamsMI.ParamByName('Amount_gofro_box').AsFloat)+'>.');
               ActiveControl:= EditGoodsCode_box;
               exit;
         end;
     // 0.2.3.ящик - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_box').AsFloat = 0) and (ParamsMI.ParamByName('GoodsId_gofro_box').AsInteger > 0)
     then begin
               ShowMessage('Ошибка.Не определено кол-во для Товара = <'+EditGoodsName_box.Text+'>.');
               ActiveControl:= EditAmount_box;
               exit;
         end;
     //
     // 0.3.1.Гофро-уголок - Проверка
     if (EditGoodsCode_pd.Value > 0) and (ParamsMI.ParamByName('GoodsId_gofro_ugol').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_ugol.Text+'> не найден.');
               ActiveControl:= EditGoodsCode_ugol;
               exit;
         end;
     // 0.3.2.Гофро-уголок - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_ugol').AsFloat > 0) and (ParamsMI.ParamByName('GoodsId_gofro_ugol').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Не определен Товар с кол-вом = <'+FloatToStr(ParamsMI.ParamByName('Amount_gofro_ugol').AsFloat)+'>.');
               ActiveControl:= EditGoodsCode_ugol;
               exit;
         end;
     // 0.3.3.Гофро-уголок - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_ugol').AsFloat = 0) and (ParamsMI.ParamByName('GoodsId_gofro_ugol').AsInteger > 0)
     then begin
               ShowMessage('Ошибка.Не определено кол-во для Товара = <'+EditGoodsName_ugol.Text+'>.');
               ActiveControl:= EditAmount_ugol;
               exit;
         end;
     //
     // 1.1.Гофро-ящик-1 - Проверка
     if (EditGoodsCode_pd.Value > 0) and (ParamsMI.ParamByName('GoodsId_gofro_1').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_1.Text+'> не найден.');
               ActiveControl:= EditGoodsCode_1;
               exit;
         end;
     // 1.2.Гофро-ящик-1 - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_1').AsFloat > 0) and (ParamsMI.ParamByName('GoodsId_gofro_1').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Не определен Товар с кол-вом = <'+FloatToStr(ParamsMI.ParamByName('Amount_gofro_1').AsFloat)+'>.');
               ActiveControl:= EditGoodsCode_1;
               exit;
         end;
     // 1.3.Гофро-ящик-1 - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_1').AsFloat = 0) and (ParamsMI.ParamByName('GoodsId_gofro_1').AsInteger > 0)
     then begin
               ShowMessage('Ошибка.Не определено кол-во для Товара = <'+EditGoodsName_1.Text+'>.');
               ActiveControl:= EditAmount_1;
               exit;
         end;
     //
     // 2.1.Гофро-ящик-2 - Проверка
     if (EditGoodsCode_pd.Value > 0) and (ParamsMI.ParamByName('GoodsId_gofro_2').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_2.Text+'> не найден.');
               ActiveControl:= EditGoodsCode_2;
               exit;
         end;
     // 2.2.Гофро-ящик-2 - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_2').AsFloat > 0) and (ParamsMI.ParamByName('GoodsId_gofro_2').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Не определен Товар с кол-вом = <'+FloatToStr(ParamsMI.ParamByName('Amount_gofro_2').AsFloat)+'>.');
               ActiveControl:= EditGoodsCode_2;
               exit;
         end;
     // 2.3.Гофро-ящик-2 - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_2').AsFloat = 0) and (ParamsMI.ParamByName('GoodsId_gofro_2').AsInteger > 0)
     then begin
               ShowMessage('Ошибка.Не определено кол-во для Товара = <'+EditGoodsName_2.Text+'>.');
               ActiveControl:= EditAmount_2;
               exit;
         end;
     //
     // 3.1.Гофро-ящик-3 - Проверка
     if (EditGoodsCode_pd.Value > 0) and (ParamsMI.ParamByName('GoodsId_gofro_3').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_3.Text+'> не найден.');
               ActiveControl:= EditGoodsCode_3;
               exit;
         end;
     // 3.2.Гофро-ящик-3 - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_3').AsFloat > 0) and (ParamsMI.ParamByName('GoodsId_gofro_3').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Не определен Товар с кол-вом = <'+FloatToStr(ParamsMI.ParamByName('Amount_gofro_3').AsFloat)+'>.');
               ActiveControl:= EditGoodsCode_3;
               exit;
         end;
     // 3.3.Гофро-ящик-3 - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_3').AsFloat = 0) and (ParamsMI.ParamByName('GoodsId_gofro_3').AsInteger > 0)
     then begin
               ShowMessage('Ошибка.Не определено кол-во для Товара = <'+EditGoodsName_3.Text+'>.');
               ActiveControl:= EditAmount_3;
               exit;
         end;
     //
     // 4.1.Гофро-ящик-4 - Проверка
     if (EditGoodsCode_pd.Value > 0) and (ParamsMI.ParamByName('GoodsId_gofro_4').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_4.Text+'> не найден.');
               ActiveControl:= EditGoodsCode_4;
               exit;
         end;
     // 4.2.Гофро-ящик-4 - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_4').AsFloat > 0) and (ParamsMI.ParamByName('GoodsId_gofro_4').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Не определен Товар с кол-вом = <'+FloatToStr(ParamsMI.ParamByName('Amount_gofro_4').AsFloat)+'>.');
               ActiveControl:= EditGoodsCode_4;
               exit;
         end;
     // 4.3.Гофро-ящик-4 - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_4').AsFloat = 0) and (ParamsMI.ParamByName('GoodsId_gofro_4').AsInteger > 0)
     then begin
               ShowMessage('Ошибка.Не определено кол-во для Товара = <'+EditGoodsName_4.Text+'>.');
               ActiveControl:= EditAmount_4;
               exit;
         end;
     //
     // 5.1.Гофро-ящик-5 - Проверка
     if (EditGoodsCode_pd.Value > 0) and (ParamsMI.ParamByName('GoodsId_gofro_5').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_5.Text+'> не найден.');
               ActiveControl:= EditGoodsCode_5;
               exit;
         end;
     // 5.2.Гофро-ящик-5 - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_5').AsFloat > 0) and (ParamsMI.ParamByName('GoodsId_gofro_5').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Не определен Товар с кол-вом = <'+FloatToStr(ParamsMI.ParamByName('Amount_gofro_5').AsFloat)+'>.');
               ActiveControl:= EditGoodsCode_5;
               exit;
         end;
     // 5.3.Гофро-ящик-5 - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_5').AsFloat = 0) and (ParamsMI.ParamByName('GoodsId_gofro_5').AsInteger > 0)
     then begin
               ShowMessage('Ошибка.Не определено кол-во для Товара = <'+EditGoodsName_5.Text+'>.');
               ActiveControl:= EditAmount_5;
               exit;
         end;
     //
     // 6.1.Гофро-ящик-6 - Проверка
     if (EditGoodsCode_pd.Value > 0) and (ParamsMI.ParamByName('GoodsId_gofro_6').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_6.Text+'> не найден.');
               ActiveControl:= EditGoodsCode_6;
               exit;
         end;
     // 6.2.Гофро-ящик-6 - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_6').AsFloat > 0) and (ParamsMI.ParamByName('GoodsId_gofro_6').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Не определен Товар с кол-вом = <'+FloatToStr(ParamsMI.ParamByName('Amount_gofro_6').AsFloat)+'>.');
               ActiveControl:= EditGoodsCode_6;
               exit;
         end;
     // 6.3.Гофро-ящик-6 - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_6').AsFloat = 0) and (ParamsMI.ParamByName('GoodsId_gofro_6').AsInteger > 0)
     then begin
               ShowMessage('Ошибка.Не определено кол-во для Товара = <'+EditGoodsName_6.Text+'>.');
               ActiveControl:= EditAmount_6;
               exit;
         end;
     //
     // 7.1.Гофро-ящик-7 - Проверка
     if (EditGoodsCode_pd.Value > 0) and (ParamsMI.ParamByName('GoodsId_gofro_7').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_7.Text+'> не найден.');
               ActiveControl:= EditGoodsCode_7;
               exit;
         end;
     // 7.2.Гофро-ящик-7 - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_7').AsFloat > 0) and (ParamsMI.ParamByName('GoodsId_gofro_7').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Не определен Товар с кол-вом = <'+FloatToStr(ParamsMI.ParamByName('Amount_gofro_7').AsFloat)+'>.');
               ActiveControl:= EditGoodsCode_7;
               exit;
         end;
     // 7.3.Гофро-ящик-7 - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_7').AsFloat = 0) and (ParamsMI.ParamByName('GoodsId_gofro_7').AsInteger > 0)
     then begin
               ShowMessage('Ошибка.Не определено кол-во для Товара = <'+EditGoodsName_7.Text+'>.');
               ActiveControl:= EditAmount_7;
               exit;
         end;
     //
     // 8.1.Гофро-ящик-8 - Проверка
     if (EditGoodsCode_pd.Value > 0) and (ParamsMI.ParamByName('GoodsId_gofro_8').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Товар с кодом <'+EditGoodsCode_8.Text+'> не найден.');
               ActiveControl:= EditGoodsCode_8;
               exit;
         end;
     // 8.2.Гофро-ящик-8 - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_8').AsFloat > 0) and (ParamsMI.ParamByName('GoodsId_gofro_8').AsInteger = 0)
     then begin
               ShowMessage('Ошибка.Не определен Товар с кол-вом = <'+FloatToStr(ParamsMI.ParamByName('Amount_gofro_8').AsFloat)+'>.');
               ActiveControl:= EditGoodsCode_8;
               exit;
         end;
     // 8.3.Гофро-ящик-8 - Проверка
     if (ParamsMI.ParamByName('Amount_gofro_8').AsFloat = 0) and (ParamsMI.ParamByName('GoodsId_gofro_8').AsInteger > 0)
     then begin
               ShowMessage('Ошибка.Не определено кол-во для Товара = <'+EditGoodsName_8.Text+'>.');
               ActiveControl:= EditAmount_8;
               exit;
         end;
     //
     Result:= true;
end;
{------------------------------------------------------------------------------}
end.
