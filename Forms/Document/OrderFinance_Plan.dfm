inherited OrderFinance_PlanForm: TOrderFinance_PlanForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077' '#1087#1083#1072#1090#1077#1078#1077#1081'> ('#1073#1091#1093#1075#1072#1083#1090#1077#1088')'
  ClientHeight = 324
  ClientWidth = 1020
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1036
  ExplicitHeight = 363
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 1020
    Height = 265
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 1020
    ExplicitHeight = 265
    ClientRectBottom = 265
    ClientRectRight = 1020
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1020
      ExplicitHeight = 265
      inherited cxGrid: TcxGrid
        Width = 1020
        Height = 265
        ExplicitWidth = 1020
        ExplicitHeight = 265
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = InvNumber
            end>
          OptionsData.Deleting = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object StatusCode: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089
            DataBinding.FieldName = 'StatusCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 11
                Value = 1
              end
              item
                Description = #1055#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 12
                Value = 2
              end
              item
                Description = #1059#1076#1072#1083#1077#1085
                ImageIndex = 13
                Value = 3
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 53
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object InsertName: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1088' ('#1079#1072#1103#1074#1082#1080')'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 98
          end
          object UnitName_insert: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1040#1074#1090#1086#1088')'
            DataBinding.FieldName = 'UnitName_insert'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1040#1074#1090#1086#1088' '#1079#1072#1103#1074#1082#1080')'
            Options.Editing = False
            Width = 110
          end
          object PositionName_insert: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1040#1074#1090#1086#1088')'
            DataBinding.FieldName = 'PositionName_insert'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1083#1078#1085#1086#1089#1090#1100' ('#1040#1074#1090#1086#1088' '#1079#1072#1103#1074#1082#1080')'
            Options.Editing = False
            Width = 80
          end
          object isSignWait_1: TcxGridDBColumn
            Caption = #1053#1077' '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072
            DataBinding.FieldName = 'isSignWait_1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1103#1074#1082#1072' '#1053#1072' '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1080
            Options.Editing = False
            Width = 85
          end
          object isSign_1: TcxGridDBColumn
            Caption = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072
            DataBinding.FieldName = 'isSign_1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1103#1074#1082#1072' '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072
            Options.Editing = False
            Width = 85
          end
          object OrderFinanceName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1055#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103
            DataBinding.FieldName = 'OrderFinanceName'
            DateTimeGrouping = dtgRelativeToToday
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 154
          end
          object WeekNumber: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' '#1085#1077#1076#1077#1083#1080
            DataBinding.FieldName = 'WeekNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object StartDate_WeekNumber: TcxGridDBColumn
            Caption = #1053#1077#1076#1077#1083#1103' '#1089
            DataBinding.FieldName = 'StartDate_WeekNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1083#1103' '#1053#1086#1084#1077#1088' '#1085#1077#1076#1077#1083#1080
            Options.Editing = False
            Width = 80
          end
          object EndDate_WeekNumber: TcxGridDBColumn
            Caption = #1053#1077#1076#1077#1083#1103' '#1087#1086
            DataBinding.FieldName = 'EndDate_WeekNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1083#1103' '#1053#1086#1084#1077#1088' '#1085#1077#1076#1077#1083#1080
            Options.Editing = False
            Width = 80
          end
          object ContractStateKindCode_Send: TcxGridDBColumn
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
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object ContractCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object ContractName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Caption = 'GoodsForm'
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Condition: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1077
            DataBinding.FieldName = 'Condition'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1089#1083#1086#1074#1080#1077' '#1076#1086#1075#1086#1074#1086#1088#1072
            Options.Editing = False
            Width = 100
          end
          object JuridicalCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1102#1088'.'#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
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
            Width = 150
          end
          object OKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object NumGroup: TcxGridDBColumn
            Caption = #8470' '#1059#1055
            DataBinding.FieldName = 'NumGroup'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object BankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082
            DataBinding.FieldName = 'BankName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 133
          end
          object BankAccountName: TcxGridDBColumn
            Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
            DataBinding.FieldName = 'BankAccountName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 172
          end
          object UserUpdate_report: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1086#1090#1095#1077#1090')'
            DataBinding.FieldName = 'UserUpdate_report'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' - '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1086#1090#1095#1077#1090#1072
            Options.Editing = False
            Width = 96
          end
          object DateUpdate_report: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1086#1090#1095#1077#1090')'
            DataBinding.FieldName = 'DateUpdate_report'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1076#1072#1085#1085#1099#1093' '#1080#1079' '#1086#1090#1095#1077#1090#1072
            Options.Editing = False
            Width = 101
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
            DataBinding.FieldName = 'InsertDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076#1072#1085#1080#1077' '#1047#1072#1103#1074#1082#1080')'
            Options.Editing = False
            Width = 80
          end
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
            DataBinding.FieldName = 'UpdateDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object UpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object UserMember_1: TcxGridDBColumn
            Caption = #1060#1048#1054' - '#1085#1072' '#1082#1086#1085#1090#1088#1086#1083#1077'-1'
            DataBinding.FieldName = 'UserMember_1'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 120
          end
          object UserMember_2: TcxGridDBColumn
            Caption = #1060#1048#1054' - '#1085#1072' '#1082#1086#1085#1090#1088#1086#1083#1077'-2'
            DataBinding.FieldName = 'UserMember_2'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 120
          end
          object Date_SignWait_1: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1053#1077' '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072
            DataBinding.FieldName = 'Date_SignWait_1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1047#1072#1103#1074#1082#1072' '#1085#1072' '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1080
            Options.Editing = False
            Width = 97
          end
          object Date_Sign_1: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072
            DataBinding.FieldName = 'Date_Sign_1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1047#1072#1103#1074#1082#1072' '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072
            Options.Editing = False
            Width = 90
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object StartDate: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088' '#1089
            DataBinding.FieldName = 'StartDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1075#1086#1074#1086#1088' '#1089
            Options.Editing = False
            Width = 78
          end
          object EndDate: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088' '#1076#1086
            DataBinding.FieldName = 'EndDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1075#1086#1074#1086#1088' '#1076#1086
            Options.Editing = False
            VisibleForCustomization = False
            Width = 79
          end
          object EndDate_real: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088' '#1076#1086' ('#1080#1085#1092'.)'
            DataBinding.FieldName = 'EndDate_real'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1075#1086#1074#1086#1088' '#1076#1086' ('#1080#1085#1092'.)'
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
          object AmountRemains: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1076#1086#1083#1075
            DataBinding.FieldName = 'AmountRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 80
          end
          object AmountSumm: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'AmountSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 80
          end
          object AmountPartner_1: TcxGridDBColumn
            Caption = '7 '#1076#1085#1077#1081
            DataBinding.FieldName = 'AmountPartner_1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 80
          end
          object AmountPartner_2: TcxGridDBColumn
            Caption = '14 '#1076#1085#1077#1081
            DataBinding.FieldName = 'AmountPartner_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 80
          end
          object AmountPartner_3: TcxGridDBColumn
            Caption = '21 '#1076#1085#1077#1081
            DataBinding.FieldName = 'AmountPartner_3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 80
          end
          object AmountPartner_4: TcxGridDBColumn
            Caption = '28 '#1076#1085#1077#1081
            DataBinding.FieldName = 'AmountPartner_4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 80
          end
          object AmountPartner: TcxGridDBColumn
            Caption = #1044#1086#1083#1075' '#1089' '#1086#1090#1089#1088#1086#1095#1082#1086#1081
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 100
          end
          object Amount: TcxGridDBColumn
            Caption = '***'#1055#1083#1072#1085' '#1085#1072' '#1085#1077#1076#1077#1083#1102
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1055#1083#1072#1085' '#1085#1072' '#1085#1077#1076#1077#1083#1102
            Options.Editing = False
            VisibleForCustomization = False
            Width = 80
          end
          object AmountPlan_total: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' '#1048#1058#1054#1043#1054
            DataBinding.FieldName = 'AmountPlan_total'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1086#1087#1083#1072#1090' '#1048#1058#1054#1043#1054
            Options.Editing = False
            Width = 80
          end
          object Comment_mov: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment_mov'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 163
          end
          object AmountPlan_1: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' 1.'#1087#1085'.'
            DataBinding.FieldName = 'AmountPlan_1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1086#1087#1083#1072#1090' '#1085#1072' 1.'#1087#1085'.'
            Options.Editing = False
            Width = 70
          end
          object AmountPlan_2: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' 2.'#1074#1090'.'
            DataBinding.FieldName = 'AmountPlan_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1086#1087#1083#1072#1090' '#1085#1072' 2.'#1074#1090'.'
            Options.Editing = False
            Width = 70
          end
          object AmountPlan_3: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' 3.'#1089#1088'.'
            DataBinding.FieldName = 'AmountPlan_3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1086#1087#1083#1072#1090' '#1085#1072' 3.'#1089#1088'.'
            Options.Editing = False
            Width = 70
          end
          object AmountPlan_4: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' 4.'#1095#1090'.'
            DataBinding.FieldName = 'AmountPlan_4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1086#1087#1083#1072#1090' '#1085#1072' 4.'#1095#1090'.'
            Options.Editing = False
            Width = 70
          end
          object AmountPlan_5: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' 5.'#1087#1090'.'
            DataBinding.FieldName = 'AmountPlan_5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1086#1087#1083#1072#1090' '#1085#1072' 5.'#1087#1090'.'
            Options.Editing = False
            Width = 70
          end
          object isAmountPlan: TcxGridDBColumn
            Caption = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isAmountPlan'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090')'
            Width = 70
          end
          object isAmountPlan_1: TcxGridDBColumn
            Caption = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090') 1.'#1087#1085'.'
            DataBinding.FieldName = 'isAmountPlan_1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090') 1.'#1087#1085'.'
            Options.Editing = False
            Width = 70
          end
          object isAmountPlan_2: TcxGridDBColumn
            Caption = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090') 2.'#1074#1090'.'
            DataBinding.FieldName = 'isAmountPlan_2'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090') 2.'#1074#1090'.'
            Options.Editing = False
            Width = 70
          end
          object isAmountPlan_3: TcxGridDBColumn
            Caption = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090') 3.'#1089#1088'.'
            DataBinding.FieldName = 'isAmountPlan_3'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090') 3.'#1089#1088'.'
            Options.Editing = False
            Width = 70
          end
          object isAmountPlan_4: TcxGridDBColumn
            Caption = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090') 4.'#1095#1090'.'
            DataBinding.FieldName = 'isAmountPlan_4'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090') 4.'#1095#1090'.'
            Options.Editing = False
            Width = 70
          end
          object isAmountPlan_5: TcxGridDBColumn
            Caption = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090') 5.'#1087#1090'.'
            DataBinding.FieldName = 'isAmountPlan_5'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090') 5.'#1087#1090'.'
            Options.Editing = False
            Width = 70
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1089#1090#1088#1086#1082#1072')'
            Options.Editing = False
            Width = 200
          end
          object Comment_pay: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1076#1083#1103' '#1087#1083#1072#1090#1077#1078#1072
            DataBinding.FieldName = 'Comment_pay'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1076#1083#1103' '#1087#1083#1072#1090#1077#1078#1072
            Width = 200
          end
          object Comment_jof: TcxGridDBColumn
            Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077' '#1087#1083#1072#1090#1077#1078#1072
            DataBinding.FieldName = 'Comment_jof'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 97
          end
          object BankName_jof: TcxGridDBColumn
            Caption = #1041#1072#1085#1082' ('#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103')'
            DataBinding.FieldName = 'BankName_jof'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actBankChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 84
          end
          object BankAccountName_jof: TcxGridDBColumn
            Caption = #1056'/'#1057#1095#1077#1090' ('#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103')'
            DataBinding.FieldName = 'BankAccountName_jof'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actTBankAccount_ObjectForm
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1088'/'#1089#1095#1077#1090', '#1085#1072' '#1082#1086#1090#1086#1088#1099#1081' '#1084#1099' '#1087#1083#1072#1090#1080#1084
            Width = 171
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1020
    Height = 33
    ExplicitWidth = 1020
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Left = 169
      Top = 6
      EditValue = 41640d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      ExplicitLeft = 169
      ExplicitTop = 6
      ExplicitWidth = 82
      Width = 82
    end
    inherited deEnd: TcxDateEdit
      Left = 280
      EditValue = 41640d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      ExplicitLeft = 280
      ExplicitWidth = 81
      Width = 81
    end
    inherited cxLabel1: TcxLabel
      Left = 150
      Caption = #1089':'
      ExplicitLeft = 150
      ExplicitWidth = 13
    end
    inherited cxLabel2: TcxLabel
      Left = 257
      Caption = #1087#1086':'
      ExplicitLeft = 257
      ExplicitWidth = 20
    end
    object cxLabel3: TcxLabel
      Left = 367
      Top = 6
      Caption = #1053#1077#1076#1077#1083#1103' '#1087#1086':'
    end
    object cxLabel4: TcxLabel
      Left = 13
      Top = 6
      Caption = #1053#1077#1076#1077#1083#1103' '#1089':'
    end
    object edWeekNumber1: TcxButtonEdit
      Left = 73
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 66
    end
    object edWeekNumber2: TcxButtonEdit
      Left = 429
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 61
    end
    object cbPlan_1: TcxCheckBox
      Left = 593
      Top = 2
      Caption = '1.'#1087#1085'.'
      Properties.ReadOnly = False
      TabOrder = 8
      Width = 49
    end
    object cbPlan_2: TcxCheckBox
      Left = 648
      Top = 2
      Caption = '2.'#1074#1090'.'
      Properties.ReadOnly = False
      TabOrder = 9
      Width = 49
    end
    object cbPlan_3: TcxCheckBox
      Left = 698
      Top = 2
      Caption = '3.'#1089#1088'.'
      Properties.ReadOnly = False
      TabOrder = 10
      Width = 49
    end
    object cbPlan_4: TcxCheckBox
      Left = 748
      Top = 2
      Caption = '4.'#1095#1090'.'
      Properties.ReadOnly = False
      TabOrder = 11
      Width = 49
    end
    object cbPlan_5: TcxCheckBox
      Left = 798
      Top = 2
      Caption = '5.'#1087#1090'.'
      Properties.ReadOnly = False
      TabOrder = 12
      Width = 49
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
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
        Component = edWeekNumber1
        Properties.Strings = (
          'Integer')
      end
      item
        Component = edWeekNumber2
        Properties.Strings = (
          'Integer')
      end>
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spGet_WeekNumber_byPeriod
      StoredProcList = <
        item
          StoredProc = spGet_WeekNumber_byPeriod
        end
        item
          StoredProc = spSelect
        end>
    end
    object actTBankAccount_ObjectForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TBankAccount_ObjectForm'
      FormName = 'TBankAccount_ObjectForm'
      FormNameParam.Value = 'TBankAccount_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankAccountId_jof'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankAccountName_jof'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BankId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankId_jof'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BankName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankName_jof'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBankId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankId_jof'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBankName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankName_jof'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actBankChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TBankForm'
      FormName = 'TBankForm'
      FormNameParam.Value = 'TBankForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankId_jof'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankName_jof'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_OrderFinance_Plan
      StoredProcList = <
        item
          StoredProc = spUpdate_OrderFinance_Plan
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TWeekPeriodDialogForm'
      FormNameParam.Value = 'TWeekPeriodDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
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
          Name = 'WeekNumber1'
          Value = ''
          Component = GuidesWeek_Date1
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'WeekNumber2'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actGet_Period_byWeekNumber: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = 'actGet_WeekNumber_byPeriod'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actGet_WeekNumber_byPeriod: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_WeekNumber_byPeriod
      StoredProcList = <
        item
          StoredProc = spGet_WeekNumber_byPeriod
        end>
      Caption = 'actGet_WeekNumber_byPeriod'
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderFinance_Plan'
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
        Name = 'inStartWeekNumber'
        Value = Null
        Component = edWeekNumber1
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndWeekNumber'
        Value = Null
        Component = edWeekNumber2
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 192
  end
  inherited BarManager: TdxBarManager
    Left = 144
    Top = 208
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 208
    Top = 248
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 80
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = edWeekNumber1
      end
      item
        Component = edWeekNumber2
      end
      item
        Component = GuidesWeek_Date1
      end
      item
        Component = deStart
      end
      item
        Component = deEnd
      end
      item
      end>
    Left = 352
    Top = 72
  end
  object GuidesWeek_Date1: TdsdGuides
    KeyField = 'WeekNumber'
    LookupControl = edWeekNumber1
    Key = '0'
    FormNameParam.Value = 'TWeek_DateForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TWeek_DateForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'key'
        Value = '0'
        Component = edWeekNumber1
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesWeek_Date1
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate_WeekNumber'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate_WeekNumber'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'WeekNumber'
        Value = Null
        Component = edWeekNumber2
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 135
  end
  object spUpdate_OrderFinance_Plan: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_OrderFinance_Plan'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAmountPlan'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isAmountPlan'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPlan_1'
        Value = Null
        Component = cbPlan_1
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPlan_2'
        Value = Null
        Component = cbPlan_2
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPlan_3'
        Value = Null
        Component = cbPlan_3
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPlan_4'
        Value = Null
        Component = cbPlan_4
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPlan_5'
        Value = Null
        Component = cbPlan_5
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisAmountPlan_1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isAmountPlan_1'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisAmountPlan_2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isAmountPlan_2'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisAmountPlan_3'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isAmountPlan_3'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisAmountPlan_4'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isAmountPlan_4'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisAmountPlan_5'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isAmountPlan_5'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOrderFinanceId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OrderFinanceId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalOrderFinanceId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalOrderFinanceId'
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
        Name = 'inInfoMoneyId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InfoMoneyId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankId_jof'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BankId_jof'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountName_jof'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BankAccountName_jof'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment_jof'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment_jof'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment_pay'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment_pay'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 640
    Top = 176
  end
  object RefreshDispatcherPeriod: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end>
    Left = 248
    Top = 40
  end
  object spGet_WeekNumber_byPeriod: TdsdStoredProc
    StoredProcName = 'gpGet_WeekNumber_byPeriod'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inStartDate'
        Value = 43374d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 43374d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'WeekNumber1'
        Value = ''
        Component = edWeekNumber1
        MultiSelectSeparator = ','
      end
      item
        Name = 'WeekNumber2'
        Value = 0.000000000000000000
        Component = edWeekNumber2
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 472
    Top = 48
  end
end
