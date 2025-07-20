inherited DialogGofroForm: TDialogGofroForm
  Caption = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1043#1086#1092#1088#1086
  ClientHeight = 681
  ClientWidth = 447
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 463
  ExplicitHeight = 720
  PixelsPerInch = 96
  TextHeight = 14
  inherited bbPanel: TPanel
    Top = 631
    Width = 447
    Height = 50
    ExplicitTop = 385
    ExplicitWidth = 357
    ExplicitHeight = 50
    inherited bbOk: TBitBtn
      Left = 11
      Width = 88
      Height = 28
      Default = False
      Font.Height = -13
      ParentFont = False
      ExplicitLeft = 11
      ExplicitWidth = 88
      ExplicitHeight = 28
    end
    inherited bbCancel: TBitBtn
      Left = 109
      Width = 88
      Height = 28
      Font.Height = -13
      Kind = bkCustom
      ParentFont = False
      ExplicitLeft = 109
      ExplicitWidth = 88
      ExplicitHeight = 28
    end
    object BitBtn1: TBitBtn
      Left = 211
      Top = 12
      Width = 136
      Height = 28
      Action = actExec
      Caption = #1058#1086#1074#1072#1088' '#1056#1072#1089#1093#1086#1076
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = []
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00444444444444
        4444444444444444444444444904444444444444999044444444444499904444
        4444444999990444444444999999044444444899049990444444890444499044
        4444444444499904444444444444990444444444444449904444444444444489
        0444444444444448904444444444444449904444444444444444}
      ParentFont = False
      TabOrder = 2
    end
  end
  object infoPanelSpace_2: TPanel
    Left = 0
    Top = 196
    Width = 447
    Height = 18
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 1
    ExplicitLeft = 8
    ExplicitTop = 208
  end
  object infoPanel_1: TPanel
    Left = 0
    Top = 156
    Width = 447
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 18
    ExplicitWidth = 452
    object infoPanelGoodsCode_1: TPanel
      Left = 0
      Top = 0
      Width = 95
      Height = 40
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object LabelGoodsCode_1: TLabel
        Left = 0
        Top = 0
        Width = 95
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1076' '#1043#1086#1092#1088#1086'-1'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 69
      end
      object EditGoodsCode_1: TcxCurrencyEdit
        Left = 4
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 85
      end
    end
    object infoPanelGoodsName_1: TPanel
      Left = 95
      Top = 0
      Width = 264
      Height = 40
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 100
      ExplicitTop = 6
      ExplicitWidth = 389
      ExplicitHeight = 55
      object LabelGoodsName_1: TLabel
        Left = 0
        Top = 0
        Width = 264
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1043#1086#1092#1088#1086' - 1'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitTop = -5
      end
      object EditGoodsName_1: TcxButtonEdit
        Left = 8
        Top = 15
        ParentFont = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Text = 'EditGoodsName_1'
        Width = 250
      end
    end
    object infoPanelAmount_1: TPanel
      Left = 359
      Top = 0
      Width = 88
      Height = 40
      Align = alRight
      BevelOuter = bvNone
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      ExplicitLeft = 364
      object LabelAmount_1: TLabel
        Left = 0
        Top = 0
        Width = 88
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1083'-'#1074#1086' - 1'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 55
      end
      object EditAmount_1: TcxCurrencyEdit
        Left = 5
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 79
      end
    end
  end
  object infoPanelSpace_1: TPanel
    Left = 0
    Top = 138
    Width = 447
    Height = 18
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 3
    ExplicitLeft = -16
    ExplicitTop = 162
  end
  object infoPanel_2: TPanel
    Left = 0
    Top = 214
    Width = 447
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    ExplicitTop = 76
    ExplicitWidth = 452
    object infoPanelGoodsCode_2: TPanel
      Left = 0
      Top = 0
      Width = 95
      Height = 40
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object LabelGoodsCode_2: TLabel
        Left = 0
        Top = 0
        Width = 95
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1076' '#1043#1086#1092#1088#1086'-2'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 69
      end
      object EditGoodsCode_2: TcxCurrencyEdit
        Left = 4
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 85
      end
    end
    object infoPanelGoodsName_2: TPanel
      Left = 95
      Top = 0
      Width = 264
      Height = 40
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 105
      ExplicitWidth = 254
      ExplicitHeight = 55
      object LabelGoodsName_2: TLabel
        Left = 0
        Top = 0
        Width = 264
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1043#1086#1092#1088#1086' - 2'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 51
      end
      object EditGoodsName_2: TcxButtonEdit
        Left = 8
        Top = 15
        ParentFont = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Text = 'EditGoodsName_2'
        Width = 250
      end
    end
    object infoPanelAmount_2: TPanel
      Left = 359
      Top = 0
      Width = 88
      Height = 40
      Align = alRight
      BevelOuter = bvNone
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      ExplicitLeft = 364
      object LabelAmount_2: TLabel
        Left = 0
        Top = 0
        Width = 88
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1083'-'#1074#1086' - 2'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 55
      end
      object EditAmount_2: TcxCurrencyEdit
        Left = 5
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 79
      end
    end
  end
  object infoPanelSpace_last: TPanel
    Left = 0
    Top = 602
    Width = 447
    Height = 18
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 5
    ExplicitTop = 266
  end
  object infoPanelSpace_8: TPanel
    Left = 0
    Top = 544
    Width = 447
    Height = 18
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 6
    ExplicitTop = 538
  end
  object infoPanelSpace_7: TPanel
    Left = 0
    Top = 486
    Width = 447
    Height = 18
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 7
    ExplicitLeft = 8
    ExplicitTop = 328
  end
  object infoPanelSpace_6: TPanel
    Left = 0
    Top = 428
    Width = 447
    Height = 18
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 8
    ExplicitTop = 433
  end
  object infoPanelSpace_5: TPanel
    Left = 0
    Top = 370
    Width = 447
    Height = 18
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 9
    ExplicitLeft = 8
    ExplicitTop = 379
  end
  object infoPanelSpace_4: TPanel
    Left = 0
    Top = 312
    Width = 447
    Height = 18
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 10
    ExplicitTop = 324
  end
  object infoPanelSpace_3: TPanel
    Left = 0
    Top = 254
    Width = 447
    Height = 18
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 11
    ExplicitTop = 252
  end
  object Panel1: TPanel
    Left = 0
    Top = 272
    Width = 447
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 12
    ExplicitTop = 26
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 95
      Height = 40
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 95
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1076' '#1043#1086#1092#1088#1086'-3'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 69
      end
      object EditGoodsCode_3: TcxCurrencyEdit
        Left = 4
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 85
      end
    end
    object Panel3: TPanel
      Left = 95
      Top = 0
      Width = 264
      Height = 40
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Label2: TLabel
        Left = 0
        Top = 0
        Width = 264
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1043#1086#1092#1088#1086' - 3'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 51
      end
      object EditGoodsName_3: TcxButtonEdit
        Left = 8
        Top = 15
        ParentFont = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Text = 'EditGoodsName_3'
        Width = 250
      end
    end
    object Panel4: TPanel
      Left = 359
      Top = 0
      Width = 88
      Height = 40
      Align = alRight
      BevelOuter = bvNone
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      object Label3: TLabel
        Left = 0
        Top = 0
        Width = 88
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1083'-'#1074#1086' - 3'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 55
      end
      object EditAmount_3: TcxCurrencyEdit
        Left = 5
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 79
      end
    end
  end
  object Panel5: TPanel
    Left = 0
    Top = 330
    Width = 447
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 13
    ExplicitTop = 142
    object Panel6: TPanel
      Left = 0
      Top = 0
      Width = 95
      Height = 40
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Label4: TLabel
        Left = 0
        Top = 0
        Width = 95
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1076' '#1043#1086#1092#1088#1086'-4'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 69
      end
      object EditGoodsCode_4: TcxCurrencyEdit
        Left = 4
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 85
      end
    end
    object Panel7: TPanel
      Left = 95
      Top = 0
      Width = 264
      Height = 40
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Label5: TLabel
        Left = 0
        Top = 0
        Width = 264
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1043#1086#1092#1088#1086' - 4'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 51
      end
      object EditGoodsName_4: TcxButtonEdit
        Left = 8
        Top = 15
        ParentFont = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Text = 'EditGoodsName_4'
        Width = 250
      end
    end
    object Panel8: TPanel
      Left = 359
      Top = 0
      Width = 88
      Height = 40
      Align = alRight
      BevelOuter = bvNone
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      object Label6: TLabel
        Left = 0
        Top = 0
        Width = 88
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1083'-'#1074#1086' - 4'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 55
      end
      object EditAmount_4: TcxCurrencyEdit
        Left = 5
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 79
      end
    end
  end
  object Panel9: TPanel
    Left = 0
    Top = 562
    Width = 447
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 14
    ExplicitTop = 200
    object Panel10: TPanel
      Left = 0
      Top = 0
      Width = 95
      Height = 40
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Label7: TLabel
        Left = 0
        Top = 0
        Width = 95
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1076' '#1043#1086#1092#1088#1086'-8'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 69
      end
      object EditGoodsCode_8: TcxCurrencyEdit
        Left = 4
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 85
      end
    end
    object Panel11: TPanel
      Left = 95
      Top = 0
      Width = 264
      Height = 40
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Label8: TLabel
        Left = 0
        Top = 0
        Width = 264
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1043#1086#1092#1088#1086' - 8'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitTop = 5
      end
      object EditGoodsName_8: TcxButtonEdit
        Left = 8
        Top = 15
        ParentFont = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Text = 'EditGoodsName_8'
        Width = 250
      end
    end
    object Panel12: TPanel
      Left = 359
      Top = 0
      Width = 88
      Height = 40
      Align = alRight
      BevelOuter = bvNone
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      object Label9: TLabel
        Left = 0
        Top = 0
        Width = 88
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1083'-'#1074#1086' - 8'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 55
      end
      object EditAmount_8: TcxCurrencyEdit
        Left = 5
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 79
      end
    end
  end
  object Panel13: TPanel
    Left = 0
    Top = 504
    Width = 447
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 15
    ExplicitTop = 200
    object Panel14: TPanel
      Left = 0
      Top = 0
      Width = 95
      Height = 40
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Label10: TLabel
        Left = 0
        Top = 0
        Width = 95
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1076' '#1043#1086#1092#1088#1086'-7'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 69
      end
      object EditGoodsCode_7: TcxCurrencyEdit
        Left = 4
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 85
      end
    end
    object Panel15: TPanel
      Left = 95
      Top = 0
      Width = 264
      Height = 40
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Label11: TLabel
        Left = 0
        Top = 0
        Width = 264
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1043#1086#1092#1088#1086' - 7'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 51
      end
      object EditGoodsName_7: TcxButtonEdit
        Left = 8
        Top = 15
        ParentFont = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Text = 'EditGoodsName_7'
        Width = 250
      end
    end
    object Panel16: TPanel
      Left = 359
      Top = 0
      Width = 88
      Height = 40
      Align = alRight
      BevelOuter = bvNone
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      object Label12: TLabel
        Left = 0
        Top = 0
        Width = 88
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1083'-'#1074#1086' - 7'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 55
      end
      object EditAmount_7: TcxCurrencyEdit
        Left = 5
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 79
      end
    end
  end
  object Panel17: TPanel
    Left = 0
    Top = 446
    Width = 447
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 16
    ExplicitTop = 200
    object Panel18: TPanel
      Left = 0
      Top = 0
      Width = 95
      Height = 40
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Label13: TLabel
        Left = 0
        Top = 0
        Width = 95
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1076' '#1043#1086#1092#1088#1086'-6'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 69
      end
      object EditGoodsCode_6: TcxCurrencyEdit
        Left = 4
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 85
      end
    end
    object Panel19: TPanel
      Left = 95
      Top = 0
      Width = 264
      Height = 40
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Label14: TLabel
        Left = 0
        Top = 0
        Width = 264
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1043#1086#1092#1088#1086' - 6'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 51
      end
      object EditGoodsName_6: TcxButtonEdit
        Left = 8
        Top = 15
        ParentFont = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Text = 'EditGoodsName_6'
        Width = 250
      end
    end
    object Panel20: TPanel
      Left = 359
      Top = 0
      Width = 88
      Height = 40
      Align = alRight
      BevelOuter = bvNone
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      object Label15: TLabel
        Left = 0
        Top = 0
        Width = 88
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1083'-'#1074#1086' - 6'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 55
      end
      object EditAmount_6: TcxCurrencyEdit
        Left = 5
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 79
      end
    end
  end
  object Panel21: TPanel
    Left = 0
    Top = 388
    Width = 447
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 17
    ExplicitTop = 200
    object Panel22: TPanel
      Left = 0
      Top = 0
      Width = 95
      Height = 40
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Label16: TLabel
        Left = 0
        Top = 0
        Width = 95
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1076' '#1043#1086#1092#1088#1086'-5'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 69
      end
      object EditGoodsCode_5: TcxCurrencyEdit
        Left = 4
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 85
      end
    end
    object Panel23: TPanel
      Left = 95
      Top = 0
      Width = 264
      Height = 40
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Label17: TLabel
        Left = 0
        Top = 0
        Width = 264
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1043#1086#1092#1088#1086' - 5'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 51
      end
      object EditGoodsName_5: TcxButtonEdit
        Left = 8
        Top = 15
        ParentFont = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Text = 'EditGoodsName_5'
        Width = 250
      end
    end
    object Panel24: TPanel
      Left = 359
      Top = 0
      Width = 88
      Height = 40
      Align = alRight
      BevelOuter = bvNone
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      object Label18: TLabel
        Left = 0
        Top = 0
        Width = 88
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1083'-'#1074#1086' - 5'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 55
      end
      object EditAmount_5: TcxCurrencyEdit
        Left = 5
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 79
      end
    end
  end
  object infoPanel_box: TPanel
    Left = 0
    Top = 58
    Width = 447
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 18
    object Panel26: TPanel
      Left = 0
      Top = 0
      Width = 95
      Height = 40
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Label19: TLabel
        Left = 0
        Top = 0
        Width = 95
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1076' '#1071#1097#1080#1082
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 53
      end
      object EditGoodsCode_box: TcxCurrencyEdit
        Left = 4
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 85
      end
    end
    object Panel27: TPanel
      Left = 95
      Top = 0
      Width = 264
      Height = 40
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Label20: TLabel
        Left = 0
        Top = 0
        Width = 264
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1071#1097#1080#1082
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitTop = -5
      end
      object EditGoodsName_box: TcxButtonEdit
        Left = 8
        Top = 15
        ParentFont = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Text = 'EditGoodsName_box'
        Width = 250
      end
    end
    object Panel28: TPanel
      Left = 359
      Top = 0
      Width = 88
      Height = 40
      Align = alRight
      BevelOuter = bvNone
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      object Label21: TLabel
        Left = 0
        Top = 0
        Width = 88
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1083'-'#1074#1086' '#1071#1097#1080#1082
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 71
      end
      object EditAmount_box: TcxCurrencyEdit
        Left = 5
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 79
      end
    end
  end
  object infoPanel_pd: TPanel
    Left = 0
    Top = 18
    Width = 447
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 19
    ExplicitTop = 1
    object Panel30: TPanel
      Left = 0
      Top = 0
      Width = 95
      Height = 40
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Label22: TLabel
        Left = 0
        Top = 0
        Width = 95
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1076' '#1055#1086#1076#1076#1086#1085
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 67
      end
      object EditGoodsCode_pd: TcxCurrencyEdit
        Left = 4
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        OnKeyDown = EditGoodsCode_pdKeyDown
        Width = 85
      end
    end
    object Panel31: TPanel
      Left = 95
      Top = 0
      Width = 264
      Height = 40
      Align = alClient
      BevelOuter = bvNone
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clGreen
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      object Label23: TLabel
        Left = 0
        Top = 0
        Width = 264
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1055#1086#1076#1076#1086#1085
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitTop = 6
      end
      object EditGoodsName_pd: TcxButtonEdit
        Left = 8
        Top = 15
        ParentFont = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Text = 'EditGoodsName_pd'
        Width = 250
      end
    end
    object Panel32: TPanel
      Left = 359
      Top = 0
      Width = 88
      Height = 40
      Align = alRight
      BevelOuter = bvNone
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      object Label24: TLabel
        Left = 0
        Top = 0
        Width = 88
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1083'-'#1074#1086' '#1055#1086#1076#1076#1086#1085
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 85
      end
      object EditAmount_pd: TcxCurrencyEdit
        Left = 5
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 79
      end
    end
  end
  object infoPanel_ugol: TPanel
    Left = 0
    Top = 98
    Width = 447
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 20
    object Panel34: TPanel
      Left = 0
      Top = 0
      Width = 95
      Height = 40
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Label25: TLabel
        Left = 0
        Top = 0
        Width = 95
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1076' '#1043#1086#1092#1088#1086'-'#1059'.'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 72
      end
      object EditGoodsCode_ugol: TcxCurrencyEdit
        Left = 4
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 85
      end
    end
    object Panel35: TPanel
      Left = 95
      Top = 0
      Width = 264
      Height = 40
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object Label26: TLabel
        Left = 0
        Top = 0
        Width = 264
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1043#1086#1092#1088#1086'-'#1059#1075#1086#1083#1086#1082
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitTop = -5
      end
      object EditGoodsName_ugol: TcxButtonEdit
        Left = 8
        Top = 15
        ParentFont = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Text = 'EditGoodsName_ugol'
        Width = 250
      end
    end
    object Panel36: TPanel
      Left = 359
      Top = 0
      Width = 88
      Height = 40
      Align = alRight
      BevelOuter = bvNone
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      object Label27: TLabel
        Left = 0
        Top = 0
        Width = 88
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1083'. '#1043#1086#1092#1088#1086'-'#1059'.'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clGreen
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 75
      end
      object EditAmount_ugol: TcxCurrencyEdit
        Left = 5
        Top = 15
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.DecimalPlaces = 0
        Properties.DisplayFormat = '0.'
        Properties.ReadOnly = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 79
      end
    end
  end
  object infoPanelSpace_poddon: TPanel
    Left = 0
    Top = 0
    Width = 447
    Height = 18
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 21
    ExplicitTop = 9
  end
  object ActionList: TActionList
    Left = 320
    Top = 128
    object actExec: TAction
      Category = 'ScaleLib'
      Caption = #1058#1086#1074#1072#1088
      Hint = 'actExec'
      OnExecute = actExecExecute
    end
  end
end
