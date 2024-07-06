inherited BankStatementJournalForm: TBankStatementJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1041#1072#1085#1082#1086#1074#1089#1082#1080#1077' '#1074#1099#1087#1080#1089#1082#1080'>'
  ClientHeight = 543
  ClientWidth = 872
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 888
  ExplicitHeight = 582
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 872
    Height = 486
    TabOrder = 3
    ExplicitWidth = 872
    ClientRectBottom = 486
    ClientRectRight = 872
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 872
      inherited cxGrid: TcxGrid
        Width = 872
        Height = 486
        ExplicitWidth = 872
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 95
          end
          inherited colInvNumber: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 100
          end
          inherited colOperDate: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 80
          end
          object BankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082
            DataBinding.FieldName = 'BankName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 175
          end
          object BankAccountName: TcxGridDBColumn
            Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
            DataBinding.FieldName = 'BankAccountName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 172
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086' ('#1088'.'#1089#1095#1077#1090')'
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 872
    ExplicitWidth = 872
    inherited deStart: TcxDateEdit
      Left = 109
      EditValue = 45292d
      ExplicitLeft = 109
    end
    inherited deEnd: TcxDateEdit
      EditValue = 45292d
    end
  end
  object cxLabel27: TcxLabel [2]
    Left = 522
    Top = 6
    Caption = #1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077':'
  end
  object edJuridicalBasis: TcxButtonEdit [3]
    Left = 600
    Top = 6
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 150
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = BankFidoLoad
        Properties.Strings = (
          'InitializeDirectory')
      end
      item
        Component = BankForumLoad
        Properties.Strings = (
          'InitializeDirectory')
      end
      item
        Component = BankPrivatLoad
        Properties.Strings = (
          'InitializeDirectory')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
      item
        Component = BankVostokLoad
        Properties.Strings = (
          'InitializeDirectory')
      end
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end>
  end
  inherited ActionList: TActionList
    Left = 167
    Top = 98
    object ProcreditBankLoad: TClientBankLoadAction [0]
      Category = 'Load'
      MoveParams = <>
      ClientBankType = cbProkreditBank
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
      EndDateParam.MultiSelectSeparator = ','
    end
    object ProcreditBank: TMultiAction [1]
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = BankMarfinLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1055#1088#1086#1082#1088#1077#1076#1080#1090' '#1041#1072#1085#1082
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1055#1088#1086#1082#1088#1077#1076#1080#1090' '#1041#1072#1085#1082
      ImageIndex = 73
    end
    object RaiffeisenBankLoad: TClientBankLoadAction [4]
      Category = 'Load'
      MoveParams = <>
      isOEM = False
      ClientBankType = cbRaiffeisenBank
      StartDateParam.Value = 43831d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = 43831d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
      EndDateParam.MultiSelectSeparator = ','
    end
    object mRaiffeisenBankLoad: TMultiAction [5]
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = RaiffeisenBankLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1056#1072#1081#1092#1092#1072#1081#1079#1077#1085' '#1041#1072#1085#1082
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1056#1072#1081#1092#1092#1072#1081#1079#1077#1085' '#1041#1072#1085#1082
      ImageIndex = 73
    end
    object BankMarfinLoad: TClientBankLoadAction [8]
      Category = 'Load'
      MoveParams = <>
      isOEM = False
      ClientBankType = cbMarfinBank
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
      EndDateParam.MultiSelectSeparator = ','
    end
    object BankMarfin: TMultiAction [9]
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = BankMarfinLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1052#1072#1088#1092#1080#1085' '#1041#1072#1085#1082#1072
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1052#1072#1088#1092#1080#1085' '#1041#1072#1085#1082#1072
      ImageIndex = 71
    end
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TBankStatementForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TBankStatementForm'
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
    inherited actSetErased: TdsdChangeMovementStatus
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'? '
    end
    object actDoLoad: TExecuteImportSettingsAction [24]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = '0'
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
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
    end
    object BankPrivatLoad: TClientBankLoadAction
      Category = 'Load'
      MoveParams = <>
      isOEM = False
      ClientBankType = cbPrivatBank
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
      EndDateParam.MultiSelectSeparator = ','
    end
    object BankForumLoad: TClientBankLoadAction
      Category = 'Load'
      MoveParams = <>
      ClientBankType = cbForum
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
      EndDateParam.MultiSelectSeparator = ','
    end
    object BankPireusLoad: TClientBankLoadAction
      Category = 'Load'
      MoveParams = <>
      ClientBankType = cbPireusBank
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
      EndDateParam.MultiSelectSeparator = ','
    end
    object BankOTPLoad: TClientBankLoadAction
      Category = 'Load'
      MoveParams = <>
      isOEM = False
      ClientBankType = cbOTPBank
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
      EndDateParam.MultiSelectSeparator = ','
    end
    object BankPireusDBFLoad: TClientBankLoadAction
      Category = 'Load'
      MoveParams = <>
      ClientBankType = cbPireusBankDBF
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
      EndDateParam.MultiSelectSeparator = ','
    end
    object BankPireusDBF: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = BankPireusDBFLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1055#1080#1088#1077#1091#1089' '#1073#1072#1085#1082#1072' (dbf)'
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1055#1080#1088#1077#1091#1089' '#1073#1072#1085#1082#1072' (dbf)'
      ImageIndex = 70
    end
    object BankPireus: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = BankPireusLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1055#1080#1088#1077#1091#1089' '#1073#1072#1085#1082#1072' '
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1055#1080#1088#1077#1091#1089' '#1073#1072#1085#1082#1072' '
      ImageIndex = 70
    end
    object BankOTP: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = BankOTPLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1054#1058#1055' '#1073#1072#1085#1082#1072' DBF'
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1054#1058#1055' '#1073#1072#1085#1082#1072' DBF'
      ImageIndex = 69
    end
    object BankVostokLoad: TClientBankLoadAction
      Category = 'Load'
      MoveParams = <>
      ClientBankType = cbVostok
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
      EndDateParam.MultiSelectSeparator = ','
    end
    object BankFidoLoad: TClientBankLoadAction
      Category = 'Load'
      MoveParams = <>
      ClientBankType = cbFidoBank
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
      EndDateParam.MultiSelectSeparator = ','
    end
    object BankPrivat: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = BankPrivatLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1055#1088#1080#1074#1072#1090'-'#1041#1072#1085#1082' ('#1048#1088#1085#1072')'
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1055#1088#1080#1074#1072#1090'-'#1041#1072#1085#1082' ('#1048#1088#1085#1072')'
      ImageIndex = 47
    end
    object BankForum: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = BankForumLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1073#1072#1085#1082#1072' '#1060#1086#1088#1091#1084
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1073#1072#1085#1082#1072' '#1060#1086#1088#1091#1084
      ImageIndex = 48
    end
    object BankVostok: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = BankVostokLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1073#1072#1085#1082#1072' '#1042#1086#1089#1090#1086#1082
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1073#1072#1085#1082#1072' '#1042#1086#1089#1090#1086#1082
      ImageIndex = 49
    end
    object BankFido: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = BankFidoLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1060#1080#1076#1086#1073#1072#1085#1082#1072
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1060#1080#1076#1086#1073#1072#1085#1082#1072
      ImageIndex = 68
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
    object BankOTPXLSLoad: TClientBankLoadAction
      Category = 'Load'
      MoveParams = <>
      ClientBankType = cbOTPBankXLS
      StartDateParam.Value = 42736d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = 42736d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
      EndDateParam.MultiSelectSeparator = ','
    end
    object BankOTPXLS: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = BankOTPXLSLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1054#1058#1055' '#1073#1072#1085#1082#1072' XLS'
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1054#1058#1055' '#1073#1072#1085#1082#1072' XLS'
      ImageIndex = 69
    end
    object BankOshad: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = BankOshadLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1073#1072#1085#1082#1072' '#1054#1097#1072#1076
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1073#1072#1085#1082#1072' '#1054#1097#1072#1076
      ImageIndex = 73
    end
    object BankOshadLoad: TClientBankLoadAction
      Category = 'Load'
      MoveParams = <>
      isOEM = False
      ClientBankType = cbOshadBank
      StartDateParam.Value = 43831d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = 43831d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
      EndDateParam.MultiSelectSeparator = ','
    end
    object actGetImportSetting_csv_Privat: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId_Privat
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId_Privat
        end>
      Caption = 'actGetImportSetting_csv_Privat'
    end
    object mactStartLoad_csv_Privat: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_csv_Privat
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1041#1072#1085#1082#1086#1074#1089#1082#1080#1093' '#1074#1099#1087#1080#1089#1086#1082' '#1055#1088#1080#1074#1072#1090' '#1080#1079' '#1092#1072#1081#1083#1072' csv?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1055#1088#1080#1074#1072#1090
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1055#1088#1080#1074#1072#1090
      ImageIndex = 50
      WithoutNext = True
    end
    object actGetImportSetting_csv_Vostok: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId_Vostok
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId_Vostok
        end>
      Caption = 'actGetImportSetting_csv_Vostok'
    end
    object mactStartLoad_csv_Vostok: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_csv_Vostok
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1041#1072#1085#1082#1086#1074#1089#1082#1080#1093' '#1074#1099#1087#1080#1089#1086#1082' '#1042#1086#1089#1090#1086#1082' '#1080#1079' '#1092#1072#1081#1083#1072' csv?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1042#1086#1089#1090#1086#1082
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1042#1086#1089#1090#1086#1082
      ImageIndex = 50
      WithoutNext = True
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_BankStatement'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
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
      end
      item
        Name = 'inAccountId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inAccountId'
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
          ItemName = 'dxBarStatic'
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
          ItemName = 'bbOTPLoad'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbBankOTPXLS'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProkreditBank'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRaiffeisenBankLoad'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbBankOshad'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbBankPrivat'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
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
      Enabled = False
    end
    inherited bbEdit: TdxBarButton
      Enabled = False
    end
    inherited bbComplete: TdxBarButton
      Action = nil
    end
    inherited bbUnComplete: TdxBarButton
      Action = nil
    end
    object bbBankPrivat: TdxBarButton
      Action = BankPrivat
      Category = 0
    end
    object bbBankVostok: TdxBarButton
      Action = BankVostok
      Category = 0
    end
    object bbBankForum: TdxBarButton
      Action = BankForum
      Category = 0
    end
    object bbBankErnst: TdxBarButton
      Action = BankFido
      Category = 0
    end
    object bbOTPLoad: TdxBarButton
      Action = BankOTP
      Category = 0
    end
    object bbPireus: TdxBarButton
      Action = BankPireus
      Category = 0
    end
    object bbPireusDBFLoad: TdxBarButton
      Action = BankPireusDBF
      Category = 0
    end
    object bbMarfinLoad: TdxBarButton
      Action = BankMarfin
      Category = 0
    end
    object bbProkreditBank: TdxBarButton
      Action = ProcreditBank
      Category = 0
    end
    object bbBankOTPXLS: TdxBarButton
      Action = BankOTPXLS
      Category = 0
    end
    object bbRaiffeisenBankLoad: TdxBarButton
      Action = mRaiffeisenBankLoad
      Category = 0
    end
    object bbBankOshad: TdxBarButton
      Action = BankOshad
      Category = 0
    end
    object bbStartLoad_csv_Privat: TdxBarButton
      Action = mactStartLoad_csv_Privat
      Category = 0
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' csv'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbStartLoad_csv_Privat'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbStartLoad_csv_Vostok'
        end>
    end
    object bbStartLoad_csv_Vostok: TdxBarButton
      Action = mactStartLoad_csv_Vostok
      Category = 0
    end
    object dxBarSeparator1: TdxBarSeparator
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      ShowCaption = False
    end
  end
  inherited PopupMenu: TPopupMenu
    inherited N3: TMenuItem
      Visible = False
    end
    inherited N2: TMenuItem
      Visible = False
    end
    inherited N4: TMenuItem
      Visible = False
    end
    inherited N5: TMenuItem
      Visible = False
    end
    inherited N7: TMenuItem
      Visible = False
    end
    inherited N9: TMenuItem
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
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = JuridicalBasisGuides
      end>
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_BankStatement'
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
        Name = 'inAccountId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccountName'
        Value = Null
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisId'
        Value = Null
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalBasisName'
        Value = Null
        Component = JuridicalBasisGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
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
    Left = 671
  end
  object spGet_UserJuridicalBasis: TdsdStoredProc
    StoredProcName = 'gpGet_UserJuridicalBankAccount'
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
    Left = 768
    Top = 64
  end
  object spGetImportSettingId_Privat: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TBankStatementJournalForm;zc_Object_ImportSetting_BankStatement_' +
          'csv'
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
    Left = 648
    Top = 160
  end
  object spGetImportSettingId_Vostok: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TBankStatementJournalForm;zc_Object_ImportSetting_BankStatement_' +
          'csv_Vostok'
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
    Top = 96
  end
end
