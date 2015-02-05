object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1069#1082#1089#1087#1077#1076#1080#1094#1080#1103
  ClientHeight = 700
  ClientWidth = 953
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GridPanel: TPanel
    Left = 133
    Top = 66
    Width = 820
    Height = 634
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object DBGrid: TDBGrid
      Left = 0
      Top = 33
      Width = 820
      Height = 560
      Align = alClient
      DataSource = DataSource
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDrawColumnCell = DBGridDrawColumnCell
      Columns = <
        item
          Expanded = False
          FieldName = 'GoodsCode'
          Title.Caption = #1050#1086#1076
          Width = 55
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'GoodsName'
          Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          Width = 250
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'GoodsKindName'
          Title.Caption = #1042#1080#1076' '#1091#1087#1072#1082'.'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MeasureName'
          Title.Caption = #1045#1076'.'#1080#1079#1084'.'
          Width = 40
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PartionString'
          Title.Caption = #1055#1072#1088#1090#1080#1103' '#1057#1067#1056#1068#1071
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'PartionDate'
          Title.Caption = #1055#1072#1088#1090#1080#1103' '#1044#1040#1058#1040
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'PriceListName'
          Title.Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
          Width = 70
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Price'
          Title.Caption = #1062#1077#1085#1072
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'ChangePercentAmount'
          Title.Caption = '%'#1057#1082#1076
          Width = 35
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'AmountPartner'
          Title.Caption = #1050#1086#1083'.'#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
          Width = 70
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Amount'
          Title.Caption = #1050#1086#1083'.'#1089#1082#1083#1072#1076
          Width = 55
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'RealWeight'
          Title.Caption = #1042#1077#1089' '#1085#1072' '#1058#1072#1073#1083#1086
          Width = 70
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'WeightTareTotal'
          Title.Caption = #1042#1077#1089' '#1090#1072#1088#1099
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'WeightTare'
          Title.Caption = #1042#1077#1089' 1 '#1090#1072#1088#1099
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'CountTare'
          Title.Caption = #1050#1086#1083'.'#1090#1072#1088#1099
          Width = 44
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'LevelNumber'
          Title.Caption = #8470' '#1096'.'
          Width = 30
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'BoxNumber'
          Title.Caption = #8470' '#1103#1097'.'
          Width = 35
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'BoxName'
          Title.Caption = #1053#1072#1079#1074'.'#1075#1086#1092#1088#1086
          Width = 70
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'BoxCount'
          Title.Caption = #1050#1086#1083'.'#1075#1086#1092#1088#1086
          Width = 45
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'InsertDate'
          Title.Caption = #1044#1072#1090#1072'('#1074#1088') '#1089#1086#1079#1076#1072#1085#1080#1103
          Width = 80
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'UpdateDate'
          Title.Caption = #1044#1072#1090#1072'('#1074#1088') '#1080#1079#1084'.'
          Width = 80
          Visible = True
        end>
    end
    object ButtonPanel: TPanel
      Left = 0
      Top = 0
      Width = 820
      Height = 33
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object ButtonDeleteItem: TSpeedButton
        Left = 148
        Top = 3
        Width = 31
        Height = 29
        Hint = #1091#1076#1072#1083#1080#1090#1100'/'#1074#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
        Glyph.Data = {
          C6040000424DC60400000000000036040000280000000C0000000C0000000100
          0800000000009000000000000000000000000001000000000000000000004000
          000080000000FF000000002000004020000080200000FF200000004000004040
          000080400000FF400000006000004060000080600000FF600000008000004080
          000080800000FF80000000A0000040A0000080A00000FFA0000000C0000040C0
          000080C00000FFC0000000FF000040FF000080FF0000FFFF0000000020004000
          200080002000FF002000002020004020200080202000FF202000004020004040
          200080402000FF402000006020004060200080602000FF602000008020004080
          200080802000FF80200000A0200040A0200080A02000FFA0200000C0200040C0
          200080C02000FFC0200000FF200040FF200080FF2000FFFF2000000040004000
          400080004000FF004000002040004020400080204000FF204000004040004040
          400080404000FF404000006040004060400080604000FF604000008040004080
          400080804000FF80400000A0400040A0400080A04000FFA0400000C0400040C0
          400080C04000FFC0400000FF400040FF400080FF4000FFFF4000000060004000
          600080006000FF006000002060004020600080206000FF206000004060004040
          600080406000FF406000006060004060600080606000FF606000008060004080
          600080806000FF80600000A0600040A0600080A06000FFA0600000C0600040C0
          600080C06000FFC0600000FF600040FF600080FF6000FFFF6000000080004000
          800080008000FF008000002080004020800080208000FF208000004080004040
          800080408000FF408000006080004060800080608000FF608000008080004080
          800080808000FF80800000A0800040A0800080A08000FFA0800000C0800040C0
          800080C08000FFC0800000FF800040FF800080FF8000FFFF80000000A0004000
          A0008000A000FF00A0000020A0004020A0008020A000FF20A0000040A0004040
          A0008040A000FF40A0000060A0004060A0008060A000FF60A0000080A0004080
          A0008080A000FF80A00000A0A00040A0A00080A0A000FFA0A00000C0A00040C0
          A00080C0A000FFC0A00000FFA00040FFA00080FFA000FFFFA0000000C0004000
          C0008000C000FF00C0000020C0004020C0008020C000FF20C0000040C0004040
          C0008040C000FF40C0000060C0004060C0008060C000FF60C0000080C0004080
          C0008080C000FF80C00000A0C00040A0C00080A0C000FFA0C00000C0C00040C0
          C00080C0C000FFC0C00000FFC00040FFC00080FFC000FFFFC0000000FF004000
          FF008000FF00FF00FF000020FF004020FF008020FF00FF20FF000040FF004040
          FF008040FF00FF40FF000060FF004060FF008060FF00FF60FF000080FF004080
          FF008080FF00FF80FF0000A0FF0040A0FF0080A0FF00FFA0FF0000C0FF0040C0
          FF0080C0FF00FFC0FF0000FFFF0040FFFF0080FFFF00FFFFFF00FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF00
          00000000000000000000FF00E0E0E0E0E0E0E0E0E000FF00E0E0E0E0E0E0E0E0
          E000FF00E0E0E0E0E0E0E0E0E000FF0000000000000000000000FFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
          FFFFFFFFFFFFFFFFFFFF}
        ParentShowHint = False
        ShowHint = True
        OnClick = ButtonDeleteItemClick
      end
      object ButtonExit: TSpeedButton
        Left = 489
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
        Left = 370
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
      object ButtonRefreshZakaz: TSpeedButton
        Left = 599
        Top = 6
        Width = 31
        Height = 29
        Hint = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100' '#1079#1072#1103#1074#1082#1091
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888888888873333333333333387BBBBBBBBBBBBB387BBBBBBBBBBB
          BB387BBBBBBBBBBBBB387BBBBBBBBBBBBB387BBBBBBBBBBBBB387BBBBBBBBBBB
          BB387BBBBBBBBBBBBB387BBBBBBBBBBBBB387BBBBBBBBBBBBBB888BBBBBB0888
          8888888777778888888888888888888888888888888888888888}
        ParentShowHint = False
        ShowHint = True
        Visible = False
      end
      object ButtonChangeNumberTare: TSpeedButton
        Left = 50
        Top = 3
        Width = 31
        Height = 29
        Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1053#1086#1084#1077#1088' '#1071#1097#1080#1082#1072'>'
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          888880888808080808088800088888888888880F708888888888880FF7088888
          88888880FF708888888888880FF708888888888880FF708088888888880FF000
          0888888888800B0080888888888800F708088888888880FF708888888888880F
          F708888888888880FF0888888888888800808888888888888808}
        ParentShowHint = False
        ShowHint = True
        Visible = False
      end
      object ButtonChangeNumberLevel: TSpeedButton
        Left = 82
        Top = 3
        Width = 31
        Height = 29
        Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1053#1086#1084#1077#1088' '#1057#1083#1086#1103'>'
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888889999999999998889088888889998888111088899888888889990889998
          888888199908888998888881999088889888888819990888888888888B099088
          8888888888BB990888888888888BB990888888888888B0990888888888888B99
          9088888888888819990888888888888199888888888888881888}
        ParentShowHint = False
        ShowHint = True
        Visible = False
      end
      object ButtonChangeMember: TSpeedButton
        Left = 114
        Top = 3
        Width = 31
        Height = 29
        Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072'> '#1087#1086' '#8470' '#1085#1072#1082#1083#1072#1076#1085#1086#1081
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          88888888488884088888848C88884870888884C888848C4708888C448848CCC4
          70888888888CCCCC470888888888CCCCC488888108888CCCCC888818708888CC
          C88881891708888C888818999170888888888999991708811188889999918888
          9188888999998889818888889998889888888888898888888888}
        ParentShowHint = False
        ShowHint = True
        Visible = False
      end
      object ButtonExportToEDI: TSpeedButton
        Left = 271
        Top = 2
        Width = 31
        Height = 29
        Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1085#1072#1082#1083#1072#1076#1085#1091#1102' EDI'
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
      end
    end
    object infoPanelTotalSumm: TPanel
      Left = 0
      Top = 593
      Width = 820
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object gbRealWeight: TGroupBox
        Left = 249
        Top = 0
        Width = 119
        Height = 41
        Align = alLeft
        Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1085#1072' '#1058#1072#1073#1083#1086
        TabOrder = 0
        object PanelRealWeight: TPanel
          Left = 2
          Top = 15
          Width = 115
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelRealWeight'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object gbPanelWeightTare: TGroupBox
        Left = 368
        Top = 0
        Width = 108
        Height = 41
        Align = alLeft
        Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1090#1072#1088#1099
        TabOrder = 1
        object PanelWeightTare: TPanel
          Left = 2
          Top = 15
          Width = 104
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelWeightTare'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object gbAmountPartnerWeight: TGroupBox
        Left = 0
        Top = 0
        Width = 130
        Height = 41
        Align = alLeft
        Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
        TabOrder = 2
        object PanelAmountPartnerWeight: TPanel
          Left = 2
          Top = 15
          Width = 126
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelAmountPartnerWeight'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object gbTotalSumm: TGroupBox
        Left = 712
        Top = 0
        Width = 108
        Height = 41
        Align = alRight
        Caption = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072', '#1075#1088#1085
        TabOrder = 3
        object PanelTotalSumm: TPanel
          Left = 2
          Top = 15
          Width = 104
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelTotalSumm'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object gbAmountWeight: TGroupBox
        Left = 130
        Top = 0
        Width = 119
        Height = 41
        Align = alLeft
        Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1057#1082#1083#1072#1076
        TabOrder = 4
        object PanelAmountWeight: TPanel
          Left = 2
          Top = 15
          Width = 115
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelAmountWeight'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
  end
  object PanelSaveItem: TPanel
    Left = 0
    Top = 66
    Width = 133
    Height = 634
    Align = alLeft
    BevelOuter = bvNone
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object EnterGoodsCodeScanerPanel: TPanel
      Left = 0
      Top = 42
      Width = 133
      Height = 41
      Align = alTop
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      object EnterGoodsCodeScanerLabel: TLabel
        Left = 1
        Top = 1
        Width = 131
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1076' '#1089#1086' '#1089#1082#1072#1085#1077#1088#1072
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 85
      end
      object EnterGoodsCodeScanerEdit: TEdit
        Left = 5
        Top = 14
        Width = 110
        Height = 24
        TabOrder = 0
        Text = 'EnterGoodsCodeScanerEdit'
        OnChange = EnterGoodsCodeScanerEditChange
      end
    end
    object gbOperDate: TGroupBox
      Left = 0
      Top = 0
      Width = 133
      Height = 42
      Align = alTop
      Caption = #1057#1084#1077#1085#1072' '#1079#1072
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      object OperDateEdit: TcxDateEdit
        Left = 5
        Top = 16
        EditValue = 41640d
        ParentFont = False
        Properties.DateButtons = [btnToday]
        Properties.SaveTime = False
        Properties.ShowTime = False
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clBlue
        Style.Font.Height = -13
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 110
      end
    end
    object infoPanel_Scale: TPanel
      Left = 0
      Top = 200
      Width = 133
      Height = 29
      Align = alTop
      TabOrder = 2
      object ScaleLabel: TLabel
        Left = 1
        Top = 1
        Width = 131
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = 'Scale.Active = ???'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 90
      end
      object PanelWeight_Scale: TPanel
        Left = 1
        Top = 14
        Width = 131
        Height = 14
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Weight=???'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        OnDblClick = PanelWeight_ScaleDblClick
      end
    end
    object rgScale: TRadioGroup
      Left = 0
      Top = 83
      Width = 133
      Height = 117
      Align = alTop
      Caption = #1042#1077#1089#1099
      Color = clBtnFace
      ParentColor = False
      TabOrder = 3
      OnClick = rgScaleClick
    end
  end
  object PanelInfoItem: TPanel
    Left = 133
    Top = 66
    Width = 0
    Height = 634
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 2
    Visible = False
    object PanelProduction_Goods: TPanel
      Left = 0
      Top = 15
      Width = 0
      Height = 136
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel2'
      TabOrder = 0
      object LabelProduction_Goods: TLabel
        Left = 0
        Top = 0
        Width = 0
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1043#1086#1090#1086#1074#1072#1103' '#1087#1088#1086#1076#1091#1082#1094#1080#1103
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 115
      end
      object GBProduction_GoodsCode: TGroupBox
        Left = 0
        Top = 13
        Width = 0
        Height = 41
        Align = alTop
        Caption = #1050#1086#1076
        TabOrder = 0
        object PanelProduction_GoodsCode: TPanel
          Left = 2
          Top = 15
          Width = 0
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelProduction_GoodsCode'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
          object EditProduction_GoodsCode: TEdit
            Left = 2
            Top = 1
            Width = 195
            Height = 21
            TabOrder = 0
            Text = 'EditProduction_GoodsCode'
          end
        end
      end
      object GBProduction_Goods_Weight: TGroupBox
        Left = 0
        Top = 95
        Width = 0
        Height = 41
        Align = alBottom
        Caption = #1042#1077#1089
        TabOrder = 1
        object PanelProduction_Goods_Weight: TPanel
          Left = 2
          Top = 15
          Width = 0
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelProduction_Goods_Weight'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object GBProduction_GoodsName: TGroupBox
        Left = 0
        Top = 54
        Width = 0
        Height = 41
        Align = alClient
        Caption = #1053#1072#1084#1077#1085#1086#1074#1072#1085#1080#1077
        TabOrder = 2
        object PanelProduction_GoodsName: TPanel
          Left = 2
          Top = 15
          Width = 0
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelProduction_GoodsName'
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
    object PanelTare_Goods: TPanel
      Left = 0
      Top = 166
      Width = 0
      Height = 173
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object LabelTare_Goods: TLabel
        Left = 0
        Top = 0
        Width = 0
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1058#1072#1088#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 30
      end
      object GBTare_GoodsCode: TGroupBox
        Left = 0
        Top = 13
        Width = 0
        Height = 41
        Align = alTop
        Caption = #1050#1086#1076
        TabOrder = 0
        object PanelTare_GoodsCode: TPanel
          Left = 2
          Top = 15
          Width = 0
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelTare_GoodsCode'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object GBTare_Goods_Weight: TGroupBox
        Left = 0
        Top = 132
        Width = 0
        Height = 41
        Align = alBottom
        Caption = #1042#1077#1089
        TabOrder = 1
        object PanelTare_Goods_Weight: TPanel
          Left = 2
          Top = 15
          Width = 0
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelTare_Goods_Weight'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object GBTare_GoodsName: TGroupBox
        Left = 0
        Top = 54
        Width = 0
        Height = 37
        Align = alClient
        Caption = #1053#1072#1084#1077#1085#1086#1074#1072#1085#1080#1077
        TabOrder = 2
        object PanelTare_GoodsName: TPanel
          Left = 2
          Top = 15
          Width = 0
          Height = 20
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelTare_GoodsName'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object gbTare_Goods_Count: TGroupBox
        Left = 0
        Top = 91
        Width = 0
        Height = 41
        Align = alBottom
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        TabOrder = 3
        object PanelTare_Goods_Count: TPanel
          Left = 2
          Top = 15
          Width = 0
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelTare_Goods_Count'
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
    object PanelSpace1: TPanel
      Left = 0
      Top = 0
      Width = 0
      Height = 15
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
    end
    object PanelSpace2: TPanel
      Left = 0
      Top = 151
      Width = 0
      Height = 15
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 3
    end
    object infoPanelTotalWeight: TPanel
      Left = 0
      Top = 597
      Width = 0
      Height = 37
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 4
      object GBTotalWeight: TGroupBox
        Left = 0
        Top = 0
        Width = 122
        Height = 37
        Align = alClient
        Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        object PanelTotalWeight: TPanel
          Left = 2
          Top = 15
          Width = 118
          Height = 20
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelTotalWeight'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object GBDiscountWeight: TGroupBox
        Left = -81
        Top = 0
        Width = 81
        Height = 37
        Align = alRight
        Caption = #1057#1082#1076' ('#1074#1077#1089')'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clMaroon
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 1
        object PanelDiscountWeight: TPanel
          Left = 2
          Top = 15
          Width = 77
          Height = 20
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelDiscountWeight'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
  end
  object infoPanel_mastre: TPanel
    Left = 0
    Top = 0
    Width = 953
    Height = 66
    Align = alTop
    BevelOuter = bvNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object PanelMovement: TPanel
      Left = 669
      Top = 0
      Width = 284
      Height = 28
      Align = alRight
      BevelOuter = bvNone
      Caption = 'PanelMovement'
      TabOrder = 0
    end
    object PanelMovementDesc: TPanel
      Left = 0
      Top = 0
      Width = 669
      Height = 28
      Align = alClient
      BevelOuter = bvNone
      Caption = 'PanelMovementDesc'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object infoPanel: TPanel
      Left = 0
      Top = 28
      Width = 953
      Height = 38
      Align = alBottom
      BevelOuter = bvNone
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      object infoPanelPartner: TPanel
        Left = 133
        Top = 0
        Width = 364
        Height = 38
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvNone
        TabOrder = 0
        object LabelPartner: TLabel
          Left = 1
          Top = 1
          Width = 362
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitWidth = 69
        end
        object PanelPartner: TPanel
          Left = 1
          Top = 14
          Width = 362
          Height = 23
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
      object infoPanelPriceList: TPanel
        Left = 0
        Top = 0
        Width = 133
        Height = 38
        Align = alLeft
        BevelInner = bvRaised
        BevelOuter = bvNone
        TabOrder = 1
        object PriceListNameLabel: TLabel
          Left = 1
          Top = 1
          Width = 131
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = #1055#1088#1072#1081#1089'-'#1051#1080#1089#1090
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitWidth = 71
        end
        object PanelPriceList: TPanel
          Left = 1
          Top = 14
          Width = 131
          Height = 23
          Align = alClient
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = 'PanelPriceList'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clPurple
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
      end
      object infoPanelOrderExternal: TPanel
        Left = 669
        Top = 0
        Width = 284
        Height = 38
        Align = alRight
        BevelInner = bvRaised
        BevelOuter = bvNone
        TabOrder = 2
        object LabelOrderExternal: TLabel
          Left = 1
          Top = 1
          Width = 282
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = #1047#1072#1103#1074#1082#1072
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitWidth = 44
        end
        object PanelOrderExternal: TPanel
          Left = 1
          Top = 14
          Width = 282
          Height = 23
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
      object infoPanelContract: TPanel
        Left = 497
        Top = 0
        Width = 172
        Height = 38
        Align = alRight
        BevelInner = bvRaised
        BevelOuter = bvNone
        TabOrder = 3
        object LabelContract: TLabel
          Left = 1
          Top = 1
          Width = 170
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = #1044#1086#1075#1086#1074#1086#1088
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitWidth = 52
        end
        object PanelContract: TPanel
          Left = 1
          Top = 14
          Width = 170
          Height = 23
          Align = alClient
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = 'PanelContract'
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
  end
  object PopupMenu: TPopupMenu
    Left = 256
    Top = 184
    object miPrintZakazMinus: TMenuItem
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1047#1072#1103#1074#1082#1072'/'#1055#1088#1086#1076#1072#1078#1072' ('#1089' '#1084#1080#1085#1091#1089#1086#1084')'
    end
    object miPrintZakazAll: TMenuItem
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1047#1072#1103#1074#1082#1072'/'#1055#1088#1086#1076#1072#1078#1072' ('#1042#1057#1045')'
    end
    object miLine11: TMenuItem
      Caption = '-'
    end
    object miPrintBill_byInvNumber: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '
    end
    object miPrintBill_andNaliog_byInvNumber: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' + '#1053#1072#1083#1086#1075#1086#1074#1086#1081
    end
    object miPrintBillTotal_byClient: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1080#1090#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102
    end
    object miPrintBillTotal_byFozzi: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1080#1090#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' '#1087#1086' '#1060#1086#1079#1079#1080
    end
    object miLine12: TMenuItem
      Caption = '-'
    end
    object miPrintSchet_byInvNumber: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090#1072
    end
    object miPrintBillTransport_byInvNumber: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1085#1086#1081' '#1085#1072#1083#1072#1076#1085#1086#1081
    end
    object miPrintBillTransportNew_byInvNumber: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1085#1086#1081' '#1085#1072#1083#1072#1076#1085#1086#1081' ('#1053#1054#1042#1040#1071')'
    end
    object miPrintBillKachestvo_byInvNumber: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1075#1086' '#1059#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1103
    end
    object miPrintBillNumberTare_byInvNumber: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1089' '#1053#1086#1084#1077#1088#1086#1084' '#1071#1097#1080#1082#1072
    end
    object miPrintBillNotice_byInvNumber: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1091#1074#1077#1076#1086#1084#1083#1077#1085#1080#1103
    end
    object miLine13: TMenuItem
      Caption = '-'
    end
    object miPrintSaleAll: TMenuItem
      Caption = #1054#1090#1095#1077#1090' '#1055#1088#1086#1076#1072#1078#1072'/'#1042#1086#1079#1074#1088#1072#1090' ('#1042#1057#1045')'
    end
    object miPrint_Report_byTare: TMenuItem
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1072#1088#1077
    end
    object miPrint_Report_byMemberProduction: TMenuItem
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082#1072#1084
    end
    object miLine14: TMenuItem
      Caption = '-'
    end
    object miScaleIni_DB: TMenuItem
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' - '#1052#1072#1083#1099#1077' '#1042#1077#1089#1099' (DB)'
    end
    object miScaleIni_BI: TMenuItem
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' - '#1041#1086#1083#1100#1096#1080#1077' '#1042#1077#1089#1099' (BI)'
    end
    object miScaleIni_Zeus: TMenuItem
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' - '#1047#1045#1059#1057' '#1042#1077#1089#1099'  (Zeus)'
    end
    object miScaleIni_BI_R: TMenuItem
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' - '#1056#1077#1083#1100#1089#1086#1074#1099#1077' '#1042#1077#1089#1099' (BI)'
    end
    object miLine15: TMenuItem
      Caption = '-'
    end
    object miScaleRun_DB: TMenuItem
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1052#1072#1083#1099#1077' '#1042#1077#1089#1099' (DB)'
    end
    object miScaleRun_BI: TMenuItem
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1041#1086#1083#1100#1096#1080#1077' '#1042#1077#1089#1099' (BI)'
    end
    object miScaleRun_Zeus: TMenuItem
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1047#1045#1059#1057' '#1042#1077#1089#1099'  (Zeus)'
    end
    object miScaleRun_BI_R: TMenuItem
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1056#1077#1083#1100#1089#1086#1074#1099#1077' '#1042#1077#1089#1099' (BI)'
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Goods'
    DataSet = CDS
    DataSets = <
      item
        DataSet = CDS
      end>
    Params = <>
    PackSize = 1
    Left = 224
    Top = 384
  end
  object DataSource: TDataSource
    DataSet = CDS
    Left = 320
    Top = 400
  end
  object CDS: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterOpen = CDSAfterOpen
    Left = 304
    Top = 448
  end
end
