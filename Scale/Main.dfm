object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = #1069#1082#1089#1087#1077#1076#1080#1094#1080#1103
  ClientHeight = 700
  ClientWidth = 900
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
  PixelsPerInch = 96
  TextHeight = 13
  object GridPanel: TPanel
    Left = 133
    Top = 66
    Width = 767
    Height = 634
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object DBGrid: TDBGrid
      Left = 0
      Top = 33
      Width = 767
      Height = 523
      Align = alClient
      DataSource = DataSource1
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'Production_Code'
          Width = 26
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Production_Name'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'KindPackageName'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PartionStr_MB'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'OperCount_sh'
          Title.Caption = #1050#1086#1083' '#1075#1086#1083#1086#1074
          Width = 53
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'OperCount_Upakovka'
          Title.Caption = #1050#1086#1083' '#1087#1072#1082
          Width = 43
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Production_Weight_Discount'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DiscountWeight'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Tare_Count'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PriceListName'
          Width = 71
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Tare_Weight'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NumberTare'
          Title.Caption = #1053#1086#1084'.'#1103#1097'.'
          Width = 44
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'NumberLevel'
          Title.Caption = #1053#1086#1084'.'#1096'.'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'PartionDate'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Tare_Code'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Tare_Name'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'BillKindName'
          Title.Caption = #1053#1072#1079#1074'.'#1086#1087#1077#1088#1072#1094#1080#1080
          Width = 150
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'InsertDate'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'UpdateDate'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Id'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'LastPrice'
          Visible = True
        end>
    end
    object ButtonPanel: TPanel
      Left = 0
      Top = 0
      Width = 767
      Height = 33
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object ButtonSaveAllItem: TSpeedButton
        Left = 16
        Top = 3
        Width = 15
        Height = 29
        Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
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
      object ButtonDeleteItem: TSpeedButton
        Left = 148
        Top = 3
        Width = 31
        Height = 29
        Hint = #1059#1076#1072#1083#1080#1090#1100
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
      object ButtonCancelItem: TSpeedButton
        Left = 31
        Top = 3
        Width = 15
        Height = 29
        Hint = #1054#1090#1084#1077#1085#1072' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
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
        Visible = False
      end
      object ButtonRefresh: TSpeedButton
        Left = 444
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
      end
      object ButtonRefreshZakaz: TSpeedButton
        Left = 411
        Top = 3
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
      end
      object ButtonNewGetParams: TSpeedButton
        Left = 2
        Top = 3
        Width = 15
        Height = 29
        Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1076#1083#1103' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1103
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          77777777477774077777747C77774780777774C77774794807777C4477479994
          8077777777799999480777777777999994777771077779999977771780777799
          9777717C18077779777717CCC180777777777CCCCC180771117777CCCCC17777
          9177777CCCCC777971777777CCC77797777777777C7777777777}
        ParentShowHint = False
        ShowHint = True
        Visible = False
        OnClick = ButtonNewGetParamsClick
      end
      object ButtonPrintBill_detail_byInvNumber: TSpeedButton
        Left = 541
        Top = 3
        Width = 12
        Height = 29
        Hint = #1055#1077#1095#1072#1090#1100' '#1085#1072#1082#1083#1072#1076#1085#1086#1081
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
      object ButtonChangePartionDate: TSpeedButton
        Left = 184
        Top = 3
        Width = 31
        Height = 29
        Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1072#1090#1091' '#1087#1072#1088#1090#1080#1080'> '#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00880000000000
          000000000000000000000FFFFFFFFFFFFF000FF1111FFF1FFF000FF1FFFFFF1F
          FF000FFF1FFFFF1FFF000FFFF1FFFF1FFF000FF1FF1FF11FFF000FFF11FFFF1F
          FF000FFFFFFFFFFFFF0000000000000000000EEEEEEEEEEEEE000E0EEEEEEEEE
          0E00000000000000000880888088880888088800088888800088}
        ParentShowHint = False
        ShowHint = True
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
      end
      object ButtonExportToMail: TSpeedButton
        Left = 268
        Top = 3
        Width = 31
        Height = 29
        Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1085#1072#1082#1083#1072#1076#1085#1091#1102' DBF '#1058#1072#1074#1088#1080#1103
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
      end
      object ButtonExportToEDI: TSpeedButton
        Left = 326
        Top = 4
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
        OnClick = ButtonExportToEDIClick
      end
      object ButtonChangePartionStr: TSpeedButton
        Left = 221
        Top = 4
        Width = 31
        Height = 29
        Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1055#1072#1088#1090#1080#1102' '#1057#1099#1088#1100#1103'>'
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888888888888888888888888888888888888888888888888888800
          88888888888880BB0888888888800BBB0B0880303333BBBB08B807777773BBBB
          08B8BBBBBBBBBBBB08B888888880BBBB0B088888888880BBB888888888888800
          8888888888888888888888888888888888888888888888888888}
        ParentShowHint = False
        ShowHint = True
      end
    end
    object infoPanelTotalSumm: TPanel
      Left = 0
      Top = 593
      Width = 767
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 2
      object GBTotalSummGoods_Weight: TGroupBox
        Left = 130
        Top = 0
        Width = 98
        Height = 41
        Align = alLeft
        Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1087#1088#1086#1076'.'
        TabOrder = 0
        object PanelTotalSummGoods_Weight: TPanel
          Left = 2
          Top = 15
          Width = 94
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelTotalSummGoods_Weight'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object TotalSummTare_Weight: TGroupBox
        Left = 228
        Top = 0
        Width = 108
        Height = 41
        Align = alLeft
        Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1090#1072#1088#1099
        TabOrder = 1
        object PanelTotalSummTare_Weight: TPanel
          Left = 2
          Top = 15
          Width = 104
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelTotalSummTare_Weight'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
      end
      object GBTotalSummGoods_Weight_Discount: TGroupBox
        Left = 0
        Top = 0
        Width = 130
        Height = 41
        Align = alLeft
        Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
        TabOrder = 2
        object PanelTotalSummGoods_Weight_Discount: TPanel
          Left = 2
          Top = 15
          Width = 126
          Height = 24
          Align = alClient
          BevelOuter = bvNone
          Caption = 'PanelTotalSummGoods_Weight_Discount'
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
        Left = 659
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
    end
    object PanelZakaz: TPanel
      Left = 0
      Top = 556
      Width = 767
      Height = 37
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 3
      object GroupBox1: TGroupBox
        Left = 249
        Top = 0
        Width = 63
        Height = 37
        Align = alLeft
        Caption = #1054#1089#1090#1072#1090#1086#1082
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        object DiffZakazSalePanel: TPanel
          Left = 2
          Top = 15
          Width = 59
          Height = 20
          Align = alClient
          BevelOuter = bvNone
          Caption = 'DiffZakazSalePanel'
          TabOrder = 0
        end
      end
      object GroupBox2: TGroupBox
        Left = 0
        Top = 0
        Width = 52
        Height = 37
        Align = alLeft
        Caption = #1047#1072#1103#1074#1082#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        object ZakazCountPanel: TPanel
          Left = 2
          Top = 15
          Width = 48
          Height = 20
          Align = alClient
          BevelOuter = bvNone
          Caption = 'ZakazCountPanel'
          TabOrder = 0
        end
      end
      object GroupBox3: TGroupBox
        Left = 52
        Top = 0
        Width = 64
        Height = 37
        Align = alLeft
        Caption = #1044#1086#1079#1072#1103#1074#1082#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        object ZakazChangePanel: TPanel
          Left = 2
          Top = 15
          Width = 60
          Height = 20
          Align = alClient
          BevelOuter = bvNone
          Caption = 'ZakazChangePanel'
          TabOrder = 0
        end
      end
      object GroupBox4: TGroupBox
        Left = 116
        Top = 0
        Width = 71
        Height = 37
        Align = alLeft
        Caption = #1048#1090#1086#1075#1086
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        object calcZakazCountPanel: TPanel
          Left = 2
          Top = 15
          Width = 67
          Height = 20
          Align = alClient
          BevelOuter = bvNone
          Caption = 'calcZakazCountPanel'
          TabOrder = 0
        end
      end
      object GroupBox5: TGroupBox
        Left = 187
        Top = 0
        Width = 62
        Height = 37
        Align = alLeft
        Caption = #1054#1090#1075#1088#1091#1079#1082#1072
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 4
        object SaleCountPanel: TPanel
          Left = 2
          Top = 15
          Width = 58
          Height = 20
          Align = alClient
          BevelOuter = bvNone
          Caption = 'SaleCountPanel'
          TabOrder = 0
        end
      end
      object GroupBox6: TGroupBox
        Left = 690
        Top = 0
        Width = 77
        Height = 37
        Align = alRight
        Caption = #1048#1058#1054#1043#1054' '#1054#1089#1090'.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        object TotalDiffZakazSalePanel: TPanel
          Left = 2
          Top = 15
          Width = 73
          Height = 20
          Align = alClient
          BevelOuter = bvNone
          Caption = 'TotalDiffZakazSalePanel'
          TabOrder = 0
        end
      end
      object GroupBox7: TGroupBox
        Left = 599
        Top = 0
        Width = 91
        Height = 37
        Align = alRight
        Caption = #1048#1058#1054#1043#1054' '#1047#1072#1103#1074#1082#1072
        TabOrder = 6
        object TotalZakazCountPanel: TPanel
          Left = 2
          Top = 15
          Width = 87
          Height = 20
          Align = alClient
          BevelOuter = bvNone
          Caption = 'TotalZakazCountPanel'
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
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object ButtonSaveItem: TSpeedButton
      Left = 11
      Top = 214
      Width = 76
      Height = 20
      BiDiMode = bdRightToLeft
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      Flat = True
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000
        0000F777777777777770F888888788888870F8888887F8888870F88888878F88
        8870F888888788F88870FFFFFFFF888F8870888888888888F870888888888888
        807088888888888808700000000008808870F888888708088870F88888870088
        8870F888888708888870F888888788888870FFFFFFFFFFFFFFF0}
      Layout = blGlyphTop
      ParentFont = False
      ParentBiDiMode = False
      Visible = False
    end
    object CodeInfoPanel: TPanel
      Left = 0
      Top = 113
      Width = 133
      Height = 22
      Align = alTop
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Visible = False
    end
    object EnterGoodsCodeScanerPanel: TPanel
      Left = 0
      Top = 186
      Width = 133
      Height = 41
      Align = alTop
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
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
        Width = 97
        Height = 24
        TabOrder = 0
        Text = 'EnterGoodsCodeScanerEdit'
      end
    end
    object EnterWeightPanel: TPanel
      Left = 0
      Top = 583
      Width = 133
      Height = 51
      Align = alBottom
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      object EnterWeightLabel: TLabel
        Left = 1
        Top = 1
        Width = 131
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1042#1074#1086#1076' '#1050#1054#1051#1048#1063#1045#1057#1058#1042#1054
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 105
      end
      object EnterWeightEdit: TEdit
        Left = 8
        Top = 20
        Width = 89
        Height = 24
        TabOrder = 0
        Text = 'EnterWeightEdit'
      end
    end
    object gbBillDate: TGroupBox
      Left = 0
      Top = 0
      Width = 133
      Height = 42
      Align = alTop
      Caption = #1057#1084#1077#1085#1072' '#1079#1072
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      object BillDateEdit: TcxDateEdit
        Left = 6
        Top = 16
        EditValue = 41640d
        ParentFont = False
        TabOrder = 0
        Width = 109
      end
    end
    object EnterGoodsCode_byZakazPanel: TPanel
      Left = 0
      Top = 493
      Width = 133
      Height = 45
      Align = alBottom
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      object EnterGoodsCode_byZakazLabel: TLabel
        Left = 1
        Top = 1
        Width = 131
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1042#1074#1086#1076' '#1050#1086#1076' ('#1079#1072#1103#1074')'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 87
      end
      object EnterGoodsCode_byZakazEdit: TEdit
        Left = 6
        Top = 20
        Width = 89
        Height = 24
        TabOrder = 0
        Text = 'EnterGoodsCode_byZakazEdit'
      end
    end
    object PanelCountTare: TPanel
      Left = 0
      Top = 370
      Width = 133
      Height = 41
      Align = alBottom
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      object LabelCountTare: TLabel
        Left = 1
        Top = 1
        Width = 131
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1083' '#1103#1097#1080#1082#1086#1074
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 66
      end
      object CountTareEdit: TEdit
        Left = 3
        Top = 14
        Width = 97
        Height = 24
        TabOrder = 0
        Text = 'CountTareEdit'
      end
    end
    object infoPanel_Scale: TPanel
      Left = 0
      Top = 84
      Width = 133
      Height = 29
      Align = alTop
      TabOrder = 8
      object ScaleLabel: TLabel
        Left = 1
        Top = 1
        Width = 131
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = 'Scale.Active = NO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        ExplicitWidth = 88
      end
      object Panel_Scale: TPanel
        Left = 1
        Top = 14
        Width = 131
        Height = 14
        Align = alClient
        BevelOuter = bvNone
        Caption = 'Panel_Scale'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clTeal
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 0
      end
    end
    object EnterKindPackageCode_byZakazPanel: TPanel
      Left = 0
      Top = 538
      Width = 133
      Height = 45
      Align = alBottom
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clNavy
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 9
      object EnterKindPackageCode_byZakazLabel: TLabel
        Left = 1
        Top = 1
        Width = 131
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1042#1074#1086#1076' '#1059#1087#1072#1082' ('#1079#1072#1103#1074')'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 92
      end
      object EnterKindPackageCode_byZakazEdit: TEdit
        Left = 6
        Top = 20
        Width = 26
        Height = 24
        TabOrder = 0
        Text = 'EnterKindPackageCode_byZakazEdit'
      end
      object EnterKindPackageName_byZakazPanel: TPanel
        Left = 60
        Top = 15
        Width = 72
        Height = 29
        Align = alRight
        Alignment = taLeftJustify
        BevelOuter = bvNone
        Caption = 'EnterKindPackageName_byZakazPanel'
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clNavy
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
    end
    object gbPartionDate: TGroupBox
      Left = 0
      Top = 42
      Width = 133
      Height = 42
      Align = alTop
      Caption = #1055#1072#1088#1090#1080#1103' '#1079#1072
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clRed
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 10
      object PartionDateEdit: TcxDateEdit
        Left = 6
        Top = 15
        ParentFont = False
        TabOrder = 0
        Width = 109
      end
    end
    object PanelCountPoddon: TPanel
      Left = 0
      Top = 411
      Width = 133
      Height = 41
      Align = alBottom
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      object LabelCountPoddon: TLabel
        Left = 1
        Top = 1
        Width = 131
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1083' '#1087#1086#1076#1076#1086#1085#1086#1074
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 80
      end
      object CountPoddonEdit: TEdit
        Left = 3
        Top = 14
        Width = 97
        Height = 24
        TabOrder = 0
        Text = 'CountPoddonEdit'
      end
    end
    object PanelCountVanna: TPanel
      Left = 0
      Top = 452
      Width = 133
      Height = 41
      Align = alBottom
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      object LabelCountVanna: TLabel
        Left = 1
        Top = 1
        Width = 131
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1083' '#1074#1072#1085#1085
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 51
      end
      object CountVannaEdit: TEdit
        Left = 3
        Top = 14
        Width = 97
        Height = 24
        TabOrder = 0
        Text = 'CountVannaEdit'
      end
    end
    object PanelCountUpakovka: TPanel
      Left = 0
      Top = 329
      Width = 133
      Height = 41
      Align = alBottom
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 11
      object LabelCountUpakovka: TLabel
        Left = 1
        Top = 1
        Width = 131
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1083' '#1087#1072#1082#1077#1090#1086#1074
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 69
      end
      object CountUpakovkaEdit: TEdit
        Left = 3
        Top = 14
        Width = 97
        Height = 24
        TabOrder = 0
        Text = 'CountUpakovkaEdit'
      end
    end
    object PanelPartionStr_MB: TPanel
      Left = 0
      Top = 135
      Width = 133
      Height = 51
      Align = alTop
      BevelOuter = bvNone
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 12
      object PartionStr_MBLabel: TLabel
        Left = 0
        Top = 7
        Width = 133
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
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 133
        Height = 7
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
      end
      object infoPanelPartionStr_MB: TPanel
        Left = 0
        Top = 21
        Width = 133
        Height = 30
        Align = alClient
        TabOrder = 1
        object PartionStr_MBEdit: TEdit
          Left = 3
          Top = 3
          Width = 197
          Height = 24
          TabOrder = 0
          Text = 'PartionStr_MBEdit'
        end
      end
    end
    object PanelOperCount_sh: TPanel
      Left = 0
      Top = 288
      Width = 133
      Height = 41
      Align = alBottom
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 13
      object LabelOperCount_sh: TLabel
        Left = 1
        Top = 1
        Width = 131
        Height = 14
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1083' '#1043#1086#1083#1086#1074
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = [fsBold]
        ParentFont = False
        ExplicitWidth = 58
      end
      object OperCount_shEdit: TEdit
        Left = 3
        Top = 14
        Width = 97
        Height = 24
        TabOrder = 0
        Text = 'OperCount_shEdit'
      end
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
  object PanelInfo: TPanel
    Left = 0
    Top = 0
    Width = 900
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
    object PanelMessage: TPanel
      Left = 633
      Top = 0
      Width = 267
      Height = 28
      Align = alClient
      BevelOuter = bvNone
      Caption = 'PanelMessage'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object PanelBillKind: TPanel
      Left = 0
      Top = 0
      Width = 633
      Height = 28
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'PanelBillKind'
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
      Width = 900
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
      object PanelPartner: TPanel
        Left = 117
        Top = 0
        Width = 392
        Height = 38
        Align = alLeft
        BevelInner = bvRaised
        BevelOuter = bvNone
        TabOrder = 0
        object LabelPartner: TLabel
          Left = 1
          Top = 1
          Width = 390
          Height = 13
          Align = alTop
          Alignment = taCenter
          Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          ExplicitWidth = 71
        end
        object PanelPartnerCode: TPanel
          Left = 1
          Top = 14
          Width = 47
          Height = 23
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'PanelPartnerCode'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object PanelPartnerName: TPanel
          Left = 48
          Top = 14
          Width = 343
          Height = 23
          Align = alClient
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = 'PanelPartnerName'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
      end
      object PanelPriceList: TPanel
        Left = 0
        Top = 0
        Width = 117
        Height = 38
        Align = alLeft
        BevelInner = bvRaised
        BevelOuter = bvNone
        TabOrder = 1
        object PriceListNameLabel: TLabel
          Left = 1
          Top = 1
          Width = 115
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
        object PanelPriceListName: TPanel
          Left = 1
          Top = 14
          Width = 115
          Height = 23
          Align = alClient
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = 'PanelPriceListName'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clPurple
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
      end
      object PanelRouteUnit: TPanel
        Left = 509
        Top = 0
        Width = 284
        Height = 38
        Align = alLeft
        BevelInner = bvRaised
        BevelOuter = bvNone
        TabOrder = 2
        object LabelRouteUnit: TLabel
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
        object PanelRouteUnitCode: TPanel
          Left = 1
          Top = 14
          Width = 47
          Height = 23
          Align = alLeft
          BevelOuter = bvNone
          Caption = 'PanelRouteUnitCode'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 0
        end
        object PanelRouteUnitName: TPanel
          Left = 48
          Top = 14
          Width = 235
          Height = 23
          Align = alClient
          Alignment = taLeftJustify
          BevelOuter = bvNone
          Caption = 'PanelRouteUnitName'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clNavy
          Font.Height = -11
          Font.Name = 'MS Sans Serif'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
        end
      end
      object PanelIsRecalc: TPanel
        Left = 794
        Top = 0
        Width = 106
        Height = 38
        Align = alRight
        BevelOuter = bvNone
        Caption = 'PanelIsRecalc'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        ParentFont = False
        TabOrder = 3
      end
    end
  end
  object DataSource: TDataSource
    DataSet = Query
    Left = 490
    Top = 160
  end
  object Query: TQuery
    DatabaseName = 'MainDB'
    SQL.Strings = (
      
        'SELECT ScaleHistory.Id, ScaleHistory.InsertDate, ScaleHistory.Up' +
        'dateDate, ScaleHistory.PartionDate, ScaleHistory.PartionStr_MB, ' +
        'ScaleHistory.NumberTare, ScaleHistory.NumberLevel, ScaleHistory.' +
        'Production_Weight,ScaleHistory.DiscountWeight, case when ScaleHi' +
        'story.DiscountWeight=0 then ScaleHistory.Production_Weight else ' +
        'zf_MyRound(ScaleHistory.Production_Weight*(1-ScaleHistory.Discou' +
        'ntWeight/100)) end as Production_Weight_Discount,(ScaleHistory.T' +
        'are_Weight*ScaleHistory.Tare_Count)as Tare_Weight,ScaleHistory.T' +
        'are_Count,isnull(LastPrice.NewPrice,0)as LastPrice,isnull(LastPr' +
        'ice.NewPrice,0)*Production_Weight_Discount as ToatlSumm'
      
        '     , GoodsProperty_Production.GoodsName AS Production_Name, Go' +
        'odsProperty_Production.GoodsCode AS Production_Code,ScaleHistory' +
        '.OperCount_Upakovka,ScaleHistory.OperCount_sh'
      
        '     , GoodsProperty_Tare.GoodsName AS Tare_Name, GoodsProperty_' +
        'Tare.GoodsCode AS Tare_Code'
      
        '     , PriceList.PriceListName, KindPackage.KindPackageName,Kind' +
        'Package.Id as KindPackageId,ScaleHistory.isErased,zc__rvGetConst' +
        'Value_bk(ScaleHistory.BillKind)as BillKindName'
      'FROM dba.ScaleHistory'
      
        '     LEFT OUTER JOIN dba.GoodsProperty AS GoodsProperty_Producti' +
        'on ON GoodsProperty_Production.Id = ScaleHistory.Production_Good' +
        'sId'
      
        '     LEFT OUTER JOIN dba.GoodsProperty AS GoodsProperty_Tare ON ' +
        'GoodsProperty_Tare.Id = ScaleHistory.Tare_GoodsId'
      
        '     LEFT OUTER JOIN dba.KindPackage ON KindPackage.Id = ScaleHi' +
        'story.KindPackageId'
      
        '     LEFT OUTER JOIN dba.PriceList_byHistory as PriceList ON Pri' +
        'ceList.Id = ScaleHistory.PriceListId'
      
        '     LEFT OUTER JOIN dba.PriceListItems_byHistory as LastPrice O' +
        'N LastPrice.PriceListID=ScaleHistory.PriceListID and LastPrice.G' +
        'oodsPropertyID=ScaleHistory.Production_GoodsId and fCalcCurrentB' +
        'illDate_byProduction() between LastPrice.StartDate and LastPrice' +
        '.EndDate'
      
        'WHERE ScaleHistory.isNewItem = zc_rvYes() AND ScaleHistory.UserI' +
        'd= :@UserId'
      'ORDER By ScaleHistory.Id desc')
    Left = 490
    Top = 220
    ParamData = <
      item
        DataType = ftInteger
        Name = '@UserId'
        ParamType = ptUnknown
      end>
    object QueryProduction_Code: TIntegerField
      DisplayLabel = #1050#1086#1076' '#1087#1088#1086#1076#1091#1082#1094#1080#1080
      DisplayWidth = 12
      FieldName = 'Production_Code'
    end
    object QueryProduction_Name: TStringField
      DisplayLabel = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1088#1086#1076#1091#1082#1094#1080#1080
      DisplayWidth = 40
      FieldName = 'Production_Name'
      Size = 50
    end
    object QueryKindPackageName: TStringField
      DisplayLabel = #1042#1080#1076' '#1091#1087#1072#1082'.'
      DisplayWidth = 10
      FieldName = 'KindPackageName'
      Size = 50
    end
    object QueryPartionStr_MB: TStringField
      DisplayLabel = #1055#1072#1088#1090#1080#1103' '#1057#1067#1056#1068#1071
      DisplayWidth = 15
      FieldName = 'PartionStr_MB'
      Size = 50
    end
    object QueryPartionDate: TDateField
      DisplayLabel = #1055#1072#1088#1090#1080#1103
      DisplayWidth = 8
      FieldName = 'PartionDate'
    end
    object QueryPriceListName: TStringField
      DisplayLabel = #1053#1072#1079#1074'.'#1094#1077#1085#1099
      DisplayWidth = 10
      FieldName = 'PriceListName'
      Size = 50
    end
    object QueryDiscountWeight: TFloatField
      DisplayLabel = #1057#1082#1076' %'
      DisplayWidth = 5
      FieldName = 'DiscountWeight'
    end
    object QueryProduction_Weight_Discount: TFloatField
      DisplayLabel = #1042#1077#1089' '#1089#1086' '#1089#1082#1080#1076
      FieldName = 'Production_Weight_Discount'
    end
    object QueryProduction_Weight: TFloatField
      DisplayLabel = #1042#1077#1089' '#1087#1088#1086#1076#1091#1082#1094#1080#1080
      DisplayWidth = 15
      FieldName = 'Production_Weight'
    end
    object QueryTare_Weight: TFloatField
      DisplayLabel = #1048#1090#1086#1075#1086' '#1042#1077#1089' '#1090#1072#1088#1099
      DisplayWidth = 10
      FieldName = 'Tare_Weight'
    end
    object QueryTare_Count: TFloatField
      DisplayLabel = #1050#1086#1083' '#1090#1072#1088
      DisplayWidth = 5
      FieldName = 'Tare_Count'
    end
    object QueryTare_Code: TIntegerField
      DisplayLabel = #1050#1086#1076' '#1090#1072#1088#1099
      DisplayWidth = 10
      FieldName = 'Tare_Code'
    end
    object QueryTare_Name: TStringField
      DisplayLabel = #1042#1080#1076' '#1090#1072#1088#1099
      DisplayWidth = 12
      FieldName = 'Tare_Name'
      Size = 50
    end
    object QueryNumberTare: TIntegerField
      FieldName = 'NumberTare'
    end
    object QueryNumberLevel: TIntegerField
      DisplayWidth = 7
      FieldName = 'NumberLevel'
    end
    object QueryInsertDate: TDateTimeField
      DisplayLabel = #1044#1072#1090#1072'('#1074#1088') '#1089#1086#1079#1076#1072#1085#1080#1103
      DisplayWidth = 21
      FieldName = 'InsertDate'
    end
    object QueryUpdateDate: TDateTimeField
      DisplayLabel = #1044#1072#1090#1072'('#1074#1088') '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080
      FieldName = 'UpdateDate'
    end
    object QueryLastPrice: TFloatField
      DisplayLabel = #1062#1077#1085#1072
      FieldName = 'LastPrice'
    end
    object QueryToatlSumm: TFloatField
      FieldName = 'ToatlSumm'
    end
    object QueryId: TIntegerField
      FieldName = 'Id'
      Visible = False
    end
    object QueryKindPackageId: TIntegerField
      FieldName = 'KindPackageId'
    end
    object QueryisErased: TSmallintField
      FieldName = 'isErased'
    end
    object QueryOperCount_Upakovka: TFloatField
      FieldName = 'OperCount_Upakovka'
    end
    object QueryBillKindName: TStringField
      FieldName = 'BillKindName'
      Size = 110
    end
    object QueryOperCount_sh: TFloatField
      FieldName = 'OperCount_sh'
    end
  end
  object QueryZakaz: TQuery
    DatabaseName = 'MainDB'
    SQL.Strings = (
      
        'call dba.pCalculateReport_Match_Zakaz_onScaleHistory(:@UserId, :' +
        '@ClientId, :@BillDate, :@isMinus, :@isScale_byObvalka, :@isAll)'
      '')
    Left = 552
    Top = 208
    ParamData = <
      item
        DataType = ftInteger
        Name = '@UserId'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = '@ClientId'
        ParamType = ptUnknown
      end
      item
        DataType = ftDate
        Name = '@BillDate'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = '@isMinus'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = '@isScale_byObvalka'
        ParamType = ptUnknown
      end
      item
        DataType = ftInteger
        Name = '@isAll'
        ParamType = ptUnknown
      end>
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
  object LockTimer: TTimer
    Enabled = False
    Interval = 30000
    Left = 152
    Top = 232
  end
  object spTest: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Goods'
    DataSet = DataSetMI
    DataSets = <
      item
        DataSet = DataSetMI
      end>
    Params = <>
    Left = 224
    Top = 384
  end
  object DataSource1: TDataSource
    DataSet = DataSetMI
    Left = 320
    Top = 400
  end
  object DataSetMI: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 304
    Top = 448
  end
end
