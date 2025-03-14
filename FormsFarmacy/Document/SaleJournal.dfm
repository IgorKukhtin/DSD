inherited SaleJournalForm: TSaleJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1087#1088#1086#1076#1072#1078
  ClientHeight = 491
  ClientWidth = 747
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.AddOnFormRefresh.SelfList = 'Sale'
  AddOnFormData.AddOnFormRefresh.DataSet = MasterCDS
  AddOnFormData.AddOnFormRefresh.KeyField = 'Id'
  AddOnFormData.AddOnFormRefresh.KeyParam = 'inMovementId'
  AddOnFormData.AddOnFormRefresh.GetStoredProc = spGet_Movement_Sale
  ExplicitWidth = 765
  ExplicitHeight = 538
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 747
    Height = 434
    TabOrder = 3
    ExplicitWidth = 747
    ExplicitHeight = 434
    ClientRectBottom = 434
    ClientRectRight = 747
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 747
      ExplicitHeight = 434
      inherited cxGrid: TcxGrid
        Width = 747
        Height = 434
        ExplicitWidth = 747
        ExplicitHeight = 434
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = TotalSummSale
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = TotalSummPrimeCost
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = UnitName
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = TotalSummSale
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Id: TcxGridDBColumn [0]
            Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088
            DataBinding.FieldName = 'Id'
            Visible = False
          end
          inherited colStatus: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Width = 49
          end
          inherited colInvNumber: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Width = 71
          end
          inherited colOperDate: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Width = 62
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 108
          end
          object JuridicalMainName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalMainName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 102
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 98
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 79
          end
          object TotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'TotalCount'
            PropertiesClassName = 'TcxCalcEditProperties'
            Properties.DisplayFormat = ',0.000'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 46
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object TotalSummSale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'TotalSummSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object TotalSummPrimeCost: TcxGridDBColumn
            AlternateCaption = #1057#1091#1084#1084#1072' '#1089#1077#1073#1077#1089#1090#1086#1080#1084#1086#1089#1090#1080
            Caption = #1057#1091#1084#1084#1072' '#1089#1077#1073'-'#1090#1080
            DataBinding.FieldName = 'TotalSummPrimeCost'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1091#1084#1084#1072' '#1089#1077#1073#1077#1089#1090#1086#1080#1084#1086#1089#1090#1080
          end
          object Comment: TcxGridDBColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentVert = vaCenter
            Width = 147
          end
          object isSP: TcxGridDBColumn
            Caption = #1054#1090#1087#1091#1097#1077#1085#1086' '#1087#1086' '#1087#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1102' '#8470'1303'
            DataBinding.FieldName = 'isSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1087#1091#1097#1077#1085#1086' '#1087#1086' '#1087#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1102' '#8470'1303'
            Width = 99
          end
          object PartnerMedicalName: TcxGridDBColumn
            Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1077' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1077
            DataBinding.FieldName = 'PartnerMedicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 119
          end
          object OperDateSP: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1088#1077#1094#1077#1087#1090#1072
            DataBinding.FieldName = 'OperDateSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InvNumberSP: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' '#1088#1077#1094#1077#1087#1090#1072
            DataBinding.FieldName = 'InvNumberSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object MedicSPName: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1074#1088#1072#1095#1072
            DataBinding.FieldName = 'MedicSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 98
          end
          object MemberSPName: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1087#1072#1094#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'MemberSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 98
          end
          object GroupMemberSPName: TcxGridDBColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1087#1072#1094#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'GroupMemberSPName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object INN_MemberSP: TcxGridDBColumn
            Caption = #1048#1053#1053' '#1087#1072#1094#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'INN_MemberSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Passport_MemberSP: TcxGridDBColumn
            Caption = #1057#1077#1088#1080#1103' '#1080' '#1085#1086#1084#1077#1088' '#1087#1072#1089#1087#1086#1088#1090#1072'  '#1087#1072#1094#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'Passport_MemberSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1077#1088#1080#1103' '#1080' '#1085#1086#1084#1077#1088' '#1087#1072#1089#1087#1086#1088#1090#1072'  '#1087#1072#1094#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 100
          end
          object Address_MemberSP: TcxGridDBColumn
            Caption = #1040#1076#1088#1077#1089' '#1087#1072#1094#1080#1077#1085#1090#1072
            DataBinding.FieldName = 'Address_MemberSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1076#1088#1077#1089' '#1087#1072#1094#1080#1077#1085#1090#1072
            Options.Editing = False
            Width = 108
          end
          object InvNumber_Invoice_Full: TcxGridDBColumn
            Caption = #1057#1095#1077#1090' ('#1087#1086#1089#1090'.1303)'
            DataBinding.FieldName = 'InvNumber_Invoice_Full'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object SPKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1089#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
            DataBinding.FieldName = 'SPKindName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
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
            Width = 80
          end
          object isDeferred: TcxGridDBColumn
            Caption = #1054#1090#1083#1086#1078#1077#1085
            DataBinding.FieldName = 'isDeferred'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object isNP: TcxGridDBColumn
            Caption = #1044#1086#1089#1090#1072#1074#1082#1072' '#1053#1055
            DataBinding.FieldName = 'isNP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object InsuranceCompaniesName: TcxGridDBColumn
            Caption = #1057#1090#1088#1072#1093#1086#1074#1072#1103' '#1082#1086#1084#1087#1072#1085#1080#1103
            DataBinding.FieldName = 'InsuranceCompaniesName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object MemberICName: TcxGridDBColumn
            Caption = #1060#1048#1054' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' ('#1057#1090#1088#1072#1093'. '#1082#1086#1084#1087'.)'
            DataBinding.FieldName = 'MemberICName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 126
          end
          object InsuranceCardNumber: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' '#1089#1090#1088#1072#1093'. '#1082#1072#1088#1090#1099
            DataBinding.FieldName = 'InsuranceCardNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object CashRegisterName: TcxGridDBColumn
            Caption = #1050#1072#1089#1089#1072
            DataBinding.FieldName = 'CashRegisterName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object ZReport: TcxGridDBColumn
            Caption = 'Z '#1086#1090#1095#1077#1090
            DataBinding.FieldName = 'ZReport'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
          object FiscalCheckNumber: TcxGridDBColumn
            Caption = #8470' '#1092#1080#1089#1082'. '#1095#1077#1082#1072
            DataBinding.FieldName = 'FiscalCheckNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object TotalSummPayAdd: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1076#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'TotalSummPayAdd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 747
    ExplicitWidth = 747
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 154
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TSaleForm'
      FormNameParam.Value = 'TSaleForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TSaleForm'
      FormNameParam.Value = 'TSaleForm'
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
    object PrintDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = 'actCheckPrintDialog'
      ImageIndex = 3
      FormName = 'TCheckPrintDialogForm'
      FormNameParam.Value = 'TCheckPrintDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptInputOutput
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inFiscalCheckNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'inFiscalCheckNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBayer'
          Value = Null
          Component = FormParams
          ComponentItem = 'inBayer'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inFiscalCheckNumber'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBayer'
          Value = ''
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
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
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inBayer'
          Value = Null
          Component = FormParams
          ComponentItem = 'inBayer'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'inFiscalCheckNumber'
          Value = Null
          Component = FormParams
          ComponentItem = 'inFiscalCheckNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1050#1086#1087#1080#1103' '#1095#1077#1082#1072' '#1082#1083#1080#1077#1085#1090#1091'('#1087#1088#1086#1076#1072#1078#1072')'
      ReportNameParam.Value = #1050#1086#1087#1080#1103' '#1095#1077#1082#1072' '#1082#1083#1080#1077#1085#1090#1091'('#1087#1088#1086#1076#1072#1078#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object macPrint: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = PrintDialog
        end
        item
          Action = actPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      ImageIndex = 3
    end
    object actInsertInsuranceCompanies: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = '0'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.MultiSelectSeparator = ','
        end>
      BeforeAction = actExecInsert_InsuranceCompanies
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1086#1076#1072#1078#1091' '#1095#1077#1088#1077#1079' '#1089#1090#1088#1072#1093#1086#1074#1091#1102' '#1082#1086#1084#1087#1072#1085#1080#1102
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1086#1076#1072#1078#1091' '#1095#1077#1088#1077#1079' '#1089#1090#1088#1072#1093#1086#1074#1091#1102' '#1082#1086#1084#1087#1072#1085#1080#1102
      ShortCut = 16429
      ImageIndex = 0
      FormName = 'TSaleForm'
      FormNameParam.Value = 'TSaleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
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
      isShowModal = False
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actChoiceInsuranceCompanies: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceInsuranceCompanies'
      FormName = 'TInsuranceCompanies_ObjectForm'
      FormNameParam.Value = 'TInsuranceCompanies_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'InsuranceCompaniesId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = FormParams
          ComponentItem = 'InsuranceCompaniesIName'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChoiceMemberIC: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actChoiceInsuranceCompanies
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceInsuranceCompanies'
      FormName = 'TMemberICForm'
      FormNameParam.Value = 'TMemberICForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'InsuranceCompaniesId'
          Value = Null
          Component = FormParams
          ComponentItem = 'InsuranceCompaniesId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InsuranceCompaniesIName'
          Value = Null
          Component = FormParams
          ComponentItem = 'InsuranceCompaniesIName'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'MemberICID'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actChangePercentDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actChoiceMemberIC
      Caption = 'actChangePercentDialog'
      FormName = 'TSummaDialogForm'
      FormNameParam.Value = 'TSummaDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Summa'
          Value = Null
          Component = FormParams
          ComponentItem = 'ChangePercent'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1042#1074#1077#1076#1080#1090#1077' % '#1089#1082#1080#1076#1082#1080
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actExecInsert_InsuranceCompanies: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actChangePercentDialog
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_InsuranceCompanies
      StoredProcList = <
        item
          StoredProc = spInsert_InsuranceCompanies
        end>
      Caption = 'actExecInsert_InsuranceCompanies'
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale'
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
          ItemName = 'bbInsertInsuranceCompanies'
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
          ItemName = 'bbMovementItemContainer'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbmacPrint'
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
    object bbmacPrint: TdxBarButton
      Action = macPrint
      Category = 0
      ImageIndex = 15
    end
    object bbInsertInsuranceCompanies: TdxBarButton
      Action = actInsertInsuranceCompanies
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 464
    Top = 408
  end
  inherited PopupMenu: TPopupMenu
    Left = 8
    Top = 152
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 472
    Top = 8
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 456
    Top = 8
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_Sale'
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_Sale'
    Left = 384
    Top = 264
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_Sale'
    Left = 384
    Top = 216
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
        Name = 'InsuranceCompaniesId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsuranceCompaniesIName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MemberICID'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercent'
        Value = 100.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 32
    Top = 400
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_Sale'
    Left = 384
    Top = 120
  end
  object spGet_Movement_Sale: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Sale'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = 41640d
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = False
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = Null
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = Null
        DataType = ftString
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
        Name = 'TotalSummPrimeCost'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 168
    Top = 99
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 564
    Top = 169
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 564
    Top = 214
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
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 640
    Top = 208
  end
  object spInsert_InsuranceCompanies: TdsdStoredProc
    StoredProcName = 'gpInsert_Movement_Sale_InsuranceCompanies'
    DataSets = <>
    OutputType = otResult
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
        Name = 'inInsuranceCompaniesId'
        Value = Null
        Component = FormParams
        ComponentItem = 'InsuranceCompaniesId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberICId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MemberICID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChangePercent'
        Value = Null
        Component = FormParams
        ComponentItem = 'ChangePercent'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 384
    Top = 328
  end
end
