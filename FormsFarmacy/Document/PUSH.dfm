inherited PUSHForm: TPUSHForm
  Caption = 'PUSH '#1089#1086#1086#1073#1097#1077#1085#1080#1077' '#1076#1083#1103' '#1082#1072#1089#1089#1080#1088#1086#1074
  ClientHeight = 500
  ClientWidth = 707
  AddOnFormData.AddOnFormRefresh.ParentList = 'PUSH'
  ExplicitWidth = 723
  ExplicitHeight = 539
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 195
    Width = 707
    Height = 305
    ExplicitTop = 183
    ExplicitWidth = 707
    ExplicitHeight = 317
    ClientRectBottom = 305
    ClientRectRight = 707
    inherited tsMain: TcxTabSheet
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088#1099' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084#1080
      ExplicitWidth = 707
      ExplicitHeight = 293
      inherited cxGrid: TcxGrid
        Width = 707
        Height = 281
        ExplicitWidth = 707
        ExplicitHeight = 293
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsBehavior.IncSearch = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object UserCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'UserCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
          object UserName: TcxGridDBColumn
            AlternateCaption = 'UserName'
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 164
          end
          object Views: TcxGridDBColumn
            Caption = #1055#1088#1086#1089#1084'.'
            DataBinding.FieldName = 'Views'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 171
          end
          object DateViewed: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103' '#1087#1088#1086#1089#1084#1086#1090#1088#1072
            DataBinding.FieldName = 'DateViewed'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.Kind = ckDateTime
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 158
          end
        end
      end
    end
    object tsChild: TcxTabSheet
      Caption = #1044#1083#1103' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1081
      ImageIndex = 1
      ExplicitHeight = 293
      object cxGridChild: TcxGrid
        Left = 0
        Top = 0
        Width = 707
        Height = 281
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 0
        ExplicitHeight = 293
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ChildDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.IncSearch = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object chisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object chParentName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'ParentName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 223
          end
          object chUnitCode: TcxGridDBColumn
            AlternateCaption = 'chUnitCode'
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'UnitCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
          object chUnitName: TcxGridDBColumn
            AlternateCaption = 'UserName'
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 390
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 707
    Height = 169
    TabOrder = 3
    ExplicitWidth = 707
    ExplicitHeight = 169
    inherited edInvNumber: TcxTextEdit
      Left = 8
      Top = 54
      TabOrder = 1
      ExplicitLeft = 8
      ExplicitTop = 54
      ExplicitWidth = 75
      Width = 75
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      Top = 38
      ExplicitLeft = 8
      ExplicitTop = 38
    end
    inherited edOperDate: TcxDateEdit
      Left = 8
      Top = 110
      Properties.Kind = ckDateTime
      TabOrder = 4
      ExplicitLeft = 8
      ExplicitTop = 110
      ExplicitWidth = 152
      Width = 152
    end
    inherited cxLabel2: TcxLabel
      Left = 8
      Top = 93
      Caption = #1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103' '#1085#1072#1095#1072#1083#1072
      ExplicitLeft = 8
      ExplicitTop = 93
      ExplicitWidth = 111
    end
    inherited cxLabel15: TcxLabel
      Top = 2
      ExplicitTop = 2
    end
    inherited ceStatus: TcxButtonEdit
      Top = 17
      TabOrder = 0
      ExplicitTop = 17
      ExplicitHeight = 22
    end
    object cxLabel3: TcxLabel
      Left = 166
      Top = 2
      Caption = #1058#1077#1082#1089#1090' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
    end
    object edMessage: TcxMemo
      Left = 166
      Top = 17
      Lines.Strings = (
        'edMessage')
      TabOrder = 6
      Height = 150
      Width = 532
    end
    object edDateEndPUSH: TcxDateEdit
      Left = 10
      Top = 146
      EditValue = 42132d
      Properties.Kind = ckDateTime
      TabOrder = 5
      Width = 150
    end
    object cxLabel4: TcxLabel
      Left = 9
      Top = 129
      Caption = #1050#1086#1085#1094#1072' '#1086#1087#1086#1074#1077#1097#1077#1085#1080#1103
    end
    object cxLabel5: TcxLabel
      Left = 89
      Top = 38
      Caption = #1055#1086#1074#1090#1086#1088#1086#1074
    end
    object edReplays: TcxCurrencyEdit
      Left = 89
      Top = 54
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.ReadOnly = False
      TabOrder = 2
      Width = 71
    end
    object chbDaily: TcxCheckBox
      Left = 8
      Top = 75
      Caption = #1055#1086#1074#1090'. '#1077#1078#1077#1076#1085#1077#1074#1085#1086
      TabOrder = 3
      Width = 125
    end
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectChild
        end>
    end
    inherited actMISetErased: TdsdUpdateErased
      TabSheet = tsChild
      Enabled = False
      DataSource = ChildDS
    end
    inherited actMISetUnErased: TdsdUpdateErased
      TabSheet = tsChild
      Enabled = False
      DataSource = ChildDS
    end
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end
        item
        end>
    end
    inherited actShowErased: TBooleanStoredProcAction
      TabSheet = tsChild
      Enabled = False
      StoredProc = spSelectChild
      StoredProcList = <
        item
          StoredProc = spSelectChild
        end>
    end
    inherited actShowAll: TBooleanStoredProcAction
      TabSheet = tsChild
      Enabled = False
      StoredProc = spSelectChild
      StoredProcList = <
        item
          StoredProc = spSelectChild
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
      ReportName = #1050#1086#1084#1084#1077#1088#1095#1077#1089#1082#1086#1077' '#1087#1088#1077#1076#1083#1086#1078#1077#1085#1080#1077
      ReportNameParam.Value = #1050#1086#1084#1084#1077#1088#1095#1077#1089#1082#1086#1077' '#1087#1088#1077#1076#1083#1086#1078#1077#1085#1080#1077
    end
    object actUpdateMessage: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = 'actUpdateMessage'
    end
  end
  inherited MasterDS: TDataSource
    Top = 224
  end
  inherited MasterCDS: TClientDataSet
    Top = 224
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PUSH'
    Left = 64
    Top = 224
  end
  inherited BarManager: TdxBarManager
    Left = 96
    Top = 223
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
          BeginGroup = True
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
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end
        item
          Visible = True
          ItemName = 'dxBarButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton5'
        end
        item
          Visible = True
          ItemName = 'dxBarButton6'
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
          ItemName = 'dxBarStatic'
        end>
    end
    inherited bbPrint: TdxBarButton
      Action = nil
    end
    object bbPrintCheck: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      Visible = ivAlways
      ImageIndex = 15
    end
    object bbGet_SP_Prior: TdxBarButton
      Caption = #1040#1042#1058#1054#1047#1040#1055#1054#1051#1053#1048#1058#1068
      Category = 0
      Visible = ivAlways
      ImageIndex = 74
    end
    object dxBarButton1: TdxBarButton
      Caption = 'actPrintXLSScope'
      Category = 0
      Visible = ivAlways
      ImageIndex = 3
    end
    object dxBarButton2: TdxBarButton
      Caption = #1042#1089#1090#1072#1074#1082#1072' '#1074' '#1079#1072#1082#1072#1079
      Category = 0
      Hint = #1042#1089#1090#1072#1074#1082#1072' '#1074' '#1079#1072#1082#1072#1079
      Visible = ivAlways
      ImageIndex = 0
    end
    object dxBarButton3: TdxBarButton
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1087#1088#1086#1076#1072#1078#1091
      Category = 0
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1087#1088#1086#1076#1072#1078#1091
      Visible = ivAlways
      ImageIndex = 43
    end
    object dxBarButton4: TdxBarButton
      Action = actShowErased
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = actMISetErased
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Action = actMISetUnErased
      Category = 0
    end
    object dxBarButton7: TdxBarButton
      Action = actShowAll
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
        DataSummaryItemIndex = 0
      end>
    SearchAsFilter = False
    Left = 350
    Top = 241
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
        Name = 'TotalSumm'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 328
  end
  inherited StatusGuides: TdsdGuides
    Top = 232
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_PUSH'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Top = 232
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_PUSH'
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
        Value = 'NULL'
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
        Name = 'OperDate'
        Value = 42132d
        Component = edOperDate
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
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateEndPUSH'
        Value = 'NULL'
        Component = edDateEndPUSH
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Replays'
        Value = Null
        Component = edReplays
        MultiSelectSeparator = ','
      end
      item
        Name = 'Daily'
        Value = Null
        Component = chbDaily
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'Message'
        Value = Null
        Component = edMessage
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 272
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PUSH'
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
      end
      item
        Name = 'inDateEndPUSH'
        Value = 'NULL'
        Component = edDateEndPUSH
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReplays'
        Value = Null
        Component = edReplays
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDaily'
        Value = Null
        Component = chbDaily
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMessage'
        Value = Null
        Component = edMessage
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 298
    Top = 240
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
      end
      item
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end
      item
        Action = actRefresh
      end>
    Left = 248
    Top = 240
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edOperDate
      end
      item
        Control = edInvNumber
      end
      item
        Control = edDateEndPUSH
      end
      item
        Control = edMessage
      end
      item
        Control = edReplays
      end
      item
        Control = chbDaily
      end>
    Left = 208
    Top = 233
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 32
    Top = 384
  end
  inherited spErasedMIMaster: TdsdStoredProc
    Params = <
      item
        Name = 'inMovementItemId'
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Component = ChildCDS
        ComponentItem = 'IsErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 590
    Top = 248
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpSetUnErased_MovementItemChild_PUSH'
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
        Name = 'ioMovementItemId'
        Component = ChildCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Component = ChildCDS
        ComponentItem = 'IsErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 590
    Top = 304
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
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
        Name = 'inGoodsNameUkr'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsNameUkr'
        DataType = ftString
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
        Name = 'inAmountOrder'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountOrder'
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
        Name = 'outSummOrder'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummOrder'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCodeUKTZED'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CodeUKTZED'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inExchangeId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ExchangeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 456
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 456
    Top = 312
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_PUSH_TotalSumm'
    DataSets = <
      item
      end>
    OutputType = otDataSet
    Left = 244
    Top = 300
  end
  object spSelectChild: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItemChild_PUSH'
    DataSet = ChildCDS
    DataSets = <
      item
        DataSet = ChildCDS
      end>
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
        Name = 'inShowAll'
        Value = False
        Component = FormParams
        ComponentItem = 'ShowAll'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 144
    Top = 384
  end
  object ChildDS: TDataSource
    DataSet = ChildCDS
    Left = 296
    Top = 384
  end
  object ChildCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 240
    Top = 384
  end
  object DBViewAddOnChild: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 0
      end>
    SearchAsFilter = False
    Left = 382
    Top = 385
  end
end
