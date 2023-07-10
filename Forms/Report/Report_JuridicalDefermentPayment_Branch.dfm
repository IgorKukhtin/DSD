inherited Report_JuridicalDefermentPayment_BranchForm: TReport_JuridicalDefermentPayment_BranchForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1086#1082#1091#1087#1072#1090#1077#1083#1080' '#1089' '#1086#1090#1089#1088#1086#1095#1082#1086#1081'> ('#1087#1086' '#1092#1080#1083#1080#1072#1083#1072#1084')'
  ClientHeight = 394
  ClientWidth = 1123
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1139
  ExplicitHeight = 433
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 83
    Width = 1123
    Height = 311
    TabOrder = 3
    ExplicitTop = 83
    ExplicitWidth = 1123
    ExplicitHeight = 311
    ClientRectBottom = 311
    ClientRectRight = 1123
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1123
      ExplicitHeight = 311
      inherited cxGrid: TcxGrid
        Width = 1123
        Height = 311
        ExplicitWidth = 1123
        ExplicitHeight = 311
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
            Caption = '7 '#1076#1085'.'
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
            Caption = '14 '#1076#1085'.'
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
            Caption = '21 '#1076#1085'.'
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
            Caption = '28 '#1076#1085'.'
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
            Caption = '>28 '#1076#1085'.'
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
    Width = 1123
    Height = 57
    ExplicitWidth = 1123
    ExplicitHeight = 57
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
    object cxLabel11: TcxLabel
      Left = 10
      Top = 32
      Caption = #1044#1072#1090#1072' '#1087#1088#1086#1076#1072#1078' '#1089' :'
    end
    object deStart_sale: TcxDateEdit
      Left = 102
      Top = 30
      EditValue = 42005d
      Properties.ShowTime = False
      TabOrder = 13
      Width = 80
    end
    object cxLabel12: TcxLabel
      Left = 188
      Top = 32
      Caption = #1044#1072#1090#1072' '#1087#1088#1086#1076#1072#1078' '#1087#1086':'
    end
    object deEnd_sale: TcxDateEdit
      Left = 280
      Top = 32
      EditValue = 42005d
      Properties.ShowTime = False
      TabOrder = 15
      Width = 80
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
      end
      item
        Component = deStart_sale
        Properties.Strings = (
          'Date')
      end
      item
        Component = deEnd_sale
        Properties.Strings = (
          'Date')
      end>
  end
  inherited ActionList: TActionList
    object actPrintOneWeek: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = '1'
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
      Caption = #1055#1077#1088#1074#1072#1103' '#1085#1077#1076#1077#1083#1103
      Hint = #1055#1077#1088#1074#1072#1103' '#1085#1077#1076#1077#1083#1103
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
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintTwoWeek: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = '2'
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
      Caption = #1042#1090#1086#1088#1072#1103' '#1085#1077#1076#1077#1083#1103
      Hint = #1042#1090#1086#1088#1072#1103' '#1085#1077#1076#1077#1083#1103
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
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintThreeWeek: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = '3'
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
      Caption = #1058#1088#1077#1090#1100#1103' '#1085#1077#1076#1077#1083#1103
      Hint = #1058#1088#1077#1090#1100#1103' '#1085#1077#1076#1077#1083#1103
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
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintFourWeek: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = '4'
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
      Caption = #1063#1077#1090#1074#1077#1088#1090#1072#1103' '#1085#1077#1076#1077#1083#1103
      Hint = #1063#1077#1090#1074#1077#1088#1090#1072#1103' '#1085#1077#1076#1077#1083#1103
      ImageIndex = 22
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
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
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
          FromParam.Value = '5'
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
      Caption = #1041#1086#1083#1100#1096#1077' 28 '#1076#1085#1077#1081
      Hint = #1041#1086#1083#1100#1096#1077' 28 '#1076#1085#1077#1081
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
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081'-'#1085#1072#1082#1083#1072#1076#1085#1099#1077')'
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
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1086#1090#1089#1088#1086#1095#1082#1086#1081')'
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
      FormName = 'TReport_JuridicalDefermentPayment_BranchDialogForm'
      FormNameParam.Value = 'TReport_JuridicalDefermentPayment_BranchDialogForm'
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
        end
        item
          Name = 'StartDate_start'
          Value = Null
          Component = deStart_sale
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate_start'
          Value = Null
          Component = deEnd_sale
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
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
    StoredProcName = 'gpReport_JuridicalDefermentPayment_Branch'
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
        Name = 'inStartDate_sale'
        Value = Null
        Component = deStart_sale
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate_sale'
        Value = Null
        Component = deEnd_sale
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
    Left = 128
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
          ItemName = 'bbReportOneWeek'
        end
        item
          Visible = True
          ItemName = 'bbTwoWeek'
        end
        item
          Visible = True
          ItemName = 'bbThreeWeek'
        end
        item
          Visible = True
          ItemName = 'bbFourWeek'
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
        end>
    end
    object bbReportOneWeek: TdxBarButton
      Action = actPrintOneWeek
      Category = 0
    end
    object bbTwoWeek: TdxBarButton
      Action = actPrintTwoWeek
      Category = 0
    end
    object bbThreeWeek: TdxBarButton
      Action = actPrintThreeWeek
      Category = 0
    end
    object bbFourWeek: TdxBarButton
      Action = actPrintFourWeek
      Category = 0
    end
    object bbOther: TdxBarButton
      Action = actPrintOther
      Category = 0
    end
    object bbPribt: TdxBarButton
      Action = actPrint
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
    Left = 456
    Top = 8
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
    Left = 224
    Top = 200
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
    Left = 344
    Top = 112
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
    Left = 200
    Top = 248
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
  object PeriodChoice1: TPeriodChoice
    DateStart = deStart_sale
    DateEnd = deEnd_sale
    Left = 336
    Top = 32
  end
end
