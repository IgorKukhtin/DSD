inherited OrderInternalPackRemainsForm: TOrderInternalPackRemainsForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1086#1089#1090#1072#1090#1082#1080')>'
  ClientHeight = 639
  ClientWidth = 1020
  ExplicitWidth = 1036
  ExplicitHeight = 677
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 126
    Width = 1020
    Height = 513
    ExplicitTop = 126
    ExplicitWidth = 1020
    ExplicitHeight = 513
    ClientRectBottom = 513
    ClientRectRight = 1020
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1020
      ExplicitHeight = 489
      inherited cxGrid: TcxGrid
        Width = 1020
        Height = 281
        ExplicitWidth = 1020
        ExplicitHeight = 281
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
              Column = Remains
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
              Column = AmountPartnerPrior
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForecastOrderPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForecastPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartnerPriorPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartnerPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountForecastOrder
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountForecast
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_CEH
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_CEH_Next
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Income_CEH
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_result_two
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartnerPriorTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartnerTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_pack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Income_PACK_from
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Income_PACK_to
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_result_pack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartnerNextPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForecastOrder
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForecastOrderPromo_noERR
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
              Column = Remains
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
              Column = AmountForecastOrderPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForecastPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartnerPriorPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartnerPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountForecastOrder
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountForecast
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartnerPrior
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_CEH
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_CEH_Next
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Income_CEH
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_result_two
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartnerPriorTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartnerTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_pack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Income_PACK_from
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Income_PACK_to
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_result_pack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartnerNextPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForecastOrder
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForecastOrderPromo_noERR
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
          object Num: TcxGridDBColumn [0]
            Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090
            DataBinding.FieldName = 'Num'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsGroupNameFull: TcxGridDBColumn [1]
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 122
          end
          object UnitCode: TcxGridDBColumn [2]
            Caption = #1050#1086#1076' '#1087#1086#1076#1088'. ('#1087#1088'.)'
            DataBinding.FieldName = 'UnitCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object UnitName: TcxGridDBColumn [3]
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object isCheck_basis: TcxGridDBColumn [4]
            Caption = #1056#1072#1079#1085'. ('#1090#1086#1074'.)'
            DataBinding.FieldName = 'isCheck_basis'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsCode_basis: TcxGridDBColumn [5]
            Caption = #1050#1086#1076' ('#1087#1088'.)'
            DataBinding.FieldName = 'GoodsCode_basis'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsName_basis: TcxGridDBColumn [6]
            Caption = #1058#1086#1074#1072#1088' ('#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
            DataBinding.FieldName = 'GoodsName_basis'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object MeasureName_basis: TcxGridDBColumn [7]
            Caption = #1045#1076'.'#1080#1079#1084'. ('#1087#1088'.)'
            DataBinding.FieldName = 'MeasureName_basis'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsCode: TcxGridDBColumn [8]
            Caption = #1050#1086#1076' ('#1085#1072' '#1091#1087#1072#1082'.)'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsName: TcxGridDBColumn [9]
            Caption = #1058#1086#1074#1072#1088' ('#1085#1072' '#1091#1087#1072#1082'.)'
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object GoodsKindName: TcxGridDBColumn [10]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1085#1072' '#1091#1087#1072#1082'.)'
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
            Width = 80
          end
          object MeasureName: TcxGridDBColumn [11]
            Caption = #1045#1076'. '#1080#1079#1084'. ('#1085#1072' '#1091#1087#1072#1082'.)'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Income_PACK_to: TcxGridDBColumn [12]
            Caption = #1056#1072#1089#1093#1086#1076' '#1085#1072' '#1091#1087#1072#1082'. ('#1060#1040#1050#1058')'
            DataBinding.FieldName = 'Income_PACK_to'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Income_PACK_from: TcxGridDBColumn [13]
            Caption = #1055#1088#1080#1093#1086#1076' '#1089' '#1091#1087#1072#1082'. ('#1060#1040#1050#1058')'
            DataBinding.FieldName = 'Income_PACK_from'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Amount_result: TcxGridDBColumn [14]
            Caption = #1056#1045#1047#1059#1051#1068#1058#1040#1058' '#1089' '#1087#1088'-'#1074#1086#1084
            DataBinding.FieldName = 'Amount_result'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Amount_result_two: TcxGridDBColumn [15]
            Caption = #1056#1045#1047#1059#1051#1068#1058#1040#1058' '#1073#1077#1079' '#1055#1056'-'#1042#1040
            DataBinding.FieldName = 'Amount_result_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Amount_result_pack: TcxGridDBColumn [16]
            Caption = #1056#1045#1047#1059#1051#1068#1058#1040#1058' ***'#1059#1055#1040#1050
            DataBinding.FieldName = 'Amount_result_pack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Amount: TcxGridDBColumn [17]
            Caption = '***'#1089' '#1054#1089#1090'. '#1085#1072' '#1059#1055#1040#1050
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1074#1099#1076#1072#1095#1080' '#1089' '#1054#1089#1090'. '#1085#1072' '#1059#1055#1040#1050
            Width = 70
          end
          object AmountSecond: TcxGridDBColumn [18]
            Caption = '***'#1089' '#1062#1077#1093#1072' '#1085#1072' '#1059#1055#1040#1050
            DataBinding.FieldName = 'AmountSecond'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1074#1099#1076#1072#1095#1080' '#1089' '#1062#1077#1093#1072' '#1085#1072' '#1059#1055#1040#1050
            Width = 70
          end
          object AmountTotal: TcxGridDBColumn [19]
            Caption = '***'#1048#1058#1054#1043#1054' '#1085#1072' '#1059#1055#1040#1050
            DataBinding.FieldName = 'AmountTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1074#1099#1076#1072#1095#1080' '#1048#1058#1054#1043#1054' '#1085#1072' '#1059#1055#1040#1050
            Options.Editing = False
            Width = 70
          end
          object AmountPartnerPriorTotal: TcxGridDBColumn [20]
            Caption = #1085#1077#1086#1090#1075#1088#1091#1078'. '#1079#1072#1103#1074#1082#1072' ('#1080#1090#1086#1075#1086')'
            DataBinding.FieldName = 'AmountPartnerPriorTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountNext: TcxGridDBColumn [21]
            Caption = '2**'#1089' '#1054#1089#1090'. '#1085#1072' '#1059#1055#1040#1050
            DataBinding.FieldName = 'AmountNext'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085'2 '#1074#1099#1076#1072#1095#1080' '#1089' '#1054#1089#1090'. '#1085#1072' '#1059#1055#1040#1050
            Width = 70
          end
          object AmountNextSecond: TcxGridDBColumn [22]
            Caption = '2**'#1089' '#1062#1077#1093#1072' '#1085#1072' '#1059#1055#1040#1050
            DataBinding.FieldName = 'AmountNextSecond'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085'2 '#1074#1099#1076#1072#1095#1080' '#1089' '#1062#1077#1093#1072' '#1085#1072' '#1059#1055#1040#1050
            Width = 70
          end
          object AmountNextTotal: TcxGridDBColumn [23]
            Caption = '2**'#1048#1058#1054#1043#1054' '#1085#1072' '#1059#1055#1040#1050
            DataBinding.FieldName = 'AmountNextTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085'2 '#1074#1099#1076#1072#1095#1080' '#1048#1058#1054#1043#1054' '#1085#1072' '#1059#1055#1040#1050
            Options.Editing = False
            Width = 70
          end
          object AmountAllTotal: TcxGridDBColumn [24]
            Caption = '***'#1048#1058#1054#1043#1054' '#1085#1072' '#1059#1055#1040#1050' ('#1055#1083#1072#1085' + '#1055#1083#1072#1085'2)'
            DataBinding.FieldName = 'AmountAllTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1074#1099#1076#1072#1095#1080' '#1048#1058#1054#1043#1054' '#1085#1072' '#1059#1055#1040#1050
            Options.Editing = False
            Width = 70
          end
          object AmountPartnerPrior: TcxGridDBColumn [25]
            Caption = #1085#1077#1086#1090#1075#1088#1091#1078'. '#1079#1072#1103#1074#1082#1072' ('#1073#1077#1079' '#1040#1082#1094'.)'
            DataBinding.FieldName = 'AmountPartnerPrior'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountPartnerPriorPromo: TcxGridDBColumn [26]
            Caption = #1085#1077#1086#1090#1075#1088#1091#1078'. '#1079#1072#1103#1074#1082#1072' ('#1040#1082#1094#1080#1080')'
            DataBinding.FieldName = 'AmountPartnerPriorPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountPartnerTotal: TcxGridDBColumn [27]
            Caption = #1089#1077#1075#1086#1076#1085#1103' '#1079#1072#1103#1074#1082#1072' ('#1080#1090#1086#1075#1086')'
            DataBinding.FieldName = 'AmountPartnerTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Remains: TcxGridDBColumn [28]
            Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1053#1045' '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'Remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090'. '#1085#1072#1095'. - '#1053#1045' '#1091#1087#1072#1082#1086#1074#1072#1085#1085#1099#1081
            Options.Editing = False
            Width = 70
          end
          object Remains_pack: TcxGridDBColumn [29]
            Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'Remains_pack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090'. '#1085#1072#1095'. '#1091#1087#1072#1082#1086#1074#1072#1085#1085#1099#1081
            Options.Editing = False
            Width = 70
          end
          object Remains_CEH: TcxGridDBColumn [30]
            Caption = ' '#1054#1089#1090'. '#1085#1072#1095'. '#1087#1088'-'#1074#1086' ('#1057#1045#1043#1054#1044#1053#1071')'
            DataBinding.FieldName = 'Remains_CEH'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090'. '#1085#1072#1095'. '#1087#1088'-'#1074#1086' ('#1057#1045#1043#1054#1044#1053#1071')'
            Options.Editing = False
            Width = 75
          end
          object Remains_CEH_Next: TcxGridDBColumn [31]
            Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1087#1088'-'#1074#1086' ('#1055#1054#1047#1046#1045')'
            DataBinding.FieldName = 'Remains_CEH_Next'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Income_CEH: TcxGridDBColumn [32]
            Caption = #1055#1088#1080#1093#1086#1076' '#1087#1088'-'#1074#1086' ('#1060#1040#1050#1058')'
            DataBinding.FieldName = 'Income_CEH'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CountForecastOrder: TcxGridDBColumn [33]
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
          object CountForecast: TcxGridDBColumn [34]
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
          object AmountForecastOrder: TcxGridDBColumn [35]
            Caption = #1055#1088#1086#1075#1085#1086#1079' '#1087#1086' '#1079#1072#1103#1074'. ('#1073#1077#1079' '#1040#1082#1094'.)'
            DataBinding.FieldName = 'AmountForecastOrder'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountForecastOrderPromo_noERR: TcxGridDBColumn [36]
            Caption = #1055#1088#1086#1075#1085#1086#1079' '#1087#1086' '#1079#1072#1103#1074'. ('#1040#1082#1094#1080#1080')'
            DataBinding.FieldName = 'AmountForecastOrderPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountForecastOrderPromo: TcxGridDBColumn [37]
            Caption = #1055#1088#1086#1075#1085#1086#1079' '#1087#1086' '#1079#1072#1103#1074'. ('#1040#1082#1094#1080#1080'*)'
            DataBinding.FieldName = 'AmountForecastOrderPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountForecast: TcxGridDBColumn [38]
            Caption = #1055#1088#1086#1075#1085#1086#1079' '#1087#1086' '#1087#1088#1086#1076'. ('#1073#1077#1079' '#1040#1082#1094'.)'
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
          object AmountForecastPromo: TcxGridDBColumn [39]
            Caption = #1055#1088#1086#1075#1085#1086#1079' '#1087#1086' '#1087#1088#1086#1076'. ('#1040#1082#1094#1080#1080')'
            DataBinding.FieldName = 'AmountForecastPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object DayCountForecastOrder: TcxGridDBColumn [40]
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
          object DayCountForecast: TcxGridDBColumn [41]
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
          object ReceiptCode_basis: TcxGridDBColumn [42]
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'. ('#1087#1088'.)'
            DataBinding.FieldName = 'ReceiptCode_basis'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ReceiptName_basis: TcxGridDBColumn [43]
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099' ('#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
            DataBinding.FieldName = 'ReceiptName_basis'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object ReceiptCode: TcxGridDBColumn [44]
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'. '#1043#1055
            DataBinding.FieldName = 'ReceiptCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ReceiptName: TcxGridDBColumn [45]
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099' '#1043#1055
            DataBinding.FieldName = 'ReceiptName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Id: TcxGridDBColumn [46]
            DataBinding.FieldName = 'Id'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object AmountPartner: TcxGridDBColumn [47]
            Caption = #1089#1077#1075#1086#1076#1085#1103' '#1079#1072#1103#1074#1082#1072' ('#1073#1077#1079' '#1040#1082#1094'.)'
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountPartnerPromo: TcxGridDBColumn [48]
            Caption = #1089#1077#1075#1086#1076#1085#1103' '#1079#1072#1103#1074#1082#1072' ('#1040#1082#1094#1080#1080')'
            DataBinding.FieldName = 'AmountPartnerPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountPartnerNextPromo: TcxGridDBColumn [49]
            Caption = #1074' '#1090'.'#1095'. '#1079#1072#1074#1090#1088#1072' '#1079#1072#1103#1074#1082#1072' ('#1040#1082#1094#1080#1080')'
            DataBinding.FieldName = 'AmountPartnerNextPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086
            Options.Editing = False
            Width = 70
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
      object cxGridChild: TcxGrid
        Left = 0
        Top = 286
        Width = 1020
        Height = 203
        Align = alBottom
        TabOrder = 1
        object cxGridDBTableViewChild: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = chCountForecastOrder
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chCountForecast
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountForecastOrder
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountForecastOrderPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountForecast
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountForecastPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chRemains_pack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPartnerPrior
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPartnerPriorPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPartnerPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPackSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chIncome_PACK_to
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_result_two
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPackTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPartnerPriorTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPartnerTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chIncome_PACK_from
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPack_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountSecondPack_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPackTotal_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_result_pack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPartnerNextPromo
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = chCountForecastOrder
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chCountForecast
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountForecastOrder
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountForecastOrderPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountForecast
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountForecastPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chRemains_pack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPartnerPrior
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPartnerPriorPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPartnerPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPackSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chIncome_PACK_to
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_result_two
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPackTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPartnerPriorTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPartnerTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chIncome_PACK_from
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPack_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountSecondPack_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPackTotal_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount_result_pack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountPartnerNextPromo
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.Inactive = dmMain.cxSelection
          Styles.Selection = dmMain.cxSelection
          Styles.Footer = dmMain.cxFooterStyle
          Styles.Header = dmMain.cxHeaderStyle
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object сhGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object сhGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
          object сhGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object сhMeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object chIncome_PACK_to: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1085#1072' '#1091#1087#1072#1082'. ('#1060#1040#1050#1058')'
            DataBinding.FieldName = 'Income_PACK_to'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chIncome_PACK_from: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1089' '#1091#1087#1072#1082'. ('#1060#1040#1050#1058')'
            DataBinding.FieldName = 'Income_PACK_from'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chAmount_result_two: TcxGridDBColumn
            Caption = #1056#1045#1047#1059#1051#1068#1058#1040#1058' '#1073#1077#1079' '#1087#1088'-'#1074#1072
            DataBinding.FieldName = 'Amount_result_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chAmount_result_pack: TcxGridDBColumn
            Caption = #1056#1045#1047#1059#1051#1068#1058#1040#1058' ***'#1059#1055#1040#1050
            DataBinding.FieldName = 'Amount_result_pack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chAmountPack: TcxGridDBColumn
            Caption = '***'#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1089' '#1054#1089#1090'. '#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountPack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object chAmountPackSecond: TcxGridDBColumn
            Caption = '***'#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1089' '#1062#1077#1093#1072' '#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountPackSecond'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object chAmountPackTotal: TcxGridDBColumn
            Caption = '***'#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1048#1058#1054#1043#1054' '#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountPackTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chAmountPack_calc: TcxGridDBColumn
            Caption = '*'#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1089' '#1054#1089#1090'. '#1088#1072#1089#1095'.)'
            DataBinding.FieldName = 'AmountPack_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chAmountSecondPack_calc: TcxGridDBColumn
            Caption = '*'#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1089' '#1062#1077#1093#1072' '#1088#1072#1089#1095'.)'
            DataBinding.FieldName = 'AmountSecondPack_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chAmountPackTotal_calc: TcxGridDBColumn
            Caption = '*'#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1048#1058#1054#1043#1054' '#1088#1072#1089#1095'.)'
            DataBinding.FieldName = 'AmountPackTotal_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chAmountPackNext: TcxGridDBColumn
            Caption = '2**'#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1089' '#1054#1089#1090'. '#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountPackNext'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085'2'
            Width = 70
          end
          object chAmountPackNextSecond: TcxGridDBColumn
            Caption = '2**'#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1089' '#1062#1077#1093#1072' '#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountPackNextSecond'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085'2'
            Width = 70
          end
          object chAmountPackNextTotal: TcxGridDBColumn
            Caption = '2**'#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1048#1058#1054#1043#1054' '#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountPackNextTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1055#1083#1072#1085'2'
            Options.Editing = False
            Width = 70
          end
          object chAmountPackNext_calc: TcxGridDBColumn
            Caption = #1055#1083#1072#1085'2 '#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1089' '#1054#1089#1090'. '#1088#1072#1089#1095'.)'
            DataBinding.FieldName = 'AmountPackNext_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085'2'
            Options.Editing = False
            Width = 70
          end
          object chAmountPackNextSecond_calc: TcxGridDBColumn
            Caption = #1055#1083#1072#1085'2 '#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1089' '#1062#1077#1093#1072' '#1088#1072#1089#1095'.)'
            DataBinding.FieldName = 'AmountPackNextSecond_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chAmountPackNextTotal_calc: TcxGridDBColumn
            Caption = #1055#1083#1072#1085'2 '#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1048#1058#1054#1043#1054' '#1088#1072#1089#1095'.)'
            DataBinding.FieldName = 'AmountPackNextTotal_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085'2'
            Options.Editing = False
            Width = 70
          end
          object chAmountPartnerPriorTotal: TcxGridDBColumn
            Caption = #1085#1077#1086#1090#1075#1088#1091#1078'. '#1079#1072#1103#1074#1082#1072' ('#1080#1090#1086#1075#1086')'
            DataBinding.FieldName = 'AmountPartnerPriorTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chAmountPartnerPrior: TcxGridDBColumn
            Caption = #1085#1077#1086#1090#1075#1088#1091#1078'. '#1079#1072#1103#1074#1082#1072' ('#1073#1077#1079' '#1040#1082#1094'.)'
            DataBinding.FieldName = 'AmountPartnerPrior'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chAmountPartnerPriorPromo: TcxGridDBColumn
            Caption = #1085#1077#1086#1090#1075#1088#1091#1078'. '#1079#1072#1103#1074#1082#1072' ('#1040#1082#1094#1080#1080')'
            DataBinding.FieldName = 'AmountPartnerPriorPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chAmountPartnerTotal: TcxGridDBColumn
            Caption = #1089#1077#1075#1086#1076#1085#1103' '#1079#1072#1103#1074#1082#1072' ('#1080#1090#1086#1075#1086')'
            DataBinding.FieldName = 'AmountPartnerTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chAmountPartner: TcxGridDBColumn
            Caption = #1089#1077#1075#1086#1076#1085#1103' '#1079#1072#1103#1074#1082#1072' ('#1073#1077#1079' '#1040#1082#1094'.)'
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chAmountPartnerPromo: TcxGridDBColumn
            Caption = #1089#1077#1075#1086#1076#1085#1103' '#1079#1072#1103#1074#1082#1072' ('#1040#1082#1094#1080#1080')'
            DataBinding.FieldName = 'AmountPartnerPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chAmountPartnerNextPromo: TcxGridDBColumn
            Caption = #1074' '#1090'.'#1095'. '#1079#1072#1074#1090#1088#1072' '#1079#1072#1103#1074#1082#1072' ('#1040#1082#1094#1080#1080')'
            DataBinding.FieldName = 'AmountPartnerNextPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086
            Options.Editing = False
            Width = 70
          end
          object chRemains: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1053#1045' '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'Remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090'. '#1085#1072#1095'. - '#1053#1045' '#1091#1087#1072#1082#1086#1074#1072#1085#1085#1099#1081
            Options.Editing = False
            Width = 70
          end
          object chRemains_pack: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'Remains_pack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090'. '#1085#1072#1095'. '#1091#1087#1072#1082#1086#1074#1072#1085#1085#1099#1081
            Options.Editing = False
            Width = 70
          end
          object chCountForecastOrder: TcxGridDBColumn
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
          object chCountForecast: TcxGridDBColumn
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
          object chAmountForecastOrder: TcxGridDBColumn
            Caption = #1055#1088#1086#1075#1085#1086#1079' '#1087#1086' '#1079#1072#1103#1074'. ('#1073#1077#1079' '#1040#1082#1094'.)'
            DataBinding.FieldName = 'AmountForecastOrder'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chAmountForecastOrderPromo: TcxGridDBColumn
            Caption = #1055#1088#1086#1075#1085#1086#1079' '#1087#1086' '#1079#1072#1103#1074'. ('#1040#1082#1094#1080#1080')'
            DataBinding.FieldName = 'AmountForecastOrderPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chAmountForecast: TcxGridDBColumn
            Caption = #1055#1088#1086#1075#1085#1086#1079' '#1087#1086' '#1087#1088#1086#1076'. ('#1073#1077#1079' '#1040#1082#1094'.)'
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
          object chAmountForecastPromo: TcxGridDBColumn
            Caption = #1055#1088#1086#1075#1085#1086#1079' '#1087#1086' '#1087#1088#1086#1076'. ('#1040#1082#1094#1080#1080')'
            DataBinding.FieldName = 'AmountForecastPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chDayCountForecastOrder: TcxGridDBColumn
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
          object chDayCountForecast: TcxGridDBColumn
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
          object chDayCountForecast_calc: TcxGridDBColumn
            Caption = '***'#1054#1089#1090'. '#1074' '#1076#1085#1103#1093' ('#1059#1055#1040#1050') '
            DataBinding.FieldName = 'DayCountForecast_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chReceiptCode_basis: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'. ('#1087#1088'.)'
            DataBinding.FieldName = 'ReceiptCode_basis'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chReceiptName_basis: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099' ('#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
            DataBinding.FieldName = 'ReceiptName_basis'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object chReceiptCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'. '#1043#1055
            DataBinding.FieldName = 'ReceiptCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object chReceiptName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099' '#1043#1055
            DataBinding.FieldName = 'ReceiptName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object сhContainerId: TcxGridDBColumn
            Caption = #1087#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'ContainerId'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object chId: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object сhIsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'IsErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
        end
        object cxGridLevelChild: TcxGridLevel
          GridView = cxGridDBTableViewChild
        end
      end
      object cxBottomSplitter: TcxSplitter
        Left = 0
        Top = 281
        Width = 1020
        Height = 5
        AlignSplitter = salBottom
        Control = cxGridChild
      end
    end
    object tsTotal: TcxTabSheet
      Caption = #1048#1090#1086#1075#1086' '#1087#1086' '#1091#1087#1072#1082#1086#1074#1082#1077
      ImageIndex = 0
      object cxGridChildTotal: TcxGrid
        Left = 0
        Top = 0
        Width = 1020
        Height = 489
        Align = alClient
        TabOrder = 0
        object cxGridDBTableViewChildTotal: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildTotalDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtCountForecastOrder
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtCountForecast
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountForecastOrder
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountForecastOrderPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountForecast
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountForecastPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPartnerPrior
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPartnerPriorPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPartnerPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtRemains_CEH
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtRemains_CEH_Next
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtRemains_pack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtIncome_CEH
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmount_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmount_result_two
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPartnerPriorTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPartnerTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtIncome_PACK_from
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPackSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPackTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPack_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountSecondPack_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPackTotal_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtRemains_CEH_err
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtRemains_err
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtIncome_PACK_to
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmount_result_pack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPartnerNextPromo
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtCountForecastOrder
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtCountForecast
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountForecastOrder
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountForecastOrderPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountForecast
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountForecastPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtRemains
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPartnerPrior
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPartnerPriorPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPartnerPromo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtRemains_CEH
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtRemains_CEH_Next
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtRemains_pack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtIncome_CEH
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmount_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmount_result_two
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPartnerPriorTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPartnerTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtIncome_PACK_from
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPackSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPackTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPack_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountSecondPack_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPackTotal_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtRemains_CEH_err
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtRemains_err
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtIncome_PACK_to
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmount_result_pack
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chtAmountPartnerNextPromo
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.Inactive = dmMain.cxSelection
          Styles.Selection = dmMain.cxSelection
          Styles.Footer = dmMain.cxFooterStyle
          Styles.Header = dmMain.cxHeaderStyle
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object chtGoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 122
          end
          object chtUnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1076#1088'. ('#1087#1088'.)'
            DataBinding.FieldName = 'UnitCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object chtUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object chtIsCheck_basis: TcxGridDBColumn
            Caption = #1056#1072#1079#1085'. ('#1090#1086#1074'.)'
            DataBinding.FieldName = 'isCheck_basis'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object chtGoodsCode_basis: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1087#1088'.)'
            DataBinding.FieldName = 'GoodsCode_basis'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object chtGoodsName_basis: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
            DataBinding.FieldName = 'GoodsName_basis'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object chtMeasureName_basis: TcxGridDBColumn
            Caption = #1045#1076'.'#1080#1079#1084'. ('#1087#1088'.)'
            DataBinding.FieldName = 'MeasureName_basis'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtGoodsCode_complete: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1085#1072' '#1091#1087#1072#1082'.)'
            DataBinding.FieldName = 'GoodsCode_complete'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object chtGoodsName_complete: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1085#1072' '#1091#1087#1072#1082'.)'
            DataBinding.FieldName = 'GoodsName_complete'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object chtGoodsKindName_complete: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1085#1072' '#1091#1087#1072#1082'.)'
            DataBinding.FieldName = 'GoodsKindName_complete'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object chtMeasureName_complete: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'. ('#1085#1072' '#1091#1087#1072#1082'.)'
            DataBinding.FieldName = 'MeasureName_complete'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object chtGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object chtGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object chtMeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object chtIncome_PACK_to: TcxGridDBColumn
            Caption = #1056#1072#1089#1093#1086#1076' '#1085#1072' '#1091#1087#1072#1082'. ('#1060#1040#1050#1058')'
            DataBinding.FieldName = 'Income_PACK_to'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtIncome_PACK_from: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1089' '#1091#1087#1072#1082'. ('#1060#1040#1050#1058')'
            DataBinding.FieldName = 'Income_PACK_from'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtAmount_result: TcxGridDBColumn
            Caption = #1056#1045#1047#1059#1051#1068#1058#1040#1058' c '#1087#1088'-'#1074#1086#1084
            DataBinding.FieldName = 'Amount_result'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtAmount_result_two: TcxGridDBColumn
            Caption = #1056#1045#1047#1059#1051#1068#1058#1040#1058' '#1073#1077#1079' '#1087#1088'-'#1074#1072
            DataBinding.FieldName = 'Amount_result_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtAmount_result_pack: TcxGridDBColumn
            Caption = #1056#1045#1047#1059#1051#1068#1058#1040#1058' ***'#1059#1055#1040#1050
            DataBinding.FieldName = 'Amount_result_pack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtAmount: TcxGridDBColumn
            Caption = '***'#1089' '#1054#1089#1090'. '#1085#1072' '#1059#1055#1040#1050
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1074#1099#1076#1072#1095#1080' '#1089' '#1054#1089#1090'. '#1085#1072' '#1059#1055#1040#1050
            Width = 70
          end
          object chtAmountSecond: TcxGridDBColumn
            Caption = '***'#1089' '#1062#1077#1093#1072' '#1085#1072' '#1059#1055#1040#1050
            DataBinding.FieldName = 'AmountSecond'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1074#1099#1076#1072#1095#1080' '#1089' '#1062#1077#1093#1072' '#1085#1072' '#1059#1055#1040#1050
            Width = 70
          end
          object chtAmountTotal: TcxGridDBColumn
            Caption = '***'#1048#1058#1054#1043#1054' '#1085#1072' '#1059#1055#1040#1050
            DataBinding.FieldName = 'AmountTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1074#1099#1076#1072#1095#1080' '#1048#1058#1054#1043#1054' '#1085#1072' '#1059#1055#1040#1050
            Options.Editing = False
            Width = 70
          end
          object chtAmountPack: TcxGridDBColumn
            Caption = '***'#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1089' '#1054#1089#1090'. '#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountPack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object chtAmountPackSecond: TcxGridDBColumn
            Caption = '***'#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1089' '#1062#1077#1093#1072' '#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountPackSecond'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object chtAmountPackTotal: TcxGridDBColumn
            Caption = '***'#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1048#1058#1054#1043#1054' '#1092#1072#1082#1090')'
            DataBinding.FieldName = 'AmountPackTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtAmountPartnerNextPromo: TcxGridDBColumn
            Caption = #1074' '#1090'.'#1095'. '#1079#1072#1074#1090#1088#1072' '#1079#1072#1103#1074#1082#1072' ('#1040#1082#1094#1080#1080')'
            DataBinding.FieldName = 'AmountPartnerNextPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086
            Options.Editing = False
            Width = 70
          end
          object chtAmountPack_calc: TcxGridDBColumn
            Caption = '*'#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1089' '#1054#1089#1090'. '#1088#1072#1089#1095'.)'
            DataBinding.FieldName = 'AmountPack_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtAmountSecondPack_calc: TcxGridDBColumn
            Caption = '*'#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1089' '#1062#1077#1093#1072' '#1088#1072#1089#1095'.)'
            DataBinding.FieldName = 'AmountSecondPack_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtAmountPackTotal_calc: TcxGridDBColumn
            Caption = '*'#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1048#1058#1054#1043#1054' '#1088#1072#1089#1095'.)'
            DataBinding.FieldName = 'AmountPackTotal_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtAmountPartnerPriorTotal: TcxGridDBColumn
            Caption = #1085#1077#1086#1090#1075#1088#1091#1078'. '#1079#1072#1103#1074#1082#1072' ('#1080#1090#1086#1075#1086')'
            DataBinding.FieldName = 'AmountPartnerPriorTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtAmountPartnerPrior: TcxGridDBColumn
            Caption = #1085#1077#1086#1090#1075#1088#1091#1078'. '#1079#1072#1103#1074#1082#1072' ('#1073#1077#1079' '#1040#1082#1094'.)'
            DataBinding.FieldName = 'AmountPartnerPrior'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtAmountPartnerPriorPromo: TcxGridDBColumn
            Caption = #1085#1077#1086#1090#1075#1088#1091#1078'. '#1079#1072#1103#1074#1082#1072' ('#1040#1082#1094#1080#1080')'
            DataBinding.FieldName = 'AmountPartnerPriorPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtAmountPartnerTotal: TcxGridDBColumn
            Caption = #1089#1077#1075#1086#1076#1085#1103' '#1079#1072#1103#1074#1082#1072' ('#1080#1090#1086#1075#1086')'
            DataBinding.FieldName = 'AmountPartnerTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtAmountPartner: TcxGridDBColumn
            Caption = #1089#1077#1075#1086#1076#1085#1103' '#1079#1072#1103#1074#1082#1072' ('#1073#1077#1079' '#1040#1082#1094'.)'
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtAmountPartnerPromo: TcxGridDBColumn
            Caption = #1089#1077#1075#1086#1076#1085#1103' '#1079#1072#1103#1074#1082#1072' ('#1040#1082#1094#1080#1080')'
            DataBinding.FieldName = 'AmountPartnerPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtRemains: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1053#1045' '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'Remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090'. '#1085#1072#1095'. - '#1053#1045' '#1091#1087#1072#1082#1086#1074#1072#1085#1085#1099#1081
            Options.Editing = False
            Width = 70
          end
          object chtRemains_pack: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'Remains_pack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090'. '#1085#1072#1095'. - '#1091#1087#1072#1082#1086#1074#1072#1085#1085#1099#1081
            Options.Editing = False
            Width = 70
          end
          object chtRemains_err: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1043#1055' ('#1054#1064#1048#1041#1050#1040')'
            DataBinding.FieldName = 'Remains_err'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtRemains_CEH: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1087#1088'-'#1074#1086' ('#1057#1045#1043#1054#1044#1053#1071')'
            DataBinding.FieldName = 'Remains_CEH'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090'. '#1085#1072#1095'. '#1087#1088'-'#1074#1086' ('#1057#1045#1043#1054#1044#1053#1071')'
            Options.Editing = False
            Width = 75
          end
          object chtRemains_CEH_Next: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1087#1088'-'#1074#1086' ('#1055#1054#1047#1046#1045')'
            DataBinding.FieldName = 'Remains_CEH_Next'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090'. '#1085#1072#1095'. '#1087#1088'-'#1074#1086' ('#1055#1054#1047#1046#1045')'
            Options.Editing = False
            Width = 70
          end
          object chtRemains_CEH_err: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. '#1087#1088'-'#1074#1086' ('#1054#1064#1048#1041#1050#1040')'
            DataBinding.FieldName = 'Remains_CEH_err'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtIncome_CEH: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1087#1088'-'#1074#1086' ('#1060#1040#1050#1058')'
            DataBinding.FieldName = 'Income_CEH'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtCountForecastOrder: TcxGridDBColumn
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
          object chtCountForecast: TcxGridDBColumn
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
          object chtAmountForecastOrder: TcxGridDBColumn
            Caption = #1055#1088#1086#1075#1085#1086#1079' '#1087#1086' '#1079#1072#1103#1074'. ('#1073#1077#1079' '#1040#1082#1094'.)'
            DataBinding.FieldName = 'AmountForecastOrder'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtAmountForecastOrderPromo: TcxGridDBColumn
            Caption = #1055#1088#1086#1075#1085#1086#1079' '#1087#1086' '#1079#1072#1103#1074'. ('#1040#1082#1094#1080#1080')'
            DataBinding.FieldName = 'AmountForecastOrderPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtAmountForecast: TcxGridDBColumn
            Caption = #1055#1088#1086#1075#1085#1086#1079' '#1087#1086' '#1087#1088#1086#1076'. ('#1073#1077#1079' '#1040#1082#1094'.)'
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
          object chtAmountForecastPromo: TcxGridDBColumn
            Caption = #1055#1088#1086#1075#1085#1086#1079' '#1087#1086' '#1087#1088#1086#1076'. ('#1040#1082#1094#1080#1080')'
            DataBinding.FieldName = 'AmountForecastPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtDayCountForecastOrder: TcxGridDBColumn
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
          object chtDayCountForecast: TcxGridDBColumn
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
          object chtDayCountForecast_calc: TcxGridDBColumn
            Caption = '***'#1054#1089#1090'. '#1074' '#1076#1085#1103#1093' ('#1059#1055#1040#1050') '
            DataBinding.FieldName = 'DayCountForecast_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtReceiptCode_basis: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'. ('#1087#1088'.)'
            DataBinding.FieldName = 'ReceiptCode_basis'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chtReceiptName_basis: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099' ('#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
            DataBinding.FieldName = 'ReceiptName_basis'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object chtReceiptCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'. '#1043#1055
            DataBinding.FieldName = 'ReceiptCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object chtReceiptName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099' '#1043#1055
            DataBinding.FieldName = 'ReceiptName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object chtPartionDate_pf: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' ('#1087#1092'-'#1075#1087')'
            DataBinding.FieldName = 'PartionDate_pf'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object chtGoodsKindName_pf: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1092'-'#1075#1087')'
            DataBinding.FieldName = 'GoodsKindName_pf'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object chtGoodsKindCompleteName_pf: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1043#1055' ('#1087#1092'-'#1075#1087')'
            DataBinding.FieldName = 'GoodsKindCompleteName_pf'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object chtPartionGoods_start: TcxGridDBColumn
            Caption = #1074#1089#1077' '#1095#1090#1086' <= '#1101#1090#1086#1081' '#1044#1072#1090#1099
            DataBinding.FieldName = 'PartionGoods_start'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object chtTermProduction: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1087#1088#1086#1080#1079#1074'. '#1074' '#1076#1085#1103#1093
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
          object chtContainerId: TcxGridDBColumn
            DataBinding.FieldName = 'ContainerId'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object chtId: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object chtIsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'IsErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
        end
        object cxGridLevelChildTotal: TcxGridLevel
          GridView = cxGridDBTableViewChildTotal
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1020
    Height = 100
    TabOrder = 3
    ExplicitLeft = 8
    ExplicitTop = -16
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
    object actGridTotalToExcel: TdsdGridToExcel [2]
      Category = 'DSDLib'
      TabSheet = tsTotal
      MoveParams = <>
      Enabled = False
      Grid = cxGridChildTotal
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProc = spUpdateMI_master
      StoredProcList = <
        item
          StoredProc = spUpdateMI_master
        end
        item
          StoredProc = spGetTotalSumm
        end>
    end
    object actUpdateChildDS: TdsdUpdateDataSet [9]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMI_AmountPack
      StoredProcList = <
        item
          StoredProc = spUpdateMI_AmountPack
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect
        end>
      Caption = 'actUpdateChildDS'
      DataSource = ChildDS
    end
    object actUpdateChildTotalDS: TdsdUpdateDataSet [10]
      Category = 'DSDLib'
      TabSheet = tsTotal
      MoveParams = <>
      Enabled = False
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMI_Amounts
      StoredProcList = <
        item
          StoredProc = spUpdateMI_Amounts
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect
        end>
      Caption = 'actUpdateChildTotalDS'
      DataSource = ChildTotalDS
    end
    object actPrintRemains: TdsdPrintAction [11]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintRemains
      StoredProcList = <
        item
          StoredProc = spSelectPrintRemains
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1047#1072#1103#1074#1082#1080' ('#1086#1089#1090#1072#1090#1082#1080')'
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 16
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName;GoodsName_Child;GoodsKindName_Child'
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
          Name = 'InvNumber'
          Value = Null
          Component = edInvNumber
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 'NULL'
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1086#1089#1090#1072#1090#1082#1080')'
      ReportNameParam.Value = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1086#1089#1090#1072#1090#1082#1080')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
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
          IndexFieldNames = 'UnitCode;GoodsGroupNameFull;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      ReportNameParam.Value = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
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
    object actGoodsKindChoice: TOpenChoiceForm [17]
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
    object mactUpdateAmountNext_to: TMultiAction
      Category = 'DSNext'
      TabSheet = tsMain
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateAmountNextAll_to
        end
        item
          Action = mactUpdateAmountNextGrid_to
        end
        item
          Action = actRefreshPrice
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. - '#1053#1045' '#1091#1087#1072#1082#1086#1074#1072#1085#1085#1099#1081'> ?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1083#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. - '#1053#1045' '#1091#1087#1072#1082#1086#1074#1072#1085#1085#1099#1081'>'
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. - '#1053#1045' '#1091#1087#1072#1082#1086#1074#1072#1085#1085#1099#1081'>'
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. - '#1053#1045' '#1091#1087#1072#1082#1086#1074#1072#1085#1085#1099#1081'>'
      ImageIndex = 71
    end
    object mactUpdateAmountNextGrid_to: TMultiAction
      Category = 'DSNext'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateAmountNext_to
        end>
      View = cxGridDBTableView
      Caption = 
        #1055#1077#1088#1077#1085#1086#1089#1103#1090#1089#1103' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. - '#1053#1045' '#1091#1087#1072#1082#1086#1074#1072#1085#1085#1099#1081'> '#1074' <***'#1054#1089#1090'. '#1085#1072 +
        ' '#1059#1055#1040#1050'> '
      Hint = 
        #1055#1077#1088#1077#1085#1086#1089#1103#1090#1089#1103' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. - '#1053#1045' '#1091#1087#1072#1082#1086#1074#1072#1085#1085#1099#1081'> '#1074' <***'#1054#1089#1090'. '#1085#1072 +
        ' '#1059#1055#1040#1050'> '
    end
    object actUpdateAmountNext_to: TdsdExecStoredProc
      Category = 'DSNext'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAmountNext_to
      StoredProcList = <
        item
          StoredProc = spUpdateAmountNext_to
        end>
      Caption = 'actUpdateAmountNext_to'
      Hint = 'actUpdateAmountNext_to'
    end
    object mactUpdateAmount_to: TMultiAction
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateAmountAll_to
        end
        item
          Action = mactUpdateAmountGrid_to
        end
        item
          Action = actRefreshPrice
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. - '#1053#1045' '#1091#1087#1072#1082#1086#1074#1072#1085#1085#1099#1081'> ?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1083#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. - '#1053#1045' '#1091#1087#1072#1082#1086#1074#1072#1085#1085#1099#1081'>'
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. - '#1053#1045' '#1091#1087#1072#1082#1086#1074#1072#1085#1085#1099#1081'>'
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. - '#1053#1045' '#1091#1087#1072#1082#1086#1074#1072#1085#1085#1099#1081'>'
      ImageIndex = 68
    end
    object mactUpdateAmountGrid_to: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateAmount_to
        end>
      View = cxGridDBTableView
      Caption = 
        #1055#1077#1088#1077#1085#1086#1089#1103#1090#1089#1103' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. - '#1053#1045' '#1091#1087#1072#1082#1086#1074#1072#1085#1085#1099#1081'> '#1074' <***'#1054#1089#1090'. '#1085#1072 +
        ' '#1059#1055#1040#1050'> '
      Hint = 
        #1055#1077#1088#1077#1085#1086#1089#1103#1090#1089#1103' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. - '#1053#1045' '#1091#1087#1072#1082#1086#1074#1072#1085#1085#1099#1081'> '#1074' <***'#1054#1089#1090'. '#1085#1072 +
        ' '#1059#1055#1040#1050'> '
    end
    object actUpdateAmountNextAll_to: TdsdExecStoredProc
      Category = 'DSNext'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAmountNextAll_to
      StoredProcList = <
        item
          StoredProc = spUpdateAmountNextAll_to
        end>
      Caption = 'actUpdateAmountNextAll_to'
      Hint = 'actUpdateAmountNextAll_to'
    end
    object mactUpdateAmountNextSecond_to: TMultiAction
      Category = 'DSNext'
      TabSheet = tsMain
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateAmountNextSecondAll_to
        end
        item
          Action = mactUpdateAmountSecondGrid_to
        end
        item
          Action = actRefreshPrice
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. '#1087#1088'-'#1074#1086' ('#1057#1045#1043#1054#1044#1053#1071')> ?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1083#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. '#1087#1088'-'#1074#1086' ('#1057#1045#1043#1054#1044#1053#1071')>'
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. '#1087#1088'-'#1074#1086' ('#1057#1045#1043#1054#1044#1053#1071')>'
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. '#1087#1088'-'#1074#1086' ('#1057#1045#1043#1054#1044#1053#1071')>'
      ImageIndex = 73
    end
    object mactUpdateAmountNextSecondGrid_to: TMultiAction
      Category = 'DSNext'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateAmountNextSecond_to
        end>
      View = cxGridDBTableView
      Caption = 
        #1055#1077#1088#1077#1085#1086#1089#1103#1090#1089#1103' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. '#1087#1088'-'#1074#1086' ('#1057#1045#1043#1054#1044#1053#1071')> '#1074' <***'#1055#1083#1072#1085' '#1055#1056'-' +
        #1042#1054' '#1085#1072' '#1059#1055#1040#1050'> '
      Hint = 
        #1055#1077#1088#1077#1085#1086#1089#1103#1090#1089#1103' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. '#1087#1088'-'#1074#1086' ('#1057#1045#1043#1054#1044#1053#1071')> '#1074' <***'#1055#1083#1072#1085' '#1055#1056'-' +
        #1042#1054' '#1085#1072' '#1059#1055#1040#1050'> '
    end
    object actUpdateAmountNextSecond_to: TdsdExecStoredProc
      Category = 'DSNext'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAmountNextSecond_to
      StoredProcList = <
        item
          StoredProc = spUpdateAmountNextSecond_to
        end>
      Caption = 'actUpdateAmountSecond_to'
      Hint = 'actUpdateAmountNextSecond_to'
    end
    object actUpdateAmountNextSecondAll_to: TdsdExecStoredProc
      Category = 'DSNext'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAmountNextSecond_to
      StoredProcList = <
        item
          StoredProc = spUpdateAmountNextSecond_to
        end>
      Caption = 'actUpdateAmountSecondAll_to'
      Hint = 'actUpdateAmountNextSecondAll_to'
    end
    object mactUpdateAmountNextSecondCEH_to: TMultiAction
      Category = 'DSNext'
      TabSheet = tsMain
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateAmountNextSecondAll_to
        end
        item
          Action = mactUpdateAmountNextSecondCEHGrid_to
        end
        item
          Action = actRefreshPrice
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1055#1088#1080#1093#1086#1076' '#1087#1088'-'#1074#1086' ('#1060#1040#1050#1058')> ?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1083#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1055#1088#1080#1093#1086#1076' '#1087#1088'-'#1074#1086' ('#1060#1040#1050#1058')>'
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1055#1088#1080#1093#1086#1076' '#1087#1088'-'#1074#1086' ('#1060#1040#1050#1058')>'
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1055#1088#1080#1093#1086#1076' '#1087#1088'-'#1074#1086' ('#1060#1040#1050#1058')>'
      ImageIndex = 73
    end
    object mactUpdateAmountNextSecondCEHGrid_to: TMultiAction
      Category = 'DSNext'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateAmountNextSecondCEH_to
        end>
      View = cxGridDBTableView
      Caption = 
        #1055#1077#1088#1077#1085#1086#1089#1103#1090#1089#1103' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1055#1088#1080#1093#1086#1076' '#1087#1088'-'#1074#1086' ('#1060#1040#1050#1058')> '#1074' <***'#1055#1083#1072#1085' '#1055#1056'-'#1042#1054' '#1085#1072' ' +
        #1059#1055#1040#1050'> '
      Hint = 
        #1055#1077#1088#1077#1085#1086#1089#1103#1090#1089#1103' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1055#1088#1080#1093#1086#1076' '#1087#1088'-'#1074#1086' ('#1060#1040#1050#1058')> '#1074' <***'#1055#1083#1072#1085' '#1055#1056'-'#1042#1054' '#1085#1072' ' +
        #1059#1055#1040#1050'> '
    end
    object actUpdateAmountNextSecondCEH_to: TdsdExecStoredProc
      Category = 'DSNext'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAmountNextSecondCEH_to
      StoredProcList = <
        item
          StoredProc = spUpdateAmountNextSecondCEH_to
        end>
      Caption = 'actUpdateAmountSecond_to'
      Hint = 'actUpdateAmountNextSecond_to'
    end
    object actUpdateAmount_to: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAmount_to
      StoredProcList = <
        item
          StoredProc = spUpdateAmount_to
        end>
      Caption = 'actUpdateAmount_to'
      Hint = 'actUpdateAmount_to'
    end
    object actUpdateAmountAll_to: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAmountAll_to
      StoredProcList = <
        item
          StoredProc = spUpdateAmountAll_to
        end>
      Caption = 'actUpdateAmountAll_to'
      Hint = 'actUpdateAmountAll_to'
    end
    object mactUpdateAmountSecond_to: TMultiAction
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateAmountSecondAll_to
        end
        item
          Action = mactUpdateAmountSecondGrid_to
        end
        item
          Action = actRefreshPrice
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. '#1087#1088'-'#1074#1086' ('#1057#1045#1043#1054#1044#1053#1071')> ?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1083#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. '#1087#1088'-'#1074#1086' ('#1057#1045#1043#1054#1044#1053#1071')>'
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. '#1087#1088'-'#1074#1086' ('#1057#1045#1043#1054#1044#1053#1071')>'
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. '#1087#1088'-'#1074#1086' ('#1057#1045#1043#1054#1044#1053#1071')>'
      ImageIndex = 69
    end
    object mactUpdateAmountSecondGrid_to: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateAmountSecond_to
        end>
      View = cxGridDBTableView
      Caption = 
        #1055#1077#1088#1077#1085#1086#1089#1103#1090#1089#1103' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. '#1087#1088'-'#1074#1086' ('#1057#1045#1043#1054#1044#1053#1071')> '#1074' <***'#1055#1083#1072#1085' '#1055#1056'-' +
        #1042#1054' '#1085#1072' '#1059#1055#1040#1050'> '
      Hint = 
        #1055#1077#1088#1077#1085#1086#1089#1103#1090#1089#1103' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1054#1089#1090'. '#1085#1072#1095'. '#1087#1088'-'#1074#1086' ('#1057#1045#1043#1054#1044#1053#1071')> '#1074' <***'#1055#1083#1072#1085' '#1055#1056'-' +
        #1042#1054' '#1085#1072' '#1059#1055#1040#1050'> '
    end
    object actUpdateAmountSecond_to: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAmountSecond_to
      StoredProcList = <
        item
          StoredProc = spUpdateAmountSecond_to
        end>
      Caption = 'actUpdateAmountSecond_to'
      Hint = 'actUpdateAmountSecond_to'
    end
    object actUpdateAmountSecondAll_to: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAmountSecond_to
      StoredProcList = <
        item
          StoredProc = spUpdateAmountSecond_to
        end>
      Caption = 'actUpdateAmountSecondAll_to'
      Hint = 'actUpdateAmountSecondAll_to'
    end
    object mactUpdateAmountSecondCEH_to: TMultiAction
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateAmountSecondAll_to
        end
        item
          Action = mactUpdateAmountSecondCEHGrid_to
        end
        item
          Action = actRefreshPrice
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1055#1088#1080#1093#1086#1076' '#1087#1088'-'#1074#1086' ('#1060#1040#1050#1058')> ?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1083#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1055#1088#1080#1093#1086#1076' '#1087#1088'-'#1074#1086' ('#1060#1040#1050#1058')>'
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1055#1088#1080#1093#1086#1076' '#1087#1088'-'#1074#1086' ('#1060#1040#1050#1058')>'
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1055#1088#1080#1093#1086#1076' '#1087#1088'-'#1074#1086' ('#1060#1040#1050#1058')>'
      ImageIndex = 70
    end
    object mactUpdateAmountSecondCEHGrid_to: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateAmountSecondCEH_to
        end>
      View = cxGridDBTableView
      Caption = 
        #1055#1077#1088#1077#1085#1086#1089#1103#1090#1089#1103' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1055#1088#1080#1093#1086#1076' '#1087#1088'-'#1074#1086' ('#1060#1040#1050#1058')> '#1074' <***'#1055#1083#1072#1085' '#1055#1056'-'#1042#1054' '#1085#1072' ' +
        #1059#1055#1040#1050'> '
      Hint = 
        #1055#1077#1088#1077#1085#1086#1089#1103#1090#1089#1103' '#1076#1072#1085#1085#1099#1077' '#1080#1079' <'#1055#1088#1080#1093#1086#1076' '#1087#1088'-'#1074#1086' ('#1060#1040#1050#1058')> '#1074' <***'#1055#1083#1072#1085' '#1055#1056'-'#1042#1054' '#1085#1072' ' +
        #1059#1055#1040#1050'> '
    end
    object actUpdateAmountSecondCEH_to: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAmountSecondCEH_to
      StoredProcList = <
        item
          StoredProc = spUpdateAmountSecondCEH_to
        end>
      Caption = 'actUpdateAmountSecond_to'
      Hint = 'actUpdateAmountSecond_to'
    end
    object actUpdateAmount_toPACK: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAmount_toPACK
      StoredProcList = <
        item
          StoredProc = spUpdateAmount_toPACK
        end>
      Caption = #1056#1072#1089#1095#1077#1090' <'#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1089' '#1054#1089#1090'. '#1092#1072#1082#1090')>'
      Hint = #1056#1072#1089#1095#1077#1090' <'#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1089' '#1054#1089#1090'. '#1092#1072#1082#1090')>'
      ImageIndex = 76
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' <'#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1089' '#1054#1089#1090'. '#1092#1072#1082#1090')> ?'
      InfoAfterExecute = #1057#1076#1077#1083#1072#1083#1080' '#1055#1051#1040#1053' '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1089' '#1054#1089#1090'. '#1092#1072#1082#1090'). '#1052#1086#1078#1085#1086' '#1055#1077#1095#1072#1090#1072#1090#1100
    end
    object actUpdateAmountSecond_toPACK: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAmountSecond_toPACK
      StoredProcList = <
        item
          StoredProc = spUpdateAmountSecond_toPACK
        end>
      Caption = #1056#1072#1089#1095#1077#1090' <'#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1089' '#1062#1077#1093#1072' '#1092#1072#1082#1090')>'
      Hint = #1056#1072#1089#1095#1077#1090' <'#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1089' '#1062#1077#1093#1072' '#1092#1072#1082#1090')>'
      ImageIndex = 77
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' <'#1079#1072#1082#1072#1079' '#1085#1072' '#1059#1055#1040#1050' ('#1089' '#1062#1077#1093#1072' '#1092#1072#1082#1090')> ?'
      InfoAfterExecute = #1057#1076#1077#1083#1072#1083#1080' '#1055#1051#1040#1053' '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080' ('#1089' '#1062#1077#1093#1072' '#1092#1072#1082#1090'). '#1052#1086#1078#1085#1086' '#1055#1077#1095#1072#1090#1072#1090#1100
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
    StoredProcName = 'gpSelect_MI_OrderInternalPackRemains'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = ChildCDS
      end
      item
        DataSet = ChildTotalCDS
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
          ItemName = 'bbPrintRemains'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateAmount_to'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateAmountSecond_to'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbtUpdateAmountSecondCEH_to'
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
          ItemName = 'bbUpdateAmountNext_to'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateAmountNextSecond_to'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateAmountNextSecondCEH_to'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateAmount_toPACK'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateAmountSecond_toPACK'
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
        end
        item
          Visible = True
          ItemName = 'bbGridTotalToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    object bbPrintRemains: TdxBarButton [5]
      Action = actPrintRemains
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
    object bbUpdateAmount_to: TdxBarButton
      Action = mactUpdateAmount_to
      Category = 0
    end
    object bbUpdateAmountSecond_to: TdxBarButton
      Action = mactUpdateAmountSecond_to
      Category = 0
    end
    object bbtUpdateAmountSecondCEH_to: TdxBarButton
      Action = mactUpdateAmountSecondCEH_to
      Category = 0
    end
    object bbUpdateAmount_toPACK: TdxBarButton
      Action = actUpdateAmount_toPACK
      Category = 0
    end
    object bbUpdateAmountSecond_toPACK: TdxBarButton
      Action = actUpdateAmountSecond_toPACK
      Category = 0
    end
    object bbGridTotalToExcel: TdxBarButton
      Action = actGridTotalToExcel
      Category = 0
    end
    object bbUpdateAmountNext_to: TdxBarButton
      Action = mactUpdateAmountNext_to
      Category = 0
    end
    object bbUpdateAmountNextSecond_to: TdxBarButton
      Action = mactUpdateAmountNextSecond_to
      Category = 0
    end
    object bbUpdateAmountNextSecondCEH_to: TdxBarButton
      Action = mactUpdateAmountNextSecondCEH_to
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
        DataSummaryItemIndex = 5
      end>
    Left = 846
    Top = 353
  end
  inherited PopupMenu: TPopupMenu
    Left = 736
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
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 264
    Top = 321
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
        Value = True
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
    Left = 912
    Top = 320
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderInternal_SetErased'
    Left = 390
    Top = 344
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderInternal_SetUnErased'
    Left = 734
    Top = 368
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
        Value = '0'
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
        Value = '0'
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
        Value = '0'
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
    Left = 320
    Top = 224
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
    StoredProcName = 'gpSelect_Movement_OrderInternal_Print'
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
    Left = 375
    Top = 456
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
    StoredProcName = 'gpUpdateMI_OrderInternal_AmountRemainsPack'
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
      end>
    PackSize = 1
    Left = 738
    Top = 256
  end
  object spUpdateAmountPartner: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderInternal_AmountPartnerPromo'
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
      end>
    PackSize = 1
    Left = 736
    Top = 296
  end
  object spUpdateAmountForecast: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderInternal_AmountForecastPromo'
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
      end>
    PackSize = 1
    Left = 864
    Top = 288
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'KeyId'
    MasterFields = 'KeyId'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 152
    Top = 569
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 244
    Top = 570
  end
  object ChildDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewChild
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 358
    Top = 569
  end
  object ChildTotalCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 504
    Top = 585
  end
  object ChildTotalDS: TDataSource
    DataSet = ChildTotalCDS
    Left = 596
    Top = 586
  end
  object ChildTotalDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewChildTotal
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 654
    Top = 553
  end
  object spUpdateMIMasterChildTotal: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_OrderInternal'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ChildTotalCDS
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
        Component = ChildTotalCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCuterCount'
        Value = 0
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmount'
        Value = Null
        Component = ChildTotalCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCuterCountSecond'
        Value = '0'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountSecond'
        Value = Null
        Component = ChildTotalCDS
        ComponentItem = 'AmountSecond'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = ChildTotalCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptId_basis'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPack'
        Value = True
        Component = FormParams
        ComponentItem = 'isPack'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 312
    Top = 400
  end
  object spUpdateAmount_to: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderInternal_Amount_to'
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
        Name = 'inId'
        Value = 42132d
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Remains'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsClear'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 586
    Top = 280
  end
  object spUpdateAmountAll_to: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderInternal_Amount_to'
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
        Name = 'inId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = '0'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsClear'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 554
    Top = 208
  end
  object spUpdateAmountSecond_to: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderInternal_AmountSecond_to'
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
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Remains_CEH'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsClear'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 602
    Top = 272
  end
  object spUpdateAmountSecondAll_to: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderInternal_AmountSecond_to'
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
        Name = 'inId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = '0'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsClear'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 674
    Top = 224
  end
  object spUpdateAmountSecondCEH_to: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderInternal_AmountSecond_to'
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
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Income_CEH'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsClear'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 690
    Top = 312
  end
  object spUpdateAmountSecond_toPACK: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderInternal_Amount_toPACK'
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
        Name = 'inId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumber'
        Value = 100
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsClear'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPack'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPackSecond'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 522
    Top = 384
  end
  object spUpdateAmount_toPACK: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderInternal_Amount_toPACK'
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
        Name = 'inId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumber'
        Value = '100'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsClear'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPack'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPackSecond'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 298
    Top = 368
  end
  object spSelectPrintRemains: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderInternalPackRemains_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
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
    Left = 887
    Top = 488
  end
  object spUpdateMI_Amounts: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderInternal_Amounts'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ChildTotalCDS
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
        Name = 'inAmount'
        Value = Null
        Component = ChildTotalCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountSecond'
        Value = Null
        Component = ChildTotalCDS
        ComponentItem = 'AmountSecond'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPack'
        Value = Null
        Component = ChildTotalCDS
        ComponentItem = 'AmountPack'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPackSecond'
        Value = '0'
        Component = ChildTotalCDS
        ComponentItem = 'AmountPackSecond'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 88
    Top = 496
  end
  object spUpdateMI_AmountPack: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderInternal_AmountPack'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = ChildCDS
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
        Name = 'inAmountPack'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountPack'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPackSecond'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountPackSecond'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPackNext'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountPackNext'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPackNextSecond'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountPackNextSecond'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 216
    Top = 504
  end
  object spUpdateMI_master: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderInternal_AmountPack_master'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
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
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountSecond'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountSecond'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountNext'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'AmountNext'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountNextSecond'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountNextSecond'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountTotal'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'AmountTotal'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountNextTotal'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'AmountNextTotal'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 200
    Top = 440
  end
  object spUpdateAmountNext_to: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderInternal_AmountNext_to'
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
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountNext'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Remains'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsClear'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 362
    Top = 512
  end
  object spUpdateAmountNextSecond_to: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderInternal_AmountNextSecond_to'
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
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Remains_CEH'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsClear'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 458
    Top = 496
  end
  object spUpdateAmountNextSecondCEH_to: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderInternal_AmountNextSecond_to'
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
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Income_CEH'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsClear'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 570
    Top = 496
  end
  object spUpdateAmountNextAll_to: TdsdStoredProc
    StoredProcName = 'gpUpdateMI_OrderInternal_AmountNext_to'
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
        Name = 'inId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = '0'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsClear'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 698
    Top = 512
  end
end
