object GoogleOTPRegistrationForm: TGoogleOTPRegistrationForm
  Left = 0
  Top = 0
  Caption = #1056#1077#1075#1080#1089#1090#1088#1072#1094#1080#1103' '#1083#1086#1075#1080#1085#1072
  ClientHeight = 273
  ClientWidth = 308
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 221
    Width = 308
    Height = 52
    Align = alBottom
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    ExplicitTop = 248
    ExplicitWidth = 362
    object cxButton1: TcxButton
      Left = 40
      Top = 16
      Width = 89
      Height = 25
      Caption = #1055#1088#1086#1076#1086#1083#1078#1080#1090#1100
      Default = True
      ModalResult = 1
      TabOrder = 0
    end
    object cxButton2: TcxButton
      Left = 168
      Top = 16
      Width = 89
      Height = 25
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
  end
  object cxImage: TcxImage
    Left = 0
    Top = 0
    Align = alClient
    TabOrder = 1
    Transparent = True
    ExplicitLeft = 48
    ExplicitTop = 96
    Height = 221
    Width = 308
  end
  object IdHTTP: TIdHTTP
    IOHandler = IdSSLIOHandlerSocketOpenSSL
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 248
    Top = 16
  end
  object IdSSLIOHandlerSocketOpenSSL: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Method = sslvSSLv23
    SSLOptions.SSLVersions = [sslvSSLv2, sslvSSLv3, sslvTLSv1]
    SSLOptions.Mode = sslmClient
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 248
    Top = 72
  end
end
