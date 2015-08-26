inherited CheckJournalForm: TCheckJournalForm
  Caption = #1050#1072#1089#1089#1086#1074#1099#1077' '#1095#1077#1082#1080
  ClientWidth = 697
  AddOnFormData.RefreshAction = actRefreshStart
  ExplicitWidth = 705
  ExplicitHeight = 702
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 77
    Width = 697
    Height = 598
    TabOrder = 3
    ExplicitTop = 77
    ExplicitWidth = 697
    ExplicitHeight = 598
    ClientRectBottom = 598
    ClientRectRight = 697
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 697
      ExplicitHeight = 598
      inherited cxGrid: TcxGrid
        Width = 697
        Height = 598
        ExplicitWidth = 697
        ExplicitHeight = 598
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSumm
            end>
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            Options.Editing = False
          end
          inherited colInvNumber: TcxGridDBColumn
            Options.Editing = False
            Width = 99
          end
          inherited colOperDate: TcxGridDBColumn
            Options.Editing = False
          end
          object colUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            Options.Editing = False
            Width = 111
          end
          object colCashNumber: TcxGridDBColumn
            Caption = #1050#1072#1089#1089#1072
            DataBinding.FieldName = 'CashRegisterName'
            Options.Editing = False
            Width = 74
          end
          object colTotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'TotalCount'
            Options.Editing = False
            Width = 72
          end
          object colTotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            Options.Editing = False
            Width = 79
          end
          object coPaidTypeName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidTypeName'
            Width = 70
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 697
    Height = 51
    ExplicitWidth = 697
    ExplicitHeight = 51
    object ceUnit: TcxButtonEdit
      Left = 107
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 4
      Width = 288
    end
    object cxLabel3: TcxLabel
      Left = 10
      Top = 29
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
  end
  inherited ActionList: TActionList
    inherited actInsert: TdsdInsertUpdateAction
      Enabled = False
      FormName = 'TCheckForm'
      FormNameParam.Value = 'TCheckForm'
    end
    inherited actInsertMask: TdsdInsertUpdateAction
      Enabled = False
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TCheckForm'
      FormNameParam.Value = 'TCheckForm'
    end
    inherited actUnComplete: TdsdChangeMovementStatus
      Enabled = False
    end
    inherited actComplete: TdsdChangeMovementStatus
      Enabled = False
    end
    inherited actSetErased: TdsdChangeMovementStatus
      Enabled = False
    end
    inherited actReCompleteList: TMultiAction
      Enabled = False
    end
    inherited actCompleteList: TMultiAction
      Enabled = False
    end
    inherited actUnCompleteList: TMultiAction
      Enabled = False
    end
    inherited actSetErasedList: TMultiAction
      Enabled = False
    end
    inherited spCompete: TdsdExecStoredProc
      Enabled = False
    end
    inherited spUncomplete: TdsdExecStoredProc
      Enabled = False
    end
    inherited spErased: TdsdExecStoredProc
      Enabled = False
    end
    inherited actSimpleCompleteList: TMultiAction
      Enabled = False
    end
    inherited actSimpleUncompleteList: TMultiAction
      Enabled = False
    end
    inherited actSimpleReCompleteList: TMultiAction
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1087#1088#1086#1094#1077#1076#1091#1088#1091' '#1087#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103' '#1086#1090#1086#1073#1088#1072#1085#1085#1099#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'?'
    end
    inherited actSimpleErased: TMultiAction
      Enabled = False
    end
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Check'
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
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
      end>
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
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
          ItemName = 'bbMovementItemContainer'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementProtocol'
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
    inherited bbInsert: TdxBarButton
      Visible = ivNever
    end
    inherited bbInsertMask: TdxBarButton
      Visible = ivNever
    end
    inherited bbComplete: TdxBarButton
      Visible = ivNever
    end
    inherited bbUnComplete: TdxBarButton
      Visible = ivNever
    end
    inherited bbDelete: TdxBarButton
      Visible = ivNever
    end
  end
  inherited PopupMenu: TPopupMenu
    object N13: TMenuItem [11]
      Action = actSimpleReCompleteList
    end
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    RefreshAction = actRefreshStart
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
  end
  inherited spMovementComplete: TdsdStoredProc
    Left = 88
    Top = 296
  end
  inherited spMovementUnComplete: TdsdStoredProc
    Left = 88
    Top = 344
  end
  inherited spMovementSetErased: TdsdStoredProc
    Left = 88
    Top = 448
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
        Name = 'UnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
      end>
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_Check'
    Left = 88
    Top = 392
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnitTreeForm'
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
    Left = 336
    Top = 24
  end
  object rdUnit: TRefreshDispatcher
    IdParam.Value = Null
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = UnitGuides
      end>
    Left = 296
    Top = 24
  end
  object spGet_UserUnit: TdsdStoredProc
    StoredProcName = 'gpGet_UserUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'UnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    PackSize = 1
    Left = 432
    Top = 424
  end
  object dsdStoredProc1: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_Income'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inIsLastComplete'
        Value = 'True'
        DataType = ftBoolean
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 761
    Top = 178
  end
end
