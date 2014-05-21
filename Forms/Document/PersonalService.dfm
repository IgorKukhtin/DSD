inherited PersonalServiceForm: TPersonalServiceForm
  Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1079#1072#1088#1087#1083#1072#1090#1099
  ClientHeight = 381
  ClientWidth = 982
  ExplicitWidth = 990
  ExplicitHeight = 408
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 982
    Height = 324
    ExplicitWidth = 982
    ExplicitHeight = 324
    ClientRectBottom = 324
    ClientRectRight = 982
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 982
      ExplicitHeight = 324
      inherited cxGrid: TcxGrid
        Width = 982
        Height = 324
        ExplicitWidth = 982
        ExplicitHeight = 324
        inherited cxGridDBTableView: TcxGridDBTableView
          OnDblClick = nil
          OnKeyDown = nil
          OnKeyPress = nil
          OnCustomDrawCell = nil
          DataController.Filter.OnChanged = nil
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = clAmount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = clAmount
            end>
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          OnColumnHeaderClick = nil
          OnCustomDrawColumnHeader = nil
          inherited colStatus: TcxGridDBColumn
            Options.Editing = False
            Width = 55
          end
          inherited colInvNumber: TcxGridDBColumn
            Width = 89
          end
          inherited colOperDate: TcxGridDBColumn
            Options.Editing = False
            Width = 56
          end
          object clServiceDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'ServiceDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'mmmm yyyy'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object clAmount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1086#1087#1077#1088#1072#1094#1080#1080
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object colPersonalName: TcxGridDBColumn
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clPosition: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object clUnit: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object clPaidKind: TcxGridDBColumn
            Caption = #1042#1080#1076#1099' '#1092#1086#1088#1084' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object clInfoMoney: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1100#1080' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object colComment: TcxGridDBColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 982
    ExplicitWidth = 982
    object cxLabel3: TcxLabel
      Left = 404
      Top = 6
      Caption = #1044#1072#1090#1072' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103':'
    end
    object deServiceDate: TcxDateEdit
      Left = 499
      Top = 5
      EditValue = 41640d
      Properties.DisplayFormat = 'mmmm yyyy'
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 5
      Width = 86
    end
    object cxLabel4: TcxLabel
      Left = 589
      Top = 6
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
    end
    object cePaidKind: TcxButtonEdit
      Left = 664
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 139
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deServiceDate
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = PaidKindGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TPersonalServiceEditForm'
      FormNameParam.Value = 'TPersonalServiceEditForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TPersonalServiceEditForm'
      FormNameParam.Value = 'TPersonalServiceEditForm'
    end
    object UpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end
        item
          StoredProc = spGet
        end>
      DataSource = MasterDS
    end
  end
  inherited MasterCDS: TClientDataSet
    AfterInsert = nil
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PersonalService'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInputOutput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inPaidKindId'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
      end>
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited PeriodChoice: TPeriodChoice
    Top = 96
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = PaidKindGuides
      end>
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PersonalService'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioMovementId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inInvNumber'
        Component = MasterCDS
        ComponentItem = 'InvNumber'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inPersonalId'
        Component = MasterCDS
        ComponentItem = 'PersonalId'
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyId'
        Component = MasterCDS
        ComponentItem = 'InfoMoneyId'
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
      end
      item
        Name = 'inPositionId'
        Component = MasterCDS
        ComponentItem = 'PositionId'
        ParamType = ptInput
      end
      item
        Name = 'inPaidKindId'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inServiceDate'
        Value = 41640d
        Component = deServiceDate
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 336
    Top = 160
  end
  object PaidKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 680
    Top = 13
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_PersonalService'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'InvNumber'
        Component = MasterCDS
        ComponentItem = 'InvNumber'
        DataType = ftString
      end
      item
        Name = 'OperDate'
        Component = MasterCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
      end
      item
        Name = 'ServiceDate'
        Component = MasterCDS
        ComponentItem = 'ServiceDate'
        DataType = ftDateTime
      end
      item
        Name = 'PaidKindId'
        Component = MasterCDS
        ComponentItem = 'PaidKindId'
      end
      item
        Name = 'PaidKindName'
        Component = MasterCDS
        ComponentItem = 'PaidKindName'
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
      end
      item
        Name = 'StatusCode'
        Component = MasterCDS
        ComponentItem = 'StatusCode'
      end
      item
        Name = 'StatusName'
        Component = MasterCDS
        ComponentItem = 'StatusName'
        DataType = ftString
      end>
    Left = 384
    Top = 160
  end
end
