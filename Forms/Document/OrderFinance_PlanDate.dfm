inherited OrderFinance_PlanDateForm: TOrderFinance_PlanDateForm
  Caption = #1055#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077' '#1087#1083#1072#1090#1077#1078#1077#1081' ('#1087#1086' '#1076#1072#1090#1072#1084')'
  ClientHeight = 410
  ClientWidth = 1020
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1036
  ExplicitHeight = 449
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 1020
    Height = 277
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 1020
    ExplicitHeight = 277
    ClientRectBottom = 277
    ClientRectRight = 1020
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1020
      ExplicitHeight = 277
      inherited cxGrid: TcxGrid
        Width = 1020
        Height = 277
        ExplicitWidth = 1020
        ExplicitHeight = 277
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_day
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountRemains
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPartner
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPartner_1
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPartner_2
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPartner_3
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPartner_4
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPartner_5
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_1
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_2
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_3
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_4
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_5
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = InvNumber
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_day
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountRemains
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPartner
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPartner_1
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPartner_2
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPartner_3
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPartner_4
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPartner_5
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_1
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_2
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_3
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_4
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = AmountPlan_5
            end>
          OptionsData.Deleting = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
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
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
            DataBinding.FieldName = 'OperDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object InsertName: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1088' ('#1079#1072#1103#1074#1082#1080')'
            DataBinding.FieldName = 'InsertName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 140
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
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1103#1074#1082#1072' '#1053#1072' '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1080
            Options.Editing = False
            Width = 85
          end
          object isSign_1: TcxGridDBColumn
            Caption = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072
            DataBinding.FieldName = 'isSign_1'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1103#1074#1082#1072' '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072
            Options.Editing = False
            Width = 85
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
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1047#1072#1103#1074#1082#1072' '#1085#1072' '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1080
            Options.Editing = False
            Width = 97
          end
          object Date_Sign_1: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072
            DataBinding.FieldName = 'Date_Sign_1'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1047#1072#1103#1074#1082#1072' '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072
            Options.Editing = False
            Width = 90
          end
          object isSignSB: TcxGridDBColumn
            Caption = #1042#1080#1079#1072' '#1057#1041
            DataBinding.FieldName = 'isSignSB'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1103#1074#1082#1072' '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072
            Options.Editing = False
            Width = 85
          end
          object Date_SignSB: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1042#1080#1079#1072' '#1057#1041')'
            DataBinding.FieldName = 'Date_SignSB'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1047#1072#1103#1074#1082#1072' '#1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1072
            Options.Editing = False
            Width = 72
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
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1083#1103' '#1053#1086#1084#1077#1088' '#1085#1077#1076#1077#1083#1080
            Options.Editing = False
            Width = 80
          end
          object EndDate_WeekNumber: TcxGridDBColumn
            Caption = #1053#1077#1076#1077#1083#1103' '#1087#1086
            DataBinding.FieldName = 'EndDate_WeekNumber'
            Visible = False
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
          object PersonalName_contract: TcxGridDBColumn
            Caption = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' '#1079#1072' '#1076#1086#1075'. ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalName_contract'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' '#1079#1072' '#1076#1086#1075'. ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            Options.Editing = False
            Width = 119
          end
          object Condition: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1077
            DataBinding.FieldName = 'Condition'
            Visible = False
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
          object NumGroup: TcxGridDBColumn
            Caption = #8470' '#1059#1055
            DataBinding.FieldName = 'NumGroup'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
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
          object Amount: TcxGridDBColumn
            Caption = '***'#1055#1083#1072#1085' '#1085#1072' '#1085#1077#1076#1077#1083#1102
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1074#1072#1088#1080#1090#1077#1083#1100#1085#1099#1081' '#1055#1083#1072#1085' '#1085#1072' '#1085#1077#1076#1077#1083#1102
            Options.Editing = False
            Width = 80
          end
          object WeekDay: TcxGridDBColumn
            Caption = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080
            DataBinding.FieldName = 'WeekDay'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1085#1100' '#1085#1077#1076#1077#1083#1080' '#1076#1083#1103' <'#1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099'>'
            Options.Editing = False
            Width = 55
          end
          object DateDay: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'DateDay'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'DD.MM.YYYY'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object AmountPlan_day: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1055#1083#1072#1085
            DataBinding.FieldName = 'AmountPlan_day'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1055#1083#1072#1085' '#1086#1087#1083#1072#1090' '#1085#1072' '#1076#1072#1090#1091
            Width = 90
          end
          object AmountPlan_1: TcxGridDBColumn
            Caption = #1055#1083#1072#1085' 1.'#1087#1085'.'
            DataBinding.FieldName = 'AmountPlan_1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = False
            Visible = False
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
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = False
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
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = False
            Visible = False
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
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = False
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
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1085' '#1086#1087#1083#1072#1090' '#1085#1072' 5.'#1087#1090'.'
            Options.Editing = False
            Width = 70
          end
          object isAmountPlan_day: TcxGridDBColumn
            Caption = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isAmountPlan_day'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1083#1072#1090#1080#1084' ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 70
          end
          object AmountRemains: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1076#1086#1083#1075
            DataBinding.FieldName = 'AmountRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountPartner: TcxGridDBColumn
            Caption = #1044#1086#1083#1075' '#1089' '#1086#1090#1089#1088#1086#1095#1082#1086#1081
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object AmountSumm: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'AmountSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountPartner_1: TcxGridDBColumn
            Caption = '7 '#1076#1085#1077#1081
            DataBinding.FieldName = 'AmountPartner_1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountPartner_2: TcxGridDBColumn
            Caption = '14 '#1076#1085#1077#1081
            DataBinding.FieldName = 'AmountPartner_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountPartner_3: TcxGridDBColumn
            Caption = '21 '#1076#1085#1077#1081
            DataBinding.FieldName = 'AmountPartner_3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountPartner_4: TcxGridDBColumn
            Caption = '28 '#1076#1085#1077#1081
            DataBinding.FieldName = 'AmountPartner_4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object AmountPartner_5: TcxGridDBColumn
            Caption = '>28 '#1076#1085#1077#1081
            DataBinding.FieldName = 'AmountPartner_5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Number_day: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'Number_day'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0.;-,0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1074' '#1086#1095#1077#1088#1077#1076#1080' '#1085#1072' '#1101#1082#1089#1087#1086#1088#1090' '#1074' '#1073#1072#1085#1082
            Options.Editing = False
            Width = 70
          end
          object Comment_pay: TcxGridDBColumn
            Caption = #1060#1040#1050#1058' '#1053#1072#1079#1085#1072#1095#1077#1085#1080#1077' '#1087#1083#1072#1090#1077#1078#1072
            DataBinding.FieldName = 'Comment_pay'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
          object Comment_jof: TcxGridDBColumn
            Caption = #1064#1040#1041#1051#1054#1053' '#1053#1072#1079#1085#1072#1095#1077#1085#1080#1077' '#1087#1083#1072#1090#1077#1078#1072
            DataBinding.FieldName = 'Comment_jof'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
          object BankAccountName: TcxGridDBColumn
            Caption = #1056'/'#1057#1095#1077#1090' ('#1055#1083#1072#1090#1077#1083#1100#1097#1080#1082')'
            DataBinding.FieldName = 'BankAccountName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actBankAccountChoicetFormMain
                Default = True
                Kind = bkEllipsis
              end>
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1087#1083#1072#1090#1072' '#1089' '#1088'/'#1089#1095#1077#1090#1072
            Options.Editing = False
            Width = 172
          end
          object BankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082' ('#1055#1083#1072#1090#1077#1083#1100#1097#1080#1082')'
            DataBinding.FieldName = 'BankName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actBankChoiceFormMain
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 133
          end
          object MFO_Main: TcxGridDBColumn
            Caption = #1052#1060#1054' '#1041#1072#1085#1082' ('#1055#1083#1072#1090#1077#1083#1100#1097#1080#1082')'
            DataBinding.FieldName = 'MFO'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 97
          end
          object BankAccountName_jof: TcxGridDBColumn
            Caption = #1056'/'#1057#1095#1077#1090' ('#1055#1086#1083#1091#1095#1072#1090#1077#1083#1100')'
            DataBinding.FieldName = 'BankAccountName_jof'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actBankAccountChoicetForm
                Default = True
                Kind = bkEllipsis
              end>
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1086#1087#1083#1072#1090#1072' '#1085#1072' '#1088'/'#1089#1095#1077#1090
            Options.Editing = False
            Width = 171
          end
          object BankName_jof: TcxGridDBColumn
            Caption = #1041#1072#1085#1082' ('#1055#1086#1083#1091#1095#1072#1090#1077#1083#1100')'
            DataBinding.FieldName = 'BankName_jof'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actBankChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object MFO_jof: TcxGridDBColumn
            Caption = #1052#1060#1054' '#1041#1072#1085#1082' ('#1055#1086#1083#1091#1095#1072#1090#1077#1083#1100')'
            DataBinding.FieldName = 'MFO_jof'
            Visible = False
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 112
          end
          object FonColor_AmountPlan_day: TcxGridDBColumn
            DataBinding.FieldName = 'FonColor_AmountPlan_day'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
          object FonColor_string: TcxGridDBColumn
            DataBinding.FieldName = 'FonColor_string'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 60
          end
        end
      end
      object edNPP: TcxCurrencyEdit
        Left = 484
        Top = 83
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####'
        Properties.ReadOnly = False
        TabOrder = 1
        Visible = False
        Width = 40
      end
    end
  end
  inherited Panel: TPanel
    Width = 1020
    Height = 33
    ExplicitWidth = 1020
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Left = 129
      EditValue = 45658d
      Enabled = False
      Properties.ReadOnly = True
      Properties.SaveTime = False
      ExplicitLeft = 129
      ExplicitWidth = 82
      Width = 82
    end
    inherited deEnd: TcxDateEdit
      Left = 237
      EditValue = 45658d
      Enabled = False
      Properties.ReadOnly = True
      Properties.SaveTime = False
      ExplicitLeft = 237
      ExplicitWidth = 79
      Width = 79
    end
    inherited cxLabel1: TcxLabel
      Left = 115
      Caption = #1089':'
      ExplicitLeft = 115
      ExplicitWidth = 13
    end
    inherited cxLabel2: TcxLabel
      Left = 215
      Caption = #1087#1086':'
      ExplicitLeft = 215
      ExplicitWidth = 20
    end
    object cxLabel3: TcxLabel
      Left = 174
      Top = 29
      Caption = #1053#1077#1076#1077#1083#1103' '#1087#1086':'
      Visible = False
    end
    object cxLabel4: TcxLabel
      Left = 3
      Top = 6
      Caption = #1053#1077#1076#1077#1083#1103':'
    end
    object edWeekNumber1: TcxButtonEdit
      Left = 49
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 64
    end
    object edWeekNumber2: TcxButtonEdit
      Left = 221
      Top = 28
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Visible = False
      Width = 31
    end
    object cxLabel12: TcxLabel
      Left = 644
      Top = 6
      Caption = #1041#1072#1085#1082' ('#1055#1083#1072#1090#1077#1083#1100#1097#1080#1082'):'
    end
    object edBankMain: TcxButtonEdit
      Left = 753
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 265
    end
  end
  object ExportXmlGrid: TcxGrid [2]
    Left = 0
    Top = 336
    Width = 1020
    Height = 74
    Align = alBottom
    Anchors = [akTop, akRight, akBottom]
    TabOrder = 6
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
    object mactExport_New_OTP_NPP: TMultiAction [0]
      Category = 'Export_file'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_FileNameNPP
        end
        item
          Action = actExport_fileNPP
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1080#1084#1087#1086#1088#1090' '#1087#1083#1072#1090#1077#1078#1077#1081' '#1076#1083#1103' '#8470' '#1086#1095#1077#1088#1077#1076#1080'?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1089#1086#1079#1076#1072#1085' '#1092#1072#1081#1083' '#1076#1083#1103' '#1080#1084#1087#1086#1088#1090#1072' '#1074' OTP Bank '#1076#1083#1103' '#8470' '#1086#1095#1077#1088#1077#1076#1080
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1080#1084#1087#1086#1088#1090' '#1074' OTP Bank '#1076#1083#1103' '#8470' '#1086#1095#1077#1088#1077#1076#1080
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1080#1084#1087#1086#1088#1090' '#1074' OTP Bank '#1076#1083#1103' '#8470' '#1086#1095#1077#1088#1077#1076#1080
    end
    object actRefreshStart: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_WeekNumber_byPeriod
      StoredProcList = <
        item
          StoredProc = spGet_WeekNumber_byPeriod
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spGet_Period
      StoredProcList = <
        item
          StoredProc = spGet_Period
        end
        item
          StoredProc = spSelect
        end>
    end
    object actGet_Export_FileNameNPP: TdsdExecStoredProc
      Category = 'Export_file'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_FileNameNPP
      StoredProcList = <
        item
          StoredProc = spGet_Export_FileNameNPP
        end>
      Caption = 'actGet_Export_FileName'
    end
    object actBankAccountChoicetFormMain: TOpenChoiceForm
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
          ComponentItem = 'BankAccountId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankAccountName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BankId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BankName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MFO'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MFO'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBankId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBankName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actExport_fileNPP: TdsdStoredProcExportToFile
      Category = 'Export_fileNPP'
      MoveParams = <>
      dsdStoredProcName = spSelect_ExportNPP
      FilePathParam.Value = ''
      FilePathParam.DataType = ftString
      FilePathParam.MultiSelectSeparator = ','
      FileNameParam.Value = Null
      FileNameParam.Component = FormParams
      FileNameParam.ComponentItem = 'outFileName'
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      FileExt = '.xml'
      FileExtParam.Value = Null
      FileExtParam.Component = FormParams
      FileExtParam.ComponentItem = 'outDefaultFileExt'
      FileExtParam.DataType = ftString
      FileExtParam.MultiSelectSeparator = ','
      FileNamePrefixParam.Value = ''
      FileNamePrefixParam.DataType = ftString
      FileNamePrefixParam.MultiSelectSeparator = ','
      FieldDefs = <>
      Left = 1208
      Top = 168
    end
    object actBankAccountChoicetForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TBankAccount_ObjectForm'
      FormName = 'TBankAccount_ChoiceForm'
      FormNameParam.Value = 'TBankAccount_ChoiceForm'
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
          Name = 'MFO'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MFO_jof'
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
    object actBankChoiceFormMain: TOpenChoiceForm
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
          ComponentItem = 'BankId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankName'
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
      StoredProc = spUpdate_PlanDate
      StoredProcList = <
        item
          StoredProc = spUpdate_PlanDate
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
    object mactExport_New_OTP: TMultiAction
      Category = 'Export_file'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_FileName
        end
        item
          Action = actExport_file
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1080#1084#1087#1086#1088#1090' '#1087#1083#1072#1090#1077#1078#1077#1081'?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1089#1086#1079#1076#1072#1085' '#1092#1072#1081#1083' '#1076#1083#1103' '#1080#1084#1087#1086#1088#1090#1072' '#1074' OTP Bank'
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1080#1084#1087#1086#1088#1090' '#1074' OTP Bank'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1080#1084#1087#1086#1088#1090' '#1087#1083#1072#1090#1077#1078#1077#1081' '#1074' OTP Bank'
    end
    object actExport_Grid: TExportGrid
      Category = 'Export_file'
      MoveParams = <>
      ExportType = cxegExportToText
      Grid = ExportXmlGrid
      Caption = 'actExport_Grid'
      OpenAfterCreate = False
      DefaultFileName = 'Report_'
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
    object actExport_file: TdsdStoredProcExportToFile
      Category = 'Export_file'
      MoveParams = <>
      dsdStoredProcName = spSelect_Export
      FilePathParam.Value = ''
      FilePathParam.DataType = ftString
      FilePathParam.MultiSelectSeparator = ','
      FileNameParam.Value = ''
      FileNameParam.Component = FormParams
      FileNameParam.ComponentItem = 'outFileName'
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      FileExt = '.xml'
      FileExtParam.Value = ''
      FileExtParam.Component = FormParams
      FileExtParam.ComponentItem = 'outDefaultFileExt'
      FileExtParam.DataType = ftString
      FileExtParam.MultiSelectSeparator = ','
      FileNamePrefixParam.Value = ''
      FileNamePrefixParam.DataType = ftString
      FileNamePrefixParam.MultiSelectSeparator = ','
      FieldDefs = <>
      Left = 1208
      Top = 168
    end
    object actPrintPlan: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100' '#1087#1083#1072#1090#1077#1078#1077#1081' '#1079#1072' 1 '#1076#1077#1085#1100
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
          IndexFieldNames = 'BankName;NumGroup;InfoMoneyName;JuridicalName'
        end>
      Params = <
        item
          Name = 'WeekNumber'
          Value = ''
          Component = edWeekNumber1
          ParamType = ptInput
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
          Value = 42160d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_OrderFinancePlan'
      ReportNameParam.Value = 'PrintMovement_OrderFinancePlan'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object MovementItemProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementItemId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object MovementProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementProtocolForm'
      FormNameParam.Value = 'TMovementProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateStatus_Complete: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateStatus_Complete
      StoredProcList = <
        item
          StoredProc = spUpdateStatus_Complete
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1047#1072#1082#1088#1099#1090#1100' '#1042#1057#1045' '#1076#1083#1103' '#1080#1089#1087#1088#1072#1074#1083#1077#1085#1080#1081
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1047#1072#1082#1088#1099#1090#1100' '#1042#1057#1045' '#1042#1080#1076#1099' '#1055#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103' '#1076#1083#1103' '#1080#1089#1087#1088#1072#1074#1083#1077#1085#1080#1081'?'
      InfoAfterExecute = #1047#1072#1082#1088#1099#1090#1099' '#1042#1057#1045' '#1042#1080#1076#1099' '#1055#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103' '#1076#1083#1103' '#1080#1089#1087#1088#1072#1074#1083#1077#1085#1080#1081
    end
    object actUpdateStatus_UnComplete: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateStatus_UnComplete
      StoredProcList = <
        item
          StoredProc = spUpdateStatus_UnComplete
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1083#1103' '#1080#1089#1087#1088#1072#1074#1083#1077#1085#1080#1081
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1082#1088#1099#1090#1100' '#1086#1076#1080#1085' '#1042#1080#1076' '#1055#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103' '#1076#1083#1103' '#1080#1089#1087#1088#1072#1074#1083#1077#1085#1080#1081'?'
      InfoAfterExecute = #1042#1099#1073#1088#1072#1085#1085#1099#1081' '#1042#1080#1076' '#1055#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103' '#1086#1090#1082#1088#1099#1090' '#1076#1083#1103' '#1080#1089#1087#1088#1072#1074#1083#1077#1085#1080#1081
    end
    object actGet_Export_Email_body: TdsdExecStoredProc
      Category = 'Export_Email_body'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_Email_Body
      StoredProcList = <
        item
          StoredProc = spGet_Export_Email_Body
        end>
      Caption = 'actGet_Export_Email'
    end
    object actSMTPFile_body: TdsdSMTPFileAction
      Category = 'Export_Email_body'
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
    object mactExport_body: TMultiAction
      Category = 'Export_Email_body'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_Email_body
        end
        item
          Action = actSMTPFile_body
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1059#1074#1077#1076#1086#1084#1080#1090#1100' '#1041#1091#1093#1075#1072#1083#1090#1077#1088#1080#1102' '#1087#1086' '#1087#1086#1095#1090#1077'?'
      InfoAfterExecute = #1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' '#1041#1091#1093#1075#1072#1083#1090#1077#1088#1080#1080' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1086
      Caption = #1059#1074#1077#1076#1086#1084#1080#1090#1100' '#1041#1091#1093#1075#1072#1083#1090#1077#1088#1080#1102
      Hint = #1059#1074#1077#1076#1086#1084#1080#1090#1100' '#1057#1041
      ImageIndex = 53
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
    StoredProcName = 'gpSelect_Movement_OrderFinance_PlanDate'
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
        Name = 'inBankMainId'
        Value = Null
        Component = GuidesBankMain
        ComponentItem = 'Key'
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
        Component = edWeekNumber1
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 200
    Top = 200
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateStatus_UnComplete'
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
          ItemName = 'bbUpdateStatus_Complete'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbExport_body'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementProtocolOpen'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocolOpen'
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
    object bbExport_New_OTP: TdxBarButton
      Action = mactExport_New_OTP
      Category = 0
    end
    object bbBank: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edNPP
    end
    object bbText: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object bbPrintPlan: TdxBarButton
      Action = actPrintPlan
      Category = 0
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = #1048#1084#1087#1086#1088#1090
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object dxBarButton1: TdxBarButton
      Action = mactExport_New_OTP_NPP
      Category = 0
    end
    object bbMovementItemProtocolOpen: TdxBarButton
      Action = MovementItemProtocolOpenForm
      Category = 0
    end
    object bbMovementProtocolOpen: TdxBarButton
      Action = MovementProtocolOpenForm
      Category = 0
    end
    object bbUpdateStatus_Complete: TdxBarButton
      Action = actUpdateStatus_Complete
      Category = 0
    end
    object bbUpdateStatus_UnComplete: TdxBarButton
      Action = actUpdateStatus_UnComplete
      Category = 0
    end
    object bbExport_body: TdxBarButton
      Action = mactExport_body
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ActionItemList = <
      item
      end>
    ColorRuleList = <
      item
        BackGroundValueColumn = FonColor_string
        ColorValueList = <>
      end
      item
        ColorColumn = AmountPlan_day
        BackGroundValueColumn = FonColor_AmountPlan_day
        ColorValueList = <>
      end>
    Left = 240
    Top = 248
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 80
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = edWeekNumber1
      end
      item
        Component = deStart
      end
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesWeek_Date1
      end
      item
        Component = GuidesBankMain
      end
      item
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
      end>
    Left = 135
    Top = 120
  end
  object spUpdate_PlanDate: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_OrderFinance_PlanDate'
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
        Name = 'inDateDay'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DateDay'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioDateDay_old'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DateDay_old'
        DataType = ftDateTime
        ParamType = ptInputOutput
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
        Name = 'ioAmountPlan_day'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan_day'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outWeekDay'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'WeekDay'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountPlan_1'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan_1'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountPlan_2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan_2'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountPlan_3'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan_3'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountPlan_4'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan_4'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountPlan_5'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlan_5'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 584
    Top = 152
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
    Left = 368
    Top = 88
  end
  object spSelect_Export: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderFinancePlan_XML'
    DataSet = ExportCDS
    DataSets = <
      item
        DataSet = ExportCDS
      end>
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeekNumber'
        Value = Null
        Component = edWeekNumber1
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankMainId'
        Value = '76970'
        Component = GuidesBankMain
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_1'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_2'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_3'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_4'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_5'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNPP'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNPP'
        Value = Null
        Component = edNPP
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 688
    Top = 216
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
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
        Name = 'outFileName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEncodingANSI'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 390
    Top = 159
  end
  object ExportCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 520
    Top = 304
  end
  object ExportDS: TDataSource
    DataSet = ExportCDS
    Left = 600
    Top = 312
  end
  object spGet_Export_FileName: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderFinance_FileNamePlan'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outFileName'
        Value = Null
        Component = FormParams
        ComponentItem = 'outFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        Component = FormParams
        ComponentItem = 'outDefaultFileExt'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEncodingANSI'
        Value = Null
        Component = FormParams
        ComponentItem = 'outEncodingANSI'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankName_Main'
        Value = Null
        Component = GuidesBankMain
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_1'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_2'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_3'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_4'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_5'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNPP'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNPP'
        Value = Null
        Component = edNPP
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 624
    Top = 224
  end
  object spGet_Period: TdsdStoredProc
    StoredProcName = 'spGet_Period_byWeekNumber'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inWeekNumber1'
        Value = ''
        Component = edWeekNumber1
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate_WeekNumber'
        Value = 45658d
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate_WeekNumber'
        Value = 45658d
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'WeekNumber2'
        Value = ''
        Component = edWeekNumber2
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 288
    Top = 80
  end
  object GuidesBankMain: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBankMain
    FormNameParam.Value = 'TBankForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBankMain
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBankMain
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 832
    Top = 21
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 868
    Top = 153
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 828
    Top = 166
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderFinancePlan_Print'
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
        Name = 'inOperDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankMainId'
        Value = Null
        Component = GuidesBankMain
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeekNumber'
        Value = Null
        Component = edWeekNumber1
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_1'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_2'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_3'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_4'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_5'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 751
    Top = 144
  end
  object spGet_Export_FileNameNPP: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderFinance_FileNamePlan'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outFileName'
        Value = Null
        Component = FormParams
        ComponentItem = 'outFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        Component = FormParams
        ComponentItem = 'outDefaultFileExt'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEncodingANSI'
        Value = Null
        Component = FormParams
        ComponentItem = 'outEncodingANSI'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankName_Main'
        Value = ''
        Component = GuidesBankMain
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 45658d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_1'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_2'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_3'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_4'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_5'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNPP'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNPP'
        Value = 0.000000000000000000
        Component = edNPP
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 616
    Top = 264
  end
  object spSelect_ExportNPP: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderFinancePlan_XML'
    DataSet = ExportCDS
    DataSets = <
      item
        DataSet = ExportCDS
      end>
    Params = <
      item
        Name = 'inOperDate'
        Value = 45658d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inWeekNumber'
        Value = ''
        Component = edWeekNumber1
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankMainId'
        Value = ''
        Component = GuidesBankMain
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_1'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_2'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_3'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_4'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDay_5'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisNPP'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNPP'
        Value = 0.000000000000000000
        Component = edNPP
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 232
  end
  object spUpdateStatus_UnComplete: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_OrderFinance_Status_UnComplete'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = 41640d
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 272
    Top = 136
  end
  object spUpdateStatus_Complete: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_OrderFinance_Status_Complete'
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
        Value = Null
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
    PackSize = 1
    Left = 280
    Top = 152
  end
  object ExportEmailDS: TDataSource
    DataSet = ExportEmailCDS
    Left = 408
    Top = 330
  end
  object ExportEmailCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 360
    Top = 329
  end
  object spGet_Export_Email_Body: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderFinance_Email_sendBody'
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
        ComponentItem = 'MovementId'
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
    Left = 288
    Top = 336
  end
end
