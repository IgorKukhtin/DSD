inherited PriceListJournalForm: TPriceListJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1088#1072#1081#1089'-'#1083#1080#1089#1090'>'
  ClientHeight = 535
  ClientWidth = 782
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 798
  ExplicitHeight = 573
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 782
    Height = 478
    TabOrder = 3
    ExplicitWidth = 782
    ExplicitHeight = 478
    ClientRectBottom = 478
    ClientRectRight = 782
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 782
      ExplicitHeight = 478
      inherited cxGrid: TcxGrid
        Width = 782
        Height = 478
        ExplicitWidth = 782
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
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            Visible = False
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 136
          end
          inherited colOperDate: TcxGridDBColumn [1]
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 85
          end
          inherited colInvNumber: TcxGridDBColumn [2]
            Caption = #8470' '#1076#1086#1082'.'
            Visible = False
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 109
          end
          object PartnerCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'PartnerCode'
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 71
          end
          object PartnerName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'PartnerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 316
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 178
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
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
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
            Width = 101
          end
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 782
    ExplicitWidth = 782
    inherited deStart: TcxDateEdit
      EditValue = 42370d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42370d
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 179
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    Left = 40
    Top = 243
  end
  inherited ActionList: TActionList
    Left = 471
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TPriceListMovementForm'
      FormNameParam.Value = 'TPriceListMovementForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TPriceListMovementForm'
      FormNameParam.Value = 'TPriceListMovementForm'
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
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
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
      ReportName = 'PrintMovement_Sale2'
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = 'PrintMovement_Sale2'
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
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actOpenPriceListLoad: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1047#1072#1075#1088#1091#1079#1082#1072' '#1087#1088#1072#1081#1089#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1047#1072#1075#1088#1091#1079#1082#1072' '#1087#1088#1072#1081#1089#1072'>'
      ShortCut = 13
      ImageIndex = 28
      FormName = 'TPriceListItemsLoadForm'
      FormNameParam.Value = 'TPriceListItemsLoadForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PriceListId'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      IdFieldName = 'Id'
    end
    object actDoLoad_SkiDoo: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inOperDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actDoLoad_Osculati: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId_Osculati'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inOperDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actGetImportSetting_Osculati: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId_Osculati
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId_Osculati
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1055#1088#1080#1093#1086#1076#1072' '#1080#1079' '#1092#1072#1081#1083#1072' '#1089' S/N'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1055#1088#1080#1093#1086#1076#1072' '#1080#1079' '#1092#1072#1081#1083#1072' '#1089' S/N'
    end
    object actGetImportSetting_SkiDoo: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId_SkiDoo
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId_SkiDoo
        end>
      Caption = 'actGetImportSetting_SkiDoo'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1055#1088#1080#1093#1086#1076#1072' '#1080#1079' '#1092#1072#1081#1083#1072
    end
    object mactStartLoad_Osculati: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_Osculati
        end
        item
          Action = actDoLoad_Osculati
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Osculati '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Osculati '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Osculati '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' Osculati '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 74
      WithoutNext = True
    end
    object mactStartLoad_SkiDoo: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_SkiDoo
        end
        item
          Action = actDoLoad_SkiDoo
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' SkiDoo '#1080#1079' '#1092#1072#1081#1083#1072'?'
      InfoAfterExecute = #1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' SkiDoo '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' SkiDoo '#1080#1079' '#1092#1072#1081#1083#1072
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1055#1088#1072#1081#1089' '#1083#1080#1089#1090#1099' SkiDoo '#1080#1079' '#1092#1072#1081#1083#1072
      ImageIndex = 41
      WithoutNext = True
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
    StoredProcName = 'gpSelect_Movement_PriceList'
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
        end
        item
          Visible = True
          ItemName = 'bbOpenPriceListLoad'
        end>
    end
    object bbTax: TdxBarButton
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1085#1072#1083#1086#1075#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      Category = 0
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1085#1072#1083#1086#1075#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      Visible = ivNever
      ImageIndex = 41
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
      Visible = ivNever
    end
    object bbPrintTax_Us: TdxBarButton
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbPrintTax_Client: TdxBarButton
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Visible = ivAlways
      ImageIndex = 18
    end
    object bbPrint_Bill: TdxBarButton
      Caption = #1057#1095#1077#1090
      Category = 0
      Hint = #1057#1095#1077#1090
      Visible = ivAlways
      ImageIndex = 21
    end
    object bbOpenPriceListLoad: TdxBarButton
      Action = actOpenPriceListLoad
      Category = 0
      Visible = ivNever
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
    Left = 328
    Top = 152
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
    StoredProcName = 'gpComplete_Movement_PriceList'
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
    StoredProcName = 'gpUnComplete_Movement_PriceList'
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
    StoredProcName = 'gpSetErased_Movement_PriceList'
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
        Name = 'ReportNamePriceList'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNamePriceListTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId_Osculati'
        Value = Null
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
    StoredProcName = 'gpSelect_Movement_Sale_Print'
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
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 556
    Top = 294
  end
  object spGetImportSettingId_SkiDoo: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TPriceListSkiDooJournalForm;zc_Object_ImportSetting_PriceListSki' +
          'DooJournal'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 560
    Top = 384
  end
  object spGetImportSettingId_Osculati: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TIncomeJournalForm;zc_Object_ImportSetting_IncomeSNJournal'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId_SN'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 720
    Top = 384
  end
end
