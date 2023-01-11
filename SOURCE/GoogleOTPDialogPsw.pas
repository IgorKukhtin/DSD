unit GoogleOTPDialogPsw;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons,Db, cxGraphics, cxControls,
  cxLookAndFeels, cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinsDefaultPainters, cxTextEdit, cxCurrencyEdit, Storage, GoogleOTP,
  UtilConvert, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
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
  TGoogleOTPDialogPswForm = class(TForm)
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
    FStorage: IStorage;
    FSession: String;
    FGoogleSecret: String;
    function Checked: boolean; //Проверка корректного ввода в Edit
  public
    function Execute (pStorage: IStorage; const pSession, pGoogleSecret: String): Boolean;
  end;

implementation
{$R *.dfm}
uses Xml.XmlIntf, Xml.XMLDoc;
{------------------------------------------------------------------------------}
function TGoogleOTPDialogPswForm.Execute (pStorage: IStorage; const pSession, pGoogleSecret: String): Boolean;
begin
     FStorage:= pStorage;
     FSession:= pSession;
     FGoogleSecret := pGoogleSecret;
     //
     NumberValueEdit.Text:= '';
     ActiveControl:= NumberValueEdit;
     if (ShowModal=mrOk) then result:=True
     else result:= False;
end;
{------------------------------------------------------------------------------}
function TGoogleOTPDialogPswForm.Checked : boolean;
var N: IXMLNode;
    pXML : String;
    DateTime : TDateTime;
begin
     try if StrToInt(NumberValueEdit.Text) > 0 then
         begin
            pXML :=
            '<xml Session = "' + FSession + '" >' +
              '<gpGet_CurrentDateTimeUTC OutputType="otResult">' +
              '</gpGet_CurrentDateTimeUTC>' +
            '</xml>';

            N := LoadXMLData(FStorage.ExecuteProc(pXML, False, 4, TRUE)).DocumentElement;
            //

            DateTime := gfXSStrToDate(N.GetAttribute(AnsiLowerCase('outDateTime')));

           Result := ValidateTOPT(FGoogleSecret, StrToInt(NumberValueEdit.Text), DateTime);
           if not Result then ShowMessage('Ошибка проверки кода. Повторите ввод кода, из Google Authenticator вашего смартфона.');

         end
         else begin
               Result:=false;
               ShowMessage('Введите код, из Google Authenticator вашего смартфона.');
         end;
     except Result:=false; ShowMessage('Введите код, из Google Authenticator вашего смартфона.'); end;
end;
{------------------------------------------------------------------------------}
procedure TGoogleOTPDialogPswForm.bbOkClick(Sender: TObject);
begin
  if Checked then ModalResult:=mrOk;
end;
{------------------------------------------------------------------------------}
procedure TGoogleOTPDialogPswForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
    if ModalResult <> mrOk then
      ShowMessage('Авторизация отменена.Для продолжения работы Авторизуйтесь еще раз.');
end;
{------------------------------------------------------------------------------}
procedure TGoogleOTPDialogPswForm.FormResize(Sender: TObject);
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
