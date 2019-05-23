unit DialogBoxLight;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AncestorDialogScale, StdCtrls, Mask, Buttons,
  ExtCtrls, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus,
  dxSkinsCore, dxSkinsDefaultPainters, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxCurrencyEdit, dsdDB, Vcl.ActnList, dsdAction, cxPropertiesStore,
  dsdAddOn, cxButtons, Vcl.ComCtrls, dxCore, cxDateUtils, cxCheckBox,
  cxMaskEdit, cxDropDownEdit, cxCalendar, cxLabel, Data.DB;

type
  TDialogBoxLightForm = class(TAncestorDialogScaleForm)
    PanelValue: TPanel;
    Box3Panel: TPanel;
    infoMsgPanel: TPanel;
    MsgBlinkLabel: TcxLabel;
    Box3Label: TcxLabel;
    MsgMainLabel: TcxLabel;
    Box1Panel: TPanel;
    Box1Label: TcxLabel;
    Box2Panel: TPanel;
    Box2Label: TcxLabel;
    BoxCode1Label: TcxLabel;
    BoxCode2Label: TcxLabel;
    BoxCode3Label: TcxLabel;
    Light_1Memo: TMemo;
    Light_2Memo: TMemo;
    Light_3Memo: TMemo;
    Timer: TTimer;
    Box3Edit: TcxTextEdit;
    Box2Edit: TcxTextEdit;
    Box1Edit: TcxTextEdit;
    procedure Box1EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Box2EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Box3EditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Box1EditExit(Sender: TObject);
    procedure Box2EditExit(Sender: TObject);
    procedure Box3EditExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Box3EditEnter(Sender: TObject);
    procedure Box2EditEnter(Sender: TObject);
    procedure Box1EditEnter(Sender: TObject);
    procedure Light_1MemoEnter(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Box3EditChange(Sender: TObject);
    procedure Box2EditChange(Sender: TObject);
    procedure Box1EditChange(Sender: TObject);
    procedure Box1EditKeyPress(Sender: TObject; var Key: Char);
    procedure Box2EditKeyPress(Sender: TObject; var Key: Char);
    procedure Box3EditKeyPress(Sender: TObject; var Key: Char);
  private
    is_Sh, is_Nom, is_Ves : Boolean;
    Active_box : Integer;
    ParamsLight_local: TParams;
    fStartWrite, fBoxMove :Boolean;
    function Checked: boolean; override;//Проверка корректного ввода в Edit
    procedure WriteMsgBlink (num : Integer);
  public
    function Execute (isNEW: Boolean; inGoodsId, inGoodsKindId : Integer): Boolean; virtual;
  end;

  const msc_BoxMove   = 1500;
  const msc_BoxMove_l = 2500;
  const msc_Blink     = 700;
  const msc_Blink_l   = 100;

var
   DialogBoxLightForm: TDialogBoxLightForm;

implementation
{$R *.dfm}
uses MainCeh, UtilScale, dmMainScaleCeh;
{------------------------------------------------------------------------------}
function TDialogBoxLightForm.Execute (isNEW: Boolean; inGoodsId, inGoodsKindId : Integer) : Boolean;
begin
   //перенести локально
   CopyValuesParamsFrom(ParamsLight,ParamsLight_local);
   //
   fStartWrite:= true;
   fBoxMove:= false;
   //
   with ParamsLight_local do
   begin
     if (isNEW = TRUE)
     or ((ParamByName('GoodsTypeKindId_Sh').AsInteger  = 0)
      and(ParamByName('GoodsTypeKindId_Nom').AsInteger = 0)
      and(ParamByName('GoodsTypeKindId_Ves').AsInteger = 0))
     then begin
            // в первый раз - gpGet
            Result:= DMMainScaleCehForm.gpGet_Scale_GoodsLight(ParamsLight_local, inGoodsId, inGoodsKindId);
            if not Result then exit;
            //
            is_Sh := FALSE;
            is_Nom:= FALSE;
            is_Ves:= FALSE;
     end
     else begin
            is_Sh := (ParamByName('GoodsTypeKindId_Sh').AsInteger > 0)
                 and ((ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger)
                    or(ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger)
                    or(ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger)
                     );
            is_Nom:= (ParamByName('GoodsTypeKindId_Nom').AsInteger > 0)
                 and ((ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger)
                    or(ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger)
                    or(ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger)
                     );
            is_Ves:= (ParamByName('GoodsTypeKindId_Ves').AsInteger > 0)
                 and ((ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger)
                    or(ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger)
                    or(ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger)
                     );
     end;
     //
     // Главное сообщение - сколько ящиков
     ParamByName('Count_box').AsInteger:=0;
     if ParamByName('GoodsTypeKindId_Sh').AsInteger  > 0 then ParamByName('Count_box').AsInteger:= ParamByName('Count_box').AsInteger + 1;
     if ParamByName('GoodsTypeKindId_Nom').AsInteger > 0 then ParamByName('Count_box').AsInteger:= ParamByName('Count_box').AsInteger + 1;
     if ParamByName('GoodsTypeKindId_Ves').AsInteger > 0 then ParamByName('Count_box').AsInteger:= ParamByName('Count_box').AsInteger + 1;
     //
     if ParamByName('Count_box').AsInteger = 1 then
     begin
       Box1Edit.Enabled:= true;
       Box2Edit.Enabled:= false;
       Box3Edit.Enabled:= false;
       ActiveControl:= Box1Edit;
       // мигающее сообщение - какая линия заполняется
       //WriteMsgBlink(1);
       //
       MsgMainLabel.Caption:= 'нужно = (' + IntToStr(ParamByName('Count_box').AsInteger)+' шт.)'
                             +' ящик ' + ParamByName('BoxName_1').asString
                             +' (' + FloatToStr(ParamByName('WeightOnBox_1').asFloat) + ' кг.)';
     end
     else begin
             if ParamByName('Count_box').AsInteger = 2 then
             begin
               Box1Edit.Enabled:= true;
               Box2Edit.Enabled:= true;
               Box3Edit.Enabled:= false;
               ActiveControl:= Box2Edit;
               // мигающее сообщение - какая линия заполняется
               //WriteMsgBlink(2);
             end;
             if ParamByName('Count_box').AsInteger = 3 then
             begin
               Box1Edit.Enabled:= true;
               Box2Edit.Enabled:= true;
               Box3Edit.Enabled:= true;
               ActiveControl:= Box3Edit;
               // мигающее сообщение - какая линия заполняется
               //WriteMsgBlink(3);
             end;
             //
             MsgMainLabel.Caption:= 'нужен = (' + IntToStr(ParamByName('Count_box').AsInteger)+' шт.)'
                                      +' ящик ' + ParamByName('BoxName_1').asString
                                      +' (' + FloatToStr(ParamByName('WeightOnBox_1').asFloat) + ' кг.)';
     end;
     //
     // вывели BarCode по ящикам в контролы
     if ParamByName('BoxBarCode_1').asString <> ''
     then begin
               BoxCode1Label.Caption:= '(' + ParamByName('BoxCode_1').asString + ')';
               Box1Edit.Text        := ParamByName('BoxBarCode_1').asString;
          end
     else begin BoxCode1Label.Caption:= '(-)'; Box1Edit.Text:= ''; end;

     if ParamByName('BoxBarCode_2').asString <> ''
     then begin
               BoxCode2Label.Caption:= '(' + ParamByName('BoxCode_2').asString + ')';
               Box2Edit.Text        := ParamByName('BoxBarCode_2').asString;
          end
     else begin BoxCode2Label.Caption:= '(-)'; Box2Edit.Text:= ''; end;

     if ParamByName('BoxBarCode_3').asString <> ''
     then begin
               BoxCode3Label.Caption:= '(' + ParamByName('BoxCode_3').asString + ')';
               Box3Edit.Text        := ParamByName('BoxBarCode_3').asString;
          end
     else begin BoxCode3Label.Caption:= '(-)'; Box3Edit.Text:= ''; end;

   end;
   //
   fStartWrite:= false;
   //
   try
      MainCehForm.Set_LightOff_all;
      Timer.Interval:= msc_Blink;
      Timer.Enabled:= true;
      Result:= inherited Execute;
      //
      if not Result then ActiveControl:= bbCancel;
   finally
      Timer.Enabled:= false;
      MainCehForm.Set_LightOff_all;
   end;
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.WriteMsgBlink (num : Integer);
var lCount : Integer;
    lId    : Integer;
    lName  : String;
begin
   {if num = 1 then MsgBlinkLabel.Style.BorderColor:= SettingMain.LightColor_1;
   if num = 2 then MsgBlinkLabel.Style.BorderColor:= SettingMain.LightColor_2;
   if num = 3 then MsgBlinkLabel.Style.BorderColor:= SettingMain.LightColor_3;}
   if num = 1 then MsgBlinkLabel.Style.Color:= SettingMain.LightColor_1;
   if num = 2 then MsgBlinkLabel.Style.Color:= SettingMain.LightColor_2;
   if num = 3 then MsgBlinkLabel.Style.Color:= SettingMain.LightColor_3;
   //
   with ParamsLight_local do
   begin
     if (num = 1) then lId:= ParamByName('GoodsTypeKindId_1').AsInteger
     else if (num = 2) then lId:= ParamByName('GoodsTypeKindId_2').AsInteger
          else if (num = 3) then lId:= ParamByName('GoodsTypeKindId_3').AsInteger;

     // Главное сообщение - сколько ящиков
     lCount:=0;
     if ParamByName('GoodsTypeKindId_1').AsInteger > 0 then lCount:= lCount + 1;
     if ParamByName('GoodsTypeKindId_2').AsInteger > 0 then lCount:= lCount + 1;
     if ParamByName('GoodsTypeKindId_3').AsInteger > 0 then lCount:= lCount + 1;

     // если все заполнены
     if (lId  > 0) and (lCount = ParamByName('Count_box').AsInteger)
     then if lId = ParamByName('GoodsTypeKindId_Sh').AsInteger
          then lName:= SettingMain.Name_Sh
          else if lId = ParamByName('GoodsTypeKindId_Nom').AsInteger
               then lName:= SettingMain.Name_Nom
               else if lId = ParamByName('GoodsTypeKindId_Ves').AsInteger
                    then lName:= SettingMain.Name_Ves
                    else lName:= '???'
     else
         // выбираем первый не заполненный
         if (is_Sh = FALSE) and (ParamByName('GoodsTypeKindId_Sh').AsInteger > 0)
          then lName:= SettingMain.Name_Sh
          else if (is_Nom = FALSE) and (ParamByName('GoodsTypeKindId_Nom').AsInteger > 0)
               then lName:= SettingMain.Name_Nom
               else if (is_Ves = FALSE) and (ParamByName('GoodsTypeKindId_Ves').AsInteger > 0)
                    then lName:= SettingMain.Name_Ves
                    else lName:= '???';
   end;
   //
   if fBoxMove = TRUE
   then MsgBlinkLabel.Caption:= 'Ящик для <' + lName + '> установить на линии № ' + IntToStr(Active_box)
   else MsgBlinkLabel.Caption:= 'Просканируйте Ш/К ящика для <' + lName + '>';
   //
   if fBoxMove = TRUE
   then Timer.Interval:= msc_Blink_l
   else Timer.Interval:= msc_Blink;

end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.FormCloseQuery(Sender: TObject;var CanClose: Boolean);
begin
  inherited;
  //
  if fBoxMove = TRUE
  then CanClose:= FALSE
  else ActiveControl:= bbCancel;
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.FormCreate(Sender: TObject);
begin
  inherited;
  //
  Create_ParamsLight(ParamsLight_local);
  //
  Light_1Memo.Color:= SettingMain.LightColor_1;
  Light_2Memo.Color:= SettingMain.LightColor_2;
  Light_3Memo.Color:= SettingMain.LightColor_3;
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.FormDestroy(Sender: TObject);
begin
  inherited;
  //
  ParamsLight_local.Free;
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Light_1MemoEnter(Sender: TObject);
begin
     if ParamsLight_local.ParamByName('Count_box').AsInteger = 1 then ActiveControl:= Box1Edit
     else if ParamsLight_local.ParamByName('Count_box').AsInteger = 2 then ActiveControl:= Box2Edit
          else if ParamsLight_local.ParamByName('Count_box').AsInteger = 3 then ActiveControl:= Box3Edit;
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.TimerTimer(Sender: TObject);
begin
   {if MsgBlinkLabel.Style.BorderStyle = ebsNone
   then MsgBlinkLabel.Style.BorderStyle := ebsSingle
   else MsgBlinkLabel.Style.BorderStyle := ebsNone;}
   if Active_box = 1 then if MsgBlinkLabel.Style.Color <> clBtnFace then MsgBlinkLabel.Style.Color:= clBtnFace else MsgBlinkLabel.Style.Color:= Light_1Memo.Color;
   if Active_box = 2 then if MsgBlinkLabel.Style.Color <> clBtnFace then MsgBlinkLabel.Style.Color:= clBtnFace else MsgBlinkLabel.Style.Color:= Light_2Memo.Color;
   if Active_box = 3 then if MsgBlinkLabel.Style.Color <> clBtnFace then MsgBlinkLabel.Style.Color:= clBtnFace else MsgBlinkLabel.Style.Color:= Light_3Memo.Color;
end;
{------------------------------------------------------------------------------}
function TDialogBoxLightForm.Checked: boolean; //Проверка корректного ввода в Edit
var Id_check : Integer;
begin
     Result:= true;
     //
     with ParamsLight_local do
     begin
         //1.проверка что нужные ящики поставили
         //1.1.Sh
         Id_check:= ParamByName('GoodsTypeKindId_Sh').AsInteger;
         if Id_check > 0 then
            Result:= Result
            and ((ParamByName('GoodsTypeKindId_1').AsInteger = Id_check)
               or(ParamByName('GoodsTypeKindId_2').AsInteger = Id_check)
               or(ParamByName('GoodsTypeKindId_3').AsInteger = Id_check)
                 );
         if not Result then
         begin
              ShowMessage('Ошибка.Необходимо просканировать Ш/К ящика для <'+SettingMain.Name_Sh+'>.');
              if (Box1Edit.Enabled) and (trim (Box1Edit.Text) = '') then ActiveControl:= Box1Edit;
              if (Box2Edit.Enabled) and (trim (Box2Edit.Text) = '') then ActiveControl:= Box2Edit;
              if (Box3Edit.Enabled) and (trim (Box3Edit.Text) = '') then ActiveControl:= Box3Edit;
              exit;
         end;
         //1.2.Nom
         Id_check:= ParamByName('GoodsTypeKindId_Nom').AsInteger;
         if Id_check > 0 then
            Result:= Result
            and ((ParamByName('GoodsTypeKindId_1').AsInteger = Id_check)
               or(ParamByName('GoodsTypeKindId_2').AsInteger = Id_check)
               or(ParamByName('GoodsTypeKindId_3').AsInteger = Id_check)
                );
         if not Result then
         begin
              ShowMessage('Ошибка.Необходимо просканировать Ш/К ящика для <'+SettingMain.Name_Nom+'>.');
              if (Box1Edit.Enabled) and (trim (Box1Edit.Text) = '') then ActiveControl:= Box1Edit;
              if (Box2Edit.Enabled) and (trim (Box2Edit.Text) = '') then ActiveControl:= Box2Edit;
              if (Box3Edit.Enabled) and (trim (Box3Edit.Text) = '') then ActiveControl:= Box3Edit;
              exit;
         end;
         //1.3.Ves
         Id_check:= ParamByName('GoodsTypeKindId_Ves').AsInteger;
         if Id_check > 0 then
            Result:= Result
            and ((ParamByName('GoodsTypeKindId_1').AsInteger = Id_check)
               or(ParamByName('GoodsTypeKindId_2').AsInteger = Id_check)
               or(ParamByName('GoodsTypeKindId_3').AsInteger = Id_check)
                );
         if not Result then
         begin
              ShowMessage('Ошибка.Необходимо просканировать Ш/К ящика для <'+SettingMain.Name_Ves+'>.');
              if (Box1Edit.Enabled) and (trim (Box1Edit.Text) = '') then ActiveControl:= Box1Edit;
              if (Box2Edit.Enabled) and (trim (Box2Edit.Text) = '') then ActiveControl:= Box2Edit;
              if (Box3Edit.Enabled) and (trim (Box3Edit.Text) = '') then ActiveControl:= Box3Edit;
              exit;
         end;
         //
         //2.проверка что в значениях ящиках то что надо
         //2.1. Line-1
         Id_check:= ParamByName('GoodsTypeKindId_1').AsInteger;
         if Id_check > 0 then
            Result:= Result
            and ((ParamByName('GoodsTypeKindId_Sh').AsInteger  = Id_check)
               or(ParamByName('GoodsTypeKindId_Nom').AsInteger = Id_check)
               or(ParamByName('GoodsTypeKindId_Ves').AsInteger = Id_check)
                 );
         if not Result then
         begin
              ShowMessage('Ошибка.Ш/К ящика №1 = <'+IntToStr(Id_check)+'>'
                        + ' не попадает в диапазон <'+IntToStr(ParamByName('GoodsTypeKindId_Sh').AsInteger)+'>'
                                             + ' + <'+IntToStr(ParamByName('GoodsTypeKindId_Nom').AsInteger)+'>'
                                             + ' + <'+IntToStr(ParamByName('GoodsTypeKindId_Ves').AsInteger)+'>.');
              exit;
         end;
         //2.1. Line-2
         Id_check:= ParamByName('GoodsTypeKindId_2').AsInteger;
         if Id_check > 0 then
            Result:= Result
            and ((ParamByName('GoodsTypeKindId_Sh').AsInteger  = Id_check)
               or(ParamByName('GoodsTypeKindId_Nom').AsInteger = Id_check)
               or(ParamByName('GoodsTypeKindId_Ves').AsInteger = Id_check)
                 );
         if not Result then
         begin
              ShowMessage('Ошибка.Ш/К ящика №2 = <'+IntToStr(Id_check)+'>'
                        + ' не попадает в диапазон <'+IntToStr(ParamByName('GoodsTypeKindId_Sh').AsInteger)+'>'
                                             + ' + <'+IntToStr(ParamByName('GoodsTypeKindId_Nom').AsInteger)+'>'
                                             + ' + <'+IntToStr(ParamByName('GoodsTypeKindId_Ves').AsInteger)+'>.');
              exit;
         end;
         //2.3. Line-3
         Id_check:= ParamByName('GoodsTypeKindId_3').AsInteger;
         if Id_check > 0 then
            Result:= Result
            and ((ParamByName('GoodsTypeKindId_Sh').AsInteger  = Id_check)
               or(ParamByName('GoodsTypeKindId_Nom').AsInteger = Id_check)
               or(ParamByName('GoodsTypeKindId_Ves').AsInteger = Id_check)
                 );
         if not Result then
         begin
              ShowMessage('Ошибка.Ш/К ящика №3 = <'+IntToStr(Id_check)+'>'
                        + ' не попадает в диапазон <'+IntToStr(ParamByName('GoodsTypeKindId_Sh').AsInteger)+'>'
                                             + ' + <'+IntToStr(ParamByName('GoodsTypeKindId_Nom').AsInteger)+'>'
                                             + ' + <'+IntToStr(ParamByName('GoodsTypeKindId_Ves').AsInteger)+'>.');
              exit;
         end;
         //
         // если ШТ. нет, кому-то зальем -1
         if ParamByName('GoodsTypeKindId_Sh').AsInteger = 0 then
           if ParamByName('GoodsTypeKindId_1').AsInteger = 0
           then ParamByName('GoodsTypeKindId_1').AsInteger:= -1
           else if ParamByName('GoodsTypeKindId_2').AsInteger = 0
                then ParamByName('GoodsTypeKindId_2').AsInteger:= -1
                else if ParamByName('GoodsTypeKindId_3').AsInteger = 0
                     then ParamByName('GoodsTypeKindId_3').AsInteger:= -1;
         // если НОМ. нет, кому-то зальем -2
         if ParamByName('GoodsTypeKindId_Nom').AsInteger = 0 then
           if ParamByName('GoodsTypeKindId_1').AsInteger = 0
           then ParamByName('GoodsTypeKindId_1').AsInteger:= -2
           else if ParamByName('GoodsTypeKindId_2').AsInteger = 0
                then ParamByName('GoodsTypeKindId_2').AsInteger:= -2
                else if ParamByName('GoodsTypeKindId_3').AsInteger = 0
                     then ParamByName('GoodsTypeKindId_3').AsInteger:= -2;
         // если ВЕС нет, кому-то зальем -3
         if ParamByName('GoodsTypeKindId_Ves').AsInteger = 0 then
           if ParamByName('GoodsTypeKindId_1').AsInteger = 0
           then ParamByName('GoodsTypeKindId_1').AsInteger:= -3
           else if ParamByName('GoodsTypeKindId_2').AsInteger = 0
                then ParamByName('GoodsTypeKindId_2').AsInteger:= -3
                else if ParamByName('GoodsTypeKindId_3').AsInteger = 0
                     then ParamByName('GoodsTypeKindId_3').AsInteger:= -3;


     end;
     //
     // если все ОК - вернули новые параметры
     if Result = TRUE then CopyValuesParamsFrom(ParamsLight_local,ParamsLight);
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box1EditChange(Sender: TObject);
begin
     if (fStartWrite = TRUE) then exit;
     //
     if trim (Box1Edit.Text) = ''
     then
          // потушили № 1
          MainCehForm.Set_LightOff(1)
     else
          // зажгли № 1
          MainCehForm.Set_LightOn(1);
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box1EditEnter(Sender: TObject);
begin
     Active_box:= 1;
     // зажгли № 1
     if trim (Box1Edit.Text) <> '' then begin MainCehForm.Set_LightOff(1);MainCehForm.Set_LightOn(1);end;
     // мигающее сообщение - какая линия заполняется
     WriteMsgBlink(1);
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box1EditExit(Sender: TObject);
var lBoxBarCode : String;
    lBoxCode : Integer;
begin
   if (fStartWrite = TRUE) or (ActiveControl = bbCancel) then exit;
   if fBoxMove = TRUE then begin ActiveControl:= Box1Edit; exit;end;
   //
   //
   lBoxBarCode := TRIM (Box1Edit.Text);
   lBoxCode    := 1;
   //
   with ParamsLight_local do
   begin
      // если надо обнулить
      if lBoxBarCode = '' then
      begin
           ShowMessage('Ошибка.Необходимо заполнить');
           ActiveControl:=Box1Edit;
           exit;
           //
           if ParamByName('GoodsTypeKindId_1').AsInteger > 0 then
           begin
                //отметили что освободились
                if ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger  then is_Sh := FALSE;
                if ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger then is_Nom:= FALSE;
                if ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger then is_Ves:= FALSE;
                //обнулили в 1
                ParamByName('GoodsTypeKindId_1').AsInteger := 0;
                ParamByName('BoxCode_1').AsInteger         := 0;
                ParamByName('BoxBarCode_1').AsString       := '';
           end;
      end
      else begin
          //если что-то было - сначала освободить
          if (ParamByName('GoodsTypeKindId_1').AsInteger > 0) and (ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger)
          then is_Sh := FALSE;
          if (ParamByName('GoodsTypeKindId_1').AsInteger > 0) and (ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger)
          then is_Nom:= FALSE;
          if (ParamByName('GoodsTypeKindId_1').AsInteger > 0) and (ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger)
          then is_Ves:= FALSE;
          // если еще НЕ заполнен и нужны ШТУКИ
          if (is_Sh = FALSE) and (ParamByName('GoodsTypeKindId_Sh').AsInteger > 0)
          then begin
              //в 1 будут ШТУКИ
              ParamByName('GoodsTypeKindId_1').AsInteger := ParamByName('GoodsTypeKindId_Sh').AsInteger;
              //заполнили что ШТУКИ готовы
              is_Sh:= TRUE;
          end
          else
            // если еще НЕ заполнен и нужен НОМИНАЛ
            if (is_Nom = FALSE) and (ParamByName('GoodsTypeKindId_Nom').AsInteger > 0)
            then begin
                //в 1 будут НОМ.
                ParamByName('GoodsTypeKindId_1').AsInteger := ParamByName('GoodsTypeKindId_Nom').AsInteger;
                //заполнили что НОМ. готов
                is_Nom:= TRUE;
            end
            else
              // если еще НЕ заполнен и нужен НЕНОМИНАЛ
              if (is_Ves = FALSE) and (ParamByName('GoodsTypeKindId_Ves').AsInteger > 0)
              then begin
                  //в 1 будут НЕНОМИНАЛ
                  ParamByName('GoodsTypeKindId_1').AsInteger := ParamByName('GoodsTypeKindId_Ves').AsInteger;
                  //заполнили что НЕНОМИНАЛ готов
                  is_Ves:= TRUE;
              end
              else begin
                  //Ошибка - лишний ящик
                  ShowMessage ('Ошибка.Для <Линия 1> был введен ЛИШНИЙ ящик.Обнулите значение');
                  ActiveControl:= Box1Edit;
                  exit;
              end;
          // заполнили остальное
          ParamByName('BoxCode_1').AsInteger         := lBoxCode;
          ParamByName('BoxBarCode_1').AsString       := lBoxBarCode;
      end;
   end;
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box1EditKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
     if fBoxMove = TRUE then Key:= 0;
     //
     if Key = 13 then
     begin
          ActiveControl:= bbOk;
          //
          if ActiveControl= bbOk then
          begin
             ActiveControl:= Box1Edit;
             try
               fBoxMove:= true;
               WriteMsgBlink (1);
               MyDelay(msc_BoxMove_l);
             finally
               fBoxMove:= false;
             end;
             bbOkClick(Self);
          end;
     end;
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box1EditKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if fBoxMove = TRUE then Key:= #0;
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box2EditChange(Sender: TObject);
begin
     if (fStartWrite = TRUE) then exit;
     //
     if trim (Box2Edit.Text) = ''
     then
          // потушили № 2
          MainCehForm.Set_LightOff(2)
     else
          // зажгли № 2
          MainCehForm.Set_LightOn(2);
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box2EditEnter(Sender: TObject);
begin
     Active_box:= 2;
     // зажгли № 2
     if trim (Box2Edit.Text) <> '' then begin MainCehForm.Set_LightOff(2);MainCehForm.Set_LightOn(2);end;
     // мигающее сообщение - какая линия заполняется
     WriteMsgBlink(2);
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box2EditExit(Sender: TObject);
var lBoxBarCode : String;
    lBoxCode : Integer;
begin
   if (fStartWrite = TRUE) or (ActiveControl = bbCancel) then exit;
   if fBoxMove = TRUE then begin ActiveControl:= Box2Edit; exit;end;
   //
   //
   lBoxBarCode := Box2Edit.Text;
   lBoxCode    := 2;
   //
   with ParamsLight_local do
   begin
      // если надо обнулить
      if lBoxBarCode = '' then
      begin
           ShowMessage('Ошибка.Необходимо заполнить');
           ActiveControl:=Box2Edit;
           exit;
           //
           if ParamByName('GoodsTypeKindId_2').AsInteger > 0 then
           begin
                //отметили что освободились
                if ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger  then is_Sh := FALSE;
                if ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger then is_Nom:= FALSE;
                if ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger then is_Ves:= FALSE;
                //обнулили в 2
                ParamByName('GoodsTypeKindId_2').AsInteger := 0;
                ParamByName('BoxCode_2').AsInteger         := 0;
                ParamByName('BoxBarCode_2').AsString       := '';
           end;
      end
      else begin
          //если что-то было - сначала освободить
          if (ParamByName('GoodsTypeKindId_2').AsInteger > 0) and (ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger)
          then is_Sh := FALSE;
          if (ParamByName('GoodsTypeKindId_2').AsInteger > 0) and (ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger)
          then is_Nom:= FALSE;
          if (ParamByName('GoodsTypeKindId_2').AsInteger > 0) and (ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger)
          then is_Ves:= FALSE;
          // если еще НЕ заполнен и нужны ШТУКИ
          if (is_Sh = FALSE) and (ParamByName('GoodsTypeKindId_Sh').AsInteger > 0)
          then begin
              //в 2 будут ШТУКИ
              ParamByName('GoodsTypeKindId_2').AsInteger := ParamByName('GoodsTypeKindId_Sh').AsInteger;
              //заполнили что ШТУКИ готовы
              is_Sh:= TRUE;
          end
          else
            // если еще НЕ заполнен и нужен НОМИНАЛ
            if (is_Nom = FALSE) and (ParamByName('GoodsTypeKindId_Nom').AsInteger > 0)
            then begin
                //в 2 будут НОМ.
                ParamByName('GoodsTypeKindId_2').AsInteger := ParamByName('GoodsTypeKindId_Nom').AsInteger;
                //заполнили что НОМ. готов
                is_Nom:= TRUE;
            end
            else
              // если еще НЕ заполнен и нужен НЕНОМИНАЛ
              if (is_Ves = FALSE) and (ParamByName('GoodsTypeKindId_Ves').AsInteger > 0)
              then begin
                  //в 2 будут НЕНОМИНАЛ
                  ParamByName('GoodsTypeKindId_2').AsInteger := ParamByName('GoodsTypeKindId_Ves').AsInteger;
                  //заполнили что НЕНОМИНАЛ готов
                  is_Ves:= TRUE;
              end
              else begin
                  //Ошибка - лишний ящик
                  ShowMessage ('Ошибка.Для <Линия 2> был введен ЛИШНИЙ ящик.Обнулите значение');
                  ActiveControl:= Box2Edit;
                  exit;
              end;
          // заполнили остальное
          ParamByName('BoxCode_2').AsInteger         := lBoxCode;
          ParamByName('BoxBarCode_2').AsString       := lBoxBarCode;
      end;
   end;
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box2EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if fBoxMove = TRUE then Key:= 0;
     //
     if Key = 13 then
     begin
          ActiveControl:= bbOk;
          //
          if ActiveControl= bbOk
          then
              if Box1Edit.Enabled then
              begin
                    ActiveControl:= Box2Edit;
                    try
                      fBoxMove:= true;
                      WriteMsgBlink (2);
                      MyDelay(msc_BoxMove);
                    finally
                      fBoxMove:= false;
                    end;
                    ActiveControl:=Box1Edit;
              end
              else begin
                    ActiveControl:= Box2Edit;
                    try
                      fBoxMove:= true;
                      WriteMsgBlink (2);
                      MyDelay(msc_BoxMove_l);
                    finally
                      fBoxMove:= false;
                    end;
                    bbOkClick(Self);
              end;
     end;
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box2EditKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if fBoxMove = TRUE then Key:= #0;
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box3EditChange(Sender: TObject);
begin
     if (fStartWrite = TRUE) then exit;
     //
     if trim (Box3Edit.Text) = ''
     then
          // потушили № 3
          MainCehForm.Set_LightOff(3)
     else
          // зажгли № 3
          MainCehForm.Set_LightOn(3);
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box3EditEnter(Sender: TObject);
begin
     Active_box:= 3;
     // зажгли № 3
     if trim (Box3Edit.Text) <> '' then begin MainCehForm.Set_LightOff(3);MainCehForm.Set_LightOn(3);end;
     // мигающее сообщение - какая линия заполняется
     WriteMsgBlink(3);
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box3EditExit(Sender: TObject);
var lBoxBarCode : String;
    lBoxCode : Integer;
begin
   if (fStartWrite = TRUE) or (ActiveControl = bbCancel) then exit;
   if fBoxMove = TRUE then begin ActiveControl:= Box3Edit; exit;end;
   //
   //
   lBoxBarCode := Box3Edit.Text;
   lBoxCode    := 3;
   //
   with ParamsLight_local do
   begin
      // если надо обнулить
      if lBoxBarCode = '' then
      begin
           ShowMessage('Ошибка.Необходимо заполнить');
           ActiveControl:=Box3Edit;
           exit;
           //
           if ParamByName('GoodsTypeKindId_3').AsInteger > 0 then
           begin
                //отметили что освободились
                if ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger  then is_Sh := FALSE;
                if ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger then is_Nom:= FALSE;
                if ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger then is_Ves:= FALSE;
                //обнулили в 3
                ParamByName('GoodsTypeKindId_3').AsInteger := 0;
                ParamByName('BoxCode_3').AsInteger         := 0;
                ParamByName('BoxBarCode_3').AsString       := '';
           end;
      end
      else begin
          //если что-то было - сначала освободить
          if (ParamByName('GoodsTypeKindId_3').AsInteger > 0) and (ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger)
          then is_Sh := FALSE;
          if (ParamByName('GoodsTypeKindId_3').AsInteger > 0) and (ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger)
          then is_Nom:= FALSE;
          if (ParamByName('GoodsTypeKindId_3').AsInteger > 0) and (ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger)
          then is_Ves:= FALSE;
          // если еще НЕ заполнен и нужны ШТУКИ
          if (is_Sh = FALSE) and (ParamByName('GoodsTypeKindId_Sh').AsInteger > 0)
          then begin
              //в 3 будут ШТУКИ
              ParamByName('GoodsTypeKindId_3').AsInteger := ParamByName('GoodsTypeKindId_Sh').AsInteger;
              //заполнили что ШТУКИ готовы
              is_Sh:= TRUE;
          end
          else
            // если еще НЕ заполнен и нужен НОМИНАЛ
            if (is_Nom = FALSE) and (ParamByName('GoodsTypeKindId_Nom').AsInteger > 0)
            then begin
                //в 3 будут НОМ.
                ParamByName('GoodsTypeKindId_3').AsInteger := ParamByName('GoodsTypeKindId_Nom').AsInteger;
                //заполнили что НОМ. готов
                is_Nom:= TRUE;
            end
            else
              // если еще НЕ заполнен и нужен НЕНОМИНАЛ
              if (is_Ves = FALSE) and (ParamByName('GoodsTypeKindId_Ves').AsInteger > 0)
              then begin
                  //в 3 будут НЕНОМИНАЛ
                  ParamByName('GoodsTypeKindId_3').AsInteger := ParamByName('GoodsTypeKindId_Ves').AsInteger;
                  //заполнили что НЕНОМИНАЛ готов
                  is_Ves:= TRUE;
              end
              else begin
                  //Ошибка - лишний ящик
                  ShowMessage ('Ошибка.Для <Линия 3> был введен ЛИШНИЙ ящик.Обнулите значение');
                  ActiveControl:= Box3Edit;
                  exit;
              end;
          // заполнили остальное
          ParamByName('BoxCode_3').AsInteger         := lBoxCode;
          ParamByName('BoxBarCode_3').AsString       := lBoxBarCode;
      end;
   end;
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box3EditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
     if fBoxMove = TRUE then Key:= 0;
     //
     if Key = 13 then
     begin
          ActiveControl:= bbOk;
          //
          if ActiveControl= bbOk
          then
              if Box2Edit.Enabled then
              begin
                    ActiveControl:= Box3Edit;
                    try
                      fBoxMove:= true;
                      WriteMsgBlink (3);
                      MyDelay(msc_BoxMove);
                    finally
                      fBoxMove:= false;
                    end;
                    ActiveControl:=Box2Edit;
              end
              else
              if Box1Edit.Enabled then
              begin
                    ActiveControl:= Box3Edit;
                    try
                      fBoxMove:= true;
                      WriteMsgBlink (3);
                      MyDelay(msc_BoxMove);
                    finally
                      fBoxMove:= false;
                    end;
                    ActiveControl:=Box1Edit;
              end
              else begin
                    ActiveControl:= Box3Edit;
                    try
                      fBoxMove:= true;
                      WriteMsgBlink (3);
                      MyDelay(msc_BoxMove_l);
                    finally
                      fBoxMove:= false;
                    end;
                    bbOkClick(Self);
              end;
     end;
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box3EditKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if fBoxMove = TRUE then Key:= #0;
end;
{------------------------------------------------------------------------------}
end.
