inherited DialogOrderExternalForm: TDialogOrderExternalForm
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100
  ClientHeight = 233
  ClientWidth = 460
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 476
  ExplicitHeight = 272
  PixelsPerInch = 96
  TextHeight = 14
  inherited bbPanel: TPanel
    Top = 192
    Width = 460
    ExplicitTop = 192
    ExplicitWidth = 460
    inherited bbOk: TBitBtn
      Left = 51
      Top = 9
      Default = False
      ExplicitLeft = 51
      ExplicitTop = 9
    end
    inherited bbCancel: TBitBtn
      Left = 135
      Top = 9
      ExplicitLeft = 135
      ExplicitTop = 9
    end
  end
  object PanelValue: TPanel
    Left = 0
    Top = 0
    Width = 460
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object gbBarCode: TGroupBox
      Left = 0
      Top = 0
      Width = 130
      Height = 48
      Align = alLeft
      Caption = #1064#1090#1088#1080#1093' '#1082#1086#1076' / '#8470' '#1076#1086#1082'.'
      TabOrder = 0
      object EditBarCode: TEdit
        Left = 4
        Top = 20
        Width = 120
        Height = 22
        ParentShowHint = False
        ShowHint = False
        TabOrder = 0
        Text = 'EditBarCode'
        OnKeyDown = EditBarCodeKeyDown
      end
    end
    object gbOrderExternal: TGroupBox
      Left = 130
      Top = 0
      Width = 330
      Height = 48
      Align = alClient
      Caption = #1047#1072#1082#1072#1079' '#1086#1090' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103
      TabOrder = 1
      object PanelOrderExternal: TPanel
        Left = 2
        Top = 16
        Width = 326
        Height = 30
        Align = alClient
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'PanelOrderExternal'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
    end
  end
  object gbGoodsProperty: TGroupBox
    Left = 0
    Top = 144
    Width = 460
    Height = 48
    Align = alClient
    Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088
    TabOrder = 2
    object PanelGoodsProperty: TPanel
      Left = 2
      Top = 16
      Width = 456
      Height = 30
      Align = alClient
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = 'PanelGoodsProperty'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
  end
  object gbRetail: TGroupBox
    Left = 0
    Top = 96
    Width = 460
    Height = 48
    Align = alTop
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
    TabOrder = 3
    object PanelRetail: TPanel
      Left = 2
      Top = 16
      Width = 456
      Height = 30
      Align = alClient
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = 'PanelRetail'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
  end
  object gbPartner: TGroupBox
    Left = 0
    Top = 48
    Width = 460
    Height = 48
    Align = alTop
    Caption = #1054#1090' '#1082#1086#1075#1086
    TabOrder = 4
    object PanelPartner: TPanel
      Left = 2
      Top = 16
      Width = 456
      Height = 30
      Align = alClient
      Alignment = taLeftJustify
      BevelOuter = bvNone
      Caption = 'PanelPartner'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
  end
end
