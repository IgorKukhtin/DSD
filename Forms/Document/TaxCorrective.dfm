inherited TaxCorrectiveForm: TTaxCorrectiveForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081'>'
  ClientHeight = 668
  ClientWidth = 1142
  ExplicitWidth = 1158
  ExplicitHeight = 707
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 163
    Width = 1142
    Height = 505
    ExplicitTop = 163
    ExplicitWidth = 1142
    ExplicitHeight = 505
    ClientRectBottom = 505
    ClientRectRight = 1142
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1142
      ExplicitHeight = 481
      inherited cxGrid: TcxGrid
        Width = 1142
        Height = 481
        ExplicitWidth = 1142
        ExplicitHeight = 481
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
              Column = AmountSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountTax_calc
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
              Column = AmountSumm
            end
            item
              Kind = skSum
              Column = Price
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountTax_calc
            end>
          OptionsBehavior.GoToNextCellOnEnter = False
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
          object LineNum: TcxGridDBColumn [0]
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'LineNum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object LineNumTaxOld: TcxGridDBColumn [1]
            DataBinding.FieldName = 'LineNumTaxOld'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 52
          end
          object LineNumTax: TcxGridDBColumn [2]
            Caption = #8470' '#1087'/'#1087' ('#1053#1053')'
            DataBinding.FieldName = 'LineNumTax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1087'/'#1087' '#1053#1072#1083#1086#1075#1086#1074#1086#1081' ('#1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086')'
            Width = 55
          end
          object isAuto: TcxGridDBColumn [3]
            Caption = #8470' '#1087'/'#1087' ('#1053#1053') '#1087#1086#1080#1089#1082
            DataBinding.FieldName = 'isAuto'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1087'/'#1087' '#1053#1072#1083#1086#1075#1086#1074#1086#1081' - '#1087#1086#1080#1089#1082' ('#1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086')'
            Options.Editing = False
            Width = 52
          end
          object LineNumTaxCorr_calc: TcxGridDBColumn [4]
            Caption = #8470' '#1087'/'#1087' '#1053#1053'-'#1050#1086#1088#1088'.'
            DataBinding.FieldName = 'LineNumTaxCorr_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1087'/'#1087' '#1082#1086#1090#1086#1088#1099#1081' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1091#1077#1090#1089#1103
            Options.Editing = False
            Width = 70
          end
          object LineNumTaxCorr: TcxGridDBColumn [5]
            Caption = #8470' '#1087'/'#1087' '#1050#1086#1088#1088'.'
            DataBinding.FieldName = 'LineNumTaxCorr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1087'/'#1087' '#1074' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1077' - '#1089#1082#1074#1086#1079#1085#1072#1103' '#1085#1091#1084#1077#1088#1072#1094#1080#1103
            Options.Editing = False
            Width = 55
          end
          object LineNumTaxNew: TcxGridDBColumn [6]
            Caption = #8470' '#1087'/'#1087' '#1050#1086#1088#1088'. '#1094'.'
            DataBinding.FieldName = 'LineNumTaxNew'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1087'/'#1087' '#1074' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1077' '#1089' '#1085#1086#1074#1086#1081' '#1094#1077#1085#1086#1081' - '#1089#1082#1074#1086#1079#1085#1072#1103' '#1085#1091#1084#1077#1088#1072#1094#1080#1103
            Options.Editing = False
            Width = 55
          end
          object AmountTax_calc: TcxGridDBColumn [7]
            Caption = #1050#1086#1083'-'#1074#1086' '#1074' 7/1'
            DataBinding.FieldName = 'AmountTax_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1082#1086#1083#1086#1085#1082#1077' 7/1'#1089#1090#1088#1086#1082#1072
            Options.Editing = False
            Width = 55
          end
          object SummTaxDiff_calc: TcxGridDBColumn [8]
            Caption = #1057#1091#1084#1084#1072' '#1050#1054#1056#1056'. '#1076#1083#1103' '#1053#1053'-'#1050#1086#1088#1088'.'
            DataBinding.FieldName = 'SummTaxDiff_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1050#1054#1056#1056#1045#1050#1058#1048#1056#1054#1042#1050#1048' "'#1086#1082#1088#1091#1075#1083#1077#1085#1080#1081'" '#1076#1083#1103' '#1053#1053'-'#1050#1086#1088#1088'.'
            Options.Editing = False
            Width = 80
          end
          object PriceTax_calc: TcxGridDBColumn [9]
            Caption = #1062#1077#1085#1072' '#1076#1083#1103' '#1050#1086#1088#1088'.'#1094#1077#1085#1099
            DataBinding.FieldName = 'PriceTax_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074' '#1082#1086#1083#1086#1085#1082#1077' 9/1'#1089#1090#1088#1086#1082#1072
            Options.Editing = False
            Width = 70
          end
          object GoodsGroupNameFull: TcxGridDBColumn [10]
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsCode: TcxGridDBColumn [11]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsCodeUKTZED: TcxGridDBColumn [12]
            Caption = #1050#1086#1076' '#1087#1086' '#1059#1050#1058' '#1047#1045#1044
            DataBinding.FieldName = 'GoodsCodeUKTZED'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object GoodsName: TcxGridDBColumn [13]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object GoodsKindName: TcxGridDBColumn [14]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MeasureName: TcxGridDBColumn [15]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object GoodsName_its: TcxGridDBColumn [16]
            Caption = #1044#1088#1091#1075#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' ('#1053#1053')'
            DataBinding.FieldName = 'GoodsName_its'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1088#1091#1075#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072' ('#1085#1072#1083#1086#1075#1086#1074#1072#1103')'
            Options.Editing = False
            Width = 73
          end
          object Amount: TcxGridDBColumn [17]
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Price: TcxGridDBColumn [18]
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object CountForPrice: TcxGridDBColumn [19]
            Caption = #1050#1086#1083' '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object AmountSumm: TcxGridDBColumn [20]
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'AmountSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
        end
      end
    end
    object cxTabSheet1: TcxTabSheet
      Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#8470' '#1087'/'#1087
      ImageIndex = 1
      object cxGrid1: TcxGrid
        Left = 0
        Top = 0
        Width = 1142
        Height = 481
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 0
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmountSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmountTax_calc
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmountSumm
            end
            item
              Kind = skSum
              Column = cxPrice
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = cxGoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxAmountTax_calc
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object cxLineNum: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'LineNum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object cxLineNumTaxOld: TcxGridDBColumn
            DataBinding.FieldName = 'LineNumTaxOld'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 52
          end
          object cxLineNumTax: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087' ('#1053#1053')'
            DataBinding.FieldName = 'LineNumTax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1087'/'#1087' '#1053#1072#1083#1086#1075#1086#1074#1086#1081' ('#1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086')'
            Options.Editing = False
            Width = 55
          end
          object cxisAuto: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087' ('#1053#1053') '#1087#1086#1080#1089#1082
            DataBinding.FieldName = 'isAuto'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1087'/'#1087' '#1053#1072#1083#1086#1075#1086#1074#1086#1081' - '#1087#1086#1080#1089#1082' ('#1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086')'
            Options.Editing = False
            Width = 52
          end
          object cxLineNumTaxCorr_calc: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087' '#1053#1053'-'#1050#1086#1088#1088'.'
            DataBinding.FieldName = 'LineNumTaxCorr_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1087'/'#1087' '#1082#1086#1090#1086#1088#1099#1081' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1091#1077#1090#1089#1103
            Width = 70
          end
          object cxLineNumTaxCorr: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087' '#1050#1086#1088#1088'.'
            DataBinding.FieldName = 'LineNumTaxCorr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1087'/'#1087' '#1074' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1077' - '#1089#1082#1074#1086#1079#1085#1072#1103' '#1085#1091#1084#1077#1088#1072#1094#1080#1103
            Width = 55
          end
          object cxLineNumTaxNew: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087' '#1050#1086#1088#1088'. '#1094'.'
            DataBinding.FieldName = 'LineNumTaxNew'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1087'/'#1087' '#1074' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1077' '#1089' '#1085#1086#1074#1086#1081' '#1094#1077#1085#1086#1081' - '#1089#1082#1074#1086#1079#1085#1072#1103' '#1085#1091#1084#1077#1088#1072#1094#1080#1103
            Width = 59
          end
          object cxAmountTax_calc: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074' 7/1'
            DataBinding.FieldName = 'AmountTax_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1082#1086#1083#1086#1085#1082#1077' 7/1'#1089#1090#1088#1086#1082#1072
            Width = 55
          end
          object cxSummTaxDiff_calc: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1050#1054#1056#1056'. '#1076#1083#1103' '#1053#1053'-'#1050#1086#1088#1088'.'
            DataBinding.FieldName = 'SummTaxDiff_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1050#1054#1056#1056#1045#1050#1058#1048#1056#1054#1042#1050#1048' "'#1086#1082#1088#1091#1075#1083#1077#1085#1080#1081'" '#1076#1083#1103' '#1053#1053'-'#1050#1086#1088#1088'.'
            Width = 80
          end
          object cxPriceTax_calc: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1076#1083#1103' '#1050#1086#1088#1088'.'#1094#1077#1085#1099
            DataBinding.FieldName = 'PriceTax_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074' '#1082#1086#1083#1086#1085#1082#1077' 9/1'#1089#1090#1088#1086#1082#1072
            Width = 70
          end
          object cxGoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object cxGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object cxGoodsCodeUKTZED: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086' '#1059#1050#1058' '#1047#1045#1044
            DataBinding.FieldName = 'GoodsCodeUKTZED'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object cxGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object cxGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object cxMeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object cxAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object cxPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object cxCountForPrice: TcxGridDBColumn
            Caption = #1050#1086#1083' '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object cxAmountSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'AmountSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object cxisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            Options.Editing = False
            Width = 50
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
    end
    object tsContract: TcxTabSheet
      Caption = #1044#1086#1075#1086#1074#1086#1088#1072
      ImageIndex = 2
      object cxGridDetail: TcxGrid
        Left = 0
        Top = 0
        Width = 1142
        Height = 481
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 0
        object cxGridDBTableViewDetail: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DetailDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
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
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object ContractCode_ch2: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'ContractCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object ContractName_ch2: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceFormContract
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 230
          end
          object ContractTagName_ch2: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object ContractKindName_ch2: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1076#1086#1075#1086#1074#1086#1088#1072
            DataBinding.FieldName = 'ContractKindName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 94
          end
          object StartDate_ch2: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1089
            DataBinding.FieldName = 'StartDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 94
          end
          object EndDate_ch2: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1076#1086
            DataBinding.FieldName = 'EndDate'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isErased_ch2: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            Options.Editing = False
            Width = 50
          end
        end
        object cxGridLevelDetail: TcxGridLevel
          GridView = cxGridDBTableViewDetail
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1142
    Height = 137
    TabOrder = 3
    ExplicitWidth = 1142
    ExplicitHeight = 137
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
      ExplicitWidth = 94
      Width = 94
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 211
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 211
      ExplicitWidth = 97
      Width = 97
    end
    inherited cxLabel2: TcxLabel
      Left = 211
      ExplicitLeft = 211
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 63
      ExplicitTop = 63
      ExplicitWidth = 121
      ExplicitHeight = 22
      Width = 121
    end
    object cxLabel3: TcxLabel
      Left = 314
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object edFrom: TcxButtonEdit
      Left = 314
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 157
    end
    object edTo: TcxButtonEdit
      Left = 474
      Top = 23
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 8
      Width = 172
    end
    object cxLabel4: TcxLabel
      Left = 474
      Top = 5
      Caption = #1050#1086#1084#1091
    end
    object edContract: TcxButtonEdit
      Left = 649
      Top = 23
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 10
      Width = 114
    end
    object cxLabel9: TcxLabel
      Left = 649
      Top = 5
      Caption = #1044#1086#1075#1086#1074#1086#1088
    end
    object cxLabel6: TcxLabel
      Left = 767
      Top = 5
      Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
    end
    object edDocumentTaxKind: TcxButtonEdit
      Left = 770
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 13
      Width = 119
    end
    object edPriceWithVAT: TcxCheckBox
      Left = 465
      Top = 63
      Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 14
      Width = 129
    end
    object edVATPercent: TcxCurrencyEdit
      Left = 597
      Top = 63
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      TabOrder = 15
      Width = 40
    end
    object cxLabel7: TcxLabel
      Left = 597
      Top = 45
      Caption = '% '#1053#1044#1057
    end
    object edDateRegistered: TcxDateEdit
      Left = 211
      Top = 63
      EditValue = 42342d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 17
      Width = 97
    end
    object cxLabel10: TcxLabel
      Left = 211
      Top = 45
      Caption = #1044#1072#1090#1072' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080
    end
    object edIsChecked: TcxCheckBox
      Left = 645
      Top = 63
      Caption = #1055#1088#1086#1074#1077#1088#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 19
      Width = 118
    end
    object cxLabel12: TcxLabel
      Left = 108
      Top = 5
      Caption = #8470' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080
    end
    object edInvNumberPartner: TcxTextEdit
      Left = 108
      Top = 23
      TabOrder = 21
      Width = 98
    end
    object edIsDocument: TcxCheckBox
      Left = 770
      Top = 63
      Caption = #1055#1086#1076#1087#1080#1089#1072#1085' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 22
      Width = 119
    end
    object edIsElectron: TcxCheckBox
      Left = 315
      Top = 71
      Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' ('#1076#1072'/'#1085#1077#1090')'
      Properties.ReadOnly = True
      TabOrder = 23
      Width = 140
    end
    object cxLabel5: TcxLabel
      Left = 895
      Top = 5
      Caption = #8470' '#1076#1086#1082'.'#1074#1086#1079#1074#1088'.'
    end
    object edReturnIn: TcxTextEdit
      Left = 895
      Top = 23
      Enabled = False
      TabOrder = 25
      Width = 83
    end
    object cxLabel8: TcxLabel
      Left = 895
      Top = 45
      Caption = #8470' '#1085#1072#1083#1086#1075#1086#1074#1086#1081
    end
    object edDocumentTax: TcxButtonEdit
      Left = 895
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 27
      Width = 83
    end
    object cxLabel11: TcxLabel
      Left = 984
      Top = 5
      Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
    end
    object edPartner: TcxButtonEdit
      Left = 984
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 29
      Text = ' '
      Width = 125
    end
    object cxLabel13: TcxLabel
      Left = 984
      Top = 45
      Caption = #1053#1086#1084#1077#1088' '#1092#1080#1083#1080#1072#1083#1072
    end
    object edInvNumberBranch: TcxTextEdit
      Left = 984
      Top = 63
      TabOrder = 31
      Width = 73
    end
    object cxLabel16: TcxLabel
      Left = 133
      Top = 86
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 133
      Top = 103
      TabOrder = 33
      Width = 317
    end
    object edINN: TcxTextEdit
      Left = 770
      Top = 103
      Properties.ReadOnly = True
      TabOrder = 34
      Width = 119
    end
    object cxLabel14: TcxLabel
      Left = 770
      Top = 86
      Caption = #1048#1053#1053' '#1076#1083#1103' 1-'#1086#1075#1086' '#1076#1086#1082'. / '#1080#1085#1072#1095#1077' '#1076#1083#1103' '#1042#1089#1077#1093
    end
    object cbINN: TcxCheckBox
      Left = 898
      Top = 103
      Hint = #1048#1053#1053' '#1080#1089#1087#1088#1072#1074#1083#1077#1085' '#1076#1083#1103' 1-'#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' ('#1076#1072'/'#1085#1077#1090')'
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 36
      Width = 24
    end
    object cbNPP_calc: TcxCheckBox
      Left = 465
      Top = 103
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '#8470' '#1087'/'#1087' ('#1076#1072'/'#1085#1077#1090')'
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '#8470' '#1087'/'#1087
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 37
      Width = 142
    end
    object cxLabel18: TcxLabel
      Left = 133
      Top = 45
      Caption = #8470' '#1074' '#1044#1055#1040
    end
    object edInvNumberRegistered: TcxTextEdit
      Left = 133
      Top = 63
      Properties.ReadOnly = True
      TabOrder = 39
      Width = 73
    end
    object cbIsAuto: TcxCheckBox
      Left = 315
      Top = 48
      Hint = #1057#1086#1079#1076#1072#1085' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' ('#1076#1072'/'#1085#1077#1090')'
      Caption = #1057#1086#1079#1076#1072#1085' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
      Properties.ReadOnly = True
      TabOrder = 40
      Width = 144
    end
    object cxLabel19: TcxLabel
      Left = 984
      Top = 86
      Caption = #1060#1080#1083#1080#1072#1083
    end
    object edBranch: TcxButtonEdit
      Left = 984
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 42
      Width = 125
    end
  end
  object cbPartner: TcxCheckBox [2]
    Left = 8
    Top = 103
    Caption = #1040#1082#1090' '#1085#1077#1076#1086#1074#1086#1079#1072
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 102
  end
  object cxLabel17: TcxLabel [3]
    Left = 645
    Top = 86
    Hint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1103' '#8470' '#1087'/'#1087
    Caption = #1044#1072#1090#1072'/'#1042#1088'. '#8470' '#1087'/'#1087
    ParentShowHint = False
    ShowHint = True
  end
  object edDateisNPP_calc: TcxDateEdit [4]
    Left = 645
    Top = 103
    Hint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1103' '#8470' '#1087'/'#1087
    EditValue = 42342d
    ParentShowHint = False
    Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
    Properties.EditFormat = 'dd.mm.yyyy hh:mm'
    Properties.Kind = ckDateTime
    Properties.ReadOnly = True
    ShowHint = True
    TabOrder = 8
    Width = 118
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 171
    Top = 552
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = AncestorDocumentForm.Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    Left = 56
    Top = 576
  end
  inherited ActionList: TActionList
    Left = 63
    Top = 271
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectChild
        end
        item
          StoredProc = spSelectDetail
        end>
      RefreshOnTabSetChanges = True
    end
    inherited actMISetErased: TdsdUpdateErased
      TabSheet = tsMain
    end
    inherited actMISetUnErased: TdsdUpdateErased
      TabSheet = tsMain
    end
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end
        item
          StoredProc = spInsertUpdateMovement_DocChild
        end>
    end
    inherited actShowErased: TBooleanStoredProcAction
      TabSheet = tsMain
    end
    inherited actShowAll: TBooleanStoredProcAction
      TabSheet = tsMain
    end
    object actUpdateChildDS: TdsdUpdateDataSet [7]
      Category = 'DSDLib'
      TabSheet = cxTabSheet1
      MoveParams = <>
      Enabled = False
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMI_NPP
      StoredProcList = <
        item
          StoredProc = spUpdateMI_NPP
        end>
      Caption = 'actUpdateMainDS'
      DataSource = ChildDS
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      TabSheet = tsMain
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrintTaxCorrective_Us
      StoredProcList = <
        item
          StoredProc = spSelectPrintTaxCorrective_Us
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      ImageIndex = 19
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_TaxCorrective'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      ReportNameParam.Value = 'PrintMovement_TaxCorrective'
      ReportNameParam.ParamType = ptInput
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actMovementItemContainer: TdsdOpenForm
      Enabled = False
    end
    object actGoodsKindChoice: TOpenChoiceForm [14]
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
    inherited MovementItemProtocolOpenForm: TdsdOpenForm
      TabSheet = tsMain
    end
    inherited actAddMask: TdsdExecStoredProc
      TabSheet = tsMain
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1101#1083#1077#1084#1077#1085#1090' '#1087#1086' '#1084#1072#1089#1082#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1101#1083#1077#1084#1077#1085#1090' '#1087#1086' '#1084#1072#1089#1082#1077
    end
    object actSPPrintProcName: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actSPPrintProcName'
    end
    object actSPPrintTaxCorrectiveProcName: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReportNameTaxCorrective
      StoredProcList = <
        item
          StoredProc = spGetReportNameTaxCorrective
        end>
      Caption = 'actSPPrintTaxCorrectiveProcName'
    end
    object actPrint_TaxCorrective_Us: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintTaxCorrective_Us
      StoredProcList = <
        item
          StoredProc = spSelectPrintTaxCorrective_Us
        end>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      ImageIndex = 19
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_TaxCorrective'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTaxCorrective'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_TaxCorrective_Client: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintTaxCorrective_Client
      StoredProcList = <
        item
          StoredProc = spSelectPrintTaxCorrective_Client
        end>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      ImageIndex = 18
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_TaxCorrective'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' ('#1082#1083#1080#1077#1085#1090#1091')'
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTaxCorrective'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object mactPrint_TaxCorrective_Client: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSPPrintTaxCorrectiveProcName
        end
        item
          Action = actPrint_TaxCorrective_Client
        end>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      ImageIndex = 18
    end
    object mactPrint_TaxCorrective_Us: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSPPrintTaxCorrectiveProcName
        end
        item
          Action = actPrint_TaxCorrective_Us
        end>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      ImageIndex = 19
    end
    object actOpenTax: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103'>'
      ImageIndex = 26
      FormName = 'TTaxForm'
      FormNameParam.Value = 'TTaxForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = DocumentTaxGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inmask'
          Value = False
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChangeNPP_calc: TdsdExecStoredProc
      Category = 'NPP'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMI_NPP_calc
      StoredProcList = <
        item
          StoredProc = spUpdateMI_NPP_calc
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectChild
        end
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#8470' '#1087'/'#1087' '#1044#1051#1071' '#1082#1086#1083#1086#1085#1082#1080' 1/2'#1089#1090#1088#1086#1082#1072
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#8470' '#1087'/'#1087' '#1044#1051#1071' '#1082#1086#1083#1086#1085#1082#1080' 1/2'#1089#1090#1088#1086#1082#1072
      ImageIndex = 45
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#8470' '#1087'/'#1087' '#1044#1051#1071' '#1082#1086#1083#1086#1085#1082#1080' 1/2'#1089#1090#1088#1086#1082#1072'?'
      InfoAfterExecute = #8470' '#1087'/'#1087' '#1044#1051#1071' '#1082#1086#1083#1086#1085#1082#1080' 1/2'#1089#1090#1088#1086#1082#1072' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085
    end
    object actChangeSignAmount: TdsdExecStoredProc
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMIAmountSign
      StoredProcList = <
        item
          StoredProc = spUpdateMIAmountSign
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1079#1085#1072#1082' '#1076#1083#1103' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072' '#1085#1072' '#1087#1088#1086#1090#1080#1074#1086#1087#1086#1083#1086#1078#1085#1099#1081
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1079#1085#1072#1082' '#1076#1083#1103' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072' '#1085#1072' '#1087#1088#1086#1090#1080#1074#1086#1087#1086#1083#1086#1078#1085#1099#1081
      ImageIndex = 27
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1080#1079#1084#1077#1085#1080#1090#1100' '#1079#1085#1072#1082' '#1076#1083#1103' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072' '#1085#1072' '#1087#1088#1086#1090#1080#1074#1086#1087#1086#1083#1086#1078#1085#1099#1081'?'
      InfoAfterExecute = #1047#1085#1072#1082' '#1076#1083#1103' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072' '#1080#1079#1084#1077#1085#1080#1083#1089#1103' '#1085#1072' '#1087#1088#1086#1090#1080#1074#1086#1087#1086#1083#1086#1078#1085#1099#1081
    end
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
    end
    object actUpdate_Branch: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Branch
      StoredProcList = <
        item
          StoredProc = spUpdate_Branch
        end
        item
          StoredProc = spGet
        end>
      Caption = 'actUpdate_Branch'
      ImageIndex = 43
    end
    object actUpdateINN: TdsdDataSetRefresh
      Category = 'INN'
      MoveParams = <>
      StoredProc = spUpdate_INN
      StoredProcList = <
        item
          StoredProc = spUpdate_INN
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
    object ExecuteDialogINN: TExecuteDialog
      Category = 'INN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1048#1053#1053
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1048#1053#1053
      ImageIndex = 26
      FormName = 'TMovementString_INNEditForm'
      FormNameParam.Value = 'TMovementString_INNEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inINN'
          Value = ''
          Component = edINN
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macUpdateINN: TMultiAction
      Category = 'INN'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogINN
        end
        item
          Action = actUpdateINN
        end>
      Caption = #1048#1089#1087#1088#1072#1074#1080#1090#1100' '#1048#1053#1053' '#1076#1083#1103' 1-'#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1048#1089#1087#1088#1072#1074#1080#1090#1100' '#1048#1053#1053' '#1076#1083#1103' 1-'#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 76
    end
    object actReport_Check_NPP: TdsdOpenForm
      Category = 'NPP'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#8470#1087'/'#1087'>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#8470#1087'/'#1087'>'
      ImageIndex = 40
      FormName = 'TReport_CheckTaxCorrective_NPPForm'
      FormNameParam.Value = 'TReport_CheckTaxCorrective_NPPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'GoodsId'
          Value = 0
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId'
          Value = '0'
          Component = DocumentTaxGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateMI_NPP_Null: TdsdExecStoredProc
      Category = 'NPP'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMI_NPP_Null
      StoredProcList = <
        item
          StoredProc = spUpdateMI_NPP_Null
        end
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectChild
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#8470' '#1087'/'#1087
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#8470' '#1087'/'#1087
      ImageIndex = 46
      QuestionBeforeExecute = 
        #1041#1091#1076#1091#1090' '#1059#1044#1040#1051#1045#1053#1067' '#1042#1057#1045' '#1076#1072#1085#1085#1085#1099#1077' '#1076#1083#1103' '#8470' '#1087'/'#1087' '#1041#1045#1047' '#1042#1054#1047#1052#1054#1046#1053#1054#1057#1058#1048' '#1042#1054#1057#1057#1058#1040#1053#1054#1042#1051#1045#1053 +
        #1048#1071'. '#1055#1088#1086#1076#1086#1083#1078#1080#1090#1100' ?'
      InfoAfterExecute = #1059#1044#1040#1051#1045#1053#1067' '#1042#1057#1045' '#1076#1072#1085#1085#1085#1099#1077' '#1076#1083#1103' '#8470' '#1087'/'#1087
    end
    object actBranchChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actBranchChoiceForm'
      ImageIndex = 43
      FormName = 'TBranch_ObjectForm'
      FormNameParam.Value = 'TBranch_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'BranchId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object macUpdateBranch: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      ActionList = <
        item
          Action = actBranchChoiceForm
        end
        item
          Action = actUpdate_Branch
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1060#1080#1083#1080#1072#1083
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1060#1080#1083#1080#1072#1083
      ImageIndex = 60
    end
    object actChoiceFormContract: TOpenChoiceForm
      Category = 'Detail'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ContractChoiceForm'
      FormName = 'TContractChoiceForm'
      FormNameParam.Value = 'TContractChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MasterJuridicalId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'ContractId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'ContractCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'ContractName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractTagName'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'ContractTagName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractKindName'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'ContractKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartDate'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'StartDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'EndDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object InsertRecord_Det: TInsertRecord
      Category = 'Detail'
      TabSheet = tsContract
      MoveParams = <>
      Enabled = False
      PostDataSetBeforeExecute = False
      View = cxGridDBTableViewDetail
      Action = actChoiceFormContract
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1044#1086#1075#1086#1074#1086#1088'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1044#1086#1075#1086#1074#1086#1088'>'
      ImageIndex = 0
    end
    object SetErased_Det: TdsdUpdateErased
      Category = 'Detail'
      TabSheet = tsContract
      MoveParams = <>
      Enabled = False
      StoredProc = spErasedMI_Det
      StoredProcList = <
        item
          StoredProc = spErasedMI_Det
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1044#1086#1075#1086#1074#1086#1088'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1044#1086#1075#1086#1074#1086#1088'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = DetailDS
    end
    object SetUnErased_Det: TdsdUpdateErased
      Category = 'Detail'
      TabSheet = tsContract
      MoveParams = <>
      Enabled = False
      StoredProc = spUnErasedMI_Det
      StoredProcList = <
        item
          StoredProc = spUnErasedMI_Det
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DetailDS
    end
    object actGridToExcel_Det: TdsdGridToExcel
      Category = 'Detail'
      TabSheet = tsContract
      MoveParams = <>
      Enabled = False
      Grid = cxGridDetail
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actShowErased_Det: TBooleanStoredProcAction
      Category = 'Detail'
      TabSheet = tsContract
      MoveParams = <>
      Enabled = False
      StoredProc = spSelectDetail
      StoredProcList = <
        item
          StoredProc = spSelectDetail
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object actUpdateDetailDS: TdsdUpdateDataSet
      Category = 'Detail'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIDetail
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIDetail
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = 'actUpdateDetailDS'
      DataSource = DetailDS
    end
    object MIDetailProtocolOpenForm: TdsdOpenForm
      Category = 'Detail'
      TabSheet = tsContract
      MoveParams = <>
      Enabled = False
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'ContractName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 512
  end
  inherited MasterCDS: TClientDataSet
    Left = 88
    Top = 512
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_TaxCorrective'
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
        Name = 'delme'
        Value = ''
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 312
  end
  inherited BarManager: TdxBarManager
    Left = 16
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
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowErased_Det'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddMask'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbChangeSignAmount'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateINN'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbChangeNPP_calc'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMI_NPP_Null'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateBranch'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecord_Det'
        end
        item
          Visible = True
          ItemName = 'bbSetErased_Det'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased_Det'
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
          ItemName = 'bbOpenTax'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReport_Check_NPP'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_TaxCorrective_Client'
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
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'bbMIDetailProtocolOpenForm'
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
          ItemName = 'bbGridToExcel_Det'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    inherited bbPrint: TdxBarButton
      Action = mactPrint_TaxCorrective_Us
      Caption = #1055#1077#1095#1072#1090#1100' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
    end
    object bbPrint_TaxCorrective_Client: TdxBarButton [5]
      Action = mactPrint_TaxCorrective_Client
      Category = 0
    end
    inherited bbStatic: TdxBarStatic
      ShowCaption = False
    end
    object bbChangeSignAmount: TdxBarButton
      Action = actChangeSignAmount
      Category = 0
    end
    object bbOpenTax: TdxBarButton
      Action = actOpenTax
      Category = 0
    end
    object bbUpdateINN: TdxBarButton
      Action = macUpdateINN
      Category = 0
    end
    object bbChangeNPP_calc: TdxBarButton
      Action = actChangeNPP_calc
      Category = 0
    end
    object bbReport_Check_NPP: TdxBarButton
      Action = actReport_Check_NPP
      Category = 0
    end
    object bbUpdateMI_NPP_Null: TdxBarButton
      Action = actUpdateMI_NPP_Null
      Category = 0
    end
    object bbUpdateBranch: TdxBarButton
      Action = macUpdateBranch
      Category = 0
    end
    object bbShowErased_Det: TdxBarButton
      Action = actShowErased_Det
      Category = 0
    end
    object bbGridToExcel_Det: TdxBarButton
      Action = actGridToExcel_Det
      Category = 0
    end
    object bbInsertRecord_Det: TdxBarButton
      Action = InsertRecord_Det
      Category = 0
    end
    object bbSetErased_Det: TdxBarButton
      Action = SetErased_Det
      Category = 0
    end
    object bbSetUnErased_Det: TdxBarButton
      Action = SetUnErased_Det
      Category = 0
    end
    object bbMIDetailProtocolOpenForm: TdxBarButton
      Action = MIDetailProtocolOpenForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 2
      end>
    Left = 830
    Top = 265
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
        Name = 'ReportNameSale'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSaleTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameTaxCorrective'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMask'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 288
    Top = 528
  end
  inherited StatusGuides: TdsdGuides
    Left = 48
    Top = 56
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_TaxCorrective'
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
        Name = 'ioStatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        ParamType = ptInputOutput
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
    Left = 40
    Top = 104
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TaxCorrective'
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
        Name = 'inMask'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMask'
        DataType = ftBoolean
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
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMask'
        Value = Null
        Component = FormParams
        ComponentItem = 'isMask'
        DataType = ftBoolean
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
        Name = 'Checked'
        Value = False
        Component = edIsChecked
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Document'
        Value = False
        Component = edIsDocument
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isElectron'
        Value = False
        Component = edIsElectron
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateRegistered'
        Value = 0d
        Component = edDateRegistered
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberRegistered'
        Value = 'NULL'
        Component = edInvNumberRegistered
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
        Name = 'VATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = '0'
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
        Name = 'PartnerId'
        Value = '0'
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ' '
        Component = GuidesPartner
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
        Name = 'ContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindId'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindName'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DocumentMasterName'
        Value = ''
        Component = edReturnIn
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DocumentChildId'
        Value = ''
        Component = DocumentTaxGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DocumentChildName'
        Value = ''
        Component = DocumentTaxGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberBranch'
        Value = ''
        Component = edInvNumberBranch
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPartner'
        Value = Null
        Component = cbPartner
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isINN'
        Value = Null
        Component = cbINN
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'INN_From'
        Value = Null
        Component = edINN
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isNPP_calc'
        Value = Null
        Component = cbNPP_calc
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateisNPP_calc'
        Value = Null
        Component = edDateisNPP_calc
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'isAuto'
        Value = Null
        Component = cbIsAuto
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchId'
        Value = Null
        Component = GuidesBranch
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchName'
        Value = Null
        Component = GuidesBranch
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 328
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TaxCorrective'
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
        Name = 'inInvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberBranch'
        Value = ''
        Component = edInvNumberBranch
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
        Name = 'inChecked'
        Value = False
        Component = edIsChecked
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocument'
        Value = False
        Component = edIsDocument
        DataType = ftBoolean
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
        Name = 'inVATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = '0'
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
        Name = 'inPartnerId'
        Value = '0'
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocumentTaxKind'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 90
    Top = 344
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesPartner
      end
      item
        Guides = DocumentTaxKindGuides
      end>
    Left = 216
    Top = 296
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumberPartner
      end
      item
        Control = edInvNumberBranch
      end
      item
        Control = edOperDate
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
        Control = edVATPercent
      end
      item
        Control = edContract
      end
      item
        Control = edIsChecked
      end
      item
        Control = edDocumentTaxKind
      end
      item
        Control = edPartner
      end
      item
        Control = ceComment
      end>
    Left = 168
    Top = 265
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 912
    Top = 320
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_TaxCorrective_SetErased'
    Left = 718
    Top = 512
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_TaxCorrective_SetUnErased'
    Left = 718
    Top = 464
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_TaxCorrective'
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
        Name = 'ioCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLineNumTaxOld'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'LineNumTaxOld'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLineNumTax'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'LineNumTax'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsAuto'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isAuto'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 416
    Top = 440
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_TaxCorrective'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
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
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
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
        Name = 'ioCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountSumm'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLineNumTaxOld'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLineNumTax'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsAuto'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isAuto'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 432
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 468
    Top = 252
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 512
    Top = 8
  end
  object DocumentTaxKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edDocumentTaxKind
    FormNameParam.Value = 'TDocumentTaxKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDocumentTaxKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 808
    Top = 24
  end
  object ContractGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract
    FormNameParam.Value = 'TContractForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 696
  end
  object spSelectPrintTaxCorrective_Us: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TaxCorrective_Print'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintHeaderCDS
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
      end
      item
        Name = 'inisClientCopy'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 303
    Top = 272
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    ComponentList = <>
    Left = 392
    Top = 88
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 580
    Top = 257
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 262
  end
  object HeaderSaverParams: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spInsertUpdateMovement_Params
    ControlList = <
      item
        Control = edDateRegistered
      end
      item
        Control = edIsElectron
      end>
    GetStoredProc = spGet
    Left = 408
    Top = 313
  end
  object spInsertUpdateMovement_Params: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TaxCorrective_Params'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inDateRegistered'
        Value = 0d
        Component = edDateRegistered
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRegistered'
        Value = False
        Component = edIsElectron
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 417
    Top = 552
  end
  object spSelectPrintTaxCorrective_Client: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TaxCorrective_Print'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintHeaderCDS
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
      end
      item
        Name = 'inisClientCopy'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 306
    Top = 322
  end
  object DocumentTaxGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edDocumentTax
    FormNameParam.Value = 'TTaxJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TTaxJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = DocumentTaxGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = DocumentTaxGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = '0'
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = '0'
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_Tax'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperDate_Tax'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 920
    Top = 41
  end
  object HeaderSaverDocChild: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spInsertUpdateMovement_DocChild
    ControlList = <
      item
        Control = edDocumentTax
      end>
    GetStoredProc = spGet
    Left = 376
    Top = 265
  end
  object spInsertUpdateMovement_DocChild: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TaxCorrective_DocChild'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inMovement_ChildId'
        Value = ''
        Component = DocumentTaxGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 298
    Top = 400
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    Key = '0'
    TextValue = ' '
    FormNameParam.Value = 'TContractChoicePartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoicePartnerForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'PartnerId'
        Value = '0'
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ' '
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = '0'
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1040
    Top = 8
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    Key = '0'
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'JuridicalId'
        Value = '0'
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = '0'
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ' '
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 8
  end
  object HeaderSaverIsDocument: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spInsertUpdateMovement_IsDocument
    ControlList = <
      item
        Control = edIsDocument
      end>
    GetStoredProc = spGet
    Left = 408
    Top = 241
  end
  object spInsertUpdateMovement_IsDocument: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TaxCorrective_IsDocument'
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
        Name = 'ioIsDocument'
        Value = False
        Component = edIsDocument
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsCalculate'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 545
    Top = 504
  end
  object spGetReportNameTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TaxCorrective_ReportName'
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
        Name = 'gpGet_Movement_TaxCorrective_ReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameTaxCorrective'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 400
    Top = 520
  end
  object spUpdateMIAmountSign: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_TaxCorrective_AmountSign'
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
    Left = 226
    Top = 472
  end
  object spUpdate_INN: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_INN'
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
        Name = 'ioINN'
        Value = ''
        Component = edINN
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsINN'
        Value = False
        Component = cbINN
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 690
    Top = 256
  end
  object spUpdateMI_NPP_calc: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_TaxCorrective_NPP_calc'
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
    Left = 536
    Top = 393
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 936
    Top = 472
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 1000
    Top = 472
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 2
      end>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 982
    Top = 401
  end
  object spSelectChild: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_TaxCorrective'
    DataSet = ChildCDS
    DataSets = <
      item
        DataSet = ChildCDS
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
        Name = 'delme'
        Value = ''
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 896
    Top = 392
  end
  object spUpdateMI_NPP: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_TaxCorrective_NPP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLineNumTaxCorr_calc'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'LineNumTaxCorr_calc'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLineNumTaxCorr'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'LineNumTaxCorr'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLineNumTaxNew'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'LineNumTaxNew'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountTax_calc'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountTax_calc'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummTaxDiff_calc'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'SummTaxDiff_calc'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceTax_calc'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'PriceTax_calc'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 792
    Top = 384
  end
  object spUpdateMI_NPP_Null: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_TaxCorrective_NPP_Null'
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
    Left = 696
    Top = 345
  end
  object GuidesBranch: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranch
    DisableGuidesOpen = True
    FormNameParam.Value = 'TBranch_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBranch_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1040
    Top = 104
  end
  object spUpdate_Branch: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Tax_Branch'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'MovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'BranchId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 593
    Top = 576
  end
  object DetailDS: TDataSource
    DataSet = DetailCDS
    Left = 944
    Top = 232
  end
  object DetailCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 992
    Top = 240
  end
  object DBViewAddOnDetail: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewDetail
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 2
      end>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 1062
    Top = 209
  end
  object spUnErasedMI_Det: TdsdStoredProc
    StoredProcName = 'gpMovementItem_TaxCorrective_SetUnErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1102
    Top = 280
  end
  object spErasedMI_Det: TdsdStoredProc
    StoredProcName = 'gpMovementItem_TaxCorrective_SetErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1110
    Top = 336
  end
  object spInsertUpdateMIDetail: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_TaxCorrective_Detail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = DetailCDS
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
        Name = 'inContractId'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1040
    Top = 288
  end
  object spSelectDetail: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_TaxCorrective_Detail'
    DataSet = DetailCDS
    DataSets = <
      item
        DataSet = DetailCDS
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
        Component = actShowErased_Det
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1040
    Top = 328
  end
end
