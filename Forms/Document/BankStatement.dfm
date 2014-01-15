inherited BankStatementForm: TBankStatementForm
  Caption = #1042#1099#1087#1080#1089#1082#1080' '#1073#1072#1085#1082#1072
  ClientHeight = 416
  ClientWidth = 1084
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1092
  ExplicitHeight = 443
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
          OptionsView.CellAutoHeight = True
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
            Caption = #1070#1088' '#1083#1080#1094#1086' '#1080#1079' '#1074#1099#1087#1080#1089#1082#1080
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
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
          object colCurrency: TcxGridDBColumn
            Caption = '  '
            DataBinding.FieldName = 'CurrencyName'
            Options.Editing = False
            Width = 27
          end
          object colLinkJuridicalName: TcxGridDBColumn
            Caption = #1070#1088' '#1083#1080#1094#1086' '#1074' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
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
          object colInfoMoney: TcxGridDBColumn
            Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1072#1103' '#1089#1090#1072#1090#1100#1103
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
            Width = 111
          end
          object colContract: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
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
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
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
    Images = dmMain.ImageList
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
      Caption = 'actChoiceJuridical'
      FormName = 'TJuridicalForm'
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'LinkJuridicalId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'LinkJuridicalName'
          DataType = ftString
        end
        item
          Name = 'InfoMoneyId'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'InfoMoneyName'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actChoiceInfoMoney: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'actChoiceInfoMoney'
      FormName = 'TInfoMoneyForm'
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actChoiceContract: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'actChoiceContract'
      FormName = 'TContractChoiceForm'
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'ContractId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'ContractName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actChoiceUnit: TOpenChoiceForm
      Category = 'DSDLib'
      Caption = 'actUnitForm'
      FormName = 'TUnitForm'
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'UnitId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
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
      StoredProc = spBankAccount_From_BankStatement
      StoredProcList = <
        item
          StoredProc = spBankAccount_From_BankStatement
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1086' '#1088'\'#1089
      ImageIndex = 27
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
          ItemName = 'bbRefresh'
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
          ItemName = 'bbSendToBankAccount'
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
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInput
      end>
    Left = 112
    Top = 232
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
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'injuridicalid'
        Component = MasterCDS
        ComponentItem = 'LinkJuridicalId'
        ParamType = ptInput
      end
      item
        Name = 'ininfomoneyid'
        Component = MasterCDS
        ComponentItem = 'InfoMoneyId'
        ParamType = ptInput
      end
      item
        Name = 'incontractid'
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
      end
      item
        Name = 'inunitid'
        Component = MasterCDS
        ComponentItem = 'Unitid'
        ParamType = ptInput
      end>
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
    Left = 208
    Top = 120
  end
end
