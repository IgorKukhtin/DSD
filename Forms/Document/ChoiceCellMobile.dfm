inherited ChoiceCellMobileForm: TChoiceCellMobileForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1057#1082#1072#1085#1080#1088#1086#1074#1072#1085#1080#1077' '#1084#1077#1089#1090#1072' '#1086#1090#1073#1086#1088#1072'>'
  ClientHeight = 403
  ClientWidth = 961
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 977
  ExplicitHeight = 442
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 99
    Width = 961
    Height = 304
    TabOrder = 3
    ExplicitTop = 85
    ExplicitWidth = 961
    ExplicitHeight = 318
    ClientRectBottom = 304
    ClientRectRight = 961
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 961
      ExplicitHeight = 318
      inherited cxGrid: TcxGrid
        Width = 961
        Height = 304
        ExplicitWidth = 961
        ExplicitHeight = 318
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
          DataController.Filter.TranslateBetween = True
          DataController.Filter.TranslateIn = True
          DataController.Filter.TranslateLike = True
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end>
          OptionsBehavior.GoToNextCellOnEnter = False
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          OptionsView.HeaderHeight = 50
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Width = 70
          end
          inherited colInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          inherited colOperDate: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Width = 80
          end
          object ChoiceCellCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080
            DataBinding.FieldName = 'ChoiceCellCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1071#1095#1077#1081#1082#1080' '#1086#1090#1073#1086#1088#1072
            Options.Editing = False
            Width = 114
          end
          object ChoiceCellName: TcxGridDBColumn
            Caption = #1071#1095#1077#1081#1082#1072' '#1086#1090#1073#1086#1088#1072
            DataBinding.FieldName = 'ChoiceCellName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 117
          end
          object ChoiceCellName_search: TcxGridDBColumn
            Caption = '***'#1071#1095#1077#1081#1082#1072' '#1086#1090#1073#1086#1088#1072
            DataBinding.FieldName = 'ChoiceCellName_search'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 200
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object PartionGoodsDate: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' ('#1086#1090#1073#1086#1088')'
            DataBinding.FieldName = 'PartionGoodsDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080' ('#1103#1095#1077#1081#1082#1072' '#1086#1090#1073#1086#1088#1072')'
            Width = 100
          end
          object PartionGoodsDate_next: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' ('#1093#1088#1072#1085#1077#1085#1080#1077')'
            DataBinding.FieldName = 'PartionGoodsDate_next'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080' ('#1103#1095#1077#1081#1082#1072' '#1093#1088#1072#1085#1077#1085#1080#1103')'
            Width = 100
          end
          object InsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object UpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 92
          end
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object isErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object ErasedCode: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1082#1086#1076')'
            DataBinding.FieldName = 'ErasedCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 961
    Height = 73
    ExplicitWidth = 961
    ExplicitHeight = 73
    inherited deStart: TcxDateEdit
      Left = 926
      EditValue = 45292d
      Visible = False
      ExplicitLeft = 926
      ExplicitWidth = 82
      Width = 82
    end
    inherited deEnd: TcxDateEdit
      Left = 926
      Top = 29
      EditValue = 45292d
      Visible = False
      ExplicitLeft = 926
      ExplicitTop = 29
      ExplicitWidth = 82
      Width = 82
    end
    inherited cxLabel1: TcxLabel
      Left = 834
      Visible = False
      ExplicitLeft = 834
    end
    inherited cxLabel2: TcxLabel
      Left = 815
      Top = 30
      Visible = False
      ExplicitLeft = 815
      ExplicitTop = 30
    end
    object lbSearchName: TcxLabel
      Left = 512
      Top = 4
      Caption = #1055#1086#1080#1089#1082' '#1071#1095#1077#1081#1082#1080':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchName: TcxTextEdit
      Left = 615
      Top = 5
      TabOrder = 5
      DesignSize = (
        200
        21)
      Width = 200
    end
    object ceLimit: TcxCurrencyEdit
      Left = 55
      Top = 8
      EditValue = 0.000000000000000000
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0.'
      TabOrder = 6
      Width = 81
    end
    object cxLabel3: TcxLabel
      Left = 10
      Top = 9
      Caption = #1051#1080#1084#1080#1090':'
    end
    object edFilter: TcxTextEdit
      Left = 55
      Top = 39
      TabOrder = 8
      Width = 81
    end
    object cxLabel16: TcxLabel
      Left = 8
      Top = 40
      Caption = #1060#1080#1083#1100#1090#1088':'
    end
    object cbIsOrderBy: TcxCheckBox
      Left = 161
      Top = 8
      Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' ('#1055#1086' '#1090#1086#1074#1072#1088#1091' - '#1076#1072'/ '#1055#1086' '#1076#1072#1090#1077' - '#1085#1077#1090')'
      TabOrder = 10
      Width = 256
    end
    object cbIsAllUser: TcxCheckBox
      Left = 161
      Top = 39
      Caption = #1055#1086' '#1074#1089#1077#1084' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103#1084' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 11
      Width = 200
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 179
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 243
  end
  inherited ActionList: TActionList
    Left = 15
    Top = 194
    inherited actInsert: TdsdInsertUpdateAction
      Enabled = False
      FormName = 'TChoiceCellMovementForm'
      FormNameParam.Value = 'TChoiceCellMovementForm'
    end
    object actMISetUnErased: TdsdUpdateErased [7]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end
        item
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object ExecuteDialog: TExecuteDialog [8]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
      ImageIndex = 35
      FormName = 'TChoiceCellMobileDialogForm'
      FormNameParam.Value = 'TChoiceCellMobileDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Limit'
          Value = 42370d
          Component = ceLimit
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Filter'
          Value = 42370d
          Component = edFilter
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsAllUser'
          Value = Null
          Component = cbIsAllUser
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsOrderBy'
          Value = Null
          Component = cbIsOrderBy
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actMISetErased: TdsdUpdateErased [9]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
    inherited actUpdate: TdsdInsertUpdateAction
      Enabled = False
      FormName = 'TChoiceCellMovementForm'
      FormNameParam.Value = 'TChoiceCellMovementForm'
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
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
    end
    inherited mactReCompleteList: TMultiAction
      Enabled = False
    end
    inherited mactCompleteList: TMultiAction
      Enabled = False
    end
    inherited mactUnCompleteList: TMultiAction
      Enabled = False
    end
    object MIProtocolOpenForm: TdsdOpenForm [17]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementItemId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ChoiceCellName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    inherited mactSetErasedList: TMultiAction
      Enabled = False
    end
    object actPrint: TdsdPrintAction [23]
      Category = 'Print'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'LineNum;GoodsGroupNameFull;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_ChoiceCell'
      ReportNameParam.Value = 'PrintMovement_ChoiceCell'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 139
  end
  inherited MasterCDS: TClientDataSet
    Top = 139
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ChoiceCellMobile'
    Params = <
      item
        Name = 'inIsOrderBy'
        Value = 41640d
        Component = cbIsOrderBy
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsAllUser'
        Value = 41640d
        Component = cbIsAllUser
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLimit'
        Value = Null
        Component = ceLimit
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFilter'
        Value = Null
        Component = edFilter
        DataType = ftString
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
    Left = 168
    Top = 163
  end
  inherited BarManager: TdxBarManager
    Left = 64
    Top = 195
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMIProtocolOpenForm'
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
    inherited dxBarStatic: TdxBarStatic
      Caption = ''
      Hint = ''
    end
    object bbPrint: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100
      Visible = ivAlways
      ImageIndex = 3
    end
    object bbMISetErased: TdxBarButton
      Action = actMISetErased
      Category = 0
    end
    object bbMISetUnErased: TdxBarButton
      Action = actMISetUnErased
      Category = 0
    end
    object bbMIProtocolOpenForm: TdxBarButton
      Action = MIProtocolOpenForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
      end>
    Left = 320
    Top = 224
  end
  inherited PopupMenu: TPopupMenu
    Left = 640
    Top = 152
    inherited N3: TMenuItem
      Visible = False
    end
    inherited N2: TMenuItem
      Visible = False
    end
    inherited N4: TMenuItem
      Visible = False
    end
    inherited miReComplete: TMenuItem
      Visible = False
    end
    inherited N10: TMenuItem
      Visible = False
    end
    inherited N11: TMenuItem
      Visible = False
    end
    inherited N12: TMenuItem
      Visible = False
    end
    inherited N6: TMenuItem
      Visible = False
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 912
    Top = 40
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = ceLimit
      end
      item
        Component = edFilter
      end
      item
        Component = cbIsAllUser
      end
      item
        Component = cbIsOrderBy
      end>
    Left = 424
    Top = 304
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_ChoiceCell'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPrinted'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPrinted'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 64
    Top = 296
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_ChoiceCell'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPrinted'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPrinted'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 320
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_ChoiceCell'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPrinted'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPrinted'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 184
    Top = 280
  end
  inherited FormParams: TdsdFormParams
    Left = 400
    Top = 200
  end
  inherited spMovementReComplete: TdsdStoredProc
    Left = 280
    Top = 320
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 708
    Top = 217
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 708
    Top = 270
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ChoiceCell_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
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
    Left = 535
    Top = 248
  end
  object FieldFilter_Name: TdsdFieldFilter
    TextEdit = edSearchName
    DataSet = MasterCDS
    Column = ChoiceCellName_search
    ColumnList = <
      item
        Column = ChoiceCellName_search
      end>
    CheckBoxList = <>
    Left = 464
    Top = 176
  end
end
