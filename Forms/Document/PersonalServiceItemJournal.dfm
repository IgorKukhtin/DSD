inherited PersonalServiceItemJournalForm: TPersonalServiceItemJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1079#1072#1088#1087#1083#1072#1090#1099'> '#1044#1077#1090#1072#1083#1100#1085#1086
  ClientHeight = 705
  ClientWidth = 1221
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1237
  ExplicitHeight = 744
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1221
    Height = 648
    TabOrder = 3
    ExplicitWidth = 1221
    ExplicitHeight = 648
    ClientRectBottom = 648
    ClientRectRight = 1221
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1221
      ExplicitHeight = 648
      inherited cxGrid: TcxGrid
        Width = 1221
        Height = 563
        ExplicitTop = -6
        ExplicitWidth = 1221
        ExplicitHeight = 563
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
              Column = TotalSummService
            end
            item
              Format = ',0.####'
              Column = TotalSummCard
            end
            item
              Format = ',0.####'
              Column = TotalSummMinus
            end
            item
              Format = ',0.####'
              Column = TotalSummAdd
            end
            item
              Format = ',0.####'
              Column = TotalSummCash
            end
            item
              Format = ',0.####'
              Column = TotalSummCardRecalc
            end
            item
              Format = ',0.####'
              Column = TotalSummSocialIn
            end
            item
              Format = ',0.####'
              Column = TotalSummSocialAdd
            end
            item
              Format = ',0.####'
              Column = TotalSummChild
            end
            item
              Format = ',0.####'
              Column = TotalSummToPay
            end
            item
              Format = ',0.####'
              Column = TotalSummTransport
            end
            item
              Format = ',0.####'
              Column = TotalSummPhone
            end
            item
              Format = ',0.####'
              Column = TotalSummTransportAdd
            end
            item
              Format = ',0.####'
              Column = TotalSummHoliday
            end
            item
              Format = ',0.####'
              Column = TotalSummTransportAddLong
            end
            item
              Format = ',0.####'
              Column = TotalSummTransportTaxi
            end
            item
              Format = ',0.####'
              Column = TotalSummNalog
            end
            item
              Format = ',0.####'
              Column = TotalSummNalogRecalc
            end
            item
              Format = ',0.####'
              Column = TotalSummCardSecond
            end
            item
              Format = ',0.####'
              Column = TotalSummCardSecondRecalc
            end
            item
              Format = ',0.####'
              Column = TotalSummChildRecalc
            end
            item
              Format = ',0.####'
              Column = TotalSummMinusExt
            end
            item
              Format = ',0.####'
              Column = TotalSummMinusExtRecalc
            end
            item
              Format = ',0.####'
              Column = TotalSummCardSecondCash
            end
            item
              Format = ',0.####'
              Column = TotalSummNalogRet
            end
            item
              Format = ',0.####'
              Column = TotalSummNalogRetRecalc
            end
            item
              Format = ',0.####'
              Column = TotalSummAddOth
            end
            item
              Format = ',0.####'
              Column = TotalSummAddOthRecalc
            end
            item
              Format = ',0.####'
              Column = TotalSummFine
            end
            item
              Format = ',0.####'
              Column = TotalSummHosp
            end
            item
              Format = ',0.####'
              Column = TotalSummFineOthRecalc
            end
            item
              Format = ',0.####'
              Column = TotalSummHospOthRecalc
            end
            item
              Format = ',0.####'
              Column = TotalSummFineOth
            end
            item
              Format = ',0.####'
              Column = TotalSummHospOth
            end
            item
              Format = ',0.####'
              Column = TotalSummCompensation
            end
            item
              Format = ',0.####'
              Column = TotalSummCompensationRecalc
            end
            item
              Format = ',0.####'
              Column = TotalSummAuditAdd
            end
            item
              Format = ',0.####'
              Column = TotalDayAudit
            end
            item
              Format = ',0.####'
              Column = TotalSummHouseAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHouseAdd
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
              Column = SummTransportAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummTransportAddLong
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummTransport
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummPhone
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DayCompensation
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DayVacation
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DayWork
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DayHoliday
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DayAudit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHoliday
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAuditAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummTransportTaxi
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummFine
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummFineOth
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummFineOthRecalc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHosp
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
              Format = ',0.####'
              Kind = skSum
              Column = PriceCompensation
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHospOthRecalc
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
              Column = SummSocialIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummSocialAdd
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = TotalSumm
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummFine
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummFineOth
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummFineOthRecalc
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummHosp
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummHospOth
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummCompensation
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummCompensationRecalc
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = PriceCompensation
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummHospOthRecalc
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummChildRecalc
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummMinusExt
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummMinusExtRecalc
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummSocialIn
            end
            item
              Format = ',0.####'
              Position = spFooter
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
              Column = AmountCash
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummService
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAdd
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
              Column = SummMinus
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCard
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardRecalc
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
              Column = SummCardSecondDiff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummCardSecondCash
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
              Column = SummChild
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = AmountToPay
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = AmountCash
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummService
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummAdd
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummAddOth
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummAddOthRecalc
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummMinus
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummCard
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummCardRecalc
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummCardSecond
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummCardSecondRecalc
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummCardSecondDiff
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummCardSecondCash
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummNalogRet
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummNalogRetRecalc
            end
            item
              Format = ',0.####'
              Position = spFooter
              Column = SummChild
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Format = ',0.####'
              Column = TotalSummService
            end
            item
              Format = ',0.####'
              Column = TotalSummCard
            end
            item
              Format = ',0.####'
              Column = TotalSummMinus
            end
            item
              Format = ',0.####'
              Column = TotalSummAdd
            end
            item
              Format = ',0.####'
              Column = TotalSummCash
            end
            item
              Format = ',0.####'
              Column = TotalSummCardRecalc
            end
            item
              Format = ',0.####'
              Column = TotalSummSocialIn
            end
            item
              Format = ',0.####'
              Column = TotalSummSocialAdd
            end
            item
              Format = ',0.####'
              Column = TotalSummChild
            end
            item
              Format = ',0.####'
              Column = TotalSummToPay
            end
            item
              Format = ',0.####'
              Column = TotalSummTransport
            end
            item
              Format = ',0.####'
              Column = TotalSummPhone
            end
            item
              Format = ',0.####'
              Column = TotalSummTransportAdd
            end
            item
              Format = ',0.####'
              Column = TotalSummHoliday
            end
            item
              Format = ',0.####'
              Column = TotalSummTransportAddLong
            end
            item
              Format = ',0.####'
              Column = TotalSummTransportTaxi
            end
            item
              Format = ',0.####'
              Column = TotalSummNalog
            end
            item
              Format = ',0.####'
              Column = TotalSummNalogRecalc
            end
            item
              Format = ',0.####'
              Column = TotalSummCardSecond
            end
            item
              Format = ',0.####'
              Column = TotalSummCardSecondRecalc
            end
            item
              Format = ',0.####'
              Column = TotalSummChildRecalc
            end
            item
              Format = ',0.####'
              Column = TotalSummMinusExt
            end
            item
              Format = ',0.####'
              Column = TotalSummMinusExtRecalc
            end
            item
              Format = ',0.####'
              Column = TotalSummCardSecondCash
            end
            item
              Format = ',0.####'
              Column = TotalSummNalogRet
            end
            item
              Format = ',0.####'
              Column = TotalSummNalogRetRecalc
            end
            item
              Format = ',0.####'
              Column = TotalSummAddOth
            end
            item
              Format = ',0.####'
              Column = TotalSummAddOthRecalc
            end
            item
              Format = ',0.####'
              Column = TotalSummFine
            end
            item
              Format = ',0.####'
              Column = TotalSummHosp
            end
            item
              Format = ',0.####'
              Column = TotalSummFineOthRecalc
            end
            item
              Format = ',0.####'
              Column = TotalSummHospOthRecalc
            end
            item
              Format = ',0.####'
              Column = TotalSummFineOth
            end
            item
              Format = ',0.####'
              Column = TotalSummHospOth
            end
            item
              Format = ',0.####'
              Column = TotalSummCompensation
            end
            item
              Format = ',0.####'
              Column = TotalSummCompensationRecalc
            end
            item
              Format = ',0.####'
              Column = TotalSummAuditAdd
            end
            item
              Format = ',0.####'
              Column = TotalDayAudit
            end
            item
              Format = ',0.####'
              Column = TotalSummHouseAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHouseAdd
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
              Column = SummTransportAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummTransportAddLong
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummTransport
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummPhone
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DayCompensation
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DayVacation
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DayWork
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DayHoliday
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = DayAudit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummHoliday
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummAuditAdd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummTransportTaxi
            end
            item
              Kind = skSum
              Column = SummFine
            end
            item
              Kind = skSum
              Column = SummFineOth
            end
            item
              Kind = skSum
              Column = SummFineOthRecalc
            end
            item
              Kind = skSum
              Column = SummHosp
            end
            item
              Kind = skSum
              Column = SummHospOth
            end
            item
              Kind = skSum
              Column = SummCompensation
            end
            item
              Kind = skSum
              Column = SummCompensationRecalc
            end
            item
              Kind = skSum
              Column = PriceCompensation
            end
            item
              Kind = skSum
              Column = SummHospOthRecalc
            end
            item
              Kind = skSum
              Column = SummChildRecalc
            end
            item
              Kind = skSum
              Column = SummMinusExt
            end
            item
              Kind = skSum
              Column = SummMinusExtRecalc
            end
            item
              Kind = skSum
              Column = SummSocialIn
            end
            item
              Kind = skSum
              Column = SummSocialAdd
            end
            item
              Kind = skSum
              Column = AmountToPay
            end
            item
              Kind = skSum
              Column = AmountCash
            end
            item
              Kind = skSum
              Column = SummService
            end
            item
              Kind = skSum
              Column = SummAdd
            end
            item
              Kind = skSum
              Column = SummAddOth
            end
            item
              Kind = skSum
              Column = SummAddOthRecalc
            end
            item
              Kind = skSum
              Column = SummMinus
            end
            item
              Kind = skSum
              Column = SummCard
            end
            item
              Kind = skSum
              Column = SummCardRecalc
            end
            item
              Kind = skSum
              Column = SummCardSecond
            end
            item
              Kind = skSum
              Column = SummCardSecondRecalc
            end
            item
              Kind = skSum
              Column = SummCardSecondDiff
            end
            item
              Kind = skSum
              Column = SummCardSecondCash
            end
            item
              Kind = skSum
              Column = SummNalogRet
            end
            item
              Kind = skSum
              Column = SummNalogRetRecalc
            end
            item
              Kind = skSum
              Column = SummChild
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = PersonalName
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
            Width = 69
          end
          object PersonalServiceListName: TcxGridDBColumn
            Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100
            DataBinding.FieldName = 'PersonalServiceListName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
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
          object UnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1076#1088'.'
            DataBinding.FieldName = 'UnitCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
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
          object Code1C: TcxGridDBColumn
            Caption = #1050#1086#1076' 1'#1057
            DataBinding.FieldName = 'Code1C'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Card: TcxGridDBColumn
            Caption = #8470' '#1082#1072#1088#1090'. '#1047#1055' ('#1060'1)'
            DataBinding.FieldName = 'Card'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 115
          end
          object CardSecond: TcxGridDBColumn
            Caption = #8470' '#1082#1072#1088#1090'. '#1047#1055' ('#1060'2)'
            DataBinding.FieldName = 'CardSecond'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 115
          end
          object PersonalCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'PersonalCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PersonalName: TcxGridDBColumn
            Caption = #1060#1048#1054' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object PositionName: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object IsMain: TcxGridDBColumn
            Caption = #1054#1089#1085#1086#1074'. '#1084#1077#1089#1090#1086' '#1088'.'
            DataBinding.FieldName = 'isMain'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object IsOfficial: TcxGridDBColumn
            Caption = #1054#1092#1086#1088#1084#1083'. '#1086#1092#1080#1094'.'
            DataBinding.FieldName = 'isOfficial'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object DateIn: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1080#1077#1084#1072
            DataBinding.FieldName = 'DateIn'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object DateOut: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'DateOut'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object Amount: TcxGridDBColumn
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
          object AmountToPay: TcxGridDBColumn
            Caption = #1050' '#1074#1099#1087#1083#1072#1090#1077' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'AmountToPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountCash: TcxGridDBColumn
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
          object SummService: TcxGridDBColumn
            Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'SummService'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object SummAdd: TcxGridDBColumn
            Caption = #1055#1088#1077#1084#1080#1103
            DataBinding.FieldName = 'SummAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummAddOth: TcxGridDBColumn
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
          object SummAddOthRecalc: TcxGridDBColumn
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
          object SummMinus: TcxGridDBColumn
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103
            DataBinding.FieldName = 'SummMinus'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object SummCard: TcxGridDBColumn
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
          object SummCardRecalc: TcxGridDBColumn
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 1'#1092'.'
            DataBinding.FieldName = 'SummCardRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummCardSecond: TcxGridDBColumn
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
          object SummCardSecondRecalc: TcxGridDBColumn
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1074#1074#1086#1076') - 2'#1092'.'
            DataBinding.FieldName = 'SummCardSecondRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummCardSecondDiff: TcxGridDBColumn
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
            Width = 70
          end
          object SummCardSecondCash: TcxGridDBColumn
            Caption = #1050#1072#1088#1090#1072' '#1041#1053' ('#1082#1072#1089#1089#1072') - 2'#1092'.'
            DataBinding.FieldName = 'SummCardSecondCash'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummNalogRet: TcxGridDBColumn
            Caption = #1053#1072#1083#1086#1075#1080' - '#1074#1086#1079#1084#1077#1097#1077#1085#1080#1077' '#1082' '#1047#1055
            DataBinding.FieldName = 'SummNalogRet'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummNalogRetRecalc: TcxGridDBColumn
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
          object SummChild: TcxGridDBColumn
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
          object DayCount_child: TcxGridDBColumn
            Caption = #1054#1090#1088#1072#1073'. '#1076#1085'. 1 '#1095#1077#1083' ('#1080#1085#1092'.) ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'DayCount_child'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
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
          object SummFine: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072
            DataBinding.FieldName = 'SummFine'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object SummFineOth: TcxGridDBColumn
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
          object SummFineOthRecalc: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072' ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'SummFineOthRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072' ('#1074#1074#1086#1076' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103')'
            Width = 75
          end
          object SummHosp: TcxGridDBColumn
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
          object SummHospOth: TcxGridDBColumn
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
          object SummCompensation: TcxGridDBColumn
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
          object SummCompensationRecalc: TcxGridDBColumn
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
          object PriceCompensation: TcxGridDBColumn
            Caption = #1057#1088'. '#1079#1087' '#1076#1083#1103' '#1088#1072#1089#1095'. '#1082#1086#1084#1087#1077#1085#1089'.'
            DataBinding.FieldName = 'PriceCompensation'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1088#1077#1076#1085#1103#1103' '#1079#1087' '#1076#1083#1103' '#1088#1072#1089#1095#1077#1090#1072' '#1089#1091#1084#1084#1099' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080
            Options.Editing = False
            Width = 70
          end
          object SummHospOthRecalc: TcxGridDBColumn
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
          object SummChildRecalc: TcxGridDBColumn
            Caption = #1040#1083#1080#1084#1077#1085#1090#1099' - '#1091#1076#1077#1088#1078#1072#1085#1080#1077' ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'SummChildRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object SummMinusExt: TcxGridDBColumn
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
          object SummMinusExtRecalc: TcxGridDBColumn
            Caption = #1059#1076#1077#1088#1078#1072#1085#1080#1103' '#1089#1090#1086#1088#1086#1085'. '#1102#1088'.'#1083'. ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'SummMinusExtRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object SummSocialIn: TcxGridDBColumn
            Caption = #1057#1086#1094'.'#1074#1099#1087#1083'. ('#1080#1079' '#1079#1087')'
            DataBinding.FieldName = 'SummSocialIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummSocialAdd: TcxGridDBColumn
            Caption = #1057#1086#1094'.'#1074#1099#1087#1083'. ('#1076#1086#1087'. '#1082' '#1079#1087')'
            DataBinding.FieldName = 'SummSocialAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object MemberName_mi: TcxGridDBColumn
            Caption = #1060#1048#1054' ('#1040#1083#1080#1084#1077#1085#1090#1099')'
            DataBinding.FieldName = 'MemberName_mi'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object isAuto_mi: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
            DataBinding.FieldName = 'isAuto_mi'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' '#1087#1088#1080' '#1087#1077#1088#1077#1085#1086#1089#1077' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1086#1090#1095#1077#1090#1072
            Options.Editing = False
            Width = 38
          end
          object Comment_mi: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment_mi'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 125
          end
          object SummTransportTaxi: TcxGridDBColumn
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
          object PersonalServiceListName_mi: TcxGridDBColumn
            Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100' ('#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1041#1053')'
            DataBinding.FieldName = 'PersonalServiceListName_mi'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 140
          end
          object BankOutDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1074#1099#1087#1083#1072#1090#1099' '#1087#1086' '#1073#1072#1085#1082#1091
            DataBinding.FieldName = 'BankOutDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm.yy'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1074#1099#1087#1083#1072#1090#1099' '#1087#1086' '#1073#1072#1085#1082#1091
            Width = 80
          end
          object isBankOut: TcxGridDBColumn
            Caption = #1044#1083#1103' '#1091#1074#1086#1083#1077#1085#1085#1099#1093' '#1073#1072#1085#1082
            DataBinding.FieldName = 'isBankOut'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1083#1103' '#1091#1074#1086#1083#1077#1085#1085#1099#1093' '#1073#1072#1085#1082' ('#1074#1077#1076#1086#1084#1086#1089#1090#1100')'
            Options.Editing = False
            Width = 80
          end
          object FineSubjectName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1085#1072#1088#1091#1096#1077#1085#1080#1081
            DataBinding.FieldName = 'FineSubjectName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object UnitFineSubjectName: TcxGridDBColumn
            Caption = #1050#1077#1084' '#1085#1072#1083#1072#1075#1072#1077#1090#1089#1103' '#1074#1079#1099#1089#1082#1072#1085#1080#1077
            DataBinding.FieldName = 'UnitFineSubjectName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1077#1084' '#1085#1072#1083#1072#1075#1072#1077#1090#1089#1103' '#1074#1079#1099#1089#1082#1072#1085#1080#1077
            Width = 70
          end
          object SummNalog: TcxGridDBColumn
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
          object SummNalogRecalc: TcxGridDBColumn
            Caption = #1053#1072#1083#1086#1075#1080' - '#1091#1076#1077#1088#1078#1072#1085#1080#1103' '#1089' '#1047#1055' ('#1074#1074#1086#1076')'
            DataBinding.FieldName = 'SummNalogRecalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SummTransportAdd: TcxGridDBColumn
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
          object SummTransportAddLong: TcxGridDBColumn
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
          object SummTransport: TcxGridDBColumn
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
          object SummPhone: TcxGridDBColumn
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
          object DayCompensation: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1085'. '#1082#1086#1084#1087#1077#1085#1089'. '#1086#1090#1087#1091#1089#1082#1072
            DataBinding.FieldName = 'DayCompensation'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080' '#1086#1090#1087#1091#1089#1082#1072
            Options.Editing = False
            Width = 83
          end
          object DayVacation: TcxGridDBColumn
            Caption = #1055#1086#1083#1086#1078#1077#1085#1086' '#1076#1085#1077#1081' '#1086#1090#1087#1091#1089#1082#1072
            DataBinding.FieldName = 'DayVacation'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object DayWork: TcxGridDBColumn
            Caption = #1056#1072#1073#1086#1095#1080#1093' '#1076#1085#1077#1081
            DataBinding.FieldName = 'DayWork'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object DayHoliday: TcxGridDBColumn
            Caption = #1048#1089#1087'. '#1076#1085#1077#1081' '#1086#1090#1087#1091#1089#1082#1072
            DataBinding.FieldName = 'DayHoliday'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1089#1087#1086#1083#1100#1079#1086#1074#1072#1085#1086' '#1076#1085#1077#1081' '#1086#1090#1087#1091#1089#1082#1072
            Options.Editing = False
            Width = 83
          end
          object DayAudit: TcxGridDBColumn
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
          object SummHoliday: TcxGridDBColumn
            Caption = #1054#1090#1087#1091#1089#1082#1085#1099#1077
            DataBinding.FieldName = 'SummHoliday'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object SummAuditAdd: TcxGridDBColumn
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
          object SummHouseAdd: TcxGridDBColumn
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
          object InfoMoneyName_all: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'InfoMoneyName_all'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
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
        end
      end
      object ExportXmlGrid: TcxGrid
        Left = 0
        Top = 563
        Width = 1221
        Height = 85
        Align = alBottom
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
            Width = 100
          end
        end
        object ExportXmlGridLevel: TcxGridLevel
          GridView = ExportXmlGridDBTableView
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
      Left = 401
      Top = 2
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
    Left = 23
    Top = 194
    object actExportZP: TMultiAction [0]
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
    object actGet_Export_FileNameZp: TdsdExecStoredProc [1]
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
    object actPrint: TdsdPrintAction [21]
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
    object actPrint_All: TdsdPrintAction [22]
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
    object actPrint_Detail: TdsdPrintAction [23]
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
    object actInsertUpdateMISignYes: TdsdExecStoredProc [26]
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
      FileExt = '.txt'
      FilenamePrefix = 'Vostok_'
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
      FileExt = '.xml'
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
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' CSV '#1076#1086#1082#1091#1084#1077#1085#1090' '#1087#1086' '#1087#1086#1095#1090#1077'?'
      InfoAfterExecute = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' CSV '#1091#1089#1087#1077#1096#1085#1086' '#1086#1090#1087#1088#1072#1074#1083#1077#1085' '#1087#1086' '#1087#1086#1095#1090#1077
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' CSV '#1087#1086' '#1087#1086#1095#1090#1077
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' CSV '#1087#1086' '#1087#1086#1095#1090#1077
      ImageIndex = 53
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
    StoredProcName = 'gpSelect_Movement_PersonalService_Item'
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
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_All'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Detail'
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
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbExportZp'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbExport'
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
          ItemName = 'bbExportCSV'
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
      Action = actExportZP
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
      end
      item
        Name = 'StartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsServiceDate'
        Value = Null
        Component = cbIsServiceDate
        DataType = ftBoolean
        ParamType = ptInput
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
      end>
    PackSize = 1
    Left = 535
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
    Left = 160
    Top = 408
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
    Left = 863
    Top = 8
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
    Left = 752
    Top = 88
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
        Value = Null
        Component = actExportToFileZp
        ComponentItem = 'FileExt'
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
    Left = 232
    Top = 520
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
      end>
    PackSize = 1
    Left = 392
    Top = 512
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
      end>
    PackSize = 1
    Left = 600
    Top = 512
  end
end
