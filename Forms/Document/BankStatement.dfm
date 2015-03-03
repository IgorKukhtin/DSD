inherited BankStatementForm: TBankStatementForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1041#1072#1085#1082#1086#1074#1089#1082#1072#1103' '#1074#1099#1087#1080#1089#1082#1072'>'
  ClientHeight = 416
  ClientWidth = 1084
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1100
  ExplicitHeight = 451
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 75
    Width = 1084
    Height = 199
    ExplicitTop = 75
    ExplicitWidth = 1084
    ExplicitHeight = 199
    ClientRectBottom = 199
    ClientRectRight = 1084
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1084
      ExplicitHeight = 199
      inherited cxGrid: TcxGrid
        Width = 1084
        Height = 199
        ExplicitWidth = 1084
        ExplicitHeight = 199
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colDebet
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colKredit
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colDebet
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colKredit
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.CellAutoHeight = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colDocNumber: TcxGridDBColumn
            Caption = #8470' '#1087#1083#1072#1090#1077#1078#1082#1080
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 69
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091' ('#1076#1086#1082#1091#1084#1077#1085#1090')'
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object colOKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 53
          end
          object colDebet: TcxGridDBColumn
            Caption = #1044#1077#1073#1077#1090
            DataBinding.FieldName = 'Debet'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00; ; ;'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object colKredit: TcxGridDBColumn
            Caption = #1050#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'Kredit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00; ; ;'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 52
          end
          object colAmountCurrency: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074' '#1074#1072#1083#1102#1090#1077
            DataBinding.FieldName = 'AmountCurrency'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colAmountSumm: TcxGridDBColumn
            Caption = 'C'#1091#1084#1084#1072' '#1075#1088#1085', '#1086#1073#1084#1077#1085
            DataBinding.FieldName = 'AmountSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colCurrency: TcxGridDBColumn
            Caption = '  '
            DataBinding.FieldName = 'CurrencyName'
            Options.Editing = False
            Width = 27
          end
          object CurrencyPartnerValue: TcxGridDBColumn
            Caption = #1050#1091#1088#1089
            DataBinding.FieldName = 'CurrencyPartnerValue'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ParPartnerValue: TcxGridDBColumn
            Caption = #1053#1086#1084#1080#1085#1072#1083
            DataBinding.FieldName = 'ParPartnerValue'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object CurrencyValue: TcxGridDBColumn
            Caption = #1050#1091#1088#1089' '#1059#1055
            DataBinding.FieldName = 'CurrencyValue'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ParValue: TcxGridDBColumn
            Caption = #1053#1086#1084#1080#1085#1072#1083' '#1082#1091#1088#1089' '#1059#1055
            DataBinding.FieldName = 'ParValue'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colContract: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceContract
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 65
          end
          object colLinkJuridicalName: TcxGridDBColumn
            Caption = #1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091' ('#1085#1072#1081#1076#1077#1085#1086')'
            DataBinding.FieldName = 'LinkJuridicalName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceJuridical
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 96
          end
          object clInfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object clInfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clInfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colInfoMoney: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceInfoMoney
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceUnit
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentVert = vaCenter
            Width = 112
          end
          object colBankAccount: TcxGridDBColumn
            Caption = #1057#1095#1077#1090
            DataBinding.FieldName = 'BankAccount'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 54
          end
          object colBankMFO: TcxGridDBColumn
            Caption = #1052#1060#1054
            DataBinding.FieldName = 'BankMFO'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colBankName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1073#1072#1085#1082#1072
            DataBinding.FieldName = 'BankName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          object colComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            PropertiesClassName = 'TcxMemoProperties'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 158
          end
        end
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 1084
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
    object cxLabel1: TcxLabel
      Left = 8
      Top = 5
      Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edInvNumber: TcxTextEdit
      Left = 8
      Top = 20
      Enabled = False
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 95
    end
    object cxLabel2: TcxLabel
      Left = 112
      Top = 5
      Caption = #1044#1072#1090#1072
    end
    object edOperDate: TcxDateEdit
      Left = 112
      Top = 20
      Enabled = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 3
      Width = 108
    end
    object cxLabel3: TcxLabel
      Left = 227
      Top = 5
      Caption = #1041#1072#1085#1082
    end
    object cxLabel4: TcxLabel
      Left = 374
      Top = 5
      Caption = #1057#1095#1077#1090
    end
    object edBankName: TcxTextEdit
      Left = 227
      Top = 20
      Enabled = False
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 142
    end
    object edBankAccount: TcxTextEdit
      Left = 375
      Top = 20
      Enabled = False
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 160
    end
  end
  object cxSplitter: TcxSplitter [2]
    Left = 0
    Top = 274
    Width = 1084
    Height = 5
    AlignSplitter = salBottom
    Control = BottomPanel
  end
  object BottomPanel: TPanel [3]
    Left = 0
    Top = 279
    Width = 1084
    Height = 137
    Align = alBottom
    TabOrder = 7
    object dxBarDockControl: TdxBarDockControl
      Left = 1
      Top = 1
      Width = 1082
      Height = 26
      Align = dalTop
      BarManager = BarManager
    end
    object cxDetailGrid: TcxGrid
      Left = 1
      Top = 27
      Width = 1082
      Height = 109
      Align = alClient
      TabOrder = 1
      object cxDetailGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Inserting = False
        OptionsView.GroupByBox = False
      end
      object cxDetailGridLevel: TcxGridLevel
        GridView = cxDetailGridDBTableView
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 232
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 232
  end
  inherited ActionList: TActionList
    Left = 79
    Top = 247
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end>
    end
    object actChoiceJuridical: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actChoiceJuridical'
      FormName = 'TMoneyPlace_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LinkJuridicalId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LinkJuridicalName'
          DataType = ftString
        end
        item
          Name = 'ContractId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end
        item
          Name = 'ContractName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractName'
          DataType = ftString
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'InfoMoneyCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyCode'
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actChoiceInfoMoney: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actChoiceInfoMoney'
      FormName = 'TInfoMoney_ObjectForm'
      FormNameParam.Value = 'TInfoMoney_ObjectForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end
        item
          Name = 'InfoMoneyCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyCode'
        end>
      isShowModal = False
    end
    object actChoiceContract: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actChoiceContract'
      FormName = 'TContractChoiceForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractId'
          ParamType = ptInput
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LinkJuridicalId'
          ParamType = ptInput
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LinkJuridicalName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
          ParamType = ptInput
        end
        item
          Name = 'InfoMoneyCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyCode'
          ParamType = ptInput
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'MasterJuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LinkJuridicalId'
        end
        item
          Name = 'MasterJuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LinkJuridicalName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actChoiceUnit: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actUnitForm'
      FormName = 'TUnitForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUpdate
      StoredProcList = <
        item
          StoredProc = spUpdate
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object actSendToBankAccount: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spBankAccount_From_BankStatement
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1086' '#1088'\'#1089
      ImageIndex = 27
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1086' '#1088'\'#1089'?'
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1086' '#1088'\'#1089' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099'.'
    end
    object InsertJuridical: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1102#1088'. '#1083#1080#1094#1086
      ImageIndex = 0
      FormName = 'TJuridicalEditForm'
      FormNameParam.Value = 'TJuridicalEditForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          ParamType = ptInput
        end
        item
          Name = 'OKPO'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OKPO'
          DataType = ftString
        end
        item
          Name = 'Name'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
        end>
      isShowModal = False
      DataSource = MasterDS
      IdFieldName = 'Id'
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 104
  end
  inherited MasterCDS: TClientDataSet
    Left = 24
    Top = 96
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_BankStatementItem'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Top = 112
  end
  inherited BarManager: TdxBarManager
    Left = 104
    Top = 120
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbSendToBankAccount'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertJuridical'
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
    object BarManagerBar1: TdxBar [1]
      Caption = #1056#1072#1079#1076#1077#1083#1077#1085#1085#1099#1077' '#1079#1072#1087#1080#1089#1080
      CaptionButtons = <>
      DockControl = dxBarDockControl
      DockedDockControl = dxBarDockControl
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 1110
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbSendToBankAccount: TdxBarButton
      Action = actSendToBankAccount
      Category = 0
    end
    object bbInsertJuridical: TdxBarButton
      Action = InsertJuridical
      Category = 0
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inPaidKindId'
        Value = '3'
        ParamType = ptInput
      end>
    Left = 184
    Top = 208
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_BankStatement'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'invnumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
      end
      item
        Name = 'operdate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
      end
      item
        Name = 'bankaccountname'
        Value = ''
        Component = edBankAccount
        DataType = ftString
      end
      item
        Name = 'bankname'
        Value = ''
        Component = edBankName
        DataType = ftString
      end>
    PackSize = 1
    Left = 248
    Top = 40
  end
  object spUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_BankStatementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'injuridicalid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'LinkJuridicalId'
        ParamType = ptInput
      end
      item
        Name = 'ininfomoneyid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InfoMoneyId'
        ParamType = ptInput
      end
      item
        Name = 'incontractid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
      end
      item
        Name = 'inunitid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Unitid'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 320
    Top = 128
  end
  object spBankAccount_From_BankStatement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_BankAccount_From_BankStatement'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 200
    Top = 152
  end
  object RefreshAddOn: TRefreshAddOn
    FormName = 'BankStatementJournalForm'
    DataSet = 'MasterCDS'
    KeyField = 'Id'
    RefreshAction = 'actRefresh'
    FormParams = 'FormParams'
    Left = 427
    Top = 253
  end
end
