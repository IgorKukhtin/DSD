inherited JuridicalOrderFinanceForm: TJuridicalOrderFinanceForm
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1070#1088'.'#1083#1080#1094#1072' '#1074' '#1087#1083#1072#1085#1080#1088#1086#1074#1072#1085#1080#1080' '#1087#1083#1072#1090#1077#1078#1077#1081
  ClientHeight = 423
  ClientWidth = 920
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  AddOnFormData.Params = FormParams
  ExplicitWidth = 936
  ExplicitHeight = 461
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 57
    Width = 920
    Height = 366
    ExplicitTop = 57
    ExplicitWidth = 920
    ExplicitHeight = 366
    ClientRectBottom = 366
    ClientRectRight = 920
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 920
      ExplicitHeight = 366
      inherited cxGrid: TcxGrid
        Width = 920
        Height = 366
        ExplicitWidth = 920
        ExplicitHeight = 366
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = BankAccountName_main
            end>
          OptionsBehavior.IncSearch = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object BankName_main: TcxGridDBColumn
            Caption = #1041#1072#1085#1082' ('#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072')'
            DataBinding.FieldName = 'BankName_main'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 114
          end
          object BankAccountName_main: TcxGridDBColumn
            Caption = #1056'/'#1057#1095#1077#1090' ('#1087#1083#1072#1090#1077#1083#1100#1097#1080#1082#1072')'
            DataBinding.FieldName = 'BankAccountName_main'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1088'/'#1089#1095#1077#1090', '#1089' '#1082#1086#1090#1086#1088#1086#1075#1086' '#1084#1099' '#1087#1083#1072#1090#1080#1084
            Options.Editing = False
            Width = 156
          end
          object JuridicalCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1102#1088'.'#1083#1080#1094#1072
            DataBinding.FieldName = 'JuridicalCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 192
          end
          object OKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055' '#1089#1090#1072#1090#1100#1080
            DataBinding.FieldName = 'InfoMoneyCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object BankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082' ('#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103')'
            DataBinding.FieldName = 'BankName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object BankAccountName: TcxGridDBColumn
            Caption = #1056'/'#1057#1095#1077#1090' ('#1087#1086#1083#1091#1095#1072#1090#1077#1083#1103')'
            DataBinding.FieldName = 'BankAccountName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1088'/'#1089#1095#1077#1090', '#1085#1072' '#1082#1086#1090#1086#1088#1099#1081' '#1084#1099' '#1087#1083#1072#1090#1080#1084
            Options.Editing = False
            Width = 171
          end
          object SummOrderFinance: TcxGridDBColumn
            Caption = #1051#1080#1084#1080#1090' '#1087#1086' '#1089#1091#1084#1084#1077' '#1086#1090#1089#1088#1086#1095#1082#1080
            DataBinding.FieldName = 'SummOrderFinance'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object Comment: TcxGridDBColumn
            Caption = #1053#1072#1079#1085#1072#1095#1077#1085#1080#1077' '#1087#1083#1072#1090#1077#1078#1072
            DataBinding.FieldName = 'Comment'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
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
    Width = 920
    Height = 31
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
          ComponentItem = 'GoodsName'
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
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1086#1093#1088#1072#1085#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1086#1093#1088#1072#1085#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
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
    Left = 144
    Top = 88
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
          BeginGroup = True
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
    SearchAsFilter = False
  end
  object spInsertUpdate: TdsdStoredProc
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
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inValue'
        Value = 0.000000000000000000
        Component = MasterCDS
        ComponentItem = 'Value'
        DataType = ftFloat
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
      end>
    Left = 432
    Top = 144
  end
  object FormParams: TdsdFormParams
    Params = <>
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
    Left = 656
    Top = 184
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
end
