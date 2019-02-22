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
          HeaderGlyph.Data = {
            A2070000424DA207000000000000360000002800000019000000190000000100
            1800000000006C070000C40E0000C40E00000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBF1F1696F6F059B9B03EAEA01F9F901FB
            FB01FBFB01F9F903E7E7059393727575FDF3F3FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF65696904CFCF00FA
            FA00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FAFA04C6C676
            7474FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7E5
            E51E878700F8F800FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00F8F8277D7DFFF4F4FFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFCE9E90E9C9C00FFFF00FFFF00FFFF00FFFF00EEEE00606000
            2525001414001414002727006A6A00F3F300FFFF00FFFF00FFFF00FFFF179191
            FFF7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1D8E8E00FFFF00FFFF00FFFF00
            E9E9002B2B004B4B00C0C000F0F000FFFF00FFFF00EDED00BBBB004444003737
            00EFEF00FFFF00FFFF00FFFF298383FFFFFFFFFFFFFFFFFFFFFFFFFF61707000
            F9F900FFFF00FFFF00C9C900181800DCDC00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00D2D2001B1B00D6D600FFFF00FFFF00F4F4797979FFFF
            FFFFFFFFFFFEF3F304D1D100FFFF00FFFF00DEDE001A1A00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00F6F6001A1A00E9
            EA00FFFF00FFFF07C5C5FFFDFDFFFFFFFF606D6D00FCFC00FFFF00FFFF001C1C
            00F1F100FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00E3E300232300FFFF00FFFF00F9F9807C7CFFFFFFFF0A9B9B
            00FFFF00FFFF00B0B000858500FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF006D6D00CECE00FFFF00
            FFFF0A8787FFFEFBFB02EEEE00FFFF00FFFF00323200E2E200FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00D6D600393900FFFF00FFFF04DDDDFFDCB7B700F8F800FFFF00FBFB0014
            1400FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF001A1A00FCFC00FFFF02F9F9FF8261
            6100FAFA00FFFF006C6C00030300787800FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF005757000202
            00727200FFFF01FAFAFF82626200FAFA00FFFF00FFFF00FEFE00FEFE00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FEFE00FFFF00FFFF01FAFAFFD7B2B200F8F800FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00272700A8A800FFFF00FFFF00FFFF
            00FFFF00EBEB00000000F2F200FFFF00FFFF00FFFF00FFFF00FFFF00FFFF02F9
            F9FFFEFBFB02EDED00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00CACA000000
            00171700FFFF00FFFF00FFFF00FFFF003E3E00000000969600FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF04DFDFFFFFFFFF0A9D9D00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00949400000000070700FFFF00FFFF00FFFF00FFFF0019190000
            0000545500FFFF00FFFF00FFFF00FFFF00FFFF00FFFF0A8B8DFFFFFFFF5D6F6F
            00FCFC00FFFF00FFFF00FFFF00FFFF00FFFF00838300000000030300FFFF00FF
            FF00FFFF00FFFF00121200000000272800FFFF00FFFF00FFFF00FFFF00FFFF00
            FAFA808080FFFFFFFFFDF1F104D7D700FFFF00FFFF00FFFF00FFFF00FFFF0089
            8900000000030300FFFF00FFFF00FFFF00FFFF00151500000000383800FFFF00
            FFFF00FFFF00FFFF00FFFF08C9C9FFFBFBFFFFFFFFFFFFFF5C6E6E00F9F900FF
            FF00FFFF00FFFF00FFFF00ACAC000000000D0D00FFFF00FFFF00FFFF00FFFF00
            1E1E000000006A6A00FFFF00FFFF00FFFF00FFFF00F5F5787878FFFFFFFFFFFF
            FFFFFFFFFFFFFF1A8B8B00FFFF00FFFF00FFFF00FFFF00E7E700000000323200
            FFFF00FFFF00FFFF00FFFF00818100000000C0C000FFFF00FFFF00FFFF00FFFF
            267E7EFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAE8E80C999900FFFF00FFFF00
            FFFF00FFFF00C5C500FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00A1A100FFFF
            00FFFF00FFFF00FFFF139191FFF6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFF8E4E41B898900F9F900FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00F8F8278282FFF0F0FFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF606C6C04D3D300FBFB00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FAFA04CCCC6F7272FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFF8EDED647070079E9E03EAEA00F7F700F9F900F9F900F7F702E8E80799
            996F7373FBF0F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFBDDBBBB8E6B
            6B967373E1BEBEFFFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF}
          HeaderGlyphAlignmentHorz = taCenter
          HeaderHint = #1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1074#1099#1073#1086#1088
          Options.Editing = False
          Width = 40
          IsCaptionAssigned = True
        end
        object MaincolIsSecond: TcxGridDBColumn
          DataBinding.FieldName = 'isSecond'
          HeaderGlyph.Data = {
            A2070000424DA207000000000000360000002800000019000000190000000100
            1800000000006C070000C40E0000C40E00000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFECD8D898A0A347989923B5B717CACB09D7
            DA08D6DA17C7C822B1B156999AA7AAABFCE6E6FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3F298A0A21D9A9A00D3
            D400FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FBFB00CACB339496AD
            A9ACFFFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1DE
            DE538F8F00CDCE00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00BBBD778E8FFEEEEFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFF1DEDE42919300EBEC00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00D6D8608788
            FEF0F0FFFFFFFFFFFFFFFFFFFFFFFFFFFFF1F1588C8C00EDED00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00DADB7C9395FFFDFDFFFFFFFFFFFFFFFFFFFF949C9E00
            D5D500FFFF04E8E701A8AB01FCFC00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00F0F001A9AD06F7F700FFFF05B7B9C0B3B4FFFF
            FFFFFFFFFFE9D7D715A0A100FFFF05F1F106242407262801FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF04F5F50705060C42
            4403FEFF00FFFF388F90FBECECFFFFFFFF8DA2A100E4E400FFFF088A8B0A0000
            091315029B9D04FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
            FF03F4F50977780A0A0B0800000DB9BB00FFFF00C7C7BAB3B4FFFFECEC369D9F
            00FFFF00FFFF069D9F0E797B11979709040505232300898908CDCE03F1F10CFB
            FC0CFAFB03ECEE06C3C40572720411120618180BB6B807696D08C1C100FFFF00
            F8F9619C9FFFD4ADAE0FBCBE00FFFF00FFFF00FFFF00FFFF00FFFF09E0E00675
            75061C1C070305040B0D0E15170E131505080A08040506282B068B8D05F4F400
            FFFF00FFFF00FFFF00FFFF00FFFF2EAAACFF90827E02D7D600FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF00FFFF04FFFF04DADB03B4B500A2A200A3A303B8B909
            E0E003FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF1BC1C2FF6A6D
            7603E2E600FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF16CDCDFF6C6A7607E3E700FFFF00FFFF00FFFF00FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF08D2D2FF837A7903DBDB00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF02F0F103DDDE01FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF05D7D805F9F900FFFF00FFFF00FFFF00FFFF00FFFF00FFFF14C8
            CBFFBD9D9D0CC4C500FFFF00FFFF00FFFF00FFFF00FFFF05F5F5073132030808
            04C9C900FFFF00FFFF00FFFF01FFFF05A6A603020306565802FFFF00FFFF00FF
            FF00FFFF00FFFF00FFFF25B5B6FFFBDBDB28A7AA00FFFF00FFFF00FFFF00FFFF
            00FFFF07AFB0010000000000065B5D01FFFF00FFFF00FFFF04FEFF0930310000
            000500000BD7D700FFFF00FFFF00FFFF00FFFF00FFFF4DA2A3FFFFFFFF6A9D9D
            00F3F300FFFF00FFFF00FFFF00FFFF028687000000000000023C3C01FFFF00FF
            FF00FFFF0AF6F709161800000001000003B9B900FFFF00FFFF00FFFF00FFFF00
            DADD9AA7A9FFFFFFFFD2C5C507B6B600FFFF00FFFF00FFFF00FFFF07A1A00100
            00000000074D4E02FFFF00FFFF00FFFF02FDFD02262700000003000008CACA00
            FFFF00FFFF00FFFF00FFFF22A2A4F0DDDEFFFFFFFFFFFBFB66939300EFEF00FF
            FF00FFFF00FFFF08E6E7040B0C02000006A8A900FFFF00FFFF00FFFF01FFFF0A
            7B7C010000062F3003F9F900FFFF00FFFF00FFFF00D8D997A1A1FFFFFFFFFFFF
            FFFFFFFFEBD9D922959500FFFF00FFFF00FFFF00FFFF00CACA02A9AA03FFFF00
            FFFF00FFFF00FFFF00FFFF05F9F904A4A406DFE100FFFF00FFFF00FFFF00F3F3
            478B8BFEEEEEFFFFFFFFFFFFFFFFFFFFFFFFFFCABABA14979700FFFF00FFFF00
            FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00F7F82B9797E7D3D3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFC5B6B61E989A00F2F300FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00E3E43A8D8EE2D0D1FFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE1CECE528B8E00C1C300FAFB00FFFF
            00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00F3F304B2B46E9093F3E0
            E0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFF5F5B5B1B250909215AFB205DADA00F1F204F9FA02F9F900EFF004D5D51DAA
            AA5E9494C9BBBEFFFEFEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCD7AEB07F7979335F5F1048
            46154B4C3D60618C7F7FE6BFBEFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF}
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
          HeaderGlyph.Data = {
            A2070000424DA207000000000000360000002800000019000000190000000100
            1800000000006C070000C40E0000C40E00000000000000000000FFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFD1D1FFB2B2FFF5F5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFF8A8AFF1414FF6C6CFFDADA
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1F1
            FF4D4DFF0000FF0303FF3030FFB9B9FFFDFDFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFD4D4FF0E0EFF0000FF0000FF0000FF3D3DFFE1E1FFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFF6565FF0000FF0000FF00
            00FF0000FF0404FF8F8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC2
            C2FF0B0BFF0000FF0000FF0000FF0000FF0000FF1A1AFFE0E0FFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFF3F3FF3838FF0000FF0000FF0000FF2B2BFF0000FF0000FF
            0000FF5252FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7FF8585FF0A0AFF0000FF0000FF
            1111FFE2E2FF5454FF0101FF0000FF0A0AFFAEAEFFFEFEFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFAFAFF9C9CFF
            1B1BFF0000FF0000FF0000FF5E5EFFFAFAFFC9C9FF2828FF0000FF0101FF4444
            FFE0E0FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFAFAFFF1414FF0000FF0000FF0000FF1818FFB8B8FFFEFEFFFAFA
            FF9090FF0C0CFF0000FF0707FF8B8BFFFBFBFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFCFF6E6EFF0A0AFF0404FF0C0C
            FF7777FFF8F8FFFFFFFFFFFFFFF5F5FF4E4EFF0000FF0000FF1717FFDDDDFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFF3F3FFAAAAFF7B7BFF9E9EFFF3F3FFFFFFFFFFFFFFFFFFFFFFFFFFDFDFFF2F
            2FFF0000FF0000FF4242FFEBEBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFCACAFF2828FF0000FF0000FF7474FFF9F9FFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFEFFAEAEFF1515FF
            0000FF1414FFA9A9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFAFAFF8C8CFF0D0DFF0000FF3232FFCFCFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6F6FF8585FF0B0BFF0000
            FF4B4BFFEBEBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFF7F7FF8C8CFF0B0BFF0202FF5151FFF2F2FFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7FF8383FF0A0AFF0202FF68
            68FFF6F6FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFF3F3FF8383FF1010FF0C0CFF7E7EFFF3F3FFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7F7FFA3A3FF2020FF0E0EFF7777FF
            F7F7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FDFDFFC0C0FF2929FF0606FF6363FFF4F4FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD0D0FF3B3BFF0D0DFF5F5FFFE0E0
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFE9E9FF8282FF2222FF4848FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF9F9FFBBBBFF7070FFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
            FFFFFFFFFFFF}
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
        Width = 50
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
        Width = 47
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
