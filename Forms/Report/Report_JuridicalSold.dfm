inherited Report_JuridicalSoldForm: TReport_JuridicalSoldForm
  Caption = #1054#1090#1095#1077#1090' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1102#1088'.'#1083#1080#1094#1072#1084'>'
  ClientHeight = 555
  ClientWidth = 1127
  ExplicitWidth = 1135
  ExplicitHeight = 582
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 83
    Width = 1127
    Height = 472
    TabOrder = 3
    ExplicitTop = 83
    ExplicitWidth = 1127
    ExplicitHeight = 472
    ClientRectBottom = 472
    ClientRectRight = 1127
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1127
      ExplicitHeight = 472
      inherited cxGrid: TcxGrid
        Width = 1127
        Height = 472
        ExplicitWidth = 1127
        ExplicitHeight = 472
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colStartAmount_A
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colEndAmount_A
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSaleSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colServiceSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colMoneySumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colOtherSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colStartAmount_P
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colStartAmountD
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colStartAmountK
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colIncomeSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colReturnOutSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colReturnInSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSendDebtSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colEndAmount_P
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colEndAmount_D
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colEndAmount_K
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colDebetSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colKreditSumm
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colStartAmount_A
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colEndAmount_A
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSaleSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colServiceSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colMoneySumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colOtherSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colStartAmount_P
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colStartAmountD
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colStartAmountK
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colIncomeSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colReturnOutSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colReturnInSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colSendDebtSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colEndAmount_P
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colEndAmount_D
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colEndAmount_K
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colDebetSumm
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colKreditSumm
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colJuridicalCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1102#1088'.'#1083'.'
            DataBinding.FieldName = 'JuridicalCode'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 142
          end
          object colOKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colContractCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractCode'
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colContractNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractNumber'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object colPaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colAccountName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090
            DataBinding.FieldName = 'AccountName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colInfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colInfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colInfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colInfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colStartAmount_A: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1076#1086#1083#1075' ('#1040#1082#1090#1080#1074')'
            DataBinding.FieldName = 'StartAmount_A'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colStartAmount_P: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1076#1086#1083#1075' ('#1055#1072#1089#1089#1080#1074')'
            DataBinding.FieldName = 'StartAmount_P'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Visible = False
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colStartAmountD: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1076#1086#1083#1075' ('#1044#1077#1073#1077#1090')'
            DataBinding.FieldName = 'StartAmountD'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Visible = False
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colStartAmountK: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1076#1086#1083#1075' ('#1050#1088#1077#1076#1080#1090')'
            DataBinding.FieldName = 'StartAmountK'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Visible = False
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colIncomeSumm: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'IncomeSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colReturnOutSumm: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090'-'#1082#1091'.'
            DataBinding.FieldName = 'ReturnOutSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colSaleSumm: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1072
            DataBinding.FieldName = 'SaleSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.EditFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colReturnInSumm: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082'.'
            DataBinding.FieldName = 'ReturnInSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colMoneySumm: TcxGridDBColumn
            Caption = #1054#1087#1083#1072#1090#1072' (+)'#1087#1088#1080#1093' (-)'#1088#1072#1089#1093'.'
            DataBinding.FieldName = 'MoneySumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colServiceSumm: TcxGridDBColumn
            Caption = #1059#1089#1083#1091#1075#1080'. (+)'#1087#1086#1083#1091#1095'. (-)'#1086#1082#1072#1079#1072#1085'.'
            DataBinding.FieldName = 'ServiceSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colSendDebtSumm: TcxGridDBColumn
            Caption = #1042#1079'-'#1079#1072#1095#1077#1090' (+)'#1086#1087#1083'.'#1087#1088#1080#1093'. (-)'#1086#1087#1083'.'#1088#1072#1089#1093'.'
            DataBinding.FieldName = 'SendDebtSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colOtherSumm: TcxGridDBColumn
            Caption = '***'
            DataBinding.FieldName = 'OtherSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object colDebetSumm: TcxGridDBColumn
            Caption = #1054#1073#1086#1088#1086#1090' '#1044#1077#1073#1077#1090
            DataBinding.FieldName = 'DebetSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Visible = False
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colKreditSumm: TcxGridDBColumn
            Caption = #1054#1073#1086#1088#1086#1090' '#1050#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'KreditSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Visible = False
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colEndAmount_A: TcxGridDBColumn
            Caption = #1050#1086#1085'. '#1076#1086#1083#1075' ('#1040#1082#1090#1080#1074')'
            DataBinding.FieldName = 'EndAmount_A'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colEndAmount_P: TcxGridDBColumn
            Caption = #1050#1086#1085'.  '#1076#1086#1083#1075' ('#1055#1072#1089#1089#1080#1074')'
            DataBinding.FieldName = 'EndAmount_P'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Visible = False
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colEndAmount_D: TcxGridDBColumn
            Caption = #1050#1086#1085'. '#1076#1086#1083#1075' ('#1044#1077#1073#1077#1090')'
            DataBinding.FieldName = 'EndAmount_D'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Visible = False
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colEndAmount_K: TcxGridDBColumn
            Caption = #1050#1086#1085'. '#1076#1086#1083#1075' ('#1050#1088#1077#1076#1080#1090')'
            DataBinding.FieldName = 'EndAmount_K'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##'
            Visible = False
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1127
    Height = 57
    ExplicitWidth = 1127
    ExplicitHeight = 57
    inherited deStart: TcxDateEdit
      Left = 118
      EditValue = 41609d
      ExplicitLeft = 118
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 30
      EditValue = 41639d
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
      Left = 365
      Top = 7
      Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object ceInfoMoneyGroup: TcxButtonEdit
      Left = 365
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 160
    end
    object ceInfoMoneyDestination: TcxButtonEdit
      Left = 531
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 6
      Width = 160
    end
    object cxLabel4: TcxLabel
      Left = 531
      Top = 7
      Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
    end
    object ceInfoMoney: TcxButtonEdit
      Left = 697
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 8
      Width = 160
    end
    object cxLabel5: TcxLabel
      Left = 697
      Top = 7
      Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
    end
    object cxLabel6: TcxLabel
      Left = 209
      Top = 6
      Caption = #1057#1095#1077#1090':'
    end
    object edAccount: TcxButtonEdit
      Left = 209
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 11
      Width = 150
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = AccountGuides
        Properties.Strings = (
          'FormName'
          'FormNameParam'
          'Key'
          'KeyField'
          'LookupControl'
          'Name'
          'Params'
          'ParentDataSet'
          'ParentId'
          'PositionDataSet'
          'Tag'
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
        Component = InfoMoneyDestinationGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = InfoMoneyGroupGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = InfoMoneyGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object dsdPrintAction: TdsdPrintAction
      Category = 'DSDLib'
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1086#1090#1095#1077#1090#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <>
      Params = <
        item
          Name = 'StartDate'
          Value = 41609d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41639d
          Component = deEnd
          DataType = ftDateTime
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1076#1086#1083#1075#1086#1084')'
      ReportNameParam.Value = ''
      ReportNameParam.DataType = ftString
    end
    object IncomeJournal: TdsdOpenForm
      Category = 'DSDLib'
      Caption = 'IncomeJournal'
      FormName = 'TMovementJournalForm'
      FormNameParam.Value = 'TMovementJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41609d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41639d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'DescSet'
          Value = 'Income'
          DataType = ftString
        end
        item
          Name = 'ContractId'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end>
      isShowModal = False
    end
    object ReturnOutJournal: TdsdOpenForm
      Category = 'DSDLib'
      Caption = 'ReturnOutJournal'
      FormName = 'TMovementJournalForm'
      FormNameParam.Value = 'TMovementJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41609d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41639d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'DescSet'
          Value = 'ReturnOut'
          DataType = ftString
        end
        item
          Name = 'ContractId'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end>
      isShowModal = False
    end
    object SaleJournal: TdsdOpenForm
      Category = 'DSDLib'
      FormName = 'TMovementJournalForm'
      FormNameParam.Value = 'TMovementJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41609d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41639d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'DescSet'
          Value = 'Sale'
          DataType = ftString
        end
        item
          Name = 'ContractId'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end>
      isShowModal = False
    end
    object ReturnInJournal: TdsdOpenForm
      Category = 'DSDLib'
      Caption = 'ReturnInJournal'
      FormName = 'TMovementJournalForm'
      FormNameParam.Value = 'TMovementJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41609d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41639d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'DescSet'
          Value = 'ReturnIn'
          DataType = ftString
        end
        item
          Name = 'ContractId'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end>
      isShowModal = False
    end
    object MoneyJournal: TdsdOpenForm
      Category = 'DSDLib'
      Caption = 'MoneyJournal'
      FormName = 'TMovementJournalForm'
      FormNameParam.Value = 'TMovementJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41609d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41639d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'DescSet'
          Value = 'Cash;BankAccount'
          DataType = ftString
        end
        item
          Name = 'ContractId'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end>
      isShowModal = False
    end
    object ServiceJournal: TdsdOpenForm
      Category = 'DSDLib'
      Caption = 'ServiceJournal'
      FormName = 'TMovementJournalForm'
      FormNameParam.Value = 'TMovementJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41609d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41639d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'DescSet'
          Value = 'Service'
          DataType = ftString
        end
        item
          Name = 'ContractId'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end>
      isShowModal = False
    end
    object SendDebtJournal: TdsdOpenForm
      Category = 'DSDLib'
      Caption = 'SendDebtJournal'
      FormName = 'TMovementJournalForm'
      FormNameParam.Value = 'TMovementJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41609d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41639d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'DescSet'
          Value = 'SendDebt'
          DataType = ftString
        end
        item
          Name = 'ContractId'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end>
      isShowModal = False
    end
    object OtherJournal: TdsdOpenForm
      Category = 'DSDLib'
      Caption = 'OtherJournal'
      FormName = 'TMovementJournalForm'
      FormNameParam.Value = 'TMovementJournalForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41609d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41639d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'DescSet'
          Value = 'Sale'
          DataType = ftString
        end
        item
          Name = 'ContractId'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 48
  end
  inherited MasterCDS: TClientDataSet
    IndexFieldNames = 'JuridicalName'
    Top = 48
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_JuridicalSold'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41609d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41639d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inAccountId'
        Value = ''
        Component = AccountGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyId'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyGroupId'
        Value = ''
        Component = InfoMoneyGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyDestinationId'
        Value = ''
        Component = InfoMoneyDestinationGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Top = 48
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 48
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
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
          ItemName = 'bbRefresh'
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
      Action = dsdPrintAction
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColumnAddOnList = <
      item
        Column = colIncomeSumm
        Action = IncomeJournal
      end
      item
        Column = colReturnOutSumm
        Action = ReturnOutJournal
      end
      item
        Column = colSaleSumm
        Action = SaleJournal
      end
      item
        Column = colReturnInSumm
        Action = ReturnInJournal
      end
      item
        Column = colMoneySumm
        Action = MoneyJournal
      end
      item
        Column = colServiceSumm
        Action = ServiceJournal
      end
      item
        Column = colSendDebtSumm
        Action = SendDebtJournal
      end
      item
        Column = colOtherSumm
        Action = OtherJournal
      end>
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = AccountGuides
      end
      item
        Component = InfoMoneyGroupGuides
      end
      item
        Component = InfoMoneyDestinationGuides
      end
      item
        Component = InfoMoneyGuides
      end>
  end
  object frxDBDataset: TfrxDBDataset
    UserName = 'frxDBDataset'
    CloseDataSource = False
    DataSource = MasterDS
    BCDToCurrency = False
    Left = 184
    Top = 264
  end
  object InfoMoneyGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoneyGroup
    FormNameParam.Value = 'TInfoMoneyGroupForm'
    FormNameParam.DataType = ftString
    FormName = 'TInfoMoneyGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = InfoMoneyGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InfoMoneyGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 776
    Top = 53
  end
  object InfoMoneyDestinationGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoneyDestination
    FormNameParam.Value = 'TInfoMoneyDestinationForm'
    FormNameParam.DataType = ftString
    FormName = 'TInfoMoneyDestinationForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = InfoMoneyDestinationGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InfoMoneyDestinationGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 584
    Top = 53
  end
  object InfoMoneyGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceInfoMoney
    FormNameParam.Value = 'TInfoMoney_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TInfoMoney_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = InfoMoneyGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 440
    Top = 61
  end
  object AccountGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edAccount
    FormNameParam.Value = 'TAccount_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TAccount_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = AccountGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValueAll'
        Value = ''
        Component = AccountGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 312
    Top = 48
  end
end
