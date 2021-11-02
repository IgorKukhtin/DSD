inherited IncomeForm: TIncomeForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1088#1080#1093#1086#1076'>'
  ClientHeight = 516
  ClientWidth = 1083
  ExplicitWidth = 1099
  ExplicitHeight = 555
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 195
    Width = 1083
    Height = 321
    ExplicitTop = 195
    ExplicitWidth = 1083
    ExplicitHeight = 321
    ClientRectBottom = 321
    ClientRectRight = 1083
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1083
      ExplicitHeight = 297
      inherited cxGrid: TcxGrid
        Width = 1083
        Height = 297
        ExplicitWidth = 1083
        ExplicitHeight = 297
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Summ
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = OrderAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SampleSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = OrderSumm
            end
            item
              Format = ',0.00'
              Kind = skAverage
              Column = Price
            end
            item
              Format = ',0.00'
              Kind = skAverage
              Column = OrderPrice
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Summ
            end
            item
              Format = '+,0.###;-,0.###; ;'
              Kind = skSum
              Column = AmountDiff
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountManual
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = OrderAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SampleSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = OrderSumm
            end
            item
              Format = ',0.00'
              Kind = skAverage
              Column = Price
            end
            item
              Format = ',0.00'
              Kind = skAverage
              Column = OrderPrice
            end>
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
          object AreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085' ('#1090#1086#1074#1072#1088')'
            DataBinding.FieldName = 'AreaName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object AVGIncomePriceWarning: TcxGridDBColumn
            AlternateCaption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1073#1086#1083#1077#1077' 25 %'
            Caption = '>25%'
            DataBinding.FieldName = 'AVGIncomePriceWarning'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = '> 25%'
                ImageIndex = 10
                Value = True
              end>
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1073#1086#1083#1077#1077' 25 %'
            Options.Editing = False
            Width = 29
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceGoods
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 210
          end
          object PartnerGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'PartnerGoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object PartnerGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'PartnerGoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 124
          end
          object MakerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            HeaderAlignmentVert = vaCenter
            Width = 61
          end
          object ExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'ExpirationDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object ExpirationDatePG: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1087#1086' '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'ExpirationDatePG'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 82
          end
          object OrderAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1077
            DataBinding.FieldName = 'OrderAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object isAmountDiff: TcxGridDBColumn
            Caption = #1054#1090#1082#1083'. '#1087#1086' '#1082#1086#1083'-'#1074#1091
            DataBinding.FieldName = 'isAmountDiff'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1082#1083'. '#1087#1086' '#1082#1086#1083'-'#1074#1091' '#1086#1090' '#1079#1072#1103#1074#1082#1080
            Options.Editing = False
            Width = 38
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 41
          end
          object OrderPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1074' '#1079#1072#1103#1074#1082#1077
            DataBinding.FieldName = 'OrderPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 48
          end
          object isSummDiff: TcxGridDBColumn
            Caption = #1054#1090#1082#1083'. '#1087#1086' '#1094#1077#1085#1077
            DataBinding.FieldName = 'isSummDiff'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1082#1083'. '#1087#1086' '#1094#1077#1085#1077' '#1086#1090' '#1079#1072#1103#1074#1082#1080
            Options.Editing = False
            Width = 34
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 44
          end
          object OrderSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074' '#1079#1072#1103#1074#1082#1077
            DataBinding.FieldName = 'OrderSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object PersentDiff: TcxGridDBColumn
            Caption = '% '#1086#1090#1082#1083#1086#1085'.'
            DataBinding.FieldName = 'PersentDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1103
            Options.Editing = False
            Width = 43
          end
          object Summ: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object PriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'PriceWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object SamplePrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1057#1069#1052#1055#1051' '#1074'  '#1087#1088#1072#1081#1089'. '#1094#1077#1085#1072#1093' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'SamplePrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1057#1069#1052#1055#1051' '#1074'  '#1087#1088#1072#1081#1089'. '#1094#1077#1085#1072#1093' '#1089' '#1053#1044#1057
            Width = 75
          end
          object SalePrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083'. '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'SalePrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 72
          end
          object Percent: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'MarginPercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 32
          end
          object SaleSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083'. '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'SaleSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object AVGIncomePrice: TcxGridDBColumn
            Caption = #1057#1088'. '#1094#1077#1085#1072' '#1079#1072' '#1084#1077#1089#1103#1094
            DataBinding.FieldName = 'AVGIncomePrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object SampleSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1057#1069#1052#1055#1051' '#1074' '#1087#1088#1072#1081#1089'. '#1094#1077#1085#1072#1093' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'SampleSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1057#1069#1052#1055#1051' '#1074' '#1087#1088#1072#1081#1089'. '#1094#1077#1085#1072#1093' '#1089' '#1053#1044#1057
            Options.Editing = False
            Width = 75
          end
          object JuridicalPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' c/c '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'JuridicalPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            Visible = False
            HeaderHint = #1062#1077#1085#1072' c/c '#1089' '#1053#1044#1057
            Options.Editing = False
            Width = 70
          end
          object JuridicalPriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' c/c '#1089' '#1053#1044#1057' '#1073#1077#1079' % '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'JuridicalPriceWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            Visible = False
            HeaderHint = #1062#1077#1085#1072' c/c '#1089' '#1053#1044#1057' '#1073#1077#1079' % '#1082#1086#1088#1088'.'
            Options.Editing = False
            Width = 70
          end
          object PriceOptSP: TcxGridDBColumn
            Caption = #1052#1072#1082#1089'. '#1094#1077#1085#1072' '#1087#1086#1089#1090'-'#1082#1072' '#1087#1086' '#1057#1055' ('#1073#1077#1079' '#1053#1044#1057')'
            DataBinding.FieldName = 'PriceOptSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1087#1090'.-'#1074#1110#1076#1087'. '#1094#1110#1085#1072' '#1079#1072' '#1091#1087'. (11)'
            Options.Editing = False
            Width = 76
          end
          object Goods_PercentMarkup: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080' ('#1087#1086' '#1089#1077#1090#1080')'
            DataBinding.FieldName = 'Goods_PercentMarkup'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1085#1072#1094#1077#1085#1082#1080
            Options.Editing = False
            Width = 53
          end
          object Goods_Price: TcxGridDBColumn
            Caption = #1060#1080#1082#1089'. '#1094#1077#1085#1072' ('#1087#1086' '#1089#1077#1090#1080')'
            DataBinding.FieldName = 'Goods_Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 60
          end
          object Goods_isTop: TcxGridDBColumn
            Caption = #1058#1054#1055' ('#1087#1086' '#1089#1077#1090#1080')'
            DataBinding.FieldName = 'Goods_isTop'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 60
          end
          object PartitionGoods: TcxGridDBColumn
            Caption = #1057#1077#1088#1080#1103
            DataBinding.FieldName = 'PartionGoods'
            HeaderAlignmentVert = vaCenter
            Width = 63
          end
          object FEA: TcxGridDBColumn
            Caption = #1059#1050' '#1042#1069#1044
            DataBinding.FieldName = 'FEA'
            HeaderAlignmentVert = vaCenter
            Width = 65
          end
          object Measure: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084
            DataBinding.FieldName = 'Measure'
            HeaderAlignmentVert = vaCenter
            Width = 53
          end
          object DublePriceColour: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1099#1077' '#1094#1077#1085#1099
            DataBinding.FieldName = 'DublePriceColour'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
          object SertificatNumber: TcxGridDBColumn
            AlternateCaption = #1053#1086#1084#1077#1088' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080
            Caption = #8470' '#1088#1077#1075
            DataBinding.FieldName = 'SertificatNumber'
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1086#1084#1077#1088' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080
            Width = 64
          end
          object SertificatStart: TcxGridDBColumn
            AlternateCaption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080
            Caption = #1053#1072#1095'. '#1088#1077#1075'.'
            DataBinding.FieldName = 'SertificatStart'
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080
            Width = 65
          end
          object SertificatEnd: TcxGridDBColumn
            AlternateCaption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080
            Caption = #1054#1082#1086#1085#1095'. '#1088#1077#1075'.'
            DataBinding.FieldName = 'SertificatEnd'
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080
            Width = 58
          end
          object WarningColor: TcxGridDBColumn
            Caption = '!'
            DataBinding.FieldName = 'WarningColor'
            Visible = False
            VisibleForCustomization = False
          end
          object AmountManual: TcxGridDBColumn
            Caption = #1060#1072#1082#1090'. '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'AmountManual'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 54
          end
          object AmountDiff: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'AmountDiff'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = '+,0.###;-,0.###; ;'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object ReasonDifferencesName: TcxGridDBColumn
            Caption = #1055#1088#1080#1095#1080#1085#1072' '#1088#1072#1079#1085#1086#1075#1083#1072#1089#1080#1103
            DataBinding.FieldName = 'ReasonDifferencesName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 123
          end
          object isTop: TcxGridDBColumn
            Caption = #1058#1054#1055' ('#1072#1087#1090#1077#1082#1072')'
            DataBinding.FieldName = 'isTop'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 60
          end
          object Fix_Price: TcxGridDBColumn
            Caption = #1060#1080#1082#1089'. '#1094#1077#1085#1072' ('#1072#1087#1090#1077#1082#1072')'
            DataBinding.FieldName = 'Fix_Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 60
          end
          object PercentMarkup: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080' ('#1072#1087#1090#1077#1082#1072')'
            DataBinding.FieldName = 'PercentMarkup'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '% '#1085#1072#1094#1077#1085#1082#1080
            Options.Editing = False
            Width = 70
          end
          object Color_calc: TcxGridDBColumn
            DataBinding.FieldName = 'Color_calc'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 40
          end
          object Color_ExpirationDate: TcxGridDBColumn
            DataBinding.FieldName = 'Color_ExpirationDate'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
          object isPrint: TcxGridDBColumn
            Caption = #1055#1077#1095'. '#1089#1090#1080#1082#1077#1088
            DataBinding.FieldName = 'isPrint'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object PrintCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1090#1080#1082#1077#1088#1086#1074
            DataBinding.FieldName = 'PrintCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1077#1095#1072#1090#1072#1077#1084#1099#1093' '#1089#1090#1080#1082#1077#1088#1086#1074
            Width = 62
          end
          object isSp: TcxGridDBColumn
            Caption = #1057#1086#1094'. '#1087#1088#1086#1077#1082#1090
            DataBinding.FieldName = 'isSp'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042' '#1089#1087#1080#1089#1082#1077' '#1087#1088#1086#1077#1082#1090#1072' '#171#1044#1086#1089#1090#1091#1087#1085#1099#1077' '#1083#1077#1082#1072#1088#1089#1090#1074#1072#187
            Options.Editing = False
            Width = 60
          end
          object PercentMarkupSP: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1057#1055
            DataBinding.FieldName = 'PercentMarkupSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object RetailName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1089#1077#1090#1080
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1072#1079#1074#1072#1085#1080#1077' '#1089#1077#1090#1080
            Options.Editing = False
            Width = 42
          end
          object InsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' '#1089#1086#1079#1076#1072#1083
            DataBinding.FieldName = 'InsertName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1089#1086#1079#1076#1072#1085#1080#1103
            DataBinding.FieldName = 'InsertDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ConditionsKeepName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'ConditionsKeepName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object PromoBonus: TcxGridDBColumn
            Caption = #1052#1072#1088#1082#1077#1090'. '#1073#1086#1085#1091#1089
            DataBinding.FieldName = 'PromoBonus'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object MarginPercentUnit: TcxGridDBColumn
            Caption = '% '#1087#1086' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1082#1080' '#1090#1086#1095#1082#1080
            DataBinding.FieldName = 'MarginPercentUnit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object isLearnWeek: TcxGridDBColumn
            Caption = #1059#1095#1072#1089'-'#1102#1090' '#1085#1072' '#1101#1090#1086#1081' '#1085#1077#1076#1077#1083#1077
            DataBinding.FieldName = 'isLearnWeek'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1083
    Height = 169
    TabOrder = 3
    ExplicitWidth = 1083
    ExplicitHeight = 169
    inherited edInvNumber: TcxTextEdit
      Left = 8
      Properties.ReadOnly = False
      ExplicitLeft = 8
      ExplicitWidth = 160
      Width = 160
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 174
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 174
      ExplicitWidth = 83
      Width = 83
    end
    inherited cxLabel2: TcxLabel
      Left = 174
      ExplicitLeft = 174
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 63
      TabOrder = 9
      ExplicitTop = 63
      ExplicitWidth = 145
      ExplicitHeight = 22
      Width = 145
    end
    object cxLabel3: TcxLabel
      Left = 263
      Top = 5
      Caption = #1070#1088'. '#1083#1080#1094#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082
    end
    object edFrom: TcxButtonEdit
      Left = 263
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 133
    end
    object edTo: TcxButtonEdit
      Left = 546
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 6
      Width = 287
    end
    object cxLabel4: TcxLabel
      Left = 546
      Top = 45
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object edPriceWithVAT: TcxCheckBox
      Left = 994
      Top = 23
      Hint = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
      Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057
      ParentShowHint = False
      ShowHint = True
      TabOrder = 14
      Width = 85
    end
    object cxLabel10: TcxLabel
      Left = 902
      Top = 5
      Caption = #1058#1080#1087' '#1053#1044#1057
    end
    object edNDSKind: TcxButtonEdit
      Left = 902
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 16
      Width = 86
    end
    object cxLabel5: TcxLabel
      Left = 403
      Top = 5
      Caption = #1059#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072' '#1087#1086#1089#1090'-'#1082#1072' '
    end
    object edContract: TcxButtonEdit
      Left = 403
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 218
    end
    object edPaymentDate: TcxDateEdit
      Left = 627
      Top = 23
      EditValue = 42144d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 18
      Width = 83
    end
    object cxLabel6: TcxLabel
      Left = 627
      Top = 5
      Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
    end
    object ceTotalSummMVAT: TcxCurrencyEdit
      Left = 958
      Top = 62
      EditValue = 1111111.000000000000000000
      Enabled = False
      ParentFont = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DisplayFormat = ',0.00;-,0.00'
      Style.BorderColor = clBtnFace
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      StyleDisabled.BorderColor = clBtnFace
      StyleDisabled.BorderStyle = ebsSingle
      StyleDisabled.TextColor = clBtnText
      TabOrder = 20
      Width = 94
    end
    object ceTotalSummPVAT: TcxCurrencyEdit
      Left = 958
      Top = 83
      EditValue = 1111111.000000000000000000
      Enabled = False
      ParentFont = False
      Properties.Alignment.Horz = taRightJustify
      Properties.DisplayFormat = ',0.00;-,0.00'
      Style.BorderColor = clBtnFace
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
      StyleDisabled.BorderColor = clBtnFace
      StyleDisabled.BorderStyle = ebsSingle
      StyleDisabled.TextColor = clBtnText
      TabOrder = 21
      Width = 94
    end
    object cxLabel7: TcxLabel
      Left = 860
      Top = 63
      Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object cxLabel8: TcxLabel
      Left = 847
      Top = 82
      Caption = #1057#1091#1084#1084#1072' c '#1053#1044#1057':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -15
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object cxLabel9: TcxLabel
      Left = 212
      Top = 46
      Caption = #8470' '#1074' '#1072#1087#1090#1077#1082#1077
    end
    object edPointNumber: TcxTextEdit
      Left = 211
      Top = 63
      Properties.ReadOnly = False
      Style.BorderColor = clFuchsia
      TabOrder = 11
      Width = 99
    end
    object cxLabel11: TcxLabel
      Left = 314
      Top = 46
      Caption = #1044#1072#1090#1072' '#1072#1087#1090#1077#1082#1080
    end
    object edPointDate: TcxDateEdit
      Left = 314
      Top = 63
      EditValue = 42132d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 3
      Width = 82
    end
    object cbFarmacyShow: TcxCheckBox
      Left = 171
      Top = 63
      DragMode = dmAutomatic
      Enabled = False
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -11
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 10
      Width = 22
    end
    object cxLabel12: TcxLabel
      Left = 149
      Top = 47
      Caption = #1055#1088#1086#1074#1077#1088#1077#1085':'
    end
    object cxLabel13: TcxLabel
      Left = 403
      Top = 46
      Caption = #1070#1088'.'#1083#1080#1094#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100
    end
    object edJuridical: TcxButtonEdit
      Left = 403
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 28
      Width = 137
    end
    object chbIsPay: TcxCheckBox
      Left = 713
      Top = 23
      Caption = #1054#1087#1083#1072#1095#1077#1085#1072
      Properties.ReadOnly = True
      TabOrder = 29
      Width = 73
    end
    object вуDateLastPay: TcxDateEdit
      Left = 790
      Top = 23
      EditValue = 42144d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 30
      Width = 103
    end
    object cxLabel17: TcxLabel
      Left = 790
      Top = 5
      Hint = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099' '#1087#1086' '#1073#1072#1085#1082#1091
      Caption = #1044#1072#1090#1072' '#1086#1087#1083'. '#1087#1086' '#1073#1072#1085#1082#1091
      ParentShowHint = False
      ShowHint = True
    end
    object cbisDocument: TcxCheckBox
      Left = 312
      Top = 141
      Caption = #1054#1088#1080#1075#1080#1085#1072#1083' '#1085#1072#1082#1083'. ('#1076#1072'/'#1085#1077#1090')'
      Properties.ReadOnly = True
      TabOrder = 32
      Width = 150
    end
    object cbisRegistered: TcxCheckBox
      Left = 713
      Top = 102
      Caption = #1052#1077#1076#1088#1077#1077#1089#1090#1088' Pfizer'
      Properties.ReadOnly = True
      TabOrder = 33
      Width = 111
    end
    object cbisDeferred: TcxCheckBox
      Left = 490
      Top = 141
      Caption = #1086#1090#1083#1086#1078#1077#1085
      Properties.ReadOnly = True
      TabOrder = 34
      Width = 68
    end
    object edMemberIncomeCheck: TcxTextEdit
      Left = 153
      Top = 141
      Properties.ReadOnly = True
      Style.BorderColor = clFuchsia
      TabOrder = 35
      Width = 136
    end
    object edCheckDate: TcxDateEdit
      Left = 8
      Top = 141
      EditValue = 42144d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 36
      Width = 136
    end
    object cxLabel16: TcxLabel
      Left = 8
      Top = 126
      Caption = #1044#1072#1090#1072' '#1087#1088#1086#1074#1077#1088#1082#1080' '#1091#1087'. '#1083#1080#1094#1086#1084
    end
    object cbDifferent: TcxCheckBox
      Left = 564
      Top = 102
      Hint = #1072#1087#1090#1077#1082#1072' '#1076#1088'. '#1102#1088'.'#1083#1080#1094#1072
      Caption = #1072#1087#1090#1077#1082#1072' '#1076#1088'. '#1102#1088'.'#1083#1080#1094#1072
      ParentShowHint = False
      ShowHint = True
      TabOrder = 38
      Width = 137
    end
    object cxLabel18: TcxLabel
      Left = 8
      Top = 87
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object edComment: TcxTextEdit
      Left = 8
      Top = 102
      Properties.ReadOnly = False
      TabOrder = 40
      Width = 550
    end
    object cbUseNDSKind: TcxCheckBox
      Left = 564
      Top = 85
      Hint = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1089#1090#1072#1074#1082#1091' '#1053#1044#1057' '#1087#1086' '#1087#1088#1080#1093#1086#1076#1091
      Caption = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1090#1100' '#1089#1090#1072#1074#1082#1091' '#1053#1044#1057' '#1087#1086' '#1087#1088#1080#1093#1086#1076#1091
      ParentShowHint = False
      ShowHint = True
      TabOrder = 41
      Width = 222
    end
  end
  object edInvNumberOrder: TcxButtonEdit [2]
    Left = 564
    Top = 141
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 269
  end
  object cxLabel25: TcxLabel [3]
    Left = 564
    Top = 126
    Caption = #1047#1072#1103#1074#1082#1072' '#1087#1086#1089#1090'.'
  end
  object cxLabel14: TcxLabel [4]
    Left = 230
    Top = 126
    Caption = #1060#1048#1054' '#1091#1087#1086#1083#1085#1086#1084#1086#1095'. '#1083#1080#1094#1072
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 179
    Top = 416
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Tag'
          'Width')
      end>
    Left = 40
    Top = 408
  end
  inherited ActionList: TActionList
    Left = 375
    Top = 455
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect
        end>
      RefreshOnTabSetChanges = True
    end
    object actUpdate_BranchDate: TdsdExecStoredProc [2]
      Category = 'PartnerData'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_BranchDate
      StoredProcList = <
        item
          StoredProc = spUpdate_BranchDate
        end>
      Caption = 'actUpdate_BranchDate'
    end
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end
        item
          StoredProc = spUpdateMovementIncome_OrderExt
        end>
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
        end>
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus [9]
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus [10]
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
          StoredProc = spGet
        end>
    end
    inherited actDeleteMovement: TChangeGuidesStatus [11]
    end
    inherited actMovementItemContainer: TdsdOpenForm [12]
    end
    object actGoodsKindChoice: TOpenChoiceForm [13]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
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
    inherited MovementItemProtocolOpenForm: TdsdOpenForm [14]
    end
    inherited MultiAction: TMultiAction [15]
    end
    inherited actNewDocument: TdsdInsertUpdateAction [16]
    end
    inherited actFormClose: TdsdFormClose [17]
    end
    inherited actAddMask: TdsdExecStoredProc [18]
    end
    object actChoiceGoods: TOpenChoiceForm [19]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceGoods'
      FormName = 'TGoodsLiteForm'
      FormNameParam.Value = 'TGoodsLiteForm'
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
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actRefreshPrice: TdsdDataSetRefresh [20]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshGoodsCode: TdsdExecStoredProc [21]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spIncome_GoodsId
      StoredProcList = <
        item
          StoredProc = spIncome_GoodsId
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1089#1095#1077#1090' '#1082#1086#1076#1086#1074
      Hint = #1055#1077#1088#1077#1089#1095#1077#1090' '#1082#1086#1076#1086#1074
      ImageIndex = 43
    end
    object actisDocument: TdsdExecStoredProc [22]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spisDocument
      StoredProcList = <
        item
          StoredProc = spisDocument
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1054#1088#1080#1075#1080#1085#1072#1083' '#1044#1072'/'#1053#1077#1090'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1054#1088#1080#1075#1080#1085#1072#1083' '#1044#1072'/'#1053#1077#1090'"'
      ImageIndex = 58
    end
    object actCheckObject: TdsdExecStoredProc [23]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spCheckObject
      StoredProcList = <
        item
          StoredProc = spCheckObject
        end>
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1085#1072#1096#1077#1075#1086' '#1090#1086#1074#1072#1088#1072
      Hint = #1055#1088#1086#1074#1077#1088#1082#1072' '#1085#1072#1096#1077#1075#1086' '#1090#1086#1074#1072#1088#1072
      ImageIndex = 75
    end
    object macCalculateSalePrice: TMultiAction [24]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actCheckObject
        end
        item
          Action = actUpdate_OrderExternal_Deferred
        end
        item
          Action = actCalculateSalePrice
        end
        item
          Action = actLinkCheck
        end
        item
          Action = actUpdate_BranchDate
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1077#1088#1077#1089#1095#1077#1090#1077' '#1094#1077#1085' '#1080' '#1080#1079#1084#1077#1085#1077#1085#1080#1080' '#1089#1090#1072#1090#1091#1089#1072' '#1079#1072#1103#1074#1082#1080'?'
      InfoAfterExecute = #1062#1077#1085#1099' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1087#1077#1088#1077#1089#1095#1080#1090#1072#1085#1099
      Caption = #1056#1072#1089#1095#1077#1090' '#1094#1077#1085#1099' '#1087#1088#1086#1076#1072#1078#1080', '#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1090#1072#1090#1091#1089#1072' '#1079#1072#1103#1074#1082#1080
      Hint = #1056#1072#1089#1095#1077#1090' '#1094#1077#1085#1099' '#1087#1088#1086#1076#1072#1078#1080', '#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1090#1072#1090#1091#1089#1072' '#1079#1072#1103#1074#1082#1080
      ImageIndex = 75
    end
    object actUpdate_OrderExternal_Deferred: TdsdExecStoredProc [25]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_OrderExternal_Deferred
      StoredProcList = <
        item
          StoredProc = spUpdate_OrderExternal_Deferred
        end>
      Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1090#1072#1090#1091#1089#1072' '#1079#1072#1082#1072#1079#1072
      Hint = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1089#1090#1072#1090#1091#1089#1072' '#1079#1072#1082#1072#1079#1072
      ImageIndex = 75
    end
    object actLinkCheck: TdsdExecStoredProc [26]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spLinkCheck
      StoredProcList = <
        item
          StoredProc = spLinkCheck
        end>
      Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1087#1088#1080#1074#1103#1079#1082#1080
      Hint = #1055#1088#1086#1074#1077#1088#1082#1072' '#1087#1088#1080#1074#1103#1079#1082#1080
      ImageIndex = 75
    end
    object actCalculateSalePrice: TdsdExecStoredProc [27]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spCalculateSalePrice
      StoredProcList = <
        item
          StoredProc = spCalculateSalePrice
        end
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1056#1072#1089#1095#1077#1090' '#1094#1077#1085#1099' '#1087#1088#1086#1076#1072#1078#1080
      Hint = #1056#1072#1089#1095#1077#1090' '#1094#1077#1085#1099' '#1087#1088#1086#1076#1072#1078#1080
      ImageIndex = 75
    end
    object actPrintStickerOld: TdsdPrintAction [28]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      ImageIndex = 18
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'UnitName'
          Value = 42370d
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = 42371d
          Component = GuidesJuridical
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072' '#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      ReportNameParam.Value = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072' '#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintReestr: TdsdPrintAction [29]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1077#1077#1089#1090#1088#1072' '#1083#1077#1082#1072#1088#1089#1090#1074#1077#1085#1085#1099#1093' '#1087#1088#1077#1087#1072#1088#1072#1090#1086#1074
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1077#1077#1089#1090#1088#1072' '#1083#1077#1082#1072#1088#1089#1090#1074#1077#1085#1085#1099#1093' '#1087#1088#1077#1087#1072#1088#1072#1090#1086#1074
      ImageIndex = 17
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1056#1077#1077#1089#1090#1088' '#1083#1077#1082#1072#1088#1089#1090#1074#1077#1085#1085#1099#1093' '#1087#1088#1077#1087#1072#1088#1072#1090#1086#1074
      ReportNameParam.Value = #1056#1077#1077#1089#1090#1088' '#1083#1077#1082#1072#1088#1089#1090#1074#1077#1085#1085#1099#1093' '#1087#1088#1077#1087#1072#1088#1072#1090#1086#1074
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object mactEditPartnerData: TMultiAction [30]
      Category = 'PartnerData'
      MoveParams = <>
      ActionList = <
        item
          Action = actPartnerDataDialod
        end
        item
          Action = actUpdateIncome_PartnerData
        end
        item
          Action = actRefresh
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1080' '#1076#1072#1090#1091' '#1086#1087#1083#1072#1090#1099
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1080' '#1076#1072#1090#1091' '#1086#1087#1083#1072#1090#1099
      ImageIndex = 35
    end
    inherited actPrint: TdsdPrintAction [31]
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1056#1072#1089#1093#1086#1076#1085#1072#1103'_'#1085#1072#1082#1083#1072#1076#1085#1072#1103'_'#1076#1083#1103'_'#1084#1077#1085#1077#1076#1078#1077#1088#1072
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' '#1076#1083#1103' '#1084#1077#1085#1077#1076#1078#1077#1088#1072
      ReportNameParam.Value = #1056#1072#1089#1093#1086#1076#1085#1072#1103'_'#1085#1072#1082#1083#1072#1076#1085#1072#1103'_'#1076#1083#1103'_'#1084#1077#1085#1077#1076#1078#1077#1088#1072
      ReportNameParam.ParamType = ptInput
    end
    object actPartnerDataDialod: TExecuteDialog
      Category = 'PartnerData'
      MoveParams = <>
      Caption = 'actPartnerDataDialog'
      FormName = 'TIncomePartnerDataDialogForm'
      FormNameParam.Value = 'TIncomePartnerDataDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'InvNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'InvNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaymentDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'PaymentDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdateIncome_PartnerData: TdsdExecStoredProc
      Category = 'PartnerData'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateIncome_PartnerData
      StoredProcList = <
        item
          StoredProc = spUpdateIncome_PartnerData
        end>
      Caption = 'actUpdateReturnOut_PartnerData'
    end
    object actPrintSticker_notPrice: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintSticker
      StoredProcList = <
        item
          StoredProc = spSelectPrintSticker
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080' '#1073#1077#1079' '#1094#1077#1085#1099
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080' '#1073#1077#1079' '#1094#1077#1085#1099
      ImageIndex = 19
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = ''
          Component = GuidesJuridical
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPrice'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072' '#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072' '#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      ReportNameParam.Value = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072' '#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintSticker: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintSticker
      StoredProcList = <
        item
          StoredProc = spSelectPrintSticker
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072'-'#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      ImageIndex = 18
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = GuidesJuridical
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPrice'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072' '#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072' '#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      ReportNameParam.Value = #1055#1077#1095#1072#1090#1100' '#1089#1090#1080#1082#1077#1088#1072' '#1089#1072#1084#1086#1082#1083#1077#1081#1082#1080
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object spUpdateisDeferredNo: TdsdExecStoredProc
      Category = 'Deferred'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isDeferred_No
      StoredProcList = <
        item
          StoredProc = spUpdate_isDeferred_No
        end>
      Caption = #1054#1090#1083#1086#1078#1077#1085' - '#1053#1077#1090
      Hint = #1054#1090#1083#1086#1078#1077#1085' - '#1053#1077#1090
      ImageIndex = 77
    end
    object spUpdateisDeferredYes: TdsdExecStoredProc
      Category = 'Deferred'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isDeferred_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_isDeferred_Yes
        end>
      Caption = #1054#1090#1083#1086#1078#1077#1085' - '#1044#1072
      Hint = #1054#1090#1083#1086#1078#1077#1085' - '#1044#1072
      ImageIndex = 52
    end
    object actUpdateCheck: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate_Check
      StoredProcList = <
        item
          StoredProc = spUpdate_Check
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 26
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object ExecuteDialogCheck: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1088#1086#1074#1077#1088#1082#1080' '#1091#1087'. '#1083#1080#1094#1086#1084
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1088#1086#1074#1077#1088#1082#1080' '#1091#1087'. '#1083#1080#1094#1086#1084
      ImageIndex = 26
      FormName = 'TIncomeCheckDialogForm'
      FormNameParam.Value = 'TIncomeCheckDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'CheckDate'
          Value = 42261d
          Component = edCheckDate
          DataType = ftDateTime
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberIncomeCheckId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'MemberIncomeCheckId'
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberIncomeCheckName'
          Value = ''
          Component = edMemberIncomeCheck
          DataType = ftString
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macUpdateCheck: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogCheck
        end
        item
          Action = actUpdateCheck
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1088#1086#1074#1077#1088#1082#1080' '#1091#1087'. '#1083#1080#1094#1086#1084
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1088#1086#1074#1077#1088#1082#1080' '#1091#1087'. '#1083#1080#1094#1086#1084
      ImageIndex = 26
    end
    object actComplete: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementComplete
      StoredProcList = <
        item
          StoredProc = spMovementComplete
        end
        item
          StoredProc = spGet
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1076#1085#1080#1084' '#1095#1080#1089#1083#1086#1084
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1079#1072#1076#1085#1080#1084' '#1095#1080#1089#1083#1086#1084
      ImageIndex = 12
    end
    object actShowMessage: TShowMessageAction
      Category = 'Union'
      MoveParams = <>
    end
    object actUpdateOperDate: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actExecuteDataDialog
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateIncome_OperData
      StoredProcList = <
        item
          StoredProc = spUpdateIncome_OperData
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#8470' '#1080' '#1076#1072#1090#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#8470' '#1080' '#1076#1072#1090#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 43
    end
    object actExecuteDataDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteDataDialog'
      FormName = 'TIncomeOperDataDialogForm'
      FormNameParam.Value = 'TIncomeOperDataDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'InvNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'InvNumberUpdate'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'OperDateUpdate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actExecuteDialogExpirationDate: TExecuteDialog
      Category = 'DSDLib'
      ActiveControl = cbDifferent
      MoveParams = <>
      Caption = 'actExecuteDialogExpirationDate'
      FormName = 'TDataDialogForm'
      FormNameParam.Value = 'TDataDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'ExpirationDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_ExpirationDate: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actExecuteDialogExpirationDate
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_ExpirationDate
      StoredProcList = <
        item
          StoredProc = spUpdate_ExpirationDate
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1087#1086' '#1089#1090#1088#1086#1082#1077' '#1090#1086#1074#1072#1088#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1087#1086' '#1089#1090#1088#1086#1082#1077' '#1090#1086#1074#1072#1088#1072
      ImageIndex = 47
    end
    object actExecuteDialogBranchDate: TExecuteDialog
      Category = 'DSDLib'
      ActiveControl = cbDifferent
      MoveParams = <>
      Caption = 'actExecuteDialogExpirationDate'
      FormName = 'TDataDialogForm'
      FormNameParam.Value = 'TDataDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'BranchDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_SetBranchDate: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actExecuteDialogBranchDate
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SetBranchDate
      StoredProcList = <
        item
          StoredProc = spUpdate_SetBranchDate
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1044#1072#1090#1091' '#1072#1087#1090#1077#1082#1080'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1044#1072#1090#1091' '#1072#1087#1090#1077#1082#1080'"'
      ImageIndex = 67
    end
    object actInsert_ReturnOut: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_ReturnOut
      StoredProcList = <
        item
          StoredProc = spInsert_ReturnOut
        end>
      Caption = 'actInsert_ReturnOut'
      QuestionBeforeExecute = #1057#1086#1079#1076#1072#1090#1100' '#1074#1086#1079#1074#1088#1072#1090#1085#1091#1102' '#1085#1072#1082#1083#1072#1076#1085#1091#1102'?'
    end
    object actOpenReturnOut: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actInsert_ReturnOut
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1074#1086#1079#1074#1088#1072#1090#1085#1091#1102' '#1085#1072#1082#1083#1072#1076#1085#1091#1102
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1074#1086#1079#1074#1088#1072#1090#1085#1091#1102' '#1085#1072#1082#1083#1072#1076#1085#1091#1102
      ImageIndex = 27
      FormName = 'TReturnOutForm'
      FormNameParam.Value = 'TReturnOutForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'ReturnOutId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 448
  end
  inherited MasterCDS: TClientDataSet
    Left = 96
    Top = 448
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Income'
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
        Name = 'inShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
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
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 144
    Top = 272
  end
  inherited BarManager: TdxBarManager
    Left = 416
    Top = 455
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbComplete'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbisDocument'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
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
          ItemName = 'bbCalculateSalePrice'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefreshGoodsCode'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateisDeferredNo'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenReturnOut'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_ExpirationDate'
        end>
    end
    object bbPrint_Bill: TdxBarButton [5]
      Action = actPrintSticker
      Category = 0
    end
    object bbPrintTax: TdxBarButton [6]
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbPrintTax_Client: TdxBarButton [7]
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Visible = ivAlways
      ImageIndex = 18
    end
    inherited bbStatic: TdxBarStatic
      Caption = '                                    '
      Hint = '                                    '
    end
    inherited bbAddMask: TdxBarButton
      Visible = ivNever
    end
    object bbTax: TdxBarButton
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
      Category = 0
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
      Visible = ivAlways
      ImageIndex = 41
    end
    object bbRefreshGoodsCode: TdxBarButton
      Action = actRefreshGoodsCode
      Category = 0
    end
    object bbCalculateSalePrice: TdxBarButton
      Action = macCalculateSalePrice
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = mactEditPartnerData
      Category = 0
    end
    object bbisDocument: TdxBarButton
      Action = actisDocument
      Category = 0
    end
    object bbPrintSticker_notPrice: TdxBarButton
      Action = actPrintSticker_notPrice
      Category = 0
    end
    object bbUpdateisDeferredYes: TdxBarButton
      Action = spUpdateisDeferredYes
      Caption = #1047#1072#1082#1072#1079' '#1054#1090#1083#1086#1078#1077#1085' - '#1044#1072
      Category = 0
    end
    object bbUpdateisDeferredNo: TdxBarButton
      Action = spUpdateisDeferredNo
      Caption = #1047#1072#1082#1072#1079' '#1054#1090#1083#1086#1078#1077#1085' - '#1053#1077#1090
      Category = 0
    end
    object bbUpdateCheck: TdxBarButton
      Action = macUpdateCheck
      Category = 0
    end
    object bbPrintReestr: TdxBarButton
      Action = actPrintReestr
      Category = 0
    end
    object bbComplete: TdxBarButton
      Action = actComplete
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actUpdateOperDate
      Category = 0
    end
    object bbUpdate_ExpirationDate: TdxBarButton
      Action = actUpdate_ExpirationDate
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Action = actUpdate_SetBranchDate
      Category = 0
    end
    object bbOpenReturnOut: TdxBarButton
      Action = actOpenReturnOut
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        BackGroundValueColumn = DublePriceColour
        ColorValueList = <>
      end
      item
        ValueColumn = WarningColor
        ColorValueList = <>
      end
      item
        ColorColumn = isTop
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = JuridicalPriceWithVAT
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = JuridicalPrice
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = Summ
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = SertificatStart
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = SertificatNumber
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = SertificatEnd
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = SaleSumm
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = SalePrice
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = PriceWithVAT
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = ReasonDifferencesName
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = Price
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = PersentDiff
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = Percent
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = PartnerGoodsName
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = PartnerGoodsCode
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = PartitionGoods
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = OrderSumm
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = OrderPrice
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsName
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = Measure
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = OrderAmount
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = isSummDiff
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = isAmountDiff
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MakerName
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = Fix_Price
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = FEA
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = ExpirationDate
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = DublePriceColour
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsCode
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = AVGIncomePriceWarning
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = AVGIncomePrice
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = AmountManual
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = AmountDiff
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = Amount
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = PercentMarkup
        ValueColumn = Color_ExpirationDate
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    Left = 774
    Top = 289
  end
  inherited PopupMenu: TPopupMenu
    Left = 800
    Top = 464
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
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
        Name = 'ReportNameIncome'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameIncomeTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameIncomeBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = Null
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaymentDate'
        Value = Null
        Component = edPaymentDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberUpdate'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateUpdate'
        Value = Null
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'ExpirationDate'
        Value = Null
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchDate'
        Value = Null
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnOutId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 416
  end
  inherited StatusGuides: TdsdGuides
    Left = 96
    Top = 40
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Income'
    Left = 48
    Top = 48
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Income'
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
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
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
        Name = 'PriceWithVAT'
        Value = False
        Component = edPriceWithVAT
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindId'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindName'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId'
        Value = Null
        Component = GuidesContract
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = Null
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaymentDate'
        Value = Null
        Component = edPaymentDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchDate'
        Value = Null
        Component = edPointDate
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberBranch'
        Value = Null
        Component = edPointNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'Checked'
        Value = Null
        Component = cbFarmacyShow
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDocument'
        Value = Null
        Component = cbisDocument
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isRegistered'
        Value = Null
        Component = cbisRegistered
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPay'
        Value = Null
        Component = chbIsPay
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateLastPay'
        Value = Null
        Component = вуDateLastPay
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Movement_OrderId'
        Value = Null
        Component = OrderExternalChoiceGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Movement_OrderInvNumber_full'
        Value = Null
        Component = OrderExternalChoiceGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDeferred'
        Value = Null
        Component = cbisDeferred
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberIncomeCheckId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MemberIncomeCheckId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberIncomeCheckName'
        Value = Null
        Component = edMemberIncomeCheck
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CheckDate'
        Value = Null
        Component = edCheckDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDifferent'
        Value = Null
        Component = cbDifferent
        DataType = ftBoolean
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
        Name = 'InvNumber'
        Value = Null
        Component = FormParams
        ComponentItem = 'InvNumberUpdate'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperDateUpdate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'isUseNDSKind'
        Value = Null
        Component = cbUseNDSKind
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 280
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Income'
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
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceWithVAT'
        Value = False
        Component = edPriceWithVAT
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDifferent'
        Value = ''
        Component = cbDifferent
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNDSKindId'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = 0.000000000000000000
        Component = GuidesContract
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOrderExternalId'
        Value = ''
        Component = OrderExternalChoiceGuides
        ComponentItem = 'Key'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaymentDate'
        Value = Null
        Component = edPaymentDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberBranch'
        Value = 0.000000000000000000
        Component = edPointNumber
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateBranch'
        Value = Null
        Component = edPointDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioJuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outJuridicalName'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
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
        Name = 'inisUseNDSKind'
        Value = Null
        Component = cbUseNDSKind
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
      end
      item
        Guides = GuidesContract
      end>
    Left = 160
    Top = 192
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edContract
      end
      item
        Control = edPaymentDate
      end
      item
        Control = edOperDate
      end
      item
        Control = edNDSKind
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end
      item
        Control = edPriceWithVAT
      end
      item
        Control = edJuridical
      end
      item
        Control = edInvNumberOrder
      end
      item
        Control = cbDifferent
      end
      item
        Control = edComment
      end
      item
        Control = cbUseNDSKind
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 232
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 840
    Top = 360
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Income_SetErased'
    Left = 710
    Top = 376
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Income_SetUnErased'
    Left = 710
    Top = 328
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Income'
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
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSalePrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SalePrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSamplePrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SamplePrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrintCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PrintCount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPrint'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPrint'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFEA'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FEA'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMeasure'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Measure'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Params = <
      item
        Name = 'ioId'
        Value = '0'
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
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 376
    Top = 304
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Summ'
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
        Name = 'TotalSummMVAT'
        Value = Null
        Component = ceTotalSummMVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummPVAT'
        Value = Null
        Component = ceTotalSummPVAT
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 876
    Top = 116
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshPrice
    ComponentList = <
      item
      end>
    Left = 512
    Top = 328
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 444
    Top = 297
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'GoodsName'
    Params = <>
    Left = 508
    Top = 286
  end
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 644
    Top = 334
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Income_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
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
    Left = 599
    Top = 288
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 640
    Top = 48
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 224
    Top = 64
  end
  object NDSKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edNDSKind
    FormNameParam.Value = 'TNDSKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TNDSKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = NDSKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 720
    Top = 48
  end
  object GuidesContract: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisName'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 479
    Top = 8
  end
  object spIncome_GoodsId: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_Income_GoodsId'
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
    Left = 304
    Top = 288
  end
  object spCalculateSalePrice: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_Income_SendPrice'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inIncomeId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 928
    Top = 120
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridicalCorporateForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalCorporateForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 320
    Top = 88
  end
  object spUpdate_MovementItem_Income_AmountManual: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_Income_AmountManual'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountManual'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountManual'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReasonDifferences'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReasonDifferencesId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccommodationName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AccommodationName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountDiff'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountDiff'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 512
    Top = 384
  end
  object spUpdateIncome_PartnerData: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Income_PartnerData'
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
        Name = 'inInvNumber'
        Value = ''
        Component = FormParams
        ComponentItem = 'InvNumber'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaymentDate'
        Value = 42381d
        Component = FormParams
        ComponentItem = 'PaymentDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 664
    Top = 432
  end
  object spisDocument: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_isDocument'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId '
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDocument'
        Value = Null
        Component = cbisDocument
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 784
    Top = 371
  end
  object OrderExternalChoiceGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumberOrder
    Key = '0'
    FormNameParam.Value = 'TOrderExternalJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderExternalJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = OrderExternalChoiceGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_full'
        Value = Null
        Component = OrderExternalChoiceGuides
        ComponentItem = 'TextValue'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_full'
        Value = ''
        Component = OrderExternalChoiceGuides
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDeferred'
        Value = Null
        Component = cbisDeferred
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1028
    Top = 176
  end
  object spUpdateMovementIncome_OrderExt: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Income_OrderExternal'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOrderExternalId'
        Value = '0'
        Component = OrderExternalChoiceGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 90
    Top = 280
  end
  object HeaderSaver1: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spUpdateMovementIncome_OrderExt
    ControlList = <
      item
        Control = edInvNumberOrder
      end>
    GetStoredProc = spGet
    Left = 976
    Top = 113
  end
  object spSelectPrintSticker: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Income_PrintSticker'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
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
    Left = 695
    Top = 296
  end
  object spUpdate_isDeferred_Yes: TdsdStoredProc
    StoredProcName = 'gpUpdate_isDeferred'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = OrderExternalChoiceGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDeferred'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisDeferred'
        Value = Null
        Component = cbisDeferred
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 904
    Top = 299
  end
  object spUpdate_isDeferred_No: TdsdStoredProc
    StoredProcName = 'gpUpdate_isDeferred'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = OrderExternalChoiceGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDeferred'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisDeferred'
        Value = Null
        Component = cbisDeferred
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1016
    Top = 291
  end
  object spUpdate_Check: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Income_CheckParam'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberIncomeCheckId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MemberIncomeCheckId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCheckDate'
        Value = 42261d
        Component = edCheckDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSaveNull'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 338
    Top = 360
  end
  object spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_Income'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsCurrentData'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisDeferred'
        Value = Null
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 56
    Top = 344
  end
  object spUpdate_OrderExternal_Deferred: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_OrderExternal_Deferred_byIncome'
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
    Left = 416
    Top = 112
  end
  object spLinkCheck: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Income_LinkCheck'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inIncomeId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 944
    Top = 384
  end
  object spCheckObject: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_Income_CheckObject'
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
    Left = 1008
    Top = 368
  end
  object spUpdate_BranchDate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Income_BranchDate'
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
        Name = 'inBranchDate'
        Value = 42144d
        Component = edPointDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 488
    Top = 440
  end
  object spUpdateIncome_OperData: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Income_OperData'
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
        Name = 'inInvNumber'
        Value = Null
        Component = FormParams
        ComponentItem = 'InvNumberUpdate'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42144d
        Component = FormParams
        ComponentItem = 'OperDateUpdate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInvNumber'
        Value = Null
        Component = edInvNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outOperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 792
    Top = 424
  end
  object spUpdate_ExpirationDate: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_Income_ExpirationDate'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
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
        Name = 'inJuridicalId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inExpirationDate'
        Value = 42144d
        Component = FormParams
        ComponentItem = 'ExpirationDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outExpirationDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ExpirationDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outExpirationDatePD'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ExpirationDatePG'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 354
    Top = 408
  end
  object spUpdate_SetBranchDate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Income_SetBranchDate'
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
        Name = 'inBranchDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'BranchDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBranchDate'
        Value = 42132d
        Component = edPointDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 592
    Top = 440
  end
  object spInsert_ReturnOut: TdsdStoredProc
    StoredProcName = 'gpInsert_Movement_ReturnOutFromIncome'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outId'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnOutId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 256
    Top = 344
  end
end
