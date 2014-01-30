inherited TransportServiceJournalForm: TTransportServiceJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1085#1072#1077#1084#1085#1099#1081' '#1090#1088#1072#1085#1089#1087#1086#1088#1090'>'
  ClientHeight = 336
  ClientWidth = 1212
  ExplicitWidth = 1220
  ExplicitHeight = 370
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1212
    Height = 279
    TabOrder = 3
    ExplicitWidth = 1212
    ExplicitHeight = 279
    ClientRectBottom = 279
    ClientRectRight = 1212
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1212
      ExplicitHeight = 279
      inherited cxGrid: TcxGrid
        Width = 1212
        Height = 279
        ExplicitWidth = 1212
        ExplicitHeight = 279
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Position = spFooter
              Column = clAmount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = clAmount
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            Options.Editing = False
            Width = 53
          end
          inherited colInvNumber: TcxGridDBColumn
            Visible = False
            Options.Editing = False
            Width = 53
          end
          inherited colOperDate: TcxGridDBColumn
            Options.Editing = False
            Width = 52
          end
          object clAmount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object clDistance: TcxGridDBColumn
            Caption = #1055#1088#1086#1073#1077#1075' '#1092#1072#1082#1090', '#1082#1084
            DataBinding.FieldName = 'Distance'
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' ('#1090#1086#1087#1083#1080#1074#1072')'
            DataBinding.FieldName = 'Price'
            HeaderAlignmentVert = vaCenter
            Width = 65
          end
          object clCountPoint: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1090#1086#1095#1077#1082
            DataBinding.FieldName = 'CountPoint'
            HeaderAlignmentVert = vaCenter
            Width = 59
          end
          object clTrevelTime: TcxGridDBColumn
            Caption = #1042#1088#1077#1084#1103' '#1074' '#1087#1091#1090#1080', '#1095
            DataBinding.FieldName = 'TrevelTime'
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clJuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = ContractChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentVert = vaCenter
            Width = 92
          end
          object clContractName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = ContractChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clContractConditionKindName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1076#1086#1075#1086#1074#1086#1088#1072
            DataBinding.FieldName = 'ContractConditionKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = ContractConditionKindChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object clInfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 53
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
          object clInfoMoney: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = InfoMoneyChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object clPaidKind: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = PaidKindChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 54
          end
          object clRouteName: TcxGridDBColumn
            Caption = #1052#1072#1088#1096#1088#1091#1090
            DataBinding.FieldName = 'RouteName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = RouteChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 79
          end
          object clCarModelName: TcxGridDBColumn
            Caption = #1052#1072#1088#1082#1072' '#1072#1074#1090#1086
            DataBinding.FieldName = 'CarModelName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object clCarName: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
            DataBinding.FieldName = 'CarName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = CarChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 82
          end
          object clUnitForwardingName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1052#1077#1089#1090#1086' '#1086#1090#1087#1088#1072#1074#1082#1080')'
            DataBinding.FieldName = 'UnitForwardingName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object clComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 102
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1212
    ExplicitWidth = 1212
    inherited deStart: TcxDateEdit
      Properties.SaveTime = False
      Properties.ShowTime = False
    end
    inherited deEnd: TcxDateEdit
      Properties.SaveTime = False
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 99
    Top = 187
  end
  inherited ActionList: TActionList
    Left = 47
    Top = 274
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TTransportServiceForm'
    end
    object CarChoiceForm: TOpenChoiceForm [3]
      Category = 'DSDLib'
      FormName = 'TCarForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'CarId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'CarName'
          DataType = ftString
        end
        item
          Name = 'CarModelName'
          Component = MasterCDS
          ComponentItem = 'CarModelName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object ContractConditionKindChoiceForm: TOpenChoiceForm [4]
      Category = 'DSDLib'
      FormName = 'TContractConditionKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'ContractConditionKindId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'ContractConditionKindName'
          DataType = ftString
        end
        item
          Name = 'inContractId'
          Component = MasterCDS
          ComponentItem = 'ContractId'
          ParamType = ptInput
        end>
      isShowModal = True
    end
    object RouteChoiceForm: TOpenChoiceForm [5]
      Category = 'DSDLib'
      FormName = 'TRouteForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'RouteId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'RouteName'
          DataType = ftString
        end>
      isShowModal = True
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TTransportServiceForm'
    end
    object ContractChoiceForm: TOpenChoiceForm [8]
      Category = 'DSDLib'
      FormName = 'TContractChoiceForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
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
        end
        item
          Name = 'JuridicalId'
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
        end
        item
          Name = 'JuridicalName'
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
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
      isShowModal = True
    end
    object PaidKindChoiceForm: TOpenChoiceForm [9]
      Category = 'DSDLib'
      FormName = 'TPaidKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object InfoMoneyChoiceForm: TOpenChoiceForm [10]
      Category = 'DSDLib'
      FormName = 'TInfoMoneyForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
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
      isShowModal = True
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end
        item
          StoredProc = spSelect
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Left = 80
    Top = 120
  end
  inherited MasterCDS: TClientDataSet
    Left = 24
    Top = 104
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TransportService'
    Params = <
      item
        Name = 'instartdate'
        Value = 41579d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inenddate'
        Value = 41608d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 120
    Top = 120
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 112
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 472
    Top = 248
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 232
    Top = 104
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = MasterCDS
      end>
    Left = 328
    Top = 104
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_TransportService'
    Left = 640
    Top = 136
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_TransportService'
    Left = 640
    Top = 184
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_TransportService'
    Left = 640
    Top = 232
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TransportService'
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
        Name = 'iomiid'
        Component = MasterCDS
        ComponentItem = 'MIId'
        ParamType = ptInputOutput
      end
      item
        Name = 'ininvnumber'
        Component = MasterCDS
        ComponentItem = 'InvNumber'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inoperdate'
        Component = MasterCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'ioAmount'
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInputOutput
      end
      item
        Name = 'indistance'
        Component = MasterCDS
        ComponentItem = 'Distance'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inprice'
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'incountpoint'
        Component = MasterCDS
        ComponentItem = 'CountPoint'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'intreveltime'
        Component = MasterCDS
        ComponentItem = 'treveltime'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'incomment'
        Component = MasterCDS
        ComponentItem = 'comment'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'injuridicalid'
        Component = MasterCDS
        ComponentItem = 'juridicalid'
        ParamType = ptInput
      end
      item
        Name = 'incontractid'
        Component = MasterCDS
        ComponentItem = 'contractid'
        ParamType = ptInput
      end
      item
        Name = 'ininfomoneyid'
        Component = MasterCDS
        ComponentItem = 'infomoneyid'
        ParamType = ptInput
      end
      item
        Name = 'inpaidkindid'
        Component = MasterCDS
        ComponentItem = 'paidkindid'
        ParamType = ptInput
      end
      item
        Name = 'inrouteid'
        Component = MasterCDS
        ComponentItem = 'routeid'
        ParamType = ptInput
      end
      item
        Name = 'incarid'
        Component = MasterCDS
        ComponentItem = 'carid'
        ParamType = ptInput
      end
      item
        Name = 'inContractConditionKindId'
        Component = MasterCDS
        ComponentItem = 'ContractConditionKindId'
        ParamType = ptInput
      end
      item
        Name = 'inUnitForwardingId'
        Component = MasterCDS
        ComponentItem = 'UnitForwardingId'
        ParamType = ptInput
      end>
    Left = 504
    Top = 164
  end
end
