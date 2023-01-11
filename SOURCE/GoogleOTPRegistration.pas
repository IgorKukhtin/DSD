unit GoogleOTPRegistration;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.OleCtrls, SHDocVw,
  Vcl.ExtCtrls, IdURI, GoogleOTP, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, dxSkinsCore, dxSkinsDefaultPainters,
  cxButtons, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP, cxControls, cxContainer, cxEdit, cxImage, dxSkinBlack, dxSkinBlue,
  dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide,
  dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TGoogleOTPRegistrationForm = class(TForm)
    Panel1: TPanel;
    cxButton1: TcxButton;
    cxButton2: TcxButton;
    IdHTTP: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL;
    cxImage: TcxImage;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FProjectName: String;
    FUserName: String;
    FGoogleSecret : String;
  public
    { Public declarations }
    function Execute (const pProjectName, pUserName: String; var pGoogleSecret: String): Boolean;
  end;

implementation

{$R *.dfm}

function TGoogleOTPRegistrationForm.Execute (const pProjectName, pUserName: String; var pGoogleSecret: String): Boolean;
begin
  FProjectName := pProjectName;
  FUserName := pUserName;
  FGoogleSecret := GenerateOTPSecret;
  result:= (ShowModal = mrOk) and (FGoogleSecret <> '');
  if result then pGoogleSecret := FGoogleSecret;
end;

procedure TGoogleOTPRegistrationForm.FormShow(Sender: TObject);
  var tmpStream: TMemoryStream;  Graphic: TGraphic;
      sl: TStringList;
begin
   IdHTTP.Request.Clear;
   IdHTTP.Request.CustomHeaders.Clear;
   IdHTTP.Request.ContentType := 'application/x-www-form-urlencoded';
   IdHTTP.Request.ContentEncoding := 'utf-8';
   IdHTTP.Request.CustomHeaders.FoldLines := False;

   sl := TStringList.Create;
   sl.Add('chs=200x200');
   sl.Add('cht=qr');
   sl.Add('chld=M');
   sl.Add('chl=otpauth://totp/' + FProjectName + ':' + FUserName + '?secret=' + FGoogleSecret +
                     '&issuer=' + FProjectName);

   tmpStream := TMemoryStream.Create;
   Graphic := TGraphicClass(TWICImage).Create;
   try
     try
       IdHTTP.POST('https://chart.apis.google.com/chart', sl, tmpStream);
       tmpStream.Seek(0, soFromBeginning);
       Graphic.LoadFromStream(tmpStream);
       cxImage.Picture.Graphic := Graphic;
     except
     end;
   finally
     tmpStream.Free;
     Graphic.Free;
     sl.Free;
   end;

end;

end.
