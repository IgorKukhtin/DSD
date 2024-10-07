inherited PersonalServiceJournalForm: TPersonalServiceJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
  ClientHeight = 681
  ClientWidth = 1221
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1237
  ExplicitHeight = 720
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1221
    Height = 624
    TabOrder = 3
    ExplicitWidth = 1221
    ExplicitHeight = 624
    ClientRectBottom = 624
    ClientRectRight = 1221
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1221
      ExplicitHeight = 624
      inherited cxGrid: TcxGrid
        Width = 1221
        Height = 544
        ExplicitWidth = 1221
        ExplicitHeight = 544
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
          DataController.Filter.TranslateBetween = True
          DataController.Filter.TranslateIn = True
          DataController.Filter.TranslateLike = True
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummService
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummCard
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummMinus
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummCash
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummCardRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummSocialIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummSocialAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummChild
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummToPay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummTransport
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummPhone
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummTransportAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummHoliday
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummTransportAddLong
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummTransportTaxi
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummNalog
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummNalogRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummCardSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummCardSecondRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummChildRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummMinusExt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummMinusExtRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummCardSecondCash
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummNalogRet
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummNalogRetRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummAddOth
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummAddOthRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummFine
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummHosp
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummFineOthRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummHospOthRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummFineOth
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummHospOth
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummCompensation
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummCompensationRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummAuditAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalDayAudit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummHouseAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummAvance
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummAvanceRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummMedicdayAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummSkip
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalDayMedicday
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalDaySkip
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummAvCardSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummAvCardSecondRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_BankSecond_num
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_BankSecondTwo_num
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_BankSecondDiff_num
            end
            item
              Position = spFooter
              Column = TotalSumm_BankSecond_num
            end
            item
              Position = spFooter
              Column = TotalSumm_BankSecondTwo_num
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummService
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummCard
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummMinus
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummCash
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummCardRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummSocialIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummSocialAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummChild
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummToPay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummTransport
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummPhone
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummTransportAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummHoliday
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummTransportAddLong
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummTransportTaxi
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummNalog
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummNalogRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummCardSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummCardSecondRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummChildRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummMinusExt
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummMinusExtRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummCardSecondCash
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummNalogRet
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummNalogRetRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummAddOth
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummAddOthRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummFine
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummHosp
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummFineOthRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummHospOthRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummFineOth
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummHospOth
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummCompensation
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummCompensationRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummAuditAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalDayAudit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummHouseAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummAvance
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummAvanceRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummMedicdayAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummSkip
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalDayMedicday
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalDaySkip
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummAvCardSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummAvCardSecondRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_BankSecond_num
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_BankSecondTwo_num
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm_BankSecondDiff_num
            end>
          OptionsBehavior.GoToNextCellOnEnter = False
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          OptionsView.HeaderHeight = 50
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Width = 77
          end
          inherited colOperDate: TcxGridDBColumn [1]
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          inherited colInvNumber: TcxGridDBColumn [2]
            Caption = #8470' '#1076#1086#1082'.'
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          object ServiceDate: TcxGridDBColumn
            Caption = #1052#1077#1089#1103#1094' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081
            DataBinding.FieldName = 'ServiceDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'mmmm yyyy'
            Properties.SaveTime = False
            Properties.ShowTime = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object PersonalServiceListName: TcxGridDBColumn
            Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100
            DataBinding.FieldName = 'PersonalServiceListName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object isMail: TcxGridDBColumn
            Caption = #1054#1090#1087#1088#1072#1074#1083#1077#1085' '#1087#1086' '#1087#1086#1095#1090#1077
            DataBinding.FieldName = 'isMail'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1087#1088#1072#1074#1083#1077#1085' '#1087#1086' '#1087#1086#1095#1090#1077' ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 76
          end
          object isDetail: TcxGridDBColumn
            Caption = #1044#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103
            DataBinding.FieldName = 'isDetail'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103' '#1076#1072#1085#1085#1099#1093
            Options.Editing = False
            Width = 55
          end
          object MemberName: TcxGridDBColumn
            Caption = #1060#1080#1079'.'#1083#1080#1094#1086' ('#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100') ('#1074#1077#1076'.)'
            DataBinding.FieldName = 'MemberName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1080#1079'.'#1083#1080#1094#1086' ('#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100')('#1074#1077#1076#1086#1084#1086#1089#1090#1100')'
            Options.Editing = False
            Width = 100
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' ('#1079#1072#1090#1088#1072#1090#1099')'
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSummToPay: TcxGridDBColumn
            Caption = #1050' '#1074#1099#1087#1083#1072#1090#1077' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'TotalSummToPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object TotalSummCash: TcxGridDBColumn
            Caption = #1050' '#1074#1099#1087#1083#1072#1090#1077' ('#1080#1079' '#1082#1072#1089#1089#1099')'
            DataBinding.FieldName = 'TotalSummCash'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSummService: TcxGridDBColumn
            Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'TotalSummService'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSummCard: TcxGridDBColumn
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' - 1'#1092'.'
            DataBinding.FieldName = 'TotalSummCard'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 92
          end
          object TotalSummCardRecalc: TcxGridDBColumn
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 1'#1092'.'
            DataBinding.FieldName = 'TotalSummCardRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 95
          end
          object TotalSummCardSecond: TcxGridDBColumn
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' - 2'#1092'.'
            DataBinding.FieldName = 'TotalSummCardSecond'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 82
          end
          object TotalSummCardSecondRecalc: TcxGridDBColumn
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'.'
            DataBinding.FieldName = 'TotalSummCardSecondRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 95
          end
          object TotalSummAvCardSecond: TcxGridDBColumn
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' - 2'#1092'. '#1040#1074#1072#1085#1089
            DataBinding.FieldName = 'TotalSummAvCardSecond'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 82
          end
          object TotalSummAvCardSecondRecalc: TcxGridDBColumn
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'. '#1040#1074#1072#1085#1089
            DataBinding.FieldName = 'TotalSummAvCardSecondRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 95
          end
          object TotalSummCardSecondCash: TcxGridDBColumn
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1072#1089#1089#1072') - 2'#1092'.'
            DataBinding.FieldName = 'TotalSummCardSecondCash'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 82
          end
          object TotalSumm_BankSecond_num: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1050#1072#1088#1090#1072' '#1041#1072#1085#1082' - 2'#1092'.('#1042#1086#1089#1090#1086#1082', '#1087#1086' '#1087#1088#1080#1086#1088')'
            DataBinding.FieldName = 'TotalSumm_BankSecond_num'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1072#1088#1090#1072' '#1041#1072#1085#1082' - 2'#1092'.('#1042#1086#1089#1090#1086#1082', '#1087#1086' '#1087#1088#1080#1086#1088#1080#1090#1077#1090#1091')'
            Width = 80
          end
          object TotalSumm_BankSecondTwo_num: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1050#1072#1088#1090#1072' '#1041#1072#1085#1082' - 2'#1092'.('#1054#1058#1055', '#1087#1086' '#1087#1088#1080#1086#1088')'
            DataBinding.FieldName = 'TotalSumm_BankSecondTwo_num'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1072#1088#1090#1072' '#1041#1072#1085#1082' - 2'#1092'.('#1054#1058#1055', '#1087#1086' '#1087#1088#1080#1086#1088#1080#1090#1077#1090#1091')'
            Width = 80
          end
          object TotalSumm_BankSecondDiff_num: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1050#1072#1088#1090#1072' '#1041#1072#1085#1082' - 2'#1092'.('#1083#1080#1095#1085#1099#1081', '#1087#1086' '#1087#1088#1080#1086#1088')'
            DataBinding.FieldName = 'TotalSumm_BankSecondDiff_num'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1072#1088#1090#1072' '#1041#1072#1085#1082' - 2'#1092'.('#1083#1080#1095#1085#1099#1081', '#1087#1086' '#1087#1088#1080#1086#1088#1080#1090#1077#1090#1091')'
            Width = 80
          end
          object TotalSummNalog: TcxGridDBColumn
            Caption = #1053#1072#1083#1086#1075#1080' - '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1089' '#1047#1055
            DataBinding.FieldName = 'TotalSummNalog'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSummNalogRecalc: TcxGridDBColumn
            Caption = #1053#1072#1083#1086#1075#1080' - '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1089' '#1047#1055' ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'TotalSummNalogRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSummNalogRet: TcxGridDBColumn
            Caption = #1053#1072#1083#1086#1075#1080' - '#1074#1086#1079#1084#1077#1097#1077#1085#1080#1077' '#1082' '#1047#1055
            DataBinding.FieldName = 'TotalSummNalogRet'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object TotalSummNalogRetRecalc: TcxGridDBColumn
            Caption = #1053#1072#1083#1086#1075#1080' - '#1074#1086#1079#1084#1077#1097#1077#1085#1080#1077' '#1082' '#1047#1055' ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'TotalSummNalogRetRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object TotalSummAddOth: TcxGridDBColumn
            Caption = #1055#1088#1077#1084#1080#1103' ('#1088#1072#1089#1087#1088#1077#1076'.)'
            DataBinding.FieldName = 'TotalSummAddOth'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1084#1080#1103' ('#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086')'
            Width = 85
          end
          object TotalSummAddOthRecalc: TcxGridDBColumn
            Caption = #1055#1088#1077#1084#1080#1103' ('#1074#1074#1086#1076' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076'.)'
            DataBinding.FieldName = 'TotalSummAddOthRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1084#1080#1103' ('#1074#1074#1086#1076' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103')'
            Width = 85
          end
          object TotalSummChild: TcxGridDBColumn
            Caption = #1040#1083#1080#1084#1077#1085#1090#1099' - '#1091#1076#1077#1088#1078#1072#1085#1080#1077
            DataBinding.FieldName = 'TotalSummChild'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSummChildRecalc: TcxGridDBColumn
            Caption = #1040#1083#1080#1084#1077#1085#1090#1099' - '#1091#1076#1077#1088#1078#1072#1085#1080#1077' ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'TotalSummChildRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSummAvance: TcxGridDBColumn
            Caption = #1040#1074#1072#1085#1089' ('#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086')'
            DataBinding.FieldName = 'TotalSummAvance'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSummAvanceRecalc: TcxGridDBColumn
            Caption = #1040#1074#1072#1085#1089' ('#1074#1074#1086#1076' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103')'
            DataBinding.FieldName = 'TotalSummAvanceRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSummMinusExt: TcxGridDBColumn
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103' '#1089#1090#1086#1088#1086#1085'. '#1102#1088'.'#1083'.'
            DataBinding.FieldName = 'TotalSummMinusExt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSummMinusExtRecalc: TcxGridDBColumn
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103' '#1089#1090#1086#1088#1086#1085'. '#1102#1088'.'#1083'. ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'TotalSummMinusExtRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 113
          end
          object TotalSummMinus: TcxGridDBColumn
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103
            DataBinding.FieldName = 'TotalSummMinus'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSummAdd: TcxGridDBColumn
            Caption = #1055#1088#1077#1084#1080#1103
            DataBinding.FieldName = 'TotalSummAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSummHoliday: TcxGridDBColumn
            Caption = #1054#1090#1087#1091#1089#1082#1085#1099#1077
            DataBinding.FieldName = 'TotalSummHoliday'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSummTransport: TcxGridDBColumn
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103' '#1043#1057#1052
            DataBinding.FieldName = 'TotalSummTransport'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSummPhone: TcxGridDBColumn
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103' '#1052#1086#1073'.'#1089#1074#1103#1079#1100
            DataBinding.FieldName = 'TotalSummPhone'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSummTransportAdd: TcxGridDBColumn
            Caption = #1050#1086#1084#1072#1085#1076#1080#1088#1086#1074#1086#1095#1085#1099#1077' ('#1076#1086#1087#1083#1072#1090#1072', '#1090#1088#1072#1085#1089#1087')'
            DataBinding.FieldName = 'TotalSummTransportAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object TotalSummTransportAddLong: TcxGridDBColumn
            Caption = #1044#1072#1083#1100#1085#1086#1073#1086#1081#1085#1099#1077' ('#1076#1086#1087#1083#1072#1090#1072', '#1090#1088#1072#1085#1089#1087')'
            DataBinding.FieldName = 'TotalSummTransportAddLong'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object TotalSummTransportTaxi: TcxGridDBColumn
            Caption = #1058#1072#1082#1089#1080' ('#1076#1086#1087#1083#1072#1090#1072', '#1090#1088#1072#1085#1089#1087')'
            DataBinding.FieldName = 'TotalSummTransportTaxi'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object TotalSummSocialIn: TcxGridDBColumn
            Caption = #1057#1086#1094'.'#1074#1099#1087#1083'. ('#1080#1079' '#1079#1087')'
            DataBinding.FieldName = 'TotalSummSocialIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSummSocialAdd: TcxGridDBColumn
            Caption = #1057#1086#1094'.'#1074#1099#1087#1083'. ('#1076#1086#1087'. '#1082' '#1079#1087')'
            DataBinding.FieldName = 'TotalSummSocialAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSummFine: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072
            DataBinding.FieldName = 'TotalSummFine'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object TotalSummFineOth: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072' ('#1088#1072#1089#1087#1088'.)'
            DataBinding.FieldName = 'TotalSummFineOth'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072' ('#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086')'
            Width = 87
          end
          object TotalSummFineOthRecalc: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072' ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'TotalSummFineOthRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072' ('#1074#1074#1086#1076' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103')'
            Width = 80
          end
          object TotalSummHosp: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1086#1083#1100#1085#1080#1095'.'
            DataBinding.FieldName = 'TotalSummHosp'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1073#1086#1083#1100#1085#1080#1095#1085#1099#1077
            Options.Editing = False
            Width = 87
          end
          object TotalSummHospOth: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1086#1083#1100#1085#1080#1095'. ('#1088#1072#1089#1087#1088'.)'
            DataBinding.FieldName = 'TotalSummHospOth'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1073#1086#1083#1100#1085#1080#1095#1085#1099#1077' ('#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086')'
            Width = 87
          end
          object TotalSummHospOthRecalc: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1086#1083#1100#1085#1080#1095'. ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'TotalSummHospOthRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1073#1086#1083#1100#1085#1080#1095#1085#1099#1077' ('#1074#1074#1086#1076' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103')'
            Width = 87
          end
          object TotalSummCompensation: TcxGridDBColumn
            Caption = #1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1103' ('#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086')'
            DataBinding.FieldName = 'TotalSummCompensation'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSummCompensationRecalc: TcxGridDBColumn
            Caption = #1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1103' ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'TotalSummCompensationRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSummAuditAdd: TcxGridDBColumn
            Caption = #1044#1086#1087#1083'. '#1079#1072' '#1088#1077#1074#1080#1079#1080#1102
            DataBinding.FieldName = 'TotalSummAuditAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1087#1083#1072#1090#1072' '#1079#1072' '#1088#1077#1074#1080#1079#1080#1102
            Width = 80
          end
          object TotalSummMedicdayAdd: TcxGridDBColumn
            Caption = #1044#1086#1087#1083'. '#1079#1072' '#1089#1072#1085#1086#1073#1088#1072#1073#1086#1090#1082#1091
            DataBinding.FieldName = 'TotalSummMedicdayAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1087#1083#1072#1090#1072' '#1079#1072' '#1089#1072#1085#1086#1073#1088#1072#1073#1086#1090#1082#1091
            Width = 80
          end
          object TotalSummSkip: TcxGridDBColumn
            Caption = #1059#1076#1077#1088#1078'. '#1079#1072' '#1087#1088#1086#1075#1091#1083
            DataBinding.FieldName = 'TotalSummSkip'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1076#1077#1088#1078#1072#1085#1080#1077' '#1079#1072' '#1087#1088#1086#1075#1091#1083
            Width = 80
          end
          object TotalSummHouseAdd: TcxGridDBColumn
            Caption = #1044#1086#1087#1083'. '#1079#1072' '#1078#1080#1083#1100#1077
            DataBinding.FieldName = 'TotalSummHouseAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1087#1083#1072#1090#1072' '#1079#1072' '#1078#1080#1083#1100#1077
            Options.Editing = False
            Width = 80
          end
          object TotalDayAudit: TcxGridDBColumn
            Caption = #1044#1086#1087#1083#1072#1090#1072' '#1079#1072' '#1088#1077#1074#1080#1079#1080#1102', '#1076#1085#1077#1081
            DataBinding.FieldName = 'TotalDayAudit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1085#1077#1081' '#1076#1086#1087#1083#1072#1090#1072' '#1079#1072' '#1088#1077#1074#1080#1079#1080#1102
            Options.Editing = False
            Width = 80
          end
          object TotalDayMedicday: TcxGridDBColumn
            Caption = #1044#1086#1087#1083#1072#1090#1072' '#1079#1072' '#1089#1072#1085#1086#1073#1088#1072#1073#1086#1090#1082#1091', '#1076#1085#1077#1081
            DataBinding.FieldName = 'TotalDayMedicday'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1085#1077#1081' '#1076#1086#1087#1083#1072#1090#1072' '#1079#1072' '#1089#1072#1085#1086#1073#1088#1072#1073#1086#1090#1082#1091
            Options.Editing = False
            Width = 80
          end
          object TotalDaySkip: TcxGridDBColumn
            Caption = #1059#1076#1077#1088#1078'. '#1079#1072' '#1087#1088#1086#1075#1091#1083', '#1076#1085#1077#1081
            DataBinding.FieldName = 'TotalDaySkip'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1085#1077#1081' '#1091#1076#1077#1088#1078#1072#1085#1080#1077' '#1079#1072' '#1087#1088#1086#1075#1091#1083
            Options.Editing = False
            Width = 80
          end
          object PriceNalog: TcxGridDBColumn
            Caption = #1057#1090#1072#1074#1082#1072' '#1085#1072#1083#1086#1075#1072
            DataBinding.FieldName = 'PriceNalog'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object isAuto: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
            DataBinding.FieldName = 'isAuto'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1087#1088#1080' '#1087#1077#1088#1077#1085#1086#1089#1077' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1086#1090#1095#1077#1090#1072
            Options.Editing = False
            Width = 57
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object strSign: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1087#1086#1083#1100#1079'. - '#1077#1089#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
            DataBinding.FieldName = 'strSign'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object strSignNo: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1087#1086#1083#1100#1079'. - '#1086#1078#1080#1076#1072#1077#1090#1089#1103' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
            DataBinding.FieldName = 'strSignNo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object StartBeginDate: TcxGridDBColumn
            Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1085#1072#1095'.'
            DataBinding.FieldName = 'StartBeginDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd mm yyyy'
            Properties.SaveTime = False
            Properties.ShowTime = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1086#1090#1086#1082#1086#1083' '#1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1085#1072#1095#1072#1083#1086
            Options.Editing = False
            Width = 80
          end
          object EndBeginDate: TcxGridDBColumn
            Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1086#1082#1086#1085#1095'.'
            DataBinding.FieldName = 'EndBeginDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd mm yyyy'
            Properties.SaveTime = False
            Properties.ShowTime = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1086#1090#1086#1082#1086#1083' '#1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1086#1082#1086#1085#1095#1072#1085#1080#1077
            Options.Editing = False
            Width = 80
          end
          object is4000: TcxGridDBColumn
            Caption = #1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'. (>=4000)'
            DataBinding.FieldName = 'is4000'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'. (>=4000)'
            Width = 70
          end
          object InvNumber_BankSecondNum: TcxGridDBColumn
            Caption = #1044#1086#1082'. '#1055#1088#1080#1086#1088'. '#1088#1072#1089#1087#1088#1077#1076'. '#1047#1055' - '#1060'2'
            DataBinding.FieldName = 'InvNumber_BankSecondNum'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103' '#1087#1086' '#1073#1072#1085#1082#1072#1084' '#1047#1055' - '#1060'2'
            Options.Editing = False
            Width = 100
          end
        end
      end
      object Panel1: TPanel
        Left = 0
        Top = 544
        Width = 1221
        Height = 80
        Align = alBottom
        Caption = 'Panel1'
        TabOrder = 1
        Visible = False
        object ExportXmlGrid: TcxGrid
          Left = 764
          Top = 1
          Width = 456
          Height = 78
          Align = alRight
          TabOrder = 0
          Visible = False
          object ExportXmlGridDBTableView: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = ExportDS
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsBehavior.IncSearch = True
            OptionsData.CancelOnExit = False
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Editing = False
            OptionsData.Inserting = False
            OptionsView.CellAutoHeight = True
            OptionsView.ColumnAutoWidth = True
            OptionsView.GroupByBox = False
            OptionsView.Header = False
            object RowData: TcxGridDBColumn
              DataBinding.FieldName = 'RowData'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 100
            end
          end
          object ExportXmlGridLevel: TcxGridLevel
            GridView = ExportXmlGridDBTableView
          end
        end
        object ExportXmlGrid_num: TcxGrid
          Left = 308
          Top = 1
          Width = 456
          Height = 78
          Align = alRight
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          object cxGridDBTableView1: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = ExportDS_num
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            OptionsBehavior.IncSearch = True
            OptionsData.CancelOnExit = False
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Editing = False
            OptionsData.Inserting = False
            OptionsView.CellAutoHeight = True
            OptionsView.ColumnAutoWidth = True
            OptionsView.GroupByBox = False
            OptionsView.Header = False
            object expFIO: TcxGridDBColumn
              DataBinding.FieldName = 'FIO'
              MinWidth = 180
              Width = 180
            end
            object expName: TcxGridDBColumn
              DataBinding.FieldName = 'Name'
              MinWidth = 180
              Width = 180
            end
            object expName_two: TcxGridDBColumn
              DataBinding.FieldName = 'Name_two'
              MinWidth = 180
              Width = 180
            end
            object expINN: TcxGridDBColumn
              DataBinding.FieldName = 'INN'
              MinWidth = 120
            end
            object expPhone: TcxGridDBColumn
              DataBinding.FieldName = 'Phone'
              MinWidth = 150
              Width = 150
            end
            object expCardIBANSecond: TcxGridDBColumn
              DataBinding.FieldName = 'CardIBANSecond'
              MinWidth = 320
              Width = 320
            end
            object expCardBankSecond: TcxGridDBColumn
              DataBinding.FieldName = 'CardBankSecond'
              MinWidth = 180
            end
            object expBankSecond_num: TcxGridDBColumn
              Caption = #1057#1091#1084#1084#1072
              DataBinding.FieldName = 'BankSecond_num'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DisplayFormat = ',0.00'
              MinWidth = 100
              Width = 100
            end
            object expPersonalName: TcxGridDBColumn
              DataBinding.FieldName = 'PersonalName'
              MinWidth = 350
              Width = 350
            end
            object expBankSecondName: TcxGridDBColumn
              DataBinding.FieldName = 'BankSecondName'
              MinWidth = 250
              Width = 250
            end
            object expCardSecond: TcxGridDBColumn
              DataBinding.FieldName = 'CardSecond'
              MinWidth = 320
              Width = 320
            end
          end
          object cxGridLevel1: TcxGridLevel
            GridView = cxGridDBTableView1
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1221
    ExplicitWidth = 1221
    inherited deStart: TcxDateEdit
      EditValue = 42736d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42736d
    end
    object cbIsServiceDate: TcxCheckBox
      Left = 405
      Top = 5
      Action = actIsServiceDate
      TabOrder = 4
      Width = 200
    end
  end
  object cxLabel27: TcxLabel [2]
    Left = 722
    Top = 6
    Caption = #1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077':'
  end
  object edJuridicalBasis: TcxButtonEdit [3]
    Left = 800
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 150
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 179
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 243
  end
  inherited ActionList: TActionList
    Left = 31
    Top = 194
    object macExportZP: TMultiAction [0]
      Category = 'Export'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_FileNameZp
        end
        item
          Action = actExportToFileZp
        end>
      Caption = 
        #1069#1082#1089#1087#1086#1088#1090' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1047#1055' '#1085#1072' '#1082#1072#1088#1090#1086#1095#1082#1091' '#1076#1083#1103' "'#1042#1054#1057#1058#1054#1050'" '#1080#1083#1080' "'#1054#1058 +
        #1055'"'
      Hint = 
        #1069#1082#1089#1087#1086#1088#1090' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1047#1055' '#1085#1072' '#1082#1072#1088#1090#1086#1095#1082#1091' '#1076#1083#1103' "'#1042#1054#1057#1058#1054#1050'" '#1080#1083#1080' "'#1054#1058 +
        #1055'"'
      ImageIndex = 30
    end
    object actGet_Export_FileNameZp_dbf: TdsdExecStoredProc [1]
      Category = 'Export_dbf'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_FileNameZP_dbf
      StoredProcList = <
        item
          StoredProc = spGet_Export_FileNameZP_dbf
        end>
      Caption = 'actGet_Export_Email'
    end
    object actGet_Export_FileNameZp: TdsdExecStoredProc [2]
      Category = 'Export'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_FileNameZP
      StoredProcList = <
        item
          StoredProc = spGet_Export_FileNameZP
        end>
      Caption = 'actGet_Export_Email'
    end
    object actGet_Export_FileNameCSVF2: TdsdExecStoredProc [4]
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_FileNameCSVF2
      StoredProcList = <
        item
          StoredProc = spGet_Export_FileNameCSVF2
        end>
      Caption = 'actGet_Export_FileNameCSV'
    end
    object actExport_GridF2_proir_xls: TExportGrid [5]
      Category = 'Export_Email'
      MoveParams = <>
      Grid = ExportXmlGrid_num
      Caption = 'actExport_GridF2_xls'
      OpenAfterCreate = False
      DefaultFileName = 'Report_'
      Separator = ';'
      DefaultFileExt = 'XLS'
    end
    object actGet_Export_EmailCSVF2: TdsdExecStoredProc [6]
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_EmailCSVF2
      StoredProcList = <
        item
          StoredProc = spGet_Export_EmailCSVF2
        end>
      Caption = 'actGet_Export_EmailCSV'
    end
    object actExport_dbf: TdsdStoredProcExportToFile [7]
      Category = 'Export_dbf'
      MoveParams = <>
      dsdStoredProcName = spSelectExport_dbf
      FilePathParam.Value = ''
      FilePathParam.DataType = ftString
      FilePathParam.MultiSelectSeparator = ','
      FileNameParam.Value = ''
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      FileExt = '.dbf'
      FileExtParam.Value = '.dbf'
      FileExtParam.DataType = ftString
      FileExtParam.MultiSelectSeparator = ','
      FileNamePrefix = 'Raiffeisen_'
      FileNamePrefixParam.Value = 'Raiffeisen_'
      FileNamePrefixParam.DataType = ftString
      FileNamePrefixParam.MultiSelectSeparator = ','
      ExportType = spefExportToDbf
      FieldDefs = <
        item
          Name = 'ACCT_CARD'
          DataType = ftString
          Size = 29
        end
        item
          Name = 'FIO'
          DataType = ftString
          Size = 50
        end
        item
          Name = 'ID_CODE'
          DataType = ftString
          Size = 10
        end
        item
          Name = 'SUMA'
          DataType = ftBCD
          Precision = 2
          Size = 10
        end>
      Left = 1192
      Top = 216
    end
    object actSelect_ExportCSVF2: TdsdExecStoredProc [8]
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect_ExportCSVF2
      StoredProcList = <
        item
          StoredProc = spSelect_ExportCSVF2
        end>
      Caption = 'actSelect_ExportCSV'
    end
    object mactExportCSV_F2: TMultiAction [9]
      Category = 'Export_Email'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_EmailCSVF2
        end
        item
          Action = actGet_Export_FileNameCSVF2
        end
        item
          Action = actSelect_ExportCSVF2
        end
        item
          Action = actExport_GridCSV
        end
        item
          Action = actSMTPFileCSV
        end
        item
          Action = actUpdate_isMail
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081'  CSV - '#8470' '#1082#1072#1088#1090#1099' '#1060'2 '#1076#1086#1082#1091#1084#1077#1085#1090' '#1087 +
        #1086' '#1087#1086#1095#1090#1077'?'
      InfoAfterExecute = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' CSV - '#8470' '#1082#1072#1088#1090#1099' '#1060'2 '#1091#1089#1087#1077#1096#1085#1086' '#1086#1090#1087#1088#1072#1074#1083#1077#1085' '#1087#1086' '#1087#1086#1095#1090#1077
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' CSV - '#8470' '#1082#1072#1088#1090#1099' '#1060'2'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' CSV - '#8470' '#1082#1072#1088#1090#1099' '#1060'2'
      ImageIndex = 53
    end
    object macExport_dbf: TMultiAction [10]
      Category = 'Export_dbf'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_FileNameZp_dbf
        end
        item
          Action = actExport_dbf
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1069#1082#1089#1087#1086#1088#1090#1080#1088#1086#1074#1072#1090#1100' '#1074#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1047#1055' '#1076#1083#1103' "'#1056#1072#1081#1092#1092#1072 +
        #1081#1079#1077#1085'"?'
      InfoAfterExecute = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085
      Caption = #1069#1082#1089#1087#1086#1088#1090' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1047#1055' '#1085#1072' '#1082#1072#1088#1090#1086#1095#1082#1091' '#1076#1083#1103' "'#1056#1072#1081#1092#1092#1072#1081#1079#1077#1085'"'
      Hint = #1069#1082#1089#1087#1086#1088#1090' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1047#1055' '#1085#1072' '#1082#1072#1088#1090#1086#1095#1082#1091' '#1076#1083#1103' "'#1056#1072#1081#1092#1092#1072#1081#1079#1077#1085'"'
      ImageIndex = 61
    end
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TPersonalServiceForm'
      FormNameParam.Name = 'TPersonalServiceForm'
      FormNameParam.Value = 'TPersonalServiceForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TPersonalServiceForm'
      FormNameParam.Value = 'TPersonalServiceForm'
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
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
    end
    inherited actComplete: TdsdChangeMovementStatus
      StoredProcList = <
        item
          StoredProc = spMovementComplete
        end
        item
          StoredProc = spSelect
        end>
    end
    object actPrint_Num: TdsdPrintAction [20]
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint_Num
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Num
        end>
      Caption = #1055#1077#1095#1072#1090#1100' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
      Hint = #1055#1077#1095#1072#1090#1100' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1087#1086' '#1079#1087' ('#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1087#1086' '#1073#1072#1085#1082#1072#1084')>'
      ImageIndex = 17
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
      ReportName = 'PrintMovement_PersonalServiceNum'
      ReportNameParam.Name = 'PrintMovement_PersonalServiceNum'
      ReportNameParam.Value = 'PrintMovement_PersonalServiceNum'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint: TdsdPrintAction [30]
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
      Hint = #1055#1077#1095#1072#1090#1100' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
      ImageIndex = 3
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
    object actPrint_All: TdsdPrintAction [31]
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint_All
      StoredProcList = <
        item
          StoredProc = spSelectPrint_All
        end>
      Caption = #1055#1077#1095#1072#1090#1100' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099' ('#1042#1089#1077' '#1076#1086#1083#1078#1085#1086#1089#1090#1080')>'
      Hint = #1055#1077#1095#1072#1090#1100' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099' ('#1042#1089#1077' '#1076#1086#1083#1078#1085#1086#1089#1090#1080')>'
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
    object actPrint_Detail: TdsdPrintAction [32]
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint_Detail
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Detail
        end>
      Caption = #1055#1077#1095#1072#1090#1100' <'#1056#1072#1089#1096#1080#1092#1088#1086#1074#1082#1072' '#1074#1077#1076#1086#1084#1086#1089#1090#1080'>'
      Hint = #1055#1077#1095#1072#1090#1100' <'#1056#1072#1089#1096#1080#1092#1088#1086#1074#1082#1072' '#1074#1077#1076#1086#1084#1086#1089#1090#1080'>'
      ImageIndex = 22
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'PositionName;PersonalName;ModelServiceName;PositionLevelName;Sta' +
            'ffListSummKindName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_PersonalServiceDetail'
      ReportNameParam.Value = 'PrintMovement_PersonalServiceDetail'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actInsertUpdateMISignYes: TdsdExecStoredProc [35]
      Category = 'Sign'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMISign_Yes
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMISign_Yes
        end
        item
        end>
      Caption = #1055#1086#1089#1090#1072#1074#1080#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
      Hint = #1055#1086#1089#1090#1072#1074#1080#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
    end
    object actIsServiceDate: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1080#1086#1076' '#1076#1083#1103' <'#1052#1077#1089#1103#1094' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081'>'
      Hint = #1055#1077#1088#1080#1086#1076' '#1076#1083#1103' <'#1052#1077#1089#1103#1094' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081'>'
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actExportTXTVostok: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <>
      Caption = #1047#1055' '#1074#1077#1076#1086#1084#1086#1089#1090#1100' '#1042#1086#1089#1090#1086#1082
    end
    object actExportTXTVostokSelect: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectExport
      StoredProcList = <
        item
          StoredProc = spSelectExport
        end>
      Caption = 'actExportTXTVostokSelect'
      QuestionBeforeExecute = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1074#1099#1073#1088#1072#1085#1085#1086#1084#1091' '#1087#1091#1085#1082#1090#1091' '#1074' '#1092#1086#1088#1084#1072#1090' '#1073#1072#1085#1082#1072' '#1042#1086#1089#1090#1086#1082'?'
    end
    object FileDialogAction1: TFileDialogAction
      Category = 'DSDLib'
      MoveParams = <>
      FileOpenDialog.FavoriteLinks = <>
      FileOpenDialog.FileTypes = <>
      FileOpenDialog.Options = []
      Param.Value = Null
      Param.MultiSelectSeparator = ','
    end
    object ExportGrid1: TExportGrid
      Category = 'DSDLib'
      MoveParams = <>
      ExportType = cxegExportToText
      Caption = 'ExportGrid1'
      OpenAfterCreate = False
    end
    object actExportToFileZp: TdsdStoredProcExportToFile
      Category = 'Export'
      MoveParams = <>
      dsdStoredProcName = spSelectExport
      FilePathParam.Value = ''
      FilePathParam.DataType = ftString
      FilePathParam.MultiSelectSeparator = ','
      FileNameParam.Value = ''
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      FileExt = '.txt'
      FileExtParam.Value = ''
      FileExtParam.DataType = ftString
      FileExtParam.MultiSelectSeparator = ','
      FileNamePrefix = 'Vostok_'
      FileNamePrefixParam.Value = ''
      FileNamePrefixParam.DataType = ftString
      FileNamePrefixParam.MultiSelectSeparator = ','
      FieldDefs = <>
      Left = 1192
      Top = 216
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserJuridicalBasis
      StoredProcList = <
        item
          StoredProc = spGet_UserJuridicalBasis
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1078#1091#1088#1085#1072#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1078#1091#1088#1085#1072#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      ImageIndex = 35
      FormName = 'TMovement_DateDialogForm'
      FormNameParam.Value = 'TMovement_DateDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsPartnerDate'
          Value = False
          Component = cbIsServiceDate
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object mactInsertUpdateMISignYes: TMultiAction
      Category = 'Sign'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdateMISignYes
        end>
      View = cxGridDBTableView
      Caption = #1055#1086#1089#1090#1072#1074#1080#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
      Hint = #1055#1086#1089#1090#1072#1074#1080#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
    end
    object mactInsertUpdateMISignYesList: TMultiAction
      Category = 'Sign'
      MoveParams = <>
      ActionList = <
        item
          Action = mactInsertUpdateMISignYes
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084'? '
      InfoAfterExecute = #1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1086#1076#1087#1080#1089#1072#1085#1099' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      Hint = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
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
        end>
      Caption = #1059#1073#1088#1072#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
      Hint = #1059#1073#1088#1072#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
    end
    object mactInsertUpdateMISignNo: TMultiAction
      Category = 'Sign'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdateMISignNo
        end>
      View = cxGridDBTableView
      Caption = #1059#1073#1088#1072#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
      Hint = #1059#1073#1088#1072#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
    end
    object mactInsertUpdateMISignNoList: TMultiAction
      Category = 'Sign'
      MoveParams = <>
      ActionList = <
        item
          Action = mactInsertUpdateMISignNo
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084'? '
      InfoAfterExecute = #1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' '#1087#1086#1076#1087#1080#1089#1100' '#1086#1090#1084#1077#1085#1077#1085#1072' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      ImageIndex = 52
    end
    object actGet_Export_FileName: TdsdExecStoredProc
      Category = 'Export_file'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_FileName
      StoredProcList = <
        item
          StoredProc = spGet_Export_FileName
        end>
      Caption = 'actGet_Export_FileName'
    end
    object actSMTPFile: TdsdSMTPFileAction
      Category = 'Export_file'
      MoveParams = <>
      Host.Value = Null
      Host.ComponentItem = 'Host'
      Host.DataType = ftString
      Host.MultiSelectSeparator = ','
      Port.Value = 25
      Port.ComponentItem = 'Port'
      Port.DataType = ftString
      Port.MultiSelectSeparator = ','
      UserName.Value = Null
      UserName.ComponentItem = 'UserName'
      UserName.DataType = ftString
      UserName.MultiSelectSeparator = ','
      Password.Value = Null
      Password.ComponentItem = 'Password'
      Password.DataType = ftString
      Password.MultiSelectSeparator = ','
      Body.Value = Null
      Body.ComponentItem = 'Body'
      Body.DataType = ftString
      Body.MultiSelectSeparator = ','
      Subject.Value = Null
      Subject.ComponentItem = 'Subject'
      Subject.DataType = ftString
      Subject.MultiSelectSeparator = ','
      FromAddress.Value = Null
      FromAddress.ComponentItem = 'AddressFrom'
      FromAddress.DataType = ftString
      FromAddress.MultiSelectSeparator = ','
      ToAddress.Value = Null
      ToAddress.ComponentItem = 'AddressTo'
      ToAddress.DataType = ftString
      ToAddress.MultiSelectSeparator = ','
    end
    object actExport_Grid: TExportGrid
      Category = 'Export_file'
      MoveParams = <>
      ExportType = cxegExportToText
      Caption = 'actExport_Grid'
      OpenAfterCreate = False
      DefaultFileName = 'PersonalService_Child'
      DefaultFileExt = 'XML'
      EncodingANSI = True
    end
    object actExport: TMultiAction
      Category = 'Export_file'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_FileName
        end
        item
          Action = actExport_file
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1074#1099#1075#1088#1091#1079#1080#1090#1100' '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1076#1083#1103' '#1082#1083#1080#1077#1085#1090'-'#1073#1072#1085#1082#1072' '#1074' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081 +
        ' '#1076#1086#1082#1091#1084#1077#1085#1090'?'
      InfoAfterExecute = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1091#1076#1077#1088#1078#1072#1085#1080#1081' '#1091#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1092#1072#1081#1083' '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1076#1083#1103' '#1082#1083#1080#1077#1085#1090'-'#1073#1072#1085#1082#1072
      Hint = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1092#1072#1081#1083' '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1076#1083#1103' '#1082#1083#1080#1077#1085#1090'-'#1073#1072#1085#1082#1072
      ImageIndex = 53
    end
    object actExport_file: TdsdStoredProcExportToFile
      Category = 'Export_file'
      MoveParams = <>
      dsdStoredProcName = spSelect_Export
      FilePathParam.Value = ''
      FilePathParam.DataType = ftString
      FilePathParam.MultiSelectSeparator = ','
      FileNameParam.Value = ''
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      FileExt = '.xml'
      FileExtParam.Value = ''
      FileExtParam.DataType = ftString
      FileExtParam.MultiSelectSeparator = ','
      FileNamePrefixParam.Value = ''
      FileNamePrefixParam.DataType = ftString
      FileNamePrefixParam.MultiSelectSeparator = ','
      FieldDefs = <>
      Left = 1072
      Top = 240
    end
    object actExport_GridCSV: TExportGrid
      Category = 'Export_Email'
      MoveParams = <>
      ExportType = cxegExportToText
      Grid = ExportXmlGrid
      Caption = 'actExport_GridCSV'
      OpenAfterCreate = False
      DefaultFileName = 'Report_'
      DefaultFileExt = 'XML'
    end
    object actExport_GridF2_xls: TExportGrid
      Category = 'Export_Email'
      MoveParams = <>
      Grid = ExportXmlGrid
      Caption = 'actExport_GridF2_xls'
      OpenAfterCreate = False
      DefaultFileName = 'Report_'
      Separator = ';'
      DefaultFileExt = 'XLS'
    end
    object actSMTPFileCSV: TdsdSMTPFileAction
      Category = 'Export_Email'
      MoveParams = <>
      Host.Value = Null
      Host.Component = ExportEmailCDS
      Host.ComponentItem = 'Host'
      Host.DataType = ftString
      Host.MultiSelectSeparator = ','
      Port.Value = 25
      Port.Component = ExportEmailCDS
      Port.ComponentItem = 'Port'
      Port.DataType = ftString
      Port.MultiSelectSeparator = ','
      UserName.Value = Null
      UserName.Component = ExportEmailCDS
      UserName.ComponentItem = 'UserName'
      UserName.DataType = ftString
      UserName.MultiSelectSeparator = ','
      Password.Value = Null
      Password.Component = ExportEmailCDS
      Password.ComponentItem = 'Password'
      Password.DataType = ftString
      Password.MultiSelectSeparator = ','
      Body.Value = Null
      Body.Component = ExportEmailCDS
      Body.ComponentItem = 'Body'
      Body.DataType = ftString
      Body.MultiSelectSeparator = ','
      Subject.Value = Null
      Subject.Component = ExportEmailCDS
      Subject.ComponentItem = 'Subject'
      Subject.DataType = ftString
      Subject.MultiSelectSeparator = ','
      FromAddress.Value = Null
      FromAddress.Component = ExportEmailCDS
      FromAddress.ComponentItem = 'AddressFrom'
      FromAddress.DataType = ftString
      FromAddress.MultiSelectSeparator = ','
      ToAddress.Value = Null
      ToAddress.Component = ExportEmailCDS
      ToAddress.ComponentItem = 'AddressTo'
      ToAddress.DataType = ftString
      ToAddress.MultiSelectSeparator = ','
    end
    object actGet_Export_FileNameCSV: TdsdExecStoredProc
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_FileNameCSV
      StoredProcList = <
        item
          StoredProc = spGet_Export_FileNameCSV
        end>
      Caption = 'actGet_Export_FileNameCSV'
    end
    object actGet_Export_EmailCSV: TdsdExecStoredProc
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_EmailCSV
      StoredProcList = <
        item
          StoredProc = spGet_Export_EmailCSV
        end>
      Caption = 'actGet_Export_EmailCSV'
    end
    object actSelect_ExportCSV: TdsdExecStoredProc
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect_ExportCSV
      StoredProcList = <
        item
          StoredProc = spSelect_ExportCSV
        end>
      Caption = 'actSelect_ExportCSV'
    end
    object mactExportCSV: TMultiAction
      Category = 'Export_Email'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_EmailCSV
        end
        item
          Action = actGet_Export_FileNameCSV
        end
        item
          Action = actSelect_ExportCSV
        end
        item
          Action = actExport_GridCSV
        end
        item
          Action = actSMTPFileCSV
        end
        item
          Action = actUpdate_isMail
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' CSV '#1076#1086#1082#1091#1084#1077#1085#1090' '#1087#1086' '#1087#1086#1095#1090#1077'?'
      InfoAfterExecute = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' CSV '#1091#1089#1087#1077#1096#1085#1086' '#1086#1090#1087#1088#1072#1074#1083#1077#1085' '#1087#1086' '#1087#1086#1095#1090#1077
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' CSV '#1087#1086' '#1087#1086#1095#1090#1077
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' CSV '#1087#1086' '#1087#1086#1095#1090#1077
      ImageIndex = 53
    end
    object actOpenFormPersonalServiceDetail: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1077#1090#1072#1083#1100#1085#1086' '#1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
      Hint = #1044#1077#1090#1072#1083#1100#1085#1086' '#1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
      ImageIndex = 42
      FormName = 'TPersonalServiceItemJournalForm'
      FormNameParam.Value = 'TPersonalServiceItemJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsServiceDate'
          Value = Null
          Component = cbIsServiceDate
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalServiceListId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalServiceListId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalServiceListName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalServiceListName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actSelect_ExportF2_xls: TdsdExecStoredProc
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect_ExportF2_xls
      StoredProcList = <
        item
          StoredProc = spSelect_ExportF2_xls
        end>
      Caption = 'actSelect_ExportF2_xls'
    end
    object actGet_Export_FileNameF2_xls: TdsdExecStoredProc
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_FileNameF2_xls
      StoredProcList = <
        item
          StoredProc = spGet_Export_FileNameF2_xls
        end>
      Caption = 'actGet_Export_FileNameF2_xls'
    end
    object actGet_Export_EmailF2_xls: TdsdExecStoredProc
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_EmailF2_xls
      StoredProcList = <
        item
          StoredProc = spGet_Export_EmailF2_xls
        end>
      Caption = 'actGet_Export_EmailF2_xls'
    end
    object mactExportF2_xls: TMultiAction
      Category = 'Export_Email'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_EmailF2_xls
        end
        item
          Action = actGet_Export_FileNameF2_xls
        end
        item
          Action = actSelect_ExportF2_xls
        end
        item
          Action = actExport_GridF2_xls
        end
        item
          Action = actSMTPFileCSV
        end
        item
          Action = actUpdate_isMail
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' XLS - '#8470' '#1082#1072#1088#1090#1099' '#1060'2 '#1076#1086#1082#1091#1084#1077#1085#1090' '#1087#1086 +
        ' '#1087#1086#1095#1090#1077'?'
      InfoAfterExecute = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' XLS - '#8470' '#1082#1072#1088#1090#1099' '#1060'2 '#1091#1089#1087#1077#1096#1085#1086' '#1086#1090#1087#1088#1072#1074#1083#1077#1085' '#1087#1086' '#1087#1086#1095#1090#1077
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' XLS - '#8470' '#1082#1072#1088#1090#1099' '#1060'2'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' XLS - '#8470' '#1082#1072#1088#1090#1099' '#1060'2'
      ImageIndex = 53
    end
    object actGet_Export_EmailF2_prior_xls: TdsdExecStoredProc
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_EmailF2_prior_xls
      StoredProcList = <
        item
          StoredProc = spGet_Export_EmailF2_prior_xls
        end>
      Caption = 'actGet_Export_EmailF2_xls'
    end
    object actGet_Export_FileNameF2_prior_xls: TdsdExecStoredProc
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_FileNameF2_prior_xls
      StoredProcList = <
        item
          StoredProc = spGet_Export_FileNameF2_prior_xls
        end>
      Caption = 'actGet_Export_FileNameF2_xls'
    end
    object actSelect_ExportF2_prior_xls: TdsdExecStoredProc
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect_ExportF2_prior_xls
      StoredProcList = <
        item
          StoredProc = spSelect_ExportF2_prior_xls
        end>
      Caption = 'actSelect_ExportF2_xls'
    end
    object mactExportF2_prior_xls: TMultiAction
      Category = 'Export_Email'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_EmailF2_prior_xls
        end
        item
          Action = actGet_Export_FileNameF2_prior_xls
        end
        item
          Action = actSelect_ExportF2_prior_xls
        end
        item
          Action = actExport_GridF2_proir_xls
        end
        item
          Action = actSMTPFileCSV
        end
        item
          Action = actUpdate_isMail
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' XLS - '#1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077 +
        ' '#1087#1086' '#1073#1072#1085#1082#1072#1084' '#1060'2 '#1087#1086' '#1087#1086#1095#1090#1077'?'
      InfoAfterExecute = 
        #1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' XLS - '#1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1087#1086' '#1073#1072#1085#1082#1072#1084' '#1060'2 '#1091#1089#1087#1077#1096#1085#1086' '#1086#1090 +
        #1087#1088#1072#1074#1083#1077#1085' '#1087#1086' '#1087#1086#1095#1090#1077
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' XLS - '#1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1087#1086' '#1073#1072#1085#1082#1072#1084' '#1060'2'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' XLS - '#8470' '#1082#1072#1088#1090#1099' '#1060'2'
      ImageIndex = 89
    end
    object actUpdate_isMail: TdsdExecStoredProc
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isMail
      StoredProcList = <
        item
          StoredProc = spUpdate_isMail
        end>
      Caption = 'actUpdate_isMail'
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 139
  end
  inherited MasterCDS: TClientDataSet
    Top = 139
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PersonalService'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalBasisId'
        Value = Null
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsServiceDate'
        Value = False
        Component = cbIsServiceDate
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
    Left = 120
    Top = 131
  end
  inherited BarManager: TdxBarManager
    Left = 224
    Top = 155
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbComplete'
        end
        item
          Visible = True
          ItemName = 'bbUnComplete'
        end
        item
          Visible = True
          ItemName = 'bbDelete'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
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
          ItemName = 'bbOpenFormPersonalServiceDetail'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMISignYesList'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdateMISignNoList'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemContainer'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbsPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbsSend'
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
    object bbTax: TdxBarButton
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1085#1072#1083#1086#1075#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      Category = 0
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1085#1072#1083#1086#1075#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      Visible = ivNever
      ImageIndex = 41
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbPrintTax_Us: TdxBarButton
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbPrintTax_Client: TdxBarButton
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Visible = ivAlways
      ImageIndex = 18
    end
    object bbPrint_Bill: TdxBarButton
      Caption = #1057#1095#1077#1090
      Category = 0
      Hint = #1057#1095#1077#1090
      Visible = ivAlways
      ImageIndex = 21
    end
    object bbExportZp: TdxBarButton
      Action = macExportZP
      Category = 0
    end
    object bbPrint_All: TdxBarButton
      Action = actPrint_All
      Category = 0
      ImageIndex = 19
    end
    object bbInsertUpdateMISignYesList: TdxBarButton
      Action = mactInsertUpdateMISignYesList
      Category = 0
    end
    object bbInsertUpdateMISignNoList: TdxBarButton
      Action = mactInsertUpdateMISignNoList
      Category = 0
    end
    object bbPrint_Detail: TdxBarButton
      Action = actPrint_Detail
      Category = 0
    end
    object bbExport: TdxBarButton
      Action = actExport
      Category = 0
    end
    object bbExportCSV: TdxBarButton
      Action = mactExportCSV
      Category = 0
    end
    object bbOpenFormPersonalServiceDetail: TdxBarButton
      Action = actOpenFormPersonalServiceDetail
      Category = 0
    end
    object bbExport_dbf: TdxBarButton
      Action = macExport_dbf
      Category = 0
    end
    object bbExportCSV_F2: TdxBarButton
      Action = mactExportCSV_F2
      Category = 0
    end
    object bbsPrint: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 3
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbPrint_All'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Detail'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Num'
        end>
    end
    object bbsSend: TdxBarSubItem
      Caption = #1069#1082#1089#1087#1086#1088#1090
      Category = 0
      Visible = ivAlways
      ImageIndex = 50
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbExportZp'
        end
        item
          Visible = True
          ItemName = 'bbExport_dbf'
        end
        item
          Visible = True
          ItemName = 'bbSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbExport'
        end
        item
          Visible = True
          ItemName = 'bbSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbExportCSV'
        end
        item
          Visible = True
          ItemName = 'bbSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbExportCSV_F2'
        end
        item
          Visible = True
          ItemName = 'bbtExportF2_xls'
        end
        item
          Visible = True
          ItemName = 'bbExportF2_prior_xls'
        end>
    end
    object bbSeparator1: TdxBarSeparator
      Caption = 'Separator'
      Category = 0
      Hint = 'Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbtExportF2_xls: TdxBarButton
      Action = mactExportF2_xls
      Category = 0
    end
    object bbExportF2_prior_xls: TdxBarButton
      Action = mactExportF2_prior_xls
      Category = 0
    end
    object bbPrint_Num: TdxBarButton
      Action = actPrint_Num
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 224
  end
  inherited PopupMenu: TPopupMenu
    Left = 640
    Top = 152
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 288
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = JuridicalBasisGuides
      end>
    Left = 392
    Top = 304
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_PersonalService'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = True
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 320
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_PersonalService'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 152
    Top = 296
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_PersonalService'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 224
    Top = 312
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
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameLoss'
        Value = Null
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameLossTax'
        Value = Null
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 400
    Top = 200
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_PersonalService'
    Left = 376
    Top = 152
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 708
    Top = 217
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 708
    Top = 270
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
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsList'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 599
    Top = 248
  end
  object spSelectExport: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PersonalService_export'
    DataSet = ExportCDS
    DataSets = <
      item
        DataSet = ExportCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'InvNumber'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'TotalSummCardRecalc'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 485
    Top = 357
  end
  object ExportCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 864
    Top = 632
  end
  object JuridicalBasisGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridicalBasis
    Key = '0'
    FormNameParam.Value = 'TJuridical_BasisForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_BasisForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 943
  end
  object spGet_UserJuridicalBasis: TdsdStoredProc
    StoredProcName = 'gpGet_User_JuridicalBasis'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'JuridicalBasisId'
        Value = '0'
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisName'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 728
    Top = 152
  end
  object spGet_Export_FileNameZP: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Export_FileName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileNamePrefix'
        Value = Null
        Component = actExportToFileZp
        ComponentItem = 'FileNamePrefix'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileExt'
        Value = '.txt'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 514
    Top = 154
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
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsList'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 471
    Top = 233
  end
  object spInsertUpdateMISign_Yes: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_IncomeFuel_Sign'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSign'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 832
    Top = 179
  end
  object spInsertUpdateMISign_No: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_IncomeFuel_Sign'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSign'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 824
    Top = 227
  end
  object spSelectPrint_Detail: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PersonalService_DetailPrint'
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
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 527
    Top = 201
  end
  object spGet_Export_FileName: TdsdStoredProc
    StoredProcName = 'gpGet_PersonalService_FileName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        Component = actExport_file
        ComponentItem = 'FileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        Component = actExport_file
        ComponentItem = 'FileExt'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileNamePrefix'
        Value = Null
        Component = actExport_file
        ComponentItem = 'FileNamePrefix'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 992
    Top = 168
  end
  object spSelect_Export: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PersonalService_XML'
    DataSet = ExportCDS
    DataSets = <
      item
        DataSet = ExportCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1104
    Top = 176
  end
  object ExportDS: TDataSource
    DataSet = ExportCDS
    Left = 808
    Top = 616
  end
  object ExportEmailDS: TDataSource
    DataSet = ExportEmailCDS
    Left = 80
    Top = 505
  end
  object ExportEmailCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 24
    Top = 504
  end
  object spGet_Export_EmailCSV: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_PersonalService_Email'
    DataSet = ExportEmailCDS
    DataSets = <
      item
        DataSet = ExportEmailCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParam'
        Value = '1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 504
    Top = 440
  end
  object spGet_Export_FileNameCSV: TdsdStoredProc
    StoredProcName = 'gpGet_PersonalService_FileNameCSV'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParam'
        Value = '1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        Component = actExport_GridCSV
        ComponentItem = 'DefaultFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        Component = actExport_GridCSV
        ComponentItem = 'DefaultFileExt'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEncodingANSI'
        Value = Null
        Component = actExport_GridCSV
        ComponentItem = 'EncodingANSI'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        Component = actSMTPFileCSV
        ComponentItem = 'FileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outExportType'
        Value = Null
        Component = actExport_GridCSV
        ComponentItem = 'ExportType'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 504
    Top = 512
  end
  object spSelect_ExportCSV: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PersonalService_mail'
    DataSet = ExportCDS
    DataSets = <
      item
        DataSet = ExportCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParam'
        Value = '1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 624
    Top = 488
  end
  object spSelectExport_dbf: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PersonalService_export_dbf'
    DataSet = ExportCDS
    DataSets = <
      item
        DataSet = ExportCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InvNumber'
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalSummCardRecalc'
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 581
    Top = 413
  end
  object spGet_Export_FileNameZP_dbf: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Export_FileName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileNamePrefix'
        Value = Null
        Component = actExport_dbf
        ComponentItem = 'FileNamePrefix'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileExt'
        Value = '.dbf'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 738
    Top = 410
  end
  object spGet_Export_EmailCSVF2: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_PersonalService_Email'
    DataSet = ExportEmailCDS
    DataSets = <
      item
        DataSet = ExportEmailCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParam'
        Value = '2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 904
    Top = 416
  end
  object spGet_Export_FileNameCSVF2: TdsdStoredProc
    StoredProcName = 'gpGet_PersonalService_FileNameCSV'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParam'
        Value = '2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        Component = actExport_GridCSV
        ComponentItem = 'DefaultFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        Component = actExport_GridCSV
        ComponentItem = 'DefaultFileExt'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEncodingANSI'
        Value = Null
        Component = actExport_GridCSV
        ComponentItem = 'EncodingANSI'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        Component = actSMTPFileCSV
        ComponentItem = 'FileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outExportType'
        Value = Null
        Component = actExport_GridCSV
        ComponentItem = 'ExportType'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 904
    Top = 504
  end
  object spSelect_ExportCSVF2: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PersonalService_mail'
    DataSet = ExportCDS
    DataSets = <
      item
        DataSet = ExportCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParam'
        Value = '2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 912
    Top = 464
  end
  object spGet_Export_EmailF2_xls: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_PersonalService_Email'
    DataSet = ExportEmailCDS
    DataSets = <
      item
        DataSet = ExportEmailCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParam'
        Value = '3'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1032
    Top = 416
  end
  object spSelect_ExportF2_xls: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PersonalService_mail_xls'
    DataSet = ExportCDS
    DataSets = <
      item
        DataSet = ExportCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParam'
        Value = '3'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1040
    Top = 472
  end
  object spGet_Export_FileNameF2_xls: TdsdStoredProc
    StoredProcName = 'gpGet_PersonalService_FileNameCSV'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParam'
        Value = '3'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        Component = actExport_GridF2_xls
        ComponentItem = 'DefaultFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        Component = actExport_GridF2_xls
        ComponentItem = 'DefaultFileExt'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEncodingANSI'
        Value = Null
        Component = actExport_GridF2_xls
        ComponentItem = 'EncodingANSI'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        Component = actSMTPFileCSV
        ComponentItem = 'FileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1040
    Top = 520
  end
  object spGet_Export_EmailF2_prior_xls: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_PersonalService_Email'
    DataSet = ExportEmailCDS
    DataSets = <
      item
        DataSet = ExportEmailCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParam'
        Value = '4'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1144
    Top = 376
  end
  object spSelect_ExportF2_prior_xls: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PersonalServiceNum_mail_xls'
    DataSet = ExportCDS_num
    DataSets = <
      item
        DataSet = ExportCDS_num
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParam'
        Value = '4'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1144
    Top = 432
  end
  object spGet_Export_FileNameF2_prior_xls: TdsdStoredProc
    StoredProcName = 'gpGet_PersonalService_FileNameCSV'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParam'
        Value = '4'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        Component = actExport_GridF2_proir_xls
        ComponentItem = 'DefaultFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        Component = actExport_GridF2_proir_xls
        ComponentItem = 'DefaultFileExt'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEncodingANSI'
        Value = Null
        Component = actExport_GridF2_proir_xls
        ComponentItem = 'EncodingANSI'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        Component = actSMTPFileCSV
        ComponentItem = 'FileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1144
    Top = 480
  end
  object ExportCDS_num: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 400
    Top = 624
  end
  object ExportDS_num: TDataSource
    DataSet = ExportCDS_num
    Left = 344
    Top = 608
  end
  object spSelectPrint_Num: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PersonalServiceNum_Print'
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
    Left = 567
    Top = 312
  end
  object spUpdate_isMail: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_isMail'
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
      end>
    PackSize = 1
    Left = 312
    Top = 432
  end
end
