object PartnerMapForm: TPartnerMapForm
  Left = 0
  Top = 0
  Caption = #1056#1072#1089#1087#1086#1083#1086#1078#1077#1085#1080#1077' <'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072'>'
  ClientHeight = 487
  ClientWidth = 759
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.isSingle = False
  PixelsPerInch = 96
  TextHeight = 13
  object wbPartner: TdsdWebBrowser
    Left = 0
    Top = 0
    Width = 759
    Height = 487
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 264
    ExplicitTop = 144
    ExplicitWidth = 300
    ExplicitHeight = 150
    ControlData = {
      4C000000724E0000553200000000000000000000000000000000000000000000
      000000004C000000000000000000000001000000E0D057007335CF11AE690800
      2B2E126208000000000000004C0000000114020000000000C000000000000046
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000000100000000000000000000000000000000000000}
  end
  object gmPartnerMarker: TGMMarker
    Language = Russian
    Map = gmPartnerMap
    VisualObjects = <>
    Left = 112
    Top = 8
  end
  object gmPartnerMap: TdsdGMMap
    Language = Russian
    Active = True
    WebBrowser = wbPartner
    Left = 24
    Top = 8
  end
  object gmPartnerGeoCode: TGMGeoCode
    Language = Russian
    Map = gmPartnerMap
    Marker = gmPartnerMarker
    LangCode = lcRUSSIAN
    Left = 200
    Top = 8
  end
end
