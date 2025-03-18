inherited BankStatementForm: TBankStatementForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1041#1072#1085#1082#1086#1074#1089#1082#1072#1103' '#1074#1099#1087#1080#1089#1082#1072'>'
  ClientHeight = 416
  ClientWidth = 1084
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1100
  ExplicitHeight = 455
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
              Column = Debet
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Kredit
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = Debet
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = Kredit
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
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1087#1083#1072#1090#1077#1078#1082#1080
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 69
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091' ('#1076#1086#1082#1091#1084#1077#1085#1090')'
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object OKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 53
          end
          object ServiceDate: TcxGridDBColumn
            Caption = #1052#1077#1089#1103#1094' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081
            DataBinding.FieldName = 'ServiceDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'MMMM YYYY'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1077#1089#1103#1094' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081
            Options.Editing = False
            Width = 83
          end
          object Debet: TcxGridDBColumn
            Caption = #1044#1077#1073#1077#1090
            DataBinding.FieldName = 'Debet'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00; ; ;'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object Kredit: TcxGridDBColumn
            Caption = #1050#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'Kredit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00; ; ;'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 52
          end
          object AmountCurrency: TcxGridDBColumn
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
          object AmountSumm: TcxGridDBColumn
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
          object CurrencyName: TcxGridDBColumn
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
          object Contract: TcxGridDBColumn
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
          object LinkJuridicalName: TcxGridDBColumn
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
          object LinkINN: TcxGridDBColumn
            Caption = #1048#1053#1053
            DataBinding.FieldName = 'LinkINN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1053#1053' ('#1086#1090' '#1082#1086#1075#1086', '#1082#1086#1084#1091' ('#1085#1072#1081#1076#1077#1085#1086'))'
            Options.Editing = False
            Width = 70
          end
          object PartnerName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'PartnerName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoicePartner
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Width = 70
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object InfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoney: TcxGridDBColumn
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
          object UnitName: TcxGridDBColumn
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
          object BankAccount: TcxGridDBColumn
            Caption = #1057#1095#1077#1090
            DataBinding.FieldName = 'BankAccount'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 54
          end
          object BankMFO: TcxGridDBColumn
            Caption = #1052#1060#1054
            DataBinding.FieldName = 'BankMFO'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object BankName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1073#1072#1085#1082#1072
            DataBinding.FieldName = 'BankName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            PropertiesClassName = 'TcxMemoProperties'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 158
          end
          object InvNumber_Invoice: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1057#1095#1077#1090
            DataBinding.FieldName = 'InvNumber_Invoice'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actInvoiceJournalDetailChoiceForm
                Default = True
                Hint = #1042#1099#1073#1088#1072#1090#1100' '#8470' '#1076#1086#1082'. '#1057#1095#1077#1090
                Kind = bkEllipsis
              end
              item
                Action = actClear_Invoice
                Kind = bkGlyph
              end>
            Properties.Images = dmMain.ImageList
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object MovementId_Invoice: TcxGridDBColumn
            DataBinding.FieldName = 'MovementId_Invoice'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 100
          end
          object Comment_Invoice: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1076#1086#1082'.'#1057#1095#1077#1090')'
            DataBinding.FieldName = 'Comment_Invoice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
        end
        object cxGridLevel1: TcxGridLevel
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
    object cxLabel6: TcxLabel
      Left = 545
      Top = 2
      Caption = #1052#1077#1089#1103#1094' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1081
    end
    object edServiceDate: TcxDateEdit
      Left = 545
      Top = 20
      EditValue = 41640d
      Properties.DisplayFormat = 'mmmm yyyy'
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 9
      Width = 112
    end
    object cxLabel5: TcxLabel
      Left = 668
      Top = 2
      Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100
    end
    object edPersonalServiceList: TcxButtonEdit
      Left = 668
      Top = 20
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 218
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
    Left = 151
    Top = 335
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
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceJuridical'
      FormName = 'TMoneyPlace_ObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LinkJuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LinkJuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyCode'
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
          Name = 'OKPO'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LinkINN'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = '0'
          Component = MasterCDS
          ComponentItem = 'PartnerId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceInfoMoney: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceInfoMoney'
      FormName = 'TInfoMoney_ObjectForm'
      FormNameParam.Value = 'TInfoMoney_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyCode'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoicePartner: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceContract'
      FormName = 'TPartner_ObjectForm'
      FormNameParam.Value = 'TPartner_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LinkJuridicalId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LinkJuridicalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LinkJuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LinkJuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceContract: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceContract'
      FormName = 'TContractChoiceForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LinkJuridicalId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LinkJuridicalName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InfoMoneyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InfoMoneyName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LinkJuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LinkJuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceUnit: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actUnitForm'
      FormName = 'TUnitForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate
      StoredProcList = <
        item
          StoredProc = spUpdate
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object actUpdate_LinkJuridical: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_LinkJuridical
      StoredProcList = <
        item
          StoredProc = spUpdate_LinkJuridical
        end>
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1091#1102' '#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1074' '#1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091' ('#1085#1072#1081#1076#1077#1085#1086')'
      ImageIndex = 30
    end
    object actSendToBankAccount: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spBankAccount_From_BankStatement
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1086' '#1088'\'#1089
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1086' '#1088'\'#1089
      ImageIndex = 27
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1086' '#1088'\'#1089'?'
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1086' '#1088'\'#1089' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099'.'
    end
    object InsertJuridical: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1102#1088'. '#1083#1080#1094#1086
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1102#1088'. '#1083#1080#1094#1086
      ImageIndex = 0
      FormName = 'TJuridicalEditForm'
      FormNameParam.Value = 'TJuridicalEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OKPO'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OKPO'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Name'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = MasterDS
      IdFieldName = 'Id'
    end
    object actInvoiceJournalDetailChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'acInvoiceJournalDetailChoiceForm'
      FormName = 'TInvoiceJournalDetailChoiceForm'
      FormNameParam.Value = 'TInvoiceJournalDetailChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'InvNumber_Full'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber_Invoice'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_Invoice'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LinkJuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LinkJuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Comment'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Comment_Invoice'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object MovementProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
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
          ComponentItem = 'Id'
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
    object actClear_Invoice: TdsdSetDefaultParams
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#8470' '#1076#1086#1082'.'#1057#1095#1077#1090
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#8470' '#1076#1086#1082'. '#1057#1095#1077#1090
      ImageIndex = 52
      DefaultParams = <
        item
          Param.Value = Null
          Param.Component = MasterCDS
          Param.ComponentItem = 'MovementId_Invoice'
          Param.MultiSelectSeparator = ','
          Value = Null
        end
        item
          Param.Value = Null
          Param.Component = MasterCDS
          Param.ComponentItem = 'InvNumber_Invoice'
          Param.DataType = ftString
          Param.MultiSelectSeparator = ','
          Value = Null
        end
        item
          Param.Value = Null
          Param.Component = MasterCDS
          Param.ComponentItem = 'Comment_Invoice'
          Param.DataType = ftString
          Param.MultiSelectSeparator = ','
          Value = Null
        end>
    end
    object macUpdate_LinkJuridical_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_LinkJuridical
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1091#1102' '#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1074' '#1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091' ('#1085#1072#1081#1076#1077#1085#1086')'
      ImageIndex = 30
    end
    object macUpdate_LinkJuridical: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_LinkJuridical_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1091#1102' '#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1074' '#1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091' ('#1085#1072 +
        #1081#1076#1077#1085#1086')?'
      InfoAfterExecute = #1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1072
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1091#1102' '#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1074' '#1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091' ('#1085#1072#1081#1076#1077#1085#1086')'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1091#1102' '#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1074' '#1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091' ('#1085#1072#1081#1076#1077#1085#1086')'
      ImageIndex = 30
    end
    object actUpdateParams: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateParams
      StoredProcList = <
        item
          StoredProc = spUpdateParams
        end>
      Caption = 'actUpdateParams'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1091#1102' '#1042#1077#1076#1086#1084#1086#1089#1090#1100' '#1074' '#1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091' ('#1085#1072#1081#1076#1077#1085#1086')'
      ImageIndex = 80
    end
    object mactUpdateParams_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateParams
        end>
      View = cxGridDBTableView
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1086#1075#1086#1074#1086#1088' + '#1102#1088'.'#1083
      ImageIndex = 80
    end
    object mactUpdateParams: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = mactUpdateParams_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1054#1073#1085#1086#1074#1080#1090#1100' '#1074' '#1090#1077#1082#1091#1097#1077#1081' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' '#1076#1086#1075#1086#1074#1086#1088' + '#1102#1088'.'#1083#1080#1094#1086'?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1086#1073#1085#1086#1074#1083#1077#1085#1099
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1086#1075#1086#1074#1086#1088' + '#1102#1088'.'#1083#1080#1094#1086
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1074' '#1090#1077#1082#1091#1097#1077#1081' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' '#1076#1086#1075#1086#1074#1086#1088' + '#1102#1088'.'#1083#1080#1094#1086
      ImageIndex = 80
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 104
  end
  inherited MasterCDS: TClientDataSet
    Top = 112
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
        MultiSelectSeparator = ','
      end>
    Top = 176
  end
  inherited BarManager: TdxBarManager
    Left = 136
    Top = 128
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
          ItemName = 'bbUpdate_LinkJuridical'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateParams'
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
          ItemName = 'bbMovementProtocolOpenForm'
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
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    object bbSendToBankAccount: TdxBarButton
      Action = actSendToBankAccount
      Category = 0
    end
    object bbInsertJuridical: TdxBarButton
      Action = InsertJuridical
      Category = 0
    end
    object bbMovementProtocolOpenForm: TdxBarButton
      Action = MovementProtocolOpenForm
      Category = 0
    end
    object bbUpdate_LinkJuridical: TdxBarButton
      Action = macUpdate_LinkJuridical
      Category = 0
    end
    object bbUpdateParams: TdxBarButton
      Action = mactUpdateParams
      Category = 0
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = '3'
        ParamType = ptInput
        MultiSelectSeparator = ','
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'invnumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'operdate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'bankaccountname'
        Value = ''
        Component = edBankAccount
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'bankname'
        Value = ''
        Component = edBankName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceDate'
        Value = Null
        Component = edServiceDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalServiceListId'
        Value = Null
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PersonalServiceListName'
        Value = Null
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 224
    Top = 112
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'injuridicalid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'LinkJuridicalId'
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
        Name = 'ininfomoneyid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InfoMoneyId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'incontractid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inunitid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Unitid'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Invoice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Invoice'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inServiceDate'
        Value = Null
        Component = edServiceDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outServiceDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ServiceDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 328
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
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 184
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
  object GuidesPersonalServiceList: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPersonalServiceList
    isShowModal = True
    FormNameParam.Value = 'TPersonalServiceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPersonalServiceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPersonalServiceList
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 760
    Top = 13
  end
  object spUpdate_LinkJuridical: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_BankStatementItem_LinkJuridical'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = GuidesPersonalServiceList
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inServiceDate'
        Value = Null
        Component = edServiceDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 488
    Top = 136
  end
  object spUpdateParams: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_BankStatementItem_Params'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'LinkJuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = 41640d
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOKPO'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OKPO'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 648
    Top = 144
  end
end
