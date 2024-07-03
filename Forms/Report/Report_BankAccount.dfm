inherited Report_BankAccountForm: TReport_BankAccountForm
  Caption = #1054#1090#1095#1077#1090' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1088'/'#1089#1095#1077#1090#1091'>'
  ClientHeight = 555
  ClientWidth = 982
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 998
  ExplicitHeight = 594
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 83
    Width = 982
    Height = 472
    TabOrder = 3
    ExplicitTop = 83
    ExplicitWidth = 982
    ExplicitHeight = 472
    ClientRectBottom = 472
    ClientRectRight = 982
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 982
      ExplicitHeight = 472
      inherited cxGrid: TcxGrid
        Width = 982
        Height = 472
        ExplicitWidth = 982
        ExplicitHeight = 472
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = StartAmount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EndAmount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = DebetSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = KreditSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = StartAmountD
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = StartAmountK
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EndAmountD
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EndAmountK
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = StartAmount_Currency
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = StartAmountD_Currency
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = StartAmountK_Currency
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = DebetSumm_Currency
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = KreditSumm_Currency
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EndAmount_Currency
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EndAmountD_Currency
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EndAmountK_Currency
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Summ_Currency
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Summ_pl
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = StartAmount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EndAmount
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = DebetSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = KreditSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = StartAmountD
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = StartAmountK
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EndAmountD
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EndAmountK
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = StartAmount_Currency
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = StartAmountD_Currency
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = StartAmountK_Currency
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = DebetSumm_Currency
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = KreditSumm_Currency
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EndAmount_Currency
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EndAmountD_Currency
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = EndAmountK_Currency
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Summ_Currency
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Summ_pl
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GroupName: TcxGridDBColumn
            Caption = #1042#1080#1076
            DataBinding.FieldName = 'GroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object BankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082
            DataBinding.FieldName = 'BankName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object BankAccountName: TcxGridDBColumn
            Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
            DataBinding.FieldName = 'BankAccountName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 105
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086' ('#1088'.'#1089#1095'.)'
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object CurrencyName_BankAccount: TcxGridDBColumn
            Caption = #1042#1072#1083#1102#1090#1072' '#1088'.'#1089#1095'.'
            DataBinding.FieldName = 'CurrencyName_BankAccount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object MoneyPlaceName: TcxGridDBColumn
            Caption = #1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091
            DataBinding.FieldName = 'MoneyPlaceName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 105
          end
          object ItemName: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090
            DataBinding.FieldName = 'ItemName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
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
          object ContractInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractInvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object ContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
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
            Width = 121
          end
          object InfoMoneyName_all: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'InfoMoneyName_all'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object UnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1076#1088'.'
            DataBinding.FieldName = 'UnitCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object StartAmount: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1089#1072#1083#1100#1076#1086
            DataBinding.FieldName = 'StartAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object StartAmountD: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1089#1072#1083#1100#1076#1086' ('#1044#1077#1073#1077#1090')'
            DataBinding.FieldName = 'StartAmountD'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object StartAmountK: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1089#1072#1083#1100#1076#1086' ('#1050#1088#1077#1076#1080#1090')'
            DataBinding.FieldName = 'StartAmountK'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object DebetSumm: TcxGridDBColumn
            Caption = #1054#1073#1086#1088#1086#1090' '#1044#1077#1073#1077#1090
            DataBinding.FieldName = 'DebetSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object KreditSumm: TcxGridDBColumn
            Caption = #1054#1073#1086#1088#1086#1090' '#1050#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'KreditSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object EndAmount: TcxGridDBColumn
            Caption = #1050#1086#1085'. '#1089#1072#1083#1100#1076#1086
            DataBinding.FieldName = 'EndAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object EndAmountD: TcxGridDBColumn
            Caption = #1050#1086#1085'. '#1089#1072#1083#1100#1076#1086' ('#1044#1077#1073#1077#1090')'
            DataBinding.FieldName = 'EndAmountD'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object EndAmountK: TcxGridDBColumn
            Caption = #1050#1086#1085'. '#1089#1072#1083#1100#1076#1086' ('#1050#1088#1077#1076#1080#1090')'
            DataBinding.FieldName = 'EndAmountK'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Summ_Currency: TcxGridDBColumn
            Caption = #1050#1091#1088#1089#1086#1074#1072#1103' '#1088#1072#1079#1085#1080#1094#1072
            DataBinding.FieldName = 'Summ_Currency'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '(+) '#1089#1091#1084#1084#1072' '#1087#1088#1080#1073#1099#1083#1100'  (-) '#1089#1091#1084#1084#1072' '#1091#1073#1099#1090#1086#1082
            Options.Editing = False
            Width = 70
          end
          object Summ_pl: TcxGridDBColumn
            Caption = #1055#1088#1086#1095#1077#1077
            DataBinding.FieldName = 'Summ_pl'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '(+) '#1089#1091#1084#1084#1072' '#1076#1086#1087'. '#1087#1088#1080#1073#1099#1083#1100'  (-) '#1089#1091#1084#1084#1072' '#1091#1073#1099#1090#1086#1082
            Options.Editing = False
            Width = 70
          end
          object StartAmount_Currency: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1089#1072#1083#1100#1076#1086' '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'StartAmount_Currency'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object StartAmountD_Currency: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1089#1072#1083#1100#1076#1086' '#1074' '#1074#1072#1083'. ('#1044#1077#1073#1077#1090')'
            DataBinding.FieldName = 'StartAmountD_Currency'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object StartAmountK_Currency: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1089#1072#1083#1100#1076#1086' '#1074' '#1074#1072#1083'. ('#1050#1088#1077#1076#1080#1090')'
            DataBinding.FieldName = 'StartAmountK_Currency'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object DebetSumm_Currency: TcxGridDBColumn
            Caption = #1054#1073#1086#1088#1086#1090' '#1044#1077#1073#1077#1090' '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'DebetSumm_Currency'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object KreditSumm_Currency: TcxGridDBColumn
            Caption = #1054#1073#1086#1088#1086#1090' '#1050#1088#1077#1076#1080#1090' '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'KreditSumm_Currency'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object EndAmount_Currency: TcxGridDBColumn
            Caption = #1050#1086#1085'. '#1089#1072#1083#1100#1076#1086' '#1074' '#1074#1072#1083'.'
            DataBinding.FieldName = 'EndAmount_Currency'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object EndAmountD_Currency: TcxGridDBColumn
            Caption = #1050#1086#1085'. '#1089#1072#1083#1100#1076#1086' '#1074' '#1074#1072#1083'. ('#1044#1077#1073#1077#1090')'
            DataBinding.FieldName = 'EndAmountD_Currency'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object EndAmountK_Currency: TcxGridDBColumn
            Caption = #1050#1086#1085'. '#1089#1072#1083#1100#1076#1086' '#1074' '#1074#1072#1083'. ('#1050#1088#1077#1076#1080#1090')'
            DataBinding.FieldName = 'EndAmountK_Currency'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.AssignedValues.EditFormat = True
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object CurrencyName: TcxGridDBColumn
            Caption = #1042#1072#1083#1102#1090#1072
            DataBinding.FieldName = 'CurrencyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ProfitLossGroupCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1054#1055#1080#1059' '#1075#1088'. ('#1076#1083#1103' '#1087#1086#1076#1088'. )'
            DataBinding.FieldName = 'ProfitLossGroupCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object ProfitLossGroupName: TcxGridDBColumn
            Caption = #1054#1055#1080#1059' '#1075#1088#1091#1087#1087#1072' ('#1076#1083#1103' '#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103')'
            DataBinding.FieldName = 'ProfitLossGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object ProfitLossDirectionCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1054#1055#1080#1059' '#1085#1072#1087#1088'.  ('#1076#1083#1103' '#1087#1086#1076#1088'.)'
            DataBinding.FieldName = 'ProfitLossDirectionCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object ProfitLossDirectionName: TcxGridDBColumn
            Caption = #1054#1055#1080#1059' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077'  ('#1076#1083#1103' '#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103')'
            DataBinding.FieldName = 'ProfitLossDirectionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 180
          end
          object AccountName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090
            DataBinding.FieldName = 'AccountName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CashName: TcxGridDBColumn
            DataBinding.FieldName = 'CashName'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          object GroupId: TcxGridDBColumn
            DataBinding.FieldName = 'GroupId'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 982
    Height = 57
    ExplicitWidth = 982
    ExplicitHeight = 57
    inherited deStart: TcxDateEdit
      Left = 118
      EditValue = 43831d
      Properties.SaveTime = False
      ExplicitLeft = 118
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 30
      EditValue = 43831d
      Properties.SaveTime = False
      ExplicitLeft = 118
      ExplicitTop = 30
    end
    inherited cxLabel1: TcxLabel
      Left = 27
      ExplicitLeft = 27
    end
    inherited cxLabel2: TcxLabel
      Left = 8
      Top = 31
      ExplicitLeft = 8
      ExplicitTop = 31
    end
    object cxLabel3: TcxLabel
      Left = 215
      Top = 31
      Caption = #1057#1095#1077#1090' '#1085#1072#1079#1074#1072#1085#1080#1077':'
    end
    object edAccount: TcxButtonEdit
      Left = 298
      Top = 32
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 263
    end
    object ceBankAccount: TcxButtonEdit
      Left = 298
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 263
    end
    object cxLabel4: TcxLabel
      Left = 209
      Top = 6
      Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090':'
    end
    object cxLabel10: TcxLabel
      Left = 596
      Top = 31
      Caption = #1042#1072#1083#1102#1090#1072':'
    end
    object edCurrency: TcxButtonEdit
      Left = 645
      Top = 32
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 151
    end
    object cxLabel27: TcxLabel
      Left = 567
      Top = 6
      Caption = #1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077':'
    end
    object edJuridicalBasis: TcxButtonEdit
      Left = 645
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 151
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 35
    Top = 328
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = GuidesCurrency
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
      end>
    Left = 56
    Top = 272
  end
  inherited ActionList: TActionList
    Left = 127
    Top = 327
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spGetDescSets
      StoredProcList = <
        item
          StoredProc = spGetDescSets
        end
        item
          StoredProc = spSelect
        end>
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
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
      Caption = #1054#1090#1095#1077#1090' - '#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1088'/'#1089#1095#1077#1090#1072#1084
      Hint = #1054#1090#1095#1077#1090' - '#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1088'/'#1089#1095#1077#1090#1072#1084
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDItems'
          IndexFieldNames = 'AccountName;BankName;BankAccountName'
        end>
      Params = <
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
        end>
      ReportName = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1088#1072#1089#1095#1077#1090#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
      ReportNameParam.Value = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1088#1072#1089#1095#1077#1090#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_byElements: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42005d
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42005d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1088'/'#1089' ('#1087#1086' '#1101#1083#1077#1084#1077#1085#1090#1072#1084')'
      Hint = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1088'/'#1089' ('#1087#1086' '#1101#1083#1077#1084#1077#1085#1090#1072#1084')'
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDItems'
          IndexFieldNames = 'cashname;GroupId;InfoMoneyName_all;MoneyPlaceName;Comment'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'maintext'
          Value = #1088'/'#1089#1095#1077#1090#1091
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1082#1072#1089#1089#1077' ('#1087#1086' '#1101#1083#1077#1084#1077#1085#1090#1072#1084')'
      ReportNameParam.Value = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1082#1072#1089#1089#1077' ('#1087#1086' '#1101#1083#1077#1084#1077#1085#1090#1072#1084')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_byElements_byComments: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42005d
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42005d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = Null
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1088'/'#1089' ('#1089' '#1082#1086#1084#1084#1077#1085#1090#1072#1088#1080#1103#1084#1080')'
      Hint = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1088'/'#1089' ('#1089' '#1082#1086#1084#1084#1077#1085#1090#1072#1088#1080#1103#1084#1080')'
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDItems'
          IndexFieldNames = 'BankAccountName;GroupId;InfoMoneyName_all;MoneyPlaceName;Comment'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'maintext'
          Value = #1088'/'#1089#1095#1077#1090#1091
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1082#1072#1089#1089#1077' ('#1089' '#1082#1086#1084#1084#1077#1085#1090#1072#1088#1080#1103#1084#1080')'
      ReportNameParam.Value = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1082#1072#1089#1089#1077' ('#1089' '#1082#1086#1084#1084#1077#1085#1090#1072#1088#1080#1103#1084#1080')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
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
      FormName = 'TReport_BankAccountDialogForm'
      FormNameParam.Value = 'TReport_BankAccountDialogForm'
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
          Name = 'BankAccountId'
          Value = ''
          Component = GuidesBankAccount
          ComponentItem = 'Key'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BankAccountName'
          Value = ''
          Component = GuidesBankAccount
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountId'
          Value = ''
          Component = GuidesAccount
          ComponentItem = 'Key'
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
          Name = 'CurrencyId'
          Value = ''
          Component = GuidesCurrency
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CurrencyName'
          Value = ''
          Component = GuidesCurrency
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalBasisId'
          Value = Null
          Component = GuidesJuridicalBasis
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalBasisName'
          Value = Null
          Component = GuidesJuridicalBasis
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Top = 184
  end
  inherited MasterCDS: TClientDataSet
    IndexFieldNames = 'MoneyPlaceName'
    Top = 184
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_BankAccount'
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
        Component = GuidesJuridicalBasis
        ComponentItem = 'Key'
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
        Name = 'inBankAccountId'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId'
        Value = ''
        Component = GuidesCurrency
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDetail'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 184
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 184
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
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_byElements'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_byElements_byComments'
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
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbPrint_byElements: TdxBarButton
      Action = actPrint_byElements
      Category = 0
    end
    object bbPrint_byElements_byComments: TdxBarButton
      Action = actPrint_byElements_byComments
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  inherited PopupMenu: TPopupMenu
    Left = 128
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 144
    Top = 8
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesBankAccount
      end
      item
        Component = GuidesAccount
      end
      item
        Component = GuidesCurrency
      end
      item
        Component = GuidesJuridicalBasis
      end>
    Top = 228
  end
  object spGetDescSets: TdsdStoredProc
    StoredProcName = 'gpGetDescSets'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'IncomeDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'IncomeDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnOutDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnOutDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SaleDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'SaleDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnInDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnInDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MoneyDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'MoneyDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ServiceDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SendDebtDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'SendDebtDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OtherDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'OtherDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SaleRealDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'SaleRealDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnInRealDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReturnInRealDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TransferDebtDesc'
        Value = Null
        Component = FormParams
        ComponentItem = 'TransferDebtDesc'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
    Top = 232
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'IncomeDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnOutDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SaleDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnInDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MoneyDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SendDebtDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OtherDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'SaleRealDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReturnInRealDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TransferDebtDesc'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 232
  end
  object GuidesAccount: TdsdGuides
    KeyField = 'Id'
    LookupControl = edAccount
    FormNameParam.Value = 'TAccount_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAccount_ObjectForm'
    PositionDataSet = 'ClientDataSet'
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
      end>
    Left = 456
    Top = 8
  end
  object GuidesBankAccount: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceBankAccount
    FormNameParam.Value = 'TBankAccount_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankAccount_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 380
    Top = 29
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpReport_BankAccount'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
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
        Component = GuidesJuridicalBasis
        ComponentItem = 'Key'
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
        Name = 'inBankAccountId'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId'
        Value = ''
        Component = GuidesCurrency
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDetail'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 639
    Top = 288
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 724
    Top = 334
  end
  object GuidesCurrency: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCurrency
    FormNameParam.Value = 'TCurrency_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCurrency_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCurrency
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCurrency
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 696
    Top = 32
  end
  object GuidesJuridicalBasis: TdsdGuides
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
        Component = GuidesJuridicalBasis
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridicalBasis
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 783
  end
  object spGet_UseJuridicalBankAccount: TdsdStoredProc
    StoredProcName = 'gpGet_UserJuridicalBankAccount'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'JuridicalBasisId'
        Value = '0'
        Component = GuidesJuridicalBasis
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisName'
        Value = ''
        Component = GuidesJuridicalBasis
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 911
    Top = 26
  end
end
