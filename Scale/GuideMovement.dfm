object GuideMovementForm: TGuideMovementForm
  Left = 578
  Top = 242
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077' ('#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090')>'
  ClientHeight = 572
  ClientWidth = 1091
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 14
  object GridPanel: TPanel
    Left = 0
    Top = 41
    Width = 1091
    Height = 531
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object ButtonPanel: TPanel
      Left = 0
      Top = 0
      Width = 1091
      Height = 33
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object ButtonExit: TSpeedButton
        Left = 666
        Top = 3
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
        Left = 18
        Top = 3
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
      object bbChoice: TSpeedButton
        Left = 86
        Top = 3
        Width = 31
        Height = 29
        Action = actChoice
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
      object bbChangeMember: TSpeedButton
        Left = 166
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
        OnClick = bbChangeMemberClick
      end
      object bbPrint: TSpeedButton
        Left = 433
        Top = 3
        Width = 31
        Height = 29
        Hint = #1055#1077#1095#1072#1090#1100
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888888888888000000000788888077777777777888788888888887
          778878888889F9F7708878888888888777787FFFFFFFFFF7777887F0000000FF
          7778887FFFFFFF0FF7788887F888880777888888788888F8888888888F888880
          8888888887777777888888888888888888888888888888888888}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbPrintClick
      end
      object bbViewMI: TSpeedButton
        Left = 234
        Top = 3
        Width = 31
        Height = 29
        Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888880000000000000888FBFBFBFBFBFB088878BFBFBFBFBF088808FBFBFBFB
          FB0888FFBFBFBFBFBF088878FBFBFBFBFB088808BFBFBFBFBF0888FBFBFBFBFB
          FB088878BFBFBFBFBF088808FBFBFBFBFB0888FFBFBFBFBFBF088878FBFBFBFB
          FB088808BFBFBFBFBF0888FBFBFBFBFBFB088877777777777778}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbViewMIClick
      end
      object bbEDI_Invoice: TSpeedButton
        Left = 496
        Top = 3
        Width = 31
        Height = 29
        Hint = 'EDI <'#1057#1095#1077#1090' - Invoice> '#1086#1090#1087#1088#1072#1074#1080#1090#1100
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000000000000000
          0000000000000000000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FFFFFF000000
          000000000000FFFFFF000000000000000000FFFFFF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FFFFFF000000
          000000000000FFFFFF000000000000000000FFFFFF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0084000000840000008400
          0000840000008400000084000000840000008400000084000000FF00FF00FF00
          FF0000000000000000000000000000000000FF00FF0084000000840000008400
          0000840000008400000084000000840000008400000084000000FF00FF00FF00
          FF000000000000FFFF0000FFFF0000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF000000FF000000FF00FF00FF00FF00FF00000000000000
          00000000000000FFFF0000FFFF00000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF000000FF000000FF00FF00FF00FF00FF000000000000FF
          FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF000000FF000000FF00FF00FF00FF00FF000000000000FF
          FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000FF00FF000000
          FF00FF00FF00FF00FF000000FF000000FF00FF00FF00FF00FF00000000000000
          00000000000000FFFF0000FFFF00000000000000000000000000FF00FF000000
          FF000000FF00FF00FF000000FF000000FF00FF00FF00FF00FF00FF00FF00FF00
          FF000000000000FFFF0000FFFF0000000000FF00FF00FF00FF00FF00FF00FF00
          FF000000FF000000FF000000FF000000FF00FF00FF00FF00FF00FF00FF00FF00
          FF0000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF000000FF000000FF000000FF00FF00FF00FF00FF00}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbEDI_InvoiceClick
      end
      object bbEDI_Ordspr: TSpeedButton
        Left = 548
        Top = 3
        Width = 31
        Height = 29
        Hint = 'EDI <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' - Ordspr> '#1086#1090#1087#1088#1072#1074#1080#1090#1100
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000000000000000
          0000000000000000000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FFFFFF000000
          000000000000FFFFFF000000000000000000FFFFFF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FFFFFF000000
          000000000000FFFFFF000000000000000000FFFFFF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0084000000840000008400
          0000840000008400000084000000840000008400000084000000FF00FF00FF00
          FF0000000000000000000000000000000000FF00FF0084000000840000008400
          0000840000008400000084000000840000008400000084000000FF00FF00FF00
          FF000000000000FFFF0000FFFF0000000000FF00FF00FF00FF00FF00FF00FF00
          FF000000FF000000FF000000FF000000FF000000FF00FF00FF00000000000000
          00000000000000FFFF0000FFFF00000000000000000000000000FF00FF00FF00
          FF000000FF000000FF00FF00FF00FF00FF00FF00FF00FF00FF000000000000FF
          FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000FF00FF00FF00
          FF00FF00FF000000FF000000FF00FF00FF00FF00FF00FF00FF000000000000FF
          FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF000000FF000000FF00FF00FF00FF00FF00000000000000
          00000000000000FFFF0000FFFF00000000000000000000000000FF00FF00FF00
          FF000000FF00FF00FF00FF00FF000000FF000000FF00FF00FF00FF00FF00FF00
          FF000000000000FFFF0000FFFF0000000000FF00FF00FF00FF00FF00FF00FF00
          FF000000FF000000FF00FF00FF000000FF000000FF00FF00FF00FF00FF00FF00
          FF0000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF000000FF000000FF000000FF00FF00FF00FF00FF00}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbEDI_OrdsprClick
      end
      object bbEDI_Desadv: TSpeedButton
        Left = 601
        Top = 3
        Width = 31
        Height = 29
        Hint = 'EDI <'#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' - Desadv> '#1086#1090#1087#1088#1072#1074#1080#1090#1100
        Glyph.Data = {
          36040000424D3604000000000000360000002800000010000000100000000100
          2000000000000004000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000000000000000
          0000000000000000000000000000000000000000000000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FFFFFF000000
          000000000000FFFFFF000000000000000000FFFFFF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FFFFFF000000
          000000000000FFFFFF000000000000000000FFFFFF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0000000000FFFFFF00FFFF
          FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF0084000000840000008400
          0000840000008400000084000000840000008400000084000000FF00FF00FF00
          FF0000000000000000000000000000000000FF00FF0084000000840000008400
          0000840000008400000084000000840000008400000084000000FF00FF00FF00
          FF000000000000FFFF0000FFFF0000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF000000FF000000FF000000FF00FF00FF00FF00FF00000000000000
          00000000000000FFFF0000FFFF00000000000000000000000000FF00FF00FF00
          FF000000FF000000FF00FF00FF000000FF000000FF00FF00FF000000000000FF
          FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000FF00FF00FF00
          FF000000FF00FF00FF00FF00FF000000FF000000FF00FF00FF000000000000FF
          FF0000FFFF0000FFFF0000FFFF0000FFFF0000FFFF0000000000FF00FF00FF00
          FF00FF00FF00FF00FF000000FF000000FF00FF00FF00FF00FF00000000000000
          00000000000000FFFF0000FFFF00000000000000000000000000FF00FF00FF00
          FF000000FF00FF00FF00FF00FF000000FF000000FF00FF00FF00FF00FF00FF00
          FF000000000000FFFF0000FFFF0000000000FF00FF00FF00FF00FF00FF00FF00
          FF000000FF000000FF00FF00FF000000FF000000FF00FF00FF00FF00FF00FF00
          FF0000000000000000000000000000000000FF00FF00FF00FF00FF00FF00FF00
          FF00FF00FF000000FF000000FF000000FF00FF00FF00FF00FF00}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbEDI_DesadvClick
      end
      object bbSale_Order_all: TSpeedButton
        Left = 318
        Top = 3
        Width = 31
        Height = 29
        Hint = #1047#1072#1103#1074#1082#1072'/'#1054#1090#1075#1088#1091#1079#1082#1072' '#1042#1057#1045' - F8'
        Glyph.Data = {
          76010000424D7601000000000000760000002800000020000000100000000100
          04000000000000010000120B0000120B00001000000000000000000000000000
          800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
          0003377777777777777308888888888888807F33333333333337088888888888
          88807FFFFFFFFFFFFFF7000000000000000077777777777777770F8F8F8F8F8F
          8F807F333333333333F708F8F8F8F8F8F9F07F333333333337370F8F8F8F8F8F
          8F807FFFFFFFFFFFFFF7000000000000000077777777777777773330FFFFFFFF
          03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
          03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
          33333337F3F37F3733333330F08F0F0333333337F7337F7333333330FFFF0033
          33333337FFFF7733333333300000033333333337777773333333}
        NumGlyphs = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = bbSale_Order_allClick
      end
      object bbSale_Order_diff: TSpeedButton
        Left = 355
        Top = 3
        Width = 31
        Height = 29
        Hint = #1047#1072#1103#1074#1082#1072'/'#1054#1090#1075#1088#1091#1079#1082#1072' '#1052#1048#1053#1059#1057' - F9'
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          0400000000008000000000000000000000001000000000000000000000000000
          8000008000000080800080000000800080008080000080808000C0C0C0000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
          8888888888888888888888000000000788888077777777777888788888888887
          778878888889F9F7708878888888888777787FFFFFFFFFF7777887F0000000FF
          7778887FF9FFF10FF7788887F898180777888888788988F8888888888F189880
          8888888887777777888888888888888888888888888888888888}
        ParentShowHint = False
        ShowHint = True
        OnClick = bbSale_Order_diffClick
      end
    end
    object cxDBGrid: TcxGrid
      Left = 0
      Top = 33
      Width = 1091
      Height = 498
      Align = alClient
      TabOrder = 1
      object cxDBGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = DS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnMoving = False
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.GroupByBox = False
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object StartWeighing: TcxGridDBColumn
          Caption = #1053#1072#1095'. '#1074#1079#1074#1077#1096'.'
          DataBinding.FieldName = 'StartWeighing'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object EndWeighing: TcxGridDBColumn
          Caption = #1054#1082#1086#1085#1095'. '#1074#1079#1074#1077#1096'.'
          DataBinding.FieldName = 'EndWeighing'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 80
        end
        object StartRunPlan: TcxGridDBColumn
          Caption = #1044#1072#1090#1072'/'#1042#1088#1077#1084#1103' '#1074#1099#1077#1079#1076#1072' '#1087#1083#1072#1085
          DataBinding.FieldName = 'StartRunPlan'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          Width = 100
        end
        object Status: TcxGridDBColumn
          Caption = #1057#1090#1072#1090#1091#1089
          DataBinding.FieldName = 'StatusCode'
          PropertiesClassName = 'TcxImageComboBoxProperties'
          Properties.Images = dmMain.ImageList
          Properties.Items = <
            item
              Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
              ImageIndex = 11
              Value = 1
            end
            item
              Description = #1055#1088#1086#1074#1077#1076#1077#1085
              ImageIndex = 12
              Value = 2
            end
            item
              Description = #1059#1076#1072#1083#1077#1085
              ImageIndex = 13
              Value = 3
            end>
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object MovementDescNumber: TcxGridDBColumn
          Caption = #8470' '#1086#1087#1077#1088'.'
          DataBinding.FieldName = 'MovementDescNumber'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 45
        end
        object MovementDescName: TcxGridDBColumn
          Caption = #1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
          DataBinding.FieldName = 'MovementDescName'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 80
        end
        object OperDate_parent: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' '#1076#1086#1082'. ('#1075#1083#1072#1074#1085#1099#1081')'
          DataBinding.FieldName = 'OperDate_parent'
          Visible = False
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object OperDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
          DataBinding.FieldName = 'OperDate'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object OperDate_TransportGoods: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1058#1058#1053
          DataBinding.FieldName = 'OperDate_TransportGoods'
          Visible = False
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object InvNumber: TcxGridDBColumn
          Caption = #8470' '#1076#1086#1082'.'
          DataBinding.FieldName = 'InvNumber'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object InvNumber_parent: TcxGridDBColumn
          Caption = #8470' '#1076#1086#1082'. ('#1075#1083#1072#1074#1085#1099#1081')'
          DataBinding.FieldName = 'InvNumber_parent'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object InvNumberOrder: TcxGridDBColumn
          Caption = #8470' '#1076#1086#1082'.  '#1086#1089#1085#1086#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'InvNumberOrder'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 70
        end
        object InvNumberPartner_Tax: TcxGridDBColumn
          Caption = #8470' '#1085#1072#1083#1086#1075'.'
          DataBinding.FieldName = 'InvNumberPartner_Tax'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object OperDate_Tax: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' '#1085#1072#1083#1086#1075'.'
          DataBinding.FieldName = 'OperDate_Tax'
          Visible = False
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 60
        end
        object InvNumber_Transport: TcxGridDBColumn
          Caption = #8470' '#1076#1086#1082'. '#1087#1091#1090#1077#1074#1086#1081' '#1083'.'
          DataBinding.FieldName = 'InvNumber_Transport'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object OperDate_Transport: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1087#1091#1090#1077#1074#1086#1081' '#1083'.'
          DataBinding.FieldName = 'OperDate_Transport'
          Visible = False
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object InvNumber_TransportGoods: TcxGridDBColumn
          Caption = #8470' '#1076#1086#1082'. '#1058#1058#1053
          DataBinding.FieldName = 'InvNumber_TransportGoods'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 60
        end
        object WeighingNumber: TcxGridDBColumn
          Caption = #8470' '#1074#1079#1074#1077#1096'.'
          DataBinding.FieldName = 'WeighingNumber'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 50
        end
        object FromName: TcxGridDBColumn
          Caption = #1054#1090' '#1082#1086#1075#1086
          DataBinding.FieldName = 'FromName'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 100
        end
        object ToName: TcxGridDBColumn
          Caption = #1050#1086#1084#1091
          DataBinding.FieldName = 'ToName'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 100
        end
        object UserName: TcxGridDBColumn
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
          DataBinding.FieldName = 'UserName'
          Visible = False
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 100
        end
        object PaidKindName: TcxGridDBColumn
          Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
          DataBinding.FieldName = 'PaidKindName'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 50
        end
        object TotalCount: TcxGridDBColumn
          Caption = #1050#1086#1083'-'#1074#1086' ('#1089#1082#1083#1072#1076')'
          DataBinding.FieldName = 'TotalCount'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 60
        end
        object TotalCountTare: TcxGridDBColumn
          Caption = #1050#1086#1083'-'#1074#1086' '#1090#1072#1088#1099
          DataBinding.FieldName = 'TotalCountTare'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Visible = False
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 60
        end
        object TotalSumm: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1080#1090#1086#1075')'
          DataBinding.FieldName = 'TotalSumm'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 80
        end
        object ChangePercent: TcxGridDBColumn
          Caption = '(-)% '#1089#1082'. (+)% '#1085#1072#1094
          DataBinding.FieldName = 'ChangePercent'
          Visible = False
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 52
        end
        object ContractName: TcxGridDBColumn
          Caption = #8470' '#1076#1086#1075'.'
          DataBinding.FieldName = 'ContractName'
          Visible = False
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object ContractTagName: TcxGridDBColumn
          Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
          DataBinding.FieldName = 'ContractTagName'
          Visible = False
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 55
        end
        object RouteName: TcxGridDBColumn
          Caption = #1052#1072#1088#1096#1088#1091#1090
          DataBinding.FieldName = 'RouteName'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object CarName: TcxGridDBColumn
          Caption = #1040#1090#1086#1084#1086#1073#1080#1083#1100
          DataBinding.FieldName = 'CarName'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object PersonalDriverName: TcxGridDBColumn
          Caption = #1042#1086#1076#1080#1090#1077#1083#1100
          DataBinding.FieldName = 'PersonalDriverName'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object InfoMoneyCode: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1059#1055
          DataBinding.FieldName = 'InfoMoneyCode'
          Visible = False
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 50
        end
        object InfoMoneyName: TcxGridDBColumn
          Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
          DataBinding.FieldName = 'InfoMoneyName'
          Visible = False
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 80
        end
        object PersonalCode1: TcxGridDBColumn
          Caption = #1050#1086#1076'1 '#1089#1086#1090#1088'. '#1082#1086#1084#1087#1083'.'
          DataBinding.FieldName = 'PersonalCode1'
          Visible = False
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object PersonalName1: TcxGridDBColumn
          Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082' 1'
          DataBinding.FieldName = 'PersonalName1'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 120
        end
        object PersonalCode2: TcxGridDBColumn
          Caption = #1050#1086#1076'2 '#1089#1086#1090#1088'. '#1082#1086#1084#1087#1083'.'
          DataBinding.FieldName = 'PersonalCode2'
          Visible = False
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object PersonalName2: TcxGridDBColumn
          Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082' 2'
          DataBinding.FieldName = 'PersonalName2'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 120
        end
        object PersonalCode3: TcxGridDBColumn
          Caption = #1050#1086#1076'3 '#1089#1086#1090#1088'. '#1082#1086#1084#1087#1083'.'
          DataBinding.FieldName = 'PersonalCode3'
          Visible = False
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object PersonalName3: TcxGridDBColumn
          Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082' 3'
          DataBinding.FieldName = 'PersonalName3'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 120
        end
        object PersonalCode4: TcxGridDBColumn
          Caption = #1050#1086#1076'4 '#1089#1086#1090#1088'. '#1082#1086#1084#1087#1083'.'
          DataBinding.FieldName = 'PersonalCode4'
          Visible = False
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 55
        end
        object PersonalName4: TcxGridDBColumn
          Caption = #1050#1086#1084#1087#1083#1077#1082#1090#1086#1074#1097#1080#1082' 4'
          DataBinding.FieldName = 'PersonalName4'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 120
        end
        object PositionName1: TcxGridDBColumn
          Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' '#1082#1086#1084#1087#1083'.1'
          DataBinding.FieldName = 'PositionName1'
          Visible = False
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object PositionName2: TcxGridDBColumn
          Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' '#1082#1086#1084#1087#1083'.2'
          DataBinding.FieldName = 'PositionName2'
          Visible = False
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object PositionName3: TcxGridDBColumn
          Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' '#1082#1086#1084#1087#1083'.3'
          DataBinding.FieldName = 'PositionName3'
          Visible = False
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object PositionName4: TcxGridDBColumn
          Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' '#1082#1086#1084#1087#1083'.4'
          DataBinding.FieldName = 'PositionName4'
          Visible = False
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object EdiInvoice: TcxGridDBColumn
          Caption = #1057#1095#1077#1090' Edi Invoice'
          DataBinding.FieldName = 'EdiInvoice'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object EdiOrdspr: TcxGridDBColumn
          Caption = #1055#1086#1076#1090#1074'. Edi Ordspr'
          DataBinding.FieldName = 'EdiOrdspr'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
        object EdiDesadv: TcxGridDBColumn
          Caption = #1059#1074#1077#1076'. Edi Desadv'
          DataBinding.FieldName = 'EdiDesadv'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Width = 70
        end
      end
      object cxDBGridLevel: TcxGridLevel
        GridView = cxDBGridDBTableView
      end
    end
  end
  object ParamsPanel: TPanel
    Left = 0
    Top = 0
    Width = 1091
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object gbInvNumber_parent: TGroupBox
      Left = 280
      Top = 0
      Width = 137
      Height = 41
      Align = alLeft
      Caption = #8470' '#1076#1086#1082'. ('#1075#1083#1072#1074#1085#1099#1081')'
      TabOrder = 0
      object EditInvNumber_parent: TEdit
        Left = 5
        Top = 17
        Width = 125
        Height = 22
        TabOrder = 0
        Text = 'EditInvNumber_parent'
        OnChange = EditInvNumber_parentChange
      end
    end
    object GroupBox1: TGroupBox
      Left = 140
      Top = 0
      Width = 140
      Height = 41
      Align = alLeft
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072
      TabOrder = 1
      object deEnd: TcxDateEdit
        Left = 7
        Top = 16
        EditValue = 42005d
        Properties.ReadOnly = False
        Properties.SaveTime = False
        Properties.ShowTime = False
        Properties.OnChange = deEndPropertiesChange
        TabOrder = 0
        Width = 110
      end
    end
    object GroupBox2: TGroupBox
      Left = 0
      Top = 0
      Width = 140
      Height = 41
      Align = alLeft
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072
      TabOrder = 2
      object deStart: TcxDateEdit
        Left = 7
        Top = 16
        EditValue = 42005d
        Properties.ReadOnly = False
        Properties.SaveTime = False
        Properties.ShowTime = False
        Properties.OnChange = deStartPropertiesChange
        TabOrder = 0
        Width = 110
      end
    end
    object cbPrintMovement: TCheckBox
      Left = 433
      Top = 23
      Width = 86
      Height = 17
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 3
      OnClick = cbPrintMovementClick
    end
    object cbPrintTransport: TCheckBox
      Left = 526
      Top = 23
      Width = 48
      Height = 17
      Caption = #1058#1058#1053
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 4
      OnClick = cbPrintTransportClick
    end
    object cbPrintQuality: TCheckBox
      Left = 584
      Top = 23
      Width = 103
      Height = 17
      Caption = #1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
      OnClick = cbPrintQualityClick
    end
    object cbPrintAccount: TCheckBox
      Left = 801
      Top = 23
      Width = 53
      Height = 17
      Caption = #1057#1095#1077#1090
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      OnClick = cbPrintAccountClick
    end
    object cbPrintPack: TCheckBox
      Left = 584
      Top = 3
      Width = 100
      Height = 17
      Caption = #1059#1087#1072#1082#1086#1074#1086#1095#1085#1099#1081
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 7
      OnClick = cbPrintPackClick
    end
    object cbPrintSpec: TCheckBox
      Left = 694
      Top = 3
      Width = 110
      Height = 17
      Caption = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 8
      OnClick = cbPrintSpecClick
    end
    object cbPrintTax: TCheckBox
      Left = 694
      Top = 23
      Width = 85
      Height = 17
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 9
      OnClick = cbPrintTaxClick
    end
    object cbPrintPreview: TCheckBox
      Left = 433
      Top = 0
      Width = 128
      Height = 17
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1077#1095#1072#1090#1080
      Font.Charset = RUSSIAN_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 10
    end
  end
  object DS: TDataSource
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
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxDBGridDBTableView
    OnDblClickActionList = <
      item
        Action = actChoice
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
    Left = 384
    Top = 168
    object actRefresh: TAction
      Category = 'ScaleLib'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      OnExecute = actRefreshExecute
    end
    object actChoice: TAction
      Category = 'ScaleLib'
      Hint = #1042#1099#1073#1086#1088' '#1079#1085#1072#1095#1077#1085#1080#1103
      OnExecute = actChoiceExecute
    end
    object actExit: TAction
      Category = 'ScaleLib'
      Hint = #1042#1099#1093#1086#1076
      OnExecute = actExitExecute
    end
    object actViewMI: TdsdInsertUpdateAction
      Category = 'ScaleLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      FormName = 'TWeighingPartnerForm'
      FormNameParam.Value = 'TWeighingPartnerForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
        end
        item
          Name = 'ShowAll'
          Value = True
          DataType = ftBoolean
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end>
    Left = 112
    Top = 184
  end
end
