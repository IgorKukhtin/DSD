inherited CheckJournalForm: TCheckJournalForm
  Caption = #1050#1072#1089#1089#1086#1074#1099#1077' '#1095#1077#1082#1080
  ClientHeight = 554
  ClientWidth = 919
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 937
  ExplicitHeight = 601
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 77
    Width = 919
    Height = 477
    TabOrder = 3
    ExplicitTop = 77
    ExplicitWidth = 919
    ExplicitHeight = 477
    ClientRectBottom = 477
    ClientRectRight = 919
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 919
      ExplicitHeight = 477
      inherited cxGrid: TcxGrid
        Width = 919
        Height = 477
        ExplicitWidth = 919
        ExplicitHeight = 477
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clTotalSummChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalCount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clTotalSummChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalCount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = TotalSummPayAdd
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = SummaDelivery
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = ApplicationAward
            end>
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
          end
          inherited colInvNumber: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 99
          end
          inherited colOperDate: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
          end
          object colUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 111
          end
          object colCashNumber: TcxGridDBColumn
            Caption = #1050#1072#1089#1089#1072
            DataBinding.FieldName = 'CashRegisterName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object colTotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'TotalCount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object colTotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00; -,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object TotalSummPayAdd: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1076#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'TotalSummPayAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00; -,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clTotalSummChangePercent: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1089#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'TotalSummChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00; -,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 98
          end
          object coPaidTypeName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidTypeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colBayer: TcxGridDBColumn
            Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'Bayer'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object BayerPhone: TcxGridDBColumn
            Caption = #1058#1077#1083'. ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103')'
            DataBinding.FieldName = 'BayerPhone'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1085#1090#1072#1082#1090#1085#1099#1081' '#1090#1077#1083#1077#1092#1086#1085' ('#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103')'
            Options.Editing = False
            Width = 102
          end
          object colCashMember: TcxGridDBColumn
            Caption = #1052#1077#1085#1077#1076#1078#1077#1088
            DataBinding.FieldName = 'CashMember'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object colFiscalCheckNumber: TcxGridDBColumn
            Caption = #8470' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1075#1086' '#1095#1077#1082#1072
            DataBinding.FieldName = 'FiscalCheckNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 103
          end
          object colZReport: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' Z '#1086#1090#1095#1077#1090#1072
            DataBinding.FieldName = 'ZReport'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object colNotMCS: TcxGridDBColumn
            Caption = #1053#1077' '#1076#1083#1103' '#1053#1058#1047
            DataBinding.FieldName = 'NotMCS'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 51
          end
          object DiscountExternalName: TcxGridDBColumn
            Caption = #1055#1088#1086#1077#1082#1090
            DataBinding.FieldName = 'DiscountExternalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1086#1077#1082#1090' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099')'
            Options.Editing = False
            Width = 120
          end
          object clDiscountCardName: TcxGridDBColumn
            Caption = #8470' '#1082#1072#1088#1090#1099
            DataBinding.FieldName = 'DiscountCardName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object IsDeferred: TcxGridDBColumn
            Caption = #1054#1090#1083#1086#1078#1077#1085
            DataBinding.FieldName = 'IsDeferred'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object isSite: TcxGridDBColumn
            Caption = #1063#1077#1088#1077#1079' '#1089#1072#1081#1090
            DataBinding.FieldName = 'isSite'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object InvNumberOrder: TcxGridDBColumn
            Caption = #8470' '#1079#1072#1082#1072#1079#1072' ('#1089#1072#1081#1090')'
            DataBinding.FieldName = 'InvNumberOrder'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1086#1084#1077#1088' '#1079#1072#1082#1072#1079#1072' ('#1089' '#1089#1072#1081#1090#1072')'
            Options.Editing = False
            Width = 90
          end
          object ConfirmedKindName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072
            DataBinding.FieldName = 'ConfirmedKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072' ('#1057#1086#1089#1090#1086#1103#1085#1080#1077' VIP-'#1095#1077#1082#1072')'
            Options.Editing = False
            Width = 80
          end
          object ConfirmedKindClientName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089' '#1057#1052#1057
            DataBinding.FieldName = 'ConfirmedKindClientName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072' ('#1054#1090#1087#1088#1072#1074#1083#1077#1085' '#1082#1083#1080#1077#1085#1090#1091')'
            Options.Editing = False
            Width = 102
          end
          object CommentError: TcxGridDBColumn
            Caption = #1054#1096#1080#1073#1082#1072' '#1086#1089#1090#1072#1090#1086#1082' - '#1058#1086#1074#1072#1088'/'#1088#1072#1089#1095'/'#1092#1072#1082#1090' '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'CommentError'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
          object clPartnerMedicalName: TcxGridDBColumn
            Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1077' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1077
            DataBinding.FieldName = 'PartnerMedicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 119
          end
          object clOperDateSP: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1088#1077#1094#1077#1087#1090#1072
            DataBinding.FieldName = 'OperDateSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clInvNumberSP: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' '#1088#1077#1094#1077#1087#1090#1072
            DataBinding.FieldName = 'InvNumberSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object clMedicSP: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1074#1088#1072#1095#1072
            DataBinding.FieldName = 'MedicSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 98
          end
          object clAmbulance: TcxGridDBColumn
            Caption = #8470' '#1072#1084#1073#1091#1083#1072#1090#1086#1088#1080#1080' '
            DataBinding.FieldName = 'Ambulance'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 105
          end
          object clSPKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1089#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
            DataBinding.FieldName = 'SPKindName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 124
          end
          object MedicalProgramSPName: TcxGridDBColumn
            Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1072#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1072' '#1089#1086#1094'. '#1087#1088#1086#1077#1082#1090#1086#1074
            DataBinding.FieldName = 'MedicalProgramSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 104
          end
          object clInvNumber_Invoice_Full: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' ('#1057#1055')'
            DataBinding.FieldName = 'InvNumber_Invoice_Full'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
          end
          object clInsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object clInsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object InvNumber_PromoCode_Full: TcxGridDBColumn
            Caption = #1055#1088#1086#1084#1086' '#1082#1086#1076' ('#1076#1086#1082'.)'
            DataBinding.FieldName = 'InvNumber_PromoCode_Full'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GUID_PromoCode: TcxGridDBColumn
            Caption = #1055#1088#1086#1084#1086' '#1082#1086#1076
            DataBinding.FieldName = 'GUID_PromoCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MemberSPName: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1087#1072#1094#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'MemberSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 98
          end
          object GroupMemberSPName: TcxGridDBColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1087#1072#1094#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'GroupMemberSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object INN_MemberSP: TcxGridDBColumn
            Caption = #1048#1053#1053' '#1087#1072#1094#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'INN_MemberSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Passport_MemberSP: TcxGridDBColumn
            Caption = #1057#1077#1088#1080#1103' '#1080' '#1085#1086#1084#1077#1088' '#1087#1072#1089#1087#1086#1088#1090#1072'  '#1087#1072#1094#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'Passport_MemberSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1077#1088#1080#1103' '#1080' '#1085#1086#1084#1077#1088' '#1087#1072#1089#1087#1086#1088#1090#1072'  '#1087#1072#1094#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 100
          end
          object Address_MemberSP: TcxGridDBColumn
            Caption = #1040#1076#1088#1077#1089' '#1087#1072#1094#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'Address_MemberSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1076#1088#1077#1089' '#1087#1072#1094#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 108
          end
          object BanksPOSTerminalsName: TcxGridDBColumn
            Caption = 'POS '#1090#1077#1088#1084#1080#1085#1072#1083
            DataBinding.FieldName = 'BankPOSTerminalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 112
          end
          object JackdawsChecksName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1075#1072#1083#1082#1080
            DataBinding.FieldName = 'JackdawsChecksName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object Delay: TcxGridDBColumn
            Caption = #1055#1088#1086#1089#1088#1086#1095#1077#1085#1085#1099#1081' VIP '#1095#1077#1082
            DataBinding.FieldName = 'Delay'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object DateDelay: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1087#1088#1086#1089#1088#1086#1095#1082#1080
            DataBinding.FieldName = 'DateDelay'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object PartionDateKindName: TcxGridDBColumn
            Caption = #1058#1080#1087#1099' '#1089#1088#1086#1082'/'#1085#1077' '#1089#1088#1086#1082
            DataBinding.FieldName = 'PartionDateKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object BuyerPhone: TcxGridDBColumn
            Caption = #1055#1088#1086#1075#1088'. '#1085#1072#1082'. '#1090#1077#1083#1077#1092#1086#1085' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
            DataBinding.FieldName = 'BuyerPhone'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 115
          end
          object BuyerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1075#1088'. '#1085#1072#1082'. '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'BuyerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 134
          end
          object LoyaltySMDiscount: TcxGridDBColumn
            Caption = #1055#1088#1086#1075#1088'. '#1085#1072#1082'. '#1089#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'LoyaltySMDiscount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
          object LoyaltySMSumma: TcxGridDBColumn
            Caption = #1055#1088#1086#1075#1088'. '#1085#1072#1082'. '#1089#1091#1084#1084#1072' '#1074' '#1085#1072#1082#1086#1087#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'LoyaltySMSumma'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
          object CheckSourceKindName: TcxGridDBColumn
            Caption = #1048#1089#1090#1086#1095#1085#1080#1082' '#1095#1077#1082#1072
            DataBinding.FieldName = 'CheckSourceKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
          object MedicForSaleName: TcxGridDBColumn
            Caption = #1044#1086#1082#1090#1086#1088' '#1060#1048#1054
            DataBinding.FieldName = 'MedicForSaleName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 102
          end
          object BuyerForSaleName: TcxGridDBColumn
            Caption = #1055#1072#1094#1080#1077#1085#1090' '#1060#1048#1054
            DataBinding.FieldName = 'BuyerForSaleName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object isCorrectMarketing: TcxGridDBColumn
            Caption = #1050#1086#1088#1088'-'#1082#1072' '#1089#1091#1084#1084#1099' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072
            DataBinding.FieldName = 'isCorrectMarketing'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 92
          end
          object isCorrectIlliquidMarketing: TcxGridDBColumn
            Caption = #1050#1086#1088#1088'-'#1082#1072' '#1089#1091#1084#1084#1099' '#1085#1077#1083#1080#1082#1074#1080#1076#1086#1074' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072
            DataBinding.FieldName = 'isCorrectIlliquidMarketing'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object isDeliverySite: TcxGridDBColumn
            Caption = 'H'#1072#1096#1072' '#1076#1086#1089#1090#1072#1074#1082#1072
            DataBinding.FieldName = 'isDeliverySite'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object SummaDelivery: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1076#1086#1089#1090#1072#1074#1082#1080
            DataBinding.FieldName = 'SummaDelivery'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object isDoctors: TcxGridDBColumn
            Caption = #1042#1088#1072#1095#1080
            DataBinding.FieldName = 'isDoctors'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 53
          end
          object isDiscountCommit: TcxGridDBColumn
            Caption = #1044#1080#1089#1082#1086#1085#1090' '#1087#1088#1086#1074#1077#1076#1077#1085' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'isDiscountCommit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 89
          end
          object CommentCustomer: TcxGridDBColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081' '#1082#1083#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'CommentCustomer'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 105
          end
          object isManual: TcxGridDBColumn
            Caption = #1042#1099#1073#1086#1088' '#1092#1072#1088#1084#1072#1094#1077#1074#1090#1072' '#1087#1086' 1303'
            DataBinding.FieldName = 'isManual'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isOffsetVIP: TcxGridDBColumn
            Caption = #1047#1072#1095#1077#1090' '#1042#1048#1055#1072#1084
            DataBinding.FieldName = 'isOffsetVIP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object DateOffsetVIP: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1079#1072#1095#1077#1090#1072' '#1042#1048#1055#1072#1084
            DataBinding.FieldName = 'DateOffsetVIP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object isErrorRRO: TcxGridDBColumn
            Caption = #1042#1048#1055' '#1095#1077#1082' '#1087#1086' '#1086#1096#1080#1073#1082#1077' '#1056#1056#1054
            DataBinding.FieldName = 'isErrorRRO'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object isAutoVIPforSales: TcxGridDBColumn
            Caption = #1042#1048#1055' '#1095#1077#1082' '#1076#1083#1103' '#1087#1088#1086#1076#1072#1078
            DataBinding.FieldName = 'isAutoVIPforSales'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object isPaperRecipeSP: TcxGridDBColumn
            Caption = #1041#1091#1084#1072#1078#1085#1099#1081' '#1088#1077#1094#1077#1087#1090' '#1087#1086' '#1057#1055
            DataBinding.FieldName = 'isPaperRecipeSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object ConfirmationCodeSP: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1076#1090#1074'. '#1057#1055
            DataBinding.FieldName = 'ConfirmationCodeSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 64
          end
          object isMobileApplication: TcxGridDBColumn
            Caption = #1052#1086#1073'. '#1087#1088#1080#1083'.'
            DataBinding.FieldName = 'isMobileApplication'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 53
          end
          object isConfirmByPhone: TcxGridDBColumn
            Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1090#1077#1083#1077#1092#1086#1085#1085#1099#1084' '#1079#1074#1086#1085#1082#1086#1084
            DataBinding.FieldName = 'isConfirmByPhone'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object DateComing: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1080#1093#1086#1076#1072' '#1074' '#1072#1087#1090#1077#1082#1091
            DataBinding.FieldName = 'DateComing'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object MobileDiscount: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' '#1089' '#1084#1086#1073#1080#1083#1100#1085#1086#1075#1086' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103
            DataBinding.FieldName = 'MobileDiscount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object isMobileFirstOrder: TcxGridDBColumn
            Caption = #1055#1077#1088#1074#1072#1103' '#1087#1086#1082#1091#1087#1082#1072' '#1089' '#1084#1086#1073'. '#1087#1088#1080#1083'.'
            DataBinding.FieldName = 'isMobileFirstOrder'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object UserReferalsName: TcxGridDBColumn
            Caption = #1056#1077#1082#1086#1084'. '#1089#1086#1090#1088
            DataBinding.FieldName = 'UserReferalsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 108
          end
          object UserUnitReferalsName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1085#1080#1077' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
            DataBinding.FieldName = 'UserUnitReferalsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object ApplicationAward: TcxGridDBColumn
            Caption = #1044#1086#1087#1083#1072#1090#1072' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091' '#1079#1072' '#1084#1086#1073' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077
            DataBinding.FieldName = 'ApplicationAward'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 919
    Height = 51
    ExplicitWidth = 919
    ExplicitHeight = 51
    inherited deStart: TcxDateEdit
      EditValue = 42370d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42370d
    end
    object ceUnit: TcxButtonEdit
      Left = 107
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 4
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Width = 288
    end
    object cxLabel3: TcxLabel
      Left = 10
      Top = 29
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edIsSP: TcxCheckBox
      Left = 406
      Top = 5
      Action = actRefresh
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1057#1055' '#1095#1077#1082#1080
      TabOrder = 6
      Width = 155
    end
    object edIsVip: TcxCheckBox
      Left = 406
      Top = 29
      Action = actRefresh
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1042#1048#1055' '#1095#1077#1082#1080
      TabOrder = 7
      Width = 171
    end
  end
  inherited ActionList: TActionList
    inherited actInsert: TdsdInsertUpdateAction
      Enabled = False
      FormName = 'TCheckForm'
      FormNameParam.Value = 'TCheckForm'
    end
    inherited actInsertMask: TdsdInsertUpdateAction
      Enabled = False
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TCheckForm'
      FormNameParam.Value = 'TCheckForm'
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
      Enabled = False
    end
    inherited actUnComplete: TdsdChangeMovementStatus
      Enabled = False
    end
    inherited actSetErased: TdsdChangeMovementStatus
      Enabled = False
    end
    inherited mactReCompleteList: TMultiAction
      Enabled = False
    end
    inherited mactCompleteList: TMultiAction
      Enabled = False
    end
    inherited mactUnCompleteList: TMultiAction
      Enabled = False
    end
    inherited mactSetErasedList: TMultiAction
      Enabled = False
    end
    inherited mactSimpleReCompleteList: TMultiAction
      Enabled = False
    end
    inherited mactSimpleCompleteList: TMultiAction
      Enabled = False
    end
    inherited mactSimpleUncompleteList: TMultiAction
      Enabled = False
    end
    inherited mactSimpleErasedList: TMultiAction
      Enabled = False
    end
    inherited spCompete: TdsdExecStoredProc
      Enabled = False
    end
    inherited spUncomplete: TdsdExecStoredProc
      Enabled = False
    end
    inherited spErased: TdsdExecStoredProc
      Enabled = False
    end
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TMovement_PeriodDialogForm'
      FormNameParam.Value = 'TMovement_PeriodDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
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
          Component = MasterCDS
          ComponentItem = 'id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBayer'
          Value = Null
          Component = FormParams
          ComponentItem = 'inBayer'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inFiscalCheckNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'inFiscalCheckNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1050#1086#1087#1080#1103' '#1095#1077#1082#1072' '#1082#1083#1080#1077#1085#1090#1091
      ReportNameParam.Value = #1050#1086#1087#1080#1103' '#1095#1077#1082#1072' '#1082#1083#1080#1077#1085#1090#1091
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object PrintDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = 'actCheckPrintDialog'
      ImageIndex = 3
      FormName = 'TCheckPrintDialogForm'
      FormNameParam.Value = 'TCheckPrintDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptInputOutput
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inFiscalCheckNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'inFiscalCheckNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBayer'
          Value = Null
          Component = FormParams
          ComponentItem = 'inBayer'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inFiscalCheckNumber'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBayer'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macPrint: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = PrintDialog
        end
        item
          Action = actPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      ImageIndex = 3
    end
    object actCashSummaForDey: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1089#1091#1084#1084' '#1087#1086' '#1082#1072#1089#1089#1086#1074#1086#1084#1091' '#1072#1087#1087#1072#1088#1072#1090#1091
      Hint = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1089#1091#1084#1084' '#1087#1086' '#1082#1072#1089#1089#1086#1074#1086#1084#1091' '#1072#1087#1087#1072#1088#1072#1090#1091
      ImageIndex = 56
      FormName = 'TCashSummaForDeyForm'
      FormNameParam.Value = 'TCashSummaForDeyForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'CashRegisterName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CashRegisterName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Date'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdate_InsertDate: TdsdExecStoredProc
      Category = 'InsertDate'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_InsertDate
      StoredProcList = <
        item
          StoredProc = spUpdate_InsertDate
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1085#1072' '#1044#1072#1090#1091' '#1095#1077#1082#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1044#1072#1090#1091' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1085#1072' '#1044#1072#1090#1091' '#1095#1077#1082#1072
      ImageIndex = 50
    end
    object macUpdate_InsertDate_list: TMultiAction
      Category = 'InsertDate'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_InsertDate
        end>
      View = cxGridDBTableView
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1044#1072#1090#1091' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1085#1072' '#1044#1072#1090#1091' '#1095#1077#1082#1072
      ImageIndex = 50
    end
    object macUpdate_InsertDate: TMultiAction
      Category = 'InsertDate'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_InsertDate_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1080#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1057#1086#1079#1076#1072#1085#1080#1103' '#1085#1072' '#1076#1072#1090#1091' '#1063#1077#1082#1072'? '
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1086#1073#1085#1086#1074#1083#1077#1085#1099
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1044#1072#1090#1091' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1085#1072' '#1044#1072#1090#1091' '#1095#1077#1082#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1044#1072#1090#1091' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1085#1072' '#1044#1072#1090#1091' '#1095#1077#1082#1072
      ImageIndex = 67
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Check'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInputOutput
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
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsSP'
        Value = Null
        Component = edIsSP
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsVip'
        Value = Null
        Component = edIsVip
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
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
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_InsertDate'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    inherited bbInsert: TdxBarButton
      Visible = ivNever
    end
    inherited bbInsertMask: TdxBarButton
      Visible = ivNever
    end
    inherited bbComplete: TdxBarButton
      Visible = ivNever
    end
    inherited bbUnComplete: TdxBarButton
      Visible = ivNever
    end
    inherited bbDelete: TdxBarButton
      Visible = ivNever
    end
    object bbPrint: TdxBarButton
      Action = macPrint
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actCashSummaForDey
      Category = 0
    end
    object bbUpdate_InsertDate: TdxBarButton
      Action = macUpdate_InsertDate
      Category = 0
    end
  end
  inherited PopupMenu: TPopupMenu
    object N13: TMenuItem [11]
    end
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    RefreshAction = actRefreshStart
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
  end
  inherited spMovementComplete: TdsdStoredProc
    Left = 88
    Top = 296
  end
  inherited spMovementUnComplete: TdsdStoredProc
    Left = 88
    Top = 344
  end
  inherited spMovementSetErased: TdsdStoredProc
    Left = 88
    Top = 448
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
        Name = 'UnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end>
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_Check'
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
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 392
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 440
    Top = 24
  end
  object rdUnit: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = UnitGuides
      end>
    Left = 288
    Top = 16
  end
  object spGet_UserUnit: TdsdStoredProc
    StoredProcName = 'gpGet_UserUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'UnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 424
  end
  object dsdStoredProc1: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_Income'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsLastComplete'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 241
    Top = 346
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 748
    Top = 233
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 740
    Top = 286
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Check_Print'
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
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 648
    Top = 232
  end
  object spUpdate_InsertDate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Check_InsertDate'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'Id'
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
    Left = 488
    Top = 203
  end
end
