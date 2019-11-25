inherited OrderInternalPackForm: TOrderInternalPackForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1047#1072#1103#1074#1082#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1077#1085#1085#1072#1103' ('#1062#1077#1093' '#1091#1087#1072#1082#1086#1074#1082#1080')>'
  ClientHeight = 456
  ClientWidth = 1020
  ExplicitWidth = 1036
  ExplicitHeight = 494
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 126
    Width = 1020
    Height = 325
    ExplicitTop = 126
    ExplicitWidth = 1020
    ExplicitHeight = 325
    ClientRectBottom = 325
    ClientRectRight = 1020
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1020
      ExplicitHeight = 301
      inherited cxGrid: TcxGrid
        Width = 1020
        Height = 301
        ExplicitWidth = 1020
        ExplicitHeight = 301
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
              Column = AmountSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForecast
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForecastOrder
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartnerPrior
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemains_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPrognoz_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPrognozOrder_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemains_child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemainsChild_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSend_sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSend_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountBaza_sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountBaza_Weight
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
              Column = AmountSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForecast
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForecastOrder
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartnerPrior
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemains_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPrognoz_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPrognozOrder_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemains_child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountRemainsChild_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSend_sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSend_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountBaza_sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountBaza_Weight
            end>
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object UnitCode: TcxGridDBColumn [0]
            Caption = #1050#1086#1076' '#1087#1086#1076#1088'.'
            DataBinding.FieldName = 'UnitCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object UnitName: TcxGridDBColumn [1]
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsGroupNameFull: TcxGridDBColumn [2]
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 122
          end
          object GoodsCode: TcxGridDBColumn [3]
            Caption = #1050#1086#1076' ('#1075#1083'.)'
            DataBinding.FieldName = 'GoodsCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsName: TcxGridDBColumn [4]
            Caption = #1058#1086#1074#1072#1088' ('#1075#1083'.)'
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object GoodsKindName: TcxGridDBColumn [5]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1075#1083'.)'
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object MeasureName: TcxGridDBColumn [6]
            Caption = #1045#1076'. '#1080#1079#1084'. ('#1075#1083'.)'
            DataBinding.FieldName = 'MeasureName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsCode_detail: TcxGridDBColumn [7]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode_detail'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsName_detail: TcxGridDBColumn [8]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName_detail'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsKindName_detail: TcxGridDBColumn [9]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName_detail'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object MeasureName_detail: TcxGridDBColumn [10]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName_detail'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object isCheck_detail: TcxGridDBColumn [11]
            Caption = #1056#1072#1079#1085'. ('#1090#1086#1074'.)'
            DataBinding.FieldName = 'isCheck_detail'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object TermProduction: TcxGridDBColumn [12]
            Caption = #1057#1088#1086#1082' '#1087#1088#1086#1080#1079#1074'. '#1074' '#1076#1085'.'
            DataBinding.FieldName = 'TermProduction'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object NormInDays: TcxGridDBColumn [13]
            Caption = #1053#1086#1088#1084#1072' '#1079#1072#1087#1072#1089' '#1074' '#1076#1085'.'
            DataBinding.FieldName = 'NormInDays'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object StartProductionInDays: TcxGridDBColumn [14]
            Caption = #1053#1072#1095'. '#1087#1088#1086#1080#1079#1074'. '#1074' '#1076#1085'.'
            DataBinding.FieldName = 'StartProductionInDays'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Koeff: TcxGridDBColumn [15]
            Caption = #1050#1086#1101#1092#1092'.'
            DataBinding.FieldName = 'Koeff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object AmountForecastOrder: TcxGridDBColumn [16]
            Caption = #1055#1088#1086#1075#1085#1086#1079' '#1087#1086' '#1079#1072#1103#1074'.'
            DataBinding.FieldName = 'AmountForecastOrder'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object AmountForecast: TcxGridDBColumn [17]
            Caption = #1055#1088#1086#1075#1085#1086#1079' '#1087#1086' '#1087#1088#1086#1076'.'
            DataBinding.FieldName = 'AmountForecast'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountForecastOrder: TcxGridDBColumn [18]
            Caption = #1055#1088#1086#1075#1085' 1'#1076' ('#1087#1086' '#1079#1074'.) '#1073#1077#1079' '#1050
            DataBinding.FieldName = 'CountForecastOrder'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object CountForecast: TcxGridDBColumn [19]
            Caption = #1055#1088#1086#1075#1085' 1'#1076' ('#1087#1086' '#1087#1088'.) '#1073#1077#1079' '#1050
            DataBinding.FieldName = 'CountForecast'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object CountForecastOrderK: TcxGridDBColumn [20]
            Caption = #1055#1088#1086#1075#1085' 1'#1076' ('#1087#1086' '#1079#1074'.)'
            DataBinding.FieldName = 'CountForecastOrderK'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object CountForecastK: TcxGridDBColumn [21]
            Caption = #1055#1088#1086#1075#1085' 1'#1076' ('#1087#1086' '#1087#1088'.)'
            DataBinding.FieldName = 'CountForecastK'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object DayCountForecastOrder: TcxGridDBColumn [22]
            Caption = #1054#1089#1090'. '#1074' '#1076#1085#1103#1093' ('#1087#1086' '#1079#1074'.) '
            DataBinding.FieldName = 'DayCountForecastOrder'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object DayCountForecast: TcxGridDBColumn [23]
            Caption = #1054#1089#1090'. '#1074' '#1076#1085#1103#1093' ('#1087#1086' '#1087#1088'.) '
            DataBinding.FieldName = 'DayCountForecast'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object AmountRemains: TcxGridDBColumn [24]
            Caption = #1054#1089#1090'. '#1085#1072#1095#1072#1083#1100#1085'.'
            DataBinding.FieldName = 'AmountRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountPartnerPrior: TcxGridDBColumn [25]
            Caption = #1085#1077#1086#1090#1075#1088#1091#1078'. '#1079#1072#1103#1074#1082#1072
            DataBinding.FieldName = 'AmountPartnerPrior'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountPartner: TcxGridDBColumn [26]
            Caption = #1089#1077#1075#1086#1076#1085#1103' '#1079#1072#1103#1074#1082#1072
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountRemains_child: TcxGridDBColumn [27]
            Caption = #1054#1089#1090'. '#1085#1072' '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'AmountRemains_child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountRemains_calc: TcxGridDBColumn [28]
            Caption = #1055#1088#1086#1075#1085'. '#1086#1089#1090'.'
            DataBinding.FieldName = 'AmountRemains_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountRemainsChild_calc: TcxGridDBColumn [29]
            Caption = #1055#1088#1086#1075#1085'. '#1086#1089#1090'. (+ '#1085#1072' '#1091#1087#1072#1082'.)'
            DataBinding.FieldName = 'AmountRemainsChild_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountPrognozOrder_calc: TcxGridDBColumn [30]
            Caption = #1053#1086#1088#1084#1072' '#1079#1072#1087#1072#1089' ('#1087#1086' '#1079#1074'.)'
            DataBinding.FieldName = 'AmountPrognozOrder_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountPrognoz_calc: TcxGridDBColumn [31]
            Caption = #1053#1086#1088#1084#1072' '#1079#1072#1087#1072#1089' ('#1087#1086' '#1087#1088'.)'
            DataBinding.FieldName = 'AmountPrognoz_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Amount: TcxGridDBColumn [32]
            Caption = #1047#1072#1082#1072#1079' '#1085#1072' '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object AmountSecond: TcxGridDBColumn [33]
            Caption = #1044#1086#1079#1072#1082#1072#1079' '#1085#1072' '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'AmountSecond'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object isPercent_diff: TcxGridDBColumn [34]
            Caption = #1054#1090#1082#1083'.'
            DataBinding.FieldName = 'isPercent_diff'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object Percent_diff: TcxGridDBColumn [35]
            Caption = '% '#1086#1090#1082#1083'.'
            DataBinding.FieldName = 'Percent_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object AmountSend_sh: TcxGridDBColumn [36]
            Caption = #1055#1088#1080#1093#1086#1076' '#1089' '#1091#1087#1072#1082'. '#1096#1090'.'
            DataBinding.FieldName = 'AmountSend_sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountSend_Weight: TcxGridDBColumn [37]
            Caption = #1055#1088#1080#1093#1086#1076' '#1089' '#1091#1087#1072#1082'. '#1074#1077#1089
            DataBinding.FieldName = 'AmountSend_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountBaza_sh: TcxGridDBColumn [38]
            Caption = #1055#1088#1080#1093#1086#1076' '#1089' '#1087#1088'-'#1074#1072' '#1096#1090'.'
            DataBinding.FieldName = 'AmountBaza_sh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountBaza_Weight: TcxGridDBColumn [39]
            Caption = #1055#1088#1080#1093#1086#1076' '#1089' '#1087#1088'-'#1074#1072' '#1074#1077#1089
            DataBinding.FieldName = 'AmountBaza_Weight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ReceiptCode_code: TcxGridDBColumn [40]
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'. ('#1082#1086#1076')'
            DataBinding.FieldName = 'ReceiptCode_code'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ReceiptCode: TcxGridDBColumn [41]
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'.'
            DataBinding.FieldName = 'ReceiptCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ReceiptName: TcxGridDBColumn [42]
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
            DataBinding.FieldName = 'ReceiptName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ReceiptCode_code_basis: TcxGridDBColumn [43]
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'. ('#1075#1083'. '#1082#1086#1076')'
            DataBinding.FieldName = 'ReceiptCode_code_basis'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object ReceiptCode_basis: TcxGridDBColumn [44]
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'. ('#1075#1083'.)'
            DataBinding.FieldName = 'ReceiptCode_basis'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ReceiptName_basis: TcxGridDBColumn [45]
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099' ('#1075#1083'.)'
            DataBinding.FieldName = 'ReceiptName_basis'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object Color_send: TcxGridDBColumn [46]
            DataBinding.FieldName = 'Color_send'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_Percent_diff: TcxGridDBColumn [47]
            DataBinding.FieldName = 'Color_Percent_diff'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorB_Percent_diff: TcxGridDBColumn [48]
            DataBinding.FieldName = 'ColorB_Percent_diff'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_remains: TcxGridDBColumn [49]
            DataBinding.FieldName = 'Color_remains'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_remains_calc: TcxGridDBColumn [50]
            DataBinding.FieldName = 'Color_remains_calc'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          object Color_remainsChild_calc: TcxGridDBColumn [51]
            DataBinding.FieldName = 'Color_remainsChild_calc'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorB_const: TcxGridDBColumn [52]
            DataBinding.FieldName = 'ColorB_const'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorB_DayCountForecast: TcxGridDBColumn [53]
            DataBinding.FieldName = 'ColorB_DayCountForecast'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorB_AmountPartner: TcxGridDBColumn [54]
            DataBinding.FieldName = 'ColorB_AmountPartner'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object ColorB_AmountPrognoz: TcxGridDBColumn [55]
            DataBinding.FieldName = 'ColorB_AmountPrognoz'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1020
    Height = 100
    TabOrder = 3
    ExplicitWidth = 1020
    ExplicitHeight = 100
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
      ExplicitWidth = 99
      Width = 99
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 123
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 123
      ExplicitWidth = 103
      Width = 103
    end
    inherited cxLabel2: TcxLabel
      Left = 123
      ExplicitLeft = 123
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 63
      ExplicitTop = 63
      ExplicitWidth = 218
      ExplicitHeight = 22
      Width = 218
    end
    object cxLabel3: TcxLabel
      Left = 234
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object edFrom: TcxButtonEdit
      Left = 234
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 270
    end
    object edTo: TcxButtonEdit
      Left = 516
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 8
      Width = 270
    end
    object cxLabel4: TcxLabel
      Left = 516
      Top = 5
      Caption = #1050#1086#1084#1091
    end
    object cxLabel18: TcxLabel
      Left = 345
      Top = 45
      Caption = #1044#1085#1080
    end
    object edDayCount: TcxCurrencyEdit
      Left = 345
      Top = 63
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 39
    end
    object edOperDateStart: TcxDateEdit
      Left = 391
      Top = 63
      EditValue = 42174d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 12
      Width = 89
    end
    object cxLabel19: TcxLabel
      Left = 391
      Top = 45
      Caption = #1055#1088#1086#1075#1085#1086#1079' '#1089
    end
    object cxLabel20: TcxLabel
      Left = 487
      Top = 45
      Caption = #1055#1088#1086#1075#1085#1086#1079' '#1087#1086
    end
    object edOperDateEnd: TcxDateEdit
      Left = 487
      Top = 63
      EditValue = 42174d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 15
      Width = 89
    end
    object cxLabel16: TcxLabel
      Left = 583
      Top = 45
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 583
      Top = 63
      TabOrder = 17
      Width = 385
    end
  end
  object edOperDatePartner: TcxDateEdit [2]
    Left = 234
    Top = 63
    EditValue = 42174d
    Enabled = False
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 6
    Width = 104
  end
  object cxLabel10: TcxLabel [3]
    Left = 234
    Top = 45
    Caption = #1044#1072#1090#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1072
  end
  object cxBottomSplitter: TcxSplitter [4]
    Left = 0
    Top = 451
    Width = 1020
    Height = 5
    AlignSplitter = salBottom
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 115
    Top = 232
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 32
    Top = 232
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    inherited actRefresh: TdsdDataSetRefresh
      RefreshOnTabSetChanges = True
    end
    object actPrintScan: TdsdPrintAction [8]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1096#1090#1088#1080#1093#1082#1086#1076')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1096#1090#1088#1080#1093#1082#1086#1076')'
      ImageIndex = 16
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'UnitCode;GoodsGroupNameFull;GoodsName_basis;GoodsName;GoodsKindN' +
            'ame'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1089#1082#1072#1085')'
      ReportNameParam.Value = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1089#1082#1072#1085')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'UnitCode;GoodsGroupNameFull;GoodsName_basis;GoodsName;GoodsKindN' +
            'ame'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091
      ReportNameParam.Value = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091
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
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
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
    object actRefreshPrice: TdsdDataSetRefresh
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
    object actUpdateAmountRemains: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAmountRemains
      StoredProcList = <
        item
          StoredProc = spUpdateAmountRemains
        end>
      Caption = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' '#1086#1089#1090#1072#1090#1086#1082
      Hint = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' '#1086#1089#1090#1072#1090#1086#1082
      ImageIndex = 47
    end
    object MultiAmountRemain: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdateMovement
        end
        item
          Action = actUpdateAmountRemains
        end
        item
          Action = actRefreshPrice
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1054#1089#1090#1072#1090#1086#1082'>?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1054#1089#1090#1072#1090#1086#1082'>'
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1054#1089#1090#1072#1090#1086#1082'>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1054#1089#1090#1072#1090#1086#1082'>'
      ImageIndex = 47
    end
    object actUpdateAmountPartner: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAmountPartner
      StoredProcList = <
        item
          StoredProc = spUpdateAmountPartner
        end>
      Caption = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1079#1072#1082#1072#1079
      Hint = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1079#1072#1082#1072#1079
      ImageIndex = 48
    end
    object MultiAmountPartner: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdateMovement
        end
        item
          Action = actUpdateAmountPartner
        end
        item
          Action = actRefreshPrice
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1047#1072#1082#1072#1079' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1047#1072#1082#1072#1079' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1047#1072#1082#1072#1079' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1047#1072#1082#1072#1079' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      ImageIndex = 48
    end
    object actUpdateAmountForecast: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAmountForecast
      StoredProcList = <
        item
          StoredProc = spUpdateAmountForecast
        end>
      Caption = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1086#1075#1085#1086#1079
      Hint = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1086#1075#1085#1086#1079
      ImageIndex = 49
    end
    object MultiAmountForecast: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdateMovement
        end
        item
          Action = actUpdateAmountForecast
        end
        item
          Action = actRefreshPrice
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1055#1088#1086#1075#1085#1086#1079'>?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1055#1088#1086#1075#1085#1086#1079'>'
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1055#1088#1086#1075#1085#1086#1079'>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' <'#1055#1088#1086#1075#1085#1086#1079'>'
      ImageIndex = 49
    end
    object actUpdateAmountAll: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdateMovement
        end
        item
          Action = actUpdateAmountRemains
        end
        item
          Action = actUpdateAmountPartner
        end
        item
          Action = actUpdateAmountForecast
        end
        item
          Action = actRefreshPrice
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' <'#1042#1089#1077'> '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077'?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' <'#1042#1089#1077'> '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' <'#1042#1089#1077'> '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' <'#1042#1089#1077'> '#1088#1072#1089#1095#1077#1090#1085#1099#1077' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 50
    end
  end
  inherited MasterDS: TDataSource
    Left = 16
    Top = 392
  end
  inherited MasterCDS: TClientDataSet
    Left = 72
    Top = 392
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_OrderInternalPack'
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
      end>
    Left = 152
    Top = 296
  end
  inherited BarManager: TdxBarManager
    Left = 72
    Top = 255
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
          ItemName = 'bbUnErased'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
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
          ItemName = 'bbUpdateAmountAll'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMultiAmountRemain'
        end
        item
          Visible = True
          ItemName = 'bbMultiAmountPartner'
        end
        item
          Visible = True
          ItemName = 'bbMultiAmountForecast'
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
          ItemName = 'bbPrintScan'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    object bbPrintScan: TdxBarButton [5]
      Action = actPrintScan
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
    object bbMultiAmountRemain: TdxBarButton
      Action = MultiAmountRemain
      Category = 0
    end
    object bbMultiAmountPartner: TdxBarButton
      Action = MultiAmountPartner
      Category = 0
    end
    object bbMultiAmountForecast: TdxBarButton
      Action = MultiAmountForecast
      Category = 0
    end
    object bbUpdateAmountAll: TdxBarButton
      Action = actUpdateAmountAll
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ColorColumn = Koeff
        BackGroundValueColumn = ColorB_const
        ColorValueList = <>
      end
      item
        ColorColumn = TermProduction
        BackGroundValueColumn = ColorB_const
        ColorValueList = <>
      end
      item
        ColorColumn = NormInDays
        BackGroundValueColumn = ColorB_const
        ColorValueList = <>
      end
      item
        ColorColumn = StartProductionInDays
        BackGroundValueColumn = ColorB_const
        ColorValueList = <>
      end
      item
        ColorColumn = CountForecastOrderK
        BackGroundValueColumn = ColorB_DayCountForecast
        ColorValueList = <>
      end
      item
        ColorColumn = CountForecastK
        BackGroundValueColumn = ColorB_DayCountForecast
        ColorValueList = <>
      end
      item
        ColorColumn = DayCountForecastOrder
        ValueColumn = Color_remains
        BackGroundValueColumn = ColorB_DayCountForecast
        ColorValueList = <>
      end
      item
        ColorColumn = DayCountForecast
        ValueColumn = Color_remains
        BackGroundValueColumn = ColorB_DayCountForecast
        ColorValueList = <>
      end
      item
        ColorColumn = AmountRemains
        ValueColumn = Color_remains
        ColorValueList = <>
      end
      item
        ColorColumn = AmountPartnerPrior
        BackGroundValueColumn = ColorB_AmountPartner
        ColorValueList = <>
      end
      item
        ColorColumn = AmountPartner
        BackGroundValueColumn = ColorB_AmountPartner
        ColorValueList = <>
      end
      item
        ColorColumn = AmountRemains_child
        BackGroundValueColumn = ColorB_AmountPartner
        ColorValueList = <>
      end
      item
        ColorColumn = AmountPrognozOrder_calc
        BackGroundValueColumn = ColorB_AmountPrognoz
        ColorValueList = <>
      end
      item
        ColorColumn = AmountPrognoz_calc
        BackGroundValueColumn = ColorB_AmountPrognoz
        ColorValueList = <>
      end
      item
        ColorColumn = AmountRemains_calc
        ValueColumn = Color_remains_calc
        ColorValueList = <>
      end
      item
        ColorColumn = AmountRemainsChild_calc
        ValueColumn = Color_remainsChild_calc
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSend_sh
        ValueColumn = Color_send
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSend_Weight
        ValueColumn = Color_send
        ColorValueList = <>
      end
      item
        ColorColumn = Percent_diff
        ValueColumn = Color_Percent_diff
        BackGroundValueColumn = ColorB_Percent_diff
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSend_sh
        ValueColumn = Color_send
        ColorValueList = <>
      end
      item
        ColorColumn = AmountSend_Weight
        ValueColumn = Color_send
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
    Left = 350
    Top = 337
  end
  inherited PopupMenu: TPopupMenu
    Left = 8
    Top = 312
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
        Name = 'isPack'
        Value = True
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 369
  end
  inherited StatusGuides: TdsdGuides
    Left = 80
    Top = 48
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_OrderInternal'
    Left = 128
    Top = 56
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderInternal'
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
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPack'
        Value = Null
        Component = FormParams
        ComponentItem = 'isPack'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inFromId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inToId'
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
        Name = 'OperDatePartner'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateStart'
        Value = 'False'
        Component = edOperDateStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDateEnd'
        Value = 0.000000000000000000
        Component = edOperDateEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DayCount'
        Value = 0.000000000000000000
        Component = edDayCount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 296
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_OrderInternal'
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
        Name = 'outOperDatePartner'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperDateStart'
        Value = 'False'
        Component = edOperDateStart
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioOperDateEnd'
        Value = 0.000000000000000000
        Component = edOperDateEnd
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDayCount'
        Value = ''
        Component = edDayCount
        DataType = ftFloat
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
        Name = 'inIsRemains'
        Value = False
        DataType = ftBoolean
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
    Left = 170
    Top = 336
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
      end>
    Left = 184
    Top = 232
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
      end
      item
        Control = edOperDatePartner
      end
      item
        Control = edOperDateStart
      end
      item
        Control = edOperDateEnd
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end
      item
        Control = ceComment
      end>
    Left = 224
    Top = 241
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 424
    Top = 336
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderInternal_SetErased'
    Left = 438
    Top = 392
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderInternal_SetUnErased'
    Left = 526
    Top = 376
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_OrderInternal'
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
        Name = 'inCuterCount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCuterCountSecond'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountSecond'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountSecond'
        DataType = ftFloat
        ParamType = ptInputOutput
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
        Name = 'inReceiptId_basis'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReceiptId_basis'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPack'
        Value = Null
        Component = FormParams
        ComponentItem = 'isPack'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 168
    Top = 392
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 368
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 412
    Top = 268
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
    Left = 468
    Top = 249
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 246
  end
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 644
    Top = 334
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderInternalPack_Print'
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
    Left = 319
    Top = 248
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TUnitForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitForm'
    PositionDataSet = 'ClientDataSet'
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
    Left = 336
    Top = 8
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TUnitForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitForm'
    PositionDataSet = 'ClientDataSet'
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
    Left = 624
    Top = 8
  end
  object spUpdateAmountRemains: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderInternal_AmountRemains'
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
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
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
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 586
    Top = 248
  end
  object spUpdateAmountPartner: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderInternal_AmountPartner'
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
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
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
      end>
    PackSize = 1
    Left = 656
    Top = 264
  end
  object spUpdateAmountForecast: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderInternal_AmountForecast'
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
        Name = 'inStartDate'
        Value = 0d
        Component = edOperDateStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 0d
        Component = edOperDateEnd
        DataType = ftDateTime
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
      end>
    PackSize = 1
    Left = 736
    Top = 280
  end
end
