inherited PersonalServiceOldForm: TPersonalServiceOldForm
  Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1079#1072#1088#1087#1083#1072#1090#1099
  ClientHeight = 381
  ClientWidth = 1142
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1158
  ExplicitHeight = 416
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1142
    Height = 324
    ExplicitTop = 57
    ExplicitWidth = 1142
    ExplicitHeight = 324
    ClientRectBottom = 324
    ClientRectRight = 1142
    inherited tsMain: TcxTabSheet
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 1142
      ExplicitHeight = 324
      inherited cxGrid: TcxGrid
        Width = 1142
        Height = 324
        ExplicitWidth = 1142
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
          OptionsView.GroupByBox = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          OnColumnHeaderClick = nil
          OnCustomDrawColumnHeader = nil
          inherited colStatus: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 55
          end
          inherited colInvNumber: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 89
          end
          inherited colOperDate: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 56
          end
          object clServiceDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'ServiceDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'mmmm yyyy'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object clAmount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1086#1087#1077#1088#1072#1094#1080#1080
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 85
          end
          object colPersonalName: TcxGridDBColumn
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clPosition: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 83
          end
          object clUnit: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 63
          end
          object clPaidKind: TcxGridDBColumn
            Caption = #1042#1080#1076#1099' '#1092#1086#1088#1084' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object clInfoMoney: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1100#1080' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object colComment: TcxGridDBColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1142
    ExplicitWidth = 1142
    inherited deStart: TcxDateEdit
      Left = 94
      ExplicitLeft = 94
    end
    inherited deEnd: TcxDateEdit
      Left = 293
      ExplicitLeft = 293
    end
    inherited cxLabel1: TcxLabel
      Left = 4
      ExplicitLeft = 4
    end
    inherited cxLabel2: TcxLabel
      Left = 183
      ExplicitLeft = 183
    end
    object deServiceDate: TcxDateEdit
      Left = 496
      Top = 5
      EditValue = 41640d
      Properties.DisplayFormat = 'mmmm yyyy'
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 4
      Width = 86
    end
    object cxLabel4: TcxLabel
      Left = 589
      Top = 6
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
    end
    object cePaidKind: TcxButtonEdit
      Left = 667
      Top = 5
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 6
      Width = 57
    end
    object cxLabel5: TcxLabel
      Left = 727
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object ceUnit: TcxButtonEdit
      Left = 812
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 8
      Width = 157
    end
    object inServDate: TcxCheckBox
      Left = 381
      Top = 5
      Caption = #1084#1077#1089#1103#1094' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
      TabOrder = 9
      Width = 116
    end
  end
  object edInDescName: TcxTextEdit [2]
    AlignWithMargins = True
    Left = 975
    Top = 4
    ParentCustomHint = False
    BeepOnEnter = False
    Enabled = False
    ParentFont = False
    Properties.HideSelection = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -11
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
    TabOrder = 6
    Width = 163
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
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
        end
        item
          Name = 'ShowAll'
          Value = True
          DataType = ftBoolean
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'inServiceDate'
          Value = 41640d
          Component = deServiceDate
          DataType = ftDateTime
        end
        item
          Name = 'inPersonalId'
          Value = '0'
        end
        item
          Name = 'inPersonalName'
          Value = Null
          DataType = ftString
        end
        item
          Name = 'inPaidKindId'
          Value = '0'
          Component = PaidKindGuides
          ComponentItem = 'Key'
        end>
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TPersonalServiceEditForm'
      FormNameParam.Value = 'TPersonalServiceEditForm'
      GuiParams = <
        item
          Name = 'Id'
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'inServiceDate'
          Value = 41640d
          Component = deServiceDate
          DataType = ftDateTime
        end
        item
          Name = 'inPersonalId'
          Component = MasterCDS
          ComponentItem = 'PersonalId'
        end
        item
          Name = 'inPersonalName'
          Component = MasterCDS
          ComponentItem = 'PersonalName'
          DataType = ftString
        end
        item
          Name = 'inPaidKindId'
          Value = '0'
          Component = PaidKindGuides
          ComponentItem = 'Key'
        end>
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
        Name = 'inServiceDate'
        Value = 41640d
        Component = deServiceDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inisServiceDate'
        Value = 'False'
        Component = inServDate
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPaidKindId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'PaidKindId'
        ParamType = ptInput
      end
      item
        Name = 'InProcess'
        Value = Null
        Component = FormParams
        ComponentItem = 'InProcess'
        DataType = ftString
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
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 240
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 192
    Top = 112
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = PaidKindGuides
      end
      item
        Component = UnitGuides
      end
      item
        Component = deServiceDate
      end
      item
        Component = inServDate
      end>
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ShowAll'
        Value = False
        DataType = ftBoolean
        ParamType = ptInputOutput
      end
      item
        Name = 'InProcess'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'PaidKindId'
        Value = '0'
        Component = PaidKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'InDescName'
        Value = ''
        Component = edInDescName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Value = Null
        DataType = ftDateTime
        ParamType = ptUnknown
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
        Value = '0'
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
    Top = 184
  end
  object PaidKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePaidKind
    Key = '0'
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
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
    Left = 672
    Top = 65533
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
        Name = 'inServiceDate'
        Value = 41640d
        Component = deServiceDate
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
        Name = 'inPaidKindId'
        Value = '0'
        Component = PaidKindGuides
        ComponentItem = 'Key'
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
        Name = 'Amount'
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
      end
      item
        Name = 'PersonalId'
        Component = MasterCDS
        ComponentItem = 'PersonalId'
      end
      item
        Name = 'PersonalName'
        Component = MasterCDS
        ComponentItem = 'PersonalName'
        DataType = ftString
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
        Name = 'UnitId'
        Component = MasterCDS
        ComponentItem = 'UnitId'
      end
      item
        Name = 'UnitName'
        Component = MasterCDS
        ComponentItem = 'UnitName'
        DataType = ftString
      end
      item
        Name = 'PositionId'
        Component = MasterCDS
        ComponentItem = 'PositionId'
      end
      item
        Name = 'PositionName'
        Component = MasterCDS
        ComponentItem = 'PositionName'
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
      end
      item
        Name = 'Comment'
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
      end>
    Left = 408
    Top = 160
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 840
    Top = 65533
  end
end
