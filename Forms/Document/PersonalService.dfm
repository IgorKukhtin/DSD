inherited PersonalServiceForm: TPersonalServiceForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
  ClientHeight = 673
  ClientWidth = 1307
  ExplicitWidth = 1323
  ExplicitHeight = 711
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
              Column = colAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummCard
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummService
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummMinus
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummHoliday
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountCash
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummCardRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummSocialIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummSocialAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummChild
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountToPay
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
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummCard
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummService
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummMinus
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummHoliday
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountCash
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummCardRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummSocialIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummSocialAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummChild
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountToPay
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
          object colUnitCode: TcxGridDBColumn [0]
            Caption = #1050#1086#1076' '#1087#1086#1076#1088'.'
            DataBinding.FieldName = 'UnitCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colUnitName: TcxGridDBColumn [1]
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object colINN: TcxGridDBColumn [2]
            Caption = #1048#1053#1053
            DataBinding.FieldName = 'INN'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 70
          end
          object clCard: TcxGridDBColumn [3]
            Caption = #8470' '#1082#1072#1088#1090'. '#1089#1095#1077#1090#1072' '#1047#1055
            DataBinding.FieldName = 'Card'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 115
          end
          object colPersonalCode: TcxGridDBColumn [4]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'PersonalCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colPersonalName: TcxGridDBColumn [5]
            Caption = #1060#1048#1054' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object colPositionName: TcxGridDBColumn [6]
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colIsMain: TcxGridDBColumn [7]
            Caption = #1054#1089#1085#1086#1074'. '#1084#1077#1089#1090#1086' '#1088'.'
            DataBinding.FieldName = 'isMain'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colIsOfficial: TcxGridDBColumn [8]
            Caption = #1054#1092#1086#1088#1084#1083'. '#1086#1092#1080#1094'.'
            DataBinding.FieldName = 'isOfficial'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colAmount: TcxGridDBColumn [9]
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
          object colSummDiff: TcxGridDBColumn [10]
            Caption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077
            DataBinding.FieldName = 'SummDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1074#1099#1087#1083#1072#1090#1099' ('#1080#1090#1086#1075#1086') '#1086#1090' '#1088#1072#1089#1095#1077#1090#1085#1086#1081
            Options.Editing = False
            Width = 70
          end
          object colTotalSummChild: TcxGridDBColumn [11]
            Caption = #1048#1090#1086#1075#1086' '#1082' '#1074#1099#1087#1083#1072#1090#1077' ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'TotalSummChild'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colAmountToPay: TcxGridDBColumn [12]
            Caption = #1050' '#1074#1099#1087#1083#1072#1090#1077' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'AmountToPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colAmountCash: TcxGridDBColumn [13]
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
          object colSummService: TcxGridDBColumn [14]
            Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'SummService'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colSummAdd: TcxGridDBColumn [15]
            Caption = #1055#1088#1077#1084#1080#1103
            DataBinding.FieldName = 'SummAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colSummHoliday: TcxGridDBColumn [16]
            Caption = #1054#1090#1087#1091#1089#1082#1085#1099#1077
            DataBinding.FieldName = 'SummHoliday'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object colSummMinus: TcxGridDBColumn [17]
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103
            DataBinding.FieldName = 'SummMinus'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colSummCard: TcxGridDBColumn [18]
            Caption = #1050#1072#1088#1090#1086#1095#1082#1072' ('#1041#1053')'
            DataBinding.FieldName = 'SummCard'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colSummCardRecalc: TcxGridDBColumn [19]
            Caption = #1050#1072#1088#1090#1086#1095#1082#1072' ('#1041#1053') '#1074#1074#1086#1076
            DataBinding.FieldName = 'SummCardRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colSummSocialIn: TcxGridDBColumn [20]
            Caption = #1057#1086#1094'.'#1074#1099#1087#1083'. ('#1080#1079' '#1079#1087')'
            DataBinding.FieldName = 'SummSocialIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colSummSocialAdd: TcxGridDBColumn [21]
            Caption = #1057#1086#1094'.'#1074#1099#1087#1083'. ('#1076#1086#1087'. '#1082' '#1079#1087')'
            DataBinding.FieldName = 'SummSocialAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object SummTransport: TcxGridDBColumn [22]
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
          object SummPhone: TcxGridDBColumn [23]
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
          object SummTransportAdd: TcxGridDBColumn [24]
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
          object SummTransportAddLong: TcxGridDBColumn [25]
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
          object colMemberName: TcxGridDBColumn [26]
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
          object InfoMoneyCode: TcxGridDBColumn [27]
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clInfoMoneyName: TcxGridDBColumn [28]
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object InfoMoneyName_all: TcxGridDBColumn [29]
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'InfoMoneyName_all'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colPersonalServiceListName: TcxGridDBColumn [30]
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
          object colisAuto: TcxGridDBColumn [31]
            Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
            DataBinding.FieldName = 'isAuto'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1087#1088#1080' '#1087#1077#1088#1077#1085#1086#1089#1077' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1086#1090#1095#1077#1090#1072
            Options.Editing = False
            Width = 38
          end
          object colComment: TcxGridDBColumn [32]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 125
          end
          object SummTransportTaxi: TcxGridDBColumn [33]
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
          object colSummChild: TcxGridDBColumn [34]
            Caption = #1040#1083#1080#1084#1077#1085#1090#1099
            DataBinding.FieldName = 'SummChild'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
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
    object actUpdateIsMain: TdsdExecStoredProc [7]
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
      ImageIndex = 52
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
      ImportSettingsId.Value = '0'
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inMovementId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actGetImportSetting: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSetting
      StoredProcList = <
        item
          StoredProc = spGetImportSetting
        end>
      Caption = 'actGetImportSetting'
    end
    object actStartLoad: TMultiAction
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
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1087#1088#1080#1079#1085#1072#1082#1072' <'#1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103'>?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1087#1088#1080#1079#1085#1072#1082#1072' <'#1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103'> '#1079#1072#1074#1077#1088#1096#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103'>'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103'>'
      ImageIndex = 41
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
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 830
    Top = 265
  end
  inherited PopupMenu: TPopupMenu
    Left = 1048
    Top = 232
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
        Name = 'inSummChild'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummChild'
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
    Left = 420
    Top = 188
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
    Left = 508
    Top = 193
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
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
        Component = FormParams
        ComponentItem = 'Id'
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
    Left = 432
    Top = 267
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
end
