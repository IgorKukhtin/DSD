inherited MainCashForm: TMainCashForm
  ActiveControl = lcName
  Caption = #1055#1088#1086#1076#1072#1078#1072
  ClientHeight = 546
  ClientWidth = 784
  PopupMenu = PopupMenu
  OnCloseQuery = ParentFormCloseQuery
  OnCreate = FormCreate
  OnDestroy = ParentFormDestroy
  OnKeyDown = ParentFormKeyDown
  OnShow = ParentFormShow
  AddOnFormData.Params = FormParams
  AddOnFormData.AddOnFormRefresh.SelfList = 'MainCheck'
  ExplicitWidth = 800
  ExplicitHeight = 585
  PixelsPerInch = 96
  TextHeight = 13
  object BottomPanel: TPanel [0]
    Left = 0
    Top = 350
    Width = 784
    Height = 196
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object CheckGrid: TcxGrid
      Left = 0
      Top = 0
      Width = 530
      Height = 196
      Align = alClient
      TabOrder = 0
      object CheckGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = CheckDS
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.GridLineColor = clBtnFace
        OptionsView.GroupByBox = False
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object CheckGridColCode: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'GoodsCode'
        end
        object CheckGridColName: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'GoodsName'
          Width = 271
        end
        object CheckGridColAmount: TcxGridDBColumn
          Caption = #1050#1086#1083'-'#1074#1086
          DataBinding.FieldName = 'Amount'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Width = 58
        end
        object CheckGridColPrice: TcxGridDBColumn
          Caption = #1062#1077#1085#1072
          DataBinding.FieldName = 'Price'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Width = 55
        end
        object CheckGridColSumm: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072
          DataBinding.FieldName = 'Summ'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Width = 58
        end
        object CheckGridColPriceSale: TcxGridDBColumn
          Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1089#1082'.'
          DataBinding.FieldName = 'PriceSale'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Width = 70
        end
        object CheckGridColChangePercent: TcxGridDBColumn
          Caption = '% '#1089#1082'.'
          DataBinding.FieldName = 'ChangePercent'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Width = 45
        end
        object CheckGridColSummChangePercent: TcxGridDBColumn
          Caption = #1089#1091#1084#1084#1072' '#1089#1082'.'
          DataBinding.FieldName = 'SummChangePercent'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Width = 70
        end
        object CheckGridColAmountOrder: TcxGridDBColumn
          Caption = #1047#1072#1082#1072#1079
          DataBinding.FieldName = 'AmountOrder'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Width = 45
        end
      end
      object CheckGridLevel: TcxGridLevel
        GridView = CheckGridDBTableView
      end
    end
    object AlternativeGrid: TcxGrid
      Left = 533
      Top = 0
      Width = 251
      Height = 196
      Align = alRight
      TabOrder = 1
      object AlternativeGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = AlternativeDS
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.GridLineColor = clBtnFace
        OptionsView.GroupByBox = False
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object AlternativeGridColLinkType: TcxGridDBColumn
          Caption = '*'
          DataBinding.FieldName = 'LinkType'
          PropertiesClassName = 'TcxImageComboBoxProperties'
          Properties.Images = dmMain.ImageList
          Properties.Items = <
            item
              Description = #1044#1086#1087#1086#1083#1085#1077#1085#1080#1077
              ImageIndex = 54
              Value = 0
            end
            item
              Description = #1040#1083#1100#1090#1077#1088#1085#1072#1090#1080#1074#1072
              ImageIndex = 27
              Value = 1
            end>
          Properties.ShowDescriptions = False
          Width = 21
        end
        object AlternativeGridColGoodsCode: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'GoodsCode'
          Visible = False
          Width = 52
        end
        object AlternativeGridColGoodsName: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'GoodsName'
          Width = 139
        end
        object AlternativeGridColTypeColor: TcxGridDBColumn
          DataBinding.FieldName = 'TypeColor'
          Visible = False
        end
        object AlternativeGridDColPrice: TcxGridDBColumn
          Caption = #1062#1077#1085#1072
          DataBinding.FieldName = 'Price'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.00'
          Width = 40
        end
        object AlternativeGridColRemains: TcxGridDBColumn
          Caption = #1054#1089#1090'.'
          DataBinding.FieldName = 'Remains'
          Width = 33
        end
      end
      object AlternativeGridLevel: TcxGridLevel
        Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
        GridView = AlternativeGridDBTableView
      end
    end
    object cxSplitter1: TcxSplitter
      Left = 530
      Top = 0
      Width = 3
      Height = 196
      AlignSplitter = salRight
      Control = AlternativeGrid
    end
  end
  object cxSplitter2: TcxSplitter [1]
    Left = 0
    Top = 347
    Width = 784
    Height = 3
    AlignSplitter = salBottom
    Control = BottomPanel
  end
  object MainPanel: TPanel [2]
    Left = 0
    Top = 98
    Width = 784
    Height = 249
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object MainGrid: TcxGrid
      Left = 0
      Top = 0
      Width = 784
      Height = 216
      Align = alClient
      TabOrder = 0
      object MainGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        OnFocusedRecordChanged = MainGridDBTableViewFocusedRecordChanged
        DataController.DataSource = RemainsDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.KeyFieldNames = 'Id'
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsBehavior.IncSearch = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Inserting = False
        OptionsView.GridLineColor = clBtnFace
        OptionsView.GroupByBox = False
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object MainColIsSP: TcxGridDBColumn
          Caption = #1057#1055
          DataBinding.FieldName = 'isSP'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 25
        end
        object MainColName: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'GoodsName'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 200
        end
        object MainColCode: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'GoodsCode'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 62
        end
        object BarCode: TcxGridDBColumn
          Caption = #1064'/'#1050' '#1087#1088#1086#1080#1079#1074'.'
          DataBinding.FieldName = 'BarCode'
          HeaderAlignmentHorz = taCenter
          HeaderHint = #1064'/'#1050' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1103
          Options.Editing = False
          Width = 70
        end
        object MainColRemains: TcxGridDBColumn
          Caption = #1054#1057#1058'.'
          DataBinding.FieldName = 'Remains'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 3
          Properties.DisplayFormat = ',0.###'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Styles.Content = dmMain.cxRemainsContentStyle
          Width = 45
        end
        object MainColPrice: TcxGridDBColumn
          Caption = #1062#1077#1085#1072
          DataBinding.FieldName = 'Price'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.00'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 45
        end
        object MainColPriceSP: TcxGridDBColumn
          Caption = #1062#1077#1085#1072'.'#1089#1087
          DataBinding.FieldName = 'PriceSP'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 55
        end
        object MainColPriceSaleSP: TcxGridDBColumn
          Caption = #1062'.'#1089#1087' '#1073#1077#1079' '#1089#1082
          DataBinding.FieldName = 'PriceSaleSP'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 80
        end
        object DiffSP1: TcxGridDBColumn
          Caption = #1089#1082'1'
          DataBinding.FieldName = 'DiffSP1'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 45
        end
        object DiffSP2: TcxGridDBColumn
          Caption = #1089#1082'2'
          DataBinding.FieldName = 'DiffSP2'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
          Visible = False
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 45
        end
        object MainColIntenalSPName: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072' ('#1089#1087')'
          DataBinding.FieldName = 'IntenalSPName'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 80
        end
        object MainColReserved: TcxGridDBColumn
          Caption = 'VIP'
          DataBinding.FieldName = 'Reserved'
          OnGetDisplayText = MainColReservedGetDisplayText
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 40
        end
        object MainColMCSValue: TcxGridDBColumn
          Caption = #1053#1058#1047
          DataBinding.FieldName = 'MCSValue'
          OnGetDisplayText = MainColReservedGetDisplayText
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 40
        end
        object MainColor_calc: TcxGridDBColumn
          DataBinding.FieldName = 'Color_calc'
          Visible = False
          Options.Editing = False
          VisibleForCustomization = False
          Width = 40
        end
        object MaincolisFirst: TcxGridDBColumn
          DataBinding.FieldName = 'isFirst'
          HeaderGlyph.SourceDPI = 96
          HeaderGlyph.Data = {
            424DFA0900000000000036000000280000001900000019000000010020000000
            000000000000C40E0000C40E00000000000000000000FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FBF1F1FF696F6FFF059B9BFF03EA
            EAFF01F9F9FF01FBFBFF01FBFBFF01F9F9FF03E7E7FF059393FF727575FFFDF3
            F3FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00656969FF04CFCFFF00FAFAFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FA
            FAFF04C6C6FF767474FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00F7E5E5FF1E8787FF00F8F8FF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00F8F8FF277D7DFFFFF4F4FFFFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FCE9E9FF0E9C9CFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00EEEEFF006060FF002525FF001414FF001414FF002727FF006A
            6AFF00F3F3FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF179191FFFFF7F7FFFFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF001D8E8EFF00FFFFFF00FFFFFF00FF
            FFFF00E9E9FF002B2BFF004B4BFF00C0C0FF00F0F0FF00FFFFFF00FFFFFF00ED
            EDFF00BBBBFF004444FF003737FF00EFEFFF00FFFFFF00FFFFFF00FFFFFF2983
            83FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00617070FF00F9F9FF00FFFFFF00FF
            FFFF00C9C9FF001818FF00DCDCFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00D2D2FF001B1BFF00D6D6FF00FFFFFF00FF
            FFFF00F4F4FF797979FFFFFFFF00FFFFFF00FEF3F3FF04D1D1FF00FFFFFF00FF
            FFFF00DEDEFF001A1AFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F6F6FF001A1AFF00E9
            EAFF00FFFFFF00FFFFFF07C5C5FFFFFDFDFFFFFFFF00606D6DFF00FCFCFF00FF
            FFFF00FFFFFF001C1CFF00F1F1FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00E3
            E3FF002323FF00FFFFFF00FFFFFF00F9F9FF807C7CFFFFFFFF000A9B9BFF00FF
            FFFF00FFFFFF00B0B0FF008585FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF006D6DFF00CECEFF00FFFFFF00FFFFFF0A8787FFFEFBFBFF02EE
            EEFF00FFFFFF00FFFFFF003232FF00E2E2FF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00D6D6FF003939FF00FFFFFF00FFFFFF04DDDDFFDCB7
            B7FF00F8F8FF00FFFFFF00FBFBFF001414FF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF001A1AFF00FCFCFF00FFFFFF02F9
            F9FF826161FF00FAFAFF00FFFFFF006C6CFF000303FF007878FF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF005757FF000202FF007272FF00FF
            FFFF01FAFAFF826262FF00FAFAFF00FFFFFF00FFFFFF00FEFEFF00FEFEFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FEFEFF00FF
            FFFF00FFFFFF01FAFAFFD7B2B2FF00F8F8FF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF002727FF00A8A8FF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00EBEBFF000000FF00F2F2FF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF02F9F9FFFEFBFBFF02EDEDFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00CACAFF000000FF001717FF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF003E3EFF000000FF009696FF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF04DFDFFFFFFFFF000A9D9DFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF009494FF000000FF000707FF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF001919FF000000FF005455FF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0A8B8DFFFFFFFF005D6F6FFF00FC
            FCFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008383FF000000FF0003
            03FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF001212FF000000FF002728FF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FAFAFF808080FFFFFFFF00FDF1
            F1FF04D7D7FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF008989FF0000
            00FF000303FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF001515FF000000FF0038
            38FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF08C9C9FFFFFBFBFFFFFF
            FF00FFFFFF005C6E6EFF00F9F9FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00AC
            ACFF000000FF000D0DFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF001E1EFF0000
            00FF006A6AFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F5F5FF787878FFFFFF
            FF00FFFFFF00FFFFFF00FFFFFF001A8B8BFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00E7E7FF000000FF003232FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0081
            81FF000000FF00C0C0FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF267E7EFFFFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FAE8E8FF0C9999FF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00C5C5FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00A1A1FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF139191FFFFF6
            F6FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F8E4E4FF1B89
            89FF00F9F9FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F8F8FF278282FFFFF0
            F0FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00606C6CFF04D3D3FF00FBFBFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FAFAFF04CCCCFF6F7272FFFFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00F8EDEDFF647070FF079E9EFF03EAEAFF00F7
            F7FF00F9F9FF00F9F9FF00F7F7FF02E8E8FF079999FF6F7373FFFBF0F0FFFFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFB
            FBFFDDBBBBFF8E6B6BFF967373FFE1BEBEFFFFFDFDFFFFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
          HeaderGlyphAlignmentHorz = taCenter
          HeaderHint = #1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1074#1099#1073#1086#1088
          Options.Editing = False
          Width = 40
          IsCaptionAssigned = True
        end
        object MaincolIsSecond: TcxGridDBColumn
          DataBinding.FieldName = 'isSecond'
          HeaderGlyph.SourceDPI = 96
          HeaderGlyph.Data = {
            424DFA0900000000000036000000280000001900000019000000010020000000
            000000000000C40E0000C40E00000000000000000000FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00ECD8D8FF98A0A3FF479899FF23B5
            B7FF17CACBFF09D7DAFF08D6DAFF17C7C8FF22B1B1FF56999AFFA7AAABFFFCE6
            E6FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFF3F2FF98A0A2FF1D9A9AFF00D3D4FF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FBFBFF00CA
            CBFF339496FFADA9ACFFFFFDFDFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00F1DEDEFF538F8FFF00CDCEFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00BBBDFF778E8FFFFEEEEFFFFFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00F1DEDEFF429193FF00EBECFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D6D8FF608788FFFEF0F0FFFFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFF1F1FF588C8CFF00EDEDFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00DADBFF7C93
            95FFFFFDFDFFFFFFFF00FFFFFF00FFFFFF00949C9EFF00D5D5FF00FFFFFF04E8
            E7FF01A8ABFF01FCFCFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F0F0FF01A9ADFF06F7F7FF00FF
            FFFF05B7B9FFC0B3B4FFFFFFFF00FFFFFF00E9D7D7FF15A0A1FF00FFFFFF05F1
            F1FF062424FF072628FF01FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF04F5F5FF070506FF0C42
            44FF03FEFFFF00FFFFFF388F90FFFBECECFFFFFFFF008DA2A1FF00E4E4FF00FF
            FFFF088A8BFF0A0000FF091315FF029B9DFF04FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF03F4F5FF097778FF0A0A
            0BFF080000FF0DB9BBFF00FFFFFF00C7C7FFBAB3B4FFFFECECFF369D9FFF00FF
            FFFF00FFFFFF069D9FFF0E797BFF119797FF090405FF052323FF008989FF08CD
            CEFF03F1F1FF0CFBFCFF0CFAFBFF03ECEEFF06C3C4FF057272FF041112FF0618
            18FF0BB6B8FF07696DFF08C1C1FF00FFFFFF00F8F9FF619C9FFFD4ADAEFF0FBC
            BEFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF09E0E0FF067575FF061C
            1CFF070305FF040B0DFF0E1517FF0E1315FF05080AFF080405FF06282BFF068B
            8DFF05F4F4FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF2EAAACFF9082
            7EFF02D7D6FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF04FFFFFF04DADBFF03B4B5FF00A2A2FF00A3A3FF03B8B9FF09E0E0FF03FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF1BC1
            C2FF6A6D76FF03E2E6FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF16CDCDFF6C6A76FF07E3E7FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF08D2D2FF837A79FF03DBDBFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF02F0F1FF03DDDEFF01FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF05D7D8FF05F9F9FF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF14C8CBFFBD9D9DFF0CC4C5FF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF05F5F5FF073132FF030808FF04C9C9FF00FFFFFF00FF
            FFFF00FFFFFF01FFFFFF05A6A6FF030203FF065658FF02FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF25B5B6FFFBDBDBFF28A7AAFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF07AFB0FF010000FF000000FF065B5DFF01FF
            FFFF00FFFFFF00FFFFFF04FEFFFF093031FF000000FF050000FF0BD7D7FF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF4DA2A3FFFFFFFF006A9D9DFF00F3
            F3FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF028687FF000000FF000000FF023C
            3CFF01FFFFFF00FFFFFF00FFFFFF0AF6F7FF091618FF000000FF010000FF03B9
            B9FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00DADDFF9AA7A9FFFFFFFF00D2C5
            C5FF07B6B6FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF07A1A0FF010000FF0000
            00FF074D4EFF02FFFFFF00FFFFFF00FFFFFF02FDFDFF022627FF000000FF0300
            00FF08CACAFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF22A2A4FFF0DDDEFFFFFF
            FF00FFFBFBFF669393FF00EFEFFF00FFFFFF00FFFFFF00FFFFFF08E6E7FF040B
            0CFF020000FF06A8A9FF00FFFFFF00FFFFFF00FFFFFF01FFFFFF0A7B7CFF0100
            00FF062F30FF03F9F9FF00FFFFFF00FFFFFF00FFFFFF00D8D9FF97A1A1FFFFFF
            FF00FFFFFF00FFFFFF00EBD9D9FF229595FF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00CACAFF02A9AAFF03FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF05F9
            F9FF04A4A4FF06DFE1FF00FFFFFF00FFFFFF00FFFFFF00F3F3FF478B8BFFFEEE
            EEFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00CABABAFF149797FF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7F8FF2B9797FFE7D3
            D3FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C5B6B6FF1E98
            9AFF00F2F3FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00E3E4FF3A8D8EFFE2D0
            D1FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00E1CECEFF528B8EFF00C1C3FF00FAFBFF00FFFFFF00FFFFFF00FFFFFF00FF
            FFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F3F3FF04B2B4FF6E9093FFF3E0
            E0FFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFF5F5FFB5B1B2FF509092FF15AFB2FF05DADAFF00F1
            F2FF04F9FAFF02F9F9FF00EFF0FF04D5D5FF1DAAAAFF5E9494FFC9BBBEFFFFFE
            FEFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFCFCFFD7AEB0FF7F79
            79FF335F5FFF104846FF154B4CFF3D6061FF8C7F7FFFE6BFBEFFFFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
          HeaderGlyphAlignmentHorz = taCenter
          HeaderHint = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090' '#1074#1099#1073#1086#1088
          Options.Editing = False
          Width = 40
          IsCaptionAssigned = True
        end
        object MaincolIsPromo: TcxGridDBColumn
          DataBinding.FieldName = 'isPromo'
          PropertiesClassName = 'TcxImageComboBoxProperties'
          Properties.Images = dmMain.ImageList
          Properties.Items = <
            item
              Value = False
            end
            item
              ImageIndex = 7
              Tag = 1
              Value = True
            end>
          HeaderGlyph.SourceDPI = 96
          HeaderGlyph.Data = {
            424DFA0900000000000036000000280000001900000019000000010020000000
            000000000000C40E0000C40E00000000000000000000FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00D1D1FFFFB2B2FFFFF5F5FFFFFFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FCFCFFFF8A8AFFFF1414FFFF6C6CFFFFDADAFFFFFFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00F1F1FFFF4D4DFFFF0000FFFF0303FFFF3030
            FFFFB9B9FFFFFDFDFFFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D4D4FFFF0E0EFFFF0000FFFF0000
            FFFF0000FFFF3D3DFFFFE1E1FFFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FEFEFFFF6565FFFF0000FFFF0000
            FFFF0000FFFF0000FFFF0404FFFF8F8FFFFFFFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00C2C2FFFF0B0BFFFF0000
            FFFF0000FFFF0000FFFF0000FFFF0000FFFF1A1AFFFFE0E0FFFFFFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F3F3FFFF3838FFFF0000
            FFFF0000FFFF0000FFFF2B2BFFFF0000FFFF0000FFFF0000FFFF5252FFFFFFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7F7FFFF8585FFFF0A0A
            FFFF0000FFFF0000FFFF1111FFFFE2E2FFFF5454FFFF0101FFFF0000FFFF0A0A
            FFFFAEAEFFFFFEFEFFFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FAFAFFFF9C9CFFFF1B1B
            FFFF0000FFFF0000FFFF0000FFFF5E5EFFFFFAFAFFFFC9C9FFFF2828FFFF0000
            FFFF0101FFFF4444FFFFE0E0FFFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00AFAFFFFF1414
            FFFF0000FFFF0000FFFF0000FFFF1818FFFFB8B8FFFFFEFEFFFFFAFAFFFF9090
            FFFF0C0CFFFF0000FFFF0707FFFF8B8BFFFFFBFBFFFFFFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FCFC
            FFFF6E6EFFFF0A0AFFFF0404FFFF0C0CFFFF7777FFFFF8F8FFFFFFFFFF00FFFF
            FF00F5F5FFFF4E4EFFFF0000FFFF0000FFFF1717FFFFDDDDFFFFFFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00F3F3FFFFAAAAFFFF7B7BFFFF9E9EFFFFF3F3FFFFFFFFFF00FFFF
            FF00FFFFFF00FFFFFF00DFDFFFFF2F2FFFFF0000FFFF0000FFFF4242FFFFEBEB
            FFFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00CACAFFFF2828FFFF0000FFFF0000
            FFFF7474FFFFF9F9FFFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FEFEFFFFAEAEFFFF1515
            FFFF0000FFFF1414FFFFA9A9FFFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FAFA
            FFFF8C8CFFFF0D0DFFFF0000FFFF3232FFFFCFCFFFFFFFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00F6F6FFFF8585FFFF0B0BFFFF0000FFFF4B4BFFFFEBEBFFFFFFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00F7F7FFFF8C8CFFFF0B0BFFFF0202FFFF5151
            FFFFF2F2FFFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F7F7FFFF8383FFFF0A0A
            FFFF0202FFFF6868FFFFF6F6FFFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F3F3
            FFFF8383FFFF1010FFFF0C0CFFFF7E7EFFFFF3F3FFFFFFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00F7F7FFFFA3A3FFFF2020FFFF0E0EFFFF7777FFFFF7F7FFFFFFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FDFDFFFFC0C0FFFF2929FFFF0606FFFF6363
            FFFFF4F4FFFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00D0D0FFFF3B3B
            FFFF0D0DFFFF5F5FFFFFE0E0FFFFFFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00E9E9FFFF8282FFFF2222FFFF4848FFFFFFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00F9F9FFFFBBBBFFFF7070FFFFFFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
            FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00}
          HeaderHint = #1052#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1082#1086#1085#1090#1088#1072#1082#1090
          Options.Editing = False
          Width = 30
          IsCaptionAssigned = True
        end
        object MainAmountIncome: TcxGridDBColumn
          Caption = #1058#1086#1074'.'#1074' '#1087#1091#1090#1080
          DataBinding.FieldName = 'AmountIncome'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderHint = #1058#1086#1074#1072#1088' '#1074' '#1087#1091#1090#1080
          Options.Editing = False
          Width = 50
        end
        object MainPriceSaleIncome: TcxGridDBColumn
          Caption = #1062#1077#1085#1072' ('#1074' '#1087#1091#1090#1080')'
          DataBinding.FieldName = 'PriceSaleIncome'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.00;-,0.00; ;'
          HeaderAlignmentHorz = taCenter
          HeaderHint = #1062#1077#1085#1072' ('#1090#1086#1074#1072#1088' '#1074' '#1087#1091#1090#1080')'
          Options.Editing = False
          Width = 55
        end
        object mainMinExpirationDate: TcxGridDBColumn
          Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085'. '#1086#1089#1090'.'
          DataBinding.FieldName = 'MinExpirationDate'
          HeaderAlignmentHorz = taCenter
          HeaderHint = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1086#1089#1090#1072#1090#1082#1072
          Options.Editing = False
          Width = 70
        end
        object MainNDS: TcxGridDBColumn
          Caption = #1053#1044#1057
          DataBinding.FieldName = 'NDS'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 30
        end
        object MainConditionsKeepName: TcxGridDBColumn
          Caption = #1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103
          DataBinding.FieldName = 'ConditionsKeepName'
          HeaderAlignmentHorz = taCenter
          HeaderHint = #1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103
          Options.Editing = False
          Width = 70
        end
        object MainColor_ExpirationDate: TcxGridDBColumn
          DataBinding.FieldName = 'Color_ExpirationDate'
          Visible = False
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          VisibleForCustomization = False
          Width = 30
        end
        object MainGoodsGroupName: TcxGridDBColumn
          Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
          DataBinding.FieldName = 'GoodsGroupName'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 150
        end
        object GoodsId_main: TcxGridDBColumn
          DataBinding.FieldName = 'GoodsId_main'
          Visible = False
          Options.Editing = False
          Width = 76
        end
        object MorionCode: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1052#1086#1088#1080#1086#1085#1072
          DataBinding.FieldName = 'MorionCode'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 73
        end
        object MainMCSValueOld: TcxGridDBColumn
          Caption = #1053#1058#1047' - '#1072#1074#1090#1086#1084'. '#1074#1077#1088#1085#1077#1090#1089#1103
          DataBinding.FieldName = 'MCSValueOld'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          HeaderHint = #1053#1058#1047' - '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1074#1077#1088#1085#1077#1090#1089#1103' '#1087#1086' '#1086#1082#1086#1085#1095#1072#1085#1080#1080' '#1087#1077#1088#1080#1086#1076#1072
          Options.Editing = False
          Width = 88
        end
        object MainisMCSNotRecalcOld: TcxGridDBColumn
          Caption = #1057#1087#1077#1094#1082'. - '#1072#1074#1090#1086#1084'. '#1074#1077#1088#1085#1077#1090#1089#1103
          DataBinding.FieldName = 'isMCSNotRecalcOld'
          HeaderAlignmentHorz = taCenter
          HeaderHint = #1057#1087#1077#1094#1082#1086#1085#1090#1088#1086#1083#1100' '#1082#1086#1076#1072' - '#1074#1077#1088#1085#1077#1090#1089#1103' '#1087#1086' '#1086#1082#1086#1085#1095#1072#1085#1080#1080' '#1087#1077#1088#1080#1086#1076#1072
          Options.Editing = False
          Width = 100
        end
        object MainStartDateMCSAuto: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' '#1053#1058#1047' '#1089
          DataBinding.FieldName = 'StartDateMCSAuto'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 70
        end
        object MainEndDateMCSAuto: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' '#1053#1058#1047' '#1087#1086
          DataBinding.FieldName = 'EndDateMCSAuto'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 70
        end
        object MainisMCSAuto: TcxGridDBColumn
          Caption = #1056#1077#1078#1080#1084' - '#1053#1058#1047' '#1085#1072' '#1087#1077#1088#1080#1086#1076
          DataBinding.FieldName = 'isMCSAuto'
          HeaderAlignmentHorz = taCenter
          HeaderHint = #1056#1077#1078#1080#1084' - '#1053#1058#1047' '#1091#1089#1090#1072#1085#1086#1074#1080#1083' '#1092#1072#1088#1084#1072#1094#1077#1074#1090' '#1085#1072' '#1087#1077#1088#1080#1086#1076
          Options.Editing = False
          Width = 100
        end
      end
      object MainGridLevel: TcxGridLevel
        GridView = MainGridDBTableView
      end
    end
    object SearchPanel: TPanel
      Left = 0
      Top = 216
      Width = 784
      Height = 33
      Align = alBottom
      TabOrder = 1
      object ShapeState: TShape
        Left = 751
        Top = 13
        Width = 10
        Height = 10
        Brush.Color = clGreen
        Pen.Color = clWhite
      end
      object ceAmount: TcxCurrencyEdit
        Left = 221
        Top = 7
        Properties.DecimalPlaces = 3
        Properties.DisplayFormat = ',0.###'
        TabOrder = 1
        OnExit = ceAmountExit
        OnKeyDown = ceAmountKeyDown
        Width = 44
      end
      object cxLabel1: TcxLabel
        Left = 185
        Top = 7
        Caption = #1050#1086#1083':'
        FocusControl = ceAmount
        ParentFont = False
        Style.BorderStyle = ebsNone
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -13
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.Shadow = False
        Style.IsFontAssigned = True
      end
      object lcName: TcxLookupComboBox
        Left = 7
        Top = 7
        Properties.DropDownListStyle = lsEditList
        Properties.KeyFieldNames = 'GoodsName'
        Properties.ListColumns = <
          item
            FieldName = 'GoodsName'
          end>
        Properties.ListOptions.AnsiSort = True
        Properties.ListOptions.CaseInsensitive = True
        Properties.ListOptions.ShowHeader = False
        Properties.ListOptions.SyncMode = True
        Properties.ListSource = RemainsDS
        TabOrder = 0
        OnEnter = lcNameEnter
        OnExit = lcNameExit
        OnKeyDown = lcNameKeyDown
        Width = 172
      end
      object cbSpec: TcxCheckBox
        Left = 398
        Top = 7
        Hint = #1055#1086' '#1075#1072#1083#1086#1095#1082#1077
        Action = actSpec
        Caption = #1063#1077#1082
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -12
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsStrikeOut]
        Style.Shadow = False
        Style.IsFontAssigned = True
        TabOrder = 3
      end
      object btnCheck: TcxButton
        Left = 454
        Top = 7
        Width = 35
        Height = 22
        Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1095#1077#1082#1086#1074
        Caption = #1063#1077#1082#1080
        LookAndFeel.Kind = lfStandard
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = btnCheckClick
      end
      object cxLabel2: TcxLabel
        Left = 279
        Top = 7
        Caption = #1050' '#1054#1087#1083#1072#1090#1077':'
        FocusControl = ceAmount
        ParentColor = False
        ParentFont = False
        Style.BorderStyle = ebsNone
        Style.Color = clBtnFace
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -13
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.Shadow = False
        Style.IsFontAssigned = True
      end
      object lblTotalSumm: TcxLabel
        Left = 350
        Top = 7
        Caption = '0.00'
        FocusControl = ceAmount
        ParentFont = False
        Style.BorderStyle = ebsNone
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -13
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.Shadow = False
        Style.IsFontAssigned = True
      end
      object btnVIP: TcxButton
        Left = 496
        Top = 7
        Width = 34
        Height = 22
        Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1086#1090#1083#1086#1078#1077#1085'. '#1095#1077#1082#1086#1074
        Action = actExecuteLoadVIP
        LookAndFeel.Kind = lfStandard
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblMoneyInCash: TcxLabel
        Left = 672
        Top = 7
        Caption = '0.00'
        FocusControl = ceAmount
        ParentFont = False
        Style.BorderStyle = ebsNone
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -13
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsBold]
        Style.Shadow = False
        Style.IsFontAssigned = True
      end
      object btnOpenMCSForm: TcxButton
        Left = 589
        Top = 7
        Width = 34
        Height = 22
        Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1053#1058#1047
        Action = actOpenMCS_LiteForm
        LookAndFeel.Kind = lfStandard
        ParentShowHint = False
        ShowHint = True
        TabOrder = 9
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object chbNotMCS: TcxCheckBox
        Left = 536
        Top = 7
        Hint = #1053#1077' '#1091#1095#1080#1090#1099#1074'. '#1095#1077#1082' '#1087#1088#1080' '#1087#1077#1088#1077#1089#1095#1077#1090#1077' '#1053#1058#1047
        Caption = #1053#1058#1047
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -12
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsStrikeOut]
        Style.IsFontAssigned = True
        TabOrder = 10
        OnClick = actSpecExecute
      end
      object cxButton1: TcxButton
        Left = 633
        Top = 7
        Width = 34
        Height = 22
        Hint = #1055#1086#1080#1089#1082' '#1090#1086#1074#1072#1088#1072' '#1087#1086' '#1089#1077#1090#1080
        Action = actChoiceGoodsFromRemains
        LookAndFeel.Kind = lfStandard
        ParentShowHint = False
        ShowHint = True
        TabOrder = 11
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
  end
  object pnlVIP: TPanel [3]
    Left = 0
    Top = 21
    Width = 784
    Height = 17
    Align = alTop
    Color = 15656679
    ParentBackground = False
    TabOrder = 3
    Visible = False
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 71
      Height = 15
      Align = alLeft
      Caption = '     '#1052#1077#1085#1077#1076#1078#1077#1088' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitHeight = 13
    end
    object lblCashMember: TLabel
      Left = 72
      Top = 1
      Width = 379
      Height = 15
      Align = alClient
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsItalic]
      ParentFont = False
      ExplicitWidth = 12
      ExplicitHeight = 13
    end
    object Label2: TLabel
      Left = 451
      Top = 1
      Width = 64
      Height = 15
      Align = alRight
      Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitHeight = 13
    end
    object lblBayer: TLabel
      Left = 515
      Top = 1
      Width = 268
      Height = 15
      Align = alRight
      AutoSize = False
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsItalic]
      ParentFont = False
      ExplicitLeft = 495
    end
  end
  object pnlDiscount: TPanel [4]
    Left = 0
    Top = 38
    Width = 784
    Height = 21
    Align = alTop
    Color = 15656679
    ParentBackground = False
    TabOrder = 4
    Visible = False
    object Label3: TLabel
      Left = 1
      Top = 1
      Width = 55
      Height = 19
      Align = alLeft
      Caption = '     '#1055#1088#1086#1077#1082#1090' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitHeight = 13
    end
    object lblDiscountExternalName: TLabel
      Left = 56
      Top = 1
      Width = 209
      Height = 19
      Align = alLeft
      AutoSize = False
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label5: TLabel
      Left = 265
      Top = 1
      Width = 114
      Height = 19
      Align = alLeft
      Caption = #8470' '#1076#1080#1089#1082#1086#1085#1090#1085#1086#1081' '#1082#1072#1088#1090#1099' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitHeight = 13
    end
    object lblDiscountCardNumber: TLabel
      Left = 379
      Top = 1
      Width = 110
      Height = 19
      Align = alLeft
      AutoSize = False
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblPrice: TLabel
      Left = 489
      Top = 1
      Width = 74
      Height = 19
      Align = alLeft
      Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitHeight = 13
    end
    object lblAmount: TLabel
      Left = 650
      Top = 2
      Width = 35
      Height = 13
      Caption = #1050#1086#1083'-'#1074#1086
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edPrice: TcxCurrencyEdit
      Left = 567
      Top = -1
      Properties.DisplayFormat = ',0.00;-,0.00'
      TabOrder = 0
      Width = 60
    end
    object edAmount: TcxCurrencyEdit
      Left = 691
      Top = -1
      Properties.DisplayFormat = ',0.000;-,0.000'
      TabOrder = 1
      Width = 38
    end
  end
  object Panel1: TPanel [5]
    Left = 0
    Top = 0
    Width = 784
    Height = 21
    Align = alTop
    TabOrder = 5
    object lbScaner: TLabel
      Left = 185
      Top = 2
      Width = 68
      Height = 13
      Caption = #1087#1086#1080#1089#1082' '#1087#1086' '#1064'/'#1050
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object ceScaner: TcxCurrencyEdit
      Left = 7
      Top = -1
      Properties.DisplayFormat = '0'
      Properties.MaxLength = 13
      TabOrder = 0
      OnKeyPress = ceScanerKeyPress
      Width = 172
    end
    object PanelMCSAuto: TPanel
      Left = 391
      Top = 1
      Width = 392
      Height = 19
      Align = alRight
      BevelOuter = bvNone
      Color = 15656679
      ParentBackground = False
      TabOrder = 1
      object Label6: TLabel
        Left = 0
        Top = 0
        Width = 137
        Height = 19
        Align = alLeft
        Caption = #1040#1074#1090#1086' '#1053#1058#1047' '#1085#1072' '#1082#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitHeight = 13
      end
      object edDays: TcxCurrencyEdit
        Left = 138
        Top = -2
        EditValue = 0.000000000000000000
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0;-,0'
        TabOrder = 0
        Width = 38
      end
    end
  end
  object pnlSP: TPanel [6]
    Left = 0
    Top = 59
    Width = 784
    Height = 18
    Align = alTop
    Color = 15656679
    ParentBackground = False
    TabOrder = 6
    Visible = False
    object Label4: TLabel
      Left = 1
      Top = 1
      Width = 63
      Height = 16
      Align = alLeft
      Caption = '     '#1052#1077#1076'.'#1091#1095'.: '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitHeight = 13
    end
    object lblPartnerMedicalName: TLabel
      Left = 64
      Top = 1
      Width = 331
      Height = 16
      Align = alClient
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitWidth = 12
      ExplicitHeight = 14
    end
    object Label7: TLabel
      Left = 395
      Top = 1
      Width = 26
      Height = 16
      Align = alRight
      Caption = #1060#1048#1054' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitHeight = 13
    end
    object lblMedicSP: TLabel
      Left = 421
      Top = 1
      Width = 362
      Height = 16
      Align = alRight
      AutoSize = False
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 503
    end
  end
  object pnlPromoCode: TPanel [7]
    Left = 0
    Top = 77
    Width = 784
    Height = 21
    Align = alTop
    Color = 15656679
    ParentBackground = False
    TabOrder = 7
    Visible = False
    object Label8: TLabel
      Left = 1
      Top = 1
      Width = 53
      Height = 19
      Align = alLeft
      Caption = '     '#1040#1082#1094#1080#1103': '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitHeight = 13
    end
    object lblPromoName: TLabel
      Left = 54
      Top = 1
      Width = 209
      Height = 19
      Align = alLeft
      AutoSize = False
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 56
    end
    object Label10: TLabel
      Left = 263
      Top = 1
      Width = 57
      Height = 19
      Align = alLeft
      Caption = #1055#1088#1086#1084#1086#1082#1086#1076': '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitHeight = 13
    end
    object lblPromoCode: TLabel
      Left = 320
      Top = 1
      Width = 110
      Height = 19
      Align = alLeft
      AutoSize = False
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitLeft = 379
    end
    object Label12: TLabel
      Left = 522
      Top = 2
      Width = 41
      Height = 13
      Align = alCustom
      Caption = #1057#1082#1080#1076#1082#1072' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edPromoCodeChangePrice: TcxCurrencyEdit
      Left = 567
      Top = -1
      Properties.DisplayFormat = ',0.00;-,0.00'
      TabOrder = 0
      Width = 60
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = AlternativeGrid
        Properties.Strings = (
          'Width')
      end
      item
        Component = BottomPanel
        Properties.Strings = (
          'Height')
      end
      item
        Component = CheckGrid
        Properties.Strings = (
          'Width')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
      item
        Component = MainGrid
        Properties.Strings = (
          'Height')
      end>
  end
  inherited ActionList: TActionList
    object actChoiceGoodsInRemainsGrid: TAction [0]
      Caption = 'actChoiceGoodsInRemainsGrid'
      OnExecute = actChoiceGoodsInRemainsGridExecute
    end
    object actOpenCheckVIP_Error: TOpenChoiceForm [1]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1063#1077#1082#1080' '#1089' '#1090#1086#1074#1072#1088#1072#1084#1080' "'#1085#1077#1090' '#1074' '#1085#1072#1083#1080#1095#1080#1080'"'
      FormName = 'TCheckVIP_ErrorForm'
      FormNameParam.Value = 'TCheckVIP_ErrorForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'CheckId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = FormParams
          ComponentItem = 'BayerName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CashMemberId'
          Value = Null
          Component = FormParams
          ComponentItem = 'ManagerId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CashMember'
          Value = Null
          Component = FormParams
          ComponentItem = 'ManagerName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscountExternalId'
          Value = Null
          Component = FormParams
          ComponentItem = 'DiscountExternalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscountExternalName'
          Value = Null
          Component = FormParams
          ComponentItem = 'DiscountExternalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscountCardNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'DiscountCardNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ConfirmedKindName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ConfirmedKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BayerPhone'
          Value = Null
          Component = FormParams
          ComponentItem = 'BayerPhone'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberOrder'
          Value = Null
          Component = FormParams
          ComponentItem = 'InvNumberOrder'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ConfirmedKindClientName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ConfirmedKindClientName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actRefreshAll: TAction [2]
      Category = 'DSDLib'
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      OnExecute = actRefreshAllExecute
    end
    object actSold: TAction [3]
      Caption = #1055#1088#1086#1076#1072#1078#1072
      ShortCut = 113
      OnExecute = actSoldExecute
    end
    object actCheck: TdsdOpenForm [4]
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1063#1077#1082#1080
      FormName = 'TCheckJournalForm'
      FormNameParam.Value = 'TCheckJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actInsertUpdateCheckItems: TAction [5]
      Caption = 'actInsertUpdateCheckItems'
      OnExecute = actInsertUpdateCheckItemsExecute
    end
    inherited actRefresh: TdsdDataSetRefresh
      Enabled = False
      StoredProc = spSelectRemains
      StoredProcList = <
        item
          StoredProc = spSelectRemains
        end
        item
          StoredProc = spSelect_Alternative
        end>
      ShortCut = 0
    end
    object actPutCheckToCash: TAction
      Caption = #1055#1086#1089#1083#1072#1090#1100' '#1095#1077#1082
      Hint = #1055#1086#1089#1083#1072#1090#1100' '#1095#1077#1082
      OnExecute = actPutCheckToCashExecute
    end
    object actSetVIP: TAction
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' VIP '#1095#1077#1082
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' VIP '#1095#1077#1082
      ShortCut = 117
      OnExecute = actSetVIPExecute
    end
    object actDeferrent: TAction
      Caption = #1055#1086#1089#1090#1072#1074#1080#1090#1100' '#1095#1077#1082' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1084
      Hint = #1055#1086#1089#1090#1072#1074#1080#1090#1100' '#1095#1077#1082' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1084
      ShortCut = 119
      Visible = False
    end
    object actChoiceGoodsFromRemains: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1058#1057
      FormName = 'TChoiceGoodsFromRemainsForm'
      FormNameParam.Value = 'TChoiceGoodsFromRemainsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = True
    end
    object actOpenCheckVIP: TOpenChoiceForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenCheckVIP'
      FormName = 'TCheckVIPForm'
      FormNameParam.Value = 'TCheckVIPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'CheckId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = FormParams
          ComponentItem = 'BayerName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CashMemberId'
          Value = Null
          Component = FormParams
          ComponentItem = 'ManagerId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CashMember'
          Value = Null
          Component = FormParams
          ComponentItem = 'ManagerName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscountExternalId'
          Value = Null
          Component = FormParams
          ComponentItem = 'DiscountExternalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscountExternalName'
          Value = Null
          Component = FormParams
          ComponentItem = 'DiscountExternalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DiscountCardNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'DiscountCardNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ConfirmedKindName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ConfirmedKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BayerPhone'
          Value = Null
          Component = FormParams
          ComponentItem = 'BayerPhone'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberOrder'
          Value = Null
          Component = FormParams
          ComponentItem = 'InvNumberOrder'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ConfirmedKindClientName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ConfirmedKindClientName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerMedicalId'
          Value = Null
          Component = FormParams
          ComponentItem = 'PartnerMedicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerMedicalName'
          Value = Null
          Component = FormParams
          ComponentItem = 'PartnerMedicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Ambulance'
          Value = Null
          Component = FormParams
          ComponentItem = 'Ambulance'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MedicSP'
          Value = Null
          Component = FormParams
          ComponentItem = 'MedicSP'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberSP'
          Value = Null
          Component = FormParams
          ComponentItem = 'InvNumberSP'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDateSP'
          Value = 'NULL'
          Component = FormParams
          ComponentItem = 'OperDateSP'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'SPTax'
          Value = Null
          Component = FormParams
          ComponentItem = 'SPTax'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'SPKindId'
          Value = Null
          Component = FormParams
          ComponentItem = 'SPKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'SPKindName'
          Value = Null
          Component = FormParams
          ComponentItem = 'SPKindName'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actLoadVIP: TMultiAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      ActionList = <
        item
          Action = actOpenCheckVIP
        end
        item
          Action = actSelectCheck
        end
        item
          Action = actSelectLocalVIPCheck
        end
        item
          Action = actRefreshLite
        end
        item
          Action = actUpdateRemains
        end
        item
          Action = actCalcTotalSumm
        end
        item
          Action = actSetFocus
        end>
      Caption = 'VIP'
    end
    object actUpdateRemains: TAction
      Category = 'DSDLib'
      Caption = 'actUpdateRemains'
      OnExecute = actUpdateRemainsExecute
    end
    object actCalcTotalSumm: TAction
      Category = 'DSDLib'
      Caption = 'actCalcTotalSumm'
      OnExecute = actCalcTotalSummExecute
    end
    object actCashWork: TAction
      Caption = #1056#1072#1073#1086#1090#1072' '#1089' '#1082#1072#1089#1089#1086#1081
      ShortCut = 16451
      OnExecute = actCashWorkExecute
    end
    object actClearAll: TAction
      Caption = #1057#1073#1088#1086#1089#1080#1090#1100' '#1074#1089#1077
      Hint = #1057#1073#1088#1086#1089#1080#1090#1100' '#1074#1089#1077
      ShortCut = 32776
      OnExecute = actClearAllExecute
    end
    object actClearMoney: TAction
      Caption = #1057#1073#1088#1086#1089#1080#1090#1100' '#1076#1077#1085#1100#1075#1080
      Hint = #1057#1073#1088#1086#1089#1080#1090#1100' '#1076#1077#1085#1100#1075#1080
      ShortCut = 16500
      OnExecute = actClearMoneyExecute
    end
    object actGetMoneyInCash: TAction
      Caption = #1044#1077#1085#1100#1075#1080' '#1074' '#1082#1072#1089#1089#1077
      Hint = #1044#1077#1085#1100#1075#1080' '#1074' '#1082#1072#1089#1089#1077
      ShortCut = 32884
      OnExecute = actGetMoneyInCashExecute
    end
    object actSpec: TAction
      AutoCheck = True
      Caption = #1058#1080#1093#1086' / '#1043#1088#1086#1084#1082#1086
      ShortCut = 16501
      OnExecute = actSpecExecute
    end
    object actRefreshLite: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect_CashRemains_Diff
      StoredProcList = <
        item
          StoredProc = spSelect_CashRemains_Diff
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1086#1089#1090#1072#1090#1086#1082
      Hint = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1086#1089#1090#1072#1090#1086#1082
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
    end
    object actOpenMCSForm: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1053#1058#1047
      Hint = #1056#1077#1077#1089#1090#1088' '#1085#1077#1089#1085#1080#1078#1072#1077#1084#1086#1075#1086' '#1090#1086#1074#1072#1088#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072
      FormName = 'TMCSForm'
      FormNameParam.Value = 'TMCSForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOpenMCS_LiteForm: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1053#1058#1047
      Hint = #1056#1077#1077#1089#1090#1088' '#1085#1077#1089#1085#1080#1078#1072#1077#1086#1075#1086' '#1090#1086#1074#1072#1088#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072
      FormName = 'TMCS_LiteForm'
      FormNameParam.Value = 'TMCS_LiteForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSetFocus: TAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      Caption = 'actSetFocus'
      OnExecute = actSetFocusExecute
    end
    object actRefreshRemains: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1086#1089#1090#1072#1090#1086#1082
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1086#1089#1090#1072#1090#1086#1082
      ShortCut = 115
      OnExecute = actRefreshRemainsExecute
    end
    object actExecuteLoadVIP: TAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      Caption = 'VIP'
      OnExecute = actExecuteLoadVIPExecute
    end
    object actSelectCheck: TdsdExecStoredProc
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectCheck
      StoredProcList = <
        item
          StoredProc = spSelectCheck
        end>
      Caption = 'actSelectCheck'
    end
    object actSelectLocalVIPCheck: TAction
      Caption = 'actSelectLocalVIPCheck'
      OnExecute = actSelectLocalVIPCheckExecute
    end
    object actCheckConnection: TAction
      Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100' '#1089#1074#1103#1079#1100' '#1089' '#1089#1077#1088#1074#1077#1088#1086#1084
      OnExecute = actCheckConnectionExecute
    end
    object actSetDiscountExternal: TAction
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1055#1088#1086#1077#1082#1090' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099')'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1055#1088#1086#1077#1082#1090' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099')'
      ShortCut = 118
      OnExecute = actSetDiscountExternalExecute
    end
    object actSetConfirmedKind_UnComplete: TAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072' - <'#1053#1077' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
      OnExecute = actSetConfirmedKind_UnCompleteExecute
    end
    object actSetConfirmedKind_Complete: TAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072' - <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
      OnExecute = actSetConfirmedKind_CompleteExecute
    end
    object actSetSP: TAction
      Caption = #1057#1082#1080#1076#1082#1072' '#1087#1086' '#1057#1055
      Hint = #1057#1082#1080#1076#1082#1072' '#1087#1086' '#1057#1055
      ShortCut = 114
      OnExecute = actSetSPExecute
    end
    object actOpenGoodsSP_UserForm: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1044#1086#1089#1090#1091#1087#1085#1099#1077' '#1083#1077#1082#1072#1088#1089#1090#1074#1072' - '#1057#1055
      FormName = 'TGoodsSP_ObjectForm'
      FormNameParam.Value = 'TGoodsSP_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGetJuridicalList: TAction
      Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
      OnExecute = actGetJuridicalListExecute
      OnUpdate = actGetJuridicalListUpdate
    end
    object actUpdateRemainsCDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Object_Price
      StoredProcList = <
        item
          StoredProc = spUpdate_Object_Price
        end>
      Caption = 'actUpdateRemainsCDS'
      DataSource = RemainsDS
    end
    object actSetFilter: TAction
      Caption = 'actSetFilter'
      OnExecute = actSetFilterExecute
    end
    object actSetPromoCode: TAction
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076
      OnExecute = actSetPromoCodeExecute
    end
  end
  object dsdDBViewAddOnMain: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = MainGridDBTableView
    OnDblClickActionList = <
      item
        Action = actChoiceGoodsInRemainsGrid
      end>
    ActionItemList = <
      item
        Action = actChoiceGoodsInRemainsGrid
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <
      item
        ColorColumn = MainColCode
        ValueColumn = MainColor_ExpirationDate
        BackGroundValueColumn = MainColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MainColMCSValue
        ValueColumn = MainColor_ExpirationDate
        BackGroundValueColumn = MainColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MainColName
        ValueColumn = MainColor_ExpirationDate
        BackGroundValueColumn = MainColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MainColPrice
        ValueColumn = MainColor_ExpirationDate
        BackGroundValueColumn = MainColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MainColReserved
        ValueColumn = MainColor_ExpirationDate
        BackGroundValueColumn = MainColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MaincolisFirst
        ValueColumn = MainColor_ExpirationDate
        BackGroundValueColumn = MainColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MaincolIsSecond
        ValueColumn = MainColor_ExpirationDate
        BackGroundValueColumn = MainColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MaincolIsPromo
        ValueColumn = MainColor_ExpirationDate
        BackGroundValueColumn = MainColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = mainMinExpirationDate
        ValueColumn = MainColor_ExpirationDate
        BackGroundValueColumn = MainColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MainConditionsKeepName
        ValueColumn = MainColor_ExpirationDate
        BackGroundValueColumn = MainColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MainPriceSaleIncome
        ValueColumn = MainColor_ExpirationDate
        BackGroundValueColumn = MainColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MainAmountIncome
        ValueColumn = MainColor_ExpirationDate
        BackGroundValueColumn = MainColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MainGoodsGroupName
        ValueColumn = MainColor_ExpirationDate
        BackGroundValueColumn = MainColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MainNDS
        ValueColumn = MainColor_ExpirationDate
        BackGroundValueColumn = MainColor_calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 640
    Top = 120
  end
  object spSelectRemains: TdsdStoredProc
    StoredProcName = 'gpSelect_CashRemains_ver2'
    DataSet = RemainsCDS
    DataSets = <
      item
        DataSet = RemainsCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CheckId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCashSessionId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CashSessionId'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    AutoWidth = True
    Left = 136
    Top = 16
  end
  object RemainsDS: TDataSource
    DataSet = RemainsCDS
    Left = 248
    Top = 32
  end
  object RemainsCDS: TClientDataSet
    Aggregates = <>
    Filter = 'Remains <> 0 or Reserved <> 0'
    Filtered = True
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'Id'
    Params = <>
    StoreDefs = True
    Left = 208
    Top = 32
  end
  object PopupMenu: TPopupMenu
    Left = 104
    Top = 264
    object N1: TMenuItem
      Action = actRefreshAll
    end
    object N4: TMenuItem
      Action = actClearAll
    end
    object N8: TMenuItem
      Action = actGetMoneyInCash
    end
    object N7: TMenuItem
      Action = actClearMoney
    end
    object N9: TMenuItem
      Action = actSpec
      AutoCheck = True
    end
    object N3: TMenuItem
      Action = actCashWork
    end
    object miMCSAuto: TMenuItem
      AutoCheck = True
      Caption = #1042#1082#1083'. / '#1042#1099#1082#1083'. '#1088#1077#1078#1080#1084' <'#1040#1074#1090#1086' '#1053#1058#1047'>'
      OnClick = miMCSAutoClick
    end
    object VIP1: TMenuItem
      Action = actSetVIP
    end
    object VIP3: TMenuItem
      Action = actSetConfirmedKind_Complete
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1083#1103' VIP '#1095#1077#1082' - <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
    end
    object VIP4: TMenuItem
      Action = actSetConfirmedKind_UnComplete
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1083#1103' VIP '#1095#1077#1082' - <'#1053#1077' '#1087#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085'>'
    end
    object miSetSP: TMenuItem
      Action = actSetSP
    end
    object N12: TMenuItem
      Caption = '-'
      Visible = False
    end
    object miSetDiscountExternal: TMenuItem
      Action = actSetDiscountExternal
    end
    object miGetJuridicalList: TMenuItem
      Action = actGetJuridicalList
    end
    object N5: TMenuItem
      Caption = '-'
      Visible = False
    end
    object actSold1: TMenuItem
      Action = actSold
      Visible = False
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object N10: TMenuItem
      Action = actRefreshRemains
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object miCheckConnection: TMenuItem
      Action = actCheckConnection
    end
    object N14: TMenuItem
      Caption = '-'
    end
    object N13: TMenuItem
      Action = actOpenMCSForm
    end
    object actOpenCheckVIPError1: TMenuItem
      Action = actOpenCheckVIP_Error
    end
    object miOpenGoodsSP_UserForm: TMenuItem
      Action = actOpenGoodsSP_UserForm
    end
    object miSetPromo: TMenuItem
      Action = actSetPromoCode
    end
    object miPrintNotFiscalCheck: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1085#1077#1092#1080#1089#1082#1072#1083#1100#1085#1086#1075#1086' '#1095#1077#1082#1072
      OnClick = miPrintNotFiscalCheckClick
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'CheckId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashSessionId'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ClosedCheckId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ManagerId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ManagerName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BayerName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountExternalId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountExternalName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscountCardNumber'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BayerPhone'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ConfirmedKindName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberOrder'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ConfirmedKindClientName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserSession'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerMedicalId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerMedicalName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Ambulance'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MedicSP'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberSP'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateSP'
        Value = 'NULL'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'SPTax'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SPKindId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'SPKindName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoCodeId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoCodeGUID'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoCodeChangePercent'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberSPID'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankPOSTerminal'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 56
    Top = 16
  end
  object spSelectCheck: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Check'
    DataSet = CheckCDS
    DataSets = <
      item
        DataSet = CheckCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CheckId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    AutoWidth = True
    Left = 176
    Top = 256
  end
  object CheckDS: TDataSource
    DataSet = CheckCDS
    Left = 240
    Top = 256
  end
  object CheckCDS: TClientDataSet
    Aggregates = <>
    Filter = 'Amount > 0'
    Filtered = True
    FieldDefs = <
      item
        Name = 'Id'
        DataType = ftInteger
      end
      item
        Name = 'ParentId'
        DataType = ftInteger
      end
      item
        Name = 'GoodsId'
        DataType = ftInteger
      end
      item
        Name = 'GoodsCode'
        DataType = ftInteger
      end
      item
        Name = 'GoodsName'
        DataType = ftString
        Size = 250
      end
      item
        Name = 'Amount'
        DataType = ftFloat
      end
      item
        Name = 'Price'
        DataType = ftFloat
      end
      item
        Name = 'Summ'
        DataType = ftFloat
      end
      item
        Name = 'NDS'
        DataType = ftFloat
      end
      item
        Name = 'PriceSale'
        DataType = ftFloat
      end
      item
        Name = 'ChangePercent'
        DataType = ftFloat
      end
      item
        Name = 'SummChangePercent'
        DataType = ftFloat
      end
      item
        Name = 'AmountOrder'
        DataType = ftFloat
      end
      item
        Name = 'isErased'
        DataType = ftBoolean
      end
      item
        Name = 'LIST_UID'
        DataType = ftString
        Size = 50
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    BeforePost = CheckCDSBeforePost
    Left = 208
    Top = 256
  end
  object dsdDBViewAddOnCheck: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = CheckGridDBTableView
    OnDblClickActionList = <
      item
        Action = actChoiceGoodsInRemainsGrid
      end>
    ActionItemList = <
      item
        Action = actChoiceGoodsInRemainsGrid
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 472
    Top = 336
  end
  object AlternativeCDS: TClientDataSet
    Aggregates = <>
    Filtered = True
    FieldDefs = <>
    IndexDefs = <
      item
        Name = 'AlternativeCDSIndexId'
        Fields = 'Id'
      end>
    Params = <>
    StoreDefs = True
    Left = 584
    Top = 264
  end
  object AlternativeDS: TDataSource
    DataSet = AlternativeCDS
    Left = 616
    Top = 264
  end
  object spSelect_Alternative: TdsdStoredProc
    StoredProcName = 'gpSelect_Cash_Goods_Alternative_ver2'
    DataSet = AlternativeCDS
    DataSets = <
      item
        DataSet = AlternativeCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CheckId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    AutoWidth = True
    Left = 552
    Top = 264
  end
  object dsdDBViewAddOnAlternative: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = AlternativeGridDBTableView
    OnDblClickActionList = <
      item
        Action = actChoiceGoodsInRemainsGrid
      end>
    ActionItemList = <
      item
        Action = actChoiceGoodsInRemainsGrid
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <
      item
        BackGroundValueColumn = AlternativeGridColTypeColor
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 592
    Top = 320
  end
  object spGetMoneyInCash: TdsdStoredProc
    StoredProcName = 'gpGet_Money_in_Cash'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outTotalSumm'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDate'
        Value = 'NULL'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 152
    Top = 120
  end
  object spGet_Password_MoneyInCash: TdsdStoredProc
    StoredProcName = 'gpGet_Password_MoneyInCash'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outPassword'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 224
    Top = 112
  end
  object spGet_User_IsAdmin: TdsdStoredProc
    StoredProcName = 'gpGet_User_IsAdmin'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'gpGet_User_IsAdmin'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 40
    Top = 328
  end
  object spDelete_CashSession: TdsdStoredProc
    StoredProcName = 'gpDelete_CashSession'
    DataSet = RemainsCDS
    DataSets = <
      item
        DataSet = RemainsCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inCashSessionId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CashSessionId'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    AutoWidth = True
    Left = 32
    Top = 120
  end
  object DiffCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'Id'
    Params = <>
    StoreDefs = True
    Left = 280
    Top = 96
  end
  object spSelect_CashRemains_Diff: TdsdStoredProc
    StoredProcName = 'gpSelect_CashRemains_Diff_ver2'
    DataSet = DiffCDS
    DataSets = <
      item
        DataSet = DiffCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CheckId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCashSesionId'
        Value = Null
        Component = FormParams
        ComponentItem = 'CashSessionId'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    AutoWidth = True
    Left = 184
    Top = 88
  end
  object TimerSaveAll: TTimer
    Enabled = False
    Interval = 360000
    OnTimer = TimerSaveAllTimer
    Left = 100
    Top = 8
  end
  object TimerMoneyInCash: TTimer
    Enabled = False
    Interval = 25000
    OnTimer = TimerMoneyInCashTimer
    Left = 360
    Top = 104
  end
  object spUpdate_UnitForFarmacyCash: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_UnitForFarmacyCash'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inAmount'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 424
    Top = 120
  end
  object TimerBlinkBtn: TTimer
    Enabled = False
    OnTimer = TimerBlinkBtnTimer
    Left = 320
    Top = 96
  end
  object spGet_BlinkVIP: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Check_ConfirmedKind'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outMovementId_list'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 360
    Top = 136
  end
  object spUpdate_ConfirmedKind: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_ConfirmedKind'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ouConfirmedKindName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 448
    Top = 128
  end
  object spGet_BlinkCheck: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Check_CommentError'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outMovementId_list'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 312
    Top = 168
  end
  object spCheck_RemainsError: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Check_RemainsError'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsId_list'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount_list'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 408
    Top = 248
  end
  object spGet_JuridicalList: TdsdStoredProc
    StoredProcName = 'zfGet_JuridicalList'
    DataSets = <>
    OutputType = otBlob
    Params = <
      item
        Name = 'inGoodsId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 192
    Top = 324
  end
  object spUpdate_Object_Price: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Price_MCSAuto'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMCSValue'
        Value = Null
        Component = RemainsCDS
        ComponentItem = 'MCSValue'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = RemainsCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDays'
        Value = Null
        Component = edDays
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMCSValueOld'
        Value = Null
        Component = RemainsCDS
        ComponentItem = 'MCSValueOld'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStartDateMCSAuto'
        Value = 'NULL'
        Component = RemainsCDS
        ComponentItem = 'StartDateMCSAuto'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEndDateMCSAuto'
        Value = 'NULL'
        Component = RemainsCDS
        ComponentItem = 'EndDateMCSAuto'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsMCSNotRecalcOld'
        Value = Null
        Component = RemainsCDS
        ComponentItem = 'IsMCSNotRecalcOld'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsMCSAuto'
        Value = Null
        Component = RemainsCDS
        ComponentItem = 'IsMCSAuto'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 32
  end
end
