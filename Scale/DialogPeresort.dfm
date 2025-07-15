inherited DialogPeresortForm: TDialogPeresortForm
  Caption = #1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077
  ClientHeight = 435
  ClientWidth = 357
  OldCreateOrder = True
  Position = poScreenCenter
  ExplicitWidth = 373
  ExplicitHeight = 474
  PixelsPerInch = 96
  TextHeight = 14
  inherited bbPanel: TPanel
    Top = 385
    Width = 357
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
      Caption = #1058#1086#1074#1072#1088
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
  object infoPanelGoodsName_in: TPanel
    Left = 0
    Top = 55
    Width = 357
    Height = 55
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object LabelGoodsName_in: TLabel
      Left = 0
      Top = 0
      Width = 357
      Height = 14
      Align = alTop
      Caption = '      '#1053#1072#1079#1074#1072#1085#1080#1077' '#1055#1088#1080#1093#1086#1076
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clPurple
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 115
    end
    object EditGoodsName_in: TcxButtonEdit
      Left = 5
      Top = 18
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
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
      Text = 'EditGoodsName_in'
      Width = 340
    end
  end
  object infoPanelGoods_in2: TPanel
    Left = 0
    Top = 0
    Width = 357
    Height = 55
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object infoPanelGoodsCode_in: TPanel
      Left = 0
      Top = 0
      Width = 105
      Height = 55
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object LabelGoodsCode_in: TLabel
        Left = 0
        Top = 0
        Width = 105
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1076' '#1055#1088#1080#1093#1086#1076
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 66
      end
      object PanelGoodsCode_in: TPanel
        Left = 0
        Top = 14
        Width = 105
        Height = 41
        Align = alClient
        BevelOuter = bvNone
        Caption = 'PanelGoodsCode_in'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
    end
    object infoPanelGoodsKindName_in: TPanel
      Left = 105
      Top = 0
      Width = 252
      Height = 55
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object LabelGoodsKindName_in: TLabel
        Left = 0
        Top = 0
        Width = 252
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1055#1088#1080#1093#1086#1076
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 107
      end
      object PanelGoodsKindName_in: TPanel
        Left = 0
        Top = 14
        Width = 252
        Height = 41
        Align = alClient
        BevelOuter = bvNone
        Caption = 'PanelGoodsKindName_in'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
    end
  end
  object PanelTare4: TPanel
    Left = 0
    Top = 110
    Width = 357
    Height = 55
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object infoPanelAmount_in: TPanel
      Left = 0
      Top = 0
      Width = 166
      Height = 55
      Align = alClient
      BevelOuter = bvNone
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object LabelAmount_in: TLabel
        Left = 0
        Top = 0
        Width = 166
        Height = 14
        Align = alTop
        Caption = '      '#1050#1086#1083'-'#1074#1086' '#1055#1088#1080#1093#1086#1076
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 102
      end
      object EditAmount_in: TcxCurrencyEdit
        Left = 5
        Top = 20
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.AssignedValues.DisplayFormat = True
        Properties.DecimalPlaces = 0
        Properties.ReadOnly = True
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 115
      end
    end
    object infoPanelPartionDate_in: TPanel
      Left = 166
      Top = 0
      Width = 191
      Height = 55
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object LabelPartionDate_in: TLabel
        Left = 0
        Top = 0
        Width = 191
        Height = 14
        Align = alTop
        Caption = '      '#1055#1072#1088#1090#1080#1103' '#1055#1088#1080#1093#1086#1076
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clPurple
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 102
      end
      object EditPartionDate_in: TcxDateEdit
        Left = 12
        Top = 20
        EditValue = 41640d
        ParentFont = False
        Properties.DateButtons = [btnToday]
        Properties.ReadOnly = False
        Properties.SaveTime = False
        Properties.ShowTime = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 102
      end
    end
  end
  object infoPanel: TPanel
    Left = 0
    Top = 165
    Width = 357
    Height = 51
    Align = alTop
    BevelInner = bvLowered
    TabOrder = 4
  end
  object Panel1: TPanel
    Left = 0
    Top = 216
    Width = 357
    Height = 55
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
    object infoPanelGoodsCode_out: TPanel
      Left = 0
      Top = 0
      Width = 105
      Height = 55
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 105
        Height = 14
        Align = alTop
        Caption = '      '#1050#1086#1076' '#1056#1072#1089#1093#1086#1076
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 81
      end
      object PanelGoodsCode_out: TPanel
        Left = 0
        Top = 14
        Width = 105
        Height = 41
        Align = alClient
        BevelOuter = bvNone
        Caption = 'PanelGoodsCode_out'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
    end
    object infoPanelGoodsKindName_out: TPanel
      Left = 105
      Top = 0
      Width = 252
      Height = 55
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 1
      object LabelGoodsKindName_out: TLabel
        Left = 0
        Top = 0
        Width = 252
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1056#1072#1089#1093#1086#1076
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 104
      end
      object PanelGoodsKindName_out: TPanel
        Left = 0
        Top = 14
        Width = 252
        Height = 41
        Align = alClient
        BevelOuter = bvNone
        Caption = 'PanelGoodsKindName_out'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -13
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
    end
  end
  object infoPanelGoodsName_out: TPanel
    Left = 0
    Top = 271
    Width = 357
    Height = 55
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 6
    object LabelGoodsName_out: TLabel
      Left = 0
      Top = 0
      Width = 357
      Height = 14
      Align = alTop
      Caption = '      '#1053#1072#1079#1074#1072#1085#1080#1077' '#1056#1072#1089#1093#1086#1076
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 112
    end
    object EditGoodsName_out: TcxButtonEdit
      Left = 5
      Top = 20
      ParentFont = False
      Properties.Buttons = <
        item
          Action = actExec
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Style.Font.Charset = RUSSIAN_CHARSET
      Style.Font.Color = clNavy
      Style.Font.Height = -13
      Style.Font.Name = 'Arial'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      TabOrder = 0
      Text = 'EditGoodsName_out'
      Width = 340
    end
  end
  object Panel8: TPanel
    Left = 0
    Top = 326
    Width = 357
    Height = 55
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 7
    object Panel9: TPanel
      Left = 0
      Top = 0
      Width = 166
      Height = 55
      Align = alClient
      BevelOuter = bvNone
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object LabelAmount_out: TLabel
        Left = 0
        Top = 0
        Width = 166
        Height = 14
        Align = alTop
        Caption = '      '#1050#1086#1083'-'#1074#1086' '#1056#1072#1089#1093#1086#1076
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 99
      end
      object EditAmount_out: TcxCurrencyEdit
        Left = 5
        Top = 20
        ParentFont = False
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.AssignedValues.DisplayFormat = True
        Properties.DecimalPlaces = 0
        Properties.ReadOnly = True
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 115
      end
    end
    object infoPanelPartionDate_out: TPanel
      Left = 166
      Top = 0
      Width = 191
      Height = 55
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object LabelPartionDate_out: TLabel
        Left = 0
        Top = 0
        Width = 191
        Height = 14
        Align = alTop
        Caption = '      '#1055#1072#1088#1090#1080#1103' '#1056#1072#1089#1093#1086#1076
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 99
      end
      object EditPartionDate_out: TcxDateEdit
        Left = 12
        Top = 20
        EditValue = 41640d
        ParentFont = False
        Properties.DateButtons = [btnToday]
        Properties.ReadOnly = False
        Properties.SaveTime = False
        Properties.ShowTime = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clNavy
        Style.Font.Height = -13
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 102
      end
    end
  end
  object ActionList: TActionList
    Left = 64
    Top = 168
    object actExec: TAction
      Category = 'ScaleLib'
      Caption = #1058#1086#1074#1072#1088
      Hint = 'actExec'
      OnExecute = actExecExecute
    end
  end
end
