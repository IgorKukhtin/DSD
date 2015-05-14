object GuidePartnerForm: TGuidePartnerForm
  Left = 578
  Top = 242
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099'>'
  ClientHeight = 572
  ClientWidth = 1054
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object GridPanel: TPanel
    Left = 0
    Top = 41
    Width = 1054
    Height = 486
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = 256
    ExplicitWidth = 867
    ExplicitHeight = 271
    object DBGrid: TDBGrid
      Left = 0
      Top = 33
      Width = 1054
      Height = 453
      Align = alClient
      DataSource = DataSource
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgCancelOnExit]
      ParentFont = False
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDblClick = DBGridDblClick
      Columns = <
        item
          Expanded = False
          FieldName = 'PartnerCode'
          Title.Alignment = taCenter
          Title.Caption = #1050#1086#1076
          Width = 70
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PartnerName'
          Title.Alignment = taCenter
          Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          Width = 400
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PaidKindName'
          Title.Alignment = taCenter
          Title.Caption = #1060#1086#1088#1084'.'#1086#1087#1083'.'
          Title.Color = 55
          Width = 55
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ContractCode'
          Title.Alignment = taCenter
          Title.Caption = #1050#1086#1076' '#1076#1086#1075'.'
          Width = 55
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ContractNumber'
          Title.Alignment = taCenter
          Title.Caption = #8470' '#1076#1086#1075'.'
          Width = 55
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ContractTagName'
          Title.Alignment = taCenter
          Title.Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
          Width = 70
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ChangePercent'
          Title.Alignment = taCenter
          Title.Caption = '% '#1089#1082'.'
          Width = 40
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ChangePercentAmount'
          Title.Alignment = taCenter
          Title.Caption = '% '#1089#1082'. '#1074#1077#1089
          Width = 55
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'InfoMoneyCode'
          Title.Alignment = taCenter
          Title.Caption = #1050#1086#1076' '#1059#1055
          Width = 55
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'InfoMoneyName'
          Title.Alignment = taCenter
          Title.Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
          Width = 150
          Visible = True
        end>
    end
    object ButtonPanel: TPanel
      Left = 0
      Top = 0
      Width = 1054
      Height = 33
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitWidth = 867
      object ButtonExit: TSpeedButton
        Left = 511
        Top = 3
        Width = 31
        Height = 29
        Hint = #1042#1099#1093#1086#1076
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888808077708888888880807770880800008080777088888880008077
          7088888880088078708800808000807770888888000000777088888888008007
          7088888880008077708888888800800770888888888880000088888888888888
          8888888888884444888888888888488488888888888844448888}
        ParentShowHint = False
        ShowHint = True
        OnClick = ButtonExitClick
      end
      object ButtonRefresh: TSpeedButton
        Left = 306
        Top = 3
        Width = 31
        Height = 29
        Hint = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777000000
          00007777770FFFFFFFF000700000FF0F00F0E00BFBFB0FFFFFF0E0BFBF000FFF
          F0F0E0FBFBFBF0F00FF0E0BFBF00000B0FF0E0FBFBFBFBF0FFF0E0BF0000000F
          FFF0000BFB00B0FF00F07770000B0FFFFFF0777770B0FFFF000077770B0FF00F
          0FF07770B00FFFFF0F077709070FFFFF00777770770000000777}
        ParentShowHint = False
        ShowHint = True
        OnClick = ButtonRefreshClick
      end
      object ButtonChoiceItem: TSpeedButton
        Left = 67
        Top = 3
        Width = 31
        Height = 29
        Hint = #1042#1099#1073#1088#1072#1090#1100
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          888888888888888888888888888888888888873333333333338887BB3B33B3B3
          B38887B3B3B13B3B3388873B3B9913B3B38887B3B399973B3388873B397B9973
          B38887B397BBB997338887FFFFFFFF91BB8888FBBBBB88891888888FFFF88888
          9188888888888888898888888888888888988888888888888888}
        ParentShowHint = False
        ShowHint = True
        OnClick = ButtonChoiceItemClick
      end
    end
  end
  object ParamsPanel: TPanel
    Left = 0
    Top = 0
    Width = 1054
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 867
    object gbPartnerCode: TGroupBox
      Left = 0
      Top = 0
      Width = 137
      Height = 41
      Align = alLeft
      Caption = #1050#1086#1076
      TabOrder = 0
      ExplicitHeight = 256
      object EditPartnerCode: TEdit
        Left = 5
        Top = 17
        Width = 125
        Height = 22
        TabOrder = 0
        Text = 'EditPartnerCode'
        OnChange = EditPartnerCodeChange
        OnEnter = EditPartnerCodeEnter
        OnKeyDown = EditPartnerCodeKeyDown
        OnKeyPress = EditPartnerCodeKeyPress
      end
    end
    object gbPartnerName: TGroupBox
      Left = 137
      Top = 0
      Width = 917
      Height = 41
      Align = alClient
      Caption = #1053#1072#1079#1074#1072#1085#1080#1077
      TabOrder = 1
      ExplicitLeft = 0
      ExplicitWidth = 41
      ExplicitHeight = 867
      object EditPartnerName: TEdit
        Left = 5
        Top = 17
        Width = 332
        Height = 22
        TabOrder = 0
        Text = 'EditPartnerName'
        OnChange = EditPartnerNameChange
        OnEnter = EditPartnerNameEnter
        OnKeyDown = EditPartnerNameKeyDown
        OnKeyPress = EditPartnerNameKeyPress
      end
    end
  end
  object SummPanel: TPanel
    Left = 0
    Top = 527
    Width = 1054
    Height = 45
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    ExplicitWidth = 867
  end
  object DataSource: TDataSource
    DataSet = CDS
    Left = 320
    Top = 336
  end
  object spSelect: TdsdStoredProc
    DataSet = CDS
    DataSets = <
      item
        DataSet = CDS
      end>
    Params = <>
    PackSize = 1
    Left = 264
    Top = 296
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    OnFilterRecord = CDSFilterRecord
    Left = 272
    Top = 384
  end
end
