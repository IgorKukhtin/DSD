inherited PromoManagerForm: TPromoManagerForm
  ActiveControl = edOperDate
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1040#1082#1094#1080#1103'> ('#1088#1091#1082#1086#1074#1086#1076#1080#1090#1077#1083#1100')'
  ClientHeight = 684
  ClientWidth = 1366
  ExplicitWidth = 1382
  ExplicitHeight = 723
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 139
    Width = 1366
    Height = 545
    Properties.ActivePage = cxTabSheetCalc
    ExplicitTop = 139
    ExplicitWidth = 1366
    ExplicitHeight = 545
    ClientRectBottom = 545
    ClientRectRight = 1366
    object cxTabSheetCalc: TcxTabSheet [0]
      Caption = #1050#1072#1083#1100#1082#1091#1083#1103#1090#1086#1088
      ImageIndex = 1
      object cxGridCalc: TcxGrid
        Left = 0
        Top = 0
        Width = 1366
        Height = 176
        Align = alClient
        TabOrder = 0
        LookAndFeel.NativeStyle = False
        object cxGridDBTableViewCalc: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = CalcDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Filter.Active = True
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.IncSearch = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.GroupByBox = False
          OptionsView.HeaderHeight = 40
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object calcText: TcxGridDBColumn
            Caption = 'C/c'
            DataBinding.FieldName = 'Text'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 64
          end
          object calcNum: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'Num'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object calcGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 47
          end
          object calcGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object calcMeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object calcGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076
            DataBinding.FieldName = 'GoodsKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object calcGoodsKindCompleteName: TcxGridDBColumn
            Caption = #1042#1080#1076' ('#1087#1088#1080#1084#1077#1095#1072#1085#1080#1077')'
            DataBinding.FieldName = 'GoodsKindCompleteName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' ('#1087#1088#1080#1084#1077#1095#1072#1085#1080#1077')'
            Options.Editing = False
            Width = 85
          end
          object calcPriceIn: TcxGridDBColumn
            Caption = #1057#1077#1073'-'#1090#1100' '#1087#1088#1086#1076', '#1075#1088#1085'/'#1082#1075
            DataBinding.FieldName = 'PriceIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 81
          end
          object calcTaxRetIn: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1075#1088#1085'/'#1082#1075
            DataBinding.FieldName = 'TaxRetIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object calcContractCondition: TcxGridDBColumn
            Caption = #1041#1086#1085#1091#1089' '#1089#1077#1090#1080', '#1075#1088#1085'/'#1082#1075
            DataBinding.FieldName = 'ContractCondition'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 81
          end
          object calcAmountSale: TcxGridDBColumn
            Caption = #1054#1090#1075#1088'. '#1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'AmountSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object calcAmountSaleWeight: TcxGridDBColumn
            Caption = #1054#1090#1075#1088'. '#1074#1077#1089
            DataBinding.FieldName = 'AmountSaleWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object calcSummaSale: TcxGridDBColumn
            Caption = #1054#1090#1075'.'#1075#1088#1085
            DataBinding.FieldName = 'SummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object calcPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089#1086#1074#1072#1103' '#1089' '#1053#1044#1057', '#1075#1088#1085
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089#1086#1074#1072#1103' '#1089' '#1053#1044#1057', '#1075#1088#1085
            Options.Editing = False
            Width = 108
          end
          object calcTaxPromo: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072', '#1075#1088#1085
            DataBinding.FieldName = 'TaxPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object calcPriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080', '#1075#1088#1085'/'#1082#1075
            DataBinding.FieldName = 'PriceWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 119
          end
          object Color_PriceWithVAT: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PriceWithVAT'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object CountForPrice: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object calcSummaProfit: TcxGridDBColumn
            Caption = #1055#1088#1080#1073#1099#1083#1100', '#1075#1088#1085
            DataBinding.FieldName = 'SummaProfit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Options.FilteringPopup = False
            Width = 101
          end
          object Color_PriceIn: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PriceIn'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object Color_RetIn: TcxGridDBColumn
            DataBinding.FieldName = 'Color_RetIn'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object Color_ContractCond: TcxGridDBColumn
            DataBinding.FieldName = 'Color_ContractCond'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object Color_AmountSale: TcxGridDBColumn
            DataBinding.FieldName = 'Color_AmountSale'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object Color_SummaSale: TcxGridDBColumn
            DataBinding.FieldName = 'Color_SummaSale'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object Color_Price: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Price'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object Color_PromoCond: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PromoCond'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object Color_SummaProfit: TcxGridDBColumn
            DataBinding.FieldName = 'Color_SummaProfit'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object calcGroupNum: TcxGridDBColumn
            DataBinding.FieldName = 'GroupNum'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
          object calcSummaProfit_Condition: TcxGridDBColumn
            Caption = #1055#1088#1080#1073#1099#1083#1100', '#1075#1088#1085' ('#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1103')'
            DataBinding.FieldName = 'SummaProfit_Condition'
            Visible = False
            VisibleForCustomization = False
            Width = 70
          end
          object calcTaxPromo_Condition: TcxGridDBColumn
            Caption = #1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1103', '#1075#1088#1085
            DataBinding.FieldName = 'TaxPromo_Condition'
            Visible = False
            VisibleForCustomization = False
          end
          object Repository: TcxGridDBColumn
            DataBinding.FieldName = 'Repository'
            Visible = False
            VisibleForCustomization = False
            Width = 20
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBTableViewCalc
        end
      end
      object cxGridCalc2: TcxGrid
        Left = 0
        Top = 184
        Width = 1366
        Height = 153
        Align = alBottom
        TabOrder = 1
        LookAndFeel.NativeStyle = False
        object cxGridDBTableViewCalc2: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = CalcDS2
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Filter.Active = True
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.IncSearch = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.GroupByBox = False
          OptionsView.HeaderHeight = 40
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object ccText: TcxGridDBColumn
            Caption = 'C/c'
            DataBinding.FieldName = 'Text'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ссNum: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'Num'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object ссGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 47
          end
          object ссGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object ccMeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object ссGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076
            DataBinding.FieldName = 'GoodsKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ссGoodsKindCompleteName: TcxGridDBColumn
            Caption = #1042#1080#1076' ('#1087#1088#1080#1084#1077#1095#1072#1085#1080#1077')'
            DataBinding.FieldName = 'GoodsKindCompleteName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' ('#1087#1088#1080#1084#1077#1095#1072#1085#1080#1077')'
            Options.Editing = False
            Width = 85
          end
          object ссPriceIn: TcxGridDBColumn
            Caption = #1057#1077#1073'-'#1090#1100' '#1087#1088#1086#1076', '#1075#1088#1085'/'#1082#1075
            DataBinding.FieldName = 'PriceIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 81
          end
          object ссTaxRetIn: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1075#1088#1085'/'#1082#1075
            DataBinding.FieldName = 'TaxRetIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object ссContractCondition: TcxGridDBColumn
            Caption = #1041#1086#1085#1091#1089' '#1089#1077#1090#1080', '#1075#1088#1085'/'#1082#1075
            DataBinding.FieldName = 'ContractCondition'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 81
          end
          object ссAmountSale: TcxGridDBColumn
            Caption = #1054#1090#1075#1088'. '#1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'AmountSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object ссAmountSaleWeight: TcxGridDBColumn
            Caption = #1054#1090#1075#1088'. '#1074#1077#1089
            DataBinding.FieldName = 'AmountSaleWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object ссSummaSale: TcxGridDBColumn
            Caption = #1054#1090#1075'.'#1075#1088#1085
            DataBinding.FieldName = 'SummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ссPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089#1086#1074#1072#1103' '#1089' '#1053#1044#1057', '#1075#1088#1085
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089#1086#1074#1072#1103' '#1089' '#1053#1044#1057', '#1075#1088#1085
            Options.Editing = False
            Width = 108
          end
          object ссTaxPromo_Condition: TcxGridDBColumn
            Caption = #1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1103' '#1087#1086' '#1076#1086#1087'.'#1089#1095#1077#1090#1091', '#1075#1088#1085'/'#1082#1075
            DataBinding.FieldName = 'TaxPromo_Condition'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1103' '#1087#1086' '#1076#1086#1087'.'#1089#1095#1077#1090#1091', '#1075#1088#1085'/'#1082#1075
            Options.Editing = False
            Width = 117
          end
          object ссPriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080', '#1075#1088#1085'/'#1082#1075
            DataBinding.FieldName = 'PriceWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 119
          end
          object ссSummaProfit: TcxGridDBColumn
            Caption = #1055#1088#1080#1073#1099#1083#1100', '#1075#1088#1085
            DataBinding.FieldName = 'SummaProfit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Options.FilteringPopup = False
            VisibleForCustomization = False
            Width = 101
          end
          object ссTaxPromo: TcxGridDBColumn
            Caption = #1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1103' '#1087#1086' '#1076#1086#1087'.'#1089#1095#1077#1090#1091', '#1075#1088#1085'/'#1082#1075
            DataBinding.FieldName = 'TaxPromo'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1103' '#1087#1086' '#1076#1086#1087'.'#1089#1095#1077#1090#1091', '#1075#1088#1085'/'#1082#1075
            VisibleForCustomization = False
            Width = 117
          end
          object ссSummaProfit_Condition: TcxGridDBColumn
            Caption = #1055#1088#1080#1073#1099#1083#1100', '#1075#1088#1085
            DataBinding.FieldName = 'SummaProfit_Condition'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 125
          end
          object ссColor_PriceIn: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PriceIn'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object ссColor_RetIn: TcxGridDBColumn
            DataBinding.FieldName = 'Color_RetIn'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object ссColor_ContractCond: TcxGridDBColumn
            DataBinding.FieldName = 'Color_ContractCond'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object ссColor_AmountSale: TcxGridDBColumn
            DataBinding.FieldName = 'Color_AmountSale'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object ссColor_SummaSale: TcxGridDBColumn
            DataBinding.FieldName = 'Color_SummaSale'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object ссColor_Price: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Price'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object ссColor_PriceWithVAT: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PriceWithVAT'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object ссColor_PromoCond: TcxGridDBColumn
            DataBinding.FieldName = 'Color_PromoCond'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object ссColor_SummaProfit: TcxGridDBColumn
            DataBinding.FieldName = 'Color_SummaProfit'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object ссGroupNum: TcxGridDBColumn
            DataBinding.FieldName = 'GroupNum'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
          object Repository2: TcxGridDBColumn
            DataBinding.FieldName = 'Repository'
            Visible = False
            VisibleForCustomization = False
            Width = 20
          end
        end
        object cxGridLevel5: TcxGridLevel
          GridView = cxGridDBTableViewCalc2
        end
      end
      object cxSplitter5: TcxSplitter
        Left = 0
        Top = 176
        Width = 1366
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = cxGridCalc2
      end
      object cxGridPromoStateKind: TcxGrid
        Left = 0
        Top = 345
        Width = 1366
        Height = 176
        Align = alBottom
        PopupMenu = PromoStateKindPopupMenu
        TabOrder = 3
        object cxGridDBTableViewPromoStateKind: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = PromoStateKindDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.IncSearch = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.CellAutoHeight = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object psOrd: TcxGridDBColumn
            Caption = #8470' '#1087'.'#1087'.'
            DataBinding.FieldName = 'Ord'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 54
          end
          object psisQuickly: TcxGridDBColumn
            Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090
            DataBinding.FieldName = 'isQuickly'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1088#1086#1095#1085#1086' ('#1044#1072'/'#1053#1077#1090')'
            Width = 70
          end
          object psPromoStateKindName: TcxGridDBColumn
            Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
            DataBinding.FieldName = 'PromoStateKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actPromoStateKindChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 344
          end
          object psComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 316
          end
          object psInsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 142
          end
          object psInsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' / '#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 168
          end
          object psIsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 294
          end
        end
        object cxGridLevel4: TcxGridLevel
          GridView = cxGridDBTableViewPromoStateKind
        end
      end
      object cxSplitter4: TcxSplitter
        Left = 0
        Top = 337
        Width = 1366
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = cxGridPromoStateKind
      end
    end
    inherited tsMain: TcxTabSheet
      Caption = '&1. '#1058#1086#1074#1072#1088#1099
      ExplicitWidth = 1366
      ExplicitHeight = 521
      inherited cxGrid: TcxGrid
        Width = 1366
        Height = 348
        ExplicitWidth = 1366
        ExplicitHeight = 348
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPlanMinWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPlanMaxWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOrderWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOutWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountInWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRetInWeight
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPlanMinWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPlanMaxWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOrderWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountOutWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountInWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRetInWeight
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object TradeMark: TcxGridDBColumn [0]
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GoodsCode: TcxGridDBColumn [1]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 47
          end
          object GoodsName: TcxGridDBColumn [2]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object GoodsKindName: TcxGridDBColumn [3]
            Caption = #1042#1080#1076
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 80
          end
          object GoodsKindCompleteName: TcxGridDBColumn [4]
            Caption = #1042#1080#1076' ('#1087#1088#1080#1084#1077#1095#1072#1085#1080#1077')'
            DataBinding.FieldName = 'GoodsKindCompleteName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindCompleteChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' ('#1087#1088#1080#1084#1077#1095#1072#1085#1080#1077')'
            Width = 85
          end
          object GoodsKindName_List: TcxGridDBColumn [5]
            Caption = #1042#1080#1076' ('#1089#1087#1088#1072#1074#1086#1095#1085#1086')'
            DataBinding.FieldName = 'GoodsKindName_List'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1089#1087#1088#1072#1074#1086#1095#1085#1086')'
            Options.Editing = False
            Width = 77
          end
          object MeasureName: TcxGridDBColumn [6]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object GoodComment: TcxGridDBColumn [7]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Amount: TcxGridDBColumn [8]
            Caption = '% '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object MainDiscount: TcxGridDBColumn [9]
            Caption = '% '#1086#1073#1097'. '#1089#1082'. '
            DataBinding.FieldName = 'MainDiscount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1073#1097#1072#1103' '#1089#1082#1080#1076#1082#1072' '#1076#1083#1103' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103', %'
            Options.Editing = False
            Width = 50
          end
          object PriceSale: TcxGridDBColumn [10]
            Caption = #1062#1077#1085#1072' '#1085#1072' '#1087#1086#1083#1082#1077
            DataBinding.FieldName = 'PriceSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Price: TcxGridDBColumn [11]
            Caption = #1073#1077#1079' '#1053#1044#1057' '#1074' '#1087#1088#1072#1081#1089#1077
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PriceWithOutVAT: TcxGridDBColumn [12]
            Caption = #1073#1077#1079' '#1053#1044#1057' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
            DataBinding.FieldName = 'PriceWithOutVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1073#1077#1079' '#1091#1095#1077#1090#1072' '#1053#1044#1057', '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080', '#1075#1088#1085
            Options.Editing = False
            Width = 70
          end
          object PriceWithVAT: TcxGridDBColumn [13]
            Caption = #1089' '#1053#1044#1057' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
            DataBinding.FieldName = 'PriceWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1089' '#1091#1095#1077#1090#1086#1084' '#1053#1044#1057', '#1089' '#1091#1095#1077#1090#1086#1084' '#1089#1082#1080#1076#1082#1080', '#1075#1088#1085
            Options.Editing = False
            Width = 70
          end
          object PriceTender: TcxGridDBColumn [14]
            Caption = #1062#1077#1085#1072' '#1058#1077#1085#1076#1077#1088' '#1073#1077#1079' '#1053#1044#1057', '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
            DataBinding.FieldName = 'PriceTender'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1058#1077#1085#1076#1077#1088' '#1073#1077#1079' '#1053#1044#1057', '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081', '#1075#1088#1085
            Width = 78
          end
          object AmountReal: TcxGridDBColumn [15]
            Caption = #1055#1088#1086#1076#1072#1085#1086' '#1074' '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'AmountReal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountRealWeight: TcxGridDBColumn [16]
            Caption = #1055#1088#1086#1076#1072#1085#1086' '#1074' '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076' '#1042#1077#1089
            DataBinding.FieldName = 'AmountRealWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountRetIn: TcxGridDBColumn [17]
            Caption = #1042#1086#1079#1074#1088'. '#1074' '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'AmountRetIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountRetInWeight: TcxGridDBColumn [18]
            Caption = #1042#1086#1079#1074#1088'. '#1074' '#1072#1085#1072#1083#1086#1075'. '#1087#1077#1088#1080#1086#1076' '#1042#1077#1089
            DataBinding.FieldName = 'AmountRetInWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountPlanMin: TcxGridDBColumn [19]
            Caption = #1055#1083#1072#1085' '#1084#1080#1085'.'
            DataBinding.FieldName = 'AmountPlanMin'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountPlanMinWeight: TcxGridDBColumn [20]
            Caption = #1055#1083#1072#1085' '#1084#1080#1085'. '#1042#1077#1089
            DataBinding.FieldName = 'AmountPlanMinWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountPlanMax: TcxGridDBColumn [21]
            Caption = #1055#1083#1072#1085' '#1084#1072#1082#1089'.'
            DataBinding.FieldName = 'AmountPlanMax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountPlanMaxWeight: TcxGridDBColumn [22]
            Caption = #1055#1083#1072#1085' '#1084#1072#1082#1089'. '#1042#1077#1089
            DataBinding.FieldName = 'AmountPlanMaxWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountOrder: TcxGridDBColumn [23]
            Caption = #1047#1072#1103#1074#1082#1072' ('#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountOrder'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountOrderWeight: TcxGridDBColumn [24]
            Caption = #1047#1072#1103#1074#1082#1072' ('#1092#1072#1082#1090') '#1042#1077#1089
            DataBinding.FieldName = 'AmountOrderWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountOut: TcxGridDBColumn [25]
            Caption = #1055#1088#1086#1076#1072#1085#1086' ('#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountOutWeight: TcxGridDBColumn [26]
            Caption = #1055#1088#1086#1076#1072#1085#1086' ('#1092#1072#1082#1090') '#1042#1077#1089
            DataBinding.FieldName = 'AmountOutWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountIn: TcxGridDBColumn [27]
            Caption = #1042#1086#1079#1074#1088#1072#1090' ('#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountInWeight: TcxGridDBColumn [28]
            Caption = #1042#1086#1079#1074#1088#1072#1090' ('#1092#1072#1082#1090') '#1042#1077#1089
            DataBinding.FieldName = 'AmountInWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clAmountPlan1: TcxGridDBColumn [29]
            Caption = #1050#1086#1083'-'#1087#1083#1072#1085' '#1079#1072' 1'
            DataBinding.FieldName = 'AmountPlan1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1085' '#1086#1090#1075#1088#1091#1079#1082#1080' '#1079#1072' '#1087#1085'.'
            Options.Editing = False
            Width = 55
          end
          object clAmountPlan2: TcxGridDBColumn [30]
            Caption = #1050#1086#1083'-'#1087#1083#1072#1085' '#1079#1072' 2'
            DataBinding.FieldName = 'AmountPlan2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clAmountPlan3: TcxGridDBColumn [31]
            Caption = #1050#1086#1083'-'#1087#1083#1072#1085' '#1079#1072' 3'
            DataBinding.FieldName = 'AmountPlan3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clAmountPlan4: TcxGridDBColumn [32]
            Caption = #1050#1086#1083'-'#1087#1083#1072#1085' '#1079#1072' 4'
            DataBinding.FieldName = 'AmountPlan4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clAmountPlan5: TcxGridDBColumn [33]
            Caption = #1050#1086#1083'-'#1087#1083#1072#1085' '#1079#1072' 5'
            DataBinding.FieldName = 'AmountPlan5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clAmountPlan6: TcxGridDBColumn [34]
            Caption = #1050#1086#1083'-'#1087#1083#1072#1085' '#1079#1072' 6'
            DataBinding.FieldName = 'AmountPlan66'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clAmountPlan7: TcxGridDBColumn [35]
            Caption = #1050#1086#1083'-'#1087#1083#1072#1085' '#1079#1072' 7'
            DataBinding.FieldName = 'AmountPlan7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 348
        Width = 1366
        Height = 173
        Align = alBottom
        TabOrder = 1
        object cxSplitter1: TcxSplitter
          Left = 822
          Top = 1
          Width = 8
          Height = 171
          HotZoneClassName = 'TcxMediaPlayer8Style'
          AlignSplitter = salRight
          Control = cxPageControl2
        end
        object cxPageControl1: TcxPageControl
          Left = 1
          Top = 1
          Width = 821
          Height = 171
          Align = alClient
          TabOrder = 1
          Properties.ActivePage = tsPartner
          Properties.CustomButtons.Buttons = <>
          ClientRectBottom = 171
          ClientRectRight = 821
          ClientRectTop = 24
          object tsPartner: TcxTabSheet
            Caption = '2.1. '#1055#1072#1088#1090#1085#1077#1088#1099
            object cxGridPartner: TcxGrid
              Left = 0
              Top = 0
              Width = 821
              Height = 147
              Align = alClient
              PopupMenu = pmPartner
              TabOrder = 0
              object cxGridDBTableViewPartner: TcxGridDBTableView
                Navigator.Buttons.CustomButtons = <>
                DataController.DataSource = PartnerDS
                DataController.Filter.Options = [fcoCaseInsensitive]
                DataController.Summary.DefaultGroupSummaryItems = <>
                DataController.Summary.FooterSummaryItems = <>
                DataController.Summary.SummaryGroups = <>
                Images = dmMain.SortImageList
                OptionsBehavior.GoToNextCellOnEnter = True
                OptionsBehavior.FocusCellOnCycle = True
                OptionsCustomize.ColumnHiding = True
                OptionsCustomize.ColumnsQuickCustomization = True
                OptionsCustomize.DataRowSizing = True
                OptionsData.Deleting = False
                OptionsData.DeletingConfirmation = False
                OptionsData.Editing = False
                OptionsData.Inserting = False
                OptionsView.Footer = True
                OptionsView.GroupByBox = False
                OptionsView.GroupSummaryLayout = gslAlignWithColumns
                OptionsView.HeaderAutoHeight = True
                OptionsView.Indicator = True
                Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
                object AreaName: TcxGridDBColumn
                  Caption = #1056#1077#1075#1080#1086#1085
                  DataBinding.FieldName = 'AreaName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 70
                end
                object PartnerCode: TcxGridDBColumn
                  Caption = #1050#1086#1076
                  DataBinding.FieldName = 'PartnerCode'
                  PropertiesClassName = 'TcxCurrencyEditProperties'
                  Properties.DecimalPlaces = 0
                  Properties.DisplayFormat = '0.####;-0.####; ;'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 28
                end
                object PartnerName: TcxGridDBColumn
                  Caption = #1053#1072#1079#1074#1072#1085#1080#1077
                  DataBinding.FieldName = 'PartnerName'
                  PropertiesClassName = 'TcxButtonEditProperties'
                  Properties.Buttons = <
                    item
                      Action = actPromoPartnerChoiceForm
                      Default = True
                      Kind = bkEllipsis
                    end>
                  Properties.ReadOnly = True
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 104
                end
                object PartnerDescName: TcxGridDBColumn
                  Caption = #1069#1083#1077#1084#1077#1085#1090
                  DataBinding.FieldName = 'PartnerDescName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 58
                end
                object Juridical_Name: TcxGridDBColumn
                  Caption = #1070#1088'. '#1083#1080#1094#1086
                  DataBinding.FieldName = 'Juridical_Name'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 80
                end
                object Retail_Name: TcxGridDBColumn
                  Caption = #1057#1077#1090#1100
                  DataBinding.FieldName = 'Retail_Name'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 80
                end
                object ContractCode: TcxGridDBColumn
                  Caption = #1050#1086#1076' '#1076#1086#1075'.'
                  DataBinding.FieldName = 'ContractCode'
                  PropertiesClassName = 'TcxCurrencyEditProperties'
                  Properties.DecimalPlaces = 0
                  Properties.DisplayFormat = '0.####;-0.####; ;'
                  Visible = False
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 70
                end
                object RetailName_inf: TcxGridDBColumn
                  Caption = #1057#1077#1090#1100' ('#1080#1085#1092'.)'
                  DataBinding.FieldName = 'RetailName_inf'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  HeaderHint = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
                  Width = 80
                end
                object ContractName: TcxGridDBColumn
                  Caption = #8470' '#1076#1086#1075'.'
                  DataBinding.FieldName = 'ContractName'
                  PropertiesClassName = 'TcxButtonEditProperties'
                  Properties.Buttons = <
                    item
                      Action = actContractChoiceForm
                      Default = True
                      Kind = bkEllipsis
                    end>
                  Properties.ReadOnly = True
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 55
                end
                object ContractTagName: TcxGridDBColumn
                  Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
                  DataBinding.FieldName = 'ContractTagName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 70
                end
                object Comment: TcxGridDBColumn
                  Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
                  DataBinding.FieldName = 'Comment'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 91
                end
                object isErased: TcxGridDBColumn
                  Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
                  DataBinding.FieldName = 'isErased'
                  Visible = False
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 50
                end
              end
              object cxGridLevelPartner: TcxGridLevel
                GridView = cxGridDBTableViewPartner
              end
            end
          end
          object tsPromoPartnerList: TcxTabSheet
            Caption = '2.2. '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
            ImageIndex = 1
            object grPartnerList: TcxGrid
              Left = 0
              Top = 0
              Width = 821
              Height = 147
              Align = alClient
              TabOrder = 0
              LookAndFeel.NativeStyle = True
              LookAndFeel.SkinName = 'UserSkin'
              object grtvPartnerList: TcxGridDBTableView
                Navigator.Buttons.CustomButtons = <>
                DataController.DataSource = PartnerLisrDS
                DataController.Filter.Options = [fcoCaseInsensitive]
                DataController.Summary.DefaultGroupSummaryItems = <>
                DataController.Summary.FooterSummaryItems = <>
                DataController.Summary.SummaryGroups = <>
                Images = dmMain.SortImageList
                OptionsCustomize.ColumnHiding = True
                OptionsCustomize.ColumnsQuickCustomization = True
                OptionsData.Deleting = False
                OptionsData.DeletingConfirmation = False
                OptionsData.Editing = False
                OptionsData.Inserting = False
                OptionsView.HeaderAutoHeight = True
                OptionsView.Indicator = True
                Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
                object PartnerListRetailName: TcxGridDBColumn
                  Caption = #1057#1077#1090#1100
                  DataBinding.FieldName = 'RetailName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 80
                end
                object PartnerListJuridicalName: TcxGridDBColumn
                  Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
                  DataBinding.FieldName = 'JuridicalName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 100
                end
                object PartnerListCode: TcxGridDBColumn
                  Caption = #1050#1086#1076
                  DataBinding.FieldName = 'Code'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 38
                end
                object PartnerListName: TcxGridDBColumn
                  Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
                  DataBinding.FieldName = 'Name'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 182
                end
                object PartnerListAreaName: TcxGridDBColumn
                  Caption = #1056#1077#1075#1080#1086#1085
                  DataBinding.FieldName = 'AreaName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 98
                end
                object PartnerListContractCode: TcxGridDBColumn
                  Caption = #1050#1086#1076' '#1076#1086#1075'.'
                  DataBinding.FieldName = 'ContractCode'
                  Visible = False
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 48
                end
                object PartnerListContractName: TcxGridDBColumn
                  Caption = #8470' '#1076#1086#1075'.'
                  DataBinding.FieldName = 'ContractName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 48
                end
                object PartnerListContractTagName: TcxGridDBColumn
                  Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
                  DataBinding.FieldName = 'ContractTagName'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 80
                end
                object PartnerListIsErased: TcxGridDBColumn
                  Caption = #1059#1076#1072#1083#1077#1085
                  DataBinding.FieldName = 'IsErased'
                  Visible = False
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 47
                end
              end
              object grlPartnerList: TcxGridLevel
                GridView = grtvPartnerList
              end
            end
          end
        end
        object cxPageControl2: TcxPageControl
          Left = 830
          Top = 1
          Width = 264
          Height = 171
          Align = alRight
          TabOrder = 2
          Properties.ActivePage = tsConditionPromo
          Properties.CustomButtons.Buttons = <>
          ClientRectBottom = 171
          ClientRectRight = 264
          ClientRectTop = 24
          object tsConditionPromo: TcxTabSheet
            Caption = '&3. '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1072#1103' '#1089#1082#1080#1076#1082#1072
            object cxGridConditionPromo: TcxGrid
              Left = 0
              Top = 0
              Width = 264
              Height = 147
              Align = alClient
              PopupMenu = pmCondition
              TabOrder = 0
              object grtvConditionPromo: TcxGridDBTableView
                Navigator.Buttons.CustomButtons = <>
                DataController.DataSource = ConditionPromoDS
                DataController.Filter.Options = [fcoCaseInsensitive]
                DataController.Summary.DefaultGroupSummaryItems = <>
                DataController.Summary.FooterSummaryItems = <>
                DataController.Summary.SummaryGroups = <>
                Images = dmMain.SortImageList
                OptionsBehavior.GoToNextCellOnEnter = True
                OptionsBehavior.FocusCellOnCycle = True
                OptionsCustomize.ColumnHiding = True
                OptionsCustomize.ColumnsQuickCustomization = True
                OptionsCustomize.DataRowSizing = True
                OptionsData.Deleting = False
                OptionsData.DeletingConfirmation = False
                OptionsData.Editing = False
                OptionsData.Inserting = False
                OptionsView.Footer = True
                OptionsView.GroupByBox = False
                OptionsView.GroupSummaryLayout = gslAlignWithColumns
                OptionsView.HeaderAutoHeight = True
                OptionsView.Indicator = True
                Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
                object cp_Amount: TcxGridDBColumn
                  Caption = '% '#1089#1082#1080#1076#1082#1080
                  DataBinding.FieldName = 'Amount'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 50
                end
                object ConditionPromoName: TcxGridDBColumn
                  Caption = #1053#1072#1079#1074#1072#1085#1080#1077
                  DataBinding.FieldName = 'ConditionPromoName'
                  PropertiesClassName = 'TcxButtonEditProperties'
                  Properties.Buttons = <
                    item
                      Action = actConditionPromoChoiceForm
                      Default = True
                      Kind = bkEllipsis
                    end>
                  Properties.ReadOnly = True
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 115
                end
                object cp_Comment: TcxGridDBColumn
                  Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
                  DataBinding.FieldName = 'Comment'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 80
                end
                object cp_isErased: TcxGridDBColumn
                  Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
                  DataBinding.FieldName = 'isErased'
                  Visible = False
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 50
                end
              end
              object grlConditionPromo: TcxGridLevel
                GridView = grtvConditionPromo
              end
            end
          end
        end
        object cxPageControl3: TcxPageControl
          Left = 1102
          Top = 1
          Width = 263
          Height = 171
          Align = alRight
          TabOrder = 3
          Properties.ActivePage = tsAdvertising
          Properties.CustomButtons.Buttons = <>
          ClientRectBottom = 171
          ClientRectRight = 263
          ClientRectTop = 24
          object tsAdvertising: TcxTabSheet
            Caption = '&4. '#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072
            object grAdvertising: TcxGrid
              Left = 0
              Top = 0
              Width = 263
              Height = 147
              Align = alClient
              PopupMenu = pmAdvertising
              TabOrder = 0
              object grtvAdvertising: TcxGridDBTableView
                Navigator.Buttons.CustomButtons = <>
                DataController.DataSource = AdvertisingDS
                DataController.Filter.Options = [fcoCaseInsensitive]
                DataController.Summary.DefaultGroupSummaryItems = <>
                DataController.Summary.FooterSummaryItems = <>
                DataController.Summary.SummaryGroups = <>
                Images = dmMain.SortImageList
                OptionsBehavior.GoToNextCellOnEnter = True
                OptionsBehavior.FocusCellOnCycle = True
                OptionsCustomize.ColumnHiding = True
                OptionsCustomize.ColumnsQuickCustomization = True
                OptionsCustomize.DataRowSizing = True
                OptionsData.Deleting = False
                OptionsData.DeletingConfirmation = False
                OptionsData.Editing = False
                OptionsData.Inserting = False
                OptionsView.Footer = True
                OptionsView.GroupByBox = False
                OptionsView.GroupSummaryLayout = gslAlignWithColumns
                OptionsView.HeaderAutoHeight = True
                OptionsView.Indicator = True
                Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
                object AdvertisingCode: TcxGridDBColumn
                  Caption = #1050#1086#1076
                  DataBinding.FieldName = 'AdvertisingCode'
                  PropertiesClassName = 'TcxCurrencyEditProperties'
                  Properties.DecimalPlaces = 0
                  Properties.DisplayFormat = '0.####;-0.####; ;'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Options.Editing = False
                  Width = 34
                end
                object AdvertisingName: TcxGridDBColumn
                  Caption = #1053#1072#1079#1074#1072#1085#1080#1077
                  DataBinding.FieldName = 'AdvertisingName'
                  PropertiesClassName = 'TcxButtonEditProperties'
                  Properties.Buttons = <
                    item
                      Action = actAdvertisingChoiceForm
                      Default = True
                      Kind = bkEllipsis
                    end>
                  Properties.ReadOnly = True
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 130
                end
                object CommentAdvertising: TcxGridDBColumn
                  Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
                  DataBinding.FieldName = 'Comment'
                  HeaderAlignmentHorz = taCenter
                  HeaderAlignmentVert = vaCenter
                  Width = 80
                end
                object IsErasedAdvertising: TcxGridDBColumn
                  Caption = #1059#1076#1072#1083'.'
                  DataBinding.FieldName = 'IsErased'
                  Visible = False
                  Width = 55
                end
              end
              object grlAdvertising: TcxGridLevel
                GridView = grtvAdvertising
              end
            end
          end
        end
        object cxSplitter3: TcxSplitter
          Left = 1094
          Top = 1
          Width = 8
          Height = 171
          HotZoneClassName = 'TcxMediaPlayer8Style'
          AlignSplitter = salRight
          Control = cxPageControl3
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1366
    Height = 113
    TabOrder = 3
    ExplicitWidth = 1366
    ExplicitHeight = 113
    inherited edInvNumber: TcxTextEdit
      Left = 8
      Top = 18
      TabStop = False
      ExplicitLeft = 8
      ExplicitTop = 18
      ExplicitWidth = 75
      Width = 75
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      Top = 4
      ExplicitLeft = 8
      ExplicitTop = 4
    end
    inherited edOperDate: TcxDateEdit
      Left = 89
      Top = 18
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      ExplicitLeft = 89
      ExplicitTop = 18
      ExplicitWidth = 88
      Width = 88
    end
    inherited cxLabel2: TcxLabel
      Left = 89
      Top = 4
      ExplicitLeft = 89
      ExplicitTop = 4
    end
    inherited cxLabel15: TcxLabel
      Top = 38
      ExplicitTop = 38
    end
    inherited ceStatus: TcxButtonEdit
      Top = 54
      TabStop = False
      TabOrder = 16
      ExplicitTop = 54
      ExplicitWidth = 170
      ExplicitHeight = 22
      Width = 170
    end
    object cxLabel4: TcxLabel
      Left = 380
      Top = 4
      Caption = #1059#1089#1083#1086#1074#1080#1103' '#1091#1095#1072#1089#1090#1080#1103' '
    end
    object edPromoKind: TcxButtonEdit
      Left = 380
      Top = 18
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 178
    end
    object cxLabel11: TcxLabel
      Left = 788
      Top = 4
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
    end
    object edPriceList: TcxButtonEdit
      Left = 788
      Top = 18
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 125
    end
    object cxLabel5: TcxLabel
      Left = 195
      Top = 4
      Caption = #1040#1082#1094#1080#1103' '#1089
    end
    object deStartPromo: TcxDateEdit
      Left = 195
      Top = 18
      EditValue = 42132d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 2
      Width = 81
    end
    object cxLabel6: TcxLabel
      Left = 278
      Top = 4
      Caption = #1040#1082#1094#1080#1103' '#1087#1086
    end
    object deEndPromo: TcxDateEdit
      Left = 278
      Top = 18
      EditValue = 42132d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 3
      Width = 81
    end
    object cxLabel7: TcxLabel
      Left = 195
      Top = 38
      Caption = #1054#1090#1075#1088#1091#1079#1082#1072' '#1089
    end
    object deStartSale: TcxDateEdit
      Left = 195
      Top = 54
      EditValue = 42132d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 7
      Width = 81
    end
    object cxLabel8: TcxLabel
      Left = 278
      Top = 38
      Caption = #1054#1090#1075#1088#1091#1079#1082#1072' '#1087#1086
    end
    object deEndSale: TcxDateEdit
      Left = 278
      Top = 54
      EditValue = 42132d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 8
      Width = 83
    end
    object cxLabel9: TcxLabel
      Left = 380
      Top = 38
      Caption = #1040#1085#1072#1083#1086#1075#1080#1095#1085#1099#1081' '#1089
    end
    object deOperDateStart: TcxDateEdit
      Left = 380
      Top = 54
      EditValue = 42132d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 9
      Width = 87
    end
    object cxLabel10: TcxLabel
      Left = 471
      Top = 38
      Caption = #1040#1085#1072#1083#1086#1075#1080#1095#1085#1099#1081' '#1087#1086
    end
    object deOperDateEnd: TcxDateEdit
      Left = 471
      Top = 54
      EditValue = 42132d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 10
      Width = 87
    end
    object edCostPromo: TcxCurrencyEdit
      Left = 840
      Top = 54
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = True
      Properties.UseThousandSeparator = True
      TabOrder = 12
      Width = 73
    end
    object cxLabel12: TcxLabel
      Left = 811
      Top = 38
      Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1091#1095#1072#1089#1090#1080#1103
    end
    object cxLabel13: TcxLabel
      Left = 579
      Top = 38
      Caption = #1054#1087#1080#1089#1072#1085#1080#1077
    end
    object edComment: TcxTextEdit
      Left = 579
      Top = 54
      Properties.MaxLength = 255
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 257
    end
    object cxLabel14: TcxLabel
      Left = 8
      Top = 75
      Caption = #1060#1048#1054' ('#1082#1086#1084#1084#1077#1088#1095#1077#1089#1082#1080#1081' '#1086#1090#1076#1077#1083')'
    end
    object edPersonalTrade: TcxButtonEdit
      Left = 8
      Top = 90
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Style.BorderColor = 16764159
      Style.Color = clWindow
      TabOrder = 13
      Width = 268
    end
    object cxLabel16: TcxLabel
      Left = 380
      Top = 75
      Caption = #1060#1048#1054' ('#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1086#1090#1076#1077#1083')'
    end
    object edPersonal: TcxButtonEdit
      Left = 380
      Top = 90
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 14
      Width = 178
    end
    object edUnit: TcxButtonEdit
      Left = 579
      Top = 18
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 202
    end
    object cxLabel17: TcxLabel
      Left = 579
      Top = 4
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object cxLabel18: TcxLabel
      Left = 579
      Top = 74
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1048#1090#1086#1075')'
    end
    object edCommentMain: TcxTextEdit
      Left = 579
      Top = 90
      Properties.MaxLength = 255
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 334
    end
    object deEndReturn: TcxDateEdit
      Left = 278
      Top = 90
      Hint = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1074#1086#1079#1074#1088#1072#1090#1086#1074' '#1087#1086' '#1072#1082#1094#1080#1086#1085#1085#1086#1081' '#1094#1077#1085#1077
      EditValue = 42132d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 34
      Width = 83
    end
    object cxLabel3: TcxLabel
      Left = 278
      Top = 74
      Caption = #1042#1086#1079#1074#1088#1072#1090#1099' '#1087#1086
    end
    object cbChecked: TcxCheckBox
      Left = 1019
      Top = 54
      Caption = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1086' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 36
      Width = 136
    end
    object cbPromo: TcxCheckBox
      Left = 1019
      Top = 18
      Hint = #1045#1089#1083#1080' '#1044#1072' - '#1101#1090#1086' '#1040#1082#1094#1080#1103', '#1053#1077#1090' - '#1058#1077#1085#1076#1077#1088#1099
      Caption = #1040#1082#1094#1080#1103' ('#1076#1072'/'#1085#1077#1090')'
      Properties.ReadOnly = True
      TabOrder = 37
      Width = 103
    end
    object cxLabel20: TcxLabel
      Left = 918
      Top = 38
      Caption = #1044#1072#1090#1072' '#1089#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1103
    end
    object deCheck: TcxDateEdit
      Left = 918
      Top = 54
      Hint = #1044#1072#1090#1072' '#1089#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1103
      EditValue = 42132d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 39
      Width = 97
    end
    object cbisTaxPromo: TcxCheckBox
      Left = 1180
      Top = 45
      Caption = '% '#1089#1082#1080#1076#1082#1080
      Properties.ReadOnly = True
      TabOrder = 40
      Width = 74
    end
    object cbisTaxPromo_Condition: TcxCheckBox
      Left = 1257
      Top = 45
      Caption = '% '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080
      Properties.ReadOnly = True
      TabOrder = 41
      Width = 110
    end
    object cbPromoStateKind: TcxCheckBox
      Left = 1287
      Top = 18
      Hint = #1057#1088#1086#1095#1085#1086' '#1044#1072'/'#1053#1077#1090
      Caption = #1057#1088#1086#1095#1085#1086
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 42
      Width = 66
    end
  end
  object deMonthPromo: TcxDateEdit [2]
    Left = 918
    Top = 18
    EditValue = 43070d
    Properties.DisplayFormat = 'mmmm yyyy'
    Properties.EditFormat = 'dd.mm.yyyy'
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 6
    Width = 97
  end
  object cxLabel19: TcxLabel [3]
    Left = 918
    Top = 4
    Caption = #1052#1077#1089#1103#1094' '#1072#1082#1094#1080#1080
  end
  object cxLabel21: TcxLabel [4]
    Left = 919
    Top = 74
    Caption = #1045#1089#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
  end
  object edstrSign: TcxTextEdit [5]
    Left = 919
    Top = 90
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 125
  end
  object edstrSignNo: TcxTextEdit [6]
    Left = 1048
    Top = 90
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 128
  end
  object cxLabel22: TcxLabel [7]
    Left = 1048
    Top = 74
    Caption = #1054#1078#1080#1076#1072#1077#1090#1089#1103' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
  end
  object edPromoStateKind: TcxButtonEdit [8]
    Left = 1128
    Top = 18
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 153
  end
  object cxLabel23: TcxLabel [9]
    Left = 1128
    Top = 4
    Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
  end
  object cxLabel25: TcxLabel [10]
    Left = 1182
    Top = 74
    Hint = #1052#1086#1076#1077#1083#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1086#1081' '#1087#1086#1076#1087#1080#1089#1080
    Caption = #1052#1086#1076#1077#1083#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1086#1081' '#1087#1086#1076#1087#1080#1089#1080
    ParentShowHint = False
    ShowHint = True
  end
  object edSignInternal: TcxButtonEdit [11]
    Left = 1182
    Top = 90
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 178
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 163
    Top = 256
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 312
  end
  inherited ActionList: TActionList
    Left = 215
    Top = 191
    object macUpdatePromoStateKind_Complete: TMultiAction [0]
      Category = 'Update_PromoStateKind'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetPromoStateKind_Complete
        end
        item
          Action = actPromoManagerDialog
        end
        item
          Action = actUpdateMovement_PromoStateKind
        end>
      Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100
      Hint = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' - '#1040#1082#1094#1080#1103' '#1089#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072
    end
    object macUpdatePromoStateKind_Return: TMultiAction [1]
      Category = 'Update_PromoStateKind'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetPromoStateKind_Return
        end
        item
          Action = actPromoManagerDialog
        end
        item
          Action = actUpdateMovement_PromoStateKind
        end>
      Caption = #1054#1090#1082#1083#1086#1085#1080#1090#1100
      Hint = #1054#1090#1082#1083#1086#1085#1080#1090#1100' - '#1074#1077#1088#1085#1091#1090#1100' '#1040#1082#1094#1080#1102' '#1076#1083#1103' '#1080#1089#1087#1088#1072#1074#1083#1077#1085#1080#1103
    end
    object actGetPromoStateKind_Complete: TdsdDataSetRefresh [2]
      Category = 'Update_PromoStateKind'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.Component = FormParams
          FromParam.ComponentItem = 'isComplete_PromoStateKind_true'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = True
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isComplete_PromoStateKind'
          ToParam.DataType = ftBoolean
          ToParam.ParamType = ptInput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectMIPromoStateKind
      StoredProcList = <
        item
          StoredProc = spSelectMIPromoStateKind
        end
        item
          StoredProc = spGetPromoStateKind
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actGetPromoStateKind_Return: TdsdDataSetRefresh [3]
      Category = 'Update_PromoStateKind'
      MoveParams = <
        item
          FromParam.Value = True
          FromParam.Component = FormParams
          FromParam.ComponentItem = 'isComplete_PromoStateKind_false'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = True
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isComplete_PromoStateKind'
          ToParam.DataType = ftBoolean
          ToParam.ParamType = ptInput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectMIPromoStateKind
      StoredProcList = <
        item
          StoredProc = spSelectMIPromoStateKind
        end
        item
          StoredProc = spGetPromoStateKind
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actUpdate_Movement_isTaxPromo: TdsdExecStoredProc [4]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Movement_isTaxPromo
      StoredProcList = <
        item
          StoredProc = spUpdate_Movement_isTaxPromo
        end
        item
          StoredProc = spSelectCalc
        end
        item
          StoredProc = spSelectCalc2
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' % '#1057#1082#1080#1076#1082#1080' ('#1044#1072'/'#1053#1077#1090') / % '#1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080' ('#1044#1072'/'#1053#1077#1090')'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' % '#1057#1082#1080#1076#1082#1080' ('#1044#1072'/'#1053#1077#1090') / % '#1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080' ('#1044#1072'/'#1053#1077#1090')'
      ImageIndex = 27
    end
    object actPromoManagerDialog: TExecuteDialog [5]
      Category = 'Update_PromoStateKind'
      MoveParams = <>
      Caption = 'actPromoManagerDialog'
      FormName = 'TPromoManagerDialogForm'
      FormNameParam.Value = 'TPromoManagerDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MovementItemId'
          Value = Null
          Component = FormParams
          ComponentItem = 'MovementItemId_PromoStateKind_true'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoStateKindId'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoStateKindId'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoStateKindName'
          Value = Null
          Component = FormParams
          ComponentItem = 'PromoStateKindName'
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Comment_PromoStateKind'
          Value = Null
          Component = FormParams
          ComponentItem = 'Comment_PromoStateKind'
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdateMovement_PromoStateKind: TdsdExecStoredProc [6]
      Category = 'Update_PromoStateKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_PromoStateKind
      StoredProcList = <
        item
          StoredProc = spUpdate_PromoStateKind
        end
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelectMIPromoStateKind
        end>
      Caption = 'actUpdateMovement_PromoStateKind'
    end
    object actInsertRecordPromoStateKind: TInsertRecord [7]
      Category = 'PromoStateKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewPromoStateKind
      Action = actPromoStateKindChoice
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1040#1082#1094#1080#1080'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1040#1082#1094#1080#1080'>'
      ImageIndex = 0
    end
    object actRefresh_Get: TdsdDataSetRefresh [8]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actMISetErasedPromoStateKind: TdsdUpdateErased [9]
      Category = 'PromoStateKind'
      MoveParams = <>
      StoredProc = spErasedPromoStateKind
      StoredProcList = <
        item
          StoredProc = spErasedPromoStateKind
        end
        item
          StoredProc = spGet
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1040#1082#1094#1080#1080'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1057#1086#1089#1090#1086#1103#1085#1080#1077'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = PromoStateKindDS
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' <'#1057#1086#1089#1090#1086#1103#1085#1080#1077'> ?'
    end
    object actMISetUnErasedPromoStateKind: TdsdUpdateErased [10]
      Category = 'PromoStateKind'
      MoveParams = <>
      StoredProc = spUnErasedPromoStateKind
      StoredProcList = <
        item
          StoredProc = spUnErasedPromoStateKind
        end
        item
          StoredProc = spGet
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = PromoStateKindDS
    end
    object actUpdatePromoStateKindDS: TdsdUpdateDataSet [11]
      Category = 'PromoStateKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_MI_PromoStateKind
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_MI_PromoStateKind
        end
        item
          StoredProc = spSelectMIPromoStateKind
        end
        item
          StoredProc = spGet
        end>
      Caption = 'actUpdatePromoStateKindDS'
      DataSource = PromoStateKindDS
    end
    object actPrint_CalcAll: TdsdPrintAction [12]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectCalc_Print
      StoredProcList = <
        item
          StoredProc = spSelectCalc_Print
        end>
      Caption = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      Hint = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHead
          UserName = 'frxHead'
          IndexFieldNames = 'GoodsName;Num'
        end>
      Params = <
        item
          Name = 'InvNumber'
          Value = ''
          Component = edInvNumber
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Comment'
          Value = ''
          Component = edComment
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'CommentMain'
          Value = ''
          Component = edCommentMain
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTaxPromo'
          Value = Null
          Component = cbisTaxPromo
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTaxPromo_Condition'
          Value = Null
          Component = cbisTaxPromo_Condition
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      ReportNameParam.Value = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actUpdateCalcDS2: TdsdUpdateDataSet [13]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_Calc2
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_Calc2
        end
        item
          StoredProc = spSelectCalc2
        end
        item
          StoredProc = spSelectCalc
        end
        item
          StoredProc = spGet
        end>
      Caption = 'actUpdateCalcDS'
      DataSource = CalcDS2
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_Movement_PromoPartner
        end
        item
          StoredProc = spSelect_MovementItem_PromoCondition
        end
        item
          StoredProc = spSelect_Movement_PromoAdvertising
        end
        item
          StoredProc = spSelect_MovementItem_PromoPartner
        end
        item
          StoredProc = spSelectMIPromoStateKind
        end
        item
          StoredProc = spSelectCalc
        end
        item
          StoredProc = spSelectCalc2
        end
        item
        end
        item
        end
        item
        end>
    end
    object actUpdateDataSetMessage: TdsdUpdateDataSet [15]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end
        item
        end>
      Caption = 'actUpdateDataSetMessage'
    end
    inherited actGridToExcel: TdsdGridToExcel
      Enabled = False
    end
    object InsertRecord: TInsertRecord [17]
      Category = 'Goods'
      MoveParams = <>
      Enabled = False
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actGoodsChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      ImageIndex = 0
    end
    object actUpdateCalcDS: TdsdUpdateDataSet [18]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_Calc
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_Calc
        end
        item
          StoredProc = spSelectCalc
        end
        item
          StoredProc = spSelectCalc2
        end
        item
          StoredProc = spGet
        end>
      Caption = 'actUpdateCalcDS'
      DataSource = CalcDS
    end
    object actOpenProtocoPromoStateKind: TdsdOpenForm [19]
      Category = 'PromoStateKind'
      MoveParams = <>
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083' <'#1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1040#1082#1094#1080#1080'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1040#1082#1094#1080#1080'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = PromoStateKindDCS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = PromoStateKindDCS
          ComponentItem = 'PromoStateKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    inherited actMISetErased: TdsdUpdateErased
      Category = 'Goods'
      Enabled = False
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      ShortCut = 0
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' <'#1058#1086#1074#1072#1088'> ?'
    end
    object actPrint_Calc: TdsdPrintAction [21]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectCalc
      StoredProcList = <
        item
          StoredProc = spSelectCalc
        end>
      Caption = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      Hint = #1050#1072#1083#1100#1082#1091#1083#1103#1090#1086#1088' - '#1089#1082#1080#1076#1082#1072
      ImageIndex = 15
      DataSets = <
        item
          UserName = 'frxHead'
          IndexFieldNames = 'GoodsName;Num'
          GridView = cxGridDBTableViewCalc
        end>
      Params = <
        item
          Name = 'InvNumber'
          Value = ''
          Component = edInvNumber
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Comment'
          Value = ''
          Component = edComment
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'CommentMain'
          Value = ''
          Component = edCommentMain
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTaxPromo'
          Value = Null
          Component = cbisTaxPromo
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTaxPromo_Condition'
          Value = Null
          Component = cbisTaxPromo_Condition
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      ReportNameParam.Value = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Calc2: TdsdPrintAction [22]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectCalc2
      StoredProcList = <
        item
          StoredProc = spSelectCalc2
        end>
      Caption = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      Hint = #1050#1072#1083#1100#1082#1091#1083#1103#1090#1086#1088' - % '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080
      ImageIndex = 15
      DataSets = <
        item
          UserName = 'frxHead'
          IndexFieldNames = 'GoodsName;Num'
          GridView = cxGridDBTableViewCalc2
        end>
      Params = <
        item
          Name = 'InvNumber'
          Value = ''
          Component = edInvNumber
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Comment'
          Value = ''
          Component = edComment
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'CommentMain'
          Value = ''
          Component = edCommentMain
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTaxPromo'
          Value = False
          Component = cbisTaxPromo
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTaxPromo_Condition'
          Value = False
          Component = cbisTaxPromo_Condition
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      ReportNameParam.Value = #1055#1083#1072#1085#1080#1088#1091#1077#1084#1099#1077' '#1088#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1072#1082#1094#1080#1080
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actMISetUnErased: TdsdUpdateErased
      Category = 'Goods'
      Enabled = False
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end
        item
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      ShortCut = 0
    end
    object actUpdateConditionDS: TdsdUpdateDataSet [24]
      Category = 'Condition'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMICondition
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMICondition
        end
        item
        end>
      Caption = 'actUpdateMainDS'
      DataSource = ConditionPromoDS
    end
    object actOpenProtocoPromoStateKind1: TdsdOpenForm [25]
      Category = 'PromoStateKind'
      MoveParams = <>
      Enabled = False
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1057#1086#1089#1090#1086#1103#1085#1080#1103'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1057#1086#1089#1090#1086#1103#1085#1080#1103'>'
      ImageIndex = 34
      FormName = 'TMovementProtocolForm'
      FormNameParam.Value = 'TMovementProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = PromoStateKindDCS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = PromoStateKindDCS
          ComponentItem = 'PromoStateKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end
        item
        end>
    end
    inherited actShowErased: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_Movement_PromoPartner
        end
        item
          StoredProc = spSelect_MovementItem_PromoCondition
        end
        item
          StoredProc = spSelectMIPromoStateKind
        end>
    end
    object macInsertUpdate_MI_Param: TMultiAction [28]
      Category = 'Update_MI_Param'
      MoveParams = <>
      Enabled = False
      ActionList = <
        item
          Action = actInsertUpdate_MI_Param
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1074#1099#1087#1086#1083#1085#1080#1090#1100' '#1056#1072#1089#1095#1077#1090' = '#1055#1088#1086#1076#1072#1078#1072' + '#1042#1086#1079#1074#1088#1072#1090' + '#1047#1072#1103#1074#1082#1080' ?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085' '#1088#1072#1089#1095#1077#1090' = '#1055#1088#1086#1076#1072#1078#1072' + '#1042#1086#1079#1074#1088#1072#1090' + '#1047#1072#1103#1074#1082#1080' '
      Caption = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093': '#1055#1088#1086#1076#1072#1078#1072' + '#1042#1086#1079#1074#1088#1072#1090' + '#1047#1072#1103#1074#1082#1080
      Hint = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093': '#1055#1088#1086#1076#1072#1078#1072' + '#1042#1086#1079#1074#1088#1072#1090' + '#1047#1072#1103#1074#1082#1080
      ImageIndex = 44
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
        end>
    end
    object actInsertUpdate_MI_Param: TdsdExecStoredProc [31]
      Category = 'Update_MI_Param'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_MI_Param
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_MI_Param
        end>
      Caption = 'actInsertUpdate_MI_Param'
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelect_Movement_Promo_Print
      StoredProcList = <
        item
          StoredProc = spSelect_Movement_Promo_Print
        end>
      DataSets = <
        item
          DataSet = PrintHead
          UserName = 'frxHead'
        end>
      Params = <
        item
          Name = 'InvNumber'
          Value = Null
          Component = edInvNumber
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Comment'
          Value = Null
          Component = edComment
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'CommentMain'
          Value = Null
          Component = edCommentMain
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1094#1080#1103
      ReportNameParam.Value = #1040#1082#1094#1080#1103
    end
    object actPromoStateKindChoice: TOpenChoiceForm [35]
      Category = 'PromoStateKind'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PromoStateKind_byMessageForm'
      FormName = 'TPromoStateKindForm'
      FormNameParam.Value = 'TPromoStateKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PromoStateKindDCS
          ComponentItem = 'PromoStateKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PromoStateKindDCS
          ComponentItem = 'PromoStateKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    inherited MovementItemProtocolOpenForm: TdsdOpenForm
      Enabled = False
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083' <'#1058#1086#1074#1072#1088'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1058#1086#1074#1072#1088'>'
    end
    object actPartnerProtocolOpenForm: TdsdOpenForm [39]
      Category = 'DSDLib'
      MoveParams = <>
      Enabled = False
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083' <'#1057#1077#1090#1100'/'#1070#1088'.'#1083#1080#1094#1086'/'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1087#1086' '#1057#1077#1090#1100'/'#1070#1088'.'#1083#1080#1094#1086'/'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090'>'
      ImageIndex = 34
      FormName = 'TMovementProtocolForm'
      FormNameParam.Value = 'TMovementProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actConditionPromoProtocolOpenForm: TdsdOpenForm [40]
      Category = 'DSDLib'
      MoveParams = <>
      Enabled = False
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083' <% '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1089#1082#1080#1076#1082#1080'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' % '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1089#1082#1080#1076#1082#1080'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ConditionPromoCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = ConditionPromoCDS
          ComponentItem = 'ConditionPromoName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actAdvertisingProtocolOpenForm: TdsdOpenForm [41]
      Category = 'DSDLib'
      MoveParams = <>
      Enabled = False
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083' <'#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'>'
      ImageIndex = 34
      FormName = 'TMovementProtocolForm'
      FormNameParam.Value = 'TMovementProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = AdvertisingCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = AdvertisingCDS
          ComponentItem = 'AdvertisingName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actGoodsKindChoiceForm: TOpenChoiceForm
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = 'TGoodsKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGoodsChoiceForm: TOpenChoiceForm
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasureName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TradeMarkName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'TradeMarkName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGoodsKindCompleteChoiceForm: TOpenChoiceForm
      Category = 'Goods'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindCompleteChoiceForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = 'TGoodsKindForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindCompleteId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindCompleteName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actInsertRecordPartner: TInsertRecord
      Category = 'Partner'
      MoveParams = <>
      Enabled = False
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewPartner
      Action = actPromoPartnerChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1077#1090#1100'/'#1070#1088'.'#1083#1080#1094#1086'/'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1057#1077#1090#1100'/'#1070#1088'.'#1083#1080#1094#1086'/'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090'>'
      ImageIndex = 0
    end
    object actErasedPartner: TdsdUpdateErased
      Category = 'Partner'
      MoveParams = <>
      Enabled = False
      StoredProc = spErasedMIPartner
      StoredProcList = <
        item
          StoredProc = spErasedMIPartner
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1057#1077#1090#1100'/'#1070#1088'.'#1083#1080#1094#1086'/'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1057#1077#1090#1100'/'#1070#1088'.'#1083#1080#1094#1086'/'#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = PartnerDS
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' <'#1055#1072#1088#1090#1085#1077#1088#1072'> ?'
    end
    object actUnErasedPartner: TdsdUpdateErased
      Category = 'Partner'
      MoveParams = <>
      Enabled = False
      StoredProc = spUnErasedMIPartner
      StoredProcList = <
        item
          StoredProc = spUnErasedMIPartner
        end
        item
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = PartnerDS
    end
    object actPromoPartnerChoiceForm: TOpenChoiceForm
      Category = 'Partner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'OpenChoiceForm1'
      FormName = 'TPromoPartnerForm'
      FormNameParam.Value = 'TPromoPartnerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'PartnerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'PartnerCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescName'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'PartnerDescName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Juridical_Name'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'Juridical_Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Retail_Name'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'Retail_Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateDSPartner: TdsdUpdateDataSet
      Category = 'Partner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIPartner
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIPartner
        end
        item
        end>
      Caption = 'actUpdateMainDS'
      DataSource = PartnerDS
    end
    object actInsertCondition: TInsertRecord
      Category = 'Condition'
      MoveParams = <>
      Enabled = False
      PostDataSetBeforeExecute = False
      View = grtvConditionPromo
      Action = actConditionPromoChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <% '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1089#1082#1080#1076#1082#1080'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <% '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1089#1082#1080#1076#1082#1080'>'
      ImageIndex = 0
    end
    object actErasedCondition: TdsdUpdateErased
      Category = 'Condition'
      MoveParams = <>
      Enabled = False
      StoredProc = spErasedMICondition
      StoredProcList = <
        item
          StoredProc = spErasedMICondition
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <% '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1089#1082#1080#1076#1082#1080'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <% '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1089#1082#1080#1076#1082#1080'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = ConditionPromoDS
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' <% '#1076#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086#1081' '#1089#1082#1080#1076#1082#1080'> ?'
    end
    object actUnErasedCondition: TdsdUpdateErased
      Category = 'Condition'
      MoveParams = <>
      Enabled = False
      StoredProc = spUnErasedMICondition
      StoredProcList = <
        item
          StoredProc = spUnErasedMICondition
        end
        item
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = ConditionPromoDS
    end
    object actConditionPromoChoiceForm: TOpenChoiceForm
      Category = 'Condition'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ConditionPromoChoiceForm'
      FormName = 'TConditionPromoForm'
      FormNameParam.Value = 'TConditionPromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ConditionPromoCDS
          ComponentItem = 'ConditionPromoId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = ConditionPromoCDS
          ComponentItem = 'ConditionPromoCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ConditionPromoCDS
          ComponentItem = 'ConditionPromoName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actContractChoiceForm: TOpenChoiceForm
      Category = 'Partner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ContractChoiceForm'
      FormName = 'TContractChoiceForm'
      FormNameParam.Value = 'TContractChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'ContractId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'ContractCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'ContractName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractTagName'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'ContractTagName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalId'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'PartnerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalName'
          Value = Null
          Component = PartnerCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actInsertRecordAdvertising: TInsertRecord
      Category = 'Advertising'
      MoveParams = <>
      Enabled = False
      PostDataSetBeforeExecute = False
      View = grtvAdvertising
      Action = actAdvertisingChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'>'
      ImageIndex = 0
    end
    object actErasedAdvertising: TdsdUpdateErased
      Category = 'Advertising'
      MoveParams = <>
      Enabled = False
      StoredProc = spErasedAdvertising
      StoredProcList = <
        item
          StoredProc = spErasedAdvertising
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = AdvertisingDS
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' <'#1056#1077#1082#1083#1072#1084#1085#1072#1103' '#1087#1086#1076#1076#1077#1088#1078#1082#1072'> ?'
    end
    object actunErasedAdvertising: TdsdUpdateErased
      Category = 'Advertising'
      MoveParams = <>
      Enabled = False
      StoredProc = spUnErasedAdvertising
      StoredProcList = <
        item
          StoredProc = spUnErasedAdvertising
        end
        item
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = AdvertisingDS
    end
    object actAdvertisingChoiceForm: TOpenChoiceForm
      Category = 'Advertising'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'AdvertisingChoiceForm'
      FormName = 'TAdvertisingForm'
      FormNameParam.Value = 'TAdvertisingForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = AdvertisingCDS
          ComponentItem = 'AdvertisingId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = AdvertisingCDS
          ComponentItem = 'AdvertisingCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = AdvertisingCDS
          ComponentItem = 'AdvertisingName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateDSAdvertising: TdsdUpdateDataSet
      Category = 'Advertising'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIAdvertising
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIAdvertising
        end>
      Caption = 'actUpdateMainDS'
      DataSource = AdvertisingDS
    end
    object actUpdate_Movement_Promo_Data: TdsdExecStoredProc
      Category = 'Update_Promo_Data'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Movement_Promo_Data
      StoredProcList = <
        item
          StoredProc = spUpdate_Movement_Promo_Data
        end>
      Caption = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093' '#1087#1086' '#1072#1082#1094#1080#1080
      Hint = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093' '#1087#1086' '#1072#1082#1094#1080#1080
    end
    object mactUpdate_Movement_Promo_Data: TMultiAction
      Category = 'Update_Promo_Data'
      MoveParams = <>
      Enabled = False
      ActionList = <
        item
          Action = actUpdate_Movement_Promo_Data
        end
        item
          Action = actRefresh
        end>
      Caption = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093': '#1040#1085#1072#1083#1086#1075#1080#1095#1085#1099#1081' '#1087#1077#1088#1080#1086#1076' + '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      Hint = #1056#1072#1089#1095#1077#1090' '#1076#1072#1085#1085#1099#1093': '#1040#1085#1072#1083#1086#1075#1080#1095#1085#1099#1081' '#1087#1077#1088#1080#1086#1076' + '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      ImageIndex = 45
    end
    object actPartnerListRefresh: TdsdDataSetRefresh
      Category = 'Partner'
      MoveParams = <>
      Enabled = False
      StoredProc = spSelect_MovementItem_PromoPartner
      StoredProcList = <
        item
          StoredProc = spSelect_MovementItem_PromoPartner
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object mactAddAllPartner: TMultiAction
      Category = 'Partner'
      MoveParams = <>
      Enabled = False
      ActionList = <
        item
          Action = actChoiceRetailForm
        end
        item
          Action = actInsertUpdate_Movement_PromoPartnerFromRetail
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1076#1072#1083#1080#1090#1100' '#1087#1088#1077#1076#1099#1076#1091#1097#1080#1093' <'#1055#1072#1088#1090#1085#1077#1088#1086#1074'> '#1080' '#1076#1086#1073#1072#1074#1080#1090#1100' '#1074#1089#1077#1093' '#1082#1086#1085 +
        #1090#1088#1072#1075#1077#1085#1090#1086#1074' '#1074#1099#1073#1088#1072#1085#1085#1086#1081' <'#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080'> ?'
      InfoAfterExecute = 
        #1055#1088#1077#1076#1099#1076#1091#1097#1080#1077' <'#1055#1072#1088#1090#1085#1077#1088#1099'> '#1091#1076#1072#1083#1077#1085#1099' '#1080' '#1076#1086#1073#1072#1074#1083#1077#1085#1099' '#1042#1057#1045' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1099' <'#1058#1086#1088#1075#1086 +
        #1074#1086#1081' '#1089#1077#1090#1080'>'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074#1089#1077#1093' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1086#1074' '#1076#1083#1103' <'#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1074#1089#1077#1093' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1086#1074' '#1076#1083#1103' <'#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080'>'
      ImageIndex = 74
    end
    object actChoiceRetailForm: TOpenChoiceForm
      Category = 'Partner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceRetailForm'
      FormName = 'TRetailForm'
      FormNameParam.Value = 'TRetailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'RetailId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actInsertUpdate_Movement_PromoPartnerFromRetail: TdsdExecStoredProc
      Category = 'Partner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_Movement_PromoPartnerFromRetail
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_Movement_PromoPartnerFromRetail
        end>
      Caption = 'actInsertUpdate_Movement_PromoPartnerFromRetail'
    end
    object actOpenReportForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1056#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1094#1077#1085#1086#1074#1099#1093' '#1072#1082#1094#1080#1081'>'
      Hint = #1054#1090#1095#1077#1090' <'#1056#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1094#1077#1085#1086#1074#1099#1093' '#1072#1082#1094#1080#1081'>'
      ImageIndex = 25
      FormName = 'TReport_Promo_ResultForm'
      FormNameParam.Value = 'TReport_Promo_ResultForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inStartDate'
          Value = Null
          Component = deStartPromo
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = Null
          Component = deEndPromo
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitId'
          Value = 'Null'
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Name = 'inUnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'Key'
          DataType = ftString
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Name = 'inRetailId'
          Value = 'Null'
          Component = PartnerListCDS
          ComponentItem = 'RetailId'
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Name = 'inRetailName'
          Value = 'Null'
          Component = PartnerListCDS
          ComponentItem = 'RetailName'
          DataType = ftString
          ParamType = ptUnknown
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberFull'
          Value = Null
          Component = FormParams
          ComponentItem = 'InvNumberFull'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUserChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'User_byMessageForm'
      FormName = 'TUser_byMessageForm'
      FormNameParam.Value = 'TUser_byMessageForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isQuestion'
          Value = Null
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenReport_SaleReturn_byPromo: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1077#1090#1072#1083#1100#1085#1086' '#1055#1088#1086#1076#1072#1078#1072'/'#1042#1086#1079#1074#1088#1072#1090
      Hint = #1044#1077#1090#1072#1083#1100#1085#1086' '#1055#1088#1086#1076#1072#1078#1072'/'#1042#1086#1079#1074#1088#1072#1090
      ImageIndex = 26
      FormName = 'TReport_SaleReturn_byPromoForm'
      FormNameParam.Value = 'TReport_SaleReturn_byPromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = Null
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 272
  end
  inherited MasterCDS: TClientDataSet
    Top = 272
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PromoGoods'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = False
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Top = 272
  end
  inherited BarManager: TdxBarManager
    Top = 271
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMovement_Checked'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMovement_Correction'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecordPromoStateKind'
        end
        item
          Visible = True
          ItemName = 'bsPromoStateKind'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_CalcAll'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    inherited bbShowAll: TdxBarButton
      Visible = ivNever
    end
    inherited bbAddMask: TdxBarButton
      Visible = ivNever
    end
    object bbInsertRecord: TdxBarButton
      Action = InsertRecord
      Category = 0
    end
    object bbInsertRecordPartner: TdxBarButton
      Action = actInsertRecordPartner
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actErasedPartner
      Category = 0
    end
    object dxBarButton4: TdxBarButton
      Action = actUnErasedPartner
      Category = 0
    end
    object bbInsertCondition: TdxBarButton
      Action = actInsertCondition
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = actUnErasedCondition
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = actErasedCondition
      Category = 0
    end
    object dxBarButton8: TdxBarButton
      Action = actInsertRecordAdvertising
      Category = 0
    end
    object dxBarButton9: TdxBarButton
      Action = actunErasedAdvertising
      Category = 0
    end
    object dxBarButton10: TdxBarButton
      Action = actErasedAdvertising
      Category = 0
    end
    object dxBarButton11: TdxBarButton
      Action = mactUpdate_Movement_Promo_Data
      Category = 0
    end
    object dxBarButton12: TdxBarButton
      Action = mactAddAllPartner
      Category = 0
    end
    object bbPartnerProtocol: TdxBarButton
      Action = actPartnerProtocolOpenForm
      Category = 0
    end
    object bbPartnerListProtocol: TdxBarButton
      Action = actConditionPromoProtocolOpenForm
      Category = 0
    end
    object bbAdvertisingProtocol: TdxBarButton
      Action = actAdvertisingProtocolOpenForm
      Category = 0
    end
    object bbInsertUpdate_MI_Param: TdxBarButton
      Action = macInsertUpdate_MI_Param
      Category = 0
    end
    object bbInsertUpdateMISignYes: TdxBarButton
      Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1076#1083#1103' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      Category = 0
      Hint = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1076#1083#1103' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      Visible = ivAlways
      ImageIndex = 58
    end
    object bbInsertUpdateMISignNo: TdxBarButton
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1076#1083#1103' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      Category = 0
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1076#1083#1103' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      Visible = ivAlways
      ImageIndex = 52
    end
    object bbPrint_Calc: TdxBarButton
      Action = actPrint_Calc
      Category = 0
    end
    object bbOpenReportForm: TdxBarButton
      Action = actOpenReportForm
      Category = 0
    end
    object bbInsertRecordPromoStateKind: TdxBarButton
      Action = actInsertRecordPromoStateKind
      Category = 0
    end
    object bbSetErasedPromoStateKind: TdxBarButton
      Action = actMISetErasedPromoStateKind
      Category = 0
    end
    object bbSetUnErasedPromoStateKind: TdxBarButton
      Action = actMISetUnErasedPromoStateKind
      Category = 0
    end
    object bbProtocoPromoStateKind: TdxBarButton
      Action = actOpenProtocoPromoStateKind
      Category = 0
    end
    object bbPrint_Calc2: TdxBarButton
      Action = actPrint_Calc2
      Category = 0
    end
    object bbUpdate_Movement_isTaxPromo: TdxBarButton
      Action = actUpdate_Movement_isTaxPromo
      Category = 0
    end
    object bbOpenReport_SaleReturn_byPromo: TdxBarButton
      Action = actOpenReport_SaleReturn_byPromo
      Category = 0
    end
    object bsGoods: TdxBarSubItem
      Caption = #1058#1086#1074#1072#1088
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
        end>
    end
    object bsPartner: TdxBarSubItem
      Caption = #1055#1072#1088#1090#1085#1077#1088
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'bbPartnerProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarButton12'
        end>
    end
    object bsConditionPromo: TdxBarSubItem
      Caption = '% '#1076#1086#1087'.'#1089#1082#1080#1076#1082#1080
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
        end
        item
          Visible = True
          ItemName = 'bbPartnerListProtocol'
        end>
    end
    object bsAdvertising: TdxBarSubItem
      Caption = #1056#1077#1082#1083#1072#1084#1085'. '#1087#1086#1076#1076'.'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton10'
        end
        item
          Visible = True
          ItemName = 'dxBarButton9'
        end
        item
          Visible = True
          ItemName = 'bbAdvertisingProtocol'
        end>
    end
    object bsPromoStateKind: TdxBarSubItem
      Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbSetErasedPromoStateKind'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedPromoStateKind'
        end
        item
          Visible = True
          ItemName = 'bbProtocoPromoStateKind'
        end>
    end
    object bsCalc: TdxBarSubItem
      Caption = #1056#1072#1089#1095#1077#1090
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdate_MI_Param'
        end
        item
          Visible = True
          ItemName = 'dxBarButton11'
        end>
    end
    object bsSign: TdxBarSubItem
      Caption = #1055#1086#1076#1087#1080#1089#1100
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdateMISignYes'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMISignNo'
        end>
    end
    object bbUpdateMovement_Checked: TdxBarButton
      Action = macUpdatePromoStateKind_Complete
      Category = 0
    end
    object bbUpdateMovement_Correction: TdxBarButton
      Action = macUpdatePromoStateKind_Return
      Category = 0
    end
    object bbPrint_CalcAll: TdxBarButton
      Action = actPrint_CalcAll
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = -1
      end>
    Left = 126
    Top = 385
  end
  inherited PopupMenu: TPopupMenu
    Left = 16
    Top = 552
    object N2: TMenuItem [0]
      Action = InsertRecord
    end
    object N3: TMenuItem [1]
      Action = actMISetErased
    end
    object N4: TMenuItem [2]
      Action = actMISetUnErased
    end
    object N5: TMenuItem [3]
      Caption = '-'
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'isComplete_PromoStateKind'
        Value = True
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isComplete_PromoStateKind_true'
        Value = True
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isComplete_PromoStateKind_false'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementItemId_PromoStateKind_true'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 168
    Top = 312
  end
  inherited StatusGuides: TdsdGuides
    Top = 272
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Promo'
    Top = 272
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Promo'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoKindId'
        Value = Null
        Component = StatusGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoKindName'
        Value = Null
        Component = GuidesPromoKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListId'
        Value = Null
        Component = GuidesPriceList
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListName'
        Value = Null
        Component = GuidesPriceList
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartPromo'
        Value = Null
        Component = deStartPromo
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndPromo'
        Value = Null
        Component = deEndPromo
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartSale'
        Value = Null
        Component = deStartSale
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndSale'
        Value = Null
        Component = deEndSale
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndReturn'
        Value = Null
        Component = deEndReturn
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateStart'
        Value = Null
        Component = deOperDateStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateEnd'
        Value = Null
        Component = deOperDateEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'CostPromo'
        Value = Null
        Component = edCostPromo
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CommentMain'
        Value = Null
        Component = edCommentMain
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AdvertisingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'AdvertisingName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalTradeId'
        Value = Null
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalTradeName'
        Value = Null
        Component = GuidesPersonalTrade
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalId'
        Value = Null
        Component = GuidesPersonal
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalName'
        Value = Null
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MonthPromo'
        Value = Null
        Component = deMonthPromo
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPromo'
        Value = Null
        Component = cbPromo
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Checked'
        Value = Null
        Component = cbChecked
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'CheckDate'
        Value = Null
        Component = deCheck
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'strSign'
        Value = Null
        Component = edstrSign
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'strSignNo'
        Value = Null
        Component = edstrSignNo
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberFull'
        Value = Null
        Component = FormParams
        ComponentItem = 'InvNumberFull'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPromoStateKind'
        Value = Null
        Component = cbPromoStateKind
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoStateKindId'
        Value = Null
        Component = GuidesPromoStateKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoStateKindName'
        Value = Null
        Component = GuidesPromoStateKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isTaxPromo'
        Value = Null
        Component = cbisTaxPromo
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isTaxPromo_Condition'
        Value = Null
        Component = cbisTaxPromo_Condition
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'SignInternalId'
        Value = Null
        Component = GuidesSignInternal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'SignInternalName'
        Value = Null
        Component = GuidesSignInternal
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 320
    Top = 264
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Promo'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42132d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPromoKindId'
        Value = Null
        Component = GuidesPromoKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId'
        Value = Null
        Component = GuidesPriceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartPromo'
        Value = Null
        Component = deStartPromo
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndPromo'
        Value = Null
        Component = deEndPromo
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartSale'
        Value = Null
        Component = deStartSale
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndSale'
        Value = Null
        Component = deEndSale
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndReturn'
        Value = Null
        Component = deEndReturn
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateStart'
        Value = Null
        Component = deOperDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateEnd'
        Value = Null
        Component = deOperDateEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMonthPromo'
        Value = Null
        Component = deMonthPromo
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCheckDate'
        Value = Null
        Component = deCheck
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChecked'
        Value = Null
        Component = cbChecked
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPromo'
        Value = Null
        Component = cbPromo
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCostPromo'
        Value = Null
        Component = edCostPromo
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCommentMain'
        Value = Null
        Component = edCommentMain
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalTradeId'
        Value = Null
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = Null
        Component = GuidesPersonal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 314
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    Left = 216
    Top = 264
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edOperDate
      end
      item
        Control = deStartPromo
      end
      item
        Control = deEndPromo
      end
      item
        Control = deStartSale
      end
      item
        Control = deEndSale
      end
      item
        Control = deOperDateStart
      end
      item
        Control = deOperDateEnd
      end
      item
        Control = edPromoKind
      end
      item
        Control = edUnit
      end
      item
        Control = edPriceList
      end
      item
        Control = edCostPromo
      end
      item
        Control = edPersonalTrade
      end
      item
        Control = edPersonal
      end
      item
        Control = edComment
      end
      item
        Control = edCommentMain
      end
      item
        Control = deMonthPromo
      end
      item
        Control = cbPromo
      end
      item
        Control = cbChecked
      end
      item
        Control = deCheck
      end
      item
        Control = edSignInternal
      end>
    Left = 280
    Top = 217
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 16
    Top = 360
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Promo_SetErased'
    Left = 374
    Top = 192
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Promo_SetUnErased'
    Left = 462
    Top = 200
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PromoGoods'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceSale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceSale'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPriceWithOutVAT'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceWithOutVAT'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPriceWithVAT'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceWithVAT'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceTender'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceTender'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountReal'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountReal'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountRealWeight'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountRealWeight'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPlanMin'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlanMin'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountPlanMinWeight'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlanMinWeight'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPlanMax'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlanMax'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountPlanMaxWeight'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlanMaxWeight'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsKindName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioGoodsKindCompleteId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindCompleteId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsKindCompleteName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindCompleteName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 424
    Top = 280
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 432
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = ''
    Left = 876
    Top = 196
  end
  object GuidesPriceList: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPriceList
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPriceList
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 748
    Top = 48
  end
  object GuidesPromoKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPromoKind
    FormNameParam.Value = 'TPromoKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPromoKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPromoKind
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPromoKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 460
    Top = 8
  end
  object GuidesPersonalTrade: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalTrade
    FormNameParam.Value = 'TPersonal_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonal_ChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalTrade
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 148
    Top = 64
  end
  object GuidesPersonal: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonal
    FormNameParam.Value = 'TPersonalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 468
    Top = 72
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    Key = 'Null'
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 676
  end
  object spSelect_Movement_PromoPartner: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PromoPartner'
    DataSet = PartnerCDS
    DataSets = <
      item
        DataSet = PartnerCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 352
    Top = 384
  end
  object PartnerCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 112
    Top = 552
  end
  object PartnerDS: TDataSource
    DataSet = PartnerCDS
    Left = 192
    Top = 520
  end
  object spErasedMIPartner: TdsdStoredProc
    StoredProcName = 'gpMovement_PromoPartner_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 510
    Top = 232
  end
  object spUnErasedMIPartner: TdsdStoredProc
    StoredProcName = 'gpMovement_PromoPartner_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 542
    Top = 232
  end
  object spInsertUpdateMIPartner: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PromoPartner'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'PartnerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailName_inf'
        Value = Null
        Component = PartnerCDS
        ComponentItem = 'RetailName_inf'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPriceListId'
        Value = Null
        Component = GuidesPriceList
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPriceListName'
        Value = Null
        Component = GuidesPriceList
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPersonalMarketingId'
        Value = Null
        Component = GuidesPersonal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPersonalMarketingName'
        Value = Null
        Component = GuidesPersonal
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPersonalTradeId'
        Value = Null
        Component = GuidesPersonalTrade
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPersonalTradeName'
        Value = Null
        Component = GuidesPersonalTrade
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 536
    Top = 272
  end
  object dsdDBViewAddOnPartner: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewPartner
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 118
    Top = 441
  end
  object ConditionPromoDS: TDataSource
    DataSet = ConditionPromoCDS
    Left = 776
    Top = 552
  end
  object ConditionPromoCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 720
    Top = 552
  end
  object spSelect_MovementItem_PromoCondition: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PromoCondition'
    DataSet = ConditionPromoCDS
    DataSets = <
      item
        DataSet = ConditionPromoCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = False
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 704
    Top = 328
  end
  object spInsertUpdateMICondition: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PromoCondition'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inConditionPromoId'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'ConditionPromoId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 704
    Top = 280
  end
  object spUnErasedMICondition: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Promo_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 702
    Top = 232
  end
  object spErasedMICondition: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Promo_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ConditionPromoCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 734
    Top = 216
  end
  object dsdDBViewAddOnConditionPromo: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = grtvConditionPromo
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 254
    Top = 377
  end
  object pmPartner: TPopupMenu
    Images = dmMain.ImageList
    Left = 72
    Top = 552
    object MenuItem1: TMenuItem
      Action = actInsertRecordPartner
    end
    object MenuItem2: TMenuItem
      Action = actErasedPartner
    end
    object MenuItem3: TMenuItem
      Action = actUnErasedPartner
    end
    object MenuItem4: TMenuItem
      Caption = '-'
    end
    object MenuItem5: TMenuItem
      Action = actRefresh
    end
  end
  object pmCondition: TPopupMenu
    Images = dmMain.ImageList
    Left = 40
    Top = 616
    object MenuItem7: TMenuItem
      Action = actInsertCondition
    end
    object MenuItem8: TMenuItem
      Action = actErasedCondition
    end
    object MenuItem9: TMenuItem
      Action = actUnErasedCondition
    end
    object MenuItem10: TMenuItem
      Caption = '-'
    end
    object MenuItem11: TMenuItem
      Action = actRefresh
    end
  end
  object PrintHead: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 808
    Top = 208
  end
  object spSelect_Movement_Promo_Print: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Promo_Print'
    DataSet = PrintHead
    DataSets = <
      item
        DataSet = PrintHead
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 864
    Top = 280
  end
  object AdvertisingCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 472
    Top = 488
  end
  object AdvertisingDS: TDataSource
    DataSet = AdvertisingCDS
    Left = 536
    Top = 480
  end
  object pmAdvertising: TPopupMenu
    Images = dmMain.ImageList
    Left = 112
    Top = 624
    object MenuItem13: TMenuItem
      Action = actInsertRecordAdvertising
    end
    object MenuItem14: TMenuItem
      Action = actErasedAdvertising
    end
    object MenuItem15: TMenuItem
      Action = actunErasedAdvertising
    end
    object MenuItem16: TMenuItem
      Caption = '-'
    end
    object MenuItem17: TMenuItem
      Action = actRefresh
    end
  end
  object spErasedAdvertising: TdsdStoredProc
    StoredProcName = 'gpMovement_PromoAdvertising_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = AdvertisingCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = AdvertisingCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 430
    Top = 384
  end
  object spUnErasedAdvertising: TdsdStoredProc
    StoredProcName = 'gpMovement_PromoAdvertising_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = AdvertisingCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = AdvertisingCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 534
    Top = 400
  end
  object spInsertUpdateMIAdvertising: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PromoAdvertising'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = AdvertisingCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAdvertisingId'
        Value = Null
        Component = AdvertisingCDS
        ComponentItem = 'AdvertisingId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = AdvertisingCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 448
    Top = 440
  end
  object spSelect_Movement_PromoAdvertising: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PromoAdvertising'
    DataSet = AdvertisingCDS
    DataSets = <
      item
        DataSet = AdvertisingCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 600
    Top = 504
  end
  object spUpdate_Movement_Promo_Data: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Promo_Data'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 96
    Top = 200
  end
  object PartnerListCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 272
    Top = 520
  end
  object PartnerLisrDS: TDataSource
    DataSet = PartnerListCDS
    Left = 336
    Top = 536
  end
  object spSelect_MovementItem_PromoPartner: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PromoPartner'
    DataSet = PartnerListCDS
    DataSets = <
      item
        DataSet = PartnerListCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 248
    Top = 616
  end
  object dsdDBViewAddOnPartnerList: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 446
    Top = 553
  end
  object spInsertUpdate_Movement_PromoPartnerFromRetail: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PromoPartnerFromRetail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inParentId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = FormParams
        ComponentItem = 'RetailId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1294
    Top = 520
  end
  object spInsertUpdate_MI_Param: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Promo_Param'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1040
    Top = 240
  end
  object CalcCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1088
    Top = 320
  end
  object CalcDS: TDataSource
    DataSet = CalcCDS
    Left = 1132
    Top = 318
  end
  object dsdDBViewAddOnCalc: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewCalc
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorColumn = calcPriceIn
        BackGroundValueColumn = Color_PriceIn
        ColorValueList = <>
      end
      item
        ColorColumn = calcTaxRetIn
        BackGroundValueColumn = Color_RetIn
        ColorValueList = <>
      end
      item
        ColorColumn = calcContractCondition
        BackGroundValueColumn = Color_ContractCond
        ColorValueList = <>
      end
      item
        ColorColumn = calcAmountSale
        BackGroundValueColumn = Color_AmountSale
        ColorValueList = <>
      end
      item
        ColorColumn = calcPriceWithVAT
        BackGroundValueColumn = Color_PriceWithVAT
        ColorValueList = <>
      end
      item
        ColorColumn = calcPrice
        BackGroundValueColumn = Color_Price
        ColorValueList = <>
      end
      item
        ColorColumn = calcSummaSale
        BackGroundValueColumn = Color_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = calcSummaProfit
        BackGroundValueColumn = Color_SummaProfit
        ColorValueList = <>
      end
      item
        ColorColumn = calcTaxPromo
        BackGroundValueColumn = Color_PromoCond
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <
      item
      end>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <
      item
        Column = calcTaxRetIn
        ValueColumn = Repository
        EditRepository = cxEditRepository1
      end
      item
        Column = calcContractCondition
        ValueColumn = Repository
        EditRepository = cxEditRepository1
      end
      item
        Column = calcTaxPromo
        ValueColumn = Repository
        EditRepository = cxEditRepository1
      end>
    Left = 1288
    Top = 367
  end
  object spSelectCalc: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_PromoGoods_Calc'
    DataSet = CalcCDS
    DataSets = <
      item
        DataSet = CalcCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisTaxPormo'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1012
    Top = 360
  end
  object spInsertUpdate_Calc: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_PromoGoods_Calc'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = CalcCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceIn'
        Value = Null
        Component = CalcCDS
        ComponentItem = 'PriceIn'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNum'
        Value = Null
        Component = CalcCDS
        ComponentItem = 'Num'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountSale'
        Value = Null
        Component = CalcCDS
        ComponentItem = 'AmountSale'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummaSale'
        Value = Null
        Component = CalcCDS
        ComponentItem = 'SummaSale'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractCondition'
        Value = Null
        Component = CalcCDS
        ComponentItem = 'ContractCondition'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxRetIn'
        Value = Null
        Component = CalcCDS
        ComponentItem = 'TaxRetIn'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxPromo'
        Value = Null
        Component = CalcCDS
        ComponentItem = 'TaxPromo'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisTaxPromo'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 672
    Top = 624
  end
  object dsdDBViewAddOnPlan: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 16
    Top = 423
  end
  object GuidesPromoStateKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPromoStateKind
    FormNameParam.Value = 'TPromoStateKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPromoStateKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPromoStateKind
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPromoStateKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 844
    Top = 48
  end
  object PromoStateKindDS: TDataSource
    DataSet = PromoStateKindDCS
    Left = 904
    Top = 584
  end
  object PromoStateKindDCS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 872
    Top = 552
  end
  object dsdDBViewAddOnPromoStateKind: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewPromoStateKind
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 352
    Top = 591
  end
  object spSelectMIPromoStateKind: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_Message_PromoStateKind'
    DataSet = PromoStateKindDCS
    DataSets = <
      item
        DataSet = PromoStateKindDCS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1208
    Top = 480
  end
  object spInsertUpdate_MI_PromoStateKind: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Message_PromoStateKind'
    DataSet = PromoStateKindDCS
    DataSets = <
      item
        DataSet = PromoStateKindDCS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = PromoStateKindDCS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPromoStateKindId'
        Value = Null
        Component = PromoStateKindDCS
        ComponentItem = 'PromoStateKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisQuickly'
        Value = Null
        Component = PromoStateKindDCS
        ComponentItem = 'isQuickly'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = PromoStateKindDCS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1232
    Top = 531
  end
  object dsdDBViewAddOnCalc2: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewCalc2
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <
      item
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorColumn = ссPriceIn
        BackGroundValueColumn = ссColor_PriceIn
        ColorValueList = <>
      end
      item
        ColorColumn = ссTaxRetIn
        BackGroundValueColumn = ссColor_RetIn
        ColorValueList = <>
      end
      item
        ColorColumn = ссContractCondition
        BackGroundValueColumn = ссColor_ContractCond
        ColorValueList = <>
      end
      item
        ColorColumn = ссAmountSale
        BackGroundValueColumn = ссColor_AmountSale
        ColorValueList = <>
      end
      item
        ColorColumn = ссPriceWithVAT
        BackGroundValueColumn = ссColor_PriceWithVAT
        ColorValueList = <>
      end
      item
        ColorColumn = ссPrice
        BackGroundValueColumn = ссColor_Price
        ColorValueList = <>
      end
      item
        ColorColumn = ссSummaSale
        BackGroundValueColumn = ссColor_SummaSale
        ColorValueList = <>
      end
      item
        ColorColumn = ссSummaProfit_Condition
        BackGroundValueColumn = ссColor_SummaProfit
        ColorValueList = <>
      end
      item
        ColorColumn = ссTaxPromo_Condition
        BackGroundValueColumn = ссColor_PromoCond
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <
      item
      end>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <
      item
        Column = ссTaxPromo_Condition
        ValueColumn = Repository2
        EditRepository = cxEditRepository1
      end
      item
        Column = ссTaxRetIn
        ValueColumn = Repository2
        EditRepository = cxEditRepository1
      end
      item
        Column = ссContractCondition
        ValueColumn = Repository2
        EditRepository = cxEditRepository1
      end>
    Left = 1200
    Top = 343
  end
  object spSelectCalc2: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_PromoGoods_Calc'
    DataSet = CalcCDS2
    DataSets = <
      item
        DataSet = CalcCDS2
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisTaxPormo'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1076
    Top = 424
  end
  object spInsertUpdate_Calc2: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_PromoGoods_Calc'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = CalcCDS2
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceIn'
        Value = Null
        Component = CalcCDS2
        ComponentItem = 'PriceIn'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNum'
        Value = Null
        Component = CalcCDS2
        ComponentItem = 'Num'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountSale'
        Value = Null
        Component = CalcCDS2
        ComponentItem = 'AmountSale'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummaSale'
        Value = Null
        Component = CalcCDS2
        ComponentItem = 'SummaSale'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractCondition'
        Value = Null
        Component = CalcCDS2
        ComponentItem = 'ContractCondition'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxRetIn'
        Value = Null
        Component = CalcCDS2
        ComponentItem = 'TaxRetIn'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxPromo'
        Value = Null
        Component = CalcCDS2
        ComponentItem = 'TaxPromo_Condition'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisTaxPromo'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1008
    Top = 560
  end
  object CalcCDS2: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1064
    Top = 408
  end
  object CalcDS2: TDataSource
    DataSet = CalcCDS2
    Left = 1132
    Top = 358
  end
  object spErasedPromoStateKind: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Promo_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = PromoStateKindDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = PromoStateKindDCS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1246
    Top = 264
  end
  object spUnErasedPromoStateKind: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Promo_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = PromoStateKindDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = PromoStateKindDCS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1238
    Top = 176
  end
  object GuidesSignInternal: TdsdGuides
    KeyField = 'Id'
    LookupControl = edSignInternal
    Key = 'Null'
    FormNameParam.Value = 'TSignInternalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TSignInternalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = 'Null'
        Component = GuidesSignInternal
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesSignInternal
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1252
    Top = 64
  end
  object PromoStateKindPopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 128
    Top = 584
    object MenuItem19: TMenuItem
      Action = actInsertRecordPromoStateKind
    end
    object MenuItem20: TMenuItem
      Action = actMISetErasedPromoStateKind
    end
    object MenuItem21: TMenuItem
      Action = actMISetUnErasedPromoStateKind
    end
    object MenuItem22: TMenuItem
      Caption = '-'
    end
    object MenuItem23: TMenuItem
      Action = actRefresh
    end
  end
  object spUpdate_Movement_isTaxPromo: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Promo_TaxPromo'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisTaxPromo'
        Value = Null
        Component = cbisTaxPromo
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisTaxPromo'
        Value = Null
        Component = cbisTaxPromo
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisTaxPromo_Condition'
        Value = Null
        Component = cbisTaxPromo_Condition
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 824
    Top = 616
  end
  object spUpdate_PromoStateKind: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_Message_PromoStateKind'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MovementItemId_PromoStateKind_true'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPromoStateKindId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PromoStateKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = FormParams
        ComponentItem = 'Comment_PromoStateKind'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 450
    Top = 624
  end
  object spSelectCalc_Print: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_PromoGoods_Calc'
    DataSet = PrintHead
    DataSets = <
      item
        DataSet = PrintHead
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisTaxPormo'
        Value = True
        Component = cbisTaxPromo
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 988
    Top = 440
  end
  object spGetPromoStateKind: TdsdStoredProc
    StoredProcName = 'gpGet_MI_Message_PromoStateKind'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsComplete'
        Value = False
        Component = FormParams
        ComponentItem = 'isComplete_PromoStateKind'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementItemId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementItemId_PromoStateKind_true'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoStateKindId'
        Value = ''
        Component = FormParams
        ComponentItem = 'PromoStateKindId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoStateKindName'
        Value = ''
        Component = FormParams
        ComponentItem = 'PromoStateKindName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = FormParams
        ComponentItem = 'Comment_PromoStateKind'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 280
    Top = 280
  end
  object cxEditRepository1: TcxEditRepository
    Left = 776
    Top = 416
    object cxEditRepository1CurrencyItem1: TcxEditRepositoryCurrencyItem
      Properties.DisplayFormat = ',0.## %;-,0.## %'
    end
    object cxEditRepository1CurrencyItem2: TcxEditRepositoryCurrencyItem
      Properties.DisplayFormat = ',0.##;-,0.##; ;'
    end
  end
end
