object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1069#1082#1089#1087#1077#1076#1080#1094#1080#1103
  ClientHeight = 651
  ClientWidth = 984
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyPress = FormKeyPress
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GridPanel: TPanel
    Left = 130
    Top = 66
    Width = 854
    Height = 585
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object ButtonPanel: TPanel
      Left = 0
      Top = 0
      Width = 854
      Height = 33
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object bbDeleteItem: TSpeedButton
        Left = 241
        Top = 2
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
        OnClick = bbDeleteItemClick
      end
      object bbExit: TSpeedButton
        Left = 489
        Top = 2
        Width = 31
        Height = 29
        Action = actExit
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
      end
      object bbRefresh: TSpeedButton
        Left = 396
        Top = 2
        Width = 31
        Height = 29
        Action = actRefresh
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
      end
      object bbRefreshZakaz: TSpeedButton
        Left = 599
        Top = 2
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
      object bbChangeNumberTare: TSpeedButton
        Left = 148
        Top = 2
        Width = 31
        Height = 29
        Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#8470' '#1071#1097#1080#1082#1072'>'
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
        OnClick = bbChangeNumberTareClick
      end
      object bbChangeLevelNumber: TSpeedButton
        Left = 179
        Top = 2
        Width = 31
        Height = 29
        Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#8470' '#1064#1072#1088'>'
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
        OnClick = bbChangeLevelNumberClick
      end
      object bbExportToEDI: TSpeedButton
        Left = 658
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
        Visible = False
      end
      object bbChoice_UnComlete: TSpeedButton
        Left = 303
        Top = 2
        Width = 31
        Height = 29
        Hint = #1042#1077#1088#1085#1091#1090#1100#1089#1103' '#1082' '#1085#1077' '#1079#1072#1082#1088#1099#1090#1086#1084#1091' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1102
        Glyph.Data = {
          06020000424D0602000000000000760000002800000019000000190000000100
          0400000000009001000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888000000088888888888888888888888880000000888888888888
          8888888888888000000088888888888888888888888880000000888888888887
          7777788888888000000088888888800000377788888880000000888888880EEE
          E0307778888880000000888888880EEEE030777888888000000088888880EEEE
          0333077888888000000088888880EEEE03330778888880000000888888800000
          0333077888888000000088888888887033330778888880000000888888888000
          33330778888880000000888888880EE03333077888888000000088888880EEEE
          033307788888800000008888880EEEEEE0330778888880000000888880EEEEEE
          EE03077888888000000088888000EEEE0003077888888000000088888880EEEE
          03330788888880000000888888880EEEE0307888888880000000888888880EEE
          E030888888888000000088888888800000388888888880000000888888888888
          8888888888888000000088888888888888888888888880000000888888888888
          88888888888880000000}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbChoice_UnComleteClick
      end
      object bbView_all: TSpeedButton
        Left = 334
        Top = 2
        Width = 31
        Height = 29
        Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1042#1057#1045#1061'> '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1103
        Glyph.Data = {
          06020000424D0602000000000000760000002800000019000000190000000100
          0400000000009001000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          7777777777777000000077777777777777777777777770000000777777777777
          7777777777777000000077777777777777777777777770000000777777777778
          8888877777777000000077777777700000388877777770000000777777770BBB
          B0308887777770000000777777770BBBB030888777777000000077777770BBBB
          0333088777777000000077777770BBBB03330887777770000000777777700000
          0333088777777000000077777777778033330887777770000000777777777000
          33330887777770000000777777770BB03333088777777000000077777770BBBB
          033308877777700000007777770BBBBBB0330887777770000000777770BBBBBB
          BB03088777777000000077777000BBBB0003088777777000000077777770BBBB
          03330877777770000000777777770BBBB0308777777770000000777777770BBB
          B030777777777000000077777777700000377777777770000000777777777777
          7777777777777000000077777777777777777777777770000000777777777777
          77777777777770000000}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbView_allClick
      end
      object bbChangeCountPack: TSpeedButton
        Left = 86
        Top = 2
        Width = 31
        Height = 29
        Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1072#1082#1077#1090#1086#1074'>'
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888808800000000000888F0888888888888880F808888888888888FF0088888
          888888800B308888888888880BB308888888888880BB308888888888880BB308
          888888888880BB308888888888880BB308888888888880BB0088888888888800
          0508888888888880FD0888888888888800888888888888888888}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbChangeCountPackClick
      end
      object bbChangeHeadCount: TSpeedButton
        Left = 5
        Top = 2
        Width = 31
        Height = 29
        Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1075#1086#1083#1086#1074'>'
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888808800000000000888F0888888888888880F808888888888888FF0088888
          888888800B308888888888880BB308888888888880BB308888888888880BB308
          888888888880BB308888888888880BB308888888888880BB0088888888888800
          0508888888888880FD0888888888888800888888888888888888}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbChangeHeadCountClick
      end
      object bbChangeBoxCount: TSpeedButton
        Left = 117
        Top = 2
        Width = 31
        Height = 29
        Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1091#1087#1072#1082#1086#1074#1086#1095#1085#1086#1081' '#1090#1072#1088#1099'>'
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          888887088888888888888F808888888888888080888888888888880F08888888
          88888888F0888888888888888F0888888888888888F000888888888888899108
          88888888880B9990888888888880B91908888888888809919088888888888099
          1908888888888809908888888888888008888888888888888888}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbChangeBoxCountClick
      end
      object bbChangePartionGoods: TSpeedButton
        Left = 36
        Top = 2
        Width = 31
        Height = 29
        Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1055#1072#1088#1090#1080#1103' '#1057#1067#1056#1068#1071'>'
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888870888888888888873308888888888888733088888888888887330888888
          8888888733088888888888887330888888888888873308888088888888733088
          8008888888873308087088888888730700888888888880887888888888888088
          0888888888880800888888888888808888888888888888888888}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbChangePartionGoodsClick
      end
    end
    object infoPanelTotalSumm: TPanel
      Left = 0
      Top = 544
      Width = 854
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object gbRealWeight: TGroupBox
        Left = 249
        Top = 0
        Width = 119
        Height = 41
        Align = alLeft
        Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1085#1072' '#1058#1072#1073#1083#1086
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object PanelRealWeight: TPanel
          Left = 2
          Top = 16
          Width = 115
          Height = 23
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelRealWeight'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object gbWeightTare: TGroupBox
        Left = 368
        Top = 0
        Width = 108
        Height = 41
        Align = alLeft
        Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1090#1072#1088#1099
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object PanelWeightTare: TPanel
          Left = 2
          Top = 16
          Width = 104
          Height = 23
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelWeightTare'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
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
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        object PanelAmountPartnerWeight: TPanel
          Left = 2
          Top = 16
          Width = 126
          Height = 23
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelAmountPartnerWeight'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object gbTotalSumm: TGroupBox
        Left = 746
        Top = 0
        Width = 108
        Height = 41
        Align = alRight
        Caption = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072', '#1075#1088#1085
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        object PanelTotalSumm: TPanel
          Left = 2
          Top = 16
          Width = 104
          Height = 23
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelTotalSumm'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
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
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        object PanelAmountWeight: TPanel
          Left = 2
          Top = 16
          Width = 115
          Height = 23
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelAmountWeight'
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -12
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
    end
    object cxDBGrid: TcxGrid
      Left = 0
      Top = 33
      Width = 854
      Height = 511
      Align = alClient
      TabOrder = 2
      object cxDBGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = DS
        DataController.Summary.DefaultGroupSummaryItems = <
          item
            Format = ',0.####'
            Kind = skSum
            Column = AmountPartner
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = RealWeight
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = WeightTareTotal
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = CountTare
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = BoxCount
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Count
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = HeadCount
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = ',0.####'
            Kind = skSum
            Column = AmountPartner
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Amount
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = RealWeight
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = WeightTareTotal
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = CountTare
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = BoxCount
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = Count
          end
          item
            Format = ',0.####'
            Kind = skSum
            Column = HeadCount
          end>
        DataController.Summary.SummaryGroups = <>
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnMoving = False
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Inserting = False
        OptionsView.Footer = True
        OptionsView.GroupByBox = False
        OptionsView.GroupSummaryLayout = gslAlignWithColumns
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object GoodsCode: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'GoodsCode'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object GoodsName: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'GoodsName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 200
        end
        object GoodsKindName: TcxGridDBColumn
          Caption = #1042#1080#1076' '#1091#1087#1072#1082'.'
          DataBinding.FieldName = 'GoodsKindName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object MeasureName: TcxGridDBColumn
          Caption = #1045#1076'. '#1080#1079#1084'.'
          DataBinding.FieldName = 'MeasureName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 40
        end
        object PartionGoods: TcxGridDBColumn
          Caption = #1055#1072#1088#1090#1080#1103' '#1057#1067#1056#1068#1071
          DataBinding.FieldName = 'PartionGoods'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 90
        end
        object PriceListName: TcxGridDBColumn
          Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
          DataBinding.FieldName = 'PriceListName'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 75
        end
        object Price: TcxGridDBColumn
          Caption = #1062#1077#1085#1072
          DataBinding.FieldName = 'Price'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 50
        end
        object ChangePercentAmount: TcxGridDBColumn
          Caption = '% '#1057#1082#1076
          DataBinding.FieldName = 'ChangePercentAmount'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 35
        end
        object HeadCount: TcxGridDBColumn
          Caption = #1050#1086#1083'. '#1075#1086#1083#1086#1074
          DataBinding.FieldName = 'HeadCount'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object AmountPartner: TcxGridDBColumn
          Caption = #1050#1086#1083'. '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
          DataBinding.FieldName = 'AmountPartner'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object Amount: TcxGridDBColumn
          Caption = #1050#1086#1083'. '#1089#1082#1083#1072#1076
          DataBinding.FieldName = 'Amount'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object RealWeight: TcxGridDBColumn
          Caption = #1042#1077#1089' '#1085#1072' '#1058#1072#1073#1083#1086
          DataBinding.FieldName = 'RealWeight'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object Count: TcxGridDBColumn
          Caption = #1050#1086#1083'. '#1087#1072#1082#1077#1090#1086#1074
          DataBinding.FieldName = 'Count'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object WeightTareTotal: TcxGridDBColumn
          Caption = #1042#1077#1089' '#1090#1072#1088#1099
          DataBinding.FieldName = 'WeightTareTotal'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object WeightTare: TcxGridDBColumn
          Caption = #1042#1077#1089' 1 '#1090#1072#1088#1099
          DataBinding.FieldName = 'WeightTare'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 50
        end
        object CountTare: TcxGridDBColumn
          Caption = #1050#1086#1083'. '#1090#1072#1088#1099
          DataBinding.FieldName = 'CountTare'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 50
        end
        object LevelNumber: TcxGridDBColumn
          Caption = #8470' '#1096#1088'.'
          DataBinding.FieldName = 'LevelNumber'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 40
        end
        object BoxNumber: TcxGridDBColumn
          Caption = #8470' '#1103#1097'.'
          DataBinding.FieldName = 'BoxNumber'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 40
        end
        object BoxName: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1091#1087#1072#1082'.-'#1090#1072#1088#1099
          DataBinding.FieldName = 'BoxName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Action = actUpdateBox
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 80
        end
        object BoxCount: TcxGridDBColumn
          Caption = #1050#1086#1083'. '#1091#1087#1072#1082'.-'#1090'.'
          DataBinding.FieldName = 'BoxCount'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 58
        end
        object InsertDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072'('#1074#1088') '#1089#1086#1079#1076#1072#1085#1080#1103
          DataBinding.FieldName = 'InsertDate'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object UpdateDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072'('#1074#1088') '#1080#1079#1084'.'
          DataBinding.FieldName = 'UpdateDate'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object isErased: TcxGridDBColumn
          Caption = #1059#1076#1072#1083#1077#1085
          DataBinding.FieldName = 'isErased'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
      end
      object cxDBGridLevel: TcxGridLevel
        GridView = cxDBGridDBTableView
      end
    end
  end
  object PanelSaveItem: TPanel
    Left = 0
    Top = 66
    Width = 130
    Height = 585
    Align = alLeft
    BevelOuter = bvNone
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object BarCodePanel: TPanel
      Left = 0
      Top = 39
      Width = 130
      Height = 39
      Align = alTop
      TabOrder = 0
      object BarCodeLabel: TLabel
        Left = 1
        Top = 1
        Width = 128
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1064#1090#1088#1080#1093' '#1082#1086#1076
        ExplicitWidth = 59
      end
      object EditBarCode: TcxCurrencyEdit
        Left = 5
        Top = 15
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.AssignedValues.DisplayFormat = True
        Properties.DecimalPlaces = 0
        Properties.OnChange = EditBarCodePropertiesChange
        TabOrder = 0
        Width = 120
      end
    end
    object infoPanel_Scale: TPanel
      Left = 0
      Top = 238
      Width = 130
      Height = 29
      Align = alTop
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clTeal
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object ScaleLabel: TLabel
        Left = 1
        Top = 1
        Width = 128
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = 'Scale.Active = ???'
        ExplicitWidth = 91
      end
      object PanelWeight_Scale: TPanel
        Left = 1
        Top = 15
        Width = 128
        Height = 13
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Weight=???'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clTeal
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentColor = True
        ParentFont = False
        TabOrder = 0
        OnDblClick = PanelWeight_ScaleDblClick
      end
    end
    object rgScale: TRadioGroup
      Left = 0
      Top = 121
      Width = 130
      Height = 117
      Align = alTop
      Caption = #1042#1077#1089#1099
      TabOrder = 2
      OnClick = rgScaleClick
    end
    object PanelCountPack: TPanel
      Left = 0
      Top = 267
      Width = 130
      Height = 39
      Align = alTop
      TabOrder = 3
      object LabelCountPack: TLabel
        Left = 1
        Top = 1
        Width = 128
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1083'-'#1074#1086' '#1087#1072#1082#1077#1090#1086#1074
        ExplicitWidth = 87
      end
      object EditCountPack: TcxCurrencyEdit
        Left = 5
        Top = 15
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.AssignedValues.DisplayFormat = True
        Properties.DecimalPlaces = 4
        Properties.OnChange = EditBarCodePropertiesChange
        TabOrder = 0
        Width = 120
      end
    end
    object HeadCountPanel: TPanel
      Left = 0
      Top = 360
      Width = 130
      Height = 39
      Align = alTop
      TabOrder = 4
      object HeadCountLabel: TLabel
        Left = 1
        Top = 1
        Width = 128
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1083'-'#1074#1086' '#1075#1086#1083#1086#1074
        ExplicitWidth = 75
      end
      object EditHeadCount: TcxCurrencyEdit
        Left = 5
        Top = 15
        Properties.Alignment.Horz = taRightJustify
        Properties.Alignment.Vert = taVCenter
        Properties.AssignedValues.DisplayFormat = True
        Properties.DecimalPlaces = 4
        Properties.OnChange = EditBarCodePropertiesChange
        TabOrder = 0
        Width = 120
      end
    end
    object PanelPartionGoods: TPanel
      Left = 0
      Top = 78
      Width = 130
      Height = 43
      Align = alTop
      TabOrder = 5
      object LabelPartionGoods: TLabel
        Left = 1
        Top = 1
        Width = 128
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1042#1074#1086#1076' '#1055#1040#1056#1058#1048#1071' '#1057#1067#1056#1068#1071
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 119
      end
      object EditPartionGoods: TEdit
        Left = 5
        Top = 17
        Width = 120
        Height = 23
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlack
        Font.Height = -12
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
        Text = 'EditPartionGoods'
        OnExit = EditPartionGoodsExit
      end
    end
    object PanelBox: TPanel
      Left = 0
      Top = 306
      Width = 130
      Height = 54
      Align = alTop
      TabOrder = 6
      object Label1: TLabel
        Left = 1
        Top = 1
        Width = 128
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1059#1087#1072#1082#1086#1074#1086#1095#1085#1072#1103' '#1090#1072#1088#1072
        ExplicitWidth = 99
      end
      object Panel2: TPanel
        Left = 65
        Top = 15
        Width = 64
        Height = 38
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object Label2: TLabel
          Left = 0
          Top = 0
          Width = 64
          Height = 14
          Align = alTop
          Alignment = taCenter
          Caption = #1050#1086#1083'-'#1074#1086
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 36
        end
        object EditBoxCount: TcxCurrencyEdit
          Left = 5
          Top = 15
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 4
          Properties.OnChange = EditBarCodePropertiesChange
          TabOrder = 0
          Width = 55
        end
      end
      object Panel3: TPanel
        Left = 1
        Top = 15
        Width = 64
        Height = 38
        Align = alLeft
        BevelOuter = bvNone
        TabOrder = 1
        object Label3: TLabel
          Left = 0
          Top = 0
          Width = 64
          Height = 14
          Align = alTop
          Alignment = taCenter
          Caption = #1050#1086#1076
          Font.Charset = RUSSIAN_CHARSET
          Font.Color = clBlack
          Font.Height = -11
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
          ExplicitWidth = 19
        end
        object EditBoxCode: TcxCurrencyEdit
          Left = 2
          Top = 15
          Properties.Alignment.Horz = taRightJustify
          Properties.Alignment.Vert = taVCenter
          Properties.AssignedValues.DisplayFormat = True
          Properties.DecimalPlaces = 0
          Properties.OnChange = EditBarCodePropertiesChange
          TabOrder = 0
          Width = 55
        end
      end
    end
    object Panel25: TPanel
      Left = 0
      Top = 0
      Width = 130
      Height = 39
      Align = alTop
      BevelInner = bvRaised
      BevelOuter = bvNone
      TabOrder = 7
      object Label17: TLabel
        Left = 1
        Top = 1
        Width = 128
        Height = 14
        Align = alTop
        Caption = '   '#1057#1084#1077#1085#1072' '#1079#1072
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 59
      end
      object OperDateEdit: TcxDateEdit
        Left = 5
        Top = 14
        EditValue = 41640d
        ParentFont = False
        Properties.DateButtons = [btnToday]
        Properties.SaveTime = False
        Properties.ShowTime = False
        Style.Font.Charset = RUSSIAN_CHARSET
        Style.Font.Color = clBlack
        Style.Font.Height = -12
        Style.Font.Name = 'Arial'
        Style.Font.Style = [fsBold]
        Style.IsFontAssigned = True
        TabOrder = 0
        Width = 120
      end
    end
  end
  object PanelInfoItem: TPanel
    Left = 130
    Top = 66
    Width = 0
    Height = 585
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
      Top = 548
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
    Width = 984
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
      Left = 664
      Top = 0
      Width = 320
      Height = 28
      Align = alRight
      BevelOuter = bvNone
      Caption = 'PanelMovement'
      TabOrder = 0
    end
    object PanelMovementDesc: TPanel
      Left = 0
      Top = 0
      Width = 664
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
      Width = 984
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
        Left = 130
        Top = 0
        Width = 362
        Height = 38
        Align = alClient
        BevelInner = bvRaised
        BevelOuter = bvNone
        TabOrder = 0
        object LabelPartner: TLabel
          Left = 1
          Top = 1
          Width = 360
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
          Width = 360
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
        Width = 130
        Height = 38
        Align = alLeft
        BevelInner = bvRaised
        BevelOuter = bvNone
        TabOrder = 1
        object PriceListNameLabel: TLabel
          Left = 1
          Top = 1
          Width = 128
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
          Width = 128
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
        Left = 664
        Top = 0
        Width = 320
        Height = 38
        Align = alRight
        BevelInner = bvRaised
        BevelOuter = bvNone
        TabOrder = 2
        object LabelOrderExternal: TLabel
          Left = 1
          Top = 1
          Width = 318
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitWidth = 66
        end
        object PanelOrderExternal: TPanel
          Left = 1
          Top = 14
          Width = 318
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
        Left = 492
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
  object DS: TDataSource
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
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxDBGridDBTableView
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 408
    Top = 392
  end
  object ActionList: TActionList
    Left = 592
    Top = 240
    object actRefresh: TAction
      Category = 'ScaleLib'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      OnExecute = actRefreshExecute
    end
    object actExit: TAction
      Category = 'ScaleLib'
      Hint = #1042#1099#1093#1086#1076
      OnExecute = actExitExecute
    end
    object actChoiceBox: TOpenChoiceForm
      Category = 'ScaleLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceBox'
      Hint = 'actChoiceBox'
      FormName = 'TBoxForm'
      FormNameParam.Value = 'TBoxForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
        end
        item
          Name = 'TextValue'
          Value = Null
          DataType = ftString
        end>
      isShowModal = True
    end
    object actUpdateBox: TAction
      Category = 'ScaleLib'
      Caption = 'actUpdateBox'
      Hint = 'actUpdateBox'
      OnExecute = actUpdateBoxExecute
    end
  end
end
