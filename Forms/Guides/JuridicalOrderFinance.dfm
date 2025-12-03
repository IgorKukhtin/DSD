inherited JuridicalOrderFinanceForm: TJuridicalOrderFinanceForm
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1070#1088'.'#1083#1080#1094#1072' '#1074' '#1087#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1080' '#1087#1083#1072#1090#1077#1078#1077#1081
  ClientHeight = 559
  ClientWidth = 1086
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1102
  ExplicitHeight = 598
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 99
    Width = 1086
    Height = 460
    ExplicitTop = 99
    ExplicitWidth = 1086
    ExplicitHeight = 460
    ClientRectBottom = 460
    ClientRectRight = 1086
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1086
      ExplicitHeight = 460
      inherited cxGrid: TcxGrid
        Width = 1086
        Height = 460
        ExplicitWidth = 1086
        ExplicitHeight = 460
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = BankAccountName_main
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
          object BankName_main: TcxGridDBColumn
            Caption = #1041#1072#1085#1082' ('#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072')'
            DataBinding.FieldName = 'BankName_main'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actBankChoiceFormMain
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 114
          end
          object MFO_main: TcxGridDBColumn
            Caption = #1052#1060#1054' ('#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072')'
            DataBinding.FieldName = 'MFO_main'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object BankAccountName_main: TcxGridDBColumn
            Caption = #1056'/'#1057#1095#1077#1090' ('#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072')'
            DataBinding.FieldName = 'BankAccountName_main'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actBankAccountChoicetFormMain
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1088'/'#1089#1095#1077#1090', '#1089' '#1082#1086#1090#1086#1088#1086#1075#1086' '#1084#1099' '#1087#1083#1072#1090#1080#1084
            Width = 156
          end
          object JuridicalCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'JuridicalCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1102#1088'.'#1083#1080#1094#1072
            Options.Editing = False
            Width = 70
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
            Width = 192
          end
          object OKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
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
            Width = 80
          end
          object NumGroup: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087' '#1059#1055
            DataBinding.FieldName = 'NumGroup'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
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
            Width = 100
          end
          object BankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082' ('#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103')'
            DataBinding.FieldName = 'BankName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actBankChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 87
          end
          object MFO: TcxGridDBColumn
            Caption = #1052#1060#1054' ('#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103')'
            DataBinding.FieldName = 'MFO'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object BankAccountName: TcxGridDBColumn
            Caption = #1056'/'#1057#1095#1077#1090' ('#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103')'
            DataBinding.FieldName = 'BankAccountName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actBankAccountChoicetForm
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1088'/'#1089#1095#1077#1090', '#1085#1072' '#1082#1086#1090#1086#1088#1099#1081' '#1084#1099' '#1087#1083#1072#1090#1080#1084
            Width = 171
          end
          object SummOrderFinance: TcxGridDBColumn
            Caption = #1051#1080#1084#1080#1090' '#1087#1086' '#1089#1091#1084#1084#1077' '#1086#1090#1089#1088#1086#1095#1082#1080
            DataBinding.FieldName = 'SummOrderFinance'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object Amount: TcxGridDBColumn
            Caption = 'C'#1091#1084#1084#1072' '#1087#1083#1072#1090#1077#1078#1072
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1083#1072#1090#1077#1078#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Comment: TcxGridDBColumn
            Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077' '#1087#1083#1072#1090#1077#1078#1072
            DataBinding.FieldName = 'Comment'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object isErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
        end
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 1086
    Height = 73
    Align = alTop
    TabOrder = 5
    object cxLabel3: TcxLabel
      Left = 437
      Top = 6
      Hint = #1041#1072#1085#1082' ('#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072')'
      Caption = #1041#1072#1085#1082' ('#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072'):'
    end
    object edBank: TcxButtonEdit
      Left = 552
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 233
    end
    object cxLabel2: TcxLabel
      Left = 22
      Top = 6
      Caption = #1056'/'#1057#1095#1077#1090' ('#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072'):'
    end
    object edBankAccount: TcxButtonEdit
      Left = 147
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 273
    end
    object cxLabel4: TcxLabel
      Left = 804
      Top = 6
      Caption = #1042#1080#1076' '#1055#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1103':'
    end
    object edOrderFinance: TcxButtonEdit
      Left = 913
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Text = #1042#1110#1076#1076#1110#1083' '#1079#1072#1073#1077#1079#1073#1077#1095#1077#1085#1085#1103
      Width = 175
    end
    object lbSearchName: TcxLabel
      Left = 8
      Top = 44
      Caption = #1070#1088'. '#1083#1080#1094#1086': '
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchJuridicalName: TcxTextEdit
      Left = 81
      Top = 45
      TabOrder = 7
      DesignSize = (
        140
        21)
      Width = 140
    end
    object cxLabel1: TcxLabel
      Left = 235
      Top = 44
      Caption = #1054#1050#1055#1054': '
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchOKPO: TcxTextEdit
      Left = 281
      Top = 45
      TabOrder = 9
      DesignSize = (
        123
        21)
      Width = 123
    end
  end
  object cxLabel5: TcxLabel [2]
    Left = 421
    Top = 44
    Caption = #1056'/'#1057#1095#1077#1090' ('#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103'): '
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
  end
  object edSearchBankAccountName: TcxTextEdit [3]
    Left = 573
    Top = 45
    TabOrder = 7
    DesignSize = (
      135
      21)
    Width = 135
  end
  object cxLabel6: TcxLabel [4]
    Left = 722
    Top = 44
    Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077': '
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
  end
  object edSearchComment: TcxTextEdit [5]
    Left = 811
    Top = 45
    TabOrder = 9
    DesignSize = (
      140
      21)
    Width = 140
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
  end
  inherited ActionList: TActionList
    object actRefreshStart: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spGetPeriod
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end>
    end
    inherited actInsert: TInsertUpdateChoiceAction
      FormName = 'TTaxUnitEditForm'
      FormNameParam.Value = nil
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Price'
          Value = 0.000000000000000000
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = 0.000000000000000000
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TTaxUnitEditForm'
      FormNameParam.Name = '1'
      FormNameParam.Value = nil
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
          Name = 'Price'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Price'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Value'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Value'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    inherited dsdSetUnErased: TdsdUpdateErased
      ShortCut = 49220
    end
    inherited dsdSetErased: TdsdUpdateErased
      ShortCut = 49220
    end
    inherited dsdChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end>
    end
    inherited ProtocolOpenForm: TdsdOpenForm
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
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1086#1093#1088#1072#1085#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1086#1093#1088#1072#1085#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actShowDel: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 65
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 64
      ImageIndexFalse = 65
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'ExecuteDialog'
      FormName = 'TDatePeriodDialogForm'
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
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'inEndDate'
          DataType = ftDateTime
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macInsert_byMovBankAccount: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialog
        end
        item
          Action = actInsert_byMovBankAccount
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1088'/'#1089#1095#1077#1090#1072'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1086#1073#1085#1086#1074#1083#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1088'/'#1089#1095#1077#1090#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1088'/'#1089#1095#1077#1090#1072
      ImageIndex = 27
    end
    object actInsert_byMovBankAccount: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_byMovBankAccount
      StoredProcList = <
        item
          StoredProc = spInsert_byMovBankAccount
        end>
      Caption = 'actInsert_byMovBankAccount'
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
          ComponentItem = 'BankId_main'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankName_main'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
          ComponentItem = 'BankAccountId_main'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankAccountName_main'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BankId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankId_main'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BankName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankName_main'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MFO'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MFO_main'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBankId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankId_main'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBankName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BankName_main'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
  end
  inherited MasterDS: TDataSource
    Left = 24
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Left = 48
    Top = 152
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_JuridicalOrderFinance'
    Params = <
      item
        Name = 'inBankAccountId_main'
        Value = Null
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOrderFinanceId'
        Value = Null
        Component = GuidesOrderFinance
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisErased'
        Value = Null
        Component = actShowDel
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 296
  end
  inherited BarManager: TdxBarManager
    Left = 272
    Top = 152
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
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
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
          ItemName = 'bbShowAll'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowDel'
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
          ItemName = 'bbChoiceGuides'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsert_byMovBankAccount'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenForm'
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
    inherited dxBarStatic: TdxBarStatic
      Caption = ''
      Hint = ''
      ShowCaption = False
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbShowDel: TdxBarButton
      Action = actShowDel
      Category = 0
    end
    object bbIn: TdxBarControlContainerItem
      Category = 0
      Visible = ivAlways
    end
    object bbInsert_byMovBankAccount: TdxBarButton
      Action = macInsert_byMovBankAccount
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
        ShortCut = 13
      end>
  end
  inherited PopupMenu: TPopupMenu
    inherited N2: TMenuItem
      Visible = False
    end
    inherited N3: TMenuItem
      Visible = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_JuridicalOrderFinance'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
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
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInfoMoneyId'
        Value = 0.000000000000000000
        Component = MasterCDS
        ComponentItem = 'InfoMoneyId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BankId_main'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BankId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountMainName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BankAccountName_main'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BankAccountName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummOrderFinance'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummOrderFinance'
        DataType = ftFloat
        ParamType = ptInput
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
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 328
    Top = 216
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesBankAccount
      end
      item
        Component = GuidesOrderFinance
      end>
    Left = 392
    Top = 192
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'OrderFinanceId'
        Value = '3988049'
        Component = GuidesOrderFinance
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OrderFinanceName'
        Value = #1042#1110#1076#1076#1110#1083' '#1079#1072#1073#1077#1079#1073#1077#1095#1077#1085#1085#1103
        Component = GuidesOrderFinance
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 224
    Top = 224
  end
  object GuidesBank: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBank
    FormNameParam.Value = 'TBankForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBankForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesBank
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesBank
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 584
    Top = 1
  end
  object GuidesBankAccount: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBankAccount
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
        DataType = ftString
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
        Name = 'BankId'
        Value = ''
        Component = GuidesBank
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankName'
        Value = ''
        Component = GuidesBank
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 65528
  end
  object spInsert_byMovBankAccount: TdsdStoredProc
    StoredProcName = 'gpInsert_Object_JuridicalOrderFinance_byBankAccount'
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
      end
      item
        Name = 'inBankAccountId_main'
        Value = Null
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 600
    Top = 176
  end
  object spGetPeriod: TdsdStoredProc
    StoredProcName = 'gpGet_Period_JuridicalOrderFinance'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'StartDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inStartDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inEndDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 815
    Top = 178
  end
  object GuidesOrderFinance: TdsdGuides
    KeyField = 'Id'
    LookupControl = edOrderFinance
    Key = '3988049'
    TextValue = #1042#1110#1076#1076#1110#1083' '#1079#1072#1073#1077#1079#1073#1077#1095#1077#1085#1085#1103
    FormNameParam.Value = 'TOrderFinance_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderFinance_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesOrderFinance
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesOrderFinance
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountId'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'BankAccountNameAll'
        Value = ''
        Component = GuidesBankAccount
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId_1'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName_1'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId_2'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName_2'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 960
  end
  object FieldFilter: TdsdFieldFilter
    TextEdit = edSearchJuridicalName
    DataSet = MasterCDS
    Column = JuridicalName
    ColumnList = <
      item
        Column = JuridicalName
      end
      item
        Column = OKPO
        TextEdit = edSearchOKPO
      end
      item
        Column = BankAccountName
        TextEdit = edSearchBankAccountName
      end
      item
        Column = Comment
        TextEdit = edSearchComment
      end>
    ActionNumber1 = dsdChoiceGuides
    CheckBoxList = <>
    Left = 456
    Top = 208
  end
end
