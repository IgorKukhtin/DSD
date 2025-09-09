unit DialogPswSms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons,Db, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinsDefaultPainters, cxTextEdit, cxCurrencyEdit
 ,Storage, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

type
  TDialogPswSmsForm = class(TForm)
    bbPanel: TPanel;
    bbOk: TBitBtn;
    bbCancel: TBitBtn;
    PanelNumberValue: TPanel;
    LabelNumberValue: TLabel;
    NumberValueEdit: TcxCurrencyEdit;
    procedure bbOkClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  protected
    lStorage: IStorage;
    lSession: String;
    function Checked: boolean; //Проверка корректного ввода в Edit
  public
    function Execute (pStorage: IStorage; pSession: String): String;
  end;

implementation
{$R *.dfm}
uses Xml.XmlIntf, Xml.XMLDoc;
{------------------------------------------------------------------------------}
function TDialogPswSmsForm.Execute (pStorage: IStorage; pSession: String): String;
begin
     lStorage:= pStorage;
     lSession:= pSession;
     //
     NumberValueEdit.Text:= '';
     ActiveControl:= NumberValueEdit;
     if (ShowModal=mrOk) then result:=NumberValueEdit.Text
     else result:= '';
end;
{------------------------------------------------------------------------------}
function TDialogPswSmsForm.Checked;
var N: IXMLNode;
    pXML : String;
begin
     try if StrToInt(NumberValueEdit.Text) > 0 then
         begin
            pXML :=
            '<xml Session = "' + lSession + '" >' +
              '<gpSelect_Object_User_checkSMS OutputType="otResult">' +
                '<inValueSMS DataType="ftString" Value="%s" />' +
              '</gpSelect_Object_User_checkSMS>' +
            '</xml>';

            N := LoadXMLData(lStorage.ExecuteProc(Format(pXML, [NumberValueEdit.Text]), False, 4, TRUE)).DocumentElement;
            //
            if Assigned(N)
            then Result:= N.GetAttribute(AnsiLowerCase('outMessage')) = ''
            else Result:= false;
            //
            if not Result then ShowMessage(N.GetAttribute(AnsiLowerCase('outMessage')));

         end
         else begin
               Result:=false;
               ShowMessage('Введите код, SMS было отправлено на Ваш номер телефона.');
         end;
     except Result:=false; ShowMessage('Введите код, SMS было отправлено на Ваш номер телефона.'); end;
end;
{------------------------------------------------------------------------------}
procedure TDialogPswSmsForm.bbOkClick(Sender: TObject);
begin if Checked
then ModalResult:=mrOk;
end;
{------------------------------------------------------------------------------}
procedure TDialogPswSmsForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    if ModalResult <> mrOk then
      ShowMessage('Авторизация отменена.Для продолжения работы Авторизуйтесь еще раз.');
    //if MessageDlg('Действительно отмененить Авторизацию?',mtConfirmation,mbYesNoCancel,0) <> 6
end;
{------------------------------------------------------------------------------}
procedure TDialogPswSmsForm.FormResize(Sender: TObject);
begin
 bbOk.Top:=(bbPanel.Height-bbOk.Height) div 2;
 bbCancel.Top:=bbOk.Top;
 bbOK.Left:=((bbPanel.Width div 2)*9) div 10 -bbOK.width;
 if bbOK.Visible
 then bbCancel.Left:=((bbPanel.Width div 2)*11)div 10
 else bbCancel.Left:=(bbPanel.Width div 2)-(bbCancel.Width div 2);
 //
 NumberValueEdit.Left:= (bbPanel.Width div 2) - (NumberValueEdit.Width div 2);

end;
{------------------------------------------------------------------------------}

end.
