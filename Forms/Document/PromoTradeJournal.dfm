inherited PromoTradeJournalForm: TPromoTradeJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1058#1088#1077#1081#1076'-'#1084#1072#1088#1082#1077#1090#1080#1085#1075'>'
  ClientHeight = 415
  ClientWidth = 1084
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1100
  ExplicitHeight = 454
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 61
    Width = 1084
    Height = 354
    TabOrder = 3
    ExplicitTop = 61
    ExplicitWidth = 1084
    ExplicitHeight = 354
    ClientRectBottom = 354
    ClientRectRight = 1084
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1084
      ExplicitHeight = 354
      inherited cxGrid: TcxGrid
        Width = 1084
        Height = 354
        ExplicitWidth = 1084
        ExplicitHeight = 354
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = PromoKindName
            end>
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
            HeaderAlignmentHorz = taCenter
          end
          inherited colInvNumber: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
          end
          inherited colOperDate: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
          end
          object PromoTradeStateKindName: TcxGridDBColumn
            Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
            DataBinding.FieldName = 'PromoTradeStateKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1079#1085#1072#1082' '#1089#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1103
            Width = 80
          end
          object Checked: TcxGridDBColumn
            Caption = #1057#1086#1075#1083#1072#1089#1086#1074#1072#1085#1086
            DataBinding.FieldName = 'Checked'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object CheckDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1103
            DataBinding.FieldName = 'CheckDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object RetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ContractName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 87
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 53
          end
          object ContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 97
          end
          object PromoItemName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1100#1103' '#1079#1072#1090#1088#1072#1090
            DataBinding.FieldName = 'PromoItemName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 111
          end
          object PromoKindName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1091#1095#1072#1089#1090#1080#1103
            DataBinding.FieldName = 'PromoKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 173
          end
          object ChangePercent: TcxGridDBColumn
            Caption = '(-)% '#1057#1082#1080#1076#1082#1080' (+)% '#1053#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '(-)% '#1057#1082#1080#1076#1082#1080' (+)% '#1053#1072#1094#1077#1085#1082#1080' '#1087#1086' '#1076#1086#1075#1086#1074#1086#1088#1091
            Width = 84
          end
          object CostPromo: TcxGridDBColumn
            Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1091#1095#1072#1089#1090#1080#1103
            DataBinding.FieldName = 'CostPromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object StartPromo: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089
            DataBinding.FieldName = 'StartPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object EndPromo: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1086
            DataBinding.FieldName = 'EndPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 101
          end
          object PersonalTradeName: TcxGridDBColumn
            Caption = #1060#1048#1054' ('#1082#1086#1084#1084#1077#1088#1095#1077#1089#1082#1080#1081' '#1086#1090#1076#1077#1083')'
            DataBinding.FieldName = 'PersonalTradeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' '#1087#1088#1077#1076#1089#1090#1072#1074#1080#1090#1077#1083#1100' '#1082#1086#1084#1084#1077#1088#1095#1077#1089#1082#1086#1075#1086' '#1086#1090#1076#1077#1083#1072
            Width = 103
          end
          object PriceListName: TcxGridDBColumn
            Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
            DataBinding.FieldName = 'PriceListName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 95
          end
          object SignInternalName: TcxGridDBColumn
            Caption = #1052#1086#1076#1077#1083#1100' '#1076#1083#1103' '#1089#1086#1075#1083#1072#1089#1086#1074#1072#1085#1080#1103
            DataBinding.FieldName = 'SignInternalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object strSign: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1087#1086#1083#1100#1079'. - '#1077#1089#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
            DataBinding.FieldName = 'strSign'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object strSignNo: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1087#1086#1083#1100#1079'. - '#1086#1078#1080#1076#1072#1077#1090#1089#1103' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
            DataBinding.FieldName = 'strSignNo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 93
          end
          object InsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 106
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1084
    Height = 35
    ExplicitWidth = 1084
    ExplicitHeight = 35
    inherited deStart: TcxDateEdit
      EditValue = 43831d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 43831d
    end
    inherited cxLabel2: TcxLabel
      Left = 198
      ExplicitLeft = 198
    end
    object cxLabel27: TcxLabel
      Left = 849
      Top = 6
      Caption = #1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077':'
    end
    object edJuridicalBasis: TcxButtonEdit
      Left = 927
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 155
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 99
    Top = 323
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 323
  end
  inherited ActionList: TActionList
    Left = 175
    Top = 178
    object actRefreshPartner: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1056#1072#1079#1074#1077#1088#1085#1091#1090#1100' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    inherited actUpdate: TdsdInsertUpdateAction [1]
      FormName = 'TPromoTradeForm'
      FormNameParam.Value = 'TPromoTradeForm'
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
          Name = 'inMask'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
    end
    inherited actUnComplete: TdsdChangeMovementStatus [2]
    end
    inherited actComplete: TdsdChangeMovementStatus [3]
    end
    inherited actSetErased: TdsdChangeMovementStatus [4]
    end
    inherited actRefresh: TdsdDataSetRefresh [5]
    end
    inherited actGridToExcel: TdsdGridToExcel [6]
    end
    inherited actInsert: TdsdInsertUpdateAction [7]
      FormName = 'TPromoTradeForm'
      FormNameParam.Value = 'TPromoTradeForm'
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
          Name = 'inMask'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
    end
    inherited mactReCompleteList: TMultiAction [8]
    end
    inherited actMovementItemContainer: TdsdOpenForm [9]
    end
    inherited mactCompleteList: TMultiAction [10]
    end
    inherited MovementProtocolOpenForm: TdsdOpenForm [11]
    end
    inherited mactUnCompleteList: TMultiAction [12]
    end
    inherited actShowErased: TBooleanStoredProcAction [13]
    end
    inherited spReCompete: TdsdExecStoredProc [14]
    end
    inherited spCompete: TdsdExecStoredProc [15]
    end
    inherited spUncomplete: TdsdExecStoredProc [16]
    end
    inherited spErased: TdsdExecStoredProc [17]
    end
    inherited mactSetErasedList: TMultiAction [18]
    end
    inherited mactSimpleReCompleteList: TMultiAction [19]
    end
    inherited mactSimpleCompleteList: TMultiAction [20]
    end
    object actPrint: TdsdPrintAction [21]
      Category = 'Print'
      MoveParams = <>
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
          IndexFieldNames = 'LineNo'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'Ord'
        end
        item
          DataSet = PrintSignCDS
          UserName = 'frxDBDSign'
        end>
      Params = <
        item
          Name = 'InvNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Comment'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Comment'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PromoItemName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PromoItemName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalTradeName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PersonalTradeName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextSign'
          Value = Null
          Component = FormParams
          ComponentItem = 'TextSign'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_PromoTrade'
      ReportNameParam.Value = 'PrintMovement_PromoTrade'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited mactSimpleUncompleteList: TMultiAction [22]
    end
    object ExecuteDialog: TExecuteDialog [23]
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
          Value = 42309d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42309d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actRefreshStart: TdsdDataSetRefresh [24]
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
    object actInsertUpdateMISignYes: TdsdExecStoredProc [25]
      Category = 'Sign'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMISign_Yes
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMISign_Yes
        end
        item
        end>
      Caption = #1055#1086#1089#1090#1072#1074#1080#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
      Hint = #1055#1086#1089#1090#1072#1074#1080#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
    end
    object mactInsertUpdateMISignYes: TMultiAction [26]
      Category = 'Sign'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdateMISignYes
        end>
      View = cxGridDBTableView
      Caption = #1055#1086#1089#1090#1072#1074#1080#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
      Hint = #1055#1086#1089#1090#1072#1074#1080#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
    end
    object mactInsertUpdateMISignYesList: TMultiAction [27]
      Category = 'Sign'
      MoveParams = <>
      ActionList = <
        item
          Action = mactInsertUpdateMISignYes
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084'? '
      InfoAfterExecute = #1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1086#1076#1087#1080#1089#1072#1085#1099' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      Hint = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      ImageIndex = 58
    end
    object actInsertUpdateMISignNo: TdsdExecStoredProc [28]
      Category = 'Sign'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMISign_No
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMISign_No
        end
        item
        end>
      Caption = #1059#1073#1088#1072#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
      Hint = #1059#1073#1088#1072#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
    end
    object mactInsertUpdateMISignNo: TMultiAction [29]
      Category = 'Sign'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertUpdateMISignNo
        end>
      View = cxGridDBTableView
      Caption = #1059#1073#1088#1072#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
      Hint = #1059#1073#1088#1072#1090#1100' '#1101#1083'. '#1087#1086#1076#1087#1080#1089#1100
    end
    object mactInsertUpdateMISignNoList: TMultiAction [30]
      Category = 'Sign'
      MoveParams = <>
      ActionList = <
        item
          Action = mactInsertUpdateMISignNo
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084'? '
      InfoAfterExecute = #1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' '#1087#1086#1076#1087#1080#1089#1100' '#1086#1090#1084#1077#1085#1077#1085#1072' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1091#1102' '#1087#1086#1076#1087#1080#1089#1100' '#1042#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      ImageIndex = 52
    end
    object actAllPartner: TBooleanStoredProcAction [31]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1053#1077' '#1088#1072#1079#1074#1086#1088#1072#1095#1080#1074#1072#1090#1100' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084
      Hint = #1056#1072#1079#1074#1077#1088#1085#1091#1090#1100' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084
      ImageIndex = 63
      Value = False
      HintTrue = #1053#1077' '#1088#1072#1079#1074#1086#1088#1072#1095#1080#1074#1072#1090#1100' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084
      HintFalse = #1056#1072#1079#1074#1077#1088#1085#1091#1090#1100' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084
      CaptionTrue = #1056#1072#1079#1074#1077#1088#1085#1091#1090#1100' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084
      CaptionFalse = #1053#1077' '#1088#1072#1079#1074#1086#1088#1072#1095#1080#1074#1072#1090#1100' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    inherited mactSimpleErasedList: TMultiAction [32]
    end
    inherited actInsertMask: TdsdInsertUpdateAction [33]
      ShortCut = 0
      FormName = 'TPromoTradeForm'
      FormNameParam.Value = 'TPromoTradeForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMask'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
    end
    object actInsertMaskMulti: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertMask
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1076#1086#1073#1072#1074#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1087#1086' '#1084#1072#1089#1082#1077'? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090' '#1087#1086' '#1084#1072#1089#1082#1077' '#1076#1086#1073#1072#1074#1083#1077#1085
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1087#1086' '#1084#1072#1089#1082#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1087#1086' '#1084#1072#1089#1082#1077
      ImageIndex = 54
    end
    object actGet_SignPrint: TdsdExecStoredProc
      Category = 'Print'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_SignPrint
      StoredProcList = <
        item
          StoredProc = spGet_SignPrint
        end>
      Caption = 'actGet_SignPrint'
    end
    object macPrint: TMultiAction
      Category = 'Print'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_SignPrint
        end
        item
          Action = actPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
    end
  end
  inherited MasterDS: TDataSource
    Left = 40
    Top = 123
  end
  inherited MasterCDS: TClientDataSet
    Left = 8
    Top = 131
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PromoTrade'
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
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
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
    Left = 72
    Top = 131
  end
  inherited BarManager: TdxBarManager
    Left = 136
    Top = 219
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
          ItemName = 'bbInsertMask'
        end
        item
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
    inherited bbInsertMask: TdxBarButton
      Action = actInsertMaskMulti
    end
    object dxBarButton1: TdxBarButton
      Action = macPrint
      Category = 0
    end
    object bbInsertUpdateMISignYesList: TdxBarButton
      Action = mactInsertUpdateMISignYesList
      Category = 0
    end
    object bbInsertUpdateMISignNoList: TdxBarButton
      Action = mactInsertUpdateMISignNoList
      Category = 0
    end
    object bbAllPartner: TdxBarButton
      Action = actAllPartner
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ColorValueList = <>
      end>
    Left = 208
  end
  inherited PopupMenu: TPopupMenu
    Left = 200
    Top = 320
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 248
    Top = 184
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
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_PromoTrade'
    Left = 72
    Top = 224
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_PromoTrade'
    Left = 72
    Top = 184
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_PromoTrade'
    Left = 72
    Top = 272
  end
  inherited FormParams: TdsdFormParams
    Left = 328
    Top = 296
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_PromoTrade'
    Left = 200
    Top = 264
  end
  object spSelect_Movement_PromoTrade_Print: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PromoTrade_Print'
    DataSet = PrintHead
    DataSets = <
      item
        DataSet = PrintHead
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
    Left = 576
    Top = 176
  end
  object PrintHead: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 904
    Top = 184
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
    Left = 983
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
    Left = 640
    Top = 48
  end
  object spInsertUpdateMISign_Yes: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Sign'
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
        Name = 'inisSign'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 936
    Top = 251
  end
  object spInsertUpdateMISign_No: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_Sign'
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
        Name = 'inisSign'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 864
    Top = 243
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 740
    Top = 182
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 812
    Top = 177
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_PromoTrade_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintSignCDS
      end>
    OutputType = otMultiDataSet
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
    Left = 735
    Top = 256
  end
  object PrintSignCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 780
    Top = 150
  end
  object spGet_SignPrint: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_PromoTrade_SignByPrint'
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
        Name = 'TextSign'
        Value = Null
        Component = FormParams
        ComponentItem = 'TextSign'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 864
    Top = 136
  end
end
