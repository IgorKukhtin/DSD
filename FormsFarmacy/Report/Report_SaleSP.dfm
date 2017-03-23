inherited Report_SaleSPForm: TReport_SaleSPForm
  Caption = 'P'#1077#1077#1089#1090#1088' '#1087#1086' '#1087#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1102' 1303'
  ClientHeight = 480
  ClientWidth = 1077
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1093
  ExplicitHeight = 518
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 91
    Width = 1077
    Height = 389
    TabOrder = 3
    ExplicitTop = 91
    ExplicitWidth = 1077
    ExplicitHeight = 389
    ClientRectBottom = 389
    ClientRectRight = 1077
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1077
      ExplicitHeight = 389
      inherited cxGrid: TcxGrid
        Width = 1077
        Height = 389
        ExplicitWidth = 1077
        ExplicitHeight = 389
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummaSP
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummOriginal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummaCompensation
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = colGoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummaSP
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummOriginal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colSummaCompensation
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clNumLine: TcxGridDBColumn
            Caption = #8470' '#1079'.'#1087'.'
            DataBinding.FieldName = 'NumLine'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 42
          end
          object clOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'OperDate'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 77
          end
          object clUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 127
          end
          object clJuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object clHospitalName: TcxGridDBColumn
            Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1077' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1077
            DataBinding.FieldName = 'HospitalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 128
          end
          object Contract_StartDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1075'.'
            DataBinding.FieldName = 'Contract_StartDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object ContractName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 217
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clMemberSP: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1087#1072#1094#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'MemberSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 102
          end
          object clGroupMemberSPName: TcxGridDBColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1087#1072#1094#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'GroupMemberSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 155
          end
          object clMedicSP: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1074#1088#1072#1095#1072
            DataBinding.FieldName = 'MedicSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 108
          end
          object clInvNumberSP: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' '#1088#1077#1094#1077#1087#1090#1072
            DataBinding.FieldName = 'InvNumberSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object clOperDateSP: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1088#1077#1094#1077#1087#1090#1072
            DataBinding.FieldName = 'OperDateSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 77
          end
          object clChangePercent: TcxGridDBColumn
            Caption = '% '#1057#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 78
          end
          object colAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 65
          end
          object clPriceSP: TcxGridDBColumn
            Caption = #1062#1077#1085#1072', '#1075#1088#1085
            DataBinding.FieldName = 'PriceSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object clPriceCompensation: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080', '#1075#1088#1085
            DataBinding.FieldName = 'PriceComp'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object clPriceOriginal: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1075#1088#1085
            DataBinding.FieldName = 'PriceOriginal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object colSummaSP: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072', '#1075#1088#1085
            DataBinding.FieldName = 'SummaSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 103
          end
          object colSummOriginal: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080', '#1075#1088#1085
            DataBinding.FieldName = 'SummOriginal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 103
          end
          object JuridicalFullName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086' ('#1087#1086#1083#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077')'
            DataBinding.FieldName = 'JuridicalFullName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 155
          end
          object JuridicalAddress: TcxGridDBColumn
            Caption = #1070#1088'. '#1072#1076#1088#1077#1089' ('#1057#1043')'
            DataBinding.FieldName = 'JuridicalAddress'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1070#1088'. '#1072#1076#1088#1077#1089#1072' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object OKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054' ('#1057#1043')'
            DataBinding.FieldName = 'OKPO'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1050#1055#1054' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object AccounterName: TcxGridDBColumn
            Caption = #1041#1091#1093#1075#1072#1083#1090#1077#1088' ('#1057#1043')'
            DataBinding.FieldName = 'AccounterName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1091#1093#1075#1072#1083#1090#1077#1088' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object INN: TcxGridDBColumn
            Caption = #1048#1053#1053' ('#1057#1043')'
            DataBinding.FieldName = 'INN'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1030#1055#1053' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object NumberVAT: TcxGridDBColumn
            Caption = #8470' '#1089#1074#1080#1076'. ('#1057#1043')'
            DataBinding.FieldName = 'NumberVAT'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1089#1074#1110#1076#1086#1094#1090#1074#1072' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object BankAccount: TcxGridDBColumn
            Caption = #1056'/'#1089' ('#1057#1043')'
            DataBinding.FieldName = 'BankAccount'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056'/'#1088' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object Phone: TcxGridDBColumn
            Caption = #1058#1077#1083#1077#1092#1086#1085' ('#1057#1043')'
            DataBinding.FieldName = 'Phone'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1077#1083#1077#1092#1086#1085' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object MainName: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1076#1080#1088#1077#1082#1090#1086#1088#1072' ('#1057#1043')'
            DataBinding.FieldName = 'MainName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1077#1083#1077#1092#1086#1085' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object Reestr: TcxGridDBColumn
            Caption = #1042#1080#1090#1103#1075' '#1079' '#1088#1077#1108#1089#1090#1088#1091' '#1087#1083#1072#1090#1085#1080#1082#1110#1074' '#1055#1044#1042' ('#1057#1043')'
            DataBinding.FieldName = 'Reestr'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1077#1083#1077#1092#1086#1085' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object Decision: TcxGridDBColumn
            Caption = #8470' '#1088#1110#1096#1077#1085#1085#1103' '#1087#1088#1086' '#1074#1080#1076#1072#1095#1091' '#1083#1110#1094#1077#1085#1079#1110#1111' ('#1057#1043')'
            DataBinding.FieldName = 'Decision'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1077#1083#1077#1092#1086#1085' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object DecisionDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1088#1110#1096#1077#1085#1085#1103' '#1087#1088#1086' '#1074#1080#1076#1072#1095#1091' '#1083#1110#1094#1077#1085#1079#1110#1111' ('#1057#1043')'
            DataBinding.FieldName = 'DecisionDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1077#1083#1077#1092#1086#1085' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object License: TcxGridDBColumn
            Caption = #8470' '#1083#1110#1094#1077#1085#1079#1110#1111' ('#1057#1043')'
            DataBinding.FieldName = 'License'
            Visible = False
            Options.Editing = False
            Width = 70
          end
          object BankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082' ('#1057#1043')'
            DataBinding.FieldName = 'BankName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1072#1085#1082' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object MFO: TcxGridDBColumn
            Caption = #1052#1060#1054' ('#1057#1043')'
            DataBinding.FieldName = 'MFO'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1060#1054' ('#1057#1091#1073#8217#1108#1082#1090' '#1075#1086#1089#1087#1086#1076#1072#1088#1102#1074#1072#1085#1085#1103')'
            Options.Editing = False
            Width = 155
          end
          object PartnerMedical_JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086' ('#1052#1077#1076'. '#1091#1095#1088#1077#1078#1076'.)'
            DataBinding.FieldName = 'PartnerMedical_JuridicalName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 155
          end
          object PartnerMedical_FullName: TcxGridDBColumn
            Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1077' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1077' ('#1087#1086#1083#1085#1086#1077' '#1085#1072#1079#1074#1072#1085#1080#1077')'
            DataBinding.FieldName = 'PartnerMedical_FullName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 155
          end
          object PartnerMedical_JuridicalAddress: TcxGridDBColumn
            Caption = #1070#1088'. '#1072#1076#1088#1077#1089' ('#1047#1054#1047')'
            DataBinding.FieldName = 'PartnerMedical_JuridicalAddress'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1070#1088'. '#1072#1076#1088#1077#1089#1072' ('#1047#1054#1047')'
            Options.Editing = False
            Width = 155
          end
          object PartnerMedical_Phone: TcxGridDBColumn
            Caption = #1058#1077#1083#1077#1092#1086#1085' ('#1047#1054#1047')'
            DataBinding.FieldName = 'PartnerMedical_Phone'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1077#1083#1077#1092#1086#1085' ('#1047#1054#1047')'
            Options.Editing = False
            Width = 155
          end
          object PartnerMedical_OKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054' ('#1047#1054#1047')'
            DataBinding.FieldName = 'PartnerMedical_OKPO'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1050#1055#1054' ('#1047#1054#1047')'
            Options.Editing = False
            Width = 155
          end
          object PartnerMedical_AccounterName: TcxGridDBColumn
            Caption = #1041#1091#1093#1075#1072#1083#1090#1077#1088' ('#1047#1054#1047')'
            DataBinding.FieldName = 'PartnerMedical_AccounterName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1091#1093#1075#1072#1083#1090#1077#1088' ('#1047#1054#1047')'
            Options.Editing = False
            Width = 155
          end
          object PartnerMedical_INN: TcxGridDBColumn
            Caption = #1048#1053#1053' ('#1047#1054#1047')'
            DataBinding.FieldName = 'PartnerMedical_INN'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1030#1055#1053' ('#1047#1054#1047')'
            Options.Editing = False
            Width = 155
          end
          object PartnerMedical_NumberVAT: TcxGridDBColumn
            Caption = #8470' '#1089#1074#1080#1076'. ('#1047#1054#1047')'
            DataBinding.FieldName = 'PartnerMedical_NumberVAT'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1089#1074#1110#1076'. ('#1047#1054#1047')'
            Options.Editing = False
            Width = 155
          end
          object PartnerMedical_BankAccount: TcxGridDBColumn
            Caption = #1056'/'#1088' ('#1047#1054#1047')'
            DataBinding.FieldName = 'PartnerMedical_BankAccount'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056'/'#1088' ('#1047#1054#1047')'
            Options.Editing = False
            Width = 155
          end
          object PartnerMedical_BankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082' ('#1047#1054#1047')'
            DataBinding.FieldName = 'PartnerMedical_BankName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1041#1072#1085#1082' ('#1047#1054#1047')'
            Options.Editing = False
            Width = 155
          end
          object PartnerMedical_MFO: TcxGridDBColumn
            Caption = #1052#1060#1054' ('#1047#1054#1047')'
            DataBinding.FieldName = 'PartnerMedical_MFO'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1060#1054' ('#1047#1054#1047')'
            Options.Editing = False
            Width = 155
          end
          object MedicFIO: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1075#1083#1072#1074'.'#1074#1088#1072#1095#1072
            DataBinding.FieldName = 'MedicFIO'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Unit_Address: TcxGridDBColumn
            Caption = #1040#1076#1088#1077#1089' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'Unit_Address'
            Visible = False
            Width = 80
          end
          object colSummaCompensation: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1082#1086#1084#1087#1077#1085#1089#1072#1094#1080#1080', '#1075#1088#1085
            DataBinding.FieldName = 'SummaComp'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 103
          end
          object CountSP: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1088#1077#1094#1077#1087#1090#1086#1074
            DataBinding.FieldName = 'CountSP'
            Visible = False
            Width = 70
          end
        end
      end
      object cbisInsert: TcxCheckBox
        Left = 112
        Top = 13
        Hint = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1089#1095#1077#1090
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1089#1095#1077#1090
        TabOrder = 1
        Width = 108
      end
    end
  end
  inherited Panel: TPanel
    Width = 1077
    Height = 65
    ExplicitWidth = 1077
    ExplicitHeight = 65
    inherited deStart: TcxDateEdit
      Left = 34
      EditValue = 42736d
      ExplicitLeft = 34
    end
    inherited deEnd: TcxDateEdit
      Left = 34
      Top = 32
      EditValue = 42736d
      ExplicitLeft = 34
      ExplicitTop = 32
    end
    inherited cxLabel1: TcxLabel
      Left = 15
      Caption = #1057':'
      ExplicitLeft = 15
      ExplicitWidth = 15
    end
    inherited cxLabel2: TcxLabel
      Left = 13
      Top = 33
      Caption = #1087#1086':'
      ExplicitLeft = 13
      ExplicitTop = 33
      ExplicitWidth = 20
    end
    object cxLabel3: TcxLabel
      Left = 416
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object ceUnit: TcxButtonEdit
      Left = 505
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 5
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Width = 225
    end
    object cxLabel4: TcxLabel
      Left = 128
      Top = 6
      Caption = #1070#1088'. '#1083#1080#1094#1086' ('#1085#1072#1096#1077'):'
    end
    object edJuridical: TcxButtonEdit
      Left = 220
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 186
    end
    object cbGroupMemberSP: TcxCheckBox
      Left = 736
      Top = 32
      Action = actRefresh1
      TabOrder = 8
      Width = 169
    end
    object cxLabel7: TcxLabel
      Left = 973
      Top = 33
      Caption = #1086#1090
    end
    object edDateInvoice: TcxDateEdit
      Left = 989
      Top = 32
      EditValue = 42736d
      Properties.ShowTime = False
      TabOrder = 10
      Width = 79
    end
    object cxLabel8: TcxLabel
      Left = 944
      Top = 6
      Caption = #1057#1095#1077#1090' '#8470
    end
    object edInvoice: TcxTextEdit
      Left = 989
      Top = 5
      TabOrder = 12
      Width = 79
    end
    object cxLabel11: TcxLabel
      Left = 736
      Top = 6
      Caption = '% '#1089#1082#1080#1076#1082#1080':'
    end
    object cePercentSP: TcxCurrencyEdit
      Left = 794
      Top = 5
      Properties.DisplayFormat = ',0.##'
      TabOrder = 14
      Width = 111
    end
  end
  object cxLabel5: TcxLabel [2]
    Left = 135
    Top = 33
    Caption = #1055#1088#1077#1076#1087#1088'-'#1090#1080#1077' '#1054#1047':'
  end
  object ceHospital: TcxButtonEdit [3]
    Left = 220
    Top = 32
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 186
  end
  object cxLabel6: TcxLabel [4]
    Left = 414
    Top = 32
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1087#1072#1094#1080#1077#1085#1090#1072':'
  end
  object edGroupMemberSP: TcxButtonEdit [5]
    Left = 533
    Top = 32
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 197
  end
  inherited ActionList: TActionList
    object actRefresh1: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1082#1088#1086#1084#1077' '#1074#1099#1073#1088#1072#1085#1085#1086#1081' '#1082#1072#1090#1077#1075#1086#1088#1080#1080
      Hint = #1082#1088#1086#1084#1077' '#1074#1099#1073#1088#1072#1085#1085#1086#1081' '#1082#1072#1090#1077#1075#1086#1088#1080#1080
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshPartionPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1072#1088#1090#1080#1080' '#1094#1077#1085#1099
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshIsPartion: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_SaleSPDialogForm'
      FormNameParam.Value = 'TReport_SaleSPDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = ''
          Component = JuridicalGuide
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = ''
          Component = JuridicalGuide
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = UnitGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = UnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'HospitalId'
          Value = Null
          Component = HospitalGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'HospitalName'
          Value = Null
          Component = HospitalGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GroupMemberSPId'
          Value = Null
          Component = GroupMemberSPGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GroupMemberSPName'
          Value = Null
          Component = GroupMemberSPGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGroupMemberSP'
          Value = Null
          Component = cbGroupMemberSP
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PercentSP'
          Value = Null
          Component = cePercentSP
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrintInvoice: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1095#1077#1090#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1095#1077#1090#1072
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'JuridicalName;HospitalName;ContractName;'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'GroupMemberSPName'
          Value = ''
          Component = GroupMemberSPGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGroupMemberSP'
          Value = 'False'
          Component = cbGroupMemberSP
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'Invoice'
          Value = Null
          Component = edInvoice
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DateInvoice'
          Value = 42736d
          Component = edDateInvoice
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1057#1095#1077#1090' '#1087#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 1303'
      ReportNameParam.Value = #1057#1095#1077#1090' '#1087#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 1303'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = 'P'#1077#1077#1089#1090#1088' '#1087#1086' '#1087#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1102' 1303'
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'UnitName;HospitalName;ContractName;OperDate;GoodsName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'GroupMemberSPName'
          Value = Null
          Component = GroupMemberSPGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGroupMemberSP'
          Value = Null
          Component = cbGroupMemberSP
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'P'#1077#1077#1089#1090#1088' '#1087#1086' '#1087#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1102' 1303'
      ReportNameParam.Value = 'P'#1077#1077#1089#1090#1088' '#1087#1086' '#1087#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1102' 1303'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
    end
    object macPrintInvoice: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSaveMovement
        end
        item
          Action = actPrintInvoice
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1095#1077#1090#1072
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 15
    end
    object actSaveMovement: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSavePrintMovement
      StoredProcList = <
        item
          StoredProc = spSavePrintMovement
        end>
      Caption = 'actSPSavePrintState'
    end
  end
  inherited MasterDS: TDataSource
    Left = 48
    Top = 160
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 160
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Sale_SP'
    Params = <
      item
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = JuridicalGuide
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHospitalId'
        Value = Null
        Component = HospitalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGroupMemberSPId'
        Value = Null
        Component = GroupMemberSPGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercentSP'
        Value = Null
        Component = cePercentSP
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGroupMemberSP'
        Value = Null
        Component = cbGroupMemberSP
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 120
    Top = 160
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbExecuteDialog'
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
          ItemName = 'dxBarControlContainerItem1'
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
          ItemName = 'bbPrintInvoice'
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
    object dxBarButton1: TdxBarButton
      Caption = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Category = 0
      Hint = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Visible = ivAlways
      ImageIndex = 38
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbPrintInvoice: TdxBarButton
      Action = macPrintInvoice
      Category = 0
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cbisInsert
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 200
    Top = 176
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = UnitGuides
      end
      item
        Component = HospitalGuides
      end
      item
        Component = JuridicalGuide
      end
      item
        Component = GroupMemberSPGuides
      end
      item
        Component = cePercentSP
      end>
    Left = 304
    Top = 168
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
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 632
  end
  object JuridicalGuide: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridicalCorporateForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalCorporateForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuide
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuide
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 288
  end
  object HospitalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceHospital
    FormNameParam.Value = 'TPartnerMedicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerMedicalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = HospitalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = HospitalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 344
    Top = 24
  end
  object GroupMemberSPGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGroupMemberSP
    FormNameParam.Value = 'TGroupMemberSPForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGroupMemberSPForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GroupMemberSPGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GroupMemberSPGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 584
    Top = 32
  end
  object spSavePrintMovement: TdsdStoredProc
    StoredProcName = 'gpInsert_Movement_Invoice'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inJuridicalId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerMedicalId'
        Value = ''
        Component = HospitalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGroupMemberSPId'
        Value = '0'
        Component = GroupMemberSPGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPercentSP'
        Value = Null
        Component = cePercentSP
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGroupMemberSP'
        Value = Null
        Component = cbGroupMemberSP
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateInvoice'
        Value = ''
        Component = edDateInvoice
        ComponentItem = 'Key'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvoice'
        Value = Null
        Component = edInvoice
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisInsert'
        Value = 'False'
        Component = cbisInsert
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 704
    Top = 192
  end
end
