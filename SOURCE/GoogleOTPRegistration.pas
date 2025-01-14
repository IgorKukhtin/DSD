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
  dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint, dxSkinXmas2008Blue
  {$IFDEF VER340}, REST.Types, REST.Client, REST.Response.Adapter{$ENDIF};

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
  var
{$IFDEF VER340}
    FRESTClient: TRESTClient;
    FRESTResponse: TRESTResponse;
    FRESTRequest: TRESTRequest;
    tmpStream: TMemoryStream;  Graphic: TGraphic;
{$ELSE}
    tmpStream: TMemoryStream;  Graphic: TGraphic;
    sl: TStringList;
{$ENDIF}
begin

{$IFDEF VER340}
  FRESTClient := TRESTClient.Create('');
  FRESTResponse := TRESTResponse.Create(Nil);
  FRESTRequest := TRESTRequest.Create(Nil);
  FRESTRequest.Client := FRESTClient;
  FRESTRequest.Response := FRESTResponse;
  try
    FRESTClient.BaseURL := 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=otpauth://totp/' +
      FProjectName + ':' + FUserName + '?secret=' + FGoogleSecret + '%26issuer=' + FProjectName;
    FRESTClient.ContentType := 'application/x-www-form-urlencoded';

    FRESTRequest.ClearBody;
    FRESTRequest.Method := TRESTRequestMethod.rmPOST;
    FRESTRequest.Resource := '';
    // required parameters
    FRESTRequest.Params.Clear;

    try
      FRESTRequest.Execute;
    except
    end;

    if (FRESTResponse.StatusCode = 200) and (FRESTResponse.ContentType = 'image/png') then
    begin

      tmpStream := TMemoryStream.Create;
      Graphic := TGraphicClass(TWICImage).Create;
      try
        try
          tmpStream.WriteBuffer(FRESTResponse.RawBytes[0], Length(FRESTResponse.RawBytes));
          tmpStream.Seek(0, soFromBeginning);
          Graphic.LoadFromStream(tmpStream);
          cxImage.Picture.Graphic := Graphic;
        except
        end;
      finally
        tmpStream.Free;
        Graphic.Free;
      end;
    end;

  finally
    FRESTResponse.Free;
    FRESTRequest.Free;
    FRESTClient.Free;
  end;
{$ELSE}

  IdHTTP.Request.Clear;
  IdHTTP.Request.CustomHeaders.Clear;
  IdHTTP.Request.ContentType := 'application/x-www-form-urlencoded';
  IdHTTP.Request.ContentEncoding := 'utf-8';
  IdHTTP.Request.CustomHeaders.FoldLines := False;

  sl := TStringList.Create;
  sl.Add('size=200x200');
  sl.Add('data=otpauth://totp/' + FProjectName + ':' + FUserName + '?secret=' + FGoogleSecret +
                    '&issuer=' + FProjectName);

  tmpStream := TMemoryStream.Create;
  Graphic := TGraphicClass(TWICImage).Create;
  try
    try
      IdHTTP.POST('https://api.qrserver.com/v1/create-qr-code/', sl, tmpStream);
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
{$ENDIF}
end;

end.
