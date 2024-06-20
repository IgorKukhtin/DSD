inherited Report_Balance_gridForm: TReport_Balance_gridForm
  Caption = #1041#1072#1083#1072#1085#1089
  ClientHeight = 404
  ClientWidth = 1184
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1200
  ExplicitHeight = 443
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1184
    Height = 347
    TabOrder = 3
    ExplicitWidth = 1184
    ExplicitHeight = 347
    ClientRectBottom = 347
    ClientRectRight = 1184
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1184
      ExplicitHeight = 347
      inherited cxGrid: TcxGrid
        Width = 1184
        Height = 347
        ExplicitWidth = 1184
        ExplicitHeight = 347
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPassiveStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountDebetStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountKreditStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountActiveStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountDebet
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountKredit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountDebetEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountKreditEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountActiveEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPassiveEnd
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = AccountName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPassiveStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountDebetStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountKreditStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountActiveStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountDebet
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountKredit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountDebetEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountKreditEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountActiveEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPassiveEnd
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = InfoMoneyName
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
          object RootName: TcxGridDBColumn
            Caption = #1040'-'#1055
            DataBinding.FieldName = 'RootName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 70
          end
          object AccountGroupName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090'-'#1075#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'AccountGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 100
          end
          object AccountDirectionName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' - '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'AccountDirectionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 128
          end
          object AccountName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' - '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'AccountName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 144
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 70
          end
          object ByObjectName: TcxGridDBColumn
            Caption = #1054#1073#1098#1077#1082#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'ByObjectName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 70
          end
          object ByObjectItemName: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090' '#1085#1072#1087#1088#1072#1074#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'ByObjectItemName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 70
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1054#1073#1098#1077#1082#1090' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 70
          end
          object GoodsItemName: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'GoodsItemName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 70
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1053#1072#1083'/'#1041#1085
            DataBinding.FieldName = 'PaidKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 70
          end
          object JuridicalBasisName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086' ('#1075#1083#1072#1074#1085#1086#1077')'
            DataBinding.FieldName = 'JuridicalBasisName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 70
          end
          object BusinessName: TcxGridDBColumn
            Caption = #1041#1080#1079#1085#1077#1089
            DataBinding.FieldName = 'BusinessName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 70
          end
          object AmountDebetStart: TcxGridDBColumn
            Caption = #1044#1077#1073#1077#1090' '#1085#1072' '#1085#1072#1095#1072#1083#1086
            DataBinding.FieldName = 'AmountDebetStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 70
          end
          object AmountKreditStart: TcxGridDBColumn
            Caption = #1050#1088#1077#1076#1080#1090' '#1085#1072' '#1085#1072#1095#1072#1083#1086
            DataBinding.FieldName = 'AmountKreditStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 70
          end
          object AmountActiveStart: TcxGridDBColumn
            Caption = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
            DataBinding.FieldName = 'AmountActiveStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 70
          end
          object AmountPassiveStart: TcxGridDBColumn
            Caption = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1085#1072#1095#1072#1083#1086
            DataBinding.FieldName = 'AmountPassiveStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 98
          end
          object AmountDebet: TcxGridDBColumn
            Caption = #1044#1077#1073#1077#1090' '#1086#1073#1086#1088#1086#1090
            DataBinding.FieldName = 'AmountDebet'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 70
          end
          object AmountKredit: TcxGridDBColumn
            Caption = #1050#1088#1077#1076#1080#1090' '#1086#1073#1086#1088#1086#1090
            DataBinding.FieldName = 'AmountKredit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 70
          end
          object AmountDebetEnd: TcxGridDBColumn
            Caption = #1044#1077#1073#1077#1090' '#1085#1072' '#1082#1086#1085#1077#1094
            DataBinding.FieldName = 'AmountDebetEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 70
          end
          object AmountKreditEnd: TcxGridDBColumn
            Caption = #1050#1088#1077#1076#1080#1090' '#1085#1072' '#1082#1086#1085#1077#1094
            DataBinding.FieldName = 'AmountKreditEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 86
          end
          object AmountActiveEnd: TcxGridDBColumn
            Caption = #1040#1082#1090#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
            DataBinding.FieldName = 'AmountActiveEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 91
          end
          object AmountPassiveEnd: TcxGridDBColumn
            Caption = #1055#1072#1089#1089#1080#1074#1099' '#1085#1072' '#1082#1086#1085#1077#1094
            DataBinding.FieldName = 'AmountPassiveEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 102
          end
        end
      end
      object cbTotal: TcxCheckBox
        Left = 494
        Top = 131
        Caption = 'C'#1075#1088#1091#1087#1087#1080#1088#1086#1074#1072#1090#1100
        Properties.ReadOnly = False
        TabOrder = 1
        Width = 101
      end
      object cbGroup: TcxCheckBox
        Left = 494
        Top = 83
        Caption = ' '#1072#1082#1090#1080#1074'/'#1087#1072#1089#1089#1080#1074
        Properties.ReadOnly = False
        TabOrder = 2
        Width = 96
      end
    end
  end
  inherited Panel: TPanel
    Width = 1184
    ExplicitWidth = 1184
    inherited deStart: TcxDateEdit
      Left = 97
      EditValue = 43405d
      Properties.SaveTime = False
      ExplicitLeft = 97
    end
    inherited deEnd: TcxDateEdit
      Left = 300
      EditValue = 43405d
      Properties.SaveTime = False
      ExplicitLeft = 300
    end
    inherited cxLabel1: TcxLabel
      Left = 5
      ExplicitLeft = 5
    end
    inherited cxLabel2: TcxLabel
      Left = 189
      ExplicitLeft = 189
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 27
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 8
    Top = 144
  end
  inherited ActionList: TActionList
    object actRefreshUnit: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1088#1072#1079#1074#1077#1088#1085#1091#1090#1100' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      Hint = #1088#1072#1079#1074#1077#1088#1085#1091#1090#1100' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_BalanceDialogForm'
      FormNameParam.Value = 'TReport_BalanceDialogForm'
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
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrint_ol: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
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
          Name = 'BranchName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = '11'
      ReportNameParam.Value = '11'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actGetProfitLostParam: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetProfitLostParam
      StoredProcList = <
        item
          StoredProc = spGetProfitLostParam
        end>
      Caption = 'actGetProfitLostParam'
    end
    object actOpenReport_Account: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actOpenReport_Account'
      Hint = #1054#1090#1095#1077#1090' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1089#1095#1077#1090#1091'>'
      FormName = 'TReport_AccountForm'
      FormNameParam.Value = 'TReport_AccountForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 43405d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 43405d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'AccountId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'AccountGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountDirectionId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'AccountDirectionId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountDirectionName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountDirectionName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = FormParams
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BusinessId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'BusinessId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'BusinessName'
          Value = Null
          Component = FormParams
          ComponentItem = 'BusinessName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProfitLossGroupId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'ProfitLossGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProfitLossGroupName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ProfitLossGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProfitLossDirectionId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'ProfitLossDirectionId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProfitLossDirectionName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ProfitLossDirectionName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProfitLossId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'ProfitLossId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProfitLossName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ProfitLossName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'BranchId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchName'
          Value = Null
          Component = FormParams
          ComponentItem = 'BranchName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object macReport_Account: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetProfitLostParam
        end
        item
          Action = actOpenReport_Account
        end>
      Caption = #1054#1090#1095#1077#1090' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1089#1095#1077#1090#1091'>'
      Hint = #1054#1090#1095#1077#1090' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1089#1095#1077#1090#1091'>'
      ImageIndex = 25
    end
    object actOpenReport_AccountMotion: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1091
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1091
      FormName = 'TReport_AccountMotionForm'
      FormNameParam.Value = 'TReport_AccountMotionForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 43405d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 43405d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'AccountId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'AccountGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountGroupName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountDirectionId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'AccountDirectionId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'AccountDirectionName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccountDirectionName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = FormParams
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BusinessId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'BusinessId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'BusinessName'
          Value = Null
          Component = FormParams
          ComponentItem = 'BusinessName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProfitLossGroupId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'ProfitLossGroupId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProfitLossGroupName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ProfitLossGroupName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProfitLossDirectionId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'ProfitLossDirectionId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProfitLossDirectionName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ProfitLossDirectionName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProfitLossId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'ProfitLossId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ProfitLossName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ProfitLossName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'BranchId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchName'
          Value = Null
          Component = FormParams
          ComponentItem = 'BranchName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementDescId'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementDescName'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object macReport_AccountMotion: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetProfitLostParam
        end
        item
          Action = actOpenReport_AccountMotion
        end>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1091
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1091
      ImageIndex = 26
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
        end
        item
          FromParam.Value = 43405d
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
          FromParam.Value = 43405d
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
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDItems'
          IndexFieldNames = 'ProfitLossGroupName;ProfitLossDirectionName;ProfitLossName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 43405d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 43405d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'maintext'
          Value = #1088'/'#1089#1095#1077#1090#1091
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTotal'
          Value = False
          Component = cbTotal
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1059#1055' '#1054#1055#1080#1059
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1059#1055' '#1054#1055#1080#1059
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintBranch: TdsdPrintAction
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
          FromParam.Value = 43405d
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
          FromParam.Value = 43405d
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
      Caption = #1055#1077#1095#1072#1090#1100' ('#1092#1080#1083#1080#1072#1083#1099')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1092#1080#1083#1080#1072#1083#1099')'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDItems'
          IndexFieldNames = 'ProfitLossGroupName;ProfitLossDirectionName;ProfitLossName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 43405d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 43405d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'maintext'
          Value = #1088'/'#1089#1095#1077#1090#1091
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTotal'
          Value = False
          Component = cbTotal
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1059#1055' '#1054#1055#1080#1059' ('#1092#1080#1083#1080#1072#1083#1099')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1059#1055' '#1054#1055#1080#1059' ('#1092#1080#1083#1080#1072#1083#1099')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint2: TdsdPrintAction
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
          FromParam.Value = 43405d
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
          FromParam.Value = 43405d
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
      Caption = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090')'
      ImageIndex = 3
      DataSets = <
        item
          UserName = 'frxDBDItems'
          IndexFieldNames = 'RootName;AccountGroupName;AccountDirectionName;AccountName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 43405d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 43405d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'isTotal'
          Value = False
          Component = cbTotal
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGroup'
          Value = False
          Component = cbGroup
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1059#1055' '#1041#1072#1083#1072#1085#1089' ('#1044#1077#1073#1077#1090' '#1050#1088#1077#1076#1080#1090')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1059#1055' '#1041#1072#1083#1072#1085#1089' ('#1044#1077#1073#1077#1090' '#1050#1088#1077#1076#1080#1090')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint3: TdsdPrintAction
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
          FromParam.Value = 43405d
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
          FromParam.Value = 43405d
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
      Caption = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090') '#1089#1074#1077#1088#1085#1091#1090#1086
      Hint = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090') '#1089#1074#1077#1088#1085#1091#1090#1086
      ImageIndex = 18
      DataSets = <
        item
          UserName = 'frxDBDItems'
          IndexFieldNames = 
            'RootName_Detail;AccountGroupName_Detail;AccountDirectionName_Det' +
            'ail;AccountName_Detail;Num_Detail'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 43405d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 43405d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGroup'
          Value = False
          Component = cbGroup
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1059#1055' '#1041#1072#1083#1072#1085#1089' ('#1044#1077#1073#1077#1090' '#1050#1088#1077#1076#1080#1090') '#1089#1074#1077#1088#1085#1091#1090#1086
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1059#1055' '#1041#1072#1083#1072#1085#1089' ('#1044#1077#1073#1077#1090' '#1050#1088#1077#1076#1080#1090') '#1089#1074#1077#1088#1085#1091#1090#1086
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
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
    StoredProcName = 'gpReport_Balance'
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
      end>
    Left = 128
    Top = 200
  end
  inherited BarManager: TdxBarManager
    Left = 176
    Top = 216
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
          ItemName = 'bbReport_Account'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReport_AccountMotion'
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
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintBranch'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbTotal'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbcbGroup'
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
    object bbPrint: TdxBarButton
      Action = actPrint2
      Category = 0
    end
    object bbReport_Account: TdxBarButton
      Action = macReport_Account
      Category = 0
    end
    object bbReport_AccountMotion: TdxBarButton
      Action = macReport_AccountMotion
      Category = 0
    end
    object bbPrintBranch: TdxBarButton
      Action = actPrint3
      Category = 0
    end
    object bbTotal: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cbTotal
    end
    object bbcbGroup: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cbGroup
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 232
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 112
    Top = 128
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end
      item
      end>
    Left = 224
    Top = 136
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 328
    Top = 170
  end
  object spGetProfitLostParam: TdsdStoredProc
    StoredProcName = 'gpGetProfitLossParam'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inData'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RootType'
        Value = '0'
        Component = FormParams
        ComponentItem = 'RootType'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountGroupId'
        Value = '9023'
        Component = FormParams
        ComponentItem = 'AccountGroupId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountGroupName'
        Value = '100000 '#1057#1086#1073#1089#1090#1074#1077#1085#1085#1099#1081' '#1082#1072#1087#1080#1090#1072#1083
        Component = FormParams
        ComponentItem = 'AccountGroupName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountDirectionId'
        Value = '9072'
        Component = FormParams
        ComponentItem = 'AccountDirectionId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountDirectionName'
        Value = '100300 '#1055#1088#1080#1073#1099#1083#1100' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1087#1077#1088#1080#1086#1076#1072
        Component = FormParams
        ComponentItem = 'AccountDirectionName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountId'
        Value = '9210'
        Component = FormParams
        ComponentItem = 'AccountId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'AccountName'
        Value = '100301 '#1055#1088#1080#1073#1099#1083#1100' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1087#1077#1088#1080#1086#1076#1072
        Component = FormParams
        ComponentItem = 'AccountName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyId'
        Value = ''
        Component = FormParams
        ComponentItem = 'InfoMoneyId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InfoMoneyName'
        Value = ''
        Component = FormParams
        ComponentItem = 'InfoMoneyName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectDirectionId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'ObjectDirectionId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectDestinationId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'ObjectDestinationId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'JuridicalBasisId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BusinessId'
        Value = ''
        Component = FormParams
        ComponentItem = 'BusinessId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BusinessName'
        Value = ''
        Component = FormParams
        ComponentItem = 'BusinessName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProfitLossGroupId'
        Value = ''
        Component = FormParams
        ComponentItem = 'ProfitLossGroupId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProfitLossGroupName'
        Value = ''
        Component = FormParams
        ComponentItem = 'ProfitLossGroupName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProfitLossDirectionId'
        Value = ''
        Component = FormParams
        ComponentItem = 'ProfitLossDirectionId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProfitLossDirectionName'
        Value = ''
        Component = FormParams
        ComponentItem = 'ProfitLossDirectionName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProfitLossId'
        Value = ''
        Component = FormParams
        ComponentItem = 'ProfitLossId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProfitLossName'
        Value = ''
        Component = FormParams
        ComponentItem = 'ProfitLossName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchId'
        Value = ''
        Component = FormParams
        ComponentItem = 'BranchId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BranchName'
        Value = ''
        Component = FormParams
        ComponentItem = 'BranchName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 432
    Top = 256
  end
end
