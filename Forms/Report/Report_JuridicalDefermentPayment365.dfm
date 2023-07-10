inherited Report_JuridicalDefermentPayment365Form: TReport_JuridicalDefermentPayment365Form
  Caption = #1054#1090#1095#1077#1090' <'#1055#1086#1082#1091#1087#1072#1090#1077#1083#1080' '#1089' '#1086#1090#1089#1088#1086#1095#1082#1086#1081' 365>'
  ClientHeight = 370
  ClientWidth = 1028
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1044
  ExplicitHeight = 409
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1028
    Height = 313
    TabOrder = 3
    ExplicitWidth = 1028
    ExplicitHeight = 313
    ClientRectBottom = 313
    ClientRectRight = 1028
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1028
      ExplicitHeight = 313
      inherited cxGrid: TcxGrid
        Width = 1028
        Height = 313
        ExplicitWidth = 1028
        ExplicitHeight = 313
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = SaleSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = KreditRemains
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = DebetRemains
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = DefermentPaymentRemains
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = SaleSumm1
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = SaleSumm2
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = SaleSumm3
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = SaleSumm4
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = SaleSumm5
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = SaleSumm6
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = SaleSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = KreditRemains
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = DebetRemains
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = DefermentPaymentRemains
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = SaleSumm1
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = SaleSumm2
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = SaleSumm3
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = SaleSumm4
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = SaleSumm5
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = JuridicalName
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = SaleSumm6
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object AccountName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090
            DataBinding.FieldName = 'AccountName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085' ('#1076#1086#1075#1086#1074#1086#1088')'
            DataBinding.FieldName = 'AreaName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AreaName_Partner: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085' ('#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090')'
            DataBinding.FieldName = 'AreaName_Partner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object RetailName_main: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName_main'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object RetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100' ('#1087#1088#1086#1089#1088#1086#1095#1082#1072')'
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object BranchCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1092#1083'.'
            DataBinding.FieldName = 'BranchCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 35
          end
          object BranchName: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object BranchName_personal: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083' ('#1057#1086#1090#1088#1091#1076#1085#1080#1082' '#1079#1072' '#1076#1086#1075'.)'
            DataBinding.FieldName = 'BranchName_personal'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1080#1083#1080#1072#1083' ('#1057#1086#1090#1088#1091#1076#1085#1080#1082' '#1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' '#1079#1072' '#1044#1086#1075#1086#1074#1086#1088')'
            Options.Editing = False
            Width = 85
          end
          object BranchName_personal_trade: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083' ('#1057#1086#1090#1088#1091#1076#1085#1080#1082' '#1058#1055' '#1079#1072' '#1076#1086#1075'.)'
            DataBinding.FieldName = 'BranchName_personal_trade'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1080#1083#1080#1072#1083' ('#1057#1086#1090#1088#1091#1076#1085#1080#1082' '#1058#1055' '#1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' '#1079#1072' '#1044#1086#1075#1086#1074#1086#1088')'
            Options.Editing = False
            Width = 85
          end
          object JuridicalGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'JuridicalGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object OKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PartnerCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
            DataBinding.FieldName = 'PartnerCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object PartnerName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'PartnerName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object ContractStateKindCode: TcxGridDBColumn
            Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractStateKindCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Alignment.Horz = taLeftJustify
            Properties.Alignment.Vert = taVCenter
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1055#1086#1076#1087#1080#1089#1072#1085
                ImageIndex = 12
                Value = 1
              end
              item
                Description = #1053#1077' '#1087#1086#1076#1087#1080#1089#1072#1085
                ImageIndex = 11
                Value = 2
              end
              item
                Description = #1047#1072#1074#1077#1088#1096#1077#1085
                ImageIndex = 13
                Value = 3
              end
              item
                Description = #1059' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
                ImageIndex = 66
                Value = 4
              end>
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ContractCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object ContractNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object ContractTagGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1087#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object StartDate: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088' '#1089
            DataBinding.FieldName = 'StartDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object EndDate: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088' '#1076#1086
            DataBinding.FieldName = 'EndDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object PaymentDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1086#1089#1083'. '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaymentDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PaymentAmount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086#1089#1083'. '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaymentAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object PaymentDate_jur: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1086#1089#1083'. '#1086#1087#1083#1072#1090#1099' ('#1070#1088'.'#1083#1080#1094#1086')'
            DataBinding.FieldName = 'PaymentDate_jur'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PaymentAmount_jur: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086#1089#1083'. '#1086#1087#1083#1072#1090#1099' ('#1070#1088'.'#1083#1080#1094#1086')'
            DataBinding.FieldName = 'PaymentAmount_jur'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object PersonalName: TcxGridDBColumn
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1079#1072' '#1076#1086#1075'.)'
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1086#1090#1088#1091#1076#1085#1080#1082' '#1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' '#1079#1072' '#1044#1086#1075#1086#1074#1086#1088')'
            Options.Editing = False
            Width = 100
          end
          object PersonalTradeName: TcxGridDBColumn
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' '#1058#1055' ('#1079#1072' '#1076#1086#1075'.)'
            DataBinding.FieldName = 'PersonalTradeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1086#1090#1088#1091#1076#1085#1080#1082' '#1058#1055' '#1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' '#1079#1072' '#1044#1086#1075#1086#1074#1086#1088
            Options.Editing = False
            Width = 80
          end
          object PersonalCollationName: TcxGridDBColumn
            Caption = #1041#1091#1093#1075'.'#1089#1074#1077#1088#1082#1072' '#1087#1086' '#1076#1086#1075'.  ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalCollationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' '#1079#1072' '#1044#1086#1075#1086#1074#1086#1088
            Options.Editing = False
            Width = 60
          end
          object PersonalTradeName_Partner: TcxGridDBColumn
            Caption = #1058#1055' '#1091' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalTradeName_Partner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
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
          object InfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object StartContractDate: TcxGridDBColumn
            Caption = #1054#1090#1089#1088#1086#1095#1082#1072' '#1085#1072#1095'.'#1076#1072#1090#1072
            DataBinding.FieldName = 'StartContractDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ContractJuridicalDocCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1102#1088'. '#1083'. ('#1095#1077#1088#1077#1079' '#1082#1086#1075#1086')'
            DataBinding.FieldName = 'ContractJuridicalDocCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ContractJuridicalDocName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086' ('#1095#1077#1088#1077#1079' '#1082#1086#1075#1086')'
            DataBinding.FieldName = 'ContractJuridicalDocName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object DebetRemains: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1076#1086#1083#1075' ('#1044#1077#1073#1077#1090')'
            DataBinding.FieldName = 'DebetRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object KreditRemains: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1076#1086#1083#1075' ('#1050#1088#1077#1076#1080#1090')'
            DataBinding.FieldName = 'KreditRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SaleSumm: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072
            DataBinding.FieldName = 'SaleSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object DefermentPaymentRemains: TcxGridDBColumn
            Caption = #1044#1086#1083#1075' '#1089' '#1086#1090#1089#1088#1086#1095#1082#1086#1081
            DataBinding.FieldName = 'DefermentPaymentRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SaleSumm1: TcxGridDBColumn
            Caption = '30 '#1076#1085'.'
            DataBinding.FieldName = 'SaleSumm1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SaleSumm2: TcxGridDBColumn
            Caption = '60 '#1076#1085'.'
            DataBinding.FieldName = 'SaleSumm2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SaleSumm3: TcxGridDBColumn
            Caption = '90 '#1076#1085'.'
            DataBinding.FieldName = 'SaleSumm3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SaleSumm4: TcxGridDBColumn
            Caption = '180 '#1076#1085'.'
            DataBinding.FieldName = 'SaleSumm4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SaleSumm5: TcxGridDBColumn
            Caption = '365 '#1076#1085'.'
            DataBinding.FieldName = 'SaleSumm5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object SaleSumm6: TcxGridDBColumn
            Caption = '>365 '#1076#1085'.'
            DataBinding.FieldName = 'SaleSumm6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object Condition: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1077
            DataBinding.FieldName = 'Condition'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1028
    ExplicitWidth = 1028
    inherited deStart: TcxDateEdit
      Left = 59
      Properties.SaveTime = False
      ExplicitLeft = 59
    end
    inherited deEnd: TcxDateEdit
      Left = 1024
      Top = -2
      Visible = False
      ExplicitLeft = 1024
      ExplicitTop = -2
    end
    inherited cxLabel1: TcxLabel
      Caption = #1085#1072' '#1076#1072#1090#1091':'
      ExplicitWidth = 48
    end
    inherited cxLabel2: TcxLabel
      Left = 966
      Top = -2
      Visible = False
      ExplicitLeft = 966
      ExplicitTop = -2
    end
    object edAccount: TcxButtonEdit
      Left = 246
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 320
    end
    object cxLabel3: TcxLabel
      Left = 161
      Top = 6
      Caption = #1057#1095#1077#1090' '#1085#1072#1079#1074#1072#1085#1080#1077':'
    end
    object cxLabel6: TcxLabel
      Left = 570
      Top = 6
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099':'
    end
    object edPaidKind: TcxButtonEdit
      Left = 653
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 55
    end
    object cxLabel9: TcxLabel
      Left = 717
      Top = 6
      Caption = #1060#1080#1083#1080#1072#1083':'
    end
    object edBranch: TcxButtonEdit
      Left = 765
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 120
    end
    object cxLabel4: TcxLabel
      Left = 890
      Top = 6
      Caption = #1043#1088#1091#1087#1087#1072' '#1102#1088'.'#1083#1080#1094':'
    end
    object edJuridicalGroup: TcxButtonEdit
      Left = 975
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 120
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = GuidesAccount
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesBranch
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = GuidesJuridicalGroup
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesPaidKind
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object actPrint30: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = '30'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'PeriodNumber'
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'SaleSumm1'
          FromParam.DataType = ftFloat
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'SaleSumm'
          ToParam.DataType = ftFloat
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = '30 '#1076#1085#1077#1081
      Hint = '30 '#1076#1085#1077#1081
      ImageIndex = 21
      DataSets = <
        item
          DataSet = cdsReport
          UserName = 'frxDBDataset'
        end>
      Params = <
        item
          Name = 'OperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartContractDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StartContractDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'PeriodNumber'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Summ'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SaleSumm1'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'AccountName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'365-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'365-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint60: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = '60'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'PeriodNumber'
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'SaleSumm2'
          FromParam.DataType = ftFloat
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'SaleSumm'
          ToParam.DataType = ftFloat
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = '60 '#1076#1085#1077#1081
      Hint = '60 '#1076#1085#1077#1081
      ImageIndex = 17
      DataSets = <
        item
          DataSet = cdsReport
          UserName = 'frxDBDataset'
        end>
      Params = <
        item
          Name = 'OperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartContractDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StartContractDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'PeriodNumber'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Summ'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SaleSumm2'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'AccountName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'365-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'365-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint90: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = '90'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'PeriodNumber'
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'SaleSumm3'
          FromParam.DataType = ftFloat
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'SaleSumm'
          ToParam.DataType = ftFloat
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = '90 '#1076#1085#1077#1081
      Hint = '90 '#1076#1085#1077#1081
      ImageIndex = 19
      DataSets = <
        item
          DataSet = cdsReport
          UserName = 'frxDBDataset'
        end>
      Params = <
        item
          Name = 'OperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartContractDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StartContractDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'PeriodNumber'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Summ'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SaleSumm3'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'AccountName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'365-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'365-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint180: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = '180'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'PeriodNumber'
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'SaleSumm4'
          FromParam.DataType = ftFloat
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'SaleSumm'
          ToParam.DataType = ftFloat
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = '180 '#1076#1085#1077#1081
      Hint = '180 '#1076#1085#1077#1081
      ImageIndex = 15
      DataSets = <
        item
          DataSet = cdsReport
          UserName = 'frxDBDataset'
        end>
      Params = <
        item
          Name = 'OperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartContractDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StartContractDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'PeriodNumber'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Summ'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SaleSumm4'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'AccountName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'365-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'365-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint365: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = '365'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'PeriodNumber'
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'SaleSumm5'
          FromParam.DataType = ftFloat
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'SaleSumm'
          ToParam.DataType = ftFloat
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = '365 '#1076#1085#1077#1081
      Hint = '365 '#1076#1085#1077#1081
      ImageIndex = 22
      DataSets = <
        item
          DataSet = cdsReport
          UserName = 'frxDBDataset'
        end>
      Params = <
        item
          Name = 'OperDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartContractDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StartContractDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'PeriodNumber'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Summ'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SaleSumm5'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AccountName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'365-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'365-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintOther: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = '366'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'PeriodNumber'
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'SaleSumm6'
          FromParam.DataType = ftFloat
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'SaleSumm'
          ToParam.DataType = ftFloat
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spReport
      StoredProcList = <
        item
          StoredProc = spReport
        end>
      Caption = #1041#1086#1083#1100#1096#1077' 365 '#1076#1085#1077#1081
      Hint = #1041#1086#1083#1100#1096#1077' 365 '#1076#1085#1077#1081
      ImageIndex = 23
      DataSets = <
        item
          DataSet = cdsReport
          UserName = 'frxDBDataset'
        end>
      Params = <
        item
          Name = 'OperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartContractDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StartContractDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'PeriodNumber'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Summ'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SaleSumm6'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'AccountName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'365-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'365-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1086#1090#1095#1077#1090#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 16
      DataSets = <
        item
          UserName = 'frDataSet'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'OperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountId'
          Value = Null
          Component = GuidesAccount
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountName'
          Value = Null
          Component = GuidesAccount
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindId'
          Value = Null
          Component = GuidesPaidKind
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = Null
          Component = GuidesPaidKind
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchId'
          Value = Null
          Component = GuidesBranch
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchName'
          Value = Null
          Component = GuidesBranch
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalGroupId'
          Value = Null
          Component = GuidesJuridicalGroup
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalGroupName'
          Value = Null
          Component = GuidesJuridicalGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescName'
          Value = 'zc_Movement_Sale'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'365)'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'365)'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintSale: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spReport_JuridicalSaleDocument
      StoredProcList = <
        item
          StoredProc = spReport_JuridicalSaleDocument
        end>
      Caption = #1055#1088#1086#1076#1072#1078#1072
      Hint = #1055#1088#1086#1076#1072#1078#1072
      ImageIndex = 3
      DataSets = <
        item
          DataSet = cdsReport
          UserName = 'frxDBDataset'
          IndexFieldNames = 'OperDate'
        end>
      Params = <
        item
          Name = 'OperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartContractDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StartContractDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'PeriodNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'PeriodNumber'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Summ'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'SaleSumm1'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'AccountName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1103')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1103')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_byJuridical: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1077#1090#1103#1084
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1077#1090#1103#1084
      ImageIndex = 19
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDataset'
          IndexFieldNames = 'RetailName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountId'
          Value = Null
          Component = GuidesAccount
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountName'
          Value = Null
          Component = GuidesAccount
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindId'
          Value = Null
          Component = GuidesPaidKind
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = Null
          Component = GuidesPaidKind
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchId'
          Value = Null
          Component = GuidesBranch
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchName'
          Value = Null
          Component = GuidesBranch
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalGroupId'
          Value = Null
          Component = GuidesJuridicalGroup
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalGroupName'
          Value = Null
          Component = GuidesJuridicalGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'DescName'
          Value = 'zc_Movement_Sale'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1089#1088#1086#1095#1082#1077
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1089#1088#1086#1095#1082#1077
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_JuridicalDefermentPaymentDialogForm'
      FormNameParam.Value = 'TReport_JuridicalDefermentPaymentDialogForm'
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
          Name = 'AccountId'
          Value = ''
          Component = GuidesAccount
          ComponentItem = 'Key'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountName'
          Value = ''
          Component = GuidesAccount
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindId'
          Value = ''
          Component = GuidesPaidKind
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PaidKindName'
          Value = ''
          Component = GuidesPaidKind
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchId'
          Value = ''
          Component = GuidesBranch
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchName'
          Value = ''
          Component = GuidesBranch
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalGroupId'
          Value = ''
          Component = GuidesJuridicalGroup
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalGroupName'
          Value = ''
          Component = GuidesJuridicalGroup
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actUpdate_LastPayment: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_LastPayment
      StoredProcList = <
        item
          StoredProc = spUpdate_LastPayment
        end>
      Caption = 'actUpdate_LastPayment'
      ImageIndex = 27
    end
    object ExecuteDialogLastPayment: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'ExecuteDialogLastPayment'
      ImageIndex = 27
      FormName = 'TDatePeriodDialogForm'
      FormNameParam.Name = 'TDatePeriodDialogForm'
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
          Value = Null
          Component = FormParams
          ComponentItem = 'inEndDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macUpdate_LastPayment: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogLastPayment
        end
        item
          Action = actUpdate_LastPayment
        end>
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086#1089#1083#1077#1076#1085#1080#1093' '#1086#1087#1083#1072#1090
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086#1089#1083#1077#1076#1085#1080#1093' '#1086#1087#1083#1072#1090
      ImageIndex = 27
    end
    object actOpenReportForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetAfterExecute = True
      Caption = #1054#1090#1095#1077#1090' <'#1040#1082#1090' '#1089#1074#1077#1088#1082#1080'>'
      Hint = #1054#1090#1095#1077#1090' <'#1040#1082#1090' '#1089#1074#1077#1088#1082#1080'>'
      ImageIndex = 25
      FormName = 'TReport_JuridicalCollationForm'
      FormNameParam.Value = 'TReport_JuridicalCollationForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
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
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inAccountId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AccountId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inAccountName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AccountName'
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
          Name = 'inInfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPaidKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPaidKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inContractId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inContractName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inCurrencyId'
          Value = ''
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inCurrencyName'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 155
  end
  inherited MasterCDS: TClientDataSet
    IndexFieldNames = 'JuridicalName'
    StoreDefs = True
    Top = 155
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_JuridicalDefermentPayment365'
    Params = <
      item
        Name = 'inOperDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEmptyParam'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccountId'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchId'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalGroupId'
        Value = ''
        Component = GuidesJuridicalGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    AutoWidth = True
    Left = 120
    Top = 211
  end
  inherited BarManager: TdxBarManager
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
          ItemName = 'bbOpenReportForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPribt'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbSale'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint30'
        end
        item
          Visible = True
          ItemName = 'bbPrint60'
        end
        item
          Visible = True
          ItemName = 'bbPrint90'
        end
        item
          Visible = True
          ItemName = 'bbPrint180'
        end
        item
          Visible = True
          ItemName = 'bbPrint365'
        end
        item
          Visible = True
          ItemName = 'bbOther'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_byJuridical'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_LastPayment'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbPrint30: TdxBarButton
      Action = actPrint30
      Category = 0
    end
    object bbPrint60: TdxBarButton
      Action = actPrint60
      Category = 0
    end
    object bbPrint90: TdxBarButton
      Action = actPrint90
      Category = 0
    end
    object bbPrint180: TdxBarButton
      Action = actPrint180
      Category = 0
    end
    object bbPrint365: TdxBarButton
      Action = actPrint365
      Category = 0
    end
    object bbOther: TdxBarButton
      Action = actPrintOther
      Category = 0
    end
    object bbPribt: TdxBarButton
      Action = actPrint
      Caption = #1055#1077#1095#1072#1090#1100' '#1086#1090#1095#1077#1090#1072' (365)'
      Category = 0
    end
    object bbSale: TdxBarButton
      Action = actPrintSale
      Category = 0
    end
    object bbPrint_byJuridical: TdxBarButton
      Action = actPrint_byJuridical
      Category = 0
      ImageIndex = 20
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbUpdate_LastPayment: TdxBarButton
      Action = macUpdate_LastPayment
      Category = 0
    end
    object bbOpenReportForm: TdxBarButton
      Action = actOpenReportForm
      Category = 0
    end
  end
  inherited PeriodChoice: TPeriodChoice
    DateStart = nil
    DateEnd = nil
    Left = 32
    Top = 211
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = deStart
      end
      item
        Component = GuidesAccount
      end
      item
        Component = GuidesPaidKind
      end
      item
        Component = GuidesBranch
      end
      item
        Component = GuidesJuridicalGroup
      end>
    Left = 88
    Top = 152
  end
  object GuidesAccount: TdsdGuides
    KeyField = 'Id'
    LookupControl = edAccount
    FormNameParam.Value = 'TAccount_ObjectDescForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAccount_ObjectDescForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValueAll'
        Value = ''
        Component = GuidesAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
        Value = 'zc_Object_Juridical'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 568
  end
  object spReport: TdsdStoredProc
    StoredProcName = 'gpReport_JuridicalDefermentPaymentByDocument'
    DataSet = cdsReport
    DataSets = <
      item
        DataSet = cdsReport
      end>
    Params = <
      item
        Name = 'inOperDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StartContractDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartnerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccountId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'AccountId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PaidKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BranchId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPeriodCount'
        Value = Null
        Component = FormParams
        ComponentItem = 'PeriodNumber'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSaleSumm'
        Value = Null
        Component = FormParams
        ComponentItem = 'SaleSumm'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 192
    Top = 192
  end
  object cdsReport: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 256
    Top = 208
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'PeriodNumber'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'SaleSumm'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 336
    Top = 152
  end
  object spReport_JuridicalSaleDocument: TdsdStoredProc
    StoredProcName = 'gpReport_JuridicalSaleDocument'
    DataSet = cdsReport
    DataSets = <
      item
        DataSet = cdsReport
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StartContractDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccountId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'AccountId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PaidKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BranchId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 264
  end
  object GuidesPaidKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 664
    Top = 8
  end
  object GuidesBranch: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranch
    FormNameParam.Value = 'TBranch_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBranch_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBranch
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 800
    Top = 8
  end
  object GuidesJuridicalGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridicalGroup
    FormNameParam.Value = 'TJuridicalGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridicalGroup
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridicalGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1000
    Top = 8
  end
  object spUpdate_LastPayment: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_JuridicalDefermentPayment'
    DataSets = <>
    OutputType = otResult
    Params = <
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
      end>
    PackSize = 1
    Left = 760
    Top = 192
  end
end
