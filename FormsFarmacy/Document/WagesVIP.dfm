inherited WagesVIPForm: TWagesVIPForm
  Caption = #1047'/'#1055' VIP '#1084#1077#1085#1077#1076#1078#1077#1088#1086#1074
  ClientHeight = 479
  ClientWidth = 799
  AddOnFormData.AddOnFormRefresh.ParentList = 'Sale'
  ExplicitWidth = 815
  ExplicitHeight = 518
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 109
    Width = 799
    Height = 370
    ExplicitTop = 109
    ExplicitWidth = 799
    ExplicitHeight = 370
    ClientRectBottom = 370
    ClientRectRight = 799
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 799
      ExplicitHeight = 346
      inherited cxGrid: TcxGrid
        Width = 799
        Height = 338
        ExplicitWidth = 799
        ExplicitHeight = 338
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Column = AmountAccrued
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountAccrued
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = MemberName
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          OptionsBehavior.IncSearch = True
          OptionsView.ColumnAutoWidth = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object MemberCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'MemberCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object MemberName: TcxGridDBColumn
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
            DataBinding.FieldName = 'MemberName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 293
          end
          object HoursWork: TcxGridDBColumn
            Caption = #1054#1090#1088#1072#1073#1086#1090#1072#1085#1086' '#1095#1072#1089#1086#1074
            DataBinding.FieldName = 'HoursWork'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object AmountAccrued: TcxGridDBColumn
            Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1086
            DataBinding.FieldName = 'AmountAccrued'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.000'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object isIssuedBy: TcxGridDBColumn
            Caption = #1042#1099#1076#1072#1085#1086
            DataBinding.FieldName = 'isIssuedBy'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 84
          end
          object DateIssuedBy: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1074#1099#1076#1072#1095#1080
            DataBinding.FieldName = 'DateIssuedBy'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 338
        Width = 799
        Height = 8
        Touch.ParentTabletOptions = False
        Touch.TabletOptions = [toPressAndHold]
        AlignSplitter = salBottom
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 799
    Height = 83
    TabOrder = 3
    ExplicitWidth = 799
    ExplicitHeight = 83
    inherited edInvNumber: TcxTextEdit
      Left = 8
      Top = 20
      ExplicitLeft = 8
      ExplicitTop = 20
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      Top = 2
      ExplicitLeft = 8
      ExplicitTop = 2
    end
    inherited edOperDate: TcxDateEdit
      Left = 108
      Top = 20
      EditValue = 42767d
      Properties.DisplayFormat = 'mmmm yyyy'
      ExplicitLeft = 108
      ExplicitTop = 20
    end
    inherited cxLabel2: TcxLabel
      Left = 108
      Top = 2
      ExplicitLeft = 108
      ExplicitTop = 2
    end
    inherited cxLabel15: TcxLabel
      Top = 40
      ExplicitTop = 40
    end
    inherited ceStatus: TcxButtonEdit
      Top = 57
      ExplicitTop = 57
      ExplicitWidth = 200
      ExplicitHeight = 22
      Width = 200
    end
    object cxLabel3: TcxLabel
      Left = 238
      Top = 8
      Caption = #1057#1091#1084#1084#1072' '#1087#1088#1080#1085#1103#1090#1099#1093' '#1087#1086' '#1090#1077#1083#1077#1092#1086#1085#1091' '#1079#1072#1082#1072#1079#1086#1074
    end
    object ceTotalSummPhone: TcxCurrencyEdit
      Left = 447
      Top = 7
      TabStop = False
      Properties.DisplayFormat = ',0.00;-,0.00; ;'
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 89
    end
    object ceTotalSummSale: TcxCurrencyEdit
      Left = 447
      Top = 32
      TabStop = False
      Properties.DisplayFormat = ',0.00;-,0.00; ;'
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 89
    end
    object cxLabel4: TcxLabel
      Left = 238
      Top = 33
      Caption = #1057#1091#1084#1084#1072' '#1086#1089#1090#1072#1083#1100#1085#1099#1093' '#1079#1072#1082#1072#1079#1086#1074
    end
    object ceHoursWork: TcxCurrencyEdit
      Left = 447
      Top = 57
      TabStop = False
      Properties.DisplayFormat = ',0.00;-,0.00; ;'
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 89
    end
    object cxLabel5: TcxLabel
      Left = 238
      Top = 58
      Caption = #9#1054#1090#1088#1072#1073#1086#1090#1072#1085#1086' '#1095#1072#1089#1086#1074' '#1074#1089#1077#1084#1080' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084#1080
    end
    object deDateCalculation: TcxDateEdit
      Left = 572
      Top = 20
      EditValue = 42767d
      Properties.AssignedValues.DisplayFormat = True
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 157
    end
    object cxLabel6: TcxLabel
      Left = 572
      Top = 2
      Caption = #1044#1072#1090#1072' '#1088#1072#1089#1095#1077#1090#1072
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 67
    Top = 272
  end
  inherited ActionList: TActionList
    Left = 215
    Top = 319
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end
        item
        end
        item
        end>
    end
    inherited actMISetErased: TdsdUpdateErased
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end
        item
        end>
    end
    inherited actMISetUnErased: TdsdUpdateErased
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end
        item
        end>
    end
    inherited actShowAll: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end>
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
        end>
    end
    inherited actPrint: TdsdPrintAction
      StoredProcList = <
        item
        end>
      DataSets = <
        item
          UserName = 'frxDBDHeader'
        end
        item
          UserName = 'frxDBDMaster'
        end>
      ReportName = #1055#1088#1086#1076#1072#1078#1072
      ReportNameParam.Value = #1055#1088#1086#1076#1072#1078#1072
    end
    object actCalculationAll: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecCalculationAll
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1088#1072#1089#1095#1077#1090' '#1079#1072#1088#1072#1073#1086#1090#1085#1086#1081' '#1087#1083#1072#1090#1099' '#1087#1086' '#1074#1089#1077#1084' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1056#1072#1089#1095#1080#1090#1072#1090#1100' '#1079#1072#1088#1072#1073#1086#1090#1085#1091#1102' '#1087#1083#1072#1090#1091' '#1087#1086' '#1074#1089#1077#1084' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
      Hint = #1056#1072#1089#1095#1080#1090#1072#1090#1100' '#1079#1072#1088#1072#1073#1086#1090#1085#1091#1102' '#1087#1083#1072#1090#1091' '#1087#1086' '#1074#1089#1077#1084' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
      ImageIndex = 38
    end
    object actExecCalculationAll: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spCalculationAll
      StoredProcList = <
        item
          StoredProc = spCalculationAll
        end>
      Caption = 'actExecCalculationAll'
      Hint = #1056#1072#1089#1095#1077#1090' '#1079'.'#1087'. '#1087#1086' '#1074#1089#1077#1084' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_WagesVIP'
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
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbErased'
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
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
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
    inherited bbMovementItemProtocol: TdxBarButton
      UnclickAfterDoing = False
    end
    object bbactStartLoad: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Visible = ivAlways
      ImageIndex = 41
    end
    object dxBarButton1: TdxBarButton
      Action = actCalculationAll
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 11
      end>
    SearchAsFilter = False
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalCount'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 312
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_WagesVIP'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 176
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_WagesVIP'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummPhone'
        Value = Null
        Component = ceTotalSummPhone
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummSale'
        Value = Null
        Component = ceTotalSummSale
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'HoursWork'
        Value = Null
        Component = ceHoursWork
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateCalculation'
        Value = Null
        Component = deDateCalculation
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 224
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_WagesVIP'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 202
    Top = 248
  end
  inherited GuidesFiller: TGuidesFiller
    ActionItemList = <
      item
      end
      item
        Action = actInsertUpdateMovement
      end>
    Left = 288
    Top = 216
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edOperDate
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 232
    Top = 177
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 120
    Top = 312
  end
  inherited spErasedMIMaster: TdsdStoredProc
    Left = 438
    Top = 184
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    Left = 654
    Top = 248
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_WagesVIP'
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
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserID'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UserID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisIssuedBy'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isIssuedBy'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 320
    Top = 288
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 464
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_WagesVIP_TotalSumm'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalCount'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalCount'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSumm'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummPrimeCost'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSummPrimeCost'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 652
    Top = 196
  end
  object spCalculationAll: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_WagesVIP_CalculationAll'
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
    NeedResetData = True
    Left = 552
    Top = 192
  end
end