inherited MainCashForm2: TMainCashForm2
  ActiveControl = lcName
  Caption = #1055#1088#1086#1076#1072#1078#1072
  ClientHeight = 646
  ClientWidth = 964
  PopupMenu = PopupMenu
  OnCloseQuery = ParentFormCloseQuery
  OnCreate = FormCreate
  OnDestroy = ParentFormDestroy
  OnKeyDown = ParentFormKeyDown
  OnShow = ParentFormShow
  AddOnFormData.Params = FormParams
  AddOnFormData.AddOnFormRefresh.SelfList = 'MainCheck'
  ExplicitWidth = 980
  ExplicitHeight = 685
  PixelsPerInch = 96
  TextHeight = 13
  object BottomPanel: TPanel [0]
    Left = 0
    Top = 493
    Width = 964
    Height = 153
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object CheckGrid: TcxGrid
      Left = 0
      Top = 0
      Width = 502
      Height = 153
      Align = alClient
      TabOrder = 0
      object CheckGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        OnFocusedRecordChanged = CheckGridDBTableViewFocusedRecordChanged
        DataController.DataSource = CheckDS
        DataController.KeyFieldNames = 'GoodsId;PartionDateKindId;NDSKindId;DivisionPartiesID;isPresent'
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
        OptionsSelection.HideSelection = True
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
          Styles.OnGetContentStyle = CheckGridColNameStylesGetContentStyle
          Width = 150
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
          Styles.OnGetContentStyle = CheckGridColNameStylesGetContentStyle
          Width = 45
        end
        object CheckGridColSummChangePercent: TcxGridDBColumn
          Caption = #1089#1091#1084#1084#1072' '#1089#1082'.'
          DataBinding.FieldName = 'SummChangePercent'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          Styles.OnGetContentStyle = CheckGridColNameStylesGetContentStyle
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
        object CheckGridColor_calc: TcxGridDBColumn
          DataBinding.FieldName = 'Color_calc'
          Visible = False
        end
        object CheckGridColor_ExpirationDate: TcxGridDBColumn
          DataBinding.FieldName = 'Color_ExpirationDate'
          Visible = False
        end
        object CheckGridAccommodationName: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1087#1088#1080#1074'.'
          DataBinding.FieldName = 'AccommodationName'
          HeaderAlignmentHorz = taCenter
          Width = 57
        end
        object CheckGridPartionDateKindName: TcxGridDBColumn
          Caption = #1058#1080#1087' '#1089#1088#1086#1082'/'#1085#1077' '#1089#1088#1086#1082
          DataBinding.FieldName = 'PartionDateKindName'
          HeaderAlignmentHorz = taCenter
          Width = 62
        end
        object CheckGridNDS: TcxGridDBColumn
          Caption = #1053#1044#1057
          DataBinding.FieldName = 'NDS'
          HeaderAlignmentHorz = taCenter
          Width = 46
        end
        object CheckDivisionPartiesName: TcxGridDBColumn
          Caption = #1056#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1087#1072#1088#1090#1080#1081
          DataBinding.FieldName = 'DivisionPartiesName'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
        end
        object CheckFixEndDate: TcxGridDBColumn
          AlternateCaption = 'dmMain.cxemainsCashContentStyle'
          Caption = #1044#1072#1090#1072' '#1076#1077#1081#1089#1090#1074#1080#1103' '#1089#1082#1080#1076#1082#1080
          DataBinding.FieldName = 'FixEndDate'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Styles.OnGetContentStyle = CheckGridColNameStylesGetContentStyle
          Width = 98
        end
      end
      object CheckGridLevel: TcxGridLevel
        GridView = CheckGridDBTableView
      end
    end
    object AlternativeGrid: TcxGrid
      Left = 713
      Top = 0
      Width = 251
      Height = 153
      Align = alRight
      TabOrder = 1
      Visible = False
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
      Left = 502
      Top = 0
      Width = 0
      Height = 153
      AlignSplitter = salRight
      Control = ExpirationDateGrid
    end
    object ExpirationDateGrid: TcxGrid
      Left = 502
      Top = 0
      Width = 211
      Height = 153
      Align = alRight
      TabOrder = 3
      object ExpirationDateView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = ExpirationDateDS
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
        object ExpirationDateExpirationDate: TcxGridDBColumn
          Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
          DataBinding.FieldName = 'ExpirationDate'
          Width = 122
        end
        object ExpirationDateAmount: TcxGridDBColumn
          Caption = #1054#1089#1090'.'
          DataBinding.FieldName = 'Amount'
          Width = 33
        end
        object ExpirationDateColor_calc: TcxGridDBColumn
          DataBinding.FieldName = 'Color_calc'
          Visible = False
        end
      end
      object ExpirationDateLevel: TcxGridLevel
        Caption = #1040#1083#1100#1090' (24 '#1087#1086#1079') "*"'
        GridView = ExpirationDateView
      end
    end
  end
  object cxSplitter2: TcxSplitter [1]
    Left = 0
    Top = 490
    Width = 964
    Height = 3
    AlignSplitter = salBottom
    Control = BottomPanel
  end
  object MainPanel: TPanel [2]
    Left = 0
    Top = 349
    Width = 964
    Height = 141
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object MainGrid: TcxGrid
      Left = 0
      Top = 21
      Width = 964
      Height = 87
      Align = alClient
      TabOrder = 0
      object MainGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        OnCanFocusRecord = MainGridDBTableViewCanFocusRecord
        OnFocusedRecordChanged = MainGridDBTableViewFocusedRecordChanged
        OnSelectionChanged = MainGridDBTableViewSelectionChanged
        DataController.DataSource = RemainsDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.KeyFieldNames = 'Id;PartionDateKindId;NDSKindId;DivisionPartiesID;isPresent'
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsBehavior.IncSearch = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Inserting = False
        OptionsSelection.HideSelection = True
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
        object Color_IPE: TcxGridDBColumn
          Caption = #1055#1083#1072#1085
          DataBinding.FieldName = 'Color_IPE'
          PropertiesClassName = 'TcxImageComboBoxProperties'
          Properties.Alignment.Horz = taLeftJustify
          Properties.Images = dmMain.ImageList
          Properties.Items = <
            item
              Value = 0
            end
            item
              Description = #1042#1089#1077#1075#1086' '#1087#1088#1086#1076#1072#1085#1086' < '#1079#1085#1072#1095#1077#1085#1080#1077' min '#1087#1083#1072#1085' '
              ImageIndex = 7
              Value = 1
            end
            item
              Description = #1042#1089#1077#1075#1086' '#1087#1088#1086#1076#1072#1085#1086' >= min '#1087#1083#1072#1085' '#1085#1086' < '#1087#1083#1072#1085' '#1076#1083#1103' '#1087#1088#1077#1084#1080#1080' '
              ImageIndex = 79
              Value = 2
            end
            item
              Description = #1042#1089#1077#1075#1086' '#1087#1088#1086#1076#1072#1085#1086' > min '#1087#1083#1072#1085' '#1080' >= '#1087#1083#1072#1085' '#1076#1083#1103' '#1087#1088#1077#1084#1080#1080' '
              ImageIndex = 80
              Value = 3
            end>
          Properties.ReadOnly = True
          Properties.ShowDescriptions = False
          OnGetCellHint = Color_IPEGetCellHint
          HeaderAlignmentHorz = taCenter
          HeaderHint = #1062#1074#1077#1090#1085#1099#1077' '#1075#1072#1083#1086#1095#1082#1080' '#1087#1086' '#1087#1083#1072#1085#1091' '#1087#1088#1086#1076#1072#1078
          Options.Editing = False
          Width = 47
        end
        object MainColName: TcxGridDBColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'GoodsName'
          OnCustomDrawCell = MainColNameCustomDrawCell
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 200
        end
        object MainColCode: TcxGridDBColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'GoodsCode'
          OnCustomDrawCell = MainColCodeCustomDrawCell
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
          Styles.Content = dmMain.cxRemainsCashContentStyle
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
        object MainColPriceNight: TcxGridDBColumn
          Caption = #1053#1086#1095#1085#1072#1103' '#1094#1077#1085#1072
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.Alignment.Horz = taRightJustify
          OnGetDisplayText = MainColPriceNightGetDisplayText
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 53
        end
        object MainColPriceSP: TcxGridDBColumn
          Caption = #1044#1086#1087#1083#1072#1090#1072' '#1087#1072#1094#1080#1077#1085#1090#1086#1084' '#1057#1055
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
        object MainGridPriceChange: TcxGridDBColumn
          Caption = #1062#1077#1085#1072' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
          DataBinding.FieldName = 'PriceChange'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.00'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 55
        end
        object MainGridPriceChangeNight: TcxGridDBColumn
          Caption = #1053#1086#1095#1085#1072#1103' '#1094#1077#1085#1072' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
          PropertiesClassName = 'TcxTextEditProperties'
          Properties.Alignment.Horz = taRightJustify
          OnGetDisplayText = MainGridPriceChangeNightGetDisplayText
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
        end
        object MainFixPercent: TcxGridDBColumn
          Caption = #1055#1088#1086#1094'. '#1089#1082#1080#1076#1082#1080
          DataBinding.FieldName = 'FixPercent'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = '0.## %'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Styles.OnGetContentStyle = MainFixPercentStylesGetContentStyle
          Width = 57
        end
        object MainFixDiscount: TcxGridDBColumn
          Caption = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080
          DataBinding.FieldName = 'FixDiscount'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DisplayFormat = ',0.00'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Styles.OnGetContentStyle = MainFixPercentStylesGetContentStyle
          Width = 57
        end
        object MainMultiplicity: TcxGridDBColumn
          Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1086#1090#1087'. '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
          DataBinding.FieldName = 'Multiplicity'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 68
        end
        object MainFixEndDate: TcxGridDBColumn
          Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1076#1077#1081#1089#1090#1074#1080#1103' '#1089#1082#1080#1076#1082#1080
          DataBinding.FieldName = 'FixEndDate'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Styles.OnGetContentStyle = MainFixPercentStylesGetContentStyle
          Width = 89
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
          Caption = #1054#1087#1083#1072#1090#1072' '#1075#1086#1089'-'#1074#1086#1084' '#1087#1086' '#1057#1055
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
        object MainMakerName: TcxGridDBColumn
          Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
          DataBinding.FieldName = 'MakerName'
          GroupSummaryAlignment = taCenter
          HeaderAlignmentHorz = taCenter
          HeaderHint = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
          Options.Editing = False
          Width = 110
        end
        object MainAmountIncome: TcxGridDBColumn
          Caption = #1058#1086#1074#1072#1088' ('#1086#1090' '#1087#1086#1089#1090'.) '#1074' '#1087#1091#1090#1080
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
        object MainisGoodsId_main: TcxGridDBColumn
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
        object MainisAccommodationName: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1087#1088#1080#1074'.'
          DataBinding.FieldName = 'AccommodationName'
          PropertiesClassName = 'TcxButtonEditProperties'
          Properties.Buttons = <
            item
              Caption = 'actOpenAccommodation'
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Properties.OnButtonClick = AccommodationNamePropertiesButtonClick
          HeaderAlignmentHorz = taCenter
          Width = 46
        end
        object MainisGoodsAnalog: TcxGridDBColumn
          Caption = #1040#1085#1072#1083#1086#1075#1080' '#1087#1086' '#1076#1077#1081#1089#1090#1074#1091#1102#1097#1077#1084#1091' '#1074#1077#1097#1077#1089#1090#1074#1091
          DataBinding.FieldName = 'GoodsAnalog'
          OnGetProperties = MainisGoodsAnalogGetProperties
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 88
        end
        object MainGoodsAnalogATC: TcxGridDBColumn
          Caption = #1050#1086#1076' '#1040#1058#1057
          DataBinding.FieldName = 'GoodsAnalogATC'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 88
        end
        object MainGoodsActiveSubstance: TcxGridDBColumn
          Caption = #1044#1077#1081#1089#1090#1074#1091#1102#1097#1077#1077' '#1074#1077#1097#1077#1089#1090#1074#1086
          DataBinding.FieldName = 'GoodsActiveSubstance'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 91
        end
        object MainisPartionDateKindName: TcxGridDBColumn
          Caption = #1058#1080#1087' '#1089#1088#1086#1082'/'#1085#1077' '#1089#1088#1086#1082
          DataBinding.FieldName = 'PartionDateKindName'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 56
        end
        object MainPricePartionDate: TcxGridDBColumn
          Caption = #1062#1077#1085#1072' '#1089#1088#1086#1082#1086#1074#1086#1075#1086' '#1087#1088#1077#1087#1072#1088#1072#1090#1072
          DataBinding.FieldName = 'PricePartionDate'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.####'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 70
        end
        object MainNotSold: TcxGridDBColumn
          Caption = #1053#1077' '#1087#1088#1086#1076#1072#1074#1072#1083#1089#1103' 100 '#1076#1085#1077#1081
          DataBinding.FieldName = 'NotSold'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 78
        end
        object MainDeferredSend: TcxGridDBColumn
          Caption = #1054#1090#1083#1086#1078#1077#1085#1086' '#1074' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103#1093
          DataBinding.FieldName = 'DeferredSend'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 3
          Properties.DisplayFormat = ',0.###'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 70
        end
        object MainRemainsSun: TcxGridDBColumn
          Caption = #1055#1088#1080#1096#1083#1086' '#1087#1086' '#1057#1059#1053
          DataBinding.FieldName = 'RemainsSun'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 3
          Properties.DisplayFormat = ',0.###'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 81
        end
        object MainNotTransferTime: TcxGridDBColumn
          Caption = #1053#1077' '#1087#1077#1088#1077#1074#1086#1076#1080#1090#1100' '#1074' '#1089#1088#1086#1082#1080
          DataBinding.FieldName = 'NotTransferTime'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 93
        end
        object MainNotSold60: TcxGridDBColumn
          Caption = #1058#1077#1082#1091#1097#1080#1077' '#1053#1077#1083#1080#1082#1074#1080#1076#1099' ('#1073#1077#1079' '#1087#1088#1086#1076#1072#1078') '
          DataBinding.FieldName = 'NotSold60'
          HeaderAlignmentHorz = taCenter
          Width = 100
        end
        object MainGoodsDiscountName: TcxGridDBColumn
          Caption = #1044#1083#1103' '#1076#1080#1089#1082#1086#1085#1090#1085#1086#1081' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
          DataBinding.FieldName = 'GoodsDiscountName'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 99
        end
        object MainUKTZED: TcxGridDBColumn
          Caption = #1050#1086#1076'  '#1059#1050#1058#1047#1045#1044
          DataBinding.FieldName = 'UKTZED'
          Options.Editing = False
          Width = 80
        end
        object MainDivisionPartiesName: TcxGridDBColumn
          Caption = #1056#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1087#1072#1088#1090#1080#1081
          DataBinding.FieldName = 'DivisionPartiesName'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 92
        end
        object MainisBanFiscalSale: TcxGridDBColumn
          Caption = #1047#1072#1087#1088#1077#1090' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1080
          DataBinding.FieldName = 'isBanFiscalSale'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 81
        end
        object MainAmountSendIn: TcxGridDBColumn
          Caption = #1058#1086#1074#1072#1088' '#1074' '#1087#1091#1090#1080' '#1087#1086' '#1087#1077#1088#1077#1084#1077#1097'.'
          DataBinding.FieldName = 'AmountSendIn'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.####;-,0.####; ;'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 71
        end
        object MultiplicitySale: TcxGridDBColumn
          Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080' ('#1084#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1076#1077#1083#1080#1090#1077#1083#1100')'
          DataBinding.FieldName = 'MultiplicitySale'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 3
          Properties.DisplayFormat = ',0.###;-,0.###;  ;'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 117
        end
      end
      object MainGridLevel: TcxGridLevel
        GridView = MainGridDBTableView
      end
    end
    object SearchPanel: TPanel
      Left = 0
      Top = 108
      Width = 964
      Height = 33
      Align = alBottom
      TabOrder = 1
      object ShapeState: TShape
        Left = 810
        Top = 13
        Width = 10
        Height = 10
        Brush.Color = clGreen
        Pen.Color = clWhite
      end
      object cxLabel1: TcxLabel
        Left = 185
        Top = 7
        Caption = #1050#1086#1083':'
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
        Top = 6
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
        Left = 408
        Top = 7
        Hint = #1055#1086' '#1075#1072#1083#1086#1095#1082#1077
        Action = actSpec
        Caption = #1063#1077#1082
        ParentBackground = False
        ParentColor = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Style.Color = clLime
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
        Left = 504
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
        Left = 351
        Top = 7
        Caption = '0.00'
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
        Left = 544
        Top = 7
        Width = 87
        Height = 22
        Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1086#1090#1083#1086#1078#1077#1085'. '#1095#1077#1082#1086#1074
        Caption = 'Vip/'#1058#1072#1073#1083'/Liki'
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
        OnClick = actExecuteLoadVIPExecute
      end
      object lblMoneyInCash: TcxLabel
        Left = 759
        Top = 7
        Caption = '0.00'
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
        Left = 679
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
        Left = 629
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
        Left = 719
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
      object edAmount: TcxTextEdit
        Left = 218
        Top = 6
        TabOrder = 1
        OnExit = edAmountExit
        OnKeyDown = edAmountKeyDown
        OnKeyPress = edAmountKeyPress
        Width = 55
      end
      object cbSpecCorr: TcxCheckBox
        Left = 455
        Top = 7
        Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1091#1102#1097#1072#1103' '#1075#1072#1083#1086#1095#1082#1072
        Action = actSpecCorr
        Caption = #1063#1077#1082
        ParentBackground = False
        ParentColor = False
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        Style.Color = clYellow
        Style.Font.Charset = DEFAULT_CHARSET
        Style.Font.Color = clWindowText
        Style.Font.Height = -12
        Style.Font.Name = 'Tahoma'
        Style.Font.Style = [fsUnderline, fsStrikeOut]
        Style.Shadow = False
        Style.IsFontAssigned = True
        TabOrder = 12
      end
    end
    object pnlExpirationDateFilter: TPanel
      Left = 0
      Top = 0
      Width = 964
      Height = 21
      Align = alTop
      Color = 15656679
      ParentBackground = False
      TabOrder = 2
      Visible = False
      object Label13: TLabel
        Left = 1
        Top = 1
        Width = 204
        Height = 19
        Align = alLeft
        Caption = '     '#1060#1080#1083#1100#1090#1088' '#1087#1086' '#1089#1088#1088#1086#1082#1091' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1086#1089#1090#1072#1090#1082#1072'.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitHeight = 13
      end
      object Label14: TLabel
        Left = 500
        Top = 2
        Width = 59
        Height = 13
        Align = alCustom
        Caption = #1043#1086#1076#1085#1099#1077' '#1076#1086':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object edlExpirationDateFilter: TcxTextEdit
        Left = 567
        Top = 0
        Properties.MaxLength = 8
        TabOrder = 0
        Width = 80
      end
    end
  end
  object pnlVIP: TPanel [3]
    Left = 0
    Top = 60
    Width = 964
    Height = 22
    Align = alTop
    Color = 15656679
    ParentBackground = False
    TabOrder = 3
    Visible = False
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 71
      Height = 20
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
      Width = 442
      Height = 20
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
    object Panel4: TPanel
      Left = 514
      Top = 1
      Width = 449
      Height = 20
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Panel4'
      ParentColor = True
      ShowCaption = False
      TabOrder = 0
      object lblBayer: TLabel
        Left = 64
        Top = 0
        Width = 214
        Height = 20
        Align = alClient
        AutoSize = False
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = [fsItalic]
        ParentFont = False
        ExplicitLeft = 495
        ExplicitTop = 1
        ExplicitWidth = 234
        ExplicitHeight = 16
      end
      object Label2: TLabel
        Left = 0
        Top = 0
        Width = 64
        Height = 20
        Align = alLeft
        Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100' '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        ExplicitHeight = 13
      end
      object plSummCard: TPanel
        Left = 278
        Top = 0
        Width = 171
        Height = 20
        Align = alRight
        BevelOuter = bvNone
        Caption = 'plSummCard'
        ParentColor = True
        ShowCaption = False
        TabOrder = 0
        object Label29: TLabel
          Left = 0
          Top = 0
          Width = 109
          Height = 20
          Align = alClient
          Caption = #1055#1088#1077#1076#1086#1087#1083#1072#1090#1072' ('#1092#1072#1082#1090'.)'
          Color = 15656679
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          ExplicitWidth = 103
          ExplicitHeight = 13
        end
        object ceSummCard: TcxCurrencyEdit
          Left = 109
          Top = 0
          Align = alRight
          ParentFont = False
          Properties.DisplayFormat = ',0.00;-,0.00'
          Properties.ReadOnly = True
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -12
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = [fsBold]
          Style.TextColor = clRed
          Style.IsFontAssigned = True
          TabOrder = 0
          Width = 62
        end
      end
    end
  end
  object pnlDiscount: TPanel [4]
    Left = 0
    Top = 82
    Width = 964
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
      Color = 15656679
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
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
      Width = 116
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
      Left = 495
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
      Left = 569
      Top = -1
      Properties.DisplayFormat = ',0.00;-,0.00'
      TabOrder = 0
      Width = 60
    end
    object edDiscountAmount: TcxCurrencyEdit
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
    Width = 964
    Height = 21
    Align = alTop
    TabOrder = 5
    object lbScaner: TLabel
      Left = 159
      Top = 3
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
    object Label11: TLabel
      Left = 334
      Top = 3
      Width = 146
      Height = 13
      Caption = #1055#1088#1086#1084#1086#1082#1086#1076'  ('#1080#1076#1077#1085#1090#1080#1092'. '#1074#1088#1072#1095#1072')'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object Label24: TLabel
      Left = 236
      Top = 3
      Width = 41
      Height = 13
      Caption = #1057#1082#1080#1076#1082#1072' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      Visible = False
    end
    object Label32: TLabel
      Left = 565
      Top = 3
      Width = 116
      Height = 13
      Caption = #1053#1086#1084#1077#1088' '#1079#1072#1082#1072#1079#1072' (VIP '#1095#1077#1082')'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object ceScaner: TcxCurrencyEdit
      Left = 7
      Top = 0
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.MaxLength = 13
      TabOrder = 0
      OnKeyPress = ceScanerKeyPress
      Width = 146
    end
    object PanelMCSAuto: TPanel
      Left = 772
      Top = 1
      Width = 191
      Height = 19
      Align = alRight
      BevelOuter = bvNone
      Color = 15656679
      ParentBackground = False
      TabOrder = 1
      object Label6: TLabel
        Left = 3
        Top = 2
        Width = 137
        Height = 13
        Caption = #1040#1074#1090#1086' '#1053#1058#1047' '#1085#1072' '#1082#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' : '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object edDays: TcxCurrencyEdit
        Left = 137
        Top = -1
        EditValue = 7.000000000000000000
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0;-,0'
        Properties.ReadOnly = True
        TabOrder = 0
        Width = 38
      end
    end
    object edPromoCode: TcxTextEdit
      Left = 481
      Top = 0
      Properties.MaxLength = 8
      TabOrder = 2
      OnExit = edPromoCodeExit
      OnKeyDown = edPromoCodeKeyDown
      OnKeyPress = edPromoCodeKeyPress
      Width = 80
    end
    object edPermanentDiscount: TcxTextEdit
      Left = 283
      Top = 0
      TabStop = False
      Properties.AutoSelect = False
      Properties.MaxLength = 0
      Properties.ReadOnly = True
      TabOrder = 3
      Visible = False
      Width = 46
    end
    object ceVIPLoad: TcxCurrencyEdit
      Left = 684
      Top = 0
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.MaxLength = 13
      TabOrder = 4
      OnExit = ceVIPLoadExit
      OnKeyDown = ceVIPLoadKeyDown
      Width = 80
    end
  end
  object pnlSP: TPanel [6]
    Left = 0
    Top = 103
    Width = 964
    Height = 36
    Align = alTop
    Color = 15656679
    ParentBackground = False
    TabOrder = 6
    Visible = False
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 424
      Height = 34
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Panel2'
      ShowCaption = False
      TabOrder = 0
      object lblSPKindName: TLabel
        Left = 86
        Top = 1
        Width = 12
        Height = 14
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label4: TLabel
        Left = 1
        Top = 1
        Width = 85
        Height = 13
        Caption = '     '#1057#1086#1094'.'#1087#1088#1086#1077#1082#1090'.: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        OnClick = Label4Click
      end
      object lblPartnerMedicalName: TLabel
        Left = 86
        Top = 16
        Width = 12
        Height = 14
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label30: TLabel
        Left = 1
        Top = 16
        Width = 63
        Height = 13
        Caption = '     '#1052#1077#1076'.'#1091#1095'.: '
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        OnClick = Label4Click
      end
    end
    object Panel3: TPanel
      Left = 425
      Top = 1
      Width = 538
      Height = 34
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel3'
      ShowCaption = False
      TabOrder = 1
      object lblMedicSP: TLabel
        Left = 91
        Top = 0
        Width = 12
        Height = 14
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label7: TLabel
        Left = 10
        Top = 1
        Width = 60
        Height = 13
        Caption = #1060#1048#1054' '#1042#1088#1072#1095#1072':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object Label31: TLabel
        Left = 10
        Top = 17
        Width = 79
        Height = 13
        Caption = #1060#1048#1054' '#1055#1072#1094#1080#1077#1085#1090#1072':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGray
        Font.Height = -11
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
      end
      object lblMemberSP: TLabel
        Left = 91
        Top = 15
        Width = 12
        Height = 14
        Caption = '...'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -12
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
    end
  end
  object pnlPromoCode: TPanel [7]
    Left = 0
    Top = 139
    Width = 964
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
      Width = 165
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
    object Label10: TLabel
      Left = 219
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
      Left = 276
      Top = 1
      Width = 79
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
    object Label22: TLabel
      Left = 355
      Top = 1
      Width = 30
      Height = 19
      Align = alLeft
      Caption = #1060#1048#1054': '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitHeight = 13
    end
    object lblPromoBayerName: TLabel
      Left = 385
      Top = 1
      Width = 131
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
      ExplicitTop = -2
    end
    object edPromoCodeChangePrice: TcxCurrencyEdit
      Left = 567
      Top = -1
      Properties.DisplayFormat = ',0.00;-,0.00'
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 60
    end
  end
  object pnlManualDiscount: TPanel [8]
    Left = 0
    Top = 202
    Width = 964
    Height = 21
    Align = alTop
    Color = 15656679
    ParentBackground = False
    TabOrder = 8
    Visible = False
    OnClick = actSetSiteDiscountExecute
    object Label9: TLabel
      Left = 1
      Top = 1
      Width = 94
      Height = 19
      Align = alLeft
      Caption = '     '#1056#1091#1095#1085#1072#1103' '#1089#1082#1080#1076#1082#1072'.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitHeight = 13
    end
    object Label15: TLabel
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
    object edManualDiscount: TcxCurrencyEdit
      Left = 567
      Top = -1
      Properties.DisplayFormat = ',0.00;-,0.00'
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 60
    end
    object cxButton2: TcxButton
      Left = 931
      Top = 1
      Width = 32
      Height = 19
      Align = alRight
      OptionsImage.ImageIndex = 52
      OptionsImage.Images = dmMain.ImageList
      TabOrder = 1
      TabStop = False
      OnClick = actManualDiscountExecute
    end
  end
  object pnlSiteDiscount: TPanel [9]
    Left = 0
    Top = 244
    Width = 964
    Height = 21
    Align = alTop
    Color = 15656679
    ParentBackground = False
    TabOrder = 9
    Visible = False
    object Label16: TLabel
      Left = 1
      Top = 1
      Width = 127
      Height = 19
      Align = alLeft
      Caption = '     '#1057#1082#1080#1076#1082#1072' '#171#1095#1077#1088#1077#1079' '#1089#1072#1081#1090#187'.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitHeight = 13
    end
    object Label17: TLabel
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
    object edSiteDiscount: TcxCurrencyEdit
      Left = 567
      Top = 0
      Properties.DisplayFormat = ',0.00;-,0.00'
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 60
    end
    object cxButton3: TcxButton
      Left = 931
      Top = 1
      Width = 32
      Height = 19
      Align = alRight
      OptionsImage.ImageIndex = 52
      OptionsImage.Images = dmMain.ImageList
      TabOrder = 1
      TabStop = False
      OnClick = actSetSiteDiscountExecute
    end
  end
  object pnlTaxUnitNight: TPanel [10]
    Left = 0
    Top = 223
    Width = 964
    Height = 21
    Align = alTop
    Color = 15656679
    ParentBackground = False
    TabOrder = 10
    Visible = False
    object Label18: TLabel
      Left = 1
      Top = 1
      Width = 173
      Height = 19
      Align = alLeft
      Caption = '     '#1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1085#1086#1095#1085#1072#1103' '#1094#1077#1085#1072'.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitHeight = 14
    end
    object edTaxUnitNight: TcxTextEdit
      Left = 567
      Top = 0
      TabStop = False
      Properties.AutoSelect = False
      Properties.MaxLength = 8
      Properties.ReadOnly = True
      TabOrder = 0
      OnExit = edPromoCodeExit
      OnKeyDown = edPromoCodeKeyDown
      OnKeyPress = edPromoCodeKeyPress
      Width = 162
    end
  end
  object pnlAnalogFilter: TPanel [11]
    Left = 0
    Top = 328
    Width = 964
    Height = 21
    Align = alTop
    Color = 15656679
    ParentBackground = False
    TabOrder = 11
    Visible = False
    DesignSize = (
      964
      21)
    object Label19: TLabel
      Left = 1
      Top = 1
      Width = 186
      Height = 19
      Align = alLeft
      Caption = '     '#1060#1080#1083#1100#1090#1088' '#1087#1086' '#1072#1085#1072#1083#1086#1075#1091' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1072'.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitHeight = 13
    end
    object Label20: TLabel
      Left = 249
      Top = 1
      Width = 40
      Height = 13
      Align = alCustom
      Caption = #1040#1085#1072#1083#1086#1075':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edAnalogFilter: TcxTextEdit
      Left = 295
      Top = 0
      Properties.MaxLength = 0
      Properties.OnChange = edAnalogFilterPropertiesChange
      TabOrder = 0
      OnExit = edAnalogFilterExit
      Width = 524
    end
    object ProgressBar1: TProgressBar
      Left = 863
      Top = 9
      Width = 57
      Height = 9
      Anchors = [akTop, akRight]
      BarColor = clMedGray
      TabOrder = 1
      Visible = False
    end
    object cxButton7: TcxButton
      Left = 931
      Top = 1
      Width = 32
      Height = 19
      Align = alRight
      OptionsImage.ImageIndex = 52
      OptionsImage.Images = dmMain.ImageList
      TabOrder = 2
      TabStop = False
      OnClick = cxButton7Click
    end
  end
  object pnlHelsiError: TPanel [12]
    Left = 0
    Top = 42
    Width = 964
    Height = 18
    Align = alTop
    Color = 12173055
    ParentBackground = False
    TabOrder = 12
    Visible = False
    object Label21: TLabel
      Left = 1
      Top = 1
      Width = 197
      Height = 16
      Align = alLeft
      Caption = '     '#1054#1096#1080#1073#1082#1072' '#1087#1086#1075#1072#1096#1077#1085#1080#1103' '#1088#1077#1094#1077#1087#1090#1072' '#1093#1077#1083#1089#1080': '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = Label4Click
      ExplicitHeight = 13
    end
    object edHelsiError: TcxTextEdit
      Left = 204
      Top = 1
      TabStop = False
      Properties.HideSelection = False
      Properties.MaxLength = 8
      Properties.ReadOnly = True
      TabOrder = 0
      OnExit = edPromoCodeExit
      OnKeyDown = edPromoCodeKeyDown
      OnKeyPress = edPromoCodeKeyPress
      Width = 151
    end
    object cxButton4: TcxButton
      Left = 931
      Top = 1
      Width = 32
      Height = 16
      Align = alRight
      OptionsImage.ImageIndex = 52
      OptionsImage.Images = dmMain.ImageList
      TabOrder = 1
      TabStop = False
      OnClick = cxButton4Click
    end
    object cxButton5: TcxButton
      Left = 694
      Top = 1
      Width = 114
      Height = 16
      Align = alRight
      Caption = #1057#1090#1072#1090#1091#1089' '#1088#1077#1094#1077#1087#1090#1072
      OptionsImage.ImageIndex = 10
      OptionsImage.Images = dmMain.ImageList
      TabOrder = 2
      TabStop = False
      OnClick = cxButton5Click
    end
    object cxButton6: TcxButton
      Left = 808
      Top = 1
      Width = 123
      Height = 16
      Align = alRight
      Caption = #1055#1086#1075#1072#1089#1080#1090#1100' '#1088#1077#1094#1077#1087#1090
      OptionsImage.ImageIndex = 76
      OptionsImage.Images = dmMain.ImageList
      TabOrder = 3
      TabStop = False
      OnClick = cxButton6Click
    end
  end
  object pnlPromoCodeLoyalty: TPanel [13]
    Left = 0
    Top = 160
    Width = 964
    Height = 21
    Align = alTop
    Color = 15656679
    ParentBackground = False
    TabOrder = 13
    Visible = False
    object Label23: TLabel
      Left = 1
      Top = 1
      Width = 134
      Height = 19
      Align = alLeft
      Caption = '     '#1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1083#1086#1103#1083#1100#1085#1086#1089#1090#1080' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitHeight = 13
    end
    object Label25: TLabel
      Left = 135
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
    object lblPromoCodeLoyalty: TLabel
      Left = 192
      Top = 1
      Width = 12
      Height = 19
      Align = alLeft
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitHeight = 14
    end
    object Label27: TLabel
      Left = 461
      Top = 2
      Width = 73
      Height = 13
      Align = alCustom
      Caption = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object edPromoCodeLoyaltySumm: TcxCurrencyEdit
      Left = 567
      Top = -1
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.00##;-,0.00##'
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 60
    end
  end
  object pnlLoyaltySaveMoney: TPanel [14]
    Left = 0
    Top = 181
    Width = 964
    Height = 21
    Align = alTop
    Color = 15656679
    ParentBackground = False
    TabOrder = 14
    Visible = False
    DesignSize = (
      964
      21)
    object Label26: TLabel
      Left = 1
      Top = 1
      Width = 150
      Height = 19
      Align = alLeft
      Caption = '     '#1053#1072#1082#1086#1087#1080#1090#1077#1083#1100#1085#1072#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitHeight = 13
    end
    object Label28: TLabel
      Left = 151
      Top = 1
      Width = 71
      Height = 19
      Align = alLeft
      Caption = ' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1100': '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitHeight = 13
    end
    object lblLoyaltySMBuyer: TLabel
      Left = 222
      Top = 1
      Width = 12
      Height = 19
      Align = alLeft
      Caption = '...'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      ExplicitHeight = 14
    end
    object lblLoyaltySMSummaRemainder: TLabel
      Left = 649
      Top = 3
      Width = 55
      Height = 13
      Align = alCustom
      Anchors = [akTop, akRight]
      Caption = #1053#1072#1082#1086#1087#1083#1077#1085#1086
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitLeft = 543
    end
    object lblLoyaltySMSumma: TLabel
      Left = 777
      Top = 3
      Width = 73
      Height = 13
      Align = alCustom
      Anchors = [akTop, akRight]
      Caption = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clGray
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitLeft = 671
    end
    object edLoyaltySMSummaRemainder: TcxCurrencyEdit
      Left = 711
      Top = 0
      Anchors = [akTop, akRight]
      Properties.DisplayFormat = ',0.00;-,0.00'
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 60
    end
    object cxButton8: TcxButton
      Left = 931
      Top = 1
      Width = 32
      Height = 19
      Align = alRight
      OptionsImage.ImageIndex = 52
      OptionsImage.Images = dmMain.ImageList
      TabOrder = 1
      TabStop = False
      OnClick = cxButton8Click
    end
    object edLoyaltySMSumma: TcxCurrencyEdit
      Left = 865
      Top = 0
      Anchors = [akTop, akRight]
      Properties.DisplayFormat = ',0.00;-,0.00'
      TabOrder = 2
      OnExit = edLoyaltySMSummaExit
      Width = 60
    end
  end
  object pnlPosition: TPanel [15]
    Left = 0
    Top = 265
    Width = 964
    Height = 63
    Align = alTop
    Color = 15656679
    ParentBackground = False
    TabOrder = 15
    Visible = False
    DesignSize = (
      964
      63)
    object cmPosition: TcxMemo
      Left = 1
      Top = 1
      Align = alLeft
      Properties.ReadOnly = True
      TabOrder = 0
      Height = 61
      Width = 348
    end
    object edName_inn_ua: TcxTextEdit
      Left = 349
      Top = 0
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Properties.AutoSelect = False
      Properties.MaxLength = 8
      Properties.ReadOnly = True
      TabOrder = 1
      OnExit = edPromoCodeExit
      OnKeyDown = edPromoCodeKeyDown
      OnKeyPress = edPromoCodeKeyPress
      Width = 425
    end
    object edName_reg_ua: TcxTextEdit
      Left = 349
      Top = 21
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Properties.AutoSelect = False
      Properties.MaxLength = 8
      Properties.ReadOnly = True
      TabOrder = 2
      OnExit = edPromoCodeExit
      OnKeyDown = edPromoCodeKeyDown
      OnKeyPress = edPromoCodeKeyPress
      Width = 425
    end
    object edCommentPosition: TcxTextEdit
      Left = 349
      Top = 42
      TabStop = False
      Anchors = [akLeft, akTop, akRight]
      Properties.AutoSelect = False
      Properties.MaxLength = 8
      Properties.ReadOnly = True
      TabOrder = 3
      OnExit = edPromoCodeExit
      OnKeyDown = edPromoCodeKeyDown
      OnKeyPress = edPromoCodeKeyPress
      Width = 425
    end
    object bbPositionNext: TcxButton
      Left = 935
      Top = 1
      Width = 28
      Height = 61
      Hint = #1057#1083#1082#1076#1091#1102#1097#1080#1094#1081' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090' '#1089' '#1088#1077#1094#1077#1087#1090#1072
      Align = alRight
      OptionsImage.ImageIndex = 80
      OptionsImage.Images = dmMain.ImageList
      TabOrder = 4
      TabStop = False
      OnClick = bbPositionNextClick
    end
    object cbMorionFilter: TcxCheckBox
      Left = 775
      Top = 2
      Anchors = [akTop, akRight]
      Caption = #1060#1080#1083#1100#1090#1088' '#1087#1086' '#1082#1086#1076#1091' '#1084#1086#1088#1080#1086#1085#1072
      Properties.OnChange = cbMorionFilterPropertiesChange
      TabOrder = 5
    end
  end
  object pnlInfo: TPanel [16]
    Left = 0
    Top = 21
    Width = 964
    Height = 21
    Align = alTop
    Color = 15656679
    ParentBackground = False
    TabOrder = 16
    Visible = False
    object lblInfo: TLabel
      Left = 1
      Top = 1
      Width = 63
      Height = 19
      Align = alLeft
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103
      Color = 15656679
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ExplicitHeight = 13
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
    Images = dmMain.ImageList
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
        end
        item
          Name = 'ManualDiscount'
          Value = Null
          Component = FormParams
          ComponentItem = 'ManualDiscount'
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
      StoredProcList = <
        item
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
          Value = Null
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
        end
        item
          Name = 'ManualDiscount'
          Value = Null
          Component = FormParams
          ComponentItem = 'ManualDiscount'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeID'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoCodeID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoName'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeGUID'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoCodeGUID'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeChangePercent'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoCodeChangePercent'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberSPId'
          Value = Null
          Component = FormParams
          ComponentItem = 'MemberSPID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'SiteDiscount'
          Value = Null
          Component = FormParams
          ComponentItem = 'SiteDiscount'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionDateKindId'
          Value = Null
          Component = FormParams
          ComponentItem = 'PartionDateKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'LoyaltyChangeSumma'
          Value = Null
          Component = FormParams
          ComponentItem = 'LoyaltyChangeSumma'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'SummCard'
          Value = Null
          Component = FormParams
          ComponentItem = 'SummCard'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'isBanAdd'
          Value = Null
          Component = FormParams
          ComponentItem = 'isBanAdd'
          DataType = ftBoolean
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
      Enabled = False
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
      Enabled = False
      StoredProcList = <>
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
      Caption = 'Vip/'#1058#1072#1073#1083
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
    object actAddDiffMemdata: TAction
      Caption = 'actAddDiffMemdata'
      OnExecute = actAddDiffMemdataExecute
    end
    object actSetRimainsFromMemdata: TAction
      Caption = 'actSetRimainsFromMemdata'
      OnExecute = actSetRimainsFromMemdataExecute
    end
    object actSaveCashSesionIdToFile: TAction
      Caption = 'actSaveCashSesionIdToFile'
      OnExecute = actSaveCashSesionIdToFileExecute
    end
    object actServiseRun: TAction
      Caption = 'actServiseRun'
      OnExecute = actServiseRunExecute
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
      FormName = 'TGoodsSP_MovementForm'
      FormNameParam.Value = 'TGoodsSP_MovementForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'MovementSPId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
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
      ShortCut = 16504
      OnExecute = actSetPromoCodeExecute
    end
    object actManualDiscount: TAction
      Caption = #1044#1072#1090#1100' '#1088#1091#1095#1085#1091#1102' '#1089#1082#1080#1076#1082#1091
      Enabled = False
      Visible = False
      OnExecute = actManualDiscountExecute
    end
    object actDivisibilityDialog: TAction
      Caption = 'actDivisibilityDialog'
    end
    object actOpenAccommodation: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenAccommodation'
      FormName = 'TAccommodationForm'
      FormNameParam.Value = 'TAccommodationForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = RemainsCDS
          ComponentItem = 'AccommodationId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = RemainsCDS
          ComponentItem = 'AccommodationName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actDeleteAccommodation: TAction
      Category = 'DSDLib'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1087#1088#1080#1074#1103#1079#1082#1091' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1090#1086#1074#1072#1088#1072' '#1082' '#1088#1072#1079#1084#1077#1097#1077#1085#1080#1102
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1087#1088#1080#1074#1103#1079#1082#1091' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1090#1086#1074#1072#1088#1072' '#1082' '#1088#1072#1079#1084#1077#1097#1077#1085#1080#1102
      OnExecute = actDeleteAccommodationExecute
    end
    object actExpirationDateFilter: TAction
      Caption = #1060#1080#1083#1100#1090#1088' '#1087#1086' '#1089#1088#1086#1082#1091' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1086#1089#1090#1072#1090#1082#1072
      OnExecute = actExpirationDateFilterExecute
    end
    object actListDiffAddGoods: TAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1077#1087#1072#1088#1072#1090' '#1074' '#1083#1080#1089#1090' '#1086#1090#1082#1072#1079#1086#1074
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1077#1087#1072#1088#1072#1090' '#1085#1072' '#1082#1086#1090#1086#1088#1086#1084' '#1095#1090#1086#1080#1090' '#1082#1091#1088#1089#1086#1088' '#1074' '#1083#1080#1089#1090' '#1086#1090#1082#1072#1079#1086#1074
      ShortCut = 121
      OnExecute = actListDiffAddGoodsExecute
    end
    object actShowListDiff: TAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1083#1080#1089#1090' '#1086#1090#1082#1072#1079#1086#1074' '#1087#1086' '#1082#1072#1089#1089#1077' '#1079#1072' '#1076#1074#1072' '#1076#1085#1103
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1083#1080#1089#1090' '#1086#1090#1082#1072#1079#1086#1074' '#1087#1086' '#1082#1072#1089#1089#1077' '#1079#1072' '#1076#1074#1072' '#1076#1085#1103
      OnExecute = actShowListDiffExecute
    end
    object actListGoods: TAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      Caption = #1055#1086#1076#1073#1086#1088' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1086#1074
      Hint = #1055#1086#1076#1073#1086#1088' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1086#1074' '#1076#1083#1103' '#1074#1089#1090#1072#1074#1082#1080' '#1074' '#1083#1080#1089#1090' '#1086#1090#1082#1072#1079#1086#1074
      ShortCut = 123
      OnExecute = actListGoodsExecute
    end
    object actOpenCheckVIP_Search: TOpenChoiceForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenCheckVIP_Search'
      FormName = 'TCheckVIP_SearchForm'
      FormNameParam.Value = 'TCheckVIP_SearchForm'
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
          Value = Null
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
        end
        item
          Name = 'ManualDiscount'
          Value = Null
          Component = FormParams
          ComponentItem = 'ManualDiscount'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeID'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoCodeID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoName'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeGUID'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoCodeGUID'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeChangePercent'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoCodeChangePercent'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberSPId'
          Value = Null
          Component = FormParams
          ComponentItem = 'MemberSPID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'SiteDiscount'
          Value = Null
          Component = FormParams
          ComponentItem = 'SiteDiscount'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionDateKindId'
          Value = Null
          Component = FormParams
          ComponentItem = 'PartionDateKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'LoyaltyChangeSumma'
          Value = Null
          Component = FormParams
          ComponentItem = 'LoyaltyChangeSumma'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'SummCard'
          Value = Null
          Component = FormParams
          ComponentItem = 'SummCard'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'isBanAdd'
          Value = Null
          Component = FormParams
          ComponentItem = 'isBanAdd'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actLoadVIP_Search: TMultiAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      ActionList = <
        item
          Action = actOpenCheckVIP_Search
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
      Caption = 'actLoadVIP_Search'
    end
    object actCashListDiffPeriod: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1051#1080#1089#1090' '#1086#1090#1082#1072#1079#1086#1074' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      Hint = #1051#1080#1089#1090' '#1086#1090#1082#1072#1079#1086#1074' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      FormName = 'TReport_CashListDiffPeriodForm'
      FormNameParam.Value = 'TReport_CashListDiffPeriodForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSetSiteDiscount: TAction
      Caption = #1057#1082#1080#1076#1082#1072' '#1095#1077#1088#1077#1079' '#1089#1072#1081#1090
      OnExecute = actSetSiteDiscountExecute
    end
    object actOpenMovementSP: TMultiAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      ActionList = <
        item
          Action = actExecGet_Movement_GoodsSP_ID
        end
        item
          Action = actOpenGoodsSP_UserForm
        end>
      Caption = #1044#1086#1089#1090#1091#1087#1085#1099#1077' '#1083#1077#1082#1072#1088#1089#1090#1074#1072' - '#1057#1055
    end
    object actExecGet_Movement_GoodsSP_ID: TdsdExecStoredProc
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = gpGet_Movement_GoodsSP_ID
      StoredProcList = <
        item
          StoredProc = gpGet_Movement_GoodsSP_ID
        end>
      Caption = 'actExecGet_Movement_GoodsSP_ID'
    end
    object actEmployeeScheduleUser: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      CancelAction = actBanCash
      AfterAction = actBanCash
      Caption = #1047#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1074#1088#1077#1084#1077#1085#1080' '#1087#1088#1080#1093#1086#1076#1072
      FormName = 'TEmployeeScheduleUserForm'
      FormNameParam.Value = 'TEmployeeScheduleUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = True
    end
    object actSpecCorr: TAction
      AutoCheck = True
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1091#1102#1097#1072#1103' '#1075#1072#1083#1082#1072
      OnExecute = actSpecCorrExecute
    end
    object actDoesNotShare: TAction
      Category = 'DSDLib'
      Caption = #1055#1088#1080#1079#1085#1072#1082' "'#1041#1083#1086#1082#1080#1088#1086#1074#1082#1072' '#1076#1077#1083#1077#1085#1080#1103' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1072'"'
      Hint = #1055#1088#1080#1079#1085#1072#1082' "'#1041#1083#1086#1082#1080#1088#1086#1074#1082#1072' '#1076#1077#1083#1077#1085#1080#1103' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1072'"'
      ShortCut = 16462
      OnExecute = actDoesNotShareExecute
    end
    object actOpenCashGoodsOneToExpirationDate: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actOpenCashGoodsOneToExpirationDate'
      FormName = 'TCashGoodsOneToExpirationDateForm'
      FormNameParam.Value = 'TCashGoodsOneToExpirationDateForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'GoodsId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actCashGoodsOneToExpirationDate: TAction
      Category = 'DSDLib'
      Caption = #1054#1089#1090#1072#1090#1086#1082' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1072' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084
      Enabled = False
      Hint = #1054#1089#1090#1072#1090#1086#1082' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1072' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084
      OnExecute = actCashGoodsOneToExpirationDateExecute
    end
    object actOpenDelayVIPForm: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1088#1086#1095#1077#1085#1085#1099#1077' VIP '#1095#1077#1082#1080
      FormName = 'TCheckDelayVIPForm'
      FormNameParam.Value = 'TCheckDelayVIPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actGoodsAnalog: TAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1072#1085#1072#1083#1086#1075#1080' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1072
      ShortCut = 16449
      OnExecute = actGoodsAnalogExecute
    end
    object actGoodsAnalogChoose: TAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1087#1072#1085#1077#1083#1100' '#1092#1080#1083#1100#1090#1088#1072' '#1076#1083#1103' '#1087#1086#1080#1089#1082#1072' '#1072#1085#1072#1083#1086#1075#1086#1074
      ShortCut = 49217
      OnExecute = actGoodsAnalogChooseExecute
    end
    object actSetSPHelsi: TAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      Caption = #1057#1082#1080#1076#1082#1072' '#1087#1086' '#1057#1055' "'#1044#1086#1089#1090#1091#1087#1085#1110' '#1051#1110#1082#1080'"'
      ShortCut = 16498
      OnExecute = actSetSPHelsiExecute
    end
    object actSendPartionDateChangeCashJournal: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1047#1072#1103#1074#1082#1080' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1089#1088#1086#1082#1072' '#1075#1086#1076#1085#1086#1089#1090#1080
      FormName = 'TSendPartionDateChangeCashJournalForm'
      FormNameParam.Value = 'TSendPartionDateChangeCashJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOverdueChangeCashJournal: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1083#1077#1085#1080#1077' '#1087#1072#1088#1090#1080#1081' '#1090#1086#1074#1072#1088#1072' '#1074' '#1079#1072#1103#1074#1082#1091' '#1085#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1089#1088#1086#1082#1072
      ShortCut = 16457
      FormName = 'TOverdueChangeCashJournalForm'
      FormNameParam.Value = 'TOverdueChangeCashJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'GoodsId'
          Value = Null
          Component = RemainsCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = RemainsCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = RemainsCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actDeleteAccommodationAllId: TAction
      Category = 'DSDLib'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1077' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1082' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1088#1072#1079#1084#1077#1097#1077#1085#1080#1080#1102
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1077' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1082' '#1090#1077#1082#1091#1097#1077#1084#1091' '#1088#1072#1079#1084#1077#1097#1077#1085#1080#1080#1102
      OnExecute = actDeleteAccommodationAllIdExecute
    end
    object actDeleteAccommodationAll: TAction
      Category = 'DSDLib'
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1077' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1077' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102
      OnExecute = actDeleteAccommodationAllExecute
    end
    object actOverdueJournal: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1088#1086#1082#1072' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1099#1093' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1086#1074
      Hint = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1088#1086#1082#1072' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1099#1093' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1086#1074
      ShortCut = 16467
      FormName = 'TOverdueJournalForm'
      FormNameParam.Value = 'TOverdueJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actReport_GoodsRemainsCash: TdsdOpenForm
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = #1054#1089#1090#1072#1090#1082#1080' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102
      Hint = #1054#1089#1090#1072#1090#1082#1080' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102
      FormName = 'TReport_GoodsRemainsCashForm'
      FormNameParam.Value = 'TReport_GoodsRemainsCashForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actInventoryEveryMonth: TMultiAction
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      ActionList = <
        item
          Action = actDataDialog
        end
        item
          Action = actExecInventoryEveryMonth
        end
        item
          Action = actDOCReportInventoryEveryMonth
        end>
      Caption = #1048#1053#1042#1045#1053#1058' '#1054#1055#1048#1057#1068' '#1085#1072' '#1082#1072#1078#1076#1099#1081' '#1084#1077#1089#1103#1094
      Hint = #1048#1053#1042#1045#1053#1058' '#1054#1055#1048#1057#1068' '#1085#1072' '#1082#1072#1078#1076#1099#1081' '#1084#1077#1089#1103#1094
    end
    object actSendCashJournal: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1046#1091#1088#1085#1072#1083' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081
      Hint = #1046#1091#1088#1085#1072#1083' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081
      FormName = 'TSendCashJournalForm'
      FormNameParam.Value = 'TSendCashJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSendCashJournalSun: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1046#1091#1088#1085#1072#1083' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' '#1057#1059#1053
      Hint = #1046#1091#1088#1085#1072#1083' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' '#1057#1059#1053
      FormName = 'TSendCashJournalSunForm'
      FormNameParam.Value = 'TSendCashJournalSunForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'isSUNAll'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenWagesUser: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actOpenWagesUser'
      FormName = 'TWagesUserForm'
      FormNameParam.Value = 'TWagesUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = True
    end
    object actWagesUser: TAction
      Category = 'DSDLib'
      Caption = 'actWagesUser'
      ShortCut = 16474
      OnExecute = actWagesUserExecute
    end
    object actDataDialog: TExecuteDialog
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = 'actDataDialog'
      FormName = 'TDataDialogForm'
      FormNameParam.Value = 'TDataDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actExecInventoryEveryMonth: TdsdExecStoredProc
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInventoryEveryMonth
      StoredProcList = <
        item
          StoredProc = spInventoryEveryMonth
        end>
      Caption = 'actExecInventoryEveryMonth'
    end
    object actDOCReportInventoryEveryMonth: TdsdDOCReportFormAction
      Category = #1054#1090#1095#1077#1090#1099
      MoveParams = <>
      Caption = 'actDOCReportInventoryEveryMonth'
      DataSet = cdsInventoryEveryMonth
      BlankName = #1048#1053#1042#1045#1053#1058'_'#1054#1055#1048#1057#1068'_'#1085#1072'_'#1082#1072#1078#1076#1099#1081'_'#1084#1077#1089#1103#1094'.doc'
      FileName = #1048#1053#1042#1045#1053#1058' '#1054#1055#1048#1057#1068' '#1085#1072' '#1082#1072#1078#1076#1099#1081' '#1084#1077#1089#1103#1094'.doc'
    end
    object actBanCash: TAction
      Category = #1054#1090#1095#1077#1090#1099
      Caption = 'actBanCash'
      OnExecute = actBanCashExecute
    end
    object actNotTransferTime: TAction
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077' '#1087#1077#1088#1077#1074#1086#1076#1080#1090#1100' '#1074' '#1089#1088#1086#1082#1080'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077' '#1087#1077#1088#1077#1074#1086#1076#1080#1090#1100' '#1074' '#1089#1088#1086#1082#1080'"'
      ShortCut = 16472
      Visible = False
      OnExecute = actNotTransferTimeExecute
    end
    object actSetPromoCodeLoyalty: TAction
      Category = 'DSDLib'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1086#1084#1086#1082#1086#1076' "'#1055#1088#1086#1075#1088#1072#1084#1084#1099' '#1083#1086#1103#1083#1100#1085#1086#1089#1090#1080'"'
      Hint = #1042#1074#1077#1089#1090#1080' '#1087#1088#1086#1084#1086#1082#1086#1076' "'#1055#1088#1086#1075#1088#1072#1084#1084#1099' '#1083#1086#1103#1083#1100#1085#1086#1089#1090#1080'"'
      ShortCut = 120
      OnExecute = actSetPromoCodeLoyaltyExecute
    end
    object actOpenMCS: TAction
      Category = 'DSDLib'
      Caption = #1053#1058#1047
      Hint = #1056#1077#1077#1089#1090#1088' '#1085#1077#1089#1085#1080#1078#1072#1077#1084#1086#1075#1086' '#1090#1086#1074#1072#1088#1085#1086#1075#1086' '#1079#1072#1087#1072#1089#1072
      OnExecute = actOpenMCSExecute
    end
    object actReport_ImplementationPlanEmployee: TAction
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1102' '#1087#1083#1072#1085#1072' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1102' '#1087#1083#1072#1085#1072' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091
      OnExecute = actReport_ImplementationPlanEmployeeExecute
    end
    object actReport_IlliquidReductionPlanAll: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1083#1072#1085' '#1087#1086' '#1091#1084#1077#1085#1100#1096#1077#1085#1080#1102' '#1082#1086#1083'-'#1074#1086' '#1085#1077#1083#1080#1082#1074#1080#1076#1072
      Hint = #1054#1090#1095#1077#1090' '#1087#1083#1072#1085' '#1087#1086' '#1091#1084#1077#1085#1100#1096#1077#1085#1080#1102' '#1082#1086#1083'-'#1074#1086' '#1085#1077#1083#1080#1082#1074#1080#1076#1072
      FormName = 'TReport_IlliquidReductionPlanUserForm'
      FormNameParam.Value = 'TReport_IlliquidReductionPlanUserForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actSetLoyaltySaveMoney: TAction
      Caption = #1042#1099#1073#1086#1088' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' '#1076#1083#1103' '#1085#1072#1082#1086#1087#1080#1090#1077#1083#1100#1085#1086#1081'  '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1083#1086#1103#1083#1100#1085#1086#1089#1090#1080
      Hint = #1042#1099#1073#1086#1088' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' '#1076#1083#1103' '#1085#1072#1082#1086#1087#1080#1090#1077#1083#1100#1085#1086#1081'  '#1087#1088#1086#1075#1088#1072#1084#1084#1099' '#1083#1086#1103#1083#1100#1085#1086#1089#1090#1080
      ShortCut = 32888
      OnExecute = actSetLoyaltySaveMoneyExecute
    end
    object actTechnicalRediscount: TAction
      Caption = #1058#1077#1082#1091#1097#1080#1081' '#1090#1077#1093#1085#1080#1095#1077#1089#1082#1080#1081' '#1087#1077#1088#1077#1091#1095#1077#1090
      Hint = #1058#1077#1082#1091#1097#1080#1081' '#1090#1077#1093#1085#1080#1095#1077#1089#1082#1080#1081' '#1087#1077#1088#1077#1091#1095#1077#1090
      OnExecute = actTechnicalRediscountExecute
    end
    object actTechnicalRediscountCurr: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actTechnicalRediscountCurr'
      FormName = 'TTechnicalRediscountCashierForm'
      FormNameParam.Value = 'TTechnicalRediscountCashierForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actTechnicalRediscountCashier: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1058#1077#1093#1085#1080#1095#1077#1089#1082#1080#1077' '#1087#1077#1088#1077#1091#1095#1077#1090#1099
      Hint = #1058#1077#1093#1085#1080#1095#1077#1089#1082#1080#1077' '#1087#1077#1088#1077#1091#1095#1077#1090#1099
      FormName = 'TTechnicalRediscountCashierJournalForm'
      FormNameParam.Value = 'TTechnicalRediscountCashierJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actPromoCodeDoctor: TAction
      Caption = #1042#1099#1073#1086#1088' '#1087#1088#1086#1084#1086#1082#1086#1076#1072' '#1074#1088#1072#1095#1072' '
      Hint = #1042#1099#1073#1086#1088' '#1087#1088#1086#1084#1086#1082#1086#1076#1072' '#1074#1088#1072#1095#1072' '
      ShortCut = 16452
      OnExecute = actPromoCodeDoctorExecute
    end
    object actChoicePromoCodeDoctor: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoicePromoCodeDoctor'
      FormName = 'TPromoCodeDoctorForm'
      FormNameParam.Value = 'TPromoCodeDoctorForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoCodeId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actSaveHardwareData: TAction
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1072#1087#1087#1072#1088#1072#1090#1085#1091#1102' '#1095#1072#1089#1090#1100' '
      Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1072#1087#1087#1072#1088#1072#1090#1085#1091#1102' '#1095#1072#1089#1090#1100' '
      ShortCut = 16456
      OnExecute = actSaveHardwareDataExecute
    end
    object actUpdateProgram: TAction
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1074#1077#1088#1089#1080#1102' '#1087#1088#1086#1075#1088#1072#1084#1084#1099
      ShortCut = 57429
      OnExecute = actUpdateProgramExecute
    end
    object actOpenFormPUSH: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actOpenFormPUSH'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = True
    end
    object actSendCashJournalVip: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1046#1091#1088#1085#1072#1083' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' VIP'
      Hint = #1046#1091#1088#1085#1072#1083' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' VIP'
      FormName = 'TSendCashJournalVIPForm'
      FormNameParam.Value = 'TSendCashJournalVIPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'VIPType'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actIncomeHouseholdInventoryCashJournal: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1080#1093#1086#1076#1099' '#1093#1086#1079#1103#1081#1089#1090#1074#1077#1085#1085#1086#1075#1086' '#1080#1085#1074#1077#1085#1090#1072#1088#1103
      FormName = 'TIncomeHouseholdInventoryCashJournalForm'
      FormNameParam.Value = 'TIncomeHouseholdInventoryCashJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'GoodsId'
          Value = Null
          Component = RemainsCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = RemainsCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = RemainsCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actReport_HouseholdInventoryRemainsCash: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1054#1089#1090#1072#1090#1082#1080' '#1093#1086#1079#1103#1081#1089#1090#1074#1077#1085#1085#1086#1075#1086' '#1080#1085#1074#1077#1085#1090#1072#1088#1103
      FormName = 'TReport_HouseholdInventoryRemainsCashForm'
      FormNameParam.Value = 'TReport_HouseholdInventoryRemainsCashForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'GoodsId'
          Value = Null
          Component = RemainsCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = RemainsCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = RemainsCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actReturnInJournal: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
      ShortCut = 16470
      FormName = 'TReturnInJournalCashForm'
      FormNameParam.Value = 'TReturnInJournalCashForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'GoodsId'
          Value = Null
          Component = RemainsCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = RemainsCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = RemainsCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenCheckDeferred: TOpenChoiceForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenCheckDeferred'
      FormName = 'TCheckDeferredForm'
      FormNameParam.Value = 'TCheckDeferredForm'
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
          Value = Null
          Component = FormParams
          ComponentItem = 'OperDateSP'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'SPTax'
          Value = 0.000000000000000000
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
        end
        item
          Name = 'ManualDiscount'
          Value = Null
          Component = FormParams
          ComponentItem = 'ManualDiscount'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeID'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoCodeID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoName'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeGUID'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoCodeGUID'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeChangePercent'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'PromoCodeChangePercent'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberSPId'
          Value = Null
          Component = FormParams
          ComponentItem = 'MemberSPID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'SiteDiscount'
          Value = Null
          Component = FormParams
          ComponentItem = 'SiteDiscount'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionDateKindId'
          Value = Null
          Component = FormParams
          ComponentItem = 'PartionDateKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'LoyaltyChangeSumma'
          Value = Null
          Component = FormParams
          ComponentItem = 'LoyaltyChangeSumma'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'SummCard'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'SummCard'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'isBanAdd'
          Value = Null
          Component = FormParams
          ComponentItem = 'isBanAdd'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actLoadDeferred: TMultiAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      ActionList = <
        item
          Action = actOpenCheckDeferred
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
      Caption = 'Deferred'
    end
    object actOpenCheckDeferred_Search: TOpenChoiceForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenCheckDeferred_Search'
      FormName = 'TCheckDeferred_SearchForm'
      FormNameParam.Value = 'TCheckDeferred_SearchForm'
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
          Value = Null
          Component = FormParams
          ComponentItem = 'OperDateSP'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'SPTax'
          Value = 0.000000000000000000
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
        end
        item
          Name = 'ManualDiscount'
          Value = Null
          Component = FormParams
          ComponentItem = 'ManualDiscount'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeID'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoCodeID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoName'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeGUID'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoCodeGUID'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeChangePercent'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'PromoCodeChangePercent'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberSPId'
          Value = Null
          Component = FormParams
          ComponentItem = 'MemberSPID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'SiteDiscount'
          Value = Null
          Component = FormParams
          ComponentItem = 'SiteDiscount'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionDateKindId'
          Value = Null
          Component = FormParams
          ComponentItem = 'PartionDateKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'LoyaltyChangeSumma'
          Value = Null
          Component = FormParams
          ComponentItem = 'LoyaltyChangeSumma'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'SummCard'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'SummCard'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'isBanAdd'
          Value = Null
          Component = FormParams
          ComponentItem = 'isBanAdd'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actLoadDeferred_Search: TMultiAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      ActionList = <
        item
          Action = actOpenCheckDeferred_Search
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
      Caption = 'actLoadDeferred_Search'
    end
    object actOpenDelayDeferred: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1042#1089#1077' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1099#1077'  '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1077' '#1095#1077#1082#1080
      FormName = 'TCheckDelayDeferredForm'
      FormNameParam.Value = 'TCheckDelayDeferredForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actOpenCheckSite: TOpenChoiceForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenCheckSite'
      FormName = 'TCheckSiteForm'
      FormNameParam.Value = 'TCheckSiteForm'
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
          Value = Null
          Component = FormParams
          ComponentItem = 'OperDateSP'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'SPTax'
          Value = 0.000000000000000000
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
        end
        item
          Name = 'ManualDiscount'
          Value = Null
          Component = FormParams
          ComponentItem = 'ManualDiscount'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeID'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoCodeID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoName'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeGUID'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoCodeGUID'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeChangePercent'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'PromoCodeChangePercent'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberSPId'
          Value = Null
          Component = FormParams
          ComponentItem = 'MemberSPID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'SiteDiscount'
          Value = Null
          Component = FormParams
          ComponentItem = 'SiteDiscount'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionDateKindId'
          Value = Null
          Component = FormParams
          ComponentItem = 'PartionDateKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'LoyaltyChangeSumma'
          Value = Null
          Component = FormParams
          ComponentItem = 'LoyaltyChangeSumma'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'SummCard'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'SummCard'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'isBanAdd'
          Value = Null
          Component = FormParams
          ComponentItem = 'isBanAdd'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actLoadSite: TMultiAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      ActionList = <
        item
          Action = actOpenCheckSite
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
      Caption = 'Site'
    end
    object actOpenCheckSite_Search: TOpenChoiceForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenCheckSite_Search'
      FormName = 'TCheckSite_SearchForm'
      FormNameParam.Value = 'TCheckSite_SearchForm'
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
          Value = Null
          Component = FormParams
          ComponentItem = 'OperDateSP'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'SPTax'
          Value = 0.000000000000000000
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
        end
        item
          Name = 'ManualDiscount'
          Value = Null
          Component = FormParams
          ComponentItem = 'ManualDiscount'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeID'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoCodeID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoName'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeGUID'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoCodeGUID'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeChangePercent'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'PromoCodeChangePercent'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberSPId'
          Value = Null
          Component = FormParams
          ComponentItem = 'MemberSPID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'SiteDiscount'
          Value = Null
          Component = FormParams
          ComponentItem = 'SiteDiscount'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionDateKindId'
          Value = Null
          Component = FormParams
          ComponentItem = 'PartionDateKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'LoyaltyChangeSumma'
          Value = Null
          Component = FormParams
          ComponentItem = 'LoyaltyChangeSumma'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'SummCard'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'SummCard'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'isBanAdd'
          Value = Null
          Component = FormParams
          ComponentItem = 'isBanAdd'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actLoadSite_Search: TMultiAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      ActionList = <
        item
          Action = actOpenCheckSite_Search
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
      Caption = 'actLoadSite_Search'
    end
    object actOpenDelaySite: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1088#1086#1095#1077#1085#1085#1099#1077'  '#1095#1077#1082#1080' '#1089' '#1089#1072#1081#1090#1072' "'#1058#1072#1073#1083#1077#1090#1082#1080'"'
      FormName = 'TCheckDelaySiteForm'
      FormNameParam.Value = 'TCheckDelaySiteForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actShowPUSH_UKTZED: TdsdShowPUSHMessage
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spShowPUSH_UKTZED
      StoredProcList = <
        item
          StoredProc = spShowPUSH_UKTZED
        end>
      Caption = 'actShowPUSH_UKTZED'
      PUSHMessageType = pmtInformation
    end
    object actGoodsSP_Cash: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1058#1086#1074#1072#1088#1099' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072'  "'#1044#1086#1089#1090#1091#1087#1085#1110' '#1051#1110#1082#1080'"'
      Hint = #1058#1086#1074#1072#1088#1099' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072'  "'#1044#1086#1089#1090#1091#1087#1085#1110' '#1051#1110#1082#1080'"'
      FormName = 'TGoodsSP_CashForm'
      FormNameParam.Value = 'TGoodsSP_CashForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actLoadVIPOrder: TMultiAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      ActionList = <
        item
          Action = actExecLoadVIPOrder
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
    object actExecLoadVIPOrder: TdsdExecStoredProc
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectChechHead
      StoredProcList = <
        item
          StoredProc = spSelectChechHead
        end>
      Caption = 'actExecLoadVIPOrder'
    end
    object actOpenCheckLiki24: TOpenChoiceForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenCheckLiki24'
      FormName = 'TCheckLiki24Form'
      FormNameParam.Value = 'TCheckLiki24Form'
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
          Value = Null
          Component = FormParams
          ComponentItem = 'OperDateSP'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'SPTax'
          Value = 0.000000000000000000
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
        end
        item
          Name = 'ManualDiscount'
          Value = Null
          Component = FormParams
          ComponentItem = 'ManualDiscount'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeID'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoCodeID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoName'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeGUID'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoCodeGUID'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeChangePercent'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'PromoCodeChangePercent'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberSPId'
          Value = Null
          Component = FormParams
          ComponentItem = 'MemberSPID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'SiteDiscount'
          Value = Null
          Component = FormParams
          ComponentItem = 'SiteDiscount'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionDateKindId'
          Value = Null
          Component = FormParams
          ComponentItem = 'PartionDateKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'LoyaltyChangeSumma'
          Value = Null
          Component = FormParams
          ComponentItem = 'LoyaltyChangeSumma'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'SummCard'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'SummCard'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'isBanAdd'
          Value = Null
          Component = FormParams
          ComponentItem = 'isBanAdd'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenCheckLiki24_Search: TOpenChoiceForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenCheckLiki24_Search'
      FormName = 'TCheckLiki24_SearchForm'
      FormNameParam.Value = 'TCheckLiki24_SearchForm'
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
          Value = Null
          Component = FormParams
          ComponentItem = 'OperDateSP'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'SPTax'
          Value = 0.000000000000000000
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
        end
        item
          Name = 'ManualDiscount'
          Value = Null
          Component = FormParams
          ComponentItem = 'ManualDiscount'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeID'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoCodeID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoName'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeGUID'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoCodeGUID'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoCodeChangePercent'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'PromoCodeChangePercent'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberSPId'
          Value = Null
          Component = FormParams
          ComponentItem = 'MemberSPID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'SiteDiscount'
          Value = Null
          Component = FormParams
          ComponentItem = 'SiteDiscount'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionDateKindId'
          Value = Null
          Component = FormParams
          ComponentItem = 'PartionDateKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'LoyaltyChangeSumma'
          Value = Null
          Component = FormParams
          ComponentItem = 'LoyaltyChangeSumma'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'SummCard'
          Value = 0.000000000000000000
          Component = FormParams
          ComponentItem = 'SummCard'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'isBanAdd'
          Value = Null
          Component = FormParams
          ComponentItem = 'isBanAdd'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenDelayLiki24: TdsdOpenForm
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1088#1086#1095#1077#1085#1085#1099#1077'  '#1095#1077#1082#1080' '#1089' '#1089#1072#1081#1090#1072' "Liki24"'
      FormName = 'TCheckDelayLiki24Form'
      FormNameParam.Value = 'TCheckDelayLiki24Form'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actLoadLiki24: TMultiAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      ActionList = <
        item
          Action = actOpenCheckLiki24
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
      Caption = 'actLoadLiki24'
    end
    object actLoadLiki24_Search: TMultiAction
      Category = #1044#1086#1082#1091#1084#1077#1085#1090#1099
      MoveParams = <>
      ActionList = <
        item
          Action = actOpenCheckLiki24_Search
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
      Caption = 'actLoadLiki24_Search'
    end
    object actInstructionsCash: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1085#1089#1090#1088#1091#1082#1094#1080#1080
      ShortCut = 16463
      FormName = 'TInstructionsCashForm'
      FormNameParam.Value = 'TInstructionsCashForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
    object actRecipeNumber1303: TAction
      Category = 'DSDLib'
      Caption = #1042#1074#1086#1076' '#1085#1086#1084#1077#1088#1072' '#1088#1077#1094#1077#1087#1090#1072' '#1087#1088#1086#1075#1088#1072#1084#1084#1099' 1303'
      ShortCut = 32882
      OnExecute = actRecipeNumber1303Execute
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
    ChartList = <>
    ColorRuleList = <
      item
        ColorColumn = MainColCode
        ValueColumn = MainColor_ExpirationDate
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
      end
      item
        ColorColumn = MainisPartionDateKindName
        ValueColumn = MainColor_ExpirationDate
        BackGroundValueColumn = MainColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MainPricePartionDate
        ValueColumn = MainColor_ExpirationDate
        BackGroundValueColumn = MainColor_calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 600
    Top = 40
  end
  object RemainsDS: TDataSource
    DataSet = RemainsCDS
    Left = 256
    Top = 48
  end
  object RemainsCDS: TClientDataSet
    Aggregates = <>
    Filter = 'Remains <> 0 or Reserved <> 0 or DeferredSend <> 0'
    Filtered = True
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'Id'
    Params = <>
    StoreDefs = True
    Left = 216
    Top = 48
  end
  object PopupMenu: TPopupMenu
    Left = 112
    Top = 264
    object N1: TMenuItem
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      OnClick = N1Click
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
    object N25: TMenuItem
      Action = actSetSPHelsi
    end
    object N13031: TMenuItem
      Action = actRecipeNumber1303
    end
    object N15: TMenuItem
      Caption = #1051#1080#1089#1090' '#1086#1090#1082#1072#1079#1072
      object N16: TMenuItem
        Action = actListDiffAddGoods
      end
      object N19: TMenuItem
        Action = actListGoods
      end
      object N17: TMenuItem
        Caption = '-'
      end
      object N20: TMenuItem
        Action = actCashListDiffPeriod
      end
      object N18: TMenuItem
        Action = actShowListDiff
      end
    end
    object N30: TMenuItem
      Caption = #1054#1090#1095#1077#1090#1099
      object actReportGoodsRemainsCash1: TMenuItem
        Action = actReport_GoodsRemainsCash
      end
      object N37: TMenuItem
        Action = actReport_ImplementationPlanEmployee
      end
      object N38: TMenuItem
        Action = actReport_IlliquidReductionPlanAll
      end
      object N53: TMenuItem
        Action = actGoodsSP_Cash
      end
      object N57: TMenuItem
        Action = actInstructionsCash
      end
      object N33: TMenuItem
        Caption = '-'
      end
      object N40: TMenuItem
        Action = actSaveHardwareData
      end
      object N34: TMenuItem
        Action = actInventoryEveryMonth
      end
    end
    object N47: TMenuItem
      Caption = #1061#1086#1079#1103#1081#1089#1090#1074#1077#1085#1085#1099#1081' '#1080#1085#1074#1077#1085#1090#1072#1088#1100
      object N45: TMenuItem
        Action = actIncomeHouseholdInventoryCashJournal
      end
      object N46: TMenuItem
        Action = actReport_HouseholdInventoryRemainsCash
      end
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
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1086#1089#1090#1072#1090#1086#1082
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1086#1089#1090#1072#1090#1086#1082
      ShortCut = 115
      OnClick = N10Click
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
      Action = actOpenMCS
    end
    object actOpenCheckVIPError1: TMenuItem
      Action = actOpenCheckVIP_Error
    end
    object miOpenGoodsSP_UserForm: TMenuItem
      Action = actOpenMovementSP
    end
    object miSetPromo: TMenuItem
      Action = actSetPromoCode
    end
    object N36: TMenuItem
      Action = actSetPromoCodeLoyalty
    end
    object N39: TMenuItem
      Action = actSetLoyaltySaveMoney
    end
    object pmPromoCodeDoctor: TMenuItem
      Action = actPromoCodeDoctor
    end
    object miManualDiscount: TMenuItem
      Action = actManualDiscount
    end
    object N21: TMenuItem
      Action = actSetSiteDiscount
    end
    object miPrintNotFiscalCheck: TMenuItem
      Caption = #1055#1077#1095#1072#1090#1100' '#1085#1077#1092#1080#1089#1082#1072#1083#1100#1085#1086#1075#1086' '#1095#1077#1082#1072
      OnClick = miPrintNotFiscalCheckClick
    end
    object mmSaveToExcel: TMenuItem
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1074' '#1101#1082#1089#1077#1083#1100
      OnClick = mmSaveToExcelClick
    end
    object mmDeleteAccommodation: TMenuItem
      Caption = #1059#1076#1072#1083#1077#1085#1080#1077' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1090#1086#1074#1072#1088#1086#1074' '#1082' '#1088#1072#1079#1084#1077#1097#1077#1085#1080#1102
      Hint = #1059#1076#1072#1083#1077#1085#1080#1077' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1090#1086#1074#1072#1088#1086#1074' '#1082' '#1088#1072#1079#1084#1077#1097#1077#1085#1080#1102
      object N26: TMenuItem
        Action = actDeleteAccommodation
      end
      object N27: TMenuItem
        Action = actDeleteAccommodationAllId
      end
      object N28: TMenuItem
        Caption = '-'
      end
      object N29: TMenuItem
        Action = actDeleteAccommodationAll
      end
    end
    object N11: TMenuItem
      Action = actExpirationDateFilter
    end
    object N22: TMenuItem
      Caption = #1047#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1074#1088#1077#1084#1077#1085#1080' '#1087#1088#1080#1093#1086#1076#1072
      ShortCut = 16468
      OnClick = N22Click
    end
    object actUpdateRemainsCDS1: TMenuItem
      Action = actDoesNotShare
    end
    object N23: TMenuItem
      Action = actGoodsAnalog
    end
    object N24: TMenuItem
      Action = actGoodsAnalogChoose
    end
    object N35: TMenuItem
      Action = actNotTransferTime
    end
    object N41: TMenuItem
      Action = actUpdateProgram
      ShortCut = 16469
    end
    object N43: TMenuItem
      Action = actOverdueChangeCashJournal
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
        Name = 'MemberSP'
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
        Value = Null
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
        Name = 'ManualDiscount'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummPayAdd'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ZReportName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberSPID'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'SiteDiscount'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankPOSTerminal'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'JackdawsChecksCode'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementSPId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 43678d
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'RoundingDown'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'HelsiID'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'HelsiIDList'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'HelsiName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'HelsiQty'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ConfirmationCodeSP'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionDateKindId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = Null
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'LoyaltySignID'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'LoyaltyText'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LoyaltyChangeSumma'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LoyaltyShowMessage'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'LoyaltySMID'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'LoyaltySMSumma'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LoyaltySMText'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LoyaltyMovementId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'LoyaltyPresent'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'LoyaltyAmountPresent'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LoyaltyGoodsId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Price1303'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummCard'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DivisionPartiesID'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'DivisionPartiesName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AddPresent'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'MedicForSale'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BuyerForSale'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BuyerForSalePhone'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isBanAdd'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'DistributionPromoList'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MedicKashtanId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'MedicKashtanName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberKashtanId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberKashtanName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCorrectMarketing'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCorrectIlliquidAssets'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'CheckOldId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 32
    Top = 24
  end
  object spSelectCheck: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_CheckLoadCash'
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
      end
      item
        Name = 'Remains'
        DataType = ftFloat
      end
      item
        Name = 'Color_calc'
        DataType = ftInteger
      end
      item
        Name = 'Color_ExpirationDate'
        DataType = ftInteger
      end
      item
        Name = 'AccommodationName'
        DataType = ftString
        Size = 200
      end
      item
        Name = 'Multiplicity'
        DataType = ftCurrency
      end
      item
        Name = 'DoesNotShare'
        DataType = ftBoolean
      end
      item
        Name = 'IdSP'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'ProgramIdSP'
        DataType = ftString
        Size = 60
      end
      item
        Name = 'CountSP'
        DataType = ftFloat
      end
      item
        Name = 'PriceRetSP'
        DataType = ftFloat
      end
      item
        Name = 'PaymentSP'
        DataType = ftFloat
      end
      item
        Name = 'PartionDateKindId'
        DataType = ftInteger
      end
      item
        Name = 'PartionDateKindName'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'PricePartionDate'
        DataType = ftFloat
      end
      item
        Name = 'AmountMonth'
        DataType = ftFloat
      end
      item
        Name = 'TypeDiscount'
        DataType = ftInteger
      end
      item
        Name = 'PriceDiscount'
        DataType = ftFloat
      end
      item
        Name = 'NDSKindId'
        DataType = ftInteger
      end
      item
        Name = 'DiscountExternalID'
        DataType = ftInteger
      end
      item
        Name = 'DiscountExternalName'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'UKTZED'
        DataType = ftString
        Size = 20
      end
      item
        Name = 'GoodsPairSunId'
        DataType = ftInteger
      end
      item
        Name = 'GoodsPairSunMainId'
        DataType = ftInteger
      end
      item
        Name = 'DivisionPartiesID'
        DataType = ftInteger
      end
      item
        Name = 'DivisionPartiesName'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'isPresent'
        DataType = ftBoolean
      end
      item
        Name = 'MultiplicitySale'
        DataType = ftFloat
      end
      item
        Name = 'isMultiplicityError'
        DataType = ftBoolean
      end
      item
        Name = 'FixEndDate'
        DataType = ftDateTime
      end>
    IndexDefs = <
      item
        Name = 'CheckCDSIndex1'
      end>
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
    ChartList = <>
    ColorRuleList = <
      item
        ColorColumn = CheckGridColCode
        ValueColumn = CheckGridColor_ExpirationDate
        BackGroundValueColumn = CheckGridColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = CheckGridColName
        ValueColumn = CheckGridColor_ExpirationDate
        BackGroundValueColumn = CheckGridColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = CheckGridColAmount
        ValueColumn = CheckGridColor_ExpirationDate
        BackGroundValueColumn = CheckGridColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = CheckGridColAmount
        ValueColumn = CheckGridColor_ExpirationDate
        BackGroundValueColumn = CheckGridColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = CheckGridColPrice
        ValueColumn = CheckGridColor_ExpirationDate
        BackGroundValueColumn = CheckGridColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = CheckGridColSumm
        ValueColumn = CheckGridColor_ExpirationDate
        BackGroundValueColumn = CheckGridColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = CheckGridColPriceSale
        ValueColumn = CheckGridColor_ExpirationDate
        BackGroundValueColumn = CheckGridColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = CheckGridColChangePercent
        ValueColumn = CheckGridColor_ExpirationDate
        BackGroundValueColumn = CheckGridColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = CheckGridColAmountOrder
        ValueColumn = CheckGridColor_ExpirationDate
        BackGroundValueColumn = CheckGridColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = CheckGridAccommodationName
        ValueColumn = CheckGridColor_ExpirationDate
        BackGroundValueColumn = CheckGridColor_calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 496
    Top = 312
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
    ChartList = <>
    ColorRuleList = <
      item
        BackGroundValueColumn = AlternativeGridColTypeColor
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 592
    Top = 336
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
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 112
    Top = 32
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
    Left = 264
    Top = 80
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
    Left = 264
    Top = 136
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
    Left = 200
    Top = 72
  end
  object TimerSaveAll: TTimer
    Enabled = False
    Interval = 360000
    OnTimer = TimerSaveAllTimer
    Left = 84
    Top = 16
  end
  object TimerMoneyInCash: TTimer
    Enabled = False
    Interval = 25000
    OnTimer = TimerMoneyInCashTimer
    Left = 456
    Top = 464
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
    Top = 136
  end
  object TimerBlinkBtn: TTimer
    Enabled = False
    OnTimer = TimerBlinkBtnTimer
    Left = 408
    Top = 464
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
      end
      item
        Name = 'outIsVIP'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsTabletki'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsLiki24'
        Value = Null
        DataType = ftBoolean
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
    Left = 488
    Top = 136
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
        Name = 'inPartionDate_list'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNDS_list'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDivisionPartiesId_list'
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
    Left = 400
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
        Value = Null
        Component = RemainsCDS
        ComponentItem = 'StartDateMCSAuto'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEndDateMCSAuto'
        Value = Null
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
    Left = 352
    Top = 48
  end
  object MemData: TdxMemData
    Indexes = <>
    SortOptions = []
    Left = 160
    Top = 48
    object MemDataID: TIntegerField
      FieldName = 'ID'
    end
    object MemDataGOODSCODE: TIntegerField
      FieldName = 'GOODSCODE'
    end
    object MemDataGOODSNAME: TStringField
      FieldName = 'GOODSNAME'
      Size = 254
    end
    object MemDataPRICE: TFloatField
      FieldName = 'PRICE'
    end
    object MemDataNDS: TFloatField
      FieldName = 'NDS'
    end
    object MemDataNDSKINDID: TIntegerField
      FieldName = 'NDSKINDID'
    end
    object MemDataREMAINS: TFloatField
      FieldName = 'REMAINS'
    end
    object MemDataMCSVALUE: TFloatField
      FieldName = 'MCSVALUE'
    end
    object MemDataRESERVED: TFloatField
      FieldName = 'RESERVED'
    end
    object MemDataMEXPDATE: TDateTimeField
      FieldName = 'MEXPDATE'
    end
    object MemDataPDKINDID: TIntegerField
      FieldName = 'PDKINDID'
    end
    object MemDataPDKINDNAME: TStringField
      FieldName = 'PDKINDNAME'
      Size = 100
    end
    object MemDataNEWROW: TBooleanField
      FieldName = 'NEWROW'
    end
    object MemDataACCOMID: TIntegerField
      FieldName = 'ACCOMID'
    end
    object MemDataACCOMNAME: TStringField
      DisplayWidth = 20
      FieldName = 'ACCOMNAME'
    end
    object MemDataAMOUNTMON: TFloatField
      FieldName = 'AMOUNTMON'
    end
    object MemDataPricePD: TFloatField
      FieldName = 'PRICEPD'
    end
    object MemDataCOLORCALC: TIntegerField
      FieldName = 'COLORCALC'
    end
    object MemDataDEFERENDS: TFloatField
      FieldName = 'DEFERENDS'
    end
    object MemDataREMAINSSUN: TFloatField
      FieldName = 'REMAINSSUN'
    end
    object MemDataDISCEXTID: TIntegerField
      FieldName = 'DISCEXTID'
    end
    object MemDataDISCEXTNAME: TStringField
      FieldName = 'DISCEXTNAME'
      Size = 100
    end
    object MemDataGOODSDIID: TIntegerField
      FieldName = 'GOODSDIID'
    end
    object MemDataGOODSDINAME: TStringField
      FieldName = 'GOODSDINAME'
      Size = 100
    end
    object MemDataUKTZED: TStringField
      FieldName = 'UKTZED'
    end
    object MemDataGOODSPSID: TIntegerField
      FieldName = 'GOODSPSID'
    end
    object MemDataDIVPARTID: TIntegerField
      FieldName = 'DIVPARTID'
    end
    object MemDataDIVPARTNAME: TStringField
      FieldName = 'DIVPARTNAME'
      Size = 100
    end
    object MemDataBANFISCAL: TBooleanField
      FieldName = 'BANFISCAL'
    end
    object MemDataGOODSPROJ: TBooleanField
      FieldName = 'GOODSPROJ'
    end
    object MemDataGOODSPMID: TIntegerField
      FieldName = 'GOODSPMID'
    end
    object MemDataGOODSDIMP: TFloatField
      FieldName = 'GOODSDIMP'
    end
  end
  object mdCheck: TdxMemData
    Indexes = <>
    SortOptions = []
    Left = 456
    Top = 48
    object mdCheckID: TIntegerField
      FieldName = 'ID'
    end
    object mdCheckPDKINDID: TIntegerField
      FieldName = 'PDKINDID'
    end
    object mdCheckNDSKINDID: TIntegerField
      FieldName = 'NDSKINDID'
    end
    object mdCheckDISCEXTID: TIntegerField
      FieldName = 'DISCEXTID'
    end
    object mdCheckDIVPARTID: TIntegerField
      FieldName = 'DIVPARTID'
    end
    object mdCheckAMOUNT: TCurrencyField
      FieldName = 'AMOUNT'
    end
  end
  object SaveExcelDialog: TSaveDialog
    Filter = 'Excel files (*.xls)|*.xls'
    Left = 648
    Top = 56
  end
  object TimerServiceRun: TTimer
    Enabled = False
    OnTimer = TimerServiceRunTimer
    Left = 728
    Top = 56
  end
  object spUpdate_Accommodation: TdsdStoredProc
    StoredProcName = 'gpUpdate_Cash_Accommodation'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsId'
        Value = Null
        Component = RemainsCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAccommodationId'
        Value = Null
        Component = RemainsCDS
        ComponentItem = 'AccommodationId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAccommodationName'
        Value = Null
        Component = RemainsCDS
        ComponentItem = 'AccommodationName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 56
    Top = 171
  end
  object spGet_PromoCode_by_GUID: TdsdStoredProc
    StoredProcName = 'gpGet_PromoCode_by_GUID'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inPromoGUID'
        Value = ''
        Component = FormParams
        ComponentItem = 'PromoCodeGUID'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPromoCodeID'
        Value = 0
        Component = FormParams
        ComponentItem = 'PromoCodeID'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPromoName'
        Value = ''
        Component = FormParams
        ComponentItem = 'PromoName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBayerName'
        Value = Null
        Component = FormParams
        ComponentItem = 'BayerName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPromoCodeChangePercent'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'PromoCodeChangePercent'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 192
    Top = 168
  end
  object spDelete_Accommodation: TdsdStoredProc
    StoredProcName = 'gpDelete_Cash_Accommodation'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsId'
        Value = Null
        Component = RemainsCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 224
    Top = 379
  end
  object pm_OpenVIP: TPopupMenu
    Left = 520
    Top = 416
    object VIP6: TMenuItem
      Tag = 1
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1074#1089#1077#1093' '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1093' '#1095#1077#1082#1086#1074
      OnClick = pm_VIP1Click
    end
    object VIP7: TMenuItem
      Tag = 2
      Caption = #1055#1086#1080#1089#1082' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1086#1074' '#1074#1086' '#1074#1089#1077#1093'  '#1086#1090#1083#1086#1078#1077#1085#1085#1099#1093' '#1095#1077#1082#1072#1093
      OnClick = pm_VIP1Click
    end
    object VIP8: TMenuItem
      Action = actOpenDelayDeferred
    end
    object N52: TMenuItem
      Caption = '-'
    end
    object pm_VIP1: TMenuItem
      Tag = 11
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' VIP '#1095#1077#1082#1086#1074
      OnClick = pm_VIP1Click
    end
    object pm_VIP2: TMenuItem
      Tag = 12
      Caption = #1055#1086#1080#1089#1082' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1086#1074' '#1074' VIP '#1095#1077#1082#1072#1093
      OnClick = pm_VIP1Click
    end
    object VIP2: TMenuItem
      Action = actOpenDelayVIPForm
    end
    object N48: TMenuItem
      Caption = '-'
    end
    object N49: TMenuItem
      Tag = 21
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1095#1077#1082#1086#1074' '#1089' '#1089#1072#1081#1090#1072' "'#1058#1072#1073#1083#1077#1090#1082#1080'"'
      OnClick = pm_VIP1Click
    end
    object N50: TMenuItem
      Tag = 22
      Caption = #1055#1086#1080#1089#1082' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1086#1074' '#1074' '#1095#1077#1082#1072#1093' '#1089' '#1089#1072#1081#1090#1072' "'#1058#1072#1073#1083#1077#1090#1082#1080'"'
      OnClick = pm_VIP1Click
    end
    object N51: TMenuItem
      Action = actOpenDelaySite
    end
    object N54: TMenuItem
      Caption = '-'
    end
    object N55: TMenuItem
      Tag = 31
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1095#1077#1082#1086#1074' '#1089' '#1089#1072#1081#1090#1072' "Liki24"'
      OnClick = pm_VIP1Click
    end
    object N56: TMenuItem
      Tag = 32
      Caption = #1055#1086#1080#1089#1082' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1086#1074' '#1074' '#1095#1077#1082#1072#1093' '#1089' '#1089#1072#1081#1090#1072' "Liki24"'
      OnClick = pm_VIP1Click
    end
    object Liki241: TMenuItem
      Action = actOpenDelayLiki24
    end
  end
  object CashListDiffCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 704
    Top = 168
  end
  object spSelect_CashListDiffGoods: TdsdStoredProc
    StoredProcName = 'gpSelect_CashListDiffGoods'
    DataSet = CashListDiffCDS
    DataSets = <
      item
        DataSet = CashListDiffCDS
      end>
    Params = <
      item
        Name = 'inGoodsId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiffKindID'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 688
    Top = 144
  end
  object spUpdate_CashSerialNumber: TdsdStoredProc
    StoredProcName = 'gpUpdate_CashSerialNumber'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inFiscalNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSerialNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 480
    Top = 176
  end
  object spGlobalConst_SiteDiscount: TdsdStoredProc
    StoredProcName = 'gpGet_GlobalConst_SiteDiscount '
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'gpget_globalconst_sitediscount'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 712
    Top = 56
  end
  object gpGet_Movement_GoodsSP_ID: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_GoodsSP_ID'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outMovementID'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementSPId'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 480
    Top = 232
  end
  object BankPOSTerminalCDS: TClientDataSet
    Aggregates = <>
    Filtered = True
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'Id'
    Params = <>
    StoreDefs = True
    Left = 48
    Top = 392
  end
  object UnitConfigCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'Id'
    Params = <>
    Left = 48
    Top = 448
  end
  object TaxUnitNightCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'PriceTaxUnitNight'
    Params = <>
    Left = 136
    Top = 448
  end
  object TimerPUSH: TTimer
    Enabled = False
    OnTimer = TimerPUSHTimer
    Left = 808
    Top = 56
  end
  object spGet_PUSH_Cash: TdsdStoredProc
    StoredProcName = 'gpGet_PUSH_Cash'
    DataSet = PUSHDS
    DataSets = <
      item
        DataSet = PUSHDS
      end>
    Params = <>
    PackSize = 1
    Left = 768
    Top = 56
  end
  object PUSHDS: TClientDataSet
    Aggregates = <>
    Filtered = True
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'Id'
    Params = <>
    StoreDefs = True
    Left = 768
    Top = 112
  end
  object spDoesNotShare: TdsdStoredProc
    StoredProcName = 'gpUodate_Cash_DoesNotShare'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsID'
        Value = Null
        Component = RemainsCDS
        ComponentItem = 'ID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDoesNotShare'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 592
    Top = 408
  end
  object spInsert_MovementItem_PUSH: TdsdStoredProc
    StoredProcName = 'gpInsert_MovementItem_PUSH_Cash'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovement'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inResult'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 752
    Top = 128
  end
  object spDelete_AccommodationAllID: TdsdStoredProc
    StoredProcName = 'gpDelete_Cash_AccommodationAllId'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inAccommodationId'
        Value = Null
        Component = RemainsCDS
        ComponentItem = 'AccommodationId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 224
    Top = 427
  end
  object spDelete_AccommodationAll: TdsdStoredProc
    StoredProcName = 'gpDelete_Cash_AccommodationAll'
    DataSets = <>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 352
    Top = 411
  end
  object ExpirationDateCDS: TClientDataSet
    Aggregates = <>
    Filtered = True
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'ID;ExpirationDate'
    Params = <>
    StoreDefs = True
    Left = 656
    Top = 328
  end
  object ExpirationDateDS: TDataSource
    DataSet = ExpirationDateCDS
    Left = 688
    Top = 408
  end
  object dsdDBViewAddOnExpirationDate: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = ExpirationDateView
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
    ChartList = <>
    ColorRuleList = <
      item
        BackGroundValueColumn = ExpirationDateColor_calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 688
    Top = 448
  end
  object spGet_Movement_InvNumberSP: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_InvNumberSP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inSPKindId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberSP'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsExists'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 56
    Top = 200
  end
  object pm_OpenCheck: TPopupMenu
    Left = 456
    Top = 416
    object pm_Check: TMenuItem
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1095#1077#1082#1086#1074
      OnClick = pm_CheckClick
    end
    object pm_CheckHelsi: TMenuItem
      Tag = 1
      Caption = #1057#1074#1077#1088#1082#1072' '#1095#1077#1082#1086#1074' '#1089' '#1061#1077#1083#1089#1080
      OnClick = pm_CheckHelsiClick
    end
    object pm_CheckHelsiAllUnit: TMenuItem
      Caption = #1057#1074#1077#1088#1082#1072' '#1095#1077#1082#1086#1074' '#1089' '#1061#1077#1083#1089#1080' '#1087#1086' '#1074#1089#1077#1084' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      OnClick = pm_CheckHelsiAllUnitClick
    end
    object pmOverdueJournal: TMenuItem
      Action = actOverdueJournal
    end
    object N31: TMenuItem
      Action = actSendCashJournal
    end
    object N32: TMenuItem
      Action = actSendCashJournalSun
    end
    object VIP5: TMenuItem
      Action = actSendCashJournalVip
    end
    object pmTechnicalRediscount: TMenuItem
      Action = actTechnicalRediscount
    end
    object pmTechnicalRediscountCashier: TMenuItem
      Action = actTechnicalRediscountCashier
    end
    object N42: TMenuItem
      Action = actSendPartionDateChangeCashJournal
    end
    object N44: TMenuItem
      Action = actReturnInJournal
    end
  end
  object TimerDroppedDown: TTimer
    Enabled = False
    Interval = 200
    OnTimer = TimerDroppedDownTimer
    Left = 512
    Top = 463
  end
  object TimerAnalogFilter: TTimer
    Enabled = False
    Interval = 50
    OnTimer = TimerAnalogFilterTimer
    Left = 528
    Top = 176
  end
  object cxEditRepository1: TcxEditRepository
    Left = 304
    Top = 264
    PixelsPerInch = 96
    object cxEditRepository1BlobItem1: TcxEditRepositoryBlobItem
      Properties.BlobEditKind = bekMemo
      Properties.BlobPaintStyle = bpsText
      Properties.ReadOnly = True
    end
  end
  object spInventoryEveryMonth: TdsdStoredProc
    StoredProcName = 'gpSelect_Cash_InventoryEveryMonth'
    DataSet = cdsInventoryEveryMonth
    DataSets = <
      item
        DataSet = cdsInventoryEveryMonth
      end>
    Params = <
      item
        Name = 'inRemainsDate'
        Value = 43678d
        Component = FormParams
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 544
    Top = 24
  end
  object cdsInventoryEveryMonth: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 520
    Top = 56
  end
  object spGet_BanCash: TdsdStoredProc
    StoredProcName = 'gpGet_EmployeeSchedule_Ban_Cash'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outBanCash'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 360
    Top = 176
  end
  object spLoyaltyGUID: TdsdStoredProc
    StoredProcName = 'gpInsert_MovementItem_Loyalty_GUID'
    DataSet = CashListDiffCDS
    DataSets = <
      item
        DataSet = CashListDiffCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGUID'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmount'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDateEnd'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessage'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 712
    Top = 248
  end
  object spLoyaltyCheckGUID: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Loyalty_GUID'
    DataSet = CashListDiffCDS
    DataSets = <
      item
        DataSet = CashListDiffCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inGUID'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outID'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmount'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outError'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMovementId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisPresent'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountPresent'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 712
    Top = 288
  end
  object spLoyaltyStatus: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Loyalty_Status'
    DataSet = CashListDiffCDS
    DataSets = <
      item
        DataSet = CashListDiffCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessage'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 712
    Top = 328
  end
  object spLoyaltySM: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_LoyaltySM_Cash'
    DataSet = LoyaltySMCDS
    DataSets = <
      item
        DataSet = LoyaltySMCDS
      end>
    Params = <
      item
        Name = 'inBuyerID'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 784
    Top = 248
  end
  object LoyaltySMCDS: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 784
    Top = 296
  end
  object spInsertMovementItem: TdsdStoredProc
    StoredProcName = 'gpInsert_MovementItem_LoyaltySaveMoney_Cash'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBuyerID'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 769
    Top = 341
  end
  object spLoyaltySaveMoneyChekInfo: TdsdStoredProc
    StoredProcName = 'gpSelect_LoyaltySaveMoney_ChekInfo'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummaCheck'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSumma'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outText'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 785
    Top = 389
  end
  object spCheckItem_SPKind_1303: TdsdStoredProc
    StoredProcName = 'gpSelect_CheckItem_SPKind_1303'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inSPKindId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceSale'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outError'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outError2'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSentence'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPrice'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 785
    Top = 437
  end
  object spGet_Movement_TechnicalRediscount_Id: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TechnicalRediscount_Cash_Id'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outMovementId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 785
    Top = 485
  end
  object spUpdateHardwareDataCash: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_CashRegister_HardwareData'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inSerial'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxRate'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIdentifier'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisLicense'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSmartphone'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisModem'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisBarcodeScanner'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComputerName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBaseBoardProduct'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProcessorName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiskDriveModel'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPhysicalMemory'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 608
    Top = 96
  end
  object spUpdateHardwareData: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Hardware_HardwareData'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inIdentifier'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisLicense'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSmartphone'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisModem'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisBarcodeScanner'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComputerName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBaseBoardProduct'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProcessorName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiskDriveModel'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPhysicalMemory'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 608
    Top = 144
  end
  object spShowPUSH_UKTZED: TdsdStoredProc
    StoredProcName = 'gpSelect_Cash_ShowPUSH_UKTZED'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsId'
        Value = Null
        Component = CheckCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outShowMessage'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPUSHType'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outText'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 47
    Top = 488
  end
  object spSelectChechHead: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_CheckLoadCash'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inVIPOrder'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ID'
        Value = Null
        Component = FormParams
        ComponentItem = 'CheckId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BayerName'
        Value = Null
        Component = FormParams
        ComponentItem = 'BayerName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashMemberId'
        Value = Null
        Component = FormParams
        ComponentItem = 'ManagerId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashMember'
        Value = Null
        Component = FormParams
        ComponentItem = 'ManagerName'
        DataType = ftString
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
        Value = Null
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
      end
      item
        Name = 'ManualDiscount'
        Value = Null
        Component = FormParams
        ComponentItem = 'ManualDiscount'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoCodeID'
        Value = Null
        Component = FormParams
        ComponentItem = 'PromoCodeID'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoName'
        Value = Null
        Component = FormParams
        ComponentItem = 'PromoName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoCodeGUID'
        Value = Null
        Component = FormParams
        ComponentItem = 'PromoCodeGUID'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoCodeChangePercent'
        Value = Null
        Component = FormParams
        ComponentItem = 'PromoCodeChangePercent'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberSPId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MemberSPID'
        MultiSelectSeparator = ','
      end
      item
        Name = 'SiteDiscount'
        Value = Null
        Component = FormParams
        ComponentItem = 'SiteDiscount'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionDateKindId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionDateKindId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'LoyaltyChangeSumma'
        Value = Null
        Component = FormParams
        ComponentItem = 'LoyaltyChangeSumma'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummCard'
        Value = Null
        Component = FormParams
        ComponentItem = 'SummCard'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isBanAdd'
        Value = Null
        Component = FormParams
        ComponentItem = 'isBanAdd'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    AutoWidth = True
    Left = 160
    Top = 192
  end
  object PlanEmployeeCDS: TClientDataSet
    Aggregates = <>
    Filtered = True
    FieldDefs = <>
    IndexDefs = <>
    IndexFieldNames = 'GoodsCode'
    Params = <>
    StoreDefs = True
    Left = 168
    Top = 504
  end
  object spPullGoodsCheck: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_PullGoodsCheck'
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
        Name = 'inMovementItemId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMovementId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 864
    Top = 104
  end
  object spSelectCheckId: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_CheckLoadCashId'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ID'
        Value = Null
        Component = FormParams
        ComponentItem = 'CheckId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BayerName'
        Value = Null
        Component = FormParams
        ComponentItem = 'BayerName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashMemberId'
        Value = Null
        Component = FormParams
        ComponentItem = 'ManagerId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashMember'
        Value = Null
        Component = FormParams
        ComponentItem = 'ManagerName'
        DataType = ftString
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
        Value = Null
        Component = FormParams
        ComponentItem = 'OperDateSP'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'SPTax'
        Value = 0.000000000000000000
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
      end
      item
        Name = 'ManualDiscount'
        Value = Null
        Component = FormParams
        ComponentItem = 'ManualDiscount'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoCodeID'
        Value = Null
        Component = FormParams
        ComponentItem = 'PromoCodeID'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoName'
        Value = Null
        Component = FormParams
        ComponentItem = 'PromoName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoCodeGUID'
        Value = Null
        Component = FormParams
        ComponentItem = 'PromoCodeGUID'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoCodeChangePercent'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'PromoCodeChangePercent'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberSPId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MemberSPID'
        MultiSelectSeparator = ','
      end
      item
        Name = 'SiteDiscount'
        Value = Null
        Component = FormParams
        ComponentItem = 'SiteDiscount'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionDateKindId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PartionDateKindId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'LoyaltyChangeSumma'
        Value = Null
        Component = FormParams
        ComponentItem = 'LoyaltyChangeSumma'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummCard'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'SummCard'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isBanAdd'
        Value = Null
        Component = FormParams
        ComponentItem = 'isBanAdd'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    AutoWidth = True
    Left = 864
    Top = 168
  end
end
