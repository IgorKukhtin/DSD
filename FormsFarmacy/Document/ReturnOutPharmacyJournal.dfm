inherited ReturnOutPharmacyJournalForm: TReturnOutPharmacyJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1091'>'
  ClientHeight = 469
  ClientWidth = 785
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 801
  ExplicitHeight = 508
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 785
    Height = 412
    TabOrder = 3
    ExplicitWidth = 785
    ExplicitHeight = 412
    ClientRectBottom = 412
    ClientRectRight = 785
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 785
      ExplicitHeight = 412
      inherited cxGrid: TcxGrid
        Width = 785
        Height = 412
        ExplicitWidth = 785
        ExplicitHeight = 412
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
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = TotalSummMVAT
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
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = TotalSummMVAT
            end>
          OptionsBehavior.GoToNextCellOnEnter = False
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 55
          end
          inherited colOperDate: TcxGridDBColumn [1]
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 74
          end
          inherited colInvNumber: TcxGridDBColumn [2]
            Caption = #8470' '#1076#1086#1082'.'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 88
          end
          object FromName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 125
          end
          object ToName: TcxGridDBColumn
            Caption = #1070#1088' '#1083#1080#1094#1086' '#1087#1086#1089#1090'-'#1082
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 143
          end
          object BranchDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1077#1088#1077#1076#1072#1095#1080' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'BranchDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1092#1072#1082#1090'. '#1087#1077#1088#1077#1076#1072#1095#1080' '#1090#1086#1074#1072#1088#1072' '#1074#1086#1076#1080#1090#1077#1083#1102' '#1087#1086#1089#1090'-'#1082#1072
            Width = 92
          end
          object BranchUser: TcxGridDBColumn
            Caption = #1050#1090#1086' '#1087#1077#1088#1077#1076#1072#1083' '#1090#1086#1074#1072#1088
            DataBinding.FieldName = 'BranchUser'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 97
          end
          object TotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'TotalCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object TotalSummMVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'TotalSummMVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object NDSKindName: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDSKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 113
          end
          object InvNumberPartner: TcxGridDBColumn
            Caption = #8470' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'InvNumberPartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object OperDatePartner: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'OperDatePartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
          object AdjustingOurDate: TcxGridDBColumn
            Caption = #1050#1086#1088#1088'. '#1085#1072#1096#1077#1081' '#1076#1072#1090#1099
            DataBinding.FieldName = 'AdjustingOurDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
          object IncomeOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1055#1053
            DataBinding.FieldName = 'IncomeOperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object IncomeInvNumber: TcxGridDBColumn
            Caption = #8470' '#1055#1053
            DataBinding.FieldName = 'IncomeInvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          object ReturnTypeName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1074#1086#1079#1074#1088#1072#1090#1072
            DataBinding.FieldName = 'ReturnTypeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 111
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 785
    ExplicitWidth = 785
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
    object actPrintOptima: TdsdPrintAction [5]
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
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1087#1090#1080#1084#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1087#1090#1080#1084#1072
      ImageIndex = 17
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
      ReportName = #1042#1086#1079#1074#1088#1072#1090#1085#1072#1103'_'#1085#1072#1082#1083#1072#1076#1085#1072#1103'('#1054#1087#1090#1080#1084#1072')'
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = #1042#1086#1079#1074#1088#1072#1090#1085#1072#1103'_'#1085#1072#1082#1083#1072#1076#1085#1072#1103'('#1054#1087#1090#1080#1084#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actInsert: TdsdInsertUpdateAction
      Category = 'Edit'
      ImageIndex = -1
      FormName = 'TReturnOutForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
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
        end>
    end
    inherited actInsertMask: TdsdInsertUpdateAction
      Category = 'Edit'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      Category = 'Edit'
      FormName = 'TReturnOutPharmacyForm'
      FormNameParam.Value = 'TReturnOutPharmacyForm'
      CheckIDRecords = True
    end
    inherited actComplete: TdsdChangeMovementStatus
      Category = 'Complete'
    end
    inherited actUnComplete: TdsdChangeMovementStatus
      Category = 'Complete'
    end
    inherited actSetErased: TdsdChangeMovementStatus
      Category = 'Complete'
    end
    inherited mactReCompleteList: TMultiAction
      Category = 'Complete'
    end
    inherited mactCompleteList: TMultiAction
      Category = 'Complete'
    end
    inherited mactUnCompleteList: TMultiAction
      Category = 'Complete'
    end
    inherited mactSetErasedList: TMultiAction
      Category = 'Complete'
    end
    inherited mactSimpleReCompleteList: TMultiAction
      Category = 'Complete'
    end
    inherited mactSimpleCompleteList: TMultiAction
      Category = 'Complete'
    end
    inherited mactSimpleUncompleteList: TMultiAction
      Category = 'Complete'
    end
    inherited mactSimpleErasedList: TMultiAction
      Category = 'Complete'
    end
    inherited spReCompete: TdsdExecStoredProc
      Category = 'Complete'
    end
    inherited spCompete: TdsdExecStoredProc
      Category = 'Complete'
    end
    inherited spUncomplete: TdsdExecStoredProc
      Category = 'Complete'
    end
    inherited spErased: TdsdExecStoredProc
      Category = 'Complete'
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
      Caption = #1055#1077#1095#1072#1090#1100' '#1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
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
      ReportName = #1042#1086#1079#1074#1088#1072#1090#1085#1072#1103'_'#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = #1042#1086#1079#1074#1088#1072#1090#1085#1072#1103'_'#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object ADOQueryAction1: TADOQueryAction
      Category = 'dsdImportExport'
      MoveParams = <>
    end
    object actGetDataForSend: TdsdExecStoredProc
      Category = 'dsdImportExport'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetDataForSend
      StoredProcList = <
        item
          StoredProc = spGetDataForSend
        end>
      Caption = 'actGetDataForSend'
    end
    object mactSendOneDoc: TMultiAction
      Category = 'dsdImportExport'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetDataForSend
        end
        item
          Action = ADOQueryAction1
        end
        item
          Action = actComplete
        end>
      Caption = 'mactSendOneDoc'
    end
    object MultiAction2: TMultiAction
      Category = 'dsdImportExport'
      MoveParams = <>
      ActionList = <>
      Caption = 'MultiAction2'
    end
    object mactInsert: TMultiAction
      Category = 'Edit'
      MoveParams = <>
      ActionList = <
        item
          Action = actChoiceIncomeMovement
        end
        item
          Action = actReturnOutMovementInsert
        end
        item
          Action = actPUSHMessage
        end
        item
          Action = actInsert
        end>
      ImageIndex = 0
    end
    object actReturnOutMovementInsert: TdsdExecStoredProc
      Category = 'Edit'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertMovement
      StoredProcList = <
        item
          StoredProc = spInsertMovement
        end>
      Caption = 'actReturnOutMovementInsert'
    end
    object actChoiceIncomeMovement: TOpenChoiceForm
      Category = 'Edit'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceIncomeMovement'
      FormName = 'TIncomeJournalChoiceForm'
      FormNameParam.Value = 'TIncomeJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'IncomeMovementId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'StartData'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndData'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object mactEditPartnerData: TMultiAction
      Category = 'PartnerData'
      MoveParams = <>
      ActionList = <
        item
          Action = actPartnerDataDialog
        end
        item
          Action = actUpdateReturnOut_PartnerData
        end
        item
          Action = DataSetPost1
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#8470' '#1080' '#1076#1072#1090#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#8470' '#1080' '#1076#1072#1090#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      ImageIndex = 35
    end
    object actPartnerDataDialog: TExecuteDialog
      Category = 'PartnerData'
      MoveParams = <>
      Caption = 'actPartnerDataDialog'
      FormName = 'TReturnOutPartnerDataDialogForm'
      FormNameParam.Value = 'TReturnOutPartnerDataDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'InvNumberPartner'
          Value = Null
          Component = FormParams
          ComponentItem = 'InvNumberPartner'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDatePartner'
          Value = Null
          Component = FormParams
          ComponentItem = 'OperDatePartner'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AdjustingOurDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'AdjustingOurDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdateReturnOut_PartnerData: TdsdExecStoredProc
      Category = 'PartnerData'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateReturnOut_PartnerData
      StoredProcList = <
        item
          StoredProc = spUpdateReturnOut_PartnerData
        end>
      Caption = 'actUpdateReturnOut_PartnerData'
    end
    object DataSetPost1: TDataSetPost
      Category = 'PartnerData'
      Caption = 'P&ost'
      Hint = 'Post'
      ImageIndex = 78
      DataSource = MasterDS
    end
    object actPrintTTN: TdsdPrintAction
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
      Caption = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053
      Hint = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053
      ImageIndex = 18
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
      ReportName = #1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1058#1058#1053
      ReportNameParam.Value = #1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1058#1058#1053
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
    object actUpdate_BranchDate: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_BranchDate
      StoredProcList = <
        item
          StoredProc = spUpdate_BranchDate
        end>
      Caption = 'actUpdate_BranchDate'
      DataSource = MasterDS
    end
    object actPUSHMessage: TdsdShowPUSHMessage
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPUSHInfo
      StoredProcList = <
        item
          StoredProc = spPUSHInfo
        end>
      Caption = 'actPUSHMessage'
      PUSHMessageType = pmtInformation
    end
    object actUpdate_ClearBranchDate: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_ClearBranchDate
      StoredProcList = <
        item
          StoredProc = spUpdate_ClearBranchDate
        end>
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1044#1072#1090#1072' '#1087#1077#1088#1077#1076#1072#1095#1080' '#1090#1086#1074#1072#1088#1072'"'
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1044#1072#1090#1072' '#1087#1077#1088#1077#1076#1072#1095#1080' '#1090#1086#1074#1072#1088#1072'"'
      ImageIndex = 77
      QuestionBeforeExecute = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1044#1072#1090#1072' '#1087#1077#1088#1077#1076#1072#1095#1080' '#1090#1086#1074#1072#1088#1072'"?'
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
    StoredProcName = 'gpSelect_Movement_ReturnOutPharmacy'
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
    Left = 128
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
          ItemName = 'bbTax'
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
          ItemName = 'bbShowErased'
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
          ItemName = 'bbPrintOptima'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintTax_Us'
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
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'bbSendData'
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
    inherited bbInsert: TdxBarButton
      Action = mactInsert
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
    end
    object bbPrintTax_Us: TdxBarButton
      Action = actPrintTTN
      Category = 0
    end
    object bbPrintTax_Client: TdxBarButton
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Category = 0
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Visible = ivAlways
      ImageIndex = 18
    end
    object bbPrint_Bill: TdxBarButton
      Action = actPrintTTN
      Category = 0
    end
    object bbSendData: TdxBarButton
      Action = mactSendOneDoc
      Category = 0
      Visible = ivNever
    end
    object dxBarButton1: TdxBarButton
      Action = mactEditPartnerData
      Category = 0
      Visible = ivNever
    end
    object bbPrintOptima: TdxBarButton
      Action = actPrintOptima
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actUpdate_ClearBranchDate
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
    inherited N3: TMenuItem
      Action = mactInsert
      Visible = False
    end
    inherited N5: TMenuItem
      Visible = False
    end
    inherited N7: TMenuItem
      Visible = False
    end
    inherited N8: TMenuItem
      Visible = False
    end
    inherited N9: TMenuItem
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
    StoredProcName = 'gpComplete_Movement_ReturnOut'
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
    StoredProcName = 'gpUnComplete_Movement_ReturnOut'
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
    StoredProcName = 'gpSetErased_Movement_ReturnOut'
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
        Name = 'ReportNameReturnOut'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameReturnOutTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'IncomeMovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberPartner'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InvNumberPartner'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDatePartner'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDatePartner'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'AdjustingOurDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AdjustingOurDate'
        DataType = ftDateTime
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
    StoredProcName = 'gpSelect_Movement_ReturnOut_Print'
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
    Left = 607
    Top = 224
  end
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 628
    Top = 294
  end
  object spGetDataForSend: TdsdStoredProc
    StoredProcName = 'gpGetDataForSend'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ConnectionString'
        Value = Null
        Component = ADOQueryAction1
        ComponentItem = 'ConnectionString'
        MultiSelectSeparator = ','
      end
      item
        Name = 'QueryText'
        Value = Null
        Component = ADOQueryAction1
        ComponentItem = 'QueryText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 456
    Top = 112
  end
  object spInsertMovement: TdsdStoredProc
    StoredProcName = 'gpInsert_Movement_ReturnOutFromIncome'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = FormParams
        ComponentItem = 'IncomeMovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 192
    Top = 288
  end
  object spUpdateReturnOut_PartnerData: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_ReturnOut_PartnerData'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inInvNumberPartner'
        Value = ''
        Component = FormParams
        ComponentItem = 'InvNumberPartner'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDatePartner'
        Value = 42381d
        Component = FormParams
        ComponentItem = 'OperDatePartner'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAdjustingOurDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'AdjustingOurDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 416
    Top = 400
  end
  object spUpdate_BranchDate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_ReturnOut_BranchDate'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inBranchDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BranchDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 520
    Top = 280
  end
  object spPUSHInfo: TdsdStoredProc
    StoredProcName = 'gpSelect_ShowPUSH_ReturnOut'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementID'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentID'
        Value = Null
        Component = FormParams
        ComponentItem = 'IncomeMovementId'
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
      end
      item
        Name = 'outSpecialLighting'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outTextColor'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outColor'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outBold'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 410
    Top = 280
  end
  object spUpdate_ClearBranchDate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_ReturnOut_ClearBranchDate'
    DataSets = <>
    OutputType = otResult
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
    Left = 536
    Top = 347
  end
end
