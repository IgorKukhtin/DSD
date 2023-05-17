inherited OrderInternalPackRemainsJournalForm: TOrderInternalPackRemainsJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1086#1089#1090#1072#1090#1082#1080')>'
  ClientHeight = 535
  ClientWidth = 1073
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1089
  ExplicitHeight = 574
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1073
    Height = 478
    TabOrder = 3
    ExplicitWidth = 1073
    ExplicitHeight = 478
    ClientRectBottom = 478
    ClientRectRight = 1073
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1073
      ExplicitHeight = 478
      inherited cxGrid: TcxGrid
        Width = 1073
        Height = 478
        ExplicitWidth = 1073
        ExplicitHeight = 478
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Filter.Options = [fcoCaseInsensitive, fcoShowOperatorDescription]
          DataController.Filter.TranslateBetween = True
          DataController.Filter.TranslateIn = True
          DataController.Filter.TranslateLike = True
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
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
            Width = 80
          end
          inherited colOperDate: TcxGridDBColumn [1]
            HeaderAlignmentHorz = taCenter
            Width = 70
          end
          inherited colInvNumber: TcxGridDBColumn [2]
            Caption = #8470' '#1076#1086#1082'.'
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          object FromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object ToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object TotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'TotalCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object TotalCountKg: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086', '#1082#1075
            DataBinding.FieldName = 'TotalCountKg'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object TotalCountSh: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086', '#1096#1090
            DataBinding.FieldName = 'TotalCountSh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 140
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1073
    ExplicitWidth = 1073
    inherited deStart: TcxDateEdit
      EditValue = 42736d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42736d
    end
  end
  object cxLabel27: TcxLabel [2]
    Left = 722
    Top = 6
    Caption = #1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077':'
  end
  object edJuridicalBasis: TcxButtonEdit [3]
    Left = 800
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 150
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 179
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 203
  end
  inherited ActionList: TActionList
    Left = 47
    Top = 250
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TOrderInternalPackRemainsForm'
      FormNameParam.Value = 'TOrderInternalPackRemainsForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inFromId'
          Value = Null
          Component = FormParams
          ComponentItem = 'inFromId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inToId'
          Value = Null
          Component = FormParams
          ComponentItem = 'inToId'
          MultiSelectSeparator = ','
        end>
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TOrderInternalPackRemainsForm'
      FormNameParam.Value = 'TOrderInternalPackRemainsForm'
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
        end
        item
          Name = 'inFromId'
          Value = Null
          Component = FormParams
          ComponentItem = 'inFromId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inToId'
          Value = Null
          Component = FormParams
          ComponentItem = 'inToId'
          MultiSelectSeparator = ','
        end>
    end
    object actPrintDiff: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintRemains
      StoredProcList = <
        item
          StoredProc = spSelectPrintRemains
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1047#1072#1103#1074#1082#1072' ('#1057#1088#1072#1074#1085#1077#1085#1080#1077')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1047#1072#1103#1074#1082#1072' ('#1057#1088#1072#1074#1085#1077#1085#1080#1077')'
      ImageIndex = 17
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsName;GoodsKindName;KeyId;GoodsName_Child' +
            ';GoodsKindName_Child'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 42132d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'FromName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'ToName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDetail'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDiff'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isMinus'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1086#1089#1090#1072#1090#1082#1080')'
      ReportNameParam.Value = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1086#1089#1090#1072#1090#1082#1080')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintDetail: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintRemains
      StoredProcList = <
        item
          StoredProc = spSelectPrintRemains
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1047#1072#1103#1074#1082#1072' ('#1044#1077#1090#1072#1083#1100#1085#1086')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1047#1072#1103#1074#1082#1072' ('#1044#1077#1090#1072#1083#1100#1085#1086')'
      ImageIndex = 16
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsName;GoodsKindName;KeyId;GoodsName_Child' +
            ';GoodsKindName_Child'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 42132d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'FromName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'ToName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDetail'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDiff'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isMinus'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1086#1089#1090#1072#1090#1082#1080')'
      ReportNameParam.Value = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1086#1089#1090#1072#1090#1082#1080')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintRemains: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintRemains
      StoredProcList = <
        item
          StoredProc = spSelectPrintRemains
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1047#1072#1103#1074#1082#1072' ('#1048#1090#1086#1075#1086')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1047#1072#1103#1074#1082#1072' ('#1048#1090#1086#1075#1086')'
      ImageIndex = 3
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsName;GoodsKindName;KeyId;GoodsName_Child' +
            ';GoodsKindName_Child'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 42132d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'FromName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'ToName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDetail'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDiff'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isMinus'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1086#1089#1090#1072#1090#1082#1080')'
      ReportNameParam.Value = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1086#1089#1090#1072#1090#1082#1080')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
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
          IndexFieldNames = 'UnitCode;GoodsGroupNameFull;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      ReportNameParam.Value = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
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
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserJuridicalBasis
      StoredProcList = <
        item
          StoredProc = spGet_UserJuridicalBasis
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrintRemainsLessUpak: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'Id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'Id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrintRemainsLess
      StoredProcList = <
        item
          StoredProc = spSelectPrintRemainsLess
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080
      Hint = #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1091#1087#1072#1082#1086#1074#1082#1080
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsName;GoodsKindName;FromName;'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 42132d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'FromName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'ToName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isUpak'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1084#1077#1085#1100#1096#1077' '#1079#1072#1082#1072#1079#1072')'
      ReportNameParam.Value = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1084#1077#1085#1100#1096#1077' '#1079#1072#1082#1072#1079#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintRemainsLess: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'Id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'Id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrintRemainsLess
      StoredProcList = <
        item
          StoredProc = spSelectPrintRemainsLess
        end>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1084#1077#1085#1100#1096#1077' '#1079#1072#1082#1072#1079#1072')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1084#1077#1085#1100#1096#1077' '#1079#1072#1082#1072#1079#1072')'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsName;GoodsKindName;FromName;'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 42132d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'FromName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'ToName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isUpak'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1084#1077#1085#1100#1096#1077' '#1079#1072#1082#1072#1079#1072')'
      ReportNameParam.Value = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1084#1077#1085#1100#1096#1077' '#1079#1072#1082#1072#1079#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actOrderInternalPackRemainsOpen: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetAfterExecute = True
      Caption = #1047#1072#1103#1074#1082#1072' ('#1057#1088#1072#1074#1085#1077#1085#1080#1077')'
      Hint = #1047#1072#1103#1074#1082#1072' ('#1057#1088#1072#1074#1085#1077#1085#1080#1077')'
      ImageIndex = 25
      FormName = 'TReport_OrderInternalPackRemainsForm'
      FormNameParam.Value = 'TReport_OrderInternalPackRemainsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = 42736d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inInvNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FromName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ToName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FromId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ToId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPrintRemains_fact2: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrintRemains_fact2
      StoredProcList = <
        item
          StoredProc = spSelectPrintRemains_fact2
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1047#1072#1103#1074#1082#1072' ('#1044#1077#1090#1072#1083#1100#1085#1086' '#1088#1072#1089#1095'.'#1092#1072#1082#1090')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1047#1072#1103#1074#1082#1072' ('#1044#1077#1090#1072#1083#1100#1085#1086' '#1088#1072#1089#1095'.'#1092#1072#1082#1090')'
      ImageIndex = 23
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName;GoodsKindName;Num;'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 42132d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'FromName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'ToName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1086#1089#1090#1072#1090#1082#1080' '#1076#1077#1090#1072#1083#1100#1085#1086')2'
      ReportNameParam.Value = #1047#1072#1103#1074#1082#1072' '#1085#1072' '#1091#1087#1072#1082#1086#1074#1082#1091' ('#1086#1089#1090#1072#1090#1082#1080' '#1076#1077#1090#1072#1083#1100#1085#1086')2'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
  end
  inherited MasterDS: TDataSource
    Left = 88
    Top = 147
  end
  inherited MasterCDS: TClientDataSet
    Top = 139
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderInternal'
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
        Name = 'inisRemains'
        Value = Null
        Component = FormParams
        ComponentItem = 'isRemains'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = 'False'
        Component = FormParams
        ComponentItem = 'inFromId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inToId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalBasisId'
        Value = Null
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 144
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
          ItemName = 'bbPrintRemains'
        end
        item
          Visible = True
          ItemName = 'bbPrintDetail'
        end
        item
          Visible = True
          ItemName = 'bbPrintDiff'
        end
        item
          Visible = True
          ItemName = 'bbPrintRemainsLess'
        end
        item
          Visible = True
          ItemName = 'bbPrintRemainsLessUpak'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintRemains_fact2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOrderInternalPackRemains'
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
    object bbPrintRemains: TdxBarButton
      Action = actPrintRemains
      Category = 0
    end
    object bbPrintDetail: TdxBarButton
      Action = actPrintDetail
      Category = 0
      ImageIndex = 21
    end
    object bbPrintDiff: TdxBarButton
      Action = actPrintDiff
      Category = 0
    end
    object bbPrintRemainsLess: TdxBarButton
      Action = actPrintRemainsLess
      Category = 0
    end
    object bbPrintRemainsLessUpak: TdxBarButton
      Action = actPrintRemainsLessUpak
      Category = 0
      ImageIndex = 16
    end
    object bbOrderInternalPackRemains: TdxBarButton
      Action = actOrderInternalPackRemainsOpen
      Category = 0
    end
    object bbPrintRemains_fact2: TdxBarButton
      Action = actPrintRemains_fact2
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
        Component = JuridicalBasisGuides
      end>
    Left = 408
    Top = 344
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_OrderInternal'
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
    Top = 320
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_OrderInternal'
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
    StoredProcName = 'gpSetErased_Movement_OrderInternal'
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
        Name = 'inFromId'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isRemains'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 400
    Top = 200
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
    StoredProcName = 'gpSelect_Movement_OrderInternal_Print'
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
  object JuridicalBasisGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridicalBasis
    Key = '0'
    FormNameParam.Value = 'TJuridical_BasisForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_BasisForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 895
    Top = 8
  end
  object spGet_UserJuridicalBasis: TdsdStoredProc
    StoredProcName = 'gpGet_User_JuridicalBasis'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'JuridicalBasisId'
        Value = '0'
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisName'
        Value = ''
        Component = JuridicalBasisGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 824
    Top = 48
  end
  object spSelectPrintRemains: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderInternalPackRemains_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsMinus'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 855
    Top = 320
  end
  object spSelectPrintRemainsLess: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderInternalPackRemainsLess_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end>
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
    Left = 527
    Top = 144
  end
  object spSelectPrintRemains_fact2: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderInternalPackRemains_DetailsPrint2'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 599
    Top = 328
  end
end
