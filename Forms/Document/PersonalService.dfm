inherited PersonalServiceForm: TPersonalServiceForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
  ClientHeight = 759
  ClientWidth = 1474
  ExplicitLeft = -597
  ExplicitWidth = 1490
  ExplicitHeight = 798
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 115
    Width = 1474
    Height = 644
    ExplicitTop = 115
    ExplicitWidth = 1474
    ExplicitHeight = 644
    ClientRectBottom = 644
    ClientRectRight = 1474
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1474
      ExplicitHeight = 620
      inherited cxGrid: TcxGrid
        Width = 1474
        Height = 250
        ExplicitWidth = 1474
        ExplicitHeight = 250
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
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummFine
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHosp
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardSecondDiff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummFineOthRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHospOthRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummFineOth
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHospOth
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCompensation
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCompensationRecalc
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = DayCompensation
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = DayVacation
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = DayWork
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = DayHoliday
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAuditAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DayAudit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHouseAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_avance
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAvanceRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAvance
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_avance_ps
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DaySkip
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummSkip
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DayMedicday
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummMedicdayAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardSecond_Avance
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAvCardSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAvCardSecondRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountCash_rem
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountCash_pay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = WorkTimeHoursOne_child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardSecondRecalc_005
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardSecondRecalc_00807
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_BankSecond_num
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_BankSecondTwo_num
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_BankSecondDiff_num
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummNalog_print
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
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummFine
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHosp
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardSecondDiff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummFineOthRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHospOthRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummFineOth
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHospOth
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCompensation
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCompensationRecalc
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = DayCompensation
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = DayVacation
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = DayWork
            end
            item
              Format = ',0.'
              Kind = skSum
              Column = DayHoliday
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAuditAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DayAudit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHouseAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_avance
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = PersonalName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAvanceRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAvance
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_avance_ps
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DaySkip
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummSkip
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DayMedicday
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummMedicdayAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardSecond_Avance
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAvCardSecond
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAvCardSecondRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountCash_rem
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountCash_pay
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = WorkTimeHoursOne_child
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardSecondRecalc_005
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardSecondRecalc_00807
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_BankSecond_num
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_BankSecondTwo_num
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ_BankSecondDiff_num
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummNalog_print
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
          object Code1C: TcxGridDBColumn [2]
            Caption = #1050#1086#1076' 1'#1057
            DataBinding.FieldName = 'Code1C'
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
            Width = 55
          end
          object Card: TcxGridDBColumn [3]
            Caption = #8470' '#1082#1072#1088#1090'.'#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'1)'
            DataBinding.FieldName = 'Card'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 115
          end
          object CardIBAN: TcxGridDBColumn [4]
            Caption = #8470' '#1082#1072#1088#1090'.'#1089#1095#1077#1090#1072' IBAN '#1047#1055' ('#1060'1)'
            DataBinding.FieldName = 'CardIBAN'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 115
          end
          object CardBank: TcxGridDBColumn [5]
            Caption = #8470' '#1073#1072#1085#1082'. '#1082#1072#1088#1090#1086#1095#1082#1080' '#1047#1055' ('#1060'1)'
            DataBinding.FieldName = 'CardBank'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CardSecond: TcxGridDBColumn [6]
            Caption = #8470' '#1082#1072#1088#1090'.'#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'2) ('#1042#1086#1089#1090#1086#1082')'
            DataBinding.FieldName = 'CardSecond'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 115
          end
          object CardIBANSecond: TcxGridDBColumn [7]
            Caption = #8470' '#1082#1072#1088#1090'.'#1089#1095#1077#1090#1072' IBAN '#1047#1055' ('#1060'2) ('#1042#1086#1089#1090#1086#1082')'
            DataBinding.FieldName = 'CardIBANSecond'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 115
          end
          object CardBankSecond: TcxGridDBColumn [8]
            Caption = #8470' '#1073#1072#1085#1082'. '#1082#1072#1088#1090#1086#1095#1082#1080' '#1047#1055' ('#1060'2) ('#1042#1086#1089#1090#1086#1082')'
            DataBinding.FieldName = 'CardBankSecond'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
          object CardSecondTwo: TcxGridDBColumn [9]
            Caption = #8470' '#1082#1072#1088#1090'.'#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'2) ('#1054#1058#1055')'
            DataBinding.FieldName = 'CardSecondTwo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 115
          end
          object CardIBANSecondTwo: TcxGridDBColumn [10]
            Caption = #8470' '#1082#1072#1088#1090'. '#1089#1095#1077#1090#1072' IBAN '#1047#1055' ('#1060'2) ('#1054#1058#1055')'
            DataBinding.FieldName = 'CardIBANSecondTwo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 115
          end
          object CardBankSecondTwo: TcxGridDBColumn [11]
            Caption = #8470' '#1073#1072#1085#1082'. '#1082#1072#1088#1090#1086#1095#1082#1080' '#1047#1055' ('#1060'2)('#1054#1058#1055')'
            DataBinding.FieldName = 'CardBankSecondTwo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 115
          end
          object CardSecondDiff: TcxGridDBColumn [12]
            Caption = #8470' '#1082#1072#1088#1090'.'#1089#1095#1077#1090#1072' '#1047#1055' ('#1060'2) ('#1083#1080#1095#1085'.)'
            DataBinding.FieldName = 'CardSecondDiff'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 115
          end
          object CardIBANSecondDiff: TcxGridDBColumn [13]
            Caption = #8470' '#1082#1072#1088#1090'. '#1089#1095#1077#1090#1072' IBAN '#1047#1055' ('#1060'2) ('#1083#1080#1095#1085'.)'
            DataBinding.FieldName = 'CardIBANSecondDiff'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 115
          end
          object CardBankSecondDiff: TcxGridDBColumn [14]
            Caption = #8470' '#1073#1072#1085#1082'. '#1082#1072#1088#1090#1086#1095#1082#1080' '#1047#1055' ('#1060'2)('#1083#1080#1095#1085'.)'
            DataBinding.FieldName = 'CardBankSecondDiff'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 115
          end
          object MFO: TcxGridDBColumn [15]
            Caption = #1052#1060#1054' - '#1060'1 ('#1089#1087#1088'.)'
            DataBinding.FieldName = 'MFO'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1060#1054' - '#1060'1, '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082
            Options.Editing = False
            Width = 94
          end
          object BankName: TcxGridDBColumn [16]
            Caption = #1041#1072#1085#1082' - '#1060'1 ('#1089#1087#1088'.)'
            DataBinding.FieldName = 'BankName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1072#1085#1082' - '#1060'1, '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082
            Options.Editing = False
            Width = 94
          end
          object MFO_BankSecond: TcxGridDBColumn [17]
            Caption = #1052#1060#1054' - '#1060'2 ('#1042#1086#1089#1090#1086#1082') ('#1089#1087#1088'.)'
            DataBinding.FieldName = 'MFO_BankSecond'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1060#1054' - '#1060'1, '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082
            Options.Editing = False
            Width = 94
          end
          object BankSecondName: TcxGridDBColumn [18]
            Caption = #1041#1072#1085#1082' - '#1060'2 ('#1042#1086#1089#1090#1086#1082') ('#1089#1087#1088'.)'
            DataBinding.FieldName = 'BankSecondName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1072#1085#1082' - '#1060'2 ('#1042#1086#1089#1090#1086#1082') '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082
            Options.Editing = False
            Width = 115
          end
          object MFO_BankSecondTwo: TcxGridDBColumn [19]
            Caption = #1052#1060#1054' - '#1060'2 ('#1054#1058#1055') ('#1089#1087#1088'.)'
            DataBinding.FieldName = 'MFO_BankSecondTwo'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1060#1054' - '#1060'1, '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082
            Options.Editing = False
            Width = 94
          end
          object BankSecondTwoName: TcxGridDBColumn [20]
            Caption = #1041#1072#1085#1082' - '#1060'2 ('#1054#1058#1055') ('#1089#1087#1088'.)'
            DataBinding.FieldName = 'BankSecondTwoName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1072#1085#1082' - '#1060'2 ('#1054#1058#1055') '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082
            Options.Editing = False
            Width = 76
          end
          object MFO_BankSecondDiff: TcxGridDBColumn [21]
            Caption = #1052#1060#1054' - '#1060'2 ('#1083#1080#1095#1085#1099#1081') ('#1089#1087#1088'.)'
            DataBinding.FieldName = 'MFO_BankSecondDiff'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1060#1054' - '#1060'1, '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082
            Options.Editing = False
            Width = 94
          end
          object BankSecondDiffName: TcxGridDBColumn [22]
            Caption = #1041#1072#1085#1082' - '#1060'2 ('#1083#1080#1095#1085#1099#1081') ('#1089#1087#1088'.)'
            DataBinding.FieldName = 'BankSecondDiffName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1072#1085#1082' - '#1060'2 ('#1083#1080#1095#1085#1099#1081') '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082
            Options.Editing = False
            Width = 85
          end
          object PersonalCode: TcxGridDBColumn [23]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'PersonalCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object BankSecondName_num: TcxGridDBColumn [24]
            Caption = #1041#1072#1085#1082' - 2'#1092'.('#1042#1086#1089#1090#1086#1082', '#1087#1086' '#1087#1088#1080#1086#1088')'
            DataBinding.FieldName = 'BankSecondName_num'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1072#1085#1082' - 2'#1092'.('#1042#1086#1089#1090#1086#1082', '#1087#1086' '#1087#1088#1080#1086#1088#1080#1090#1077#1090#1091')'
            Options.Editing = False
            Width = 115
          end
          object BankSecondTwoName_num: TcxGridDBColumn [25]
            Caption = #1041#1072#1085#1082' - 2'#1092'.('#1054#1058#1055', '#1087#1086' '#1087#1088#1080#1086#1088')'
            DataBinding.FieldName = 'BankSecondTwoName_num'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1072#1085#1082' - 2'#1092'.('#1054#1058#1055', '#1087#1086' '#1087#1088#1080#1086#1088#1080#1090#1077#1090#1091')'
            Options.Editing = False
            Width = 115
          end
          object BankSecondDiffName_num: TcxGridDBColumn [26]
            Caption = #1041#1072#1085#1082' - 2'#1092'.('#1083#1080#1095#1085#1099#1081', '#1087#1086' '#1087#1088#1080#1086#1088')'
            DataBinding.FieldName = 'BankSecondDiffName_num'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1072#1085#1082' - 2'#1092'.('#1083#1080#1095#1085#1099#1081', '#1087#1086' '#1087#1088#1080#1086#1088#1080#1090#1077#1090#1091')'
            Options.Editing = False
            Width = 115
          end
          object Summ_BankSecond_num: TcxGridDBColumn [27]
            Caption = #1057#1091#1084#1084#1072' '#1050#1072#1088#1090#1072' '#1041#1072#1085#1082' - 2'#1092'.('#1042#1086#1089#1090#1086#1082', '#1087#1088#1080#1086#1088')'
            DataBinding.FieldName = 'Summ_BankSecond_num'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = ' '#9#1050#1072#1088#1090#1072' '#1041#1072#1085#1082' - 2'#1092'.('#1042#1086#1089#1090#1086#1082', '#1087#1086' '#1087#1088#1080#1086#1088#1080#1090#1077#1090#1091')'
            Options.Editing = False
            Width = 99
          end
          object Summ_BankSecondTwo_num: TcxGridDBColumn [28]
            Caption = #1057#1091#1084#1084#1072' '#1050#1072#1088#1090#1072' '#1041#1072#1085#1082' - 2'#1092'.('#1054#1058#1055', '#1087#1088#1080#1086#1088')'
            DataBinding.FieldName = 'Summ_BankSecondTwo_num'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 102
          end
          object Summ_BankSecondDiff_num: TcxGridDBColumn [29]
            Caption = #1057#1091#1084#1084#1072' '#1050#1072#1088#1090#1072' '#1041#1072#1085#1082' - 2'#1092'.('#1051#1080#1095#1085#1099#1081', '#1087#1088#1080#1086#1088')'
            DataBinding.FieldName = 'Summ_BankSecondDiff_num'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 93
          end
          object SummFineOthRecalc: TcxGridDBColumn [30]
            Caption = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072' ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'SummFineOthRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072' ('#1074#1074#1086#1076' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103')'
            Width = 75
          end
          object PersonalName: TcxGridDBColumn [31]
            Caption = #1060#1048#1054' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object PositionName: TcxGridDBColumn [32]
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object FineSubjectName: TcxGridDBColumn [33]
            Caption = #1042#1080#1076' '#1085#1072#1088#1091#1096#1077#1085#1080#1081
            DataBinding.FieldName = 'FineSubjectName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actFineSubjectOpenChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummAddOthRecalc: TcxGridDBColumn [34]
            Caption = #1055#1088#1077#1084#1080#1103' ('#1074#1074#1086#1076' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076'.)'
            DataBinding.FieldName = 'SummAddOthRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1087#1088#1077#1084#1080#1103' ('#1074#1074#1086#1076' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103')'
            Width = 70
          end
          object UnitFineSubjectName: TcxGridDBColumn [35]
            Caption = #1050#1077#1084' '#1085#1072#1083#1072#1075#1072#1077#1090#1089#1103' '#1074#1079#1099#1089#1082#1072#1085#1080#1077
            DataBinding.FieldName = 'UnitFineSubjectName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actUnitFineSubjectChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1077#1084' '#1085#1072#1083#1072#1075#1072#1077#1090#1089#1103' '#1074#1079#1099#1089#1082#1072#1085#1080#1077
            Width = 70
          end
          object PersonalCode_to: TcxGridDBColumn [36]
            Caption = #1050#1086#1076' ('#1082#1086#1084#1091' '#1079#1072#1090#1088#1072#1090#1099')'
            DataBinding.FieldName = 'PersonalCode_to'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PersonalName_to: TcxGridDBColumn [37]
            Caption = #1060#1048#1054' ('#1082#1086#1084#1091' '#1079#1072#1090#1088#1072#1090#1099')'
            DataBinding.FieldName = 'PersonalName_to'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object IsMain: TcxGridDBColumn [38]
            Caption = #1054#1089#1085#1086#1074'. '#1084#1077#1089#1090#1086' '#1088'.'
            DataBinding.FieldName = 'isMain'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object IsOfficial: TcxGridDBColumn [39]
            Caption = #1054#1092#1086#1088#1084#1083'. '#1086#1092#1080#1094'.'
            DataBinding.FieldName = 'isOfficial'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object DateIn: TcxGridDBColumn [40]
            Caption = #1044#1072#1090#1072' '#1087#1088#1080#1077#1084#1072
            DataBinding.FieldName = 'DateIn'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object DateOut: TcxGridDBColumn [41]
            Caption = #1044#1072#1090#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'DateOut'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object IsPriceNalog: TcxGridDBColumn [42]
            Caption = #1057#1091#1084#1084#1072' '#1091#1076'. '#1089#1092#1086#1088#1084'. '#1085#1072' '#1086#1089#1085'. '#1091#1076'. '#1085#1072#1083#1086#1075#1072' '#1087#1086' '#1060'2'
            DataBinding.FieldName = 'IsPriceNalog'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1072' '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1085#1072#1083#1086#1075#1072' '#1087#1086' '#1060'2'
            Options.Editing = False
            Width = 60
          end
          object DayPriceNalog: TcxGridDBColumn [43]
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1085'. '#1091#1076#1077#1088#1078'. '#1085#1072#1083#1086#1075#1072' '#1060'2'
            DataBinding.FieldName = 'DayPriceNalog'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1079#1072' '#1082#1086#1090#1086#1088#1099#1077' '#1087#1088#1086#1080#1089#1093#1086#1076#1080#1090' '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1085#1072#1083#1086#1075#1072' '#1087#1086' '#1060'2'
            Options.Editing = False
            Width = 75
          end
          object StaffListSummKindName: TcxGridDBColumn [44]
            Caption = #1058#1080#1087#1099' '#1089#1091#1084#1084' '#1076#1083#1103' '#1096#1090#1072#1090#1085#1086#1075#1086' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1103
            DataBinding.FieldName = 'StaffListSummKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object DayCount_child: TcxGridDBColumn [45]
            Caption = #1054#1090#1088#1072#1073'. '#1076#1085'. 1 '#1095#1077#1083' ('#1080#1085#1092'.) ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'DayCount_child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object WorkTimeHoursOne_child: TcxGridDBColumn [46]
            Caption = #1054#1090#1088#1072#1073'. '#1095#1072#1089#1086#1074' 1 '#1095#1077#1083' ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'WorkTimeHoursOne_child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
          object Price_child: TcxGridDBColumn [47]
            Caption = #1075#1088#1085'./'#1079#1072' '#1082#1075' '#1048#1051#1048' '#1075#1088#1085'./'#1089#1090#1072#1074#1082#1072' ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'Price_child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object TotalSummChild: TcxGridDBColumn [48]
            Caption = #1048#1090#1086#1075#1086' '#1053#1040#1063#1048#1057#1051#1045#1053#1048#1071' ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'TotalSummChild'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummService: TcxGridDBColumn [49]
            Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'SummService'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object SummHoliday: TcxGridDBColumn [50]
            Caption = #1054#1090#1087#1091#1089#1082#1085#1099#1077
            DataBinding.FieldName = 'SummHoliday'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object SummHosp: TcxGridDBColumn [51]
            Caption = #1057#1091#1084#1084#1072' '#1073#1086#1083#1100#1085#1080#1095'.'
            DataBinding.FieldName = 'SummHosp'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1073#1086#1083#1100#1085#1080#1095#1085#1099#1077
            Width = 75
          end
          object SummHospOth: TcxGridDBColumn [52]
            Caption = #1057#1091#1084#1084#1072' '#1073#1086#1083#1100#1085#1080#1095'. ('#1088#1072#1089#1087#1088'.)'
            DataBinding.FieldName = 'SummHospOth'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1073#1086#1083#1100#1085#1080#1095#1085#1099#1077' ('#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086')'
            Options.Editing = False
            Width = 75
          end
          object SummAdd: TcxGridDBColumn [53]
            Caption = #1055#1088#1077#1084#1080#1103
            DataBinding.FieldName = 'SummAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummAddOth: TcxGridDBColumn [54]
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
          object SummDiff: TcxGridDBColumn [55]
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
          object Amount: TcxGridDBColumn [56]
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
          object SummCompensation: TcxGridDBColumn [57]
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
          object SummTransportTaxi: TcxGridDBColumn [58]
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
          object SummTransportAdd: TcxGridDBColumn [59]
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
          object SummTransportAddLong: TcxGridDBColumn [60]
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
          object SummAuditAdd: TcxGridDBColumn [61]
            Caption = #1044#1086#1087#1083'. '#1079#1072' '#1088#1077#1074#1080#1079#1080#1102
            DataBinding.FieldName = 'SummAuditAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1087#1083#1072#1090#1072' '#1079#1072' '#1088#1077#1074#1080#1079#1080#1102
            Width = 70
          end
          object SummMedicdayAdd: TcxGridDBColumn [62]
            Caption = #1044#1086#1087#1083'. '#1079#1072' '#1089#1072#1085#1086#1073#1088#1072#1073#1086#1090#1082#1091', '#1075#1088#1085
            DataBinding.FieldName = 'SummMedicdayAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1076#1086#1087#1083#1072#1090#1099' '#1079#1072' '#1089#1072#1085#1086#1073#1088#1072#1073#1086#1090#1082#1091
            Options.Editing = False
            Width = 70
          end
          object SummHouseAdd: TcxGridDBColumn [63]
            Caption = #1044#1086#1087#1083'. '#1079#1072' '#1078#1080#1083#1100#1077
            DataBinding.FieldName = 'SummHouseAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1087#1083#1072#1090#1072' '#1079#1072' '#1078#1080#1083#1100#1077
            Width = 70
          end
          object SummChild: TcxGridDBColumn [64]
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
          object SummMinusExt: TcxGridDBColumn [65]
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
          object SummTransport: TcxGridDBColumn [66]
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
          object SummPhone: TcxGridDBColumn [67]
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
          object SummSkip: TcxGridDBColumn [68]
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1077' '#1079#1072' '#1087#1088#1086#1075#1091#1083', '#1075#1088#1085'.'
            DataBinding.FieldName = 'SummSkip'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1091#1076#1077#1088#1078#1072#1085#1080#1081' '#1079#1072' '#1087#1088#1086#1075#1091#1083
            Options.Editing = False
            Width = 80
          end
          object SummFineOth: TcxGridDBColumn [69]
            Caption = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072' ('#1088#1072#1089#1087#1088'.)'
            DataBinding.FieldName = 'SummFineOth'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072' ('#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086')'
            Options.Editing = False
            Width = 75
          end
          object SummFine: TcxGridDBColumn [70]
            Caption = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072
            DataBinding.FieldName = 'SummFine'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object SummMinus: TcxGridDBColumn [71]
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103
            DataBinding.FieldName = 'SummMinus'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object SummNalogRet: TcxGridDBColumn [72]
            Caption = #1053#1072#1083#1086#1075#1080' - '#1074#1086#1079#1084#1077#1097#1077#1085#1080#1077' '#1082' '#1047#1055
            DataBinding.FieldName = 'SummNalogRet'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummNalog: TcxGridDBColumn [73]
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
          object AmountToPay: TcxGridDBColumn [74]
            Caption = #1050' '#1074#1099#1087#1083#1072#1090#1077' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'AmountToPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Comment: TcxGridDBColumn [75]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 125
          end
          object SummCard: TcxGridDBColumn [76]
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
          object Amount_avance: TcxGridDBColumn [77]
            Caption = #1042#1099#1087#1083#1072#1090#1072' '#1072#1074#1072#1085#1089' ('#1092'2) '#1075#1088#1085
            DataBinding.FieldName = 'Amount_avance'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object Amount_avance_ps: TcxGridDBColumn [78]
            Caption = #1042#1099#1087#1083#1072#1090#1072' '#1074'. '#1072#1074#1072#1085#1089' ('#1092'2) '#1075#1088#1085
            DataBinding.FieldName = 'Amount_avance_ps'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1087#1083#1072#1090#1072' '#1074#1077#1076#1086#1084#1086#1089#1090#1100' '#1040#1074#1072#1085#1089' ('#1092'2) '#1075#1088#1085
            Options.Editing = False
            Width = 75
          end
          object SummAvCardSecond: TcxGridDBColumn [79]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' - 2'#1092'. '#1040#1074#1072#1085#1089
            DataBinding.FieldName = 'SummAvCardSecond'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummCardSecond_Avance: TcxGridDBColumn [80]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' '#1072#1074#1072#1085#1089' - 2'#1092'.'
            DataBinding.FieldName = 'SummCardSecond_Avance'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086' '#1041#1053' '#1072#1074#1072#1085#1089' - 2'#1092'.'
            Options.Editing = False
            Width = 70
          end
          object SummCardSecond: TcxGridDBColumn [81]
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
          object SummCardSecondCash: TcxGridDBColumn [82]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1072#1089#1089#1072') - 2'#1092'.'
            DataBinding.FieldName = 'SummCardSecondCash'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountCash: TcxGridDBColumn [83]
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
          object AmountCash_pay: TcxGridDBColumn [84]
            Caption = #1042#1099#1087#1083#1072#1095#1077#1085#1086' ('#1080#1079' '#1082#1072#1089#1089#1099')'
            DataBinding.FieldName = 'AmountCash_pay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object AmountCash_rem: TcxGridDBColumn [85]
            Caption = #1054#1089#1090'.'#1082' '#1074#1099#1076#1072#1095#1077' ('#1080#1079' '#1082#1072#1089#1089#1099')'
            DataBinding.FieldName = 'AmountCash_rem'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SummCardSecondDiff: TcxGridDBColumn [86]
            Caption = #1082#1086#1087'. '#1082#1086#1088#1088'. '#1082#1072#1088#1090#1072' '#1041#1053' - 2'#1092'.'
            DataBinding.FieldName = 'SummCardSecondDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1085#1072' '#1082#1086#1087#1077#1081#1082#1080' '#1076#1083#1103' '#1050#1072#1088#1090#1072' '#1041#1053' - 2'#1092'., '#1090'.'#1082'. '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1077' '#1076#1086' ' +
              '10-90 '#1082#1086#1087'.'
            Options.Editing = False
            Width = 70
          end
          object PersonalServiceListName: TcxGridDBColumn [87]
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
          object PriceCompensation: TcxGridDBColumn [88]
            Caption = #1057#1088'. '#1079#1087' '#1076#1083#1103' '#1088#1072#1089#1095'. '#1082#1086#1084#1087#1077#1085#1089'.'
            DataBinding.FieldName = 'PriceCompensation'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1088#1077#1076#1085#1103#1103' '#1079#1087' '#1076#1083#1103' '#1088#1072#1089#1095#1077#1090#1072' '#1089#1091#1084#1084#1099' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080
            Options.Editing = False
            Width = 70
          end
          object SummSocialIn: TcxGridDBColumn [89]
            Caption = #1057#1086#1094'.'#1074#1099#1087#1083'. ('#1080#1079' '#1079#1087')'
            DataBinding.FieldName = 'SummSocialIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummSocialAdd: TcxGridDBColumn [90]
            Caption = #1057#1086#1094'.'#1074#1099#1087#1083'. ('#1076#1086#1087'. '#1082' '#1079#1087')'
            DataBinding.FieldName = 'SummSocialAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object SummAvance: TcxGridDBColumn [91]
            Caption = #1040#1074#1072#1085#1089' ('#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1086')'
            DataBinding.FieldName = 'SummAvance'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object MemberName: TcxGridDBColumn [92]
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
          object SummCardRecalc: TcxGridDBColumn [93]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 1'#1092'.'
            DataBinding.FieldName = 'SummCardRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummAvCardSecondRecalc: TcxGridDBColumn [94]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'. '#1040#1074#1072#1085#1089
            DataBinding.FieldName = 'SummAvCardSecondRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummCardSecondRecalc: TcxGridDBColumn [95]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'.'
            DataBinding.FieldName = 'SummCardSecondRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummCardSecondRecalc_005: TcxGridDBColumn [96]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1086#1101#1092'. 0.5%) - 2'#1092'.'
            DataBinding.FieldName = 'SummCardSecondRecalc_005'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummCardSecondRecalc_00807: TcxGridDBColumn [97]
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1086#1101#1092'. 0.8%) - 2'#1092'.'
            DataBinding.FieldName = 'SummCardSecondRecalc_00807'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object SummNalogRetRecalc: TcxGridDBColumn [98]
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
          object SummCompensationRecalc: TcxGridDBColumn [99]
            Caption = #1057#1091#1084#1084#1072' '#1082#1086#1084#1087'. '#1079#1072' '#1085#1077#1080#1089#1087'. '#1086#1090#1087'. ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'SummCompensationRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080' '#1079#1072' '#1085#1077#1080#1089#1087'.'#1086#1090#1087#1091#1089#1082' ('#1074#1074#1086#1076')'
            Width = 75
          end
          object SummHospOthRecalc: TcxGridDBColumn [100]
            Caption = #1057#1091#1084#1084#1072' '#1073#1086#1083#1100#1085#1080#1095'. ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'SummHospOthRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1073#1086#1083#1100#1085#1080#1095#1085#1099#1077' ('#1074#1074#1086#1076' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103')'
            Width = 75
          end
          object SummChildRecalc: TcxGridDBColumn [101]
            Caption = #1040#1083#1080#1084#1077#1085#1090#1099' - '#1091#1076#1077#1088#1078#1072#1085#1080#1077' ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'SummChildRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object SummMinusExtRecalc: TcxGridDBColumn [102]
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103' '#1089#1090#1086#1088#1086#1085'. '#1102#1088'.'#1083'. ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'SummMinusExtRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object SummNalogRecalc: TcxGridDBColumn [103]
            Caption = #1053#1072#1083#1086#1075#1080' - '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1089' '#1047#1055' ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'SummNalogRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummAvanceRecalc: TcxGridDBColumn [104]
            Caption = #1040#1074#1072#1085#1089' ('#1074#1074#1086#1076' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103')'
            DataBinding.FieldName = 'SummAvanceRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object InfoMoneyCode: TcxGridDBColumn [105]
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InfoMoneyName: TcxGridDBColumn [106]
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object isAuto: TcxGridDBColumn [107]
            Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
            DataBinding.FieldName = 'isAuto'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1087#1088#1080' '#1087#1077#1088#1077#1085#1086#1089#1077' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1086#1090#1095#1077#1090#1072
            Options.Editing = False
            Width = 38
          end
          object BankOutDate: TcxGridDBColumn [108]
            Caption = #1044#1072#1090#1072' '#1074#1099#1087#1083#1072#1090#1099' '#1087#1086' '#1073#1072#1085#1082#1091
            DataBinding.FieldName = 'BankOutDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm.yy'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1074#1099#1087#1083#1072#1090#1099' '#1087#1086' '#1073#1072#1085#1082#1091
            Width = 80
          end
          object isBankOut: TcxGridDBColumn [109]
            Caption = #1044#1083#1103' '#1091#1074#1086#1083#1077#1085#1085#1099#1093' '#1073#1072#1085#1082
            DataBinding.FieldName = 'isBankOut'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1083#1103' '#1091#1074#1086#1083#1077#1085#1085#1099#1093' '#1073#1072#1085#1082' ('#1074#1077#1076#1086#1084#1086#1089#1090#1100')'
            Options.Editing = False
            Width = 80
          end
          object DayVacation: TcxGridDBColumn [110]
            Caption = #1055#1086#1083#1086#1078#1077#1085#1086' '#1076#1085#1077#1081' '#1086#1090#1087#1091#1089#1082#1072
            DataBinding.FieldName = 'DayVacation'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object DayHoliday: TcxGridDBColumn [111]
            Caption = #1048#1089#1087'. '#1076#1085#1077#1081' '#1086#1090#1087#1091#1089#1082#1072
            DataBinding.FieldName = 'DayHoliday'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1086' '#1076#1085#1077#1081' '#1086#1090#1087#1091#1089#1082#1072
            Options.Editing = False
            Width = 83
          end
          object DayCompensation: TcxGridDBColumn [112]
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1085'. '#1082#1086#1084#1087#1077#1085#1089'. '#1086#1090#1087#1091#1089#1082#1072
            DataBinding.FieldName = 'DayCompensation'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080' '#1086#1090#1087#1091#1089#1082#1072
            Options.Editing = False
            Width = 83
          end
          object InfoMoneyName_all: TcxGridDBColumn [113]
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'InfoMoneyName_all'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object DayWork: TcxGridDBColumn [114]
            Caption = #1056#1072#1073#1086#1095#1080#1093' '#1076#1085#1077#1081
            DataBinding.FieldName = 'DayWork'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object DayAudit: TcxGridDBColumn [115]
            Caption = #1044#1086#1087#1083'. '#1079#1072' '#1088#1077#1074#1080#1079#1080#1102', '#1076#1085'.'
            DataBinding.FieldName = 'DayAudit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1085#1077#1081' '#1076#1086#1087#1083#1072#1090#1072' '#1079#1072' '#1088#1077#1074#1080#1079#1080#1102
            Options.Editing = False
            Width = 70
          end
          object DaySkip: TcxGridDBColumn [116]
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1077' '#1079#1072' '#1087#1088#1086#1075#1091#1083', '#1076#1085
            DataBinding.FieldName = 'DaySkip'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1085#1077#1081' '#1091#1076#1077#1088#1078#1072#1085#1080#1081' '#1079#1072' '#1087#1088#1086#1075#1091#1083
            Options.Editing = False
            Width = 77
          end
          object DayMedicday: TcxGridDBColumn [117]
            Caption = #1044#1086#1087#1083'. '#1079#1072' '#1089#1072#1085#1086#1073#1088#1072#1073#1086#1090#1082#1091', '#1076#1085'.'
            DataBinding.FieldName = 'DayMedicday'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1085#1077#1081' '#1076#1086#1087#1083#1072#1090#1072' '#1079#1072' '#1089#1072#1085#1086#1073#1088#1072#1073#1086#1090#1082#1091
            Options.Editing = False
            Width = 70
          end
          object INN: TcxGridDBColumn
            Caption = #1048#1053#1053
            DataBinding.FieldName = 'INN'
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
            VisibleForCustomization = False
            Width = 70
          end
          object Amount_avance_ret: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090' '#1072#1074#1072#1085#1089', '#1075#1088#1085' ('#1076#1083#1103' '#1087#1077#1095#1072#1090#1080')'
            DataBinding.FieldName = 'Amount_avance_ret'
            Visible = False
            Width = 70
          end
          object AmountCash_print: TcxGridDBColumn
            Caption = #1050' '#1074#1099#1087#1083#1072#1090#1077' ('#1080#1079' '#1082#1072#1089#1089#1099') '#1076#1083#1103' '#1087#1077#1095#1072#1090#1080
            DataBinding.FieldName = 'AmountCash_print'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object SummNalog_print: TcxGridDBColumn
            Caption = '*'#1053#1072#1083#1086#1075#1080' - '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1089' '#1047#1055
            DataBinding.FieldName = 'SummNalog_print'
            Visible = False
            Options.Editing = False
            Width = 70
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 255
        Width = 1474
        Height = 161
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
          object cxKoeff: TcxGridDBColumn
            Caption = #1050#1086#1101#1092#1092'. '#1076#1083#1103' '#1084#1086#1076#1077#1083#1080' '#1088'.'#1074#1088'.'
            DataBinding.FieldName = 'Koeff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object cxRate: TcxGridDBColumn
            Caption = #1058#1072#1088#1080#1092
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
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
        Top = 250
        Width = 1474
        Height = 5
        AlignSplitter = salBottom
        Control = cxGrid1
      end
      object cxGrid2: TcxGrid
        Left = 0
        Top = 422
        Width = 1474
        Height = 138
        Align = alBottom
        PopupMenu = PopupMenu
        TabOrder = 3
        Visible = False
        object cxGridDBTableView2: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MessageDS
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
          OptionsData.Appending = True
          OptionsData.CancelOnExit = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object msOrd: TcxGridDBColumn
            Caption = #8470' '#1087'.'#1087'.'
            DataBinding.FieldName = 'Ord'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 25
          end
          object msisQuestion: TcxGridDBColumn
            Caption = #1054#1090#1087#1088'. '#1074#1086#1087#1088#1086#1089
            DataBinding.FieldName = 'isQuestion'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1074#1086#1087#1088#1086#1089
            Width = 43
          end
          object msisAnswer: TcxGridDBColumn
            Caption = #1054#1090#1087#1088'. '#1086#1090#1074#1077#1090
            DataBinding.FieldName = 'isAnswer'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1086#1090#1074#1077#1090
            Width = 42
          end
          object msisQuestionRead: TcxGridDBColumn
            Caption = #1055#1088#1086#1095'. '#1074#1086#1087#1088#1086#1089
            DataBinding.FieldName = 'isQuestionRead'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1086#1095#1080#1090#1072#1085' '#1074#1086#1087#1088#1086#1089
            Width = 43
          end
          object msisAnswerRead: TcxGridDBColumn
            Caption = #1055#1088#1086#1095'. '#1086#1090#1074#1077#1090
            DataBinding.FieldName = 'isAnswerRead'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1086#1095#1080#1090#1072#1085' '#1086#1090#1074#1077#1090
            Width = 42
          end
          object msOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' / '#1074#1088#1077#1084#1103' ('#1087#1088#1086#1095#1080#1090#1072#1085#1086')'
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object msUserName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1084#1091')'
            DataBinding.FieldName = 'UserName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actUserChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 114
          end
          object msComment: TcxGridDBColumn
            Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 602
          end
          object msInsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 97
          end
          object msUpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 97
          end
          object msUpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' / '#1074#1088#1077#1084#1103' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object msInsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' / '#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object msIsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'IsErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 294
          end
        end
        object cxGridLevel3: TcxGridLevel
          GridView = cxGridDBTableView2
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 416
        Width = 1474
        Height = 6
        Touch.ParentTabletOptions = False
        Touch.TabletOptions = [toPressAndHold]
        AlignSplitter = salBottom
        Control = cxGrid2
        Visible = False
      end
      object Panel1: TPanel
        Left = 0
        Top = 560
        Width = 1474
        Height = 60
        Align = alBottom
        Caption = 'Panel1'
        TabOrder = 5
        Visible = False
        object ExportXmlGrid: TcxGrid
          Left = 773
          Top = 1
          Width = 700
          Height = 58
          Align = alRight
          TabOrder = 1
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
              MinWidth = 120
              Width = 120
            end
          end
          object ExportXmlGridLevel: TcxGridLevel
            GridView = ExportXmlGridDBTableView
          end
        end
        object ExportXmlGrid_num: TcxGrid
          Left = 1
          Top = 1
          Width = 736
          Height = 58
          Align = alLeft
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          object cxGridDBTableView_num: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = ExportDS_num
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <>
            DataController.Summary.SummaryGroups = <>
            Images = dmMain.SortImageList
            OptionsBehavior.IncSearch = True
            OptionsCustomize.DataRowSizing = True
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
          object cxGridLevel4: TcxGridLevel
            GridView = cxGridDBTableView_num
          end
        end
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
        Width = 1474
        Height = 620
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
    object cxTabSheet1: TcxTabSheet
      Caption = #1044#1077#1090#1072#1083#1100#1085#1086
      ImageIndex = 2
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object cxGridChild_all: TcxGrid
        Left = 0
        Top = 0
        Width = 1474
        Height = 620
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 0
        object cxGridDBTableViewChild_all: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS_all
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_pg3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = MemberCount_pg3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DayCount_pg3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = HoursDay_pg3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = HoursPlan_pg3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Price_pg3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = WorkTimeHours_pg3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = WorkTimeHoursOne_pg3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = PersonalCount_pg3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = GrossOne_pg3
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = MemberCount_pg3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DayCount_pg3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = HoursDay_pg3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = HoursPlan_pg3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Price_pg3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = WorkTimeHours_pg3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = WorkTimeHoursOne_pg3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = PersonalCount_pg3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = GrossOne_pg3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_pg3
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = MemberName_pg3
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
          object UnitCode_pg3: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1076#1088'.'
            DataBinding.FieldName = 'UnitCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object UnitName_pg3: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object PositionName_pg3: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object MemberName_pg3: TcxGridDBColumn
            Caption = #1060#1080#1079'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'MemberName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 276
          end
          object PositionLevelName_pg3: TcxGridDBColumn
            Caption = #1056#1072#1079#1088#1103#1076' '#1076#1086#1083#1078#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'PositionLevelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object StaffListName_pg3: TcxGridDBColumn
            Caption = #1064#1090#1072#1090#1085#1086#1077' '#1088#1072#1089#1087#1080#1089#1072#1085#1080#1077
            DataBinding.FieldName = 'StaffListName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ModelServiceName_pg3: TcxGridDBColumn
            Caption = #1052#1086#1076#1077#1083#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'ModelServiceName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object StorageLineName_pg3: TcxGridDBColumn
            Caption = #1051#1080#1085#1080#1103' '#1087#1088'-'#1074#1072
            DataBinding.FieldName = 'StorageLineName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Amount_pg3: TcxGridDBColumn
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
          object MemberCount_pg3: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1083#1086#1074#1077#1082' ('#1074#1089#1077')'
            DataBinding.FieldName = 'MemberCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object StaffListSummKindName_pg3: TcxGridDBColumn
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
          object DayCount_pg3: TcxGridDBColumn
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
          object WorkTimeHoursOne_pg3: TcxGridDBColumn
            Caption = #1054#1090#1088#1072#1073'. '#1095#1072#1089#1086#1074' 1 '#1095#1077#1083
            DataBinding.FieldName = 'WorkTimeHoursOne'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object WorkTimeHours_pg3: TcxGridDBColumn
            Caption = #1054#1090#1088#1072#1073'. '#1095#1072#1089#1086#1074' ('#1074#1089#1077')'
            DataBinding.FieldName = 'WorkTimeHours'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Price_pg3: TcxGridDBColumn
            Caption = #1075#1088#1085'./'#1079#1072' '#1082#1075' '#1048#1051#1048' '#1075#1088#1085'./'#1089#1090#1072#1074#1082#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 81
          end
          object HoursPlan_pg3: TcxGridDBColumn
            Caption = #1054#1073#1097#1080#1081' '#1087#1083#1072#1085' '#1095#1072#1089#1086#1074' '#1074' '#1084#1077#1089#1103#1094' '#1085#1072' '#1095#1077#1083#1086#1074#1077#1082#1072
            DataBinding.FieldName = 'HoursPlan'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 97
          end
          object HoursDay_pg3: TcxGridDBColumn
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
          object PersonalCount_pg3: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1095#1077#1083#1086#1074#1077#1082
            DataBinding.FieldName = 'PersonalCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object GrossOne_pg3: TcxGridDBColumn
            Caption = #1041#1072#1079#1072' '#1085#1072' 1-'#1075#1086' '#1095#1077#1083', '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'GrossOne'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object isErased_pg3: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            Options.Editing = False
            Width = 50
          end
        end
        object cxGridLevelChild_all: TcxGridLevel
          GridView = cxGridDBTableViewChild_all
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1474
    Height = 89
    TabOrder = 3
    ExplicitWidth = 1474
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
      Top = 0
      Caption = #1052#1077#1089#1103#1094' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081
    end
    object edComment: TcxTextEdit
      Left = 708
      Top = 23
      TabOrder = 8
      Width = 251
    end
    object cxLabel12: TcxLabel
      Left = 708
      Top = 5
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
      Left = 288
      Top = 0
      Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100
    end
    object cxLabel4: TcxLabel
      Left = 520
      Top = 45
      Caption = #1070#1088'.'#1083#1080#1094#1086' ('#1089#1086#1094'.'#1074#1099#1087#1083#1072#1090#1099')'
    end
    object edJuridical: TcxButtonEdit
      Left = 520
      Top = 61
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 13
      Width = 182
    end
    object edIsAuto: TcxCheckBox
      Left = 182
      Top = 61
      Hint = #1057#1086#1079#1076#1072#1085' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' ('#1076#1072'/'#1085#1077#1090')'
      Caption = #1057#1086#1079#1076#1072#1085' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
      Properties.ReadOnly = True
      TabOrder = 14
      Width = 142
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
    object cbDetail: TcxCheckBox
      Left = 330
      Top = 61
      Hint = #1044#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103' '#1076#1072#1085#1085#1099#1093
      Caption = #1044#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 19
      Width = 92
    end
    object cbMail: TcxCheckBox
      Left = 1183
      Top = 88
      Hint = #1054#1090#1087#1088#1072#1074#1083#1077#1085' '#1087#1086' '#1087#1086#1095#1090#1077
      Caption = #1054#1090#1087#1088'. '#1087#1086' '#1087#1086#1095#1090#1077
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 20
      Width = 106
    end
    object cxLabel8: TcxLabel
      Left = 1077
      Top = 5
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object ceInfoMoney: TcxButtonEdit
      Left = 1077
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 22
      Width = 326
    end
    object edPriceNalog: TcxCurrencyEdit
      Left = 1077
      Top = 61
      EditValue = '0'
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = True
      TabOrder = 23
      Width = 79
    end
    object cxLabel9: TcxLabel
      Left = 1079
      Top = 43
      Caption = #1057#1090#1072#1074#1082#1072' '#1085#1072#1083#1086#1075#1072
    end
    object cxLabel30: TcxLabel
      Left = 1169
      Top = 43
      Caption = #1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103' '#1087#1086' '#1073#1072#1085#1082#1072#1084' '#1047#1055' - '#1060'2'
    end
    object edBankSecondNum: TcxButtonEdit
      Left = 1169
      Top = 61
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 26
      Width = 234
    end
  end
  object cxLabel5: TcxLabel [2]
    Left = 520
    Top = 5
    Caption = #1060#1080#1079'.'#1083#1080#1094#1086' ('#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100')'
  end
  object edMember: TcxButtonEdit [3]
    Left = 520
    Top = 23
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 182
  end
  object edBankOutDate: TcxDateEdit [4]
    Left = 429
    Top = 61
    EditValue = 44166d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 8
    Width = 81
  end
  object cxLabel7: TcxLabel [5]
    Left = 429
    Top = 43
    Caption = #1044#1072#1090#1072' '#1074#1099#1075#1088#1091#1079#1082#1080
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 299
    Top = 392
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 24
    Top = 224
  end
  inherited ActionList: TActionList
    object mactExportF2_Prior_xls: TMultiAction [0]
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
          Action = actExport_GridF2_prior_xls
        end
        item
          Action = actSMTPFileCSV
        end
        item
          Action = actUpdate_isMail
        end
        item
          Action = actRefreshGet
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
    object actGet_Export_EmailF2_prior_xls: TdsdExecStoredProc [1]
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_EmailF2_prior_xls
      StoredProcList = <
        item
          StoredProc = spGet_Export_EmailF2_prior_xls
        end>
      Caption = 'actGet_Export_EmailF2_xls'
      ImageIndex = 89
    end
    object actGet_Export_FileNameF2_prior_xls: TdsdExecStoredProc [2]
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_FileNameF2_prior_xls
      StoredProcList = <
        item
          StoredProc = spGet_Export_FileNameF2_prior_xls
        end>
      Caption = 'actGet_Export_FileNameF2_xls'
      ImageIndex = 89
    end
    object actSelect_ExportF2_prior_xls: TdsdExecStoredProc [3]
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect_ExportF2_prior_xls
      StoredProcList = <
        item
          StoredProc = spSelect_ExportF2_prior_xls
        end>
      Caption = 'actSelect_ExportCSVF2'
      ImageIndex = 89
    end
    object actExport_GridF2_prior_xls: TExportGrid [4]
      Category = 'Export_Email'
      MoveParams = <>
      Grid = ExportXmlGrid_num
      Caption = 'actExport_GridF2_xls'
      ImageIndex = 89
      OpenAfterCreate = False
      DefaultFileName = 'Report_'
      Separator = ';'
      DefaultFileExt = 'XLS'
    end
    object actGet_Export_EmailF2_xls: TdsdExecStoredProc [5]
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
    object actDoLoad_SMER: TExecuteImportSettingsAction [6]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId_SMER'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
    end
    object actGet_Export_FileNameF2_xls: TdsdExecStoredProc [7]
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
    object actExport_GridF2_xls: TExportGrid [8]
      Category = 'Export_Email'
      MoveParams = <>
      Grid = ExportXmlGrid
      Caption = 'actExport_GridF2_xls'
      OpenAfterCreate = False
      DefaultFileName = 'Report_'
      Separator = ';'
      DefaultFileExt = 'XLS'
    end
    object actGetImportSettingCompens: TdsdExecStoredProc [9]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingComp
      StoredProcList = <
        item
          StoredProc = spGetImportSettingComp
        end>
      Caption = 'actGetImportSetting'
    end
    object actSelect_ExportF2_xls: TdsdExecStoredProc [10]
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect_ExportF2_xls
      StoredProcList = <
        item
          StoredProc = spSelect_ExportF2_xls
        end>
      Caption = 'actSelect_ExportCSVF2'
    end
    object mactExportF2_xls: TMultiAction [11]
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
          Action = actRefreshGet
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' XLS - '#8470' '#1082#1072#1088#1090#1099' '#1060'2 '#1076#1086#1082#1091#1084#1077#1085#1090' '#1087#1086 +
        ' '#1087#1086#1095#1090#1077'?'
      InfoAfterExecute = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' XLS - '#8470' '#1082#1072#1088#1090#1099' '#1060'2 '#1091#1089#1087#1077#1096#1085#1086' '#1086#1090#1087#1088#1072#1074#1083#1077#1085' '#1087#1086' '#1087#1086#1095#1090#1077
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' XLS - '#8470' '#1082#1072#1088#1090#1099' '#1060'2'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' XLS - '#8470' '#1082#1072#1088#1090#1099' '#1060'2'
      ImageIndex = 53
    end
    object actUpdateCardSecond4000: TdsdExecStoredProc [12]
      Category = 'Update'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CardSecond4000
      StoredProcList = <
        item
          StoredProc = spUpdate_CardSecond4000
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1072#1089#1089#1072') - 2'#1092'. (>=4000)'
    end
    object actGet_Export_EmailCSVF2: TdsdExecStoredProc [13]
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_EmailCSVF2
      StoredProcList = <
        item
          StoredProc = spGet_Export_EmailCSVF2
        end>
      Caption = 'actGet_Export_EmailCSVF2'
    end
    object actGet_Export_FileNameCSVF2: TdsdExecStoredProc [14]
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_FileNameCSVF2
      StoredProcList = <
        item
          StoredProc = spGet_Export_FileNameCSVF2
        end>
      Caption = 'actGet_Export_FileNameCSVF2'
    end
    object actGetImportSettingAvance: TdsdExecStoredProc [15]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingAvance
      StoredProcList = <
        item
          StoredProc = spGetImportSettingAvance
        end>
      Caption = 'actGetImportSetting'
    end
    object actPrint_Num: TdsdPrintAction [16]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint_Num
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Num
        end>
      Caption = #1055#1077#1095#1072#1090#1100' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1087#1086' '#1079#1087' ('#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1087#1086' '#1073#1072#1085#1082#1072#1084')>'
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
      ReportNameParam.Name = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081'_'#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1087#1086' '#1073#1072#1085#1082#1072#1084
      ReportNameParam.Value = 'PrintMovement_PersonalServiceNum'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Grid_new: TdsdPrintAction [17]
      Category = 'Print_grid'
      MoveParams = <>
      StoredProc = spSelectPrint_grid
      StoredProcList = <
        item
          StoredProc = spSelectPrint_grid
        end>
      Caption = #1055#1077#1095#1072#1090#1100' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
      Hint = #1055#1077#1095#1072#1090#1100' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'>'
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
    object actSelect_ExportCSVF2: TdsdExecStoredProc [18]
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect_ExportCSVF2
      StoredProcList = <
        item
          StoredProc = spSelect_ExportCSVF2
        end>
      Caption = 'actSelect_ExportCSVF2'
    end
    object actDoLoad_Compens: TExecuteImportSettingsAction [19]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
    end
    object actRefresh_Message: TdsdDataSetRefresh [20]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectMIMessage
      StoredProcList = <
        item
          StoredProc = spSelectMIMessage
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object mactExportCSVF2: TMultiAction [21]
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
          Action = actRefreshGet
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081'  CSV - '#8470' '#1082#1072#1088#1090#1099' '#1060'2 '#1076#1086#1082#1091#1084#1077#1085#1090' '#1087 +
        #1086' '#1087#1086#1095#1090#1077'?'
      InfoAfterExecute = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' CSV - '#8470' '#1082#1072#1088#1090#1099' '#1060'2 '#1091#1089#1087#1077#1096#1085#1086' '#1086#1090#1087#1088#1072#1074#1083#1077#1085' '#1087#1086' '#1087#1086#1095#1090#1077
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' CSV - '#8470' '#1082#1072#1088#1090#1099' '#1060'2'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' CSV - '#8470' '#1082#1072#1088#1090#1099' '#1060'2'
      ImageIndex = 53
    end
    object actRefreshMaster: TdsdDataSetRefresh [22]
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
    object actDoLoad_Avance: TExecuteImportSettingsAction [23]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = '0'
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
    end
    object macLoad_Compens: TMultiAction [24]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingCompens
        end
        item
          Action = actDoLoad_Compens
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1102' '#1086#1090#1087#1091#1089#1082#1072' '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080' '#1086#1090#1087#1091#1089#1082#1072' '#1080#1079' '#1092#1072#1081#1083#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1102' '#1086#1090#1087#1091#1089#1082#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1050#1086#1084#1087#1077#1085#1089#1072#1094#1080#1102' '#1086#1090#1087#1091#1089#1082#1072
      ImageIndex = 74
      WithoutNext = True
    end
    object actExportToFileZpDate: TdsdStoredProcExportToFile [25]
      Category = 'Export'
      MoveParams = <>
      dsdStoredProcName = spSelectExportDate
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
      Left = 1216
      Top = 168
    end
    object actRefresh_Sign: TdsdDataSetRefresh [26]
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
    object actGetImportSettingSS: TdsdExecStoredProc [27]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingSummService
      StoredProcList = <
        item
          StoredProc = spGetImportSettingSummService
        end>
      Caption = 'actGetImportSetting'
    end
    object actDoLoad_SS: TExecuteImportSettingsAction [28]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId_SS'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
    end
    object macLoad_Avance: TMultiAction [29]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingAvance
        end
        item
          Action = actDoLoad_Avance
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1040#1074#1072#1085#1089' '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1040#1074#1072#1085#1089#1072' '#1080#1079' '#1092#1072#1081#1083#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1040#1074#1072#1085#1089
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1040#1074#1072#1085#1089
      ImageIndex = 81
      WithoutNext = True
    end
    object actExportZPDate: TMultiAction [30]
      Category = 'Export'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_FileNameZp
        end
        item
          Action = actExportToFileZpDate
        end>
      Caption = 
        #1069#1082#1089#1087#1086#1088#1090' '#1085#1072' '#1076#1072#1090#1091' '#1042#1099#1075#1088#1091#1079#1082#1080' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1047#1055' '#1085#1072' '#1082#1072#1088#1090#1086#1095#1082#1091' '#1076#1083#1103 +
        ' "'#1042#1054#1057#1058#1054#1050'" '#1080#1083#1080' "'#1054#1058#1055'"'
      Hint = 
        #1069#1082#1089#1087#1086#1088#1090' '#1085#1072' '#1076#1072#1090#1091' '#1042#1099#1075#1088#1091#1079#1082#1080' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1047#1055' '#1085#1072' '#1082#1072#1088#1090#1086#1095#1082#1091' '#1076#1083#1103 +
        ' "'#1042#1054#1057#1058#1054#1050'" '#1080#1083#1080' "'#1054#1058#1055'"'
      ImageIndex = 67
    end
    object actGetImportSetting_SMER: TdsdExecStoredProc [31]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSetting_SMER
      StoredProcList = <
        item
          StoredProc = spGetImportSetting_SMER
        end>
      Caption = 'actGetImportSetting'
    end
    object actDoLoad_fine: TExecuteImportSettingsAction [32]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'InMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actRefreshGet: TdsdDataSetRefresh [33]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object macStartLoad_SMER: TMultiAction [34]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_SMER
        end
        item
          Action = actDoLoad_SMER
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1059#1076#1077#1088#1078#1072#1085#1080#1103' '#1089#1090#1086#1088#1086#1085'. '#1102#1088'.'#1083'.('#1074#1074#1086#1076') '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1080#1079' '#1092#1072#1081#1083#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1059#1076#1077#1088#1078#1072#1085#1080#1103' '#1089#1090#1086#1088#1086#1085'. '#1102#1088'.'#1083'.('#1074#1074#1086#1076') '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1059#1076#1077#1088#1078#1072#1085#1080#1103' '#1089#1090#1086#1088#1086#1085'. '#1102#1088'.'#1083'.('#1074#1074#1086#1076')  '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 82
      WithoutNext = True
    end
    object macStartLoad: TMultiAction [35]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_mm
        end
        item
          Action = actDoLoad_mm
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1080#1079' '#1092#1072#1081#1083#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 41
      WithoutNext = True
    end
    object actGetImportSetting: TdsdExecStoredProc [36]
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
    object macStartLoad_SS: TMultiAction [37]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingSS
        end
        item
          Action = actDoLoad_SS
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1042#1099#1082#1091#1087' '#1087#1088#1086#1076#1091#1082#1094#1080#1080' '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1042#1099#1082#1091#1087' '#1087#1088#1086#1076#1091#1082#1094#1080#1080' '#1080#1079' '#1092#1072#1081#1083#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1042#1099#1082#1091#1087' '#1087#1088#1086#1076#1091#1082#1094#1080#1080
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1042#1099#1082#1091#1087' '#1087#1088#1086#1076#1091#1082#1094#1080#1080
      ImageIndex = 50
      WithoutNext = True
    end
    object actGridToExcel_Child_all: TdsdGridToExcel [38]
      Category = 'DSDLib'
      TabSheet = cxTabSheet1
      MoveParams = <>
      Enabled = False
      Grid = cxGridChild_all
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel ('#1076#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103')'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel ('#1076#1077#1090#1072#1083#1080#1079#1072#1094#1080#1103')'
      ImageIndex = 6
      ShortCut = 16472
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
        end
        item
          StoredProc = spSelectChild_all
        end>
      RefreshOnTabSetChanges = True
    end
    object actGridToExcel_Child: TdsdGridToExcel [41]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Grid = cxGrid1
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel ('#1044#1077#1090#1072#1083#1100#1085#1086')'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel ('#1044#1077#1090#1072#1083#1100#1085#1086')'
      ImageIndex = 6
      ShortCut = 16440
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
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end
        item
          StoredProc = spGet
        end>
    end
    inherited actShowErased: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectChild
        end>
    end
    object macUpdateCardSecond4000: TMultiAction [47]
      Category = 'Update'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateCardSecond4000
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'. (>=4000)' +
        '?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '#1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'. (>=4000)'
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'. (>=4000)'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'. (>=4000)'
      ImageIndex = 74
    end
    object actUpdateIsMain: TdsdExecStoredProc [48]
      Category = 'Update'
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
    object actPrint_Detail: TdsdPrintAction [50]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintDetail
      StoredProcList = <
        item
          StoredProc = spSelectPrintDetail
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
      ReportNameParam.Name = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081
      ReportNameParam.Value = 'PrintMovement_PersonalServiceDetail'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_All: TdsdPrintAction [51]
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
    object actPrint_Grid: TdsdPrintAction [53]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'> '#1074#1099#1073#1086#1088#1086#1095#1085#1086
      Hint = #1086#1096#1080#1073#1082#1072
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          GridView = cxGridDBTableView
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
          Name = 'ServiceDate'
          Value = Null
          Component = edServiceDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalServiceListName'
          Value = Null
          Component = GuidesPersonalServiceList
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          Component = edInvNumber
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AuditColumnName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AuditColumnName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_PersonalServiceGrid'
      ReportNameParam.Value = 'PrintMovement_PersonalServiceGrid'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spGet
        end>
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
    object MI_ChildProtocolOpenForm: TdsdOpenForm [59]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1077#1090#1072#1083#1080#1079#1072#1094#1080#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1077#1090#1072#1083#1080#1079#1072#1094#1080#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'MemberName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUnitFineSubjectChoiceForm: TOpenChoiceForm [61]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'UnitFineSubjectForm'
      FormName = 'TUnit_ObjectForm'
      FormNameParam.Value = 'TUnit_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitFineSubjectId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitFineSubjectName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actFineSubjectOpenChoiceForm: TOpenChoiceForm [64]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'FineSubjectForm'
      FormName = 'TFineSubjectForm'
      FormNameParam.Value = 'TFineSubjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FineSubjectId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FineSubjectName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    inherited actAddMask: TdsdExecStoredProc
      TabSheet = tsMain
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
          Component = MessageDCS
          ComponentItem = 'UserId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MessageDCS
          ComponentItem = 'UserName'
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
          Component = MessageDCS
          ComponentItem = 'isAnswer'
          DataType = ftBoolean
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
      Category = 'Update'
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
      Category = 'Update'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMask
      StoredProcList = <
        item
          StoredProc = spUpdateMask
        end>
      Caption = 'actUpdateMask'
    end
    object actInsertUpdate_byMemberMinus: TdsdExecStoredProc
      Category = 'Update'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_byMemberMinus
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_byMemberMinus
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1091#1076#1077#1088#1078#1072#1085#1080#1103
    end
    object macUpdate_Compensation: TMultiAction
      Category = 'Update'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_Compensation
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' c'#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1102' '#1079#1072' '#1085#1077#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1085#1099#1081' '#1086#1090#1087#1091#1089 +
        #1082'.?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1072' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1103' '#1079#1072' '#1085#1077#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1085#1099#1081' '#1086#1090#1087#1091#1089#1082
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1102' '#1079#1072' '#1085#1077#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1085#1099#1081' '#1086#1090#1087#1091#1089#1082
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1102' '#1079#1072' '#1085#1077#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1085#1099#1081' '#1086#1090#1087#1091#1089#1082
      ImageIndex = 56
    end
    object actUpdate_Compensation: TdsdExecStoredProc
      Category = 'Update'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Compensation
      StoredProcList = <
        item
          StoredProc = spUpdate_Compensation
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1102' '#1079#1072' '#1085#1077#1080#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1085#1099#1081' '#1086#1090#1087#1091#1089#1082
    end
    object macUpdateCardSecond_num: TMultiAction
      Category = 'Update'
      MoveParams = <>
      ActionList = <
        item
          Action = actOpenBankSecondNumForm
        end
        item
          Action = actUpdateCardSecond_num
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1087#1086' '#1073#1072#1085#1082#1072#1084' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086 +
        #1076') - 2'#1092'.?'
      InfoAfterExecute = 
        #1059#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1086' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1087#1086' '#1073#1072#1085#1082#1072#1084' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2' +
        #1092'.'
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1087#1086' '#1073#1072#1085#1082#1072#1084' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'.'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1087#1086' '#1073#1072#1085#1082#1072#1084' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'.'
      ImageIndex = 89
    end
    object actOpenBankSecondNumForm: TdsdOpenForm
      Category = 'Update'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103' '#1087#1086' '#1073#1072#1085#1082#1072#1084' '#1047#1055' - '#1060'2>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1080#1086#1088#1080#1090#1077#1090' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103' '#1087#1086' '#1073#1072#1085#1082#1072#1084' '#1047#1055' - '#1060'2>'
      ImageIndex = 89
      FormName = 'TBankSecondNumForm'
      FormNameParam.Value = 'TBankSecondNumForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = ''
          Component = GuidesBankSecondNum
          ComponentItem = 'Key'
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
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_PersonalService'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateCardSecond_num: TdsdExecStoredProc
      Category = 'Update'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CardSecond_num
      StoredProcList = <
        item
          StoredProc = spUpdate_CardSecond_num
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1087#1086' '#1073#1072#1085#1082#1072#1084' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'.'
    end
    object macUpdateCardSecond: TMultiAction
      Category = 'Update'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateCardSecond
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'.?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '#1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'.'
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'.'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'.'
      ImageIndex = 74
    end
    object actUpdateCardSecond: TdsdExecStoredProc
      Category = 'Update'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CardSecond
      StoredProcList = <
        item
          StoredProc = spUpdate_CardSecond
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'.'
    end
    object macUpdateCardSecondCash: TMultiAction
      Category = 'Update'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateCardSecondCash
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1072#1089#1089#1072') - 2'#1092'.?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '#1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1072#1089#1089#1072') - 2'#1092'.'
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1072#1089#1089#1072') - 2'#1092'.'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1072#1089#1089#1072') - 2'#1092'.'
      ImageIndex = 27
    end
    object actUpdateCardSecondCash: TdsdExecStoredProc
      Category = 'Update'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CardSecondCash
      StoredProcList = <
        item
          StoredProc = spUpdate_CardSecondCash
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1072#1089#1089#1072') - 2'#1092'.'
    end
    object actUpdateSummNalogRet: TdsdExecStoredProc
      Category = 'Update'
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
      Category = 'Update'
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
      InfoAfterExecute = 
        #1059#1089#1087#1077#1096#1085#1086' '#1079#1072#1087#1086#1083#1085#1077#1085#1099' "'#1053#1072#1083#1086#1075#1080' - '#1074#1086#1079#1084#1077#1097'. '#1082' '#1047#1055'" '#1087#1086' "'#1053#1072#1083#1086#1075#1080' - '#1091#1076#1077#1088#1078'. '#1089' ' +
        #1047#1055'"'
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' "'#1053#1072#1083#1086#1075#1080' - '#1074#1086#1079#1084#1077#1097'. '#1082' '#1047#1055'" '#1087#1086' "'#1053#1072#1083#1086#1075#1080' - '#1091#1076#1077#1088#1078'. '#1089' '#1047#1055'"'
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' "'#1053#1072#1083#1086#1075#1080' - '#1074#1086#1079#1084#1077#1097'. '#1082' '#1047#1055'" '#1087#1086' "'#1053#1072#1083#1086#1075#1080' - '#1091#1076#1077#1088#1078'. '#1089' '#1047#1055'"'
      ImageIndex = 39
    end
    object macUpdateNalogRetSimpl: TMultiAction
      Category = 'Update'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateSummNalogRet
        end>
      View = cxGridDBTableView
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' "'#1053#1072#1083#1086#1075#1080' - '#1074#1086#1079#1084#1077#1097'. '#1082' '#1047#1055'" '#1087#1086' "'#1053#1072#1083#1086#1075#1080' - '#1091#1076#1077#1088#1078'. '#1089' '#1047#1055'"'
      ImageIndex = 39
    end
    object actOpenProtocolPersonal: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' <'#1057#1086#1090#1088#1091#1076#1085#1080#1082'>'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
    object actUpdateDataSetMessage: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIMessage
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMessage
        end
        item
          StoredProc = spSelectMIMessage
        end>
      Caption = 'actUpdateDataSetMessage'
      DataSource = MessageDS
    end
    object actSelect_Export: TdsdExecStoredProc
      Category = 'Sign'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect_Export
      StoredProcList = <
        item
          StoredProc = spSelect_Export
        end>
      Caption = 'actSelect_Export'
    end
    object actExport_Grid: TExportGrid
      Category = 'Export_file'
      MoveParams = <>
      ExportType = cxegExportToText
      Grid = ExportXmlGrid
      Caption = 'actExport_Grid'
      OpenAfterCreate = False
      DefaultFileName = 'PersonalService_Child'
      DefaultFileExt = 'XML'
      EncodingANSI = True
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
    object actExport: TMultiAction
      Category = 'Export_file'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_FileNameOld
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
    object actGet_Export_FileNameOld: TdsdExecStoredProc
      Category = 'Export_file'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_FileName1
      StoredProcList = <
        item
          StoredProc = spGet_Export_FileName1
        end>
      Caption = 'actGet_Export_FileNameOld'
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
      Left = 1112
      Top = 240
    end
    object actGet_Export_FileNameZp: TdsdExecStoredProc
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
    object actExportZP: TMultiAction
      Category = 'Export'
      MoveParams = <>
      PostDataSetBeforeExecute = False
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
      Left = 1144
      Top = 272
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
    object macInsertUpdate_byMemberMinus: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdate_byMemberMinus
        end
        item
          Action = actRefreshMaster
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1091#1076#1077#1088#1078#1072#1085#1080#1103
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1091#1076#1077#1088#1078#1072#1085#1080#1103
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
          Action = actRefreshGet
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' CSV '#1076#1086#1082#1091#1084#1077#1085#1090' '#1087#1086' '#1087#1086#1095#1090#1077'?'
      InfoAfterExecute = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' CSV '#1091#1089#1087#1077#1096#1085#1086' '#1086#1090#1087#1088#1072#1074#1083#1077#1085' '#1087#1086' '#1087#1086#1095#1090#1077
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' CSV '#1087#1086' '#1087#1086#1095#1090#1077
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' CSV '#1087#1086' '#1087#1086#1095#1090#1077
      ImageIndex = 53
    end
    object actDoLoad_mm: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId_mm'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'InMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actGetImportSetting_mm: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSetting_mm
      StoredProcList = <
        item
          StoredProc = spGetImportSetting_mm
        end>
      Caption = 'actGetImportSetting'
    end
    object macStartLoad_mm: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_mm
        end
        item
          Action = actDoLoad_mm
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1080#1079' '#1092#1072#1081#1083#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 41
      WithoutNext = True
    end
    object actInsertUpdate_MemberMinus: TdsdExecStoredProc
      Category = 'Update'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_MemberMinus
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_MemberMinus
        end>
      Caption = 'actInsertUpdate_MemberMinus'
      ImageIndex = 60
    end
    object macInsertUpdate_MemberMinus: TMultiAction
      Category = 'Update'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdate_MemberMinus
        end>
      QuestionBeforeExecute = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1059#1076#1077#1088#1078#1072#1085#1080#1103' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1074#1099#1075#1088#1091#1078#1077#1085#1099
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1059#1076#1077#1088#1078#1072#1085#1080#1103' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
      ImageIndex = 60
    end
    object actOpenProtocolMember: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' <'#1060#1080#1079'.'#1083#1080#1094#1086'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' <'#1060#1080#1079'.'#1083#1080#1094#1086'>'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberId_Personal'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actGet_Export_FileNameZp_dbf: TdsdExecStoredProc
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
    object actExport_dbf: TdsdStoredProcExportToFile
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
      FieldDefs = <>
      Left = 1192
      Top = 216
    end
    object macExport_dbf: TMultiAction
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
    object actOpenReportRecalcForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1085#1080#1103#1084' ('#1076#1083#1103' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1047#1055')>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1086' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1085#1080#1103#1084' ('#1076#1083#1103' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1047#1055')>'
      ImageIndex = 24
      FormName = 'TReport_PersonalService_RecalcForm'
      FormNameParam.Value = 'TReport_PersonalService_RecalcForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inPersonalServiceListId'
          Value = ''
          Component = GuidesPersonalServiceList
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPersonalServiceListName'
          Value = ''
          Component = GuidesPersonalServiceList
          ComponentItem = 'TextValue'
          DataType = ftString
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
          Name = 'inServiceDate'
          Value = 42181d
          Component = edServiceDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'fff'
          Value = 42181d
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'fff'
          Value = ''
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'fff'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object ExecuteDialogPeriod: TExecuteDialog
      Category = 'InsertAvance'
      MoveParams = <>
      Caption = 'actDatePeriodDialog'
      FormName = 'TDatePeriodDialogForm'
      FormNameParam.Value = 'TDatePeriodDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inStartDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'inStartDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = #1050#1086#1083'-'#1074#1086' '#1079#1085#1072#1082#1086#1074' '#1076#1083#1103' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1103
          Component = FormParams
          ComponentItem = 'inEndDate'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actInsertUpdate_Avance: TdsdExecStoredProc
      Category = 'InsertAvance'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_Avance
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_Avance
        end>
      Caption = 'actInsertUpdate_Avance'
    end
    object macInsertUpdate_AvanceAuto: TMultiAction
      Category = 'InsertAvance'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogPeriod
        end
        item
          Action = actInsertUpdate_Avance
        end
        item
          Action = actRefreshMaster
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1088#1086#1089#1090#1072#1074#1080#1090#1100' '#1089#1091#1084#1084#1091' '#1072#1074#1072#1085#1089#1072' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080'?'
      InfoAfterExecute = #1057#1091#1084#1084#1072' '#1072#1074#1072#1085#1089#1072' '#1079#1072#1087#1086#1083#1085#1077#1085#1072' '
      Caption = #1055#1088#1086#1089#1090#1072#1074#1080#1090#1100' '#1089#1091#1084#1084#1091' '#1072#1074#1072#1085#1089#1072' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
      Hint = #1055#1088#1086#1089#1090#1072#1074#1080#1090#1100' '#1089#1091#1084#1084#1091' '#1072#1074#1072#1085#1089#1072' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
      ImageIndex = 45
    end
    object actGetImportSetting_fine: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSetting_fine
      StoredProcList = <
        item
          StoredProc = spGetImportSetting_fine
        end>
      Caption = 'actGetImportSetting'
    end
    object macStartLoad_fine: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_fine
        end
        item
          Action = actDoLoad_fine
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1064#1090#1088#1072#1092#1099' '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1080#1079' '#1092#1072#1081#1083#1072' '#1079#1072#1074#1077#1088#1096#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1064#1090#1088#1072#1092#1099'  '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1064#1090#1088#1072#1092#1099'  '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 41
      WithoutNext = True
    end
    object macUpdate_PriceNalog: TMultiAction
      Category = 'Update'
      MoveParams = <>
      ActionList = <
        item
          Action = actPriceNalogDialog
        end
        item
          Action = actUpdate_PriceNalog
        end
        item
          Action = actRefreshMaster
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1087#1086#1083#1085#1080#1090#1100' '#1085#1072#1083#1086#1075#1080' '#1060'2?'
      InfoAfterExecute = #1053#1072#1083#1086#1075#1080' '#1079#1072#1087#1086#1083#1085#1077#1085#1099
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1085#1072#1083#1086#1075#1080' '#1060'2'
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1085#1072#1083#1086#1075#1080' '#1060'2'
      ImageIndex = 43
    end
    object actPriceNalogDialog: TExecuteDialog
      Category = 'Update'
      MoveParams = <>
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1085#1072#1083#1086#1075#1080
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1085#1072#1083#1086#1075#1080
      ImageIndex = 35
      FormName = 'TPriceNalogDialogForm'
      FormNameParam.Value = 'TPriceNalogDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = 42736d
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PriceNalog'
          Value = 42736d
          Component = edPriceNalog
          DataType = ftFloat
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_PriceNalog: TdsdExecStoredProc
      Category = 'Update'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_PriceNalog
      StoredProcList = <
        item
          StoredProc = spUpdate_PriceNalog
        end>
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
          Value = 41640d
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
    object actDelete_Object_Print: TdsdExecStoredProc
      Category = 'Print_grid'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDelete_Object_Print
      StoredProcList = <
        item
          StoredProc = spDelete_Object_Print
        end>
      Caption = #1091#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1075#1088#1080#1076#1072' '#1076#1083#1103' '#1087#1077#1095#1072#1090#1080
      ImageIndex = 74
    end
    object actPrint_byGrid: TdsdExecStoredProc
      Category = 'Print_grid'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertPrint_byGrid
      StoredProcList = <
        item
          StoredProc = spInsertPrint_byGrid
        end>
      Caption = #1089#1086#1093#1088#1072#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1075#1088#1080#1076#1072' '#1076#1083#1103' '#1087#1077#1095#1072#1090#1080
      ImageIndex = 74
    end
    object actPrint_byGrid_list: TMultiAction
      Category = 'Print_grid'
      MoveParams = <>
      ActionList = <
        item
          Action = actPrint_byGrid
        end>
      View = cxGridDBTableView
      Caption = 'actPrint_byGrid_list'
      ImageIndex = 74
    end
    object macPrint_grid_new: TMultiAction
      Category = 'Print_grid'
      MoveParams = <>
      ActionList = <
        item
          Action = actDelete_Object_Print
        end
        item
          Action = actPrint_byGrid_list
        end
        item
          Action = actPrint_Grid_new
        end>
      Caption = #1055#1077#1095#1072#1090#1100' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'> '#1074#1099#1073#1086#1088#1086#1095#1085#1086' '
      Hint = #1055#1077#1095#1072#1090#1100' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'> '#1074#1099#1073#1086#1088#1086#1095#1085#1086
      ImageIndex = 3
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
          ItemName = 'bbAddMask'
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
          BeginGroup = True
          Visible = True
          ItemName = 'bbSubPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertData'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbLoad'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbExportSub'
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
          ItemName = 'bbOpenReportRecalcForm'
        end
        item
          Visible = True
          ItemName = 'bbReport_Open'
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
          ItemName = 'bbMI_ChildProtocolOpenForm'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenProtocolPersonal'
        end
        item
          Visible = True
          ItemName = 'bbOpenProtocolMember'
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
          ItemName = 'bbGridToExcel_Child_all'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel_Child'
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
    object bbUpdateSummNalogRet: TdxBarButton
      Action = macUpdateSummNalogRet
      Category = 0
    end
    object bbPrint_Child: TdxBarButton
      Action = actPrint_Detail
      Category = 0
    end
    object bbUpdate_Compensation: TdxBarButton
      Action = macUpdate_Compensation
      Category = 0
    end
    object bbExport: TdxBarButton
      Action = actExport
      Category = 0
    end
    object bbExportZP: TdxBarButton
      Action = actExportZP
      Category = 0
    end
    object bbmacInsertUpdate_byMemberMinus: TdxBarButton
      Action = macInsertUpdate_byMemberMinus
      Category = 0
      ImageIndex = 43
    end
    object bbExportZPDate: TdxBarButton
      Action = actExportZPDate
      Category = 0
    end
    object bbGridToExcel_Child_all: TdxBarButton
      Action = actGridToExcel_Child_all
      Category = 0
    end
    object bbExportCSV: TdxBarButton
      Action = mactExportCSV
      Category = 0
    end
    object bbStartLoad_mm: TdxBarButton
      Action = macStartLoad_mm
      Category = 0
    end
    object bbInsertUpdate_MemberMinus: TdxBarButton
      Action = macInsertUpdate_MemberMinus
      Category = 0
    end
    object bbStartLoad_SMER: TdxBarButton
      Action = macStartLoad_SMER
      Category = 0
    end
    object bbOpenProtocolMember: TdxBarButton
      Action = actOpenProtocolMember
      Category = 0
    end
    object bbOpenProtocolPersonal: TdxBarButton
      Action = actOpenProtocolPersonal
      Category = 0
    end
    object bbStartLoad_SS: TdxBarButton
      Action = macStartLoad_SS
      Category = 0
    end
    object bbLoad: TdxBarSubItem
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbLoadExcel'
        end
        item
          Visible = True
          ItemName = 'bbmacInsertUpdate_byMemberMinus'
        end
        item
          Visible = True
          ItemName = 'bbStartLoad_mm'
        end
        item
          Visible = True
          ItemName = 'bbStartLoad_SMER'
        end
        item
          Visible = True
          ItemName = 'bbStartLoad_SS'
        end
        item
          Visible = True
          ItemName = 'bbLoad_Avance'
        end
        item
          Visible = True
          ItemName = 'bbLoad_Compens'
        end
        item
          Visible = True
          ItemName = 'bbStartLoad_fine'
        end>
    end
    object bbLoad_Avance: TdxBarButton
      Action = macLoad_Avance
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1089#1091#1084#1084#1091' '#1040#1074#1072#1085#1089#1072' '#1080#1079' '#1092#1072#1081#1083#1072
      Category = 0
    end
    object bbExport_dbf: TdxBarButton
      Action = macExport_dbf
      Category = 0
    end
    object bbSubPrint: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Visible = ivAlways
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
          ItemName = 'bbPrint_Num'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrintGridNew'
        end>
    end
    object bbInsertData: TdxBarSubItem
      Caption = #1060#1086#1088#1084'.'#1076#1072#1085#1085#1099#1093
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbUpdateCardSecondCash'
        end
        item
          Visible = True
          ItemName = 'bbUpdateCardSecond'
        end
        item
          Visible = True
          ItemName = 'bbUpdateCardSecond_num'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbUpdateSummNalogRet'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Compensation'
        end
        item
          Visible = True
          ItemName = 'bbnsertUpdate_AvanceAuto'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_PriceNalog'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbUpdateCardSecond4000'
        end>
    end
    object bbExportSub: TdxBarSubItem
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdate_MemberMinus'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbExportZP'
        end
        item
          Visible = True
          ItemName = 'bbExport_dbf'
        end
        item
          Visible = True
          ItemName = 'bbExportZPDate'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbExport'
        end
        item
          Visible = True
          ItemName = 'bbExportCSV'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbExportCSVF2'
        end
        item
          Visible = True
          ItemName = 'bbExportCSVF2_xls'
        end
        item
          Visible = True
          ItemName = 'bbExportF2_Prior_xls'
        end>
    end
    object bbOpenReportRecalcForm: TdxBarButton
      Action = actOpenReportRecalcForm
      Category = 0
    end
    object bbnsertUpdate_AvanceAuto: TdxBarButton
      Action = macInsertUpdate_AvanceAuto
      Category = 0
    end
    object bbLoad_Compens: TdxBarButton
      Action = macLoad_Compens
      Category = 0
    end
    object bbStartLoad_fine: TdxBarButton
      Action = macStartLoad_fine
      Category = 0
      ImageIndex = 85
    end
    object bbUpdate_PriceNalog: TdxBarButton
      Action = macUpdate_PriceNalog
      Category = 0
    end
    object bbGridToExcel_Child: TdxBarButton
      Action = actGridToExcel_Child
      Category = 0
    end
    object bbExportCSVF2: TdxBarButton
      Action = mactExportCSVF2
      Category = 0
    end
    object bbSeparator: TdxBarSeparator
      Caption = 'Separator'
      Category = 0
      Hint = 'Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbExportCSVF2_xls: TdxBarButton
      Action = mactExportF2_xls
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090'  XLS - '#8470' '#1082#1072#1088#1090#1099' '#1060'2'
      Category = 0
    end
    object bbUpdateCardSecond4000: TdxBarButton
      Action = macUpdateCardSecond4000
      Category = 0
    end
    object bbUpdateCardSecond_num: TdxBarButton
      Action = macUpdateCardSecond_num
      Category = 0
    end
    object bbOpenBankSecondNumForm: TdxBarButton
      Action = actOpenBankSecondNumForm
      Category = 0
    end
    object bbExportF2_Prior_xls: TdxBarButton
      Action = mactExportF2_Prior_xls
      Category = 0
    end
    object bbReport_Open: TdxBarButton
      Action = actReport_Open
      Category = 0
    end
    object bbPrint_Num: TdxBarButton
      Action = actPrint_Num
      Category = 0
    end
    object bbPrint_Grid: TdxBarButton
      Action = actPrint_Grid
      Category = 0
    end
    object bbPrintGridNew: TdxBarButton
      Action = macPrint_grid_new
      Category = 0
    end
    object bbMI_ChildProtocolOpenForm: TdxBarButton
      Action = MI_ChildProtocolOpenForm
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
      end
      item
        Name = 'ImportSettingId_mm'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId_SMER'
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
        Value = Null
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
      end
      item
        Name = 'MemberId'
        Value = Null
        Component = GuidesMember
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = Null
        Component = GuidesMember
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummCardRecalc'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSummCardRecalc'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = Null
        Component = edBankOutDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDetail'
        Value = Null
        Component = cbDetail
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMail'
        Value = Null
        Component = cbMail
        DataType = ftBoolean
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
        Name = 'InfoMoneyName_all'
        Value = Null
        Component = GuidesInfoMoney
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceNalog'
        Value = Null
        Component = edPriceNalog
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_BankSecondNum'
        Value = Null
        Component = GuidesBankSecondNum
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_BankSecondNum'
        Value = Null
        Component = GuidesBankSecondNum
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AuditColumnName'
        Value = Null
        Component = FormParams
        ComponentItem = 'AuditColumnName'
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
      end
      item
        Name = 'outIsDetail'
        Value = Null
        Component = cbDetail
        DataType = ftBoolean
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
    Left = 760
    Top = 312
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_PersonalService_SetErased'
    Left = 670
    Top = 328
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
        Name = 'inSummAvCardSecondRecalc'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummAvCardSecondRecalc'
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
        Name = 'inSummFine'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummFine'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummFineOthRecalc'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummFineOthRecalc'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummHosp'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummHosp'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummHospOthRecalc'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummHospOthRecalc'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummCompensationRecalc'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummCompensationRecalc'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummAuditAdd'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummAuditAdd'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummHouseAdd'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummHouseAdd'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummAvanceRecalc'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummAvanceRecalc'
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
      end
      item
        Name = 'inFineSubjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FineSubjectId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitFineSubjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitFineSubjectId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioBankOutDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BankOutDate'
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 360
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PersonalService'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
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
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummCardRecalc'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummCardSecondRecalc'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummCardSecondCash'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummAvCardSecondRecalc'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummNalogRecalc'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummNalogRet'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummMinus'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummAdd'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummAddOthRecalc'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummHoliday'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummSocialIn'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummSocialAdd'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummChildRecalc'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummMinusExtRecalc'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummFine'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummFineOthRecalc'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummHosp'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummHospOthRecalc'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummCompensationRecalc'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummAuditAdd'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummHouseAdd'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummHouseAdd'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummAvanceRecalc'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummAvanceRecalc'
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
      end
      item
        Name = 'inFineSubjectId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitFineSubjectId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioBankOutDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BankOutDate'
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 304
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = ''
    Left = 428
    Top = 220
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
    Left = 484
    Top = 241
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 516
    Top = 222
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
    Left = 311
    Top = 200
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
      end
      item
        Name = 'MemberId'
        Value = Null
        Component = GuidesMember
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = Null
        Component = GuidesMember
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 336
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
    Left = 696
    Top = 24
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
    Top = 379
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
    Left = 120
    Top = 464
  end
  object ChildDs: TDataSource
    DataSet = ChildCDS
    Left = 64
    Top = 464
  end
  object DBViewAddOnChild: TdsdDBViewAddOn
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
        DataSummaryItemIndex = -1
      end>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 238
    Top = 473
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
    Left = 352
    Top = 480
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
    Left = 968
    Top = 264
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
    Left = 512
    Top = 264
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
    Left = 568
    Top = 344
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
    Left = 752
    Top = 464
  end
  object SignCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 832
    Top = 480
  end
  object SignDS: TDataSource
    DataSet = SignCDS
    Left = 796
    Top = 478
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
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1016
    Top = 195
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
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 800
    Top = 251
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
    Left = 383
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
    Left = 848
    Top = 328
  end
  object GuidesMember: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember
    isShowModal = True
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
    Left = 616
    Top = 21
  end
  object MessageDCS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 800
    Top = 568
  end
  object MessageDS: TDataSource
    DataSet = MessageDCS
    Left = 856
    Top = 568
  end
  object spSelectMIMessage: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_Message'
    DataSet = MessageDCS
    DataSets = <
      item
        DataSet = MessageDCS
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
    Left = 696
    Top = 544
  end
  object spInsertUpdateMIMessage: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Message'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MessageDCS
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
        Name = 'inUserId_Top'
        Value = Null
        Component = GuidesMember
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioUserId'
        Value = Null
        Component = MessageDCS
        ComponentItem = 'UserId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisQuestion'
        Value = Null
        Component = MessageDCS
        ComponentItem = 'isQuestion'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAnswer'
        Value = Null
        Component = MessageDCS
        ComponentItem = 'isAnswer'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisQuestionRead'
        Value = Null
        Component = MessageDCS
        ComponentItem = 'isQuestionRead'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAnswerRead'
        Value = Null
        Component = MessageDCS
        ComponentItem = 'isAnswerRead'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = 'False'
        Component = MessageDCS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 480
    Top = 531
  end
  object spSelectPrintDetail: TdsdStoredProc
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
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 375
    Top = 328
  end
  object spUpdate_Compensation: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_PersonalService_Compensation'
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
    Left = 608
    Top = 456
  end
  object ExportDS: TDataSource
    DataSet = ExportCDS
    Left = 120
    Top = 616
  end
  object ExportCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 72
    Top = 624
  end
  object spGet_Export_FileName1: TdsdStoredProc
    StoredProcName = 'gpGet_PersonalService_FileName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outFileName'
        Value = Null
        Component = actExport_Grid
        ComponentItem = 'DefaultFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        Component = actExport_Grid
        ComponentItem = 'DefaultFileExt'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEncodingANSI'
        Value = Null
        Component = actExport_Grid
        ComponentItem = 'EncodingANSI'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        Component = actSMTPFile
        ComponentItem = 'FileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 248
    Top = 584
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
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 328
    Top = 632
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
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = Null
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSummCardRecalc'
        DataType = ftFloat
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
      end>
    PackSize = 1
    Left = 397
    Top = 597
  end
  object spGet_Export_FileNameZP: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Export_FileName'
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
        Name = 'outFileNamePrefix'
        Value = Null
        Component = actExportToFileZp
        ComponentItem = 'FileNamePrefix'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileExt'
        Value = Null
        Component = actExportToFileZp
        ComponentItem = 'FileExt'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 482
    Top = 634
  end
  object spGet_Export_FileName: TdsdStoredProc
    StoredProcName = 'gpGet_PersonalService_FileName'
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
    Left = 944
    Top = 344
  end
  object spInsertUpdate_byMemberMinus: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_PersonalService_byMemberMinus'
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
    Left = 464
    Top = 443
  end
  object spSelectExportDate: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PersonalService_exportOnDate'
    DataSet = ExportCDS
    DataSets = <
      item
        DataSet = ExportCDS
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
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSummCardRecalc'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42132d
        Component = edBankOutDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 453
    Top = 581
  end
  object DBViewAddOnChild_all: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableViewChild_all
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
        DataSummaryItemIndex = -1
      end>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 1230
    Top = 497
  end
  object spSelectChild_all: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_PersonalService_Child_detail'
    DataSet = ChildCDS_all
    DataSets = <
      item
        DataSet = ChildCDS_all
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
    Left = 1224
    Top = 544
  end
  object ChildCDS_all: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 1152
    Top = 504
  end
  object ChildDS_all: TDataSource
    DataSet = ChildCDS_all
    Left = 1144
    Top = 552
  end
  object ExportEmailCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 1064
    Top = 448
  end
  object ExportEmailDS: TDataSource
    DataSet = ExportEmailCDS
    Left = 1120
    Top = 441
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
        Component = FormParams
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
    Left = 688
    Top = 616
  end
  object spGet_Export_FileNameCSV: TdsdStoredProc
    StoredProcName = 'gpGet_PersonalService_FileNameCSV'
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
    Left = 936
    Top = 608
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
        Component = FormParams
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
    Left = 824
    Top = 632
  end
  object spGetImportSetting_mm: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TPersonalServiceMMForm;zc_Object_ImportSetting_PersonalServiceMM'
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
        ComponentItem = 'ImportSettingId_mm'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1048
    Top = 312
  end
  object spInsertUpdate_MemberMinus: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_MemberMinus_byPersonalService'
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
    Left = 568
    Top = 248
  end
  object spGetImportSetting_SMER: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TPersonalServiceSMERForm;zc_Object_ImportSetting_PersonalService' +
          'SMER'
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
        ComponentItem = 'ImportSettingId_SMER'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 976
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
    Left = 1184
    Top = 65533
  end
  object spGetImportSettingSummService: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TPersonalServiceForm;zc_Object_ImportSetting_PersonalServiceSumm' +
          'Service'
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
        ComponentItem = 'ImportSettingId_SS'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 976
    Top = 432
  end
  object spGetImportSettingAvance: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TPersonalServiceForm;zc_Object_ImportSetting_PersonalServiceSumm' +
          'Avance'
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
    Left = 1072
    Top = 136
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
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = Null
        Component = edInvNumber
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
    Left = 229
    Top = 653
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
    Left = 402
    Top = 666
  end
  object spInsertUpdate_Avance: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_PersonalService_Avance'
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
        Value = Null
        Component = FormParams
        ComponentItem = 'inStartDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inEndDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inServiceDate'
        Value = Null
        Component = edServiceDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 624
    Top = 401
  end
  object spGetImportSettingComp: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TPersonalServiceForm;zc_Object_ImportSetting_PersonalServiceComp' +
          'ensation'
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
    Left = 1152
    Top = 88
  end
  object spGetImportSetting_fine: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TPersonalServiceFineForm;zc_Object_ImportSetting_PersonalService' +
          'Fine'
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
    Left = 1056
    Top = 376
  end
  object spUpdate_PriceNalog: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_PersonalService_PriceNalog'
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
        Name = 'inPriceNalog'
        Value = Null
        Component = edPriceNalog
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsPriceNalog'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IsPriceNalog'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 576
    Top = 139
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
        Component = FormParams
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
    Left = 824
    Top = 680
  end
  object spGet_Export_FileNameCSVF2: TdsdStoredProc
    StoredProcName = 'gpGet_PersonalService_FileNameCSV'
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
    Left = 864
    Top = 680
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
        Component = FormParams
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
    Left = 776
    Top = 672
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
        Component = FormParams
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
    Left = 1064
    Top = 672
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
        Component = FormParams
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
    Left = 1000
    Top = 672
  end
  object spGet_Export_FileNameF2_xls: TdsdStoredProc
    StoredProcName = 'gpGet_PersonalService_FileNameCSV'
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
    Left = 1032
    Top = 672
  end
  object spUpdate_CardSecond4000: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_PersonalService_CardSecond_4000'
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
    Left = 544
    Top = 400
  end
  object spUpdate_CardSecond_num: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_PersonalService_CardSecond_num'
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
    Top = 312
  end
  object GuidesBankSecondNum: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBankSecondNum
    DisableGuidesOpen = True
    Key = '0'
    FormNameParam.Value = 'TBankSecondNumJournalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankSecondNumJournalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesBankSecondNum
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesBankSecondNum
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 1265
    Top = 54
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
        Component = FormParams
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
    Left = 592
    Top = 696
  end
  object spGet_Export_FileNameF2_prior_xls: TdsdStoredProc
    StoredProcName = 'gpGet_PersonalService_FileNameCSV'
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
        Name = 'inParam'
        Value = '4'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        Component = actExport_GridF2_prior_xls
        ComponentItem = 'DefaultFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        Component = actExport_GridF2_prior_xls
        ComponentItem = 'DefaultFileExt'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEncodingANSI'
        Value = Null
        Component = actExport_GridF2_prior_xls
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
    Left = 624
    Top = 696
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
        Component = FormParams
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
    AutoWidth = True
    Left = 656
    Top = 696
  end
  object ExportCDS_num: TClientDataSet
    Aggregates = <>
    AutoCalcFields = False
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 96
    Top = 776
  end
  object ExportDS_num: TDataSource
    DataSet = ExportCDS_num
    Left = 144
    Top = 768
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
    Left = 95
    Top = 696
  end
  object spUpdate_isMail: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_isMail'
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
      end>
    PackSize = 1
    Left = 80
    Top = 336
  end
  object spDelete_Object_Print: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_Print_byUser'
    DataSets = <>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 992
    Top = 3
  end
  object spInsertPrint_byGrid: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_PrintGrid'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReportKindId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValueDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 912
    Top = 3
  end
  object spSelectPrint_grid: TdsdStoredProc
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
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 847
    Top = 16
  end
end
