inherited PersonalServiceForm: TPersonalServiceForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
  ClientHeight = 673
  ClientWidth = 1307
  ExplicitWidth = 1323
  ExplicitHeight = 708
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 115
    Width = 1307
    Height = 558
    ExplicitTop = 115
    ExplicitWidth = 1307
    ExplicitHeight = 558
    ClientRectBottom = 558
    ClientRectRight = 1307
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1307
      ExplicitHeight = 534
      inherited cxGrid: TcxGrid
        Width = 1307
        Height = 313
        ExplicitWidth = 1307
        ExplicitHeight = 313
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
              Column = SummCard
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummService
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummMinus
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHoliday
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountCash
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummSocialIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummSocialAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountToPay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummTransport
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummTransportAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummPhone
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummTransportAddLong
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummTransportTaxi
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummNalog
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummNalogRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardSecondRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummChild
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummChildRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummMinusExt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummMinusExtRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardSecondCash
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummChild
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummDiff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummNalogRet
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummNalogRetRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAddOth
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAddOthRecalc
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
              Column = SummCard
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummService
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummMinus
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHoliday
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountCash
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummSocialIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummSocialAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountToPay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummTransport
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummTransportAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummPhone
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummTransportAddLong
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummTransportTaxi
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummNalog
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummNalogRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardSecondRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummChild
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummChildRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummMinusExt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummMinusExtRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardSecondCash
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummChild
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummDiff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummNalogRet
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummNalogRetRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAddOth
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAddOthRecalc
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
            VisibleForCustomization = False
            Width = 70
          end
          object Card: TcxGridDBColumn [3]
            Caption = #8470' '#1082#1072#1088#1090'. '#1047#1055' ('#1060'1)'
            DataBinding.FieldName = 'Card'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 115
          end
          object CardSecond: TcxGridDBColumn [4]
            Caption = #8470' '#1082#1072#1088#1090'. '#1047#1055' ('#1060'2)'
            DataBinding.FieldName = 'CardSecond'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 115
          end
          object PersonalCode: TcxGridDBColumn [5]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'PersonalCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PersonalName: TcxGridDBColumn [6]
            Caption = #1060#1048#1054' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object PositionName: TcxGridDBColumn [7]
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PersonalCode_to: TcxGridDBColumn [8]
            Caption = #1050#1086#1076' ('#1082#1086#1084#1091' '#1079#1072#1090#1088#1072#1090#1099')'
            DataBinding.FieldName = 'PersonalCode_to'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PersonalName_to: TcxGridDBColumn [9]
            Caption = #1060#1048#1054' ('#1082#1086#1084#1091' '#1079#1072#1090#1088#1072#1090#1099')'
            DataBinding.FieldName = 'PersonalName_to'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object IsMain: TcxGridDBColumn [10]
            Caption = #1054#1089#1085#1086#1074'. '#1084#1077#1089#1090#1086' '#1088'.'
            DataBinding.FieldName = 'isMain'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object IsOfficial: TcxGridDBColumn [11]
            Caption = #1054#1092#1086#1088#1084#1083'. '#1086#1092#1080#1094'.'
            DataBinding.FieldName = 'isOfficial'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object DateOut: TcxGridDBColumn [12]
            Caption = #1044#1072#1090#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'DateOut'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object Amount: TcxGridDBColumn [13]
            Caption = #1057#1091#1084#1084#1072' ('#1079#1072#1090#1088#1072#1090#1099')'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object TotalSummChild: TcxGridDBColumn [14]
            Caption = #1048#1090#1086#1075#1086' '#1053#1040#1063#1048#1057#1051#1045#1053#1048#1071' ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'TotalSummChild'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummDiff: TcxGridDBColumn [15]
            Caption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077
            DataBinding.FieldName = 'SummDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1053#1040#1063#1048#1057#1051#1045#1053#1048#1049' ('#1088#1072#1089#1095#1077#1090' '#1080' '#1092#1072#1082#1090')'
            Options.Editing = False
            Width = 70
          end
          object AmountToPay: TcxGridDBColumn [16]
            Caption = #1050' '#1074#1099#1087#1083#1072#1090#1077' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'AmountToPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountCash: TcxGridDBColumn [17]
            Caption = #1050' '#1074#1099#1087#1083#1072#1090#1077' ('#1080#1079' '#1082#1072#1089#1089#1099')'
            DataBinding.FieldName = 'AmountCash'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SummService: TcxGridDBColumn [18]
            Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'SummService'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object SummAdd: TcxGridDBColumn [19]
            Caption = #1055#1088#1077#1084#1080#1103
            DataBinding.FieldName = 'SummAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummAddOth: TcxGridDBColumn [20]
            Caption = #1055#1088#1077#1084#1080#1103' ('#1088#1072#1089#1087#1088#1077#1076'.)'
            DataBinding.FieldName = 'SummAddOth'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummAddOthRecalc: TcxGridDBColumn [21]
            Caption = #1055#1088#1077#1084#1080#1103' ('#1074#1074#1086#1076' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076'.)'
            DataBinding.FieldName = 'SummAddOthRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1077#1084#1080#1103' ('#1074#1074#1086#1076' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103')'
            Width = 70
          end
          object SummHoliday: TcxGridDBColumn [22]
            Caption = #1054#1090#1087#1091#1089#1082#1085#1099#1077
            DataBinding.FieldName = 'SummHoliday'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object SummMinus: TcxGridDBColumn [23]
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103
            DataBinding.FieldName = 'SummMinus'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object SummCard: TcxGridDBColumn [24]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' - 1'#1092'.'
            DataBinding.FieldName = 'SummCard'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummCardRecalc: TcxGridDBColumn [25]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 1'#1092'.'
            DataBinding.FieldName = 'SummCardRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummCardSecond: TcxGridDBColumn [26]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' - 2'#1092'.'
            DataBinding.FieldName = 'SummCardSecond'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummCardSecondRecalc: TcxGridDBColumn [27]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'.'
            DataBinding.FieldName = 'SummCardSecondRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummCardSecondCash: TcxGridDBColumn [28]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1072#1089#1089#1072') - 2'#1092'.'
            DataBinding.FieldName = 'SummCardSecondCash'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummNalogRet: TcxGridDBColumn [29]
            Caption = #1053#1072#1083#1086#1075#1080' - '#1074#1086#1079#1084#1077#1097#1077#1085#1080#1077' '#1082' '#1047#1055
            DataBinding.FieldName = 'SummNalogRet'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummNalogRetRecalc: TcxGridDBColumn [30]
            Caption = #1053#1072#1083#1086#1075#1080' - '#1074#1086#1079#1084#1077#1097#1077#1085#1080#1077' '#1082' '#1047#1055' ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'SummNalogRetRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummChild: TcxGridDBColumn [31]
            Caption = #1040#1083#1080#1084#1077#1085#1090#1099' - '#1091#1076#1077#1088#1078#1072#1085#1080#1077
            DataBinding.FieldName = 'SummChild'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SummChildRecalc: TcxGridDBColumn [32]
            Caption = #1040#1083#1080#1084#1077#1085#1090#1099' - '#1091#1076#1077#1088#1078#1072#1085#1080#1077' ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'SummChildRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object SummMinusExt: TcxGridDBColumn [33]
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103' '#1089#1090#1086#1088#1086#1085'. '#1102#1088'.'#1083'.'
            DataBinding.FieldName = 'SummMinusExt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SummMinusExtRecalc: TcxGridDBColumn [34]
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103' '#1089#1090#1086#1088#1086#1085'. '#1102#1088'.'#1083'. ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'SummMinusExtRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object SummSocialIn: TcxGridDBColumn [35]
            Caption = #1057#1086#1094'.'#1074#1099#1087#1083'. ('#1080#1079' '#1079#1087')'
            DataBinding.FieldName = 'SummSocialIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummSocialAdd: TcxGridDBColumn [36]
            Caption = #1057#1086#1094'.'#1074#1099#1087#1083'. ('#1076#1086#1087'. '#1082' '#1079#1087')'
            DataBinding.FieldName = 'SummSocialAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object SummTransport: TcxGridDBColumn [37]
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103' '#1043#1057#1052
            DataBinding.FieldName = 'SummTransport'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SummPhone: TcxGridDBColumn [38]
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103' '#1052#1086#1073'.'#1089#1074#1103#1079#1100
            DataBinding.FieldName = 'SummPhone'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SummTransportAdd: TcxGridDBColumn [39]
            Caption = #1050#1086#1084#1072#1085#1076#1080#1088#1086#1074#1086#1095#1085#1099#1077' ('#1076#1086#1087#1083#1072#1090#1072', '#1090#1088#1072#1085#1089#1087')'
            DataBinding.FieldName = 'SummTransportAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SummTransportAddLong: TcxGridDBColumn [40]
            Caption = #1044#1072#1083#1100#1085#1086#1073#1086#1081#1085#1099#1077' ('#1076#1086#1087#1083#1072#1090#1072', '#1090#1088#1072#1085#1089#1087')'
            DataBinding.FieldName = 'SummTransportAddLong'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object MemberName: TcxGridDBColumn [41]
            Caption = #1060#1048#1054' ('#1040#1083#1080#1084#1077#1085#1090#1099')'
            DataBinding.FieldName = 'MemberName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actMemberChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object InfoMoneyCode: TcxGridDBColumn [42]
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InfoMoneyName: TcxGridDBColumn [43]
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object isAuto: TcxGridDBColumn [44]
            Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
            DataBinding.FieldName = 'isAuto'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1087#1088#1080' '#1087#1077#1088#1077#1085#1086#1089#1077' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1086#1090#1095#1077#1090#1072
            Options.Editing = False
            Width = 38
          end
          object Comment: TcxGridDBColumn [45]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 125
          end
          object SummTransportTaxi: TcxGridDBColumn [46]
            Caption = #1058#1072#1082#1089#1080' ('#1076#1086#1087#1083#1072#1090#1072', '#1090#1088#1072#1085#1089#1087')'
            DataBinding.FieldName = 'SummTransportTaxi'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object InfoMoneyName_all: TcxGridDBColumn [47]
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'InfoMoneyName_all'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PersonalServiceListName: TcxGridDBColumn [48]
            Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' ('#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1041#1053')'
            DataBinding.FieldName = 'PersonalServiceListName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actPersonalServiceListChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 140
          end
          object SummNalog: TcxGridDBColumn [49]
            Caption = #1053#1072#1083#1086#1075#1080' - '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1089' '#1047#1055
            DataBinding.FieldName = 'SummNalog'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummNalogRecalc: TcxGridDBColumn [50]
            Caption = #1053#1072#1083#1086#1075#1080' - '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1089' '#1047#1055' ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'SummNalogRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 318
        Width = 1307
        Height = 216
        Align = alBottom
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDs
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
              Column = cxHoursDay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxWorkTimeHoursOne
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxHoursPlan
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxWorkTimeHours
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxPrice
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxDayCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxPersonalCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxGrossOne
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
              Column = cxMemberCount
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
              Column = cxHoursDay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxWorkTimeHoursOne
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxHoursPlan
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxWorkTimeHours
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxPrice
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxDayCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxPersonalCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxGrossOne
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
              Column = cxMemberCount
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
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object cxMemberName: TcxGridDBColumn
            Caption = #1060#1080#1079'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'MemberName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 276
          end
          object cxPositionLevelName: TcxGridDBColumn
            Caption = #1056#1072#1079#1088#1103#1076' '#1076#1086#1083#1078#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'PositionLevelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object cxStaffListName: TcxGridDBColumn
            Caption = #1064#1090#1072#1090#1085#1086#1077' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077
            DataBinding.FieldName = 'StaffListName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object cxModelServiceName: TcxGridDBColumn
            Caption = #1052#1086#1076#1077#1083#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'ModelServiceName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object clStorageLineName: TcxGridDBColumn
            Caption = #1051#1080#1085#1080#1103' '#1087#1088'-'#1074#1072
            DataBinding.FieldName = 'StorageLineName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object cxAmount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1085#1072' 1 '#1095#1077#1083', '#1075#1088#1085
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object cxMemberCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1083#1086#1074#1077#1082' ('#1074#1089#1077')'
            DataBinding.FieldName = 'MemberCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object cxStaffListSummKindName: TcxGridDBColumn
            Caption = #1058#1080#1087#1099' '#1089#1091#1084#1084' '#1076#1083#1103' '#1096#1090#1072#1090#1085#1086#1075#1086' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1103
            DataBinding.FieldName = 'StaffListSummKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actPersonalServiceListChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 103
          end
          object cxDayCount: TcxGridDBColumn
            Caption = #1054#1090#1088#1072#1073'. '#1076#1085'. 1 '#1095#1077#1083' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'DayCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object cxWorkTimeHoursOne: TcxGridDBColumn
            Caption = #1054#1090#1088#1072#1073'. '#1095#1072#1089#1086#1074' 1 '#1095#1077#1083
            DataBinding.FieldName = 'WorkTimeHoursOne'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object cxWorkTimeHours: TcxGridDBColumn
            Caption = #1054#1090#1088#1072#1073'. '#1095#1072#1089#1086#1074' ('#1074#1089#1077')'
            DataBinding.FieldName = 'WorkTimeHours'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object cxPrice: TcxGridDBColumn
            Caption = #1075#1088#1085'./'#1079#1072' '#1082#1075' '#1048#1051#1048' '#1075#1088#1085'./'#1089#1090#1072#1074#1082#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 81
          end
          object cxHoursPlan: TcxGridDBColumn
            Caption = #1054#1073#1097#1080#1081' '#1087#1083#1072#1085' '#1095#1072#1089#1086#1074' '#1074' '#1084#1077#1089#1103#1094' '#1085#1072' '#1095#1077#1083#1086#1074#1077#1082#1072
            DataBinding.FieldName = 'HoursPlan'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 97
          end
          object cxHoursDay: TcxGridDBColumn
            Caption = #1044#1085#1077#1074#1085#1086#1081' '#1087#1083#1072#1085' '#1095#1072#1089#1086#1074' '#1085#1072' '#1095#1077#1083#1086#1074#1077#1082#1072
            DataBinding.FieldName = 'HoursDay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object cxPersonalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1083#1086#1074#1077#1082
            DataBinding.FieldName = 'PersonalCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object cxGrossOne: TcxGridDBColumn
            Caption = #1041#1072#1079#1072' '#1085#1072' 1-'#1075#1086' '#1095#1077#1083', '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'GrossOne'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
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
      object cxSplitterChild: TcxSplitter
        Left = 0
        Top = 313
        Width = 1307
        Height = 5
        AlignSplitter = salBottom
        Control = cxGrid1
      end
    end
    object cxTabSheetSign: TcxTabSheet
      Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1087#1086#1076#1087#1080#1089#1100
      ImageIndex = 3
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cxGridSign: TcxGrid
        Left = 0
        Top = 0
        Width = 1307
        Height = 534
        Align = alClient
        TabOrder = 0
        LookAndFeel.NativeStyle = False
        object cxGridDBTableViewSign: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = SignDS
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
          object sgOrd: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'Ord'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object sgUserName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
          object sgOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1076#1077#1081#1089#1090#1074#1080#1103
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object sgIsSign: TcxGridDBColumn
            Caption = #1055#1086#1076#1087#1080#1089#1072#1085' ('#1044#1072'/'#1053#1077#1090')'
            DataBinding.FieldName = 'isSign'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1076#1087#1080#1089#1072#1085' ('#1044#1072'/'#1053#1077#1090')'
            Width = 80
          end
          object sclSignInternalName: TcxGridDBColumn
            Caption = #1052#1086#1076#1077#1083#1100
            DataBinding.FieldName = 'SignInternalName'
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
            Width = 278
          end
          object sclisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBTableViewSign
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1307
    Height = 89
    TabOrder = 3
    ExplicitWidth = 1307
    ExplicitHeight = 89
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 89
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 89
      ExplicitWidth = 86
      Width = 86
    end
    inherited cxLabel2: TcxLabel
      Left = 89
      ExplicitLeft = 89
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 61
      ExplicitTop = 61
      ExplicitWidth = 167
      ExplicitHeight = 22
      Width = 167
    end
    object edServiceDate: TcxDateEdit
      Left = 185
      Top = 23
      EditValue = 41640d
      Properties.DisplayFormat = 'mmmm yyyy'
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 6
      Width = 97
    end
    object cxLabel6: TcxLabel
      Left = 185
      Top = 5
      Caption = #1052#1077#1089#1103#1094' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081
    end
    object edComment: TcxTextEdit
      Left = 708
      Top = 23
      TabOrder = 8
      Width = 365
    end
    object cxLabel12: TcxLabel
      Left = 708
      Top = 7
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '
    end
    object edPersonalServiceList: TcxButtonEdit
      Left = 292
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 218
    end
    object cxLabel3: TcxLabel
      Left = 292
      Top = 5
      Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100
    end
    object cxLabel4: TcxLabel
      Left = 526
      Top = 5
      Caption = #1070#1088'.'#1083#1080#1094#1086' ('#1089#1086#1094'.'#1074#1099#1087#1083#1072#1090#1099')'
    end
    object edJuridical: TcxButtonEdit
      Left = 526
      Top = 23
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 13
      Width = 168
    end
    object edIsAuto: TcxCheckBox
      Left = 185
      Top = 61
      Caption = #1057#1086#1079#1076#1072#1085' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' ('#1076#1072'/'#1085#1077#1090')'
      Properties.ReadOnly = True
      TabOrder = 14
      Width = 187
    end
    object cxLabel21: TcxLabel
      Left = 708
      Top = 45
      Caption = #1045#1089#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
    end
    object edstrSign: TcxTextEdit
      Left = 708
      Top = 61
      Properties.ReadOnly = True
      TabOrder = 16
      Width = 181
    end
    object cxLabel22: TcxLabel
      Left = 894
      Top = 45
      Caption = #1054#1078#1080#1076#1072#1077#1090#1089#1103' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
    end
    object edstrSignNo: TcxTextEdit
      Left = 894
      Top = 61
      Properties.ReadOnly = True
      TabOrder = 18
      Width = 179
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 299
    Top = 336
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 24
    Top = 224
  end
  inherited ActionList: TActionList
    object actRefresh_Sign: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelectMISign
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object actRefreshMaster: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = True
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
          StoredProc = spSelectChild
        end
        item
          StoredProc = spSelectMISign
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
    object actUpdateIsMain: TdsdExecStoredProc [9]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateIsMain
      StoredProcList = <
        item
          StoredProc = spUpdateIsMain
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1054#1089#1085#1086#1074#1085#1086#1077' '#1084#1077#1089#1090#1086' '#1088'.  '#1044#1072'/'#1053#1077#1090'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1054#1089#1085#1086#1074#1085#1086#1077' '#1084#1077#1089#1090#1086' '#1088'.  '#1044#1072'/'#1053#1077#1090'"'
      ImageIndex = 76
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end>
    end
    object actPrint_All: TdsdPrintAction [11]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint_All
      StoredProcList = <
        item
          StoredProc = spSelectPrint_All
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1042#1089#1077' '#1076#1086#1083#1078#1085#1086#1089#1090#1080
      Hint = #1055#1077#1095#1072#1090#1100' '#1042#1089#1077' '#1076#1086#1083#1078#1085#1086#1089#1090#1080
      ImageIndex = 3
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
      Caption = #1055#1077#1095#1072#1090#1100' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
      Hint = #1055#1077#1095#1072#1090#1100' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
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
    object actPersonalServiceListChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PersonalServiceListForm'
      FormName = 'TPersonalServiceListForm'
      FormNameParam.Value = 'TPersonalServiceListForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalServiceListId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalServiceListName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actMemberChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Member_ObjectForm'
      FormName = 'TMember_ObjectForm'
      FormNameParam.Value = 'TMember_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object mactUpdateMask: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actPersonalServiceJournalChoice
        end
        item
          Action = actUpdateMask
        end
        item
          Action = actRefresh
        end>
      Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103#1084' '#1080#1079' '#1076#1088#1091#1075#1086#1081' '#1074#1077#1076#1086#1084#1086#1089#1090#1080
      Hint = #1050#1086#1087#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103#1084' '#1080#1079' '#1076#1088#1091#1075#1086#1081' '#1074#1077#1076#1086#1084#1086#1089#1090#1080
      ImageIndex = 59
    end
    object actUpdateCardSecond: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CardSecond
      StoredProcList = <
        item
          StoredProc = spUpdate_CardSecond
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1072#1089#1089#1072') - 2'#1092'.'
    end
    object actUpdateCardSecondCash: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CardSecondCash
      StoredProcList = <
        item
          StoredProc = spUpdate_CardSecondCash
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1072#1089#1089#1072') - 2'#1092'.'
    end
    object macUpdateCardSecond: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateCardSecond
        end
        item
          Action = actRefresh
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'.'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'.'
      ImageIndex = 74
    end
    object macUpdateCardSecondCash: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateCardSecondCash
        end
        item
          Action = actRefresh
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1072#1089#1089#1072') - 2'#1092'.'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1072#1089#1089#1072') - 2'#1092'.'
      ImageIndex = 27
    end
    object actUpdateMask: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMask
      StoredProcList = <
        item
          StoredProc = spUpdateMask
        end>
      Caption = 'actUpdateMask'
    end
    object actUpdateSummNalogRet: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      StoredProc = spUpdate_MI_PersonalService_SummNalogRet
      StoredProcList = <
        item
          StoredProc = spUpdate_MI_PersonalService_SummNalogRet
        end>
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' "'#1053#1072#1083#1086#1075#1080' - '#1074#1086#1079#1084#1077#1097'. '#1082' '#1047#1055'" '#1087#1086' "'#1053#1072#1083#1086#1075#1080' - '#1091#1076#1077#1088#1078'. '#1089' '#1047#1055'"'
      Hint = 
        #1047#1072#1087#1086#1083#1085#1080#1090#1100' "'#1053#1072#1083#1086#1075#1080' - '#1074#1086#1079#1084#1077#1097#1077#1085#1080#1077' '#1082' '#1047#1055'" '#1087#1086' "'#1053#1072#1083#1086#1075#1080' - '#1091#1076#1077#1088#1078#1072#1085#1080#1077' '#1089' '#1047#1055 +
        '"'
      ImageIndex = 39
    end
    object macUpdateSummNalogRet: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateNalogRetSimpl
        end
        item
          Action = actRefreshMaster
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1087#1086#1083#1085#1080#1090#1100' "'#1053#1072#1083#1086#1075#1080' - '#1074#1086#1079#1084#1077#1097'. '#1082' '#1047#1055'" '#1087#1086' "'#1053#1072#1083#1086#1075#1080' - '#1091#1076#1077 +
        #1088#1078'. '#1089' '#1047#1055'"?'
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1103' "'#1053#1072#1083#1086#1075#1080' - '#1074#1086#1079#1084#1077#1097'. '#1082' '#1047#1055'" '#1079#1072#1087#1086#1083#1085#1077#1085#1099
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' "'#1053#1072#1083#1086#1075#1080' - '#1074#1086#1079#1084#1077#1097'. '#1082' '#1047#1055'" '#1087#1086' "'#1053#1072#1083#1086#1075#1080' - '#1091#1076#1077#1088#1078'. '#1089' '#1047#1055'"'
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' "'#1053#1072#1083#1086#1075#1080' - '#1074#1086#1079#1084#1077#1097'. '#1082' '#1047#1055'" '#1087#1086' "'#1053#1072#1083#1086#1075#1080' - '#1091#1076#1077#1088#1078'. '#1089' '#1047#1055'"'
      ImageIndex = 39
    end
    object macUpdateNalogRetSimpl: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateSummNalogRet
        end>
      View = cxGridDBTableView
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' "'#1053#1072#1083#1086#1075#1080' - '#1074#1086#1079#1084#1077#1097'. '#1082' '#1047#1055'" '#1087#1086' "'#1053#1072#1083#1086#1075#1080' - '#1091#1076#1077#1088#1078'. '#1089' '#1047#1055'"'
      ImageIndex = 39
    end
    object actPersonalServiceJournalChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actPersonalServiceJournalChoice'
      FormName = 'TPersonalServiceJournalChoiceForm'
      FormNameParam.Value = 'TPersonalServiceJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MaskId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TopPersonalServiceListId'
          Value = ''
          Component = GuidesPersonalServiceList
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TopPersonalServiceListName'
          Value = ''
          Component = GuidesPersonalServiceList
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'MaskId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inMovementId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
    end
    object actGetImportSetting: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_SetNULL
      StoredProcList = <
        item
          StoredProc = spUpdate_SetNULL
        end
        item
          StoredProc = spGetImportSetting
        end>
      Caption = 'actGetImportSetting'
    end
    object actLoadExcel: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' Excel ('#1050#1072#1088#1090#1086#1095#1082#1072' '#1041#1053' '#1080' '#1053#1072#1083#1086#1075#1080') '#1074 +
        ' '#1092#1086#1088#1084#1072#1090#1077' 1'#1057'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' Excel ('#1050#1072#1088#1090#1086#1095#1082#1072' '#1041#1053' '#1080' '#1053#1072#1083#1086#1075#1080')'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1080#1079' Excel ('#1050#1072#1088#1090#1086#1095#1082#1072' '#1041#1053' '#1080' '#1053#1072#1083#1086#1075#1080')'
      ImageIndex = 41
    end
    object actInsertUpdateMISignYes: TdsdExecStoredProc
      Category = 'Sign'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMISign_Yes
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMISign_Yes
        end
        item
          StoredProc = spSelectMISign
        end>
      Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100
      Hint = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100
    end
    object mactInsertUpdateMISignYes: TMultiAction
      Category = 'Sign'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdateMISignYes
        end
        item
          Action = actRefresh_Sign
        end>
      Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1076#1083#1103' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1076#1083#1103' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 58
    end
    object actInsertUpdateMISignNo: TdsdExecStoredProc
      Category = 'Sign'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMISign_No
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMISign_No
        end
        item
          StoredProc = spSelectMISign
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100
    end
    object mactInsertUpdateMISignNo: TMultiAction
      Category = 'Sign'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdateMISignNo
        end
        item
          Action = actRefresh_Sign
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1076#1083#1103' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1076#1083#1103' '#1044#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 52
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 384
  end
  inherited MasterCDS: TClientDataSet
    Left = 72
    Top = 384
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PersonalService'
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
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 248
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
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateIsMain'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPersonalServiceList'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_All'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbLoadExcel'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateCardSecondCash'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateCardSecond'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bb'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMISignYes'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMISignNo'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      Caption = ''
      Hint = ''
    end
    object bbPrint_Bill: TdxBarButton [5]
      Caption = #1057#1095#1077#1090
      Category = 0
      Hint = #1057#1095#1077#1090
      Visible = ivAlways
      ImageIndex = 21
    end
    inherited bbStatic: TdxBarStatic
      ShowCaption = False
    end
    inherited bbAddMask: TdxBarButton
      Visible = ivNever
    end
    object bbPersonalServiceList: TdxBarButton [13]
      Action = mactUpdateMask
      Category = 0
    end
    object bbUpdateIsMain: TdxBarButton
      Action = actUpdateIsMain
      Category = 0
    end
    object bbLoadExcel: TdxBarButton
      Action = actLoadExcel
      Category = 0
    end
    object bbUpdateCardSecondCash: TdxBarButton
      Action = macUpdateCardSecondCash
      Category = 0
    end
    object bbUpdateCardSecond: TdxBarButton
      Action = macUpdateCardSecond
      Category = 0
    end
    object bbInsertUpdateMISignNo: TdxBarButton
      Action = mactInsertUpdateMISignNo
      Category = 0
    end
    object bbInsertUpdateMISignYes: TdxBarButton
      Action = mactInsertUpdateMISignYes
      Category = 0
    end
    object bbPrint_All: TdxBarButton
      Action = actPrint_All
      Caption = #1055#1077#1095#1072#1090#1100' '#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099' ('#1042#1089#1077' '#1076#1086#1083#1078#1085#1086#1089#1090#1080')'
      Category = 0
      ImageIndex = 19
    end
    object bb: TdxBarButton
      Action = macUpdateSummNalogRet
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 726
    Top = 281
  end
  inherited PopupMenu: TPopupMenu
    Left = 928
    Top = 208
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
        Name = 'ReportNameLoss'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameLossTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameLossBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MaskId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 32
    Top = 320
  end
  inherited StatusGuides: TdsdGuides
    Left = 40
    Top = 40
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_PersonalService'
    Left = 128
    Top = 40
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_PersonalService'
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
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
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
        Name = 'PersonalServiceListId'
        Value = ''
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
        Name = 'JuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
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
        Name = 'IsAuto'
        Value = Null
        Component = edIsAuto
        DataType = ftBoolean
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
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PersonalService'
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
        Name = 'inServiceDate'
        Value = 41640d
        Component = edServiceDate
        DataType = ftDateTime
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
        Name = 'inPersonalServiceListId'
        Value = ''
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 304
  end
  inherited GuidesFiller: TGuidesFiller
    IdParam.Value = nil
    GuidesList = <
      item
        Guides = GuidesPersonalServiceList
      end>
    Left = 160
    Top = 192
  end
  inherited HeaderSaver: THeaderSaver
    IdParam.Value = nil
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
      end
      item
        Control = edServiceDate
      end
      item
        Control = edPersonalServiceList
      end
      item
        Control = edJuridical
      end
      item
        Control = edComment
      end>
    Left = 232
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 912
    Top = 320
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_PersonalService_SetErased'
    Left = 718
    Top = 320
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_PersonalService_SetUnErased'
    Left = 718
    Top = 240
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PersonalService'
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
        Name = 'inPersonalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMain'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isMain'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisAuto'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isAuto'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountToPay'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountToPay'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountCash'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountCash'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSummTransportAdd'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummTransportAdd'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSummTransport'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummTransport'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSummPhone'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummPhone'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummService'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummService'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummCardRecalc'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummCardRecalc'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummCardSecondRecalc'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummCardSecondRecalc'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummCardSecondCash'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummCardSecondCash'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummNalogRecalc'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummNalogRecalc'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummNalogRet'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummNalogRet'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummMinus'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummMinus'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummAdd'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummAdd'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummAddOthRecalc'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummAddOthRecalc'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummHoliday'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummHoliday'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummSocialIn'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummSocialIn'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummSocialAdd'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummSocialAdd'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummChildRecalc'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummChildRecalc'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummMinusExtRecalc'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummMinusExtRecalc'
        DataType = ftFloat
        ParamType = ptInput
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
        Name = 'inMemberId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MemberId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPersonalServiceListId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PersonalServiceListId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 360
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
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 320
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = ''
    Left = 412
    Top = 244
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <>
    Left = 512
    Top = 328
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 500
    Top = 249
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 548
    Top = 262
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
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisShowAll'
        Value = 'FALSE'
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
    FormNameParam.Value = 'TPersonalServiceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalServiceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalServiceList
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 408
    Top = 13
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        DataType = ftString
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
    Left = 592
    Top = 8
  end
  object spUpdateIsMain: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_PersonalService_isMain'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId '
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioIsMain'
        Value = Null
        Component = FormParams
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 416
    Top = 339
  end
  object spUpdateMask: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_PersonalService_isMask'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId '
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementMaskId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MaskId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 464
    Top = 291
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    IndexFieldNames = 'ParentId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 72
    Top = 568
  end
  object ChildDs: TDataSource
    DataSet = ChildCDS
    Left = 32
    Top = 568
  end
  object DBViewAddOnChild: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
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
        DataSummaryItemIndex = -1
      end>
    Left = 182
    Top = 569
  end
  object spSelectChild: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_PersonalService_Child'
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
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 304
    Top = 576
  end
  object spGetImportSetting: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TPersonalServiceForm;zc_Object_ImportSetting_PersonalService'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 688
    Top = 392
  end
  object spUpdate_SetNULL: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_PersonalService_NULL'
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
    Left = 600
    Top = 240
  end
  object spUpdate_CardSecondCash: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_PersonalService_CardSecondCash'
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
    Left = 600
    Top = 296
  end
  object spUpdate_CardSecond: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_PersonalService_CardSecond'
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
    Left = 592
    Top = 352
  end
  object spSelectMISign: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_PersonalService_Sign'
    DataSet = SignCDS
    DataSets = <
      item
        DataSet = SignCDS
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
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 920
    Top = 376
  end
  object SignCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 920
    Top = 464
  end
  object SignDS: TDataSource
    DataSet = SignCDS
    Left = 980
    Top = 438
  end
  object spInsertUpdateMISign_Yes: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_PersonalService_Sign'
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
        Name = 'inisSign'
        Value = 'True'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 992
    Top = 227
  end
  object spInsertUpdateMISign_No: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_PersonalService_Sign'
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
        Name = 'inisSign'
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1008
    Top = 299
  end
  object spSelectPrint_All: TdsdStoredProc
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
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisShowAll'
        Value = 'TRUE'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 359
    Top = 232
  end
  object spUpdate_MI_PersonalService_SummNalogRet: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_PersonalService_SummNalogRet'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummNalog'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummNalog'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 856
    Top = 272
  end
end
