object GuideGoodsForm: TGuideGoodsForm
  Left = 578
  Top = 242
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1088#1086#1076#1091#1082#1094#1080#1080
  ClientHeight = 563
  ClientWidth = 825
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object GridPanel: TPanel
    Left = 0
    Top = 224
    Width = 825
    Height = 294
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 711
    ExplicitHeight = 258
    object DBGrid1: TDBGrid
      Left = 0
      Top = 33
      Width = 825
      Height = 261
      Align = alClient
      DataSource = DataSource
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      OnCellClick = DBGrid1CellClick
      Columns = <
        item
          Expanded = False
          FieldName = 'GoodsCode'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'GoodsName'
          Width = 250
          Visible = True
        end>
    end
    object ButtonPanel: TPanel
      Left = 0
      Top = 0
      Width = 825
      Height = 33
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitWidth = 711
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
      object ButtonSaveAllItem: TSpeedButton
        Left = 67
        Top = 3
        Width = 31
        Height = 29
        Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100
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
        OnClick = ButtonSaveAllItemClick
      end
    end
  end
  object ParamsPanel: TPanel
    Left = 0
    Top = 0
    Width = 825
    Height = 224
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 711
    object TarePanel: TPanel
      Left = 244
      Top = 0
      Width = 182
      Height = 224
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 2
      object rgTare: TRadioGroup
        Left = 0
        Top = 70
        Width = 182
        Height = 62
        Align = alClient
        Caption = #1058#1072#1088#1072
        Color = clBtnFace
        Columns = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 2
        OnClick = rgTareClick
      end
      object PanelTare: TPanel
        Left = 0
        Top = 0
        Width = 182
        Height = 35
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object gbTareCount: TGroupBox
          Left = 0
          Top = 0
          Width = 107
          Height = 35
          Align = alClient
          Caption = #1050#1086#1083'-'#1074#1086' '#1090#1072#1088#1099
          TabOrder = 0
          object EditTareCount: TEdit
            Left = 5
            Top = 12
            Width = 85
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Text = 'EditTareCount'
            OnEnter = EditTareCountEnter
            OnExit = EditTareCountExit
            OnKeyPress = EditTareCountKeyPress
          end
        end
        object gbTareCode: TGroupBox
          Left = 107
          Top = 0
          Width = 75
          Height = 35
          Align = alRight
          Caption = #1050#1086#1076
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clMaroon
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object EditTareCode: TEdit
            Left = 5
            Top = 12
            Width = 60
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clMaroon
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Text = 'EditTareCode'
            OnChange = EditTareCodeChange
            OnEnter = EditTareCountEnter
            OnExit = EditTareCodeExit
            OnKeyPress = EditTareCodeKeyPress
          end
        end
      end
      object DiscountPanel: TPanel
        Left = 0
        Top = 132
        Width = 182
        Height = 92
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 3
        object rgDiscount: TRadioGroup
          Left = 0
          Top = 35
          Width = 182
          Height = 57
          Align = alClient
          Caption = #1057#1082#1080#1076#1082#1072' '#1087#1086' '#1074#1077#1089#1091
          Color = clBtnFace
          Columns = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 8404992
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 1
          OnClick = rgDiscountClick
        end
        object gbDiscountCode: TGroupBox
          Left = 0
          Top = 0
          Width = 182
          Height = 35
          Align = alTop
          Caption = #1050#1086#1076
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 8404992
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object EditDiscountCode: TEdit
            Left = 5
            Top = 12
            Width = 85
            Height = 21
            Font.Charset = DEFAULT_CHARSET
            Font.Color = 8404992
            Font.Height = -11
            Font.Name = 'MS Sans Serif'
            Font.Style = []
            ParentFont = False
            TabOrder = 0
            Text = 'EditDiscountCode'
            OnChange = EditDiscountCodeChange
            OnEnter = EditTareCountEnter
            OnExit = EditDiscountCodeExit
            OnKeyPress = EditDiscountCodeKeyPress
          end
        end
      end
      object gbTareWeightEnter: TGroupBox
        Left = 0
        Top = 35
        Width = 182
        Height = 35
        Align = alTop
        Caption = #1042#1077#1089' '#1090#1072#1088#1099
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 8404992
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object EditTareWeightEnter: TEdit
          Left = 5
          Top = 12
          Width = 85
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 8404992
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = 'EditTareWeightEnter'
          OnEnter = EditTareCountEnter
          OnExit = EditTareWeightEnterExit
        end
      end
    end
    object PriceListPanel: TPanel
      Left = 426
      Top = 0
      Width = 277
      Height = 224
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 3
      object rgPriceList: TRadioGroup
        Left = 0
        Top = 35
        Width = 277
        Height = 189
        Caption = #1055#1088#1072#1081#1089'-'#1051#1080#1089#1090
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615808
        Font.Height = -8
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        OnClick = rgPriceListClick
      end
      object gbPriceListCode: TGroupBox
        Left = 0
        Top = 0
        Width = 277
        Height = 35
        Align = alTop
        Caption = #1050#1086#1076
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 12615808
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object EditPriceListCode: TEdit
          Left = 5
          Top = 12
          Width = 140
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 12615808
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = 'EditPriceListCode'
          OnChange = EditPriceListCodeChange
          OnEnter = EditTareCountEnter
          OnExit = EditPriceListCodeExit
          OnKeyPress = EditPriceListCodeKeyPress
        end
      end
    end
    object GoodsPanel: TPanel
      Left = 0
      Top = 0
      Width = 134
      Height = 224
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object gbGoodsName: TGroupBox
        Left = 0
        Top = 35
        Width = 134
        Height = 35
        Align = alTop
        Caption = #1055#1088#1086#1076#1091#1082#1094#1080#1103
        TabOrder = 1
        object EditGoodsName: TEdit
          Left = 5
          Top = 12
          Width = 125
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = 'EditGoodsName'
          OnChange = EditGoodsNameChange
          OnEnter = EditGoodsNameEnter
          OnExit = EditGoodsNameExit
          OnKeyDown = EditGoodsNameKeyDown
          OnKeyPress = EditGoodsCodeKeyPress
        end
      end
      object gbGoodsCode: TGroupBox
        Left = 0
        Top = 0
        Width = 134
        Height = 35
        Align = alTop
        Caption = #1050#1086#1076
        TabOrder = 0
        object EditGoodsCode: TEdit
          Left = 5
          Top = 12
          Width = 125
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = 'EditGoodsCode'
          OnChange = EditGoodsCodeChange
          OnEnter = EditGoodsCodeEnter
          OnExit = EditGoodsCodeExit
          OnKeyDown = EditGoodsCodeKeyDown
          OnKeyPress = EditGoodsCodeKeyPress
        end
      end
      object gbGoodsWieghtValue: TGroupBox
        Left = 0
        Top = 70
        Width = 134
        Height = 41
        Align = alTop
        Caption = #1042#1077#1089' '#1085#1072' '#1058#1072#1073#1083#1086
        TabOrder = 2
        object PanelGoodsWieghtValue: TPanel
          Left = 2
          Top = 15
          Width = 130
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelGoodsWieghtValue'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object gbZakazDiffCount: TGroupBox
        Left = 0
        Top = 111
        Width = 134
        Height = 41
        Align = alTop
        Caption = #1054#1089#1090#1072#1083#1086#1089#1100
        TabOrder = 3
        Visible = False
        object PanelZakazDiffCount: TPanel
          Left = 2
          Top = 15
          Width = 130
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelZakazDiffCount'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlue
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object gblZakazTotalCount: TGroupBox
        Left = 0
        Top = 152
        Width = 134
        Height = 41
        Align = alTop
        Caption = #1048#1090#1086#1075#1086' '#1079#1072#1103#1074#1082#1072
        TabOrder = 4
        Visible = False
        object PanelZakazTotalCount: TPanel
          Left = 2
          Top = 15
          Width = 130
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelZakazTotalCount'
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
    object KindPackagePanel: TPanel
      Left = 134
      Top = 0
      Width = 110
      Height = 224
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object rgKindPackage: TRadioGroup
        Left = 0
        Top = 35
        Width = 110
        Height = 189
        Align = alClient
        Caption = #1042#1080#1076' '#1091#1087#1072#1082#1086#1074#1082#1080
        Color = clBtnFace
        Columns = 2
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 8404992
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentColor = False
        ParentFont = False
        TabOrder = 1
        OnClick = rgKindPackageClick
      end
      object gbKindPackageCode: TGroupBox
        Left = 0
        Top = 0
        Width = 110
        Height = 35
        Align = alTop
        Caption = #1050#1086#1076' '#1074#1080#1076#1072' '#1091#1087#1072#1082#1086#1074#1082#1080
        Font.Charset = DEFAULT_CHARSET
        Font.Color = 8404992
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object EditKindPackageCode: TEdit
          Left = 5
          Top = 12
          Width = 90
          Height = 21
          Font.Charset = DEFAULT_CHARSET
          Font.Color = 8404992
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          Text = 'EditKindPackageCode'
          OnChange = EditKindPackageCodeChange
          OnEnter = EditTareCountEnter
          OnExit = EditKindPackageCodeExit
          OnKeyPress = EditKindPackageCodeKeyPress
        end
      end
    end
  end
  object SummPanel: TPanel
    Left = 0
    Top = 518
    Width = 825
    Height = 45
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    ExplicitTop = 482
    ExplicitWidth = 711
  end
  object DataSource: TDataSource
    DataSet = CDS
    OnDataChange = DataSourceDataChange
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
    Left = 272
    Top = 384
  end
end
