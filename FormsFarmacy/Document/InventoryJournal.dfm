inherited InventoryJournalForm: TInventoryJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103'>'
  ClientHeight = 535
  ClientWidth = 819
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 837
  ExplicitHeight = 582
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 819
    Height = 478
    TabOrder = 3
    ExplicitWidth = 819
    ExplicitHeight = 478
    ClientRectBottom = 478
    ClientRectRight = 819
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 819
      ExplicitHeight = 478
      inherited cxGrid: TcxGrid
        Width = 819
        Height = 478
        ExplicitWidth = 819
        ExplicitHeight = 478
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
          DataController.Filter.TranslateBetween = True
          DataController.Filter.TranslateIn = True
          DataController.Filter.TranslateLike = True
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = DeficitSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = ProficitSumm
            end
            item
              Format = '+,0.00; -,0.00;0.00;'
              Kind = skSum
              Column = DiffSumm
            end
            item
              Format = '+,0.0000;-,0.0000;0,0000;'
              Kind = skSum
              Column = Diff
            end
            item
              Format = '+,0.0000;-,0.0000;0,0000;'
              Kind = skSum
              Column = Diff_calc
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = DeficitSumm_calc
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = ProficitSumm_calc
            end
            item
              Format = '+,0.00; -,0.00;0.00;'
              Kind = skSum
              Column = DiffSumm_calc
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = DeficitSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = ProficitSumm
            end
            item
              Format = '+,0.00; -,0.00;0.00;'
              Kind = skSum
              Column = DiffSumm
            end
            item
              Format = '+,0.0000;-,0.0000;0,0000;'
              Kind = skSum
              Column = Diff
            end
            item
              Format = '+,0.0000;-,0.0000;0,0000;'
              Kind = skSum
              Column = Diff_calc
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = DeficitSumm_calc
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = ProficitSumm_calc
            end
            item
              Format = '+,0.00; -,0.00;0.00;'
              Kind = skSum
              Column = DiffSumm_calc
            end>
          OptionsBehavior.GoToNextCellOnEnter = False
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          OptionsView.HeaderHeight = 40
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          inherited colOperDate: TcxGridDBColumn [1]
            HeaderAlignmentHorz = taCenter
            Width = 64
          end
          inherited colInvNumber: TcxGridDBColumn [2]
            Caption = #8470' '#1076#1086#1082'.'
            HeaderAlignmentHorz = taCenter
            Width = 66
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 252
          end
          object DeficitSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1085#1077#1076#1086#1089#1090#1072#1095#1080
            DataBinding.FieldName = 'DeficitSumm'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object ProficitSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1080#1079#1083#1080#1096#1082#1072
            DataBinding.FieldName = 'ProficitSumm'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Diff: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' '#1074' '#1082#1086#1083'-'#1074#1077
            DataBinding.FieldName = 'Diff'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = '+,0.0000;-,0.0000;;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object DiffSumm: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' '#1074' '#1089#1091#1084#1084#1077
            DataBinding.FieldName = 'DiffSumm'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = '+,0.00; -,0.00;;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Diff_calc: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' '#1074' '#1082#1086#1083'-'#1074#1077' ('#1087#1088#1086#1074#1086#1076#1082#1080')'
            DataBinding.FieldName = 'Diff_calc'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = '+,0.0000;-,0.0000;;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object DeficitSumm_calc: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1085#1077#1076#1086#1089#1090#1072#1095#1080' ('#1087#1088#1086#1074#1086#1076#1082#1080')'
            DataBinding.FieldName = 'DeficitSumm_calc'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = ',0.00'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object ProficitSumm_calc: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1080#1079#1083#1080#1096#1082#1072' ('#1087#1088#1086#1074#1086#1076#1082#1080')'
            DataBinding.FieldName = 'ProficitSumm_calc'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = ',0.00'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object DiffSumm_calc: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072' '#1074' '#1089#1091#1084#1084#1077' ('#1087#1088#1086#1074#1086#1076#1082#1080')'
            DataBinding.FieldName = 'DiffSumm_calc'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = '+,0.00; -,0.00;;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object FullInvent: TcxGridDBColumn
            Caption = #1055#1086#1083#1085#1072#1103
            DataBinding.FieldName = 'FullInvent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1083#1085#1072#1103' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
            Options.Editing = False
            Width = 52
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 121
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 819
    ExplicitWidth = 819
    inherited deStart: TcxDateEdit
      EditValue = 42005d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42005d
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
    Left = 471
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TInventoryForm'
    end
    inherited actInsertMask: TdsdInsertUpdateAction
      Enabled = False
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TInventoryForm'
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
    inherited actComplete: TdsdChangeMovementStatus
      BeforeAction = actPUSHCompile
      StoredProc = spCompileUnitFull_Start
      StoredProcList = <
        item
          StoredProc = spCompileUnitFull_Start
        end
        item
          StoredProc = spMovementComplete
        end
        item
          StoredProc = spCompileUnitFull_Finish
        end>
      QuestionBeforeExecute = #1055#1077#1088#1077#1076' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077#1084' '#1085#1077' '#1079#1072#1073#1091#1076#1100#1090#1077' '#1089#1086#1093#1088#1072#1085#1080#1090#1100' '#1087#1077#1088#1077#1091#1095#1077#1090' '#1074' Exel-'#1092#1072#1081#1083
      InfoAfterExecute = #1053#1077' '#1079#1072#1073#1091#1076#1100#1090#1077' '#1089#1086#1093#1088#1072#1085#1080#1090#1100' '#1087#1077#1088#1077#1091#1095#1077#1090' '#1074' Exel-'#1092#1072#1081#1083
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
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
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
      ReportNameParam.Value = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
      PreviewWindowMaximized = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TMovement_PeriodDialogForm'
      FormNameParam.Value = 'TMovement_PeriodDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPUSHCompile: TdsdShowPUSHMessage
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPUSHCompile
      StoredProcList = <
        item
          StoredProc = spPUSHCompile
        end>
      Caption = 'actPUSHCompile'
    end
    object actPrintInventoryTime: TdsdExportToXLS
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actExecInventoryTime
      ItemsDataSet = PrintItemsCDS
      Title = #1054#1090#1095#1077#1090' '#1088#1072#1079#1085#1080#1094#1072' '#1087#1086'  '#1074#1088#1077#1084#1077#1085#1080' '#1084#1077#1078#1076#1091' '#1089#1086#1079#1076#1072#1085#1080#1077#1084' '#1080' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077#1084
      FileNameParam.Value = ''
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      TitleHeight = 1.000000000000000000
      SignHeight = 1.000000000000000000
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'Tahoma'
      HeaderFont.Style = []
      SignFont.Charset = DEFAULT_CHARSET
      SignFont.Color = clWindowText
      SignFont.Height = -11
      SignFont.Name = 'Tahoma'
      SignFont.Style = []
      ColumnParams = <
        item
          Caption = #1053#1086#1084#1077#1088
          FieldName = 'InvNumber'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
          FieldName = 'OperDate'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          FieldName = 'UnitName'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 30
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1042#1074#1077#1083
          FieldName = 'InsertName'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 18
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1044#1072#1090#1072' '#1074#1074#1086#1076#1072
          FieldName = 'InsertDate'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 18
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1055#1088#1086#1074#1077#1083
          FieldName = 'UpdateName'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 18
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1044#1072#1090#1072' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1103
          FieldName = 'UpdateDate'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 18
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1048#1085#1090#1077#1088#1074#1072#1083
          FieldName = 'Interv'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 18
          CalcColumnLists = <>
          DetailedTexts = <>
        end>
      Caption = #1054#1090#1095#1077#1090' '#1088#1072#1079#1085#1080#1094#1072' '#1087#1086'  '#1074#1088#1077#1084#1077#1085#1080' '#1084#1077#1078#1076#1091' '#1089#1086#1079#1076#1072#1085#1080#1077#1084' '#1080' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077#1084
      Hint = #1054#1090#1095#1077#1090' '#1088#1072#1079#1085#1080#1094#1072' '#1087#1086'  '#1074#1088#1077#1084#1077#1085#1080' '#1084#1077#1078#1076#1091' '#1089#1086#1079#1076#1072#1085#1080#1077#1084' '#1080' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077#1084
      ImageIndex = 21
    end
    object actExecInventoryTime: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInventoryTime
      StoredProcList = <
        item
          StoredProc = spInventoryTime
        end>
      Caption = 'actExecInventoryTime'
    end
    object actCompileUnitFull_Finish: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spCompileUnitFull_Finish
      StoredProcList = <
        item
          StoredProc = spCompileUnitFull_Finish
        end>
      Caption = 'spCompete'
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
    StoredProcName = 'gpSelect_Movement_Inventory'
    Params = <
      item
        Name = 'instartdate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inenddate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
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
      end
      item
        Value = False
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 136
    Top = 163
  end
  inherited BarManager: TdxBarManager
    Left = 224
    Top = 155
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsert'
        end
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
          ItemName = 'bbComplete'
        end
        item
          Visible = True
          ItemName = 'bbUnComplete'
        end
        item
          Visible = True
          ItemName = 'bbDelete'
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
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
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
        end>
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbPrint1: TdxBarButton
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      Category = 0
      Hint = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      Visible = ivAlways
      ImageIndex = 22
    end
    object dxBarButton1: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100
      Visible = ivAlways
      ImageIndex = 16
    end
    object dxBarButton2: TdxBarButton
      Action = actPrintInventoryTime
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 224
  end
  inherited PopupMenu: TPopupMenu
    Left = 640
    Top = 152
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 288
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
    Left = 408
    Top = 344
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_Inventory'
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
        Value = True
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 320
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_Inventory'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 384
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_Inventory'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 376
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
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameInventory'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameInventoryTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 400
    Top = 200
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_Inventory'
    Left = 176
    Top = 304
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
    StoredProcName = 'gpSelect_Movement_Inventory_Print'
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
  object spPUSHCompile: TdsdStoredProc
    StoredProcName = 'gpSelect_ShowCompilePUSH_Inventory'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementID'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitID'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42132d
        Component = MasterCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outShowMessage'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPUSHType'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outText'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 706
    Top = 328
  end
  object spInventoryTime: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Inventory_Time'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 535
    Top = 336
  end
  object spPUSHCompileFull: TdsdStoredProc
    StoredProcName = 'gpSelect_ShowCompilePUSH_InventoryFull'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementID'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outShowMessage'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPUSHType'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outText'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 706
    Top = 384
  end
  object spCompileUnitFull_Finish: TdsdStoredProc
    StoredProcName = 'gpUpdate_Inventory_CompileUnitFull'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementID'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outShowMessage'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPUSHType'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outText'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 314
    Top = 400
  end
  object spCompileUnitFull_Start: TdsdStoredProc
    StoredProcName = 'gpUpdate_Inventory_CompileUnitFull'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementID'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outShowMessage'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPUSHType'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outText'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 314
    Top = 344
  end
end
