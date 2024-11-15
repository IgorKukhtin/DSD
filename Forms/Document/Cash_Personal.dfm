inherited Cash_PersonalForm: TCash_PersonalForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1050#1072#1089#1089#1072', '#1074#1099#1087#1083#1072#1090#1072' '#1087#1086' '#1074#1077#1076#1086#1084#1086#1089#1090#1080'>'
  ClientHeight = 507
  ClientWidth = 982
  AddOnFormData.isSingle = True
  ExplicitWidth = 998
  ExplicitHeight = 546
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 115
    Width = 982
    Height = 392
    ExplicitTop = 115
    ExplicitWidth = 982
    ExplicitHeight = 392
    ClientRectBottom = 392
    ClientRectRight = 982
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 982
      ExplicitHeight = 368
      inherited cxGrid: TcxGrid
        Width = 982
        Height = 368
        ExplicitWidth = 982
        ExplicitHeight = 368
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount_avance
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummToPay_cash
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = SummRemains
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummService
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummToPay
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCard
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount_service
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummMinus
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummAdd
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummSocialIn
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummSocialAdd
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummChild
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummTransportAdd
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummTransport
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummPhone
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummTransportAddLong
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummTransportTaxi
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummHoliday
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummNalog
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCardSecond
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummMinusExt
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCardSecondCash
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCardSecondRemains
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummFine
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummHosp
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount_avance_ret
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCompensation
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummAvance
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummAvCardSecond
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountCardSecond_avance
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCardSecond_all_005
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCardSecond_diff_005
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCardSecond_all_00807
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCardSecond_diff_00807
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountService_diff
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount_avance
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummToPay_cash
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = SummRemains
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummService
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummToPay
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCard
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount_service
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummMinus
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummAdd
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummSocialIn
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummSocialAdd
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummChild
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummTransportAdd
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummTransport
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummPhone
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummTransportAddLong
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummTransportTaxi
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummHoliday
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummNalog
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCardSecond
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummMinusExt
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCardSecondCash
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCardSecondRemains
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummFine
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummHosp
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount_avance_ret
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCompensation
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummAvance
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummAvCardSecond
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountCardSecond_avance
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCardSecond_all_005
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCardSecond_diff_005
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCardSecond_all_00807
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummCardSecond_diff_00807
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = PersonalName
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = AmountService_diff
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
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object INN: TcxGridDBColumn [2]
            Caption = #1048#1053#1053
            DataBinding.FieldName = 'INN'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PersonalCode: TcxGridDBColumn [3]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'PersonalCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PersonalName: TcxGridDBColumn [4]
            Caption = #1060#1048#1054' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object PositionName: TcxGridDBColumn [5]
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Caption = 'GoodsKindForm'
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PositionLevelName: TcxGridDBColumn [6]
            Caption = #1056#1072#1079#1088#1103#1076' '#1076#1086#1083#1078#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'PositionLevelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object isMain: TcxGridDBColumn [7]
            Caption = #1054#1089#1085#1086#1074'. '#1084#1077#1089#1090#1086' '#1088'.'
            DataBinding.FieldName = 'isMain'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object isOfficial: TcxGridDBColumn [8]
            Caption = #1054#1092#1086#1088#1084#1083'. '#1086#1092#1080#1094'.'
            DataBinding.FieldName = 'isOfficial'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object SummService: TcxGridDBColumn [9]
            Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'SummService'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object SummToPay: TcxGridDBColumn [10]
            Caption = #1050' '#1074#1099#1087#1083#1072#1090#1077' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'SummToPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummCard: TcxGridDBColumn [11]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' - 1'#1092'.'
            DataBinding.FieldName = 'SummCard'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummCardSecond: TcxGridDBColumn [12]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' - 2'#1092'. '
            DataBinding.FieldName = 'SummCardSecond'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummAvCardSecond: TcxGridDBColumn [13]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' - 2'#1092'. '#1040#1074#1072#1085#1089
            DataBinding.FieldName = 'SummAvCardSecond'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummCardSecondCash: TcxGridDBColumn [14]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1072#1089#1089#1072')- 2'#1092'. '
            DataBinding.FieldName = 'SummCardSecondCash'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummCardSecond_all_005: TcxGridDBColumn [15]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1086#1101#1092'. 0.5%) - 2'#1092'.'
            DataBinding.FieldName = 'SummCardSecond_all_005'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object SummCardSecond_diff_005: TcxGridDBColumn [16]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1088#1072#1079#1085'. 0.5%) - 2'#1092'.'
            DataBinding.FieldName = 'SummCardSecond_diff_005'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object SummCardSecond_all_00807: TcxGridDBColumn [17]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1086#1101#1092'. 0.8%) - 2'#1092'.'
            DataBinding.FieldName = 'SummCardSecond_all_00807'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummCardSecond_diff_00807: TcxGridDBColumn [18]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1088#1072#1079#1085'. 0.8%) - 2'#1092'.'
            DataBinding.FieldName = 'SummCardSecond_diff_00807'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummNalog: TcxGridDBColumn [19]
            Caption = #1053#1072#1083#1086#1075#1080' - '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1089' '#1047#1055
            DataBinding.FieldName = 'SummNalog'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummChild: TcxGridDBColumn [20]
            Caption = #1040#1083#1080#1084#1077#1085#1090#1099' - '#1091#1076#1077#1088#1078#1072#1085#1080#1077
            DataBinding.FieldName = 'SummChild'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SummMinusExt: TcxGridDBColumn [21]
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103' '#1089#1090#1086#1088#1086#1085'. '#1102#1088'.'#1083'.'
            DataBinding.FieldName = 'SummMinusExt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SummToPay_cash: TcxGridDBColumn [22]
            Caption = #1050' '#1074#1099#1087#1083#1072#1090#1077' ('#1080#1079' '#1082#1072#1089#1089#1099')'
            DataBinding.FieldName = 'SummToPay_cash'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Amount_avance: TcxGridDBColumn [23]
            Caption = #1040#1074#1072#1085#1089' ('#1074#1099#1087#1083#1072#1095#1077#1085#1086')'
            DataBinding.FieldName = 'Amount_avance'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1089' '#1087#1083#1102#1089#1086#1084
            Options.Editing = False
            Width = 80
          end
          object Amount_avance_ret: TcxGridDBColumn [24]
            Caption = #1040#1074#1072#1085#1089' ('#1074#1086#1079#1074#1088#1072#1090')'
            DataBinding.FieldName = 'Amount_avance_ret'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1089' '#1084#1080#1085#1091#1089#1086#1084
          end
          object Amount_service: TcxGridDBColumn [25]
            Caption = #1044#1088#1091#1075#1080#1077' ('#1074#1099#1087#1083#1072#1095#1077#1085#1086')'
            DataBinding.FieldName = 'Amount_service'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountCardSecond_avance: TcxGridDBColumn [26]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' - 2'#1092'.  ('#1074#1099#1087#1083#1072#1095#1077#1085#1086')'
            DataBinding.FieldName = 'AmountCardSecond_avance'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Amount: TcxGridDBColumn [27]
            Caption = #1042#1099#1087#1083#1072#1090#1072' '#1092#1072#1082#1090
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object isCalculated: TcxGridDBColumn [28]
            Caption = #1076#1083#1103' '#1050#1072#1088#1090#1072' '#1041#1053' 2'#1092'.'
            DataBinding.FieldName = 'isCalculated'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountService_diff: TcxGridDBColumn [29]
            Caption = '***'#1054#1082#1088#1091#1075#1083#1077#1085#1080#1077' - 2'#1092
            DataBinding.FieldName = 'AmountService_diff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1072#1088#1090#1072' '#1041#1053' ('#1086#1082#1088#1091#1075#1083#1077#1085#1080#1077') - 2'#1092
            Options.Editing = False
            Width = 70
          end
          object SummRemains: TcxGridDBColumn [30]
            Caption = #1054#1089#1090'. '#1082' '#1074#1099#1087#1083'. '#1080#1079' '#1082#1072#1089#1089#1099
            DataBinding.FieldName = 'SummRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummCardSecondRemains: TcxGridDBColumn [31]
            Caption = #1054#1089#1090'. '#1082' '#1074#1099#1087#1083'. '#1050#1072#1088#1090#1072' '#1041#1053' 2'#1092'. '
            DataBinding.FieldName = 'SummCardSecondRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object SummMinus: TcxGridDBColumn [32]
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103
            DataBinding.FieldName = 'SummMinus'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummFine: TcxGridDBColumn [33]
            Caption = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072
            DataBinding.FieldName = 'SummFine'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SummAdd: TcxGridDBColumn [34]
            Caption = #1055#1088#1077#1084#1080#1103
            DataBinding.FieldName = 'SummAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummHoliday: TcxGridDBColumn [35]
            Caption = #1054#1090#1087#1091#1089#1082#1085#1099#1077
            DataBinding.FieldName = 'SummHoliday'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummCompensation: TcxGridDBColumn [36]
            Caption = #1057#1091#1084#1084#1072' '#1082#1086#1084#1087'. '#1079#1072' '#1085#1077#1080#1089#1087'. '#1086#1090#1087'.'
            DataBinding.FieldName = 'SummCompensation'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080' '#1079#1072' '#1085#1077#1080#1089#1087'.'#1086#1090#1087#1091#1089#1082
            Options.Editing = False
            Width = 75
          end
          object SummHosp: TcxGridDBColumn [37]
            Caption = #1057#1091#1084#1084#1072' '#1073#1086#1083#1100#1085#1080#1095#1085#1086#1075#1086
            DataBinding.FieldName = 'SummHosp'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object SummTransport: TcxGridDBColumn [38]
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103' '#1043#1057#1052
            DataBinding.FieldName = 'SummTransport'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SummAvance: TcxGridDBColumn [39]
            Caption = #1040#1074#1072#1085#1089' ('#1074#1077#1076#1086#1084#1086#1089#1090#1100')'
            DataBinding.FieldName = 'SummAvance'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object SummPhone: TcxGridDBColumn [40]
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103' '#1052#1086#1073'.'#1089#1074#1103#1079#1100
            DataBinding.FieldName = 'SummPhone'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SummTransportAdd: TcxGridDBColumn [41]
            Caption = #1050#1086#1084#1072#1085#1076#1080#1088#1086#1074#1086#1095#1085#1099#1077' ('#1076#1086#1087#1083#1072#1090#1072', '#1090#1088#1072#1085#1089#1087')'
            DataBinding.FieldName = 'SummTransportAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object SummTransportAddLong: TcxGridDBColumn [42]
            Caption = #1044#1072#1083#1100#1085#1086#1073#1086#1081#1085#1099#1077' ('#1076#1086#1087#1083#1072#1090#1072', '#1090#1088#1072#1085#1089#1087')'
            DataBinding.FieldName = 'SummTransportAddLong'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object SummTransportTaxi: TcxGridDBColumn [43]
            Caption = #1058#1072#1082#1089#1080' ('#1076#1086#1087#1083#1072#1090#1072', '#1090#1088#1072#1085#1089#1087')'
            DataBinding.FieldName = 'SummTransportTaxi'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object SummSocialIn: TcxGridDBColumn [44]
            Caption = #1057#1086#1094'.'#1074#1099#1087#1083'. ('#1080#1079' '#1079#1087')'
            DataBinding.FieldName = 'SummSocialIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummSocialAdd: TcxGridDBColumn [45]
            Caption = #1057#1086#1094'.'#1074#1099#1087#1083'. ('#1076#1086#1087'. '#1082' '#1079#1087')'
            DataBinding.FieldName = 'SummSocialAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Comment: TcxGridDBColumn [46]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object InfoMoneyCode: TcxGridDBColumn [47]
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InfoMoneyName: TcxGridDBColumn [48]
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object InfoMoneyName_all: TcxGridDBColumn [49]
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'InfoMoneyName_all'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object MoneyPlaceName: TcxGridDBColumn
            Caption = '*** '#1042#1077#1076#1086#1084#1086#1089#1090#1100'('#1082#1072#1089#1089#1072')'
            DataBinding.FieldName = 'MoneyPlaceName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1086#1074#1077#1088#1082#1072
            Options.Editing = False
            Width = 70
          end
          object ServiceDate_mp: TcxGridDBColumn
            Caption = '*** '#1052#1077#1089#1103#1094' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081' ('#1082#1072#1089#1089#1072')'
            DataBinding.FieldName = 'ServiceDate_mp'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'mmmm yyyy'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1086#1074#1077#1088#1082#1072
            Options.Editing = False
            Width = 70
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 982
    Height = 89
    TabOrder = 3
    ExplicitWidth = 982
    ExplicitHeight = 89
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
      ExplicitWidth = 75
      Width = 75
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 100
      EditValue = 42099d
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 100
    end
    inherited cxLabel2: TcxLabel
      Left = 100
      ExplicitLeft = 100
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 63
      ExplicitTop = 63
      ExplicitWidth = 192
      ExplicitHeight = 22
      Width = 192
    end
    object edServiceDate: TcxDateEdit
      Left = 217
      Top = 63
      EditValue = 41640d
      Properties.DisplayFormat = 'mmmm yyyy'
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 6
      Width = 97
    end
    object cxLabel6: TcxLabel
      Left = 217
      Top = 45
      Caption = #1052#1077#1089#1103#1094' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081
    end
    object edComment: TcxTextEdit
      Left = 625
      Top = 63
      TabOrder = 8
      Width = 232
    end
    object cxLabel12: TcxLabel
      Left = 625
      Top = 45
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '
    end
    object edPersonalServiceList: TcxButtonEdit
      Left = 215
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 240
    end
    object cxLabel3: TcxLabel
      Left = 217
      Top = 5
      Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100':'
    end
    object cxLabel4: TcxLabel
      Left = 320
      Top = 45
      Caption = #8470' '#1076#1086#1082'. ('#1074#1077#1076#1086#1084#1086#1089#1090#1100')'
    end
    object edCash: TcxButtonEdit
      Left = 470
      Top = 23
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 140
    end
    object cxLabel9: TcxLabel
      Left = 625
      Top = 5
      Caption = #1060#1048#1054' ('#1095#1077#1088#1077#1079' '#1082#1086#1075#1086')'
    end
    object edMember: TcxButtonEdit
      Left = 625
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 232
    end
    object cxLabel7: TcxLabel
      Left = 470
      Top = 45
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object ceInfoMoney: TcxButtonEdit
      Left = 470
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 17
      Width = 140
    end
  end
  object edDocumentPersonalService: TcxButtonEdit [2]
    Left = 320
    Top = 63
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 137
  end
  object cxLabel5: TcxLabel [3]
    Left = 470
    Top = 5
    Caption = #1050#1072#1089#1089#1072':'
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 171
    Top = 512
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 400
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    object mactListCardSecondCash: TMultiAction [0]
      Category = 'actAllGrid'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      ActionList = <
        item
          Action = actGetMICardSecondCash
        end>
      View = cxGridDBTableView
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1054#1089#1090#1072#1090#1086#1082' '#1082' '#1074#1099#1087#1083#1072#1090#1077'>'
    end
    object actGetMICardSecondCash: TdsdExecStoredProc [1]
      Category = 'actAllGrid'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetMICardSecondCash
      StoredProcList = <
        item
          StoredProc = spGetMICardSecondCash
        end>
      Caption = 'actGetMIAmount'
    end
    object mactInsertUpdateMICardSecondCash_AllGrid: TMultiAction [2]
      Category = 'actAllGrid'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      ActionList = <
        item
          Action = mactListCardSecondCash
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1072#1089#1089#1072')- 2'#1092'.  '#1082' '#1074#1099#1087#1083#1072 +
        #1090#1077'> ?'
      InfoAfterExecute = '<'#1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1072#1089#1089#1072')- 2'#1092'. '#1082' '#1074#1099#1087#1083#1072#1090#1077'> '#1087#1077#1088#1077#1085#1077#1089#1083#1080' '#1091#1089#1087#1077#1096#1085#1086'.'
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1072#1089#1089#1072')- 2'#1092'.  '#1082' '#1074#1099#1087#1083#1072#1090#1077'>'
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1072#1089#1089#1072')- 2'#1092'.  '#1082' '#1074#1099#1087#1083#1072#1090#1077'>'
      ImageIndex = 74
    end
    object mactList: TMultiAction [3]
      Category = 'actAllGrid'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      ActionList = <
        item
          Action = actGetMIAmount
        end>
      View = cxGridDBTableView
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1054#1089#1090#1072#1090#1086#1082' '#1082' '#1074#1099#1087#1083#1072#1090#1077'>'
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end>
      RefreshOnTabSetChanges = True
    end
    inherited actMISetErased: TdsdUpdateErased
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end>
    end
    inherited actMISetUnErased: TdsdUpdateErased
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end>
    end
    inherited actShowErased: TBooleanStoredProcAction
      TabSheet = tsMain
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end>
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1074#1099#1087#1083#1072#1090#1099' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
      Hint = #1055#1077#1095#1072#1090#1100' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1074#1099#1087#1083#1072#1090#1099' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
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
      ReportName = 'PrintMovement_PersonalService'
      ReportNameParam.Name = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081
      ReportNameParam.Value = 'PrintMovement_PersonalService'
      ReportNameParam.ParamType = ptInput
    end
    inherited MovementItemProtocolOpenForm: TdsdOpenForm
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    inherited actAddMask: TdsdExecStoredProc
      Enabled = False
    end
    object actRefreshMaster: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = 'actRefreshMaster'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object mactInsertUpdateMIAmount_AllGrid: TMultiAction
      Category = 'actAllGrid'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      ActionList = <
        item
          Action = mactList
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1054#1089#1090#1072#1090#1086#1082' '#1082' '#1074#1099#1087#1083#1072#1090#1077'> ?'
      InfoAfterExecute = '<'#1054#1089#1090#1072#1090#1086#1082' '#1082' '#1074#1099#1087#1083#1072#1090#1077'> '#1087#1077#1088#1077#1085#1077#1089#1083#1080' '#1091#1089#1087#1077#1096#1085#1086'.'
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1054#1089#1090#1072#1090#1086#1082' '#1082' '#1074#1099#1087#1083#1072#1090#1077'>'
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1054#1089#1090#1072#1090#1086#1082' '#1082' '#1074#1099#1087#1083#1072#1090#1077'>'
      ImageIndex = 50
    end
    object actInsertUpdateMIAmount_One: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetMIAmount
      StoredProcList = <
        item
          StoredProc = spGetMIAmount
        end>
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1054#1044#1053#1054#1043#1054' <'#1054#1089#1090#1072#1090#1086#1082' '#1082' '#1074#1099#1087#1083#1072#1090#1077'>'
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1054#1044#1053#1054#1043#1054' <'#1054#1089#1090#1072#1090#1086#1082' '#1082' '#1074#1099#1087#1083#1072#1090#1077'>'
      ImageIndex = 47
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1054#1044#1053#1054#1043#1054' <'#1054#1089#1090#1072#1090#1086#1082' '#1082' '#1074#1099#1087#1083#1072#1090#1077'> ?'
    end
    object actGetMIAmount: TdsdExecStoredProc
      Category = 'actAllGrid'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetMIAmount
      StoredProcList = <
        item
          StoredProc = spGetMIAmount
        end>
      Caption = 'actGetMIAmount'
    end
    object actInsertUpdateMIAmount_All: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIAmount
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIAmount
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1054#1089#1090#1072#1090#1086#1082' '#1082' '#1074#1099#1087#1083#1072#1090#1077'>'
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1054#1089#1090#1072#1090#1086#1082' '#1082' '#1074#1099#1087#1083#1072#1090#1077'>'
      ImageIndex = 50
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1042#1057#1045#1061' <'#1054#1089#1090#1072#1090#1086#1082' '#1082' '#1074#1099#1087#1083#1072#1090#1077'> ?'
      InfoAfterExecute = '<'#1054#1089#1090#1072#1090#1086#1082' '#1082' '#1074#1099#1087#1083#1072#1090#1077'> '#1087#1077#1088#1077#1085#1077#1089#1083#1080' '#1091#1089#1087#1077#1096#1085#1086'.'
    end
    object actMasterPost: TDataSetPost
      Category = 'actAllGrid'
      Caption = 'actMasterPost'
      Hint = 'actMasterPost'
      DataSource = MasterDS
    end
    object mactInsertUpdateMIAmount_One: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      ActionList = <
        item
          Action = actGetMIAmount
        end
        item
          Action = actMasterPost
        end>
      QuestionBeforeExecute = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1054#1044#1053#1054#1043#1054' <'#1054#1089#1090#1072#1090#1086#1082' '#1082' '#1074#1099#1087#1083#1072#1090#1077'>'
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1054#1044#1053#1054#1043#1054' <'#1054#1089#1090#1072#1090#1086#1082' '#1082' '#1074#1099#1087#1083#1072#1090#1077'>'
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1083#1103' '#1054#1044#1053#1054#1043#1054' <'#1054#1089#1090#1072#1090#1086#1082' '#1082' '#1074#1099#1087#1083#1072#1090#1077'>'
      ImageIndex = 47
    end
    object actReport_Open: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1042#1099#1087#1083#1072#1090#1099' '#1092#1080#1079'.'#1083#1080#1094#1091'>'
      Hint = #1054#1090#1095#1077#1090' <'#1042#1099#1087#1083#1072#1090#1099' '#1092#1080#1079'.'#1083#1080#1094#1091'>'
      ImageIndex = 26
      FormName = 'TReport_CashPersonal_toPayForm'
      FormNameParam.Value = 'TReport_CashPersonal_toPayForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'ServiceDate'
          Value = 44927d
          Component = edServiceDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalName'
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
    StoredProcName = 'gpSelect_MovementItem_Cash_Personal'
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
        Name = 'inParentId'
        Value = 'NULL'
        Component = GuidesPersonalServiceJournal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementItemId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = FormParams
        ComponentItem = 'ShowAll'
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
    Left = 96
    Top = 256
  end
  inherited BarManager: TdxBarManager
    Left = 80
    Top = 207
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
          ItemName = 'bbReport_Open'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMIAmount_One'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMIAmount_All'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMICardSecondCash_AllGrid'
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
          ItemName = 'dxBarStatic'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    inherited bbAddMask: TdxBarButton
      Visible = ivNever
    end
    object bbInsertUpdateMIAmount_One: TdxBarButton
      Action = mactInsertUpdateMIAmount_One
      Category = 0
    end
    object bbInsertUpdateMIAmount_All: TdxBarButton
      Action = mactInsertUpdateMIAmount_AllGrid
      Category = 0
    end
    object bbInsertUpdateMICardSecondCash_AllGrid: TdxBarButton
      Action = mactInsertUpdateMICardSecondCash_AllGrid
      Category = 0
    end
    object bbReport_Open: TdxBarButton
      Action = actReport_Open
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
        Name = 'CashId_top'
        Value = Null
        Component = GuidesCash
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashName_top'
        Value = Null
        Component = GuidesCash
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 512
  end
  inherited StatusGuides: TdsdGuides
    Left = 88
    Top = 56
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Cash'
    Left = 160
    Top = 8
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Cash_Personal'
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
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCashId'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'CashId_top'
        ParamType = ptInput
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
        Name = 'ParentId'
        Value = 'NULL'
        Component = GuidesPersonalServiceJournal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParentName'
        Value = ''
        Component = GuidesPersonalServiceJournal
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceDate'
        Value = 41640d
        Component = edServiceDate
        DataType = ftDateTime
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
        Name = 'CashId'
        Value = ''
        Component = GuidesCash
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CashName'
        Value = ''
        Component = GuidesCash
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalServiceListId'
        Value = Null
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalServiceListName'
        Value = ''
        Component = GuidesPersonalServiceList
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 224
    Top = 264
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Cash_Personal'
    Params = <
      item
        Name = 'ioMovementId'
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
        Name = 'inParentId'
        Value = 'NULL'
        Component = GuidesPersonalServiceJournal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCashId'
        Value = ''
        Component = GuidesCash
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = ''
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId'
        Value = 'False'
        Component = GuidesMember
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesPersonalServiceList
      end
      item
        Guides = GuidesCash
      end>
    Left = 160
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
        Control = edPersonalServiceList
      end
      item
        Control = edServiceDate
      end
      item
        Control = edDocumentPersonalService
      end
      item
        Control = edCash
      end
      item
        Control = edMember
      end
      item
        Control = edComment
      end
      item
        Control = ceInfoMoney
      end>
    Left = 224
    Top = 217
  end
  inherited RefreshAddOn: TRefreshAddOn
    FormName = 'TCash_PersonalJournalForm'
    DataSet = 'MasterCDS'
    Left = 760
    Top = 264
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Cash_Personal_SetErased'
    Left = 646
    Top = 320
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Cash_Personal_SetUnErased'
    Left = 430
    Top = 336
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Cash_Personal'
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
        Name = 'inMovementId_Parent'
        Value = Null
        Component = GuidesPersonalServiceJournal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalId'
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
        Name = 'outSummRemains'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummRemains'
        DataType = ftFloat
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
      end
      item
        Name = 'inInfoMoneyId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InfoMoneyId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPositionId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PositionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsCalculated'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isCalculated'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 320
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = ''
    Left = 412
    Top = 228
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshMaster
    ComponentList = <
      item
        Component = GuidesPersonalServiceList
      end>
    Left = 536
    Top = 320
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 492
    Top = 233
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 572
    Top = 246
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PersonalService_Print'
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
        Component = GuidesPersonalServiceJournal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisShowAll'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 319
    Top = 208
  end
  object GuidesPersonalServiceList: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalServiceList
    isShowModal = True
    FormNameParam.Value = 'TPersonalServiceJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalServiceJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = 'NULL'
        Component = GuidesPersonalServiceJournal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalServiceJournal
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalServiceListId'
        Value = 0
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalServiceListName'
        Value = ''
        Component = GuidesPersonalServiceList
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceDate'
        Value = 41640d
        Component = edServiceDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TopPersonalServiceListId'
        Value = 0
        MultiSelectSeparator = ','
      end
      item
        Name = 'TopPersonalServiceListName'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 304
    Top = 13
  end
  object GuidesPersonalServiceJournal: TdsdGuides
    KeyField = 'Id'
    LookupControl = edDocumentPersonalService
    Key = '0'
    FormNameParam.Value = 'TPersonalServiceJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalServiceJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = 'NULL'
        Component = GuidesPersonalServiceJournal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalServiceJournal
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalServiceListId'
        Value = 0
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalServiceListName'
        Value = ''
        Component = GuidesPersonalServiceList
        ComponentItem = 'TextValue'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceDate'
        Value = 41640d
        Component = edServiceDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TopPersonalServiceListId'
        Value = 0
        MultiSelectSeparator = ','
      end
      item
        Name = 'TopPersonalServiceListName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 488
    Top = 48
  end
  object GuidesCash: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCash
    FormNameParam.Value = 'TCash_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCash_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCash
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCash
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 528
    Top = 65533
  end
  object GuidesMember: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember
    FormNameParam.Value = 'TMember_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 736
    Top = 65533
  end
  object spInsertUpdateMIAmount: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Cash_Personal_Amount'
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
        Name = 'inMovementId_Parent'
        Value = Null
        Component = GuidesPersonalServiceJournal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 290
    Top = 352
  end
  object spGetMIAmount: TdsdStoredProc
    StoredProcName = 'gpGet_MovementItem_Cash_Personal_Amount'
    DataSets = <>
    OutputType = otResult
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
        Name = 'ioAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummRemains'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummRemains'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsCalculated'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isCalculated'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 362
    Top = 368
  end
  object spGetMICardSecondCash: TdsdStoredProc
    StoredProcName = 'gpGet_MovementItem_Cash_Personal_CardSecondCash'
    DataSets = <>
    OutputType = otResult
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
        Name = 'ioAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSummCardSecondCash'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummCardSecondRemains'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsCalculated'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isCalculated'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 426
    Top = 384
  end
  object GuidesInfoMoney: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    DisableGuidesOpen = True
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 520
    Top = 53
  end
end
