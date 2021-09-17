inherited WagesVIPForm: TWagesVIPForm
  Caption = #1055#1083#1072#1085' '#1087#1086' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1091' '#1076#1083#1103' '#1090#1086#1095#1077#1082
  ClientHeight = 479
  ClientWidth = 799
  AddOnFormData.AddOnFormRefresh.ParentList = 'Sale'
  ExplicitWidth = 815
  ExplicitHeight = 518
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 123
    Width = 799
    Height = 356
    ExplicitTop = 123
    ExplicitWidth = 799
    ExplicitHeight = 356
    ClientRectBottom = 356
    ClientRectRight = 799
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 799
      ExplicitHeight = 332
      inherited cxGrid: TcxGrid
        Width = 799
        Height = 324
        ExplicitWidth = 799
        ExplicitHeight = 324
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
        Top = 324
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
    Height = 97
    TabOrder = 3
    ExplicitWidth = 799
    ExplicitHeight = 97
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 108
      EditValue = 42767d
      Properties.DisplayFormat = 'mmmm yyyy'
      ExplicitLeft = 108
    end
    inherited cxLabel2: TcxLabel
      Left = 108
      ExplicitLeft = 108
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 62
      ExplicitTop = 62
      ExplicitWidth = 200
      ExplicitHeight = 22
      Width = 200
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
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
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
        Name = 'inAmountPlanMax'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPlanMax'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summ'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSummPlanMax'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummPlanMax'
        DataType = ftFloat
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
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 320
    Top = 288
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 432
    Top = 272
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
end
