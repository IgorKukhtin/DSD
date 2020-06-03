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
    MsgMainPanel: TPanel;
    MsgMain1Label: TcxLabel;
    MsgMain3Label: TcxLabel;
    MsgMain2Label: TcxLabel;
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
    function Checked: boolean; override;//�������� ����������� ����� � Edit
    procedure WriteMsgBlink (num : Integer);
  public
    function Execute (isNEW: Boolean; inGoodsId, inGoodsKindId : Integer): Boolean; virtual;
  end;
  //����� ��������
  const msc_BoxMove   = 1000; // ���� ������� �� �� � ��������
  const msc_BoxMove_l = 2500; // ���� ������� �� ����. ����
  const msc_Blink     = 700;  // ������� ������� ���� � ������ ��� �� ������� �/� �����
  const msc_Blink_l   = 100;  // ������� ������� - �/� ����� �������, �� ��� �� ������� ������

var
   DialogBoxLightForm: TDialogBoxLightForm;

implementation
{$R *.dfm}
uses MainCeh, UtilScale, dmMainScaleCeh;
{------------------------------------------------------------------------------}
function TDialogBoxLightForm.Execute (isNEW: Boolean; inGoodsId, inGoodsKindId : Integer) : Boolean;
begin
   //��������� ��������
   CopyValuesParamsFrom(ParamsLight,ParamsLight_local);
   //
   fStartWrite:= true;
   fBoxMove:= false;
   //
   with ParamsLight_local do
   begin
     //
     // ������ BarCode �� ������ � ��������
     if ParamByName('BoxBarCode_1').asString <> ''
     then begin
               BoxCode1Label.Caption:= '(' + ParamByName('BoxCode_1').asString + ')';
               Box1Edit.Text        := ParamByName('BoxBarCode_1').asString;
          end
     else begin
               BoxCode1Label.Caption:= '(-)'; Box1Edit.Text:= '';
          end;

     if ParamByName('BoxBarCode_2').asString <> ''
     then begin
               BoxCode2Label.Caption:= '(' + ParamByName('BoxCode_2').asString + ')';
               Box2Edit.Text        := ParamByName('BoxBarCode_2').asString;
          end
     else begin
               BoxCode2Label.Caption:= '(-)'; Box2Edit.Text:= '';
          end;

     if ParamByName('BoxBarCode_3').asString <> ''
     then begin
               BoxCode3Label.Caption:= '(' + ParamByName('BoxCode_3').asString + ')';
               Box3Edit.Text        := ParamByName('BoxBarCode_3').asString;
          end
     else begin
               BoxCode3Label.Caption:= '(-)'; Box3Edit.Text:= '';
          end;
     //
     //
     if (isNEW = TRUE)
     or ((ParamByName('GoodsTypeKindId_Sh').AsInteger  = 0)
      and(ParamByName('GoodsTypeKindId_Nom').AsInteger = 0)
      and(ParamByName('GoodsTypeKindId_Ves').AsInteger = 0))
     then begin
            // � ������ ��� - gpGet
            Result:= DMMainScaleCehForm.gpGet_ScaleLight_Goods(ParamsLight_local, inGoodsId, inGoodsKindId);
            if not Result then
            begin
                 ShowMessage('����� � ������ ����� �� ������ ��� ��� ���� �� ��������� ��� �����.');
                 exit;
            end;
            //
            is_Sh := FALSE;
            is_Nom:= FALSE;
            is_Ves:= FALSE;
     end
     else begin
            is_Sh := (ParamByName('GoodsTypeKindId_Sh').AsInteger > 0)
                 and (((ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger)and(trim(ParamByName('BoxBarCode_1').AsString) <> ''))
                    or((ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger)and(trim(ParamByName('BoxBarCode_2').AsString) <> ''))
                    or((ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger)and(trim(ParamByName('BoxBarCode_3').AsString) <> ''))
                     );
            is_Nom:= (ParamByName('GoodsTypeKindId_Nom').AsInteger > 0)
                 and (((ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger)and(trim(ParamByName('BoxBarCode_1').AsString) <> ''))
                    or((ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger)and(trim(ParamByName('BoxBarCode_2').AsString) <> ''))
                    or((ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger)and(trim(ParamByName('BoxBarCode_3').AsString) <> ''))
                     );
            is_Ves:= (ParamByName('GoodsTypeKindId_Ves').AsInteger > 0)
                 and (((ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger)and(trim(ParamByName('BoxBarCode_1').AsString) <> ''))
                    or((ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger)and(trim(ParamByName('BoxBarCode_2').AsString) <> ''))
                    or((ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger)and(trim(ParamByName('BoxBarCode_3').AsString) <> ''))
                     );
            //
            if inGoodsId = -1 then begin Box1Edit.Enabled:= true; Box2Edit.Enabled:= false; Box3Edit.Enabled:= false; ActiveControl:= Box1Edit; end;
            if inGoodsId = -2 then begin Box1Edit.Enabled:= false; Box2Edit.Enabled:= true; Box3Edit.Enabled:= false; ActiveControl:= Box2Edit; end;
            if inGoodsId = -3 then begin Box1Edit.Enabled:= false; Box2Edit.Enabled:= false; Box3Edit.Enabled:= true; ActiveControl:= Box3Edit; end;
     end;
     //
     //
     if (ParamByName('Count_box').AsInteger = 1) and (inGoodsId > 0) then
     begin
       Box1Edit.Enabled:= true;
       Box2Edit.Enabled:= false;
       Box3Edit.Enabled:= false;
       ActiveControl:= Box1Edit;
       // �������� ��������� - ����� ����� �����������
       //WriteMsgBlink(1);
     end
     else begin
             if (ParamByName('Count_box').AsInteger = 2) and (inGoodsId > 0) then
             begin
               Box1Edit.Enabled:= true;
               Box2Edit.Enabled:= true;
               Box3Edit.Enabled:= false;
               ActiveControl:= Box2Edit;
               // �������� ��������� - ����� ����� �����������
               //WriteMsgBlink(2);
             end;
             if (ParamByName('Count_box').AsInteger = 3) and (inGoodsId > 0) then
             begin
               Box1Edit.Enabled:= true;
               Box2Edit.Enabled:= true;
               Box3Edit.Enabled:= true;
               ActiveControl:= Box3Edit;
               // �������� ��������� - ����� ����� �����������
               //WriteMsgBlink(3);
             end;
     end;
     //
     if ParamByName('Count_box').AsInteger > 0
     then begin
       MsgMain1Label.Caption:= '����� ������ = (' + IntToStr(ParamByName('Count_box').AsInteger)+' ��.)'
                              +' ��� = ';
       MsgMain2Label.Caption:= ParamByName('BoxName_1').asString;
       MsgMain3Label.Caption:= ' (' + FormatFloat(fmtFloat_3, (ParamByName('WeightOnBox_1').asFloat
                                                             + ParamByName('WeightOnBox_2').asFloat / 3
                                                             + ParamByName('WeightOnBox_3').asFloat
                                                              ) / ParamByName('Count_box').AsInteger
                                                 ) + ' ��.)'
                             ;
     end
     else begin
       MsgMain1Label.Caption:= '����� ������ = (' + IntToStr(ParamByName('Count_box').AsInteger)+' ��.)'
                              +' ��� = ';
       MsgMain2Label.Caption:= ParamByName('BoxName_1').asString;
       MsgMain3Label.Caption:= ' (' + FormatFloat(fmtFloat_3, 0.0) + ' ��.)'
                             ;
     end;
   end;
   //
   fStartWrite:= false;
   //
   try
      // �������� ���
      MainCehForm.Set_LightOff_all;
      Timer.Interval:= msc_Blink;
      Timer.Enabled:= true;
      Result:= inherited Execute;
      //
      if not Result then ActiveControl:= bbCancel;
   finally
      Timer.Enabled:= false;
      // �������� ���
      MainCehForm.Set_LightOff_all;
      //
      ParamsLight.ParamByName('isFull_1').asBoolean:= FALSE;
      ParamsLight.ParamByName('isFull_2').asBoolean:= FALSE;
      ParamsLight.ParamByName('isFull_3').asBoolean:= FALSE;
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

     // ������� ��������� - ������� ������
     lCount:=0;
     if ParamByName('GoodsTypeKindId_1').AsInteger > 0 then lCount:= lCount + 1;
     if ParamByName('GoodsTypeKindId_2').AsInteger > 0 then lCount:= lCount + 1;
     if ParamByName('GoodsTypeKindId_3').AsInteger > 0 then lCount:= lCount + 1;

     // ���� ��� ���������
     if (lId  > 0) and (lCount = ParamByName('Count_box').AsInteger)
     then if lId = ParamByName('GoodsTypeKindId_Sh').AsInteger
          then lName:= SettingMain.Name_Sh
          else if lId = ParamByName('GoodsTypeKindId_Nom').AsInteger
               then lName:= SettingMain.Name_Nom
               else if lId = ParamByName('GoodsTypeKindId_Ves').AsInteger
                    then lName:= SettingMain.Name_Ves
                    else lName:= '???'
     else
         // �������� ������ �� �����������
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
   then MsgBlinkLabel.Caption:= '���� ��� <' + lName + '> ���������� �� ����� � ' + IntToStr(Active_box)
   else MsgBlinkLabel.Caption:= '������������� �/� ����� ��� <' + lName + '>';
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
  //
  if SettingMain.isLightLEFT_123 = TRUE then
  begin
     Box3Label.Caption:= '����� 3 :';
     Box1Label.Caption:= '����� 1 :';
  end
  else
  begin
     Box3Label.Caption:= '����� 1 :';
     Box1Label.Caption:= '����� 3 :';
  end;
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
function TDialogBoxLightForm.Checked: boolean; //�������� ����������� ����� � Edit
var Id_check : Integer;
begin
     Result:= true;
     //
     with ParamsLight_local do
     begin
         //1.�������� ��� ������ ����� ���������
         //1.1.Sh
         Id_check:= ParamByName('GoodsTypeKindId_Sh').AsInteger;
         if Id_check > 0 then
            Result:= Result
            and (is_Sh = TRUE)
            and (((ParamByName('GoodsTypeKindId_1').AsInteger = Id_check)and(trim(Box1Edit.Text)<>''))
               or((ParamByName('GoodsTypeKindId_2').AsInteger = Id_check)and(trim(Box2Edit.Text)<>''))
               or((ParamByName('GoodsTypeKindId_3').AsInteger = Id_check)and(trim(Box3Edit.Text)<>''))
                 );
         if not Result then
         begin
              ShowMessage('������.���������� �������������� �/� ����� ��� <'+SettingMain.Name_Sh+'>.');
              if ParamByName('GoodsTypeKindId_1').AsInteger = Id_check then if Box1Edit.Enabled then ActiveControl:= Box1Edit;
              if ParamByName('GoodsTypeKindId_2').AsInteger = Id_check then if Box2Edit.Enabled then ActiveControl:= Box2Edit;
              if ParamByName('GoodsTypeKindId_3').AsInteger = Id_check then if Box3Edit.Enabled then ActiveControl:= Box3Edit;
              exit;
         end;
         //1.2.Nom
         Id_check:= ParamByName('GoodsTypeKindId_Nom').AsInteger;
         if Id_check > 0 then
            Result:= Result
            and (is_Nom = TRUE)
            and (((ParamByName('GoodsTypeKindId_1').AsInteger = Id_check)and(trim(Box1Edit.Text)<>''))
               or((ParamByName('GoodsTypeKindId_2').AsInteger = Id_check)and(trim(Box2Edit.Text)<>''))
               or((ParamByName('GoodsTypeKindId_3').AsInteger = Id_check)and(trim(Box3Edit.Text)<>''))
                );
         if not Result then
         begin
              ShowMessage('������.���������� �������������� �/� ����� ��� <'+SettingMain.Name_Nom+'>.');
              if ParamByName('GoodsTypeKindId_1').AsInteger = Id_check then if Box1Edit.Enabled then ActiveControl:= Box1Edit;
              if ParamByName('GoodsTypeKindId_2').AsInteger = Id_check then if Box2Edit.Enabled then ActiveControl:= Box2Edit;
              if ParamByName('GoodsTypeKindId_3').AsInteger = Id_check then if Box3Edit.Enabled then ActiveControl:= Box3Edit;
              exit;
         end;
         //1.3.Ves
         Id_check:= ParamByName('GoodsTypeKindId_Ves').AsInteger;
         if Id_check > 0 then
            Result:= Result
            and (is_Ves = TRUE)
            and (((ParamByName('GoodsTypeKindId_1').AsInteger = Id_check)and(trim(Box1Edit.Text)<>''))
               or((ParamByName('GoodsTypeKindId_2').AsInteger = Id_check)and(trim(Box2Edit.Text)<>''))
               or((ParamByName('GoodsTypeKindId_3').AsInteger = Id_check)and(trim(Box3Edit.Text)<>''))
                );
         if not Result then
         begin
              ShowMessage('������.���������� �������������� �/� ����� ��� <'+SettingMain.Name_Ves+'>.');
              if ParamByName('GoodsTypeKindId_1').AsInteger = Id_check then if Box1Edit.Enabled then ActiveControl:= Box1Edit;
              if ParamByName('GoodsTypeKindId_2').AsInteger = Id_check then if Box2Edit.Enabled then ActiveControl:= Box2Edit;
              if ParamByName('GoodsTypeKindId_3').AsInteger = Id_check then if Box3Edit.Enabled then ActiveControl:= Box3Edit;
              exit;
         end;
         //
         //
         //2.�������� ��� � ��������� ������ �� ��� ����
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
              ShowMessage('������.�/� ����� �1 = <'+IntToStr(Id_check)+'>'
                        + ' �� �������� � �������� <'+IntToStr(ParamByName('GoodsTypeKindId_Sh').AsInteger)+'>'
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
              ShowMessage('������.�/� ����� �2 = <'+IntToStr(Id_check)+'>'
                        + ' �� �������� � �������� <'+IntToStr(ParamByName('GoodsTypeKindId_Sh').AsInteger)+'>'
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
              ShowMessage('������.�/� ����� �3 = <'+IntToStr(Id_check)+'>'
                        + ' �� �������� � �������� <'+IntToStr(ParamByName('GoodsTypeKindId_Sh').AsInteger)+'>'
                                             + ' + <'+IntToStr(ParamByName('GoodsTypeKindId_Nom').AsInteger)+'>'
                                             + ' + <'+IntToStr(ParamByName('GoodsTypeKindId_Ves').AsInteger)+'>.');
              exit;
         end;
         //
         //
         //3.�������� ��� ������ ����� (!!!���������!!!)
         // ��� 2+1
         Result:= Result
         and ((ParamByName('BoxBarCode_1').AsString <> ParamByName('BoxBarCode_2').AsString)
           or (ParamByName('BoxBarCode_1').AsString = '')
           or (ParamByName('BoxBarCode_2').AsString = '')
             );
         if not Result then
         begin
              ShowMessage('������.������ ���������� �/� ������ ��� <'+Box2Label.Caption+'>  � <'+Box1Label.Caption+'> = <'+ParamByName('BoxBarCode_1').AsString+'>');
              if Box2Edit.Enabled then ActiveControl:= Box2Edit;
              exit;
         end;
         // ��� 3+1
         Result:= Result
         and ((ParamByName('BoxBarCode_1').AsString  <> ParamByName('BoxBarCode_3').AsString)
           or (ParamByName('BoxBarCode_1').AsString = '')
           or (ParamByName('BoxBarCode_3').AsString = '')
             );
         if not Result then
         begin
              ShowMessage('������.������ ���������� �/� ������ ��� <'+Box3Label.Caption+'>  � <'+Box1Label.Caption+'> = <'+ParamByName('BoxBarCode_1').AsString+'>');
              if Box3Edit.Enabled then ActiveControl:= Box3Edit;
              exit;
         end;
         // ��� 3+2
         Result:= Result
         and ((ParamByName('BoxBarCode_2').AsString  <> ParamByName('BoxBarCode_3').AsString)
           or (ParamByName('BoxBarCode_2').AsString = '')
           or (ParamByName('BoxBarCode_3').AsString = '')
             );
         if not Result then
         begin
              ShowMessage('������.������ ���������� �/� ������ ��� <'+Box3Label.Caption+'>  � <'+Box2Label.Caption+'> = <'+ParamByName('BoxBarCode_2').AsString+'>');
              if Box3Edit.Enabled then ActiveControl:= Box3Edit;
              exit;
         end;
     end;
     //
     // ���� ��� �� - ������� ����� ���������
     if Result = TRUE then CopyValuesParamsFrom(ParamsLight_local,ParamsLight);
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box1EditChange(Sender: TObject);
begin
     if (fStartWrite = TRUE) then exit;
     //
     // ������ ���������
     with ParamsLight_local do
       if ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger
       then is_Sh := FALSE
       else
           if ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger
           then is_Nom := FALSE
           else
               if ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger
               then is_Ves := FALSE;
     //
     {if trim (Box1Edit.Text) = ''
     then
          // �������� � 1
          MainCehForm.Set_LightOff(1)
     else
          // ������ � 1
          MainCehForm.Set_LightOn(1);}
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box1EditEnter(Sender: TObject);
begin
     Active_box:= 1;
     // ������/�������� � 1
     //if trim (Box1Edit.Text) <> '' then
     MainCehForm.Set_FlashOn(1);
     // �������� ��������� - ����� ����� �����������
     WriteMsgBlink(1);
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box1EditExit(Sender: TObject);
var lBoxBarCode : String;
begin
   if (fStartWrite = TRUE) or (ActiveControl = bbCancel) then exit;
   if fBoxMove = TRUE then begin ActiveControl:= Box1Edit; exit;end;
   //
   //
   with ParamsLight_local do
   begin
      // ���� ���� ��������
      if TRIM (Box1Edit.Text) = '' then
      begin
           ShowMessage('������.���������� ���������');
           ActiveControl:=Box1Edit;
           exit;
           //
           {if ParamByName('GoodsTypeKindId_1').AsInteger > 0 then
           begin
                //�������� ��� ������������
                if ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger  then is_Sh := FALSE;
                if ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger then is_Nom:= FALSE;
                if ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger then is_Ves:= FALSE;
                //�������� � 1
                //ParamByName('GoodsTypeKindId_1').AsInteger := 0;
                ParamByName('BoxCode_1').AsInteger         := 0;
                ParamByName('BoxBarCode_1').AsString       := '';
           end;}
      end
      else if trim(Box1Edit.Text) = trim(Box2Edit.Text) then
      begin
           ShowMessage('������.������ ���������� �/� ������ ��� <'+Box1Label.Caption+'>  � <'+Box2Label.Caption+'> = <'+trim(Box1Edit.Text)+'>');
           ActiveControl:= Box1Edit;
           exit;
      end
      else if trim(Box1Edit.Text) = trim(Box3Edit.Text) then
      begin
           ShowMessage('������.������ ���������� �/� ������ ��� <'+Box1Label.Caption+'>  � <'+Box3Label.Caption+'> = <'+trim(Box1Edit.Text)+'>');
           ActiveControl:= Box1Edit;
           exit;
      end
      else begin
          //
          ParamByName('BoxBarCode_1').AsString:= TRIM (Box1Edit.Text);
          // �����/��������� � ���� ���� - �������� �/� � ����������
          if not DMMainScaleCehForm.gpGet_ScaleLight_BarCodeBox (1, ParamsLight_local) then begin ActiveControl:=Box1Edit; exit; end;
          //
          //
          if (ParamByName('GoodsTypeKindId_1').AsInteger > 0) and (ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger)
          then is_Sh := FALSE;
          if (ParamByName('GoodsTypeKindId_1').AsInteger > 0) and (ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger)
          then is_Nom:= FALSE;
          if (ParamByName('GoodsTypeKindId_1').AsInteger > 0) and (ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger)
          then is_Ves:= FALSE;
          // ���� ��� �� �������� � ����� �����
          if (is_Sh = FALSE) and (ParamByName('GoodsTypeKindId_Sh').AsInteger > 0)
             and (ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger)
          then begin
              //� 1 ����� �����
              //ParamByName('GoodsTypeKindId_1').AsInteger := ParamByName('GoodsTypeKindId_Sh').AsInteger;
              //��������� ��� ����� ������
              is_Sh:= TRUE;
          end
          else
            // ���� ��� �� �������� � ����� �������
            if (is_Nom = FALSE) and (ParamByName('GoodsTypeKindId_Nom').AsInteger > 0)
               and (ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger)
            then begin
                //� 1 ����� ���.
                //ParamByName('GoodsTypeKindId_1').AsInteger := ParamByName('GoodsTypeKindId_Nom').AsInteger;
                //��������� ��� ���. �����
                is_Nom:= TRUE;
            end
            else
              // ���� ��� �� �������� � ����� ���
              if (is_Ves = FALSE) and (ParamByName('GoodsTypeKindId_Ves').AsInteger > 0)
                  and (ParamByName('GoodsTypeKindId_1').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger)
              then begin
                  //� 1 ����� ���
                  //ParamByName('GoodsTypeKindId_1').AsInteger := ParamByName('GoodsTypeKindId_Ves').AsInteger;
                  //��������� ��� ��� �����
                  is_Ves:= TRUE;
              end
              else begin
                  //������ - ������ ����
                  ShowMessage ('������.��� <����� 1> ��� ������ ������ ����.�������� ��������');
                  ActiveControl:= Box1Edit;
                  exit;
              end;
          //
          fStartWrite:= true;
          BoxCode1Label.Caption:= '(' + ParamByName('BoxCode_1').asString + ')';
          Box1Edit.Text:= ParamByName('BoxBarCode_1').AsString;
          fStartWrite:= false;
          // ������ � 1
          MainCehForm.Set_LightOn(1);
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
          // ���� ����� ��������
          if ActiveControl= bbOk then
          begin
             // �������� ���� � 1
             ActiveControl:= Box1Edit;
             try
               fBoxMove:= true;
               WriteMsgBlink (1);
               MyDelay(msc_BoxMove_l);
             finally
               fBoxMove:= false;
             end;
             // �������
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
     // ������ ���������
     with ParamsLight_local do
       if ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger
       then is_Sh := FALSE
       else
           if ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger
           then is_Nom := FALSE
           else
               if ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger
               then is_Ves := FALSE;
     //
     {if trim (Box2Edit.Text) = ''
     then
          // �������� � 2
        //MainCehForm.Set_LightOff(2)
          MainCehForm.Set_LightOn(2)
     else
          // ������ � 2
          MainCehForm.Set_LightOn(2);}
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box2EditEnter(Sender: TObject);
begin
     Active_box:= 2;
     // ������/�������� � 2
     //if trim (Box2Edit.Text) <> '' then
     MainCehForm.Set_FlashOn(2);
     // �������� ��������� - ����� ����� �����������
     WriteMsgBlink(2);
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box2EditExit(Sender: TObject);
begin
   if (fStartWrite = TRUE) or (ActiveControl = bbCancel) then exit;
   if fBoxMove = TRUE then begin ActiveControl:= Box2Edit; exit;end;
   //
   //
   with ParamsLight_local do
   begin
      // ���� ���� ��������
      if trim(Box2Edit.Text) = '' then
      begin
           ShowMessage('������.���������� ���������');
           ActiveControl:=Box2Edit;
           exit;
           //
           {if ParamByName('GoodsTypeKindId_2').AsInteger > 0 then
           begin
                //�������� ��� ������������
                if ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger  then is_Sh := FALSE;
                if ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger then is_Nom:= FALSE;
                if ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger then is_Ves:= FALSE;
                //�������� � 2
                //ParamByName('GoodsTypeKindId_2').AsInteger := 0;
                ParamByName('BoxCode_2').AsInteger         := 0;
                ParamByName('BoxBarCode_2').AsString       := '';
           end;}
      end
      else if trim(Box2Edit.Text) = trim(Box3Edit.Text) then
      begin
           ShowMessage('������.������ ���������� �/� ������ ��� <'+Box2Label.Caption+'>  � <'+Box3Label.Caption+'> = <'+trim(Box2Edit.Text)+'>');
           ActiveControl:= Box2Edit;
           exit;
      end
      else if trim(Box2Edit.Text) = trim(Box1Edit.Text) then
      begin
           ShowMessage('������.������ ���������� �/� ������ ��� <'+Box2Label.Caption+'>  � <'+Box1Label.Caption+'> = <'+trim(Box2Edit.Text)+'>');
           ActiveControl:= Box2Edit;
           exit;
      end
      else begin
          //
          ParamByName('BoxBarCode_2').AsString:= trim(Box2Edit.Text);
          // �����/��������� � ���� ���� - �������� �/� � ����������
          if not DMMainScaleCehForm.gpGet_ScaleLight_BarCodeBox (2, ParamsLight_local) then begin ActiveControl:=Box2Edit; exit; end;
          //
          //���� ���-�� ���� - ������� ����������
          if (ParamByName('GoodsTypeKindId_2').AsInteger > 0) and (ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger)
          then is_Sh := FALSE;
          if (ParamByName('GoodsTypeKindId_2').AsInteger > 0) and (ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger)
          then is_Nom:= FALSE;
          if (ParamByName('GoodsTypeKindId_2').AsInteger > 0) and (ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger)
          then is_Ves:= FALSE;
          // ���� ��� �� �������� � ����� �����
          if (is_Sh = FALSE) and (ParamByName('GoodsTypeKindId_Sh').AsInteger > 0)
              and(ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger)
          then begin
              //� 2 ����� �����
              //ParamByName('GoodsTypeKindId_2').AsInteger := ParamByName('GoodsTypeKindId_Sh').AsInteger;
              //��������� ��� ����� ������
              is_Sh:= TRUE;
          end
          else
            // ���� ��� �� �������� � ����� �������
            if (is_Nom = FALSE) and (ParamByName('GoodsTypeKindId_Nom').AsInteger > 0)
               and(ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger)
            then begin
                //� 2 ����� ���.
                //ParamByName('GoodsTypeKindId_2').AsInteger := ParamByName('GoodsTypeKindId_Nom').AsInteger;
                //��������� ��� ���. �����
                is_Nom:= TRUE;
            end
            else
              // ���� ��� �� �������� � ����� ���
              if (is_Ves = FALSE) and (ParamByName('GoodsTypeKindId_Ves').AsInteger > 0)
                 and(ParamByName('GoodsTypeKindId_2').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger)
              then begin
                  //� 2 ����� ���
                  //ParamByName('GoodsTypeKindId_2').AsInteger := ParamByName('GoodsTypeKindId_Ves').AsInteger;
                  //��������� ��� ��� �����
                  is_Ves:= TRUE;
              end
              else begin
                  //������ - ������ ����
                  ShowMessage ('������.��� <����� 2> ��� ������ ������ ����.�������� ��������');
                  ActiveControl:= Box2Edit;
                  exit;
              end;
          //
          fStartWrite:= true;
          BoxCode2Label.Caption:= '(' + ParamByName('BoxCode_2').asString + ')';
          Box2Edit.Text:= ParamByName('BoxBarCode_2').AsString;
          fStartWrite:= false;
          // ������ � 2
          MainCehForm.Set_LightOn(2);
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
              // ���� ������� ����� � 1
              if Box1Edit.Enabled then
              begin
                    // �������� ���� � 2
                    ActiveControl:= Box2Edit;
                    try
                      fBoxMove:= true;
                      WriteMsgBlink (2);
                      MyDelay(msc_BoxMove);
                    finally
                      fBoxMove:= false;
                    end;
                    // ������� � 1
                    ActiveControl:=Box1Edit;
              end
              // ���� ����� ��������
              else begin
                    // �������� ���� � 2
                    ActiveControl:= Box2Edit;
                    try
                      fBoxMove:= true;
                      WriteMsgBlink (2);
                      MyDelay(msc_BoxMove_l);
                    finally
                      fBoxMove:= false;
                    end;
                    // �������
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
     // ������ ���������
     with ParamsLight_local do
       if ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger
       then is_Sh := FALSE
       else
           if ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger
           then is_Nom := FALSE
           else
               if ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger
               then is_Ves := FALSE;
     //
     {if trim (Box3Edit.Text) = ''
     then
          // �������� � 3
        //MainCehForm.Set_LightOff(3)
          MainCehForm.Set_LightOn(3)
     else
          // ������ � 3
          MainCehForm.Set_LightOn(3);}
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box3EditEnter(Sender: TObject);
begin
     Active_box:= 3;
     // ������/�������� � 3
     //if trim (Box3Edit.Text) <> '' then
     MainCehForm.Set_FlashOn(3);
     // �������� ��������� - ����� ����� �����������
     WriteMsgBlink(3);
end;
{------------------------------------------------------------------------------}
procedure TDialogBoxLightForm.Box3EditExit(Sender: TObject);
begin
   if (fStartWrite = TRUE) or (ActiveControl = bbCancel) then exit;
   if fBoxMove = TRUE then begin ActiveControl:= Box3Edit; exit;end;
   //
   //
   with ParamsLight_local do
   begin
      // ���� ���� ��������
      if trim(Box3Edit.Text) = '' then
      begin
           ShowMessage('������.���������� ���������');
           ActiveControl:=Box3Edit;
           exit;
           //
           {if ParamByName('GoodsTypeKindId_3').AsInteger > 0 then
           begin
                //�������� ��� ������������
                if ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger  then is_Sh := FALSE;
                if ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger then is_Nom:= FALSE;
                if ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger then is_Ves:= FALSE;
                //�������� � 3
                //ParamByName('GoodsTypeKindId_3').AsInteger := 0;
                ParamByName('BoxCode_3').AsInteger         := 0;
                ParamByName('BoxBarCode_3').AsString       := '';
           end;}
      end
      else if trim(Box3Edit.Text) = trim(Box2Edit.Text) then
      begin
           ShowMessage('������.������ ���������� �/� ������ ��� <'+Box3Label.Caption+'>  � <'+Box2Label.Caption+'> = <'+trim(Box3Edit.Text)+'>');
           ActiveControl:= Box3Edit;
           exit;
      end
      else if trim(Box3Edit.Text) = trim(Box1Edit.Text) then
      begin
           ShowMessage('������.������ ���������� �/� ������ ��� <'+Box3Label.Caption+'>  � <'+Box1Label.Caption+'> = <'+trim(Box3Edit.Text)+'>');
           ActiveControl:= Box3Edit;
           exit;
      end
      else begin
          //
          ParamByName('BoxBarCode_3').AsString:= trim(Box3Edit.Text);
          // �����/��������� � ���� ���� - �������� �/� � ����������
          if not DMMainScaleCehForm.gpGet_ScaleLight_BarCodeBox (3, ParamsLight_local) then begin ActiveControl:=Box3Edit; exit; end;
          //
          //���� ���-�� ���� - ������� ����������
          if (ParamByName('GoodsTypeKindId_3').AsInteger > 0) and (ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger)
          then is_Sh := FALSE;
          if (ParamByName('GoodsTypeKindId_3').AsInteger > 0) and (ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger)
          then is_Nom:= FALSE;
          if (ParamByName('GoodsTypeKindId_3').AsInteger > 0) and (ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger)
          then is_Ves:= FALSE;
          // ���� ��� �� �������� � ����� �����
          if (is_Sh = FALSE) and (ParamByName('GoodsTypeKindId_Sh').AsInteger > 0)
             and(ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Sh').AsInteger)
          then begin
              //� 3 ����� �����
              //ParamByName('GoodsTypeKindId_3').AsInteger := ParamByName('GoodsTypeKindId_Sh').AsInteger;
              //��������� ��� ����� ������
              is_Sh:= TRUE;
          end
          else
            // ���� ��� �� �������� � ����� �������
            if (is_Nom = FALSE) and (ParamByName('GoodsTypeKindId_Nom').AsInteger > 0)
               and(ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Nom').AsInteger)
            then begin
                //� 3 ����� ���.
                //ParamByName('GoodsTypeKindId_3').AsInteger := ParamByName('GoodsTypeKindId_Nom').AsInteger;
                //��������� ��� ���. �����
                is_Nom:= TRUE;
            end
            else
              // ���� ��� �� �������� � ����� ���
              if (is_Ves = FALSE) and (ParamByName('GoodsTypeKindId_Ves').AsInteger > 0)
                 and(ParamByName('GoodsTypeKindId_3').AsInteger = ParamByName('GoodsTypeKindId_Ves').AsInteger)
              then begin
                  //� 3 ����� ���
                  //ParamByName('GoodsTypeKindId_3').AsInteger := ParamByName('GoodsTypeKindId_Ves').AsInteger;
                  //��������� ��� ��� �����
                  is_Ves:= TRUE;
              end
              else begin
                  //������ - ������ ����
                  ShowMessage ('������.��� <����� 3> ��� ������ ������ ����.�������� ��������');
                  ActiveControl:= Box3Edit;
                  exit;
              end;
          //
          fStartWrite:= true;
          BoxCode3Label.Caption:= '(' + ParamByName('BoxCode_3').asString + ')';
          Box3Edit.Text:= ParamByName('BoxBarCode_3').AsString;
          fStartWrite:= false;
          // ������ � 3
          MainCehForm.Set_LightOn(3);
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
              // ���� ������� ����� � 2
              if Box2Edit.Enabled then
              begin
                    // �������� ���� � 3
                    ActiveControl:= Box3Edit;
                    try
                      fBoxMove:= true;
                      WriteMsgBlink (3);
                      MyDelay(msc_BoxMove);
                    finally
                      fBoxMove:= false;
                    end;
                    // ������� � 2
                    ActiveControl:=Box2Edit;
              end
              else
              // ���� ������� ����� � 1
              if Box1Edit.Enabled then
              begin
                    // �������� ���� � 3
                    ActiveControl:= Box3Edit;
                    try
                      fBoxMove:= true;
                      WriteMsgBlink (3);
                      MyDelay(msc_BoxMove);
                    finally
                      fBoxMove:= false;
                    end;
                    // ������� � 1
                    ActiveControl:=Box1Edit;
              end
              // ���� ����� ��������
              else begin
                    // �������� ���� � 3
                    ActiveControl:= Box3Edit;
                    try
                      fBoxMove:= true;
                      WriteMsgBlink (3);
                      MyDelay(msc_BoxMove_l);
                    finally
                      fBoxMove:= false;
                    end;
                    // �������
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
