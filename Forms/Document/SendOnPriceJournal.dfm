inherited SendOnPriceJournalForm: TSendOnPriceJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1077'>'
  ClientHeight = 535
  ClientWidth = 1020
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1036
  ExplicitHeight = 570
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1020
    Height = 478
    TabOrder = 3
    ExplicitWidth = 1020
    ExplicitHeight = 478
    ClientRectBottom = 478
    ClientRectRight = 1020
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1020
      ExplicitHeight = 478
      inherited cxGrid: TcxGrid
        Width = 1020
        Height = 478
        ExplicitWidth = 1020
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
              Column = colTotalCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalCountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalSummVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalSummMVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalSummPVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalCountTare
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalCountSh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalCountKg
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalCountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalSummVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalSummMVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalSummPVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalCountTare
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalCountSh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalCountKg
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
            Caption = #1044#1072#1090#1072' ('#1088#1072#1089#1093#1086#1076')'
            HeaderAlignmentHorz = taCenter
            Width = 50
          end
          object colOperDatePartner: TcxGridDBColumn [2]
            Caption = #1044#1072#1090#1072' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'OperDatePartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 65
          end
          inherited colInvNumber: TcxGridDBColumn [3]
            Caption = #8470' '#1076#1086#1082'.'
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          object InvNumber_Order: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1079#1072#1103#1074#1082#1072
            DataBinding.FieldName = 'InvNumber_Order'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colFromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object colToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object colTotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'TotalCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colTotalCountPartner: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'TotalCountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colTotalCountTare: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1090#1072#1088#1099' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'TotalCountTare'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colTotalCountSh: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1096#1090'. ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'TotalCountSh'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colTotalCountKg: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1077#1089' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'TotalCountKg'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colTotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colChangePercent: TcxGridDBColumn
            Caption = '(-)% '#1089#1082'. (+)% '#1085#1072#1094
            DataBinding.FieldName = 'ChangePercent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 65
          end
          object colPriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'PriceWithVAT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colVATPercent: TcxGridDBColumn
            Caption = '% '#1053#1044#1057
            DataBinding.FieldName = 'VATPercent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object colTotalSummVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1053#1044#1057
            DataBinding.FieldName = 'TotalSummVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colTotalSummMVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'TotalSummMVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colTotalSummPVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'TotalSummPVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object RetailName_order: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName_order'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object PartnerName_order: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'PartnerName_order'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object RouteGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1084'. / '#1052#1072#1088#1096#1088#1091#1090
            DataBinding.FieldName = 'RouteGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object RouteName: TcxGridDBColumn
            Caption = #1052#1072#1088#1096#1088#1091#1090
            DataBinding.FieldName = 'RouteName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Comment_order: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1079#1072#1103#1074#1082#1072')'
            DataBinding.FieldName = 'Comment_order'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object PersonalName: TcxGridDBColumn
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1101#1082#1089#1087#1077#1076#1080#1090#1086#1088')'
            DataBinding.FieldName = 'PersonalName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object EdiInvoice: TcxGridDBColumn
            Caption = 'EDI - '#1057#1095#1077#1090
            DataBinding.FieldName = 'EdiInvoice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object isEdiInvoice_partner: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' - '#1057#1095#1077#1090
            DataBinding.FieldName = 'isEdiInvoice_partner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object EdiOrdspr: TcxGridDBColumn
            Caption = 'EDI - '#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077
            DataBinding.FieldName = 'EdiOrdspr'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object isEdiOrdspr_partner: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' - '#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077
            DataBinding.FieldName = 'isEdiOrdspr_partner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object EdiDesadv: TcxGridDBColumn
            Caption = 'EDI - '#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'EdiDesadv'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object isEdiDesadv_partner: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' - '#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'isEdiDesadv_partner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1020
    ExplicitWidth = 1020
    inherited deStart: TcxDateEdit
      EditValue = 42005d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42005d
    end
    object edIsPartnerDate: TcxCheckBox
      Left = 427
      Top = 5
      Action = actRefresh
      Caption = #1055#1077#1088#1080#1086#1076' '#1076#1083#1103' <'#1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      TabOrder = 4
      Width = 262
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 179
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 267
  end
  inherited ActionList: TActionList
    Left = 31
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TSendOnPriceForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
        end
        item
          Name = 'ShowAll'
          Value = True
          DataType = ftBoolean
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'inChangePercentAmount'
          Value = Null
          Component = FormParams
          ComponentItem = 'inChangePercentAmount'
          DataType = ftFloat
        end>
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TSendOnPriceForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'inChangePercentAmount'
          Value = Null
          Component = FormParams
          ComponentItem = 'inChangePercentAmount'
          DataType = ftFloat
          ParamType = ptInput
        end>
    end
    object actInvoice: TEDIAction [12]
      Category = 'EDI'
      MoveParams = <>
      StartDateParam.Value = Null
      EndDateParam.Value = Null
      EDI = EDI
      EDIDocType = ediInvoice
      HeaderDataSet = PrintHeaderCDS
      ListDataSet = PrintItemsCDS
    end
    object actPrintOut: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'Id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'Id'
          ToParam.Name = 'Id'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
        end
        item
          FromParam.Name = 'ReportType'
          FromParam.Value = 0
          ToParam.Name = 'ReportType'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'ReportType'
        end>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1088#1072#1089#1093#1086#1076')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1088#1072#1089#1093#1086#1076')'
      ImageIndex = 19
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
        end>
      ReportName = 'PrintMovement_SendOnPrice'
      ReportNameParam.Value = 'PrintMovement_SendOnPrice'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'Id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'Id'
          ToParam.Name = 'Id'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
        end
        item
          FromParam.Name = 'ReportType'
          FromParam.Value = 1
          ToParam.Name = 'ReportType'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'ReportType'
        end>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1087#1088#1080#1093#1086#1076')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1087#1088#1080#1093#1086#1076')'
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
        end>
      ReportName = 'PrintMovement_SendOnPrice'
      ReportNameParam.Name = #1055#1088#1080#1093#1086#1076
      ReportNameParam.Value = 'PrintMovement_SendOnPrice'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
    end
    object actOrdSpr: TEDIAction
      Category = 'EDI'
      MoveParams = <>
      StartDateParam.Value = Null
      EndDateParam.Value = Null
      EDI = EDI
      EDIDocType = ediOrdrsp
      HeaderDataSet = PrintHeaderCDS
      ListDataSet = PrintItemsCDS
    end
    object actDesadv: TEDIAction
      Category = 'EDI'
      MoveParams = <>
      StartDateParam.Value = Null
      EndDateParam.Value = Null
      EDI = EDI
      EDIDocType = ediDesadv
      HeaderDataSet = PrintHeaderCDS
      ListDataSet = PrintItemsCDS
    end
    object actUpdateEdiDesadvTrue: TdsdExecStoredProc
      Category = 'EDI'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateEdiDesadv
      StoredProcList = <
        item
          StoredProc = spUpdateEdiDesadv
        end>
      Caption = 'actUpdateEdiDesadvTrue'
    end
    object actUpdateEdiInvoiceTrue: TdsdExecStoredProc
      Category = 'EDI'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateEdiInvoice
      StoredProcList = <
        item
          StoredProc = spUpdateEdiInvoice
        end>
      Caption = 'actUpdateEdiInvoiceTrue'
    end
    object actUpdateEdiOrdsprTrue: TdsdExecStoredProc
      Category = 'EDI'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateEdiOrdspr
      StoredProcList = <
        item
          StoredProc = spUpdateEdiOrdspr
        end>
      Caption = 'actUpdateEdiOrdsprTrue'
    end
    object actSetDefaults: TdsdExecStoredProc
      Category = 'EDI'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetDefaultEDI
      StoredProcList = <
        item
          StoredProc = spGetDefaultEDI
        end>
      Caption = 'actSetDefaults'
    end
    object mactInvoice: TMultiAction
      Category = 'EDI'
      MoveParams = <
        item
          FromParam.Name = 'Id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'Id'
          ToParam.Name = 'Id'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
        end>
      ActionList = <
        item
          Action = actSetDefaults
        end
        item
          Action = actExecPrint_EDI
        end
        item
          Action = actInvoice
        end
        item
          Action = actUpdateEdiInvoiceTrue
        end>
      QuestionBeforeExecute = 'EXITE <'#1057#1095#1077#1090' - Invoice>.'#1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100'?'
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1057#1095#1077#1090' - Invoice> '#1086#1090#1087#1088#1072#1074#1083#1077#1085' '#1091#1089#1087#1077#1096#1085#1086' '#1074' EXITE.'
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' <'#1057#1095#1077#1090' - Invoice>'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' <'#1057#1095#1077#1090' - Invoice>'
      ImageIndex = 47
    end
    object mactOrdSpr: TMultiAction
      Category = 'EDI'
      MoveParams = <
        item
          FromParam.Name = 'Id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'Id'
          ToParam.Name = 'Id'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
        end>
      ActionList = <
        item
          Action = actSetDefaults
        end
        item
          Action = actExecPrint_EDI
        end
        item
          Action = actOrdSpr
        end
        item
          Action = actUpdateEdiOrdsprTrue
        end>
      QuestionBeforeExecute = 'EXITE <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' - Ordspr>.'#1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100'?'
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' - Ordspr> '#1086#1090#1087#1088#1072#1074#1083#1077#1085' '#1091#1089#1087#1077#1096#1085#1086' '#1074' EXITE.'
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' - Ordspr>'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' - Ordspr>'
      ImageIndex = 48
    end
    object mactDesadv: TMultiAction
      Category = 'EDI'
      MoveParams = <
        item
          FromParam.Name = 'Id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'Id'
          ToParam.Name = 'Id'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
        end>
      ActionList = <
        item
          Action = actSetDefaults
        end
        item
          Action = actExecPrint_EDI
        end
        item
          Action = actDesadv
        end
        item
          Action = actUpdateEdiDesadvTrue
        end>
      QuestionBeforeExecute = 'EXITE <'#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' - Desadv>.'#1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100'?'
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' - Desadv> '#1086#1090#1087#1088#1072#1074#1083#1077#1085' '#1091#1089#1087#1077#1096#1085#1086' '#1074' EXITE.'
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' <'#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' - Desadv>'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' <'#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' - Desadv>'
      ImageIndex = 49
    end
    object actExecPrint_EDI: TdsdExecStoredProc
      Category = 'EDI'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectSale_EDI
      StoredProcList = <
        item
          StoredProc = spSelectSale_EDI
        end>
      Caption = 'actExecPrint_EDI'
    end
    object mactInvoice_Simple: TMultiAction
      Category = 'EDI'
      MoveParams = <
        item
          FromParam.Name = 'Id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'Id'
          ToParam.Name = 'Id'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
        end>
      ActionList = <
        item
          Action = actSetDefaults
        end
        item
          Action = actExecPrint_EDI
        end
        item
          Action = actInvoice
        end
        item
          Action = actUpdateEdiInvoiceTrue
        end>
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1074#1089#1077' <'#1057#1095#1077#1090#1072' - Invoice>'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1074#1089#1077' <'#1057#1095#1077#1090#1072' - Invoice>'
      ImageIndex = 47
    end
    object mactInvoice_All: TMultiAction
      Category = 'EDI'
      MoveParams = <>
      ActionList = <
        item
          Action = mactInvoice_Simple
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = 'EXITE <'#1057#1095#1077#1090' - Invoice>.'#1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1042#1089#1077' '#1089#1095#1077#1090#1072'?'
      InfoAfterExecute = #1042#1089#1077'  '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1057#1095#1077#1090' - Invoice> '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1099' '#1091#1089#1087#1077#1096#1085#1086' '#1074' EXITE.'
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1042#1089#1077' <'#1057#1095#1077#1090' - Invoice>'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1042#1089#1077' <'#1057#1095#1077#1090' - Invoice>'
      ImageIndex = 47
    end
    object mactOrdSpr_Simple: TMultiAction
      Category = 'EDI'
      MoveParams = <
        item
          FromParam.Name = 'Id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'Id'
          ToParam.Name = 'Id'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
        end>
      ActionList = <
        item
          Action = actSetDefaults
        end
        item
          Action = actExecPrint_EDI
        end
        item
          Action = actOrdSpr
        end
        item
          Action = actUpdateEdiOrdsprTrue
        end>
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' - Ordspr>'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' - Ordspr>'
      ImageIndex = 48
    end
    object mactOrdSpr_All: TMultiAction
      Category = 'EDI'
      MoveParams = <>
      ActionList = <
        item
          Action = mactOrdSpr_Simple
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = 
        'EXITE <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' - Ordspr>. '#1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1042#1089#1077' '#1087#1086#1076#1090 +
        #1074#1077#1088#1078#1076#1077#1085#1080#1103'?'
      InfoAfterExecute = 
        #1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' - Ordspr> '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1099' '#1091#1089#1087#1077#1096#1085#1086' '#1074' EXIT' +
        'E.'
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1042#1089#1077'  <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' - Ordspr>'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1042#1089#1077'  <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' - Ordspr>'
      ImageIndex = 48
    end
    object mactDesadv_Simple: TMultiAction
      Category = 'EDI'
      MoveParams = <
        item
          FromParam.Name = 'Id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'Id'
          ToParam.Name = 'Id'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
        end>
      ActionList = <
        item
          Action = actSetDefaults
        end
        item
          Action = actExecPrint_EDI
        end
        item
          Action = actDesadv
        end
        item
          Action = actUpdateEdiDesadvTrue
        end>
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' <'#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' - Desadv>'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' <'#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' - Desadv>'
      ImageIndex = 49
    end
    object mactDesadv_All: TMultiAction
      Category = 'EDI'
      MoveParams = <>
      ActionList = <
        item
          Action = mactDesadv_Simple
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = 
        'EXITE<'#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' - Desadv>. '#1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1042#1089#1077' '#1091#1074#1077#1076#1086#1084#1083 +
        #1077#1085#1080#1103'?'
      InfoAfterExecute = #1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' - Desadv> '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1099' '#1091#1089#1087#1077#1096#1085#1086' '#1074' EXITE.'
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1042#1089#1077'  <'#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' - Desadv>'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1042#1089#1077'  <'#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' - Desadv>'
      ImageIndex = 49
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
    StoredProcName = 'gpSelect_Movement_SendOnPrice'
    Params = <
      item
        Name = 'instartdate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inenddate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inIsPartnerDate'
        Value = 'False'
        Component = edIsPartnerDate
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
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
          ItemName = 'bbPrintOut'
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
          ItemName = 'bbInvoice'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOrdSpr'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbtDesadv'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbPrintOut: TdxBarButton
      Action = actPrintOut
      Category = 0
    end
    object bbInvoice: TdxBarButton
      Action = mactInvoice
      Category = 0
    end
    object bbOrdSpr: TdxBarButton
      Action = mactOrdSpr
      Category = 0
    end
    object bbtDesadv: TdxBarButton
      Action = mactDesadv
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
    object Invoice1: TMenuItem [3]
      Action = mactInvoice_All
    end
    object Ordspr1: TMenuItem [4]
      Action = mactOrdSpr_All
    end
    object Desadv1: TMenuItem [5]
      Action = mactDesadv_All
    end
    inherited N9: TMenuItem [6]
    end
    inherited N5: TMenuItem [7]
    end
    inherited N7: TMenuItem [8]
    end
    inherited N8: TMenuItem [9]
    end
    object N13: TMenuItem [10]
      Caption = '-'
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
        Component = edIsPartnerDate
      end>
    Left = 408
    Top = 344
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_SendOnPrice'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inislastcomplete'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
      end>
    Left = 80
    Top = 320
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_SendOnPrice'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 80
    Top = 384
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_SendOnPrice'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
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
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ShowAll'
        Value = False
        DataType = ftBoolean
        ParamType = ptInputOutput
      end
      item
        Name = 'ReportNameSendOnPrice'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ReportNameSendOnPriceTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inChangePercentAmount'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
      end>
    Left = 400
    Top = 200
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_SendOnPrice'
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 596
    Top = 217
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 596
    Top = 278
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_SendOnPrice_Print'
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
      end
      item
        Name = 'inReportType'
        Value = '1'
        Component = FormParams
        ComponentItem = 'ReportType'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 487
    Top = 384
  end
  object spUpdateEdiOrdspr: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_Edi'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inDescCode'
        Value = 'zc_MovementBoolean_EdiOrdspr'
        DataType = ftString
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 768
    Top = 176
  end
  object spUpdateEdiInvoice: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_Edi'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inDescCode'
        Value = 'zc_MovementBoolean_EdiInvoice'
        DataType = ftString
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 832
    Top = 152
  end
  object spUpdateEdiDesadv: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_Edi'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inDescCode'
        Value = 'zc_MovementBoolean_EdiDesadv'
        DataType = ftString
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 896
    Top = 176
  end
  object EDI: TEDI
    ConnectionParams.Host.Value = Null
    ConnectionParams.Host.Component = FormParams
    ConnectionParams.Host.ComponentItem = 'Host'
    ConnectionParams.Host.DataType = ftString
    ConnectionParams.User.Value = Null
    ConnectionParams.User.Component = FormParams
    ConnectionParams.User.ComponentItem = 'UserName'
    ConnectionParams.User.DataType = ftString
    ConnectionParams.Password.Value = Null
    ConnectionParams.Password.Component = FormParams
    ConnectionParams.Password.ComponentItem = 'Password'
    ConnectionParams.Password.DataType = ftString
    Left = 824
    Top = 208
  end
  object spGetDefaultEDI: TdsdStoredProc
    StoredProcName = 'gpGetDefaultEDI'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Host'
        Value = Null
        Component = FormParams
        ComponentItem = 'Host'
        DataType = ftString
      end
      item
        Name = 'UserName'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserName'
        DataType = ftString
      end
      item
        Name = 'Password'
        Value = Null
        Component = FormParams
        ComponentItem = 'Password'
        DataType = ftString
      end>
    PackSize = 1
    Left = 872
    Top = 240
  end
  object spSelectSale_EDI: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_EDI'
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
      end>
    PackSize = 1
    Left = 832
    Top = 281
  end
end
