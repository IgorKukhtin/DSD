inherited Report_JuridicalCollationForm: TReport_JuridicalCollationForm
  Caption = #1054#1090#1095#1077#1090' <'#1040#1082#1090' '#1089#1074#1077#1088#1082#1080'>'
  ClientHeight = 389
  ClientWidth = 893
  ExplicitWidth = 909
  ExplicitHeight = 427
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 77
    Width = 893
    Height = 312
    TabOrder = 3
    ExplicitTop = 57
    ExplicitWidth = 893
    ExplicitHeight = 332
    ClientRectBottom = 312
    ClientRectRight = 893
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 893
      ExplicitHeight = 332
      inherited cxGrid: TcxGrid
        Width = 893
        Height = 312
        ExplicitWidth = 893
        ExplicitHeight = 332
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colDebet
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colKredit
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colStartRemains
            end
            item
              Format = ',0.00##'
              Kind = skSum
              Column = colEndRemains
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.FooterMultiSummaries = True
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colItemName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'.'
            DataBinding.FieldName = 'ItemName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object coInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colInvNumberPartner: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'#1091' '#1087#1072#1088#1090#1085#1077#1088#1072
            DataBinding.FieldName = 'InvNumberPartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colStartRemains: TcxGridDBColumn
            Caption = #1053#1072#1095'. '#1076#1086#1083#1075
            DataBinding.FieldName = 'StartRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colDebet: TcxGridDBColumn
            Caption = #1044#1077#1073#1077#1090' ('#1054#1087#1083#1072#1090#1072')'
            DataBinding.FieldName = 'Debet'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colKredit: TcxGridDBColumn
            Caption = #1050#1088#1077#1076#1080#1090' ('#1055#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'Kredit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colEndRemains: TcxGridDBColumn
            Caption = #1050#1086#1085'. '#1076#1086#1083#1075
            DataBinding.FieldName = 'EndRemains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colFromName: TcxGridDBColumn
            Caption = #1054#1090' '#1050#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object colToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object colOperationSort: TcxGridDBColumn
            Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072
            DataBinding.FieldName = 'OperationSort'
            Visible = False
            Options.Editing = False
            VisibleForCustomization = False
            Width = 55
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 893
    Height = 51
    ExplicitWidth = 893
    ExplicitHeight = 51
    inherited deStart: TcxDateEdit
      Left = 118
      EditValue = 41640d
      Properties.SaveTime = False
      ExplicitLeft = 118
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 25
      EditValue = 41640d
      Properties.SaveTime = False
      ExplicitLeft = 118
      ExplicitTop = 25
    end
    inherited cxLabel1: TcxLabel
      Left = 25
      ExplicitLeft = 25
    end
    inherited cxLabel2: TcxLabel
      Left = 6
      Top = 26
      ExplicitLeft = 6
      ExplicitTop = 26
    end
    object cxLabel6: TcxLabel
      Left = 231
      Top = 6
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086' ('#1082#1083#1080#1077#1085#1090'):'
    end
    object edJuridical: TcxButtonEdit
      Left = 386
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 210
    end
    object edJuridicalBasis: TcxButtonEdit
      Left = 386
      Top = 25
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 210
    end
    object cxLabel3: TcxLabel
      Left = 231
      Top = 26
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086' ('#1085#1072#1096#1077'):'
    end
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
        Component = JuridicalBasisGuide
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = JuridicalGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
    Left = 208
    Top = 272
  end
  inherited ActionList: TActionList
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormName = 'NULL'
      FormNameParam.Value = Null
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
        end
        item
          Name = 'inOperDate'
          Value = 'NULL'
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
        end>
      isShowModal = False
    end
    object actGetForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementForm
      StoredProcList = <
        item
          StoredProc = getMovementForm
        end>
      Caption = 'actGetForm'
    end
    object actOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetForm
        end
        item
          Action = actOpenForm
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 28
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spJuridicalBalance
      StoredProcList = <
        item
          StoredProc = spJuridicalBalance
        end>
      Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080
      Hint = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080
      ImageIndex = 3
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDataset'
          IndexFieldNames = 'ItemName;OperDate;InvNumber'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'AccountName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'PaidKindName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'StartBalance'
          Value = Null
          Component = FormParams
          ComponentItem = 'StartBalance'
          DataType = ftFloat
          ParamType = ptInput
        end
        item
          Name = 'StartBalanceCurrency'
          Value = Null
          Component = FormParams
          ComponentItem = 'StartBalanceCurrency'
          DataType = ftFloat
          ParamType = ptInput
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = FormParams
          ComponentItem = 'JuridicalName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'JuridicalShortName'
          Value = Null
          Component = FormParams
          ComponentItem = 'JuridicalShortName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'PartnerName'
          Value = ''
          Component = FormParams
          ComponentItem = 'PartnerName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'CurrencyName'
          Value = Null
          Component = FormParams
          ComponentItem = 'CurrencyName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'AccounterName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccounterName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'ContracNumber'
          Value = ''
          Component = FormParams
          ComponentItem = 'ContracNumber'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'ContractTagName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ContractTagName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'ContractSigningDate'
          Value = 'NULL'
          Component = FormParams
          ComponentItem = 'ContractSigningDate'
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'JuridicalName_Basis'
          Value = ''
          Component = FormParams
          ComponentItem = 'JuridicalName_Basis'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'JuridicalShortName_Basis'
          Value = Null
          Component = FormParams
          ComponentItem = 'JuridicalShortName_Basis'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'AccounterName_Basis'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccounterName_Basis'
          DataType = ftString
          ParamType = ptInput
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' ('#1040#1082#1090' '#1089#1074#1077#1088#1082#1080')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' ('#1040#1082#1090' '#1089#1074#1077#1088#1082#1080')'
      ReportNameParam.DataType = ftString
    end
    object actPrintOfficial: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spJuridicalBalance
      StoredProcList = <
        item
          StoredProc = spJuridicalBalance
        end>
      Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' ('#1073#1091#1093#1075#1072#1083#1090#1077#1088#1089#1082#1080#1081')'
      Hint = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' ('#1073#1091#1093#1075#1072#1083#1090#1077#1088#1089#1082#1080#1081')'
      ImageIndex = 17
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDataset'
          IndexFieldNames = 'OperDate;ItemName;InvNumber'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'AccountName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'PaidKindName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'StartBalance'
          Value = Null
          Component = FormParams
          ComponentItem = 'StartBalance'
          DataType = ftFloat
          ParamType = ptInput
        end
        item
          Name = 'StartBalanceCurrency'
          Value = Null
          Component = FormParams
          ComponentItem = 'StartBalanceCurrency'
          DataType = ftFloat
          ParamType = ptInput
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = FormParams
          ComponentItem = 'JuridicalName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'JuridicalShortName'
          Value = Null
          Component = FormParams
          ComponentItem = 'JuridicalShortName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'PartnerName'
          Value = ''
          Component = FormParams
          ComponentItem = 'PartnerName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'CurrencyName'
          Value = Null
          Component = FormParams
          ComponentItem = 'CurrencyName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'AccounterName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccounterName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'ContracNumber'
          Value = ''
          Component = FormParams
          ComponentItem = 'ContracNumber'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'ContractTagName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ContractTagName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'ContractSigningDate'
          Value = 'NULL'
          Component = FormParams
          ComponentItem = 'ContractSigningDate'
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'JuridicalName_Basis'
          Value = ''
          Component = FormParams
          ComponentItem = 'JuridicalName_Basis'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'JuridicalShortName_Basis'
          Value = Null
          Component = FormParams
          ComponentItem = 'JuridicalShortName_Basis'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'AccounterName_Basis'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccounterName_Basis'
          DataType = ftString
          ParamType = ptInput
        end>
      ReportName = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' ('#1073#1091#1093#1075#1072#1083#1090#1077#1088#1089#1082#1080#1081')'
      ReportNameParam.Value = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' ('#1073#1091#1093#1075#1072#1083#1090#1077#1088#1089#1082#1080#1081')'
      ReportNameParam.DataType = ftString
    end
    object actPrintCurrency: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spJuridicalBalance
      StoredProcList = <
        item
          StoredProc = spJuridicalBalance
        end>
      Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' ('#1074' '#1074#1072#1083#1102#1090#1077')'
      Hint = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' ('#1074' '#1074#1072#1083#1102#1090#1077')'
      ImageIndex = 21
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDataset'
          IndexFieldNames = 'OperDate;ItemName;InvNumber'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'AccountName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'PaidKindName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'StartBalance'
          Value = Null
          Component = FormParams
          ComponentItem = 'StartBalance'
          DataType = ftFloat
          ParamType = ptInput
        end
        item
          Name = 'StartBalanceCurrency'
          Value = Null
          Component = FormParams
          ComponentItem = 'StartBalanceCurrency'
          DataType = ftFloat
          ParamType = ptInput
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = FormParams
          ComponentItem = 'JuridicalName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'JuridicalShortName'
          Value = Null
          Component = FormParams
          ComponentItem = 'JuridicalShortName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'PartnerName'
          Value = ''
          Component = FormParams
          ComponentItem = 'PartnerName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'CurrencyName'
          Value = Null
          Component = FormParams
          ComponentItem = 'CurrencyName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'InternalCurrencyName'
          Value = Null
          Component = FormParams
          ComponentItem = 'InternalCurrencyName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'AccounterName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccounterName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'ContracNumber'
          Value = ''
          Component = FormParams
          ComponentItem = 'ContracNumber'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'ContractTagName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ContractTagName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'ContractSigningDate'
          Value = 'NULL'
          Component = FormParams
          ComponentItem = 'ContractSigningDate'
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'JuridicalName_Basis'
          Value = ''
          Component = FormParams
          ComponentItem = 'JuridicalName_Basis'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'JuridicalShortName_Basis'
          Value = Null
          Component = FormParams
          ComponentItem = 'JuridicalShortName_Basis'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'AccounterName_Basis'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccounterName_Basis'
          DataType = ftString
          ParamType = ptInput
        end>
      ReportName = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' ('#1074' '#1074#1072#1083#1102#1090#1077')'
      ReportNameParam.Value = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' ('#1074' '#1074#1072#1083#1102#1090#1077')'
      ReportNameParam.DataType = ftString
    end
    object actPrintTurnover: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1073#1086#1088#1086#1090#1099' '
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1073#1086#1088#1086#1090#1072#1084
      ImageIndex = 20
      DataSets = <
        item
          UserName = 'DataSet'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'AccountName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'PaidKindName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'StartBalance'
          Value = Null
          Component = FormParams
          ComponentItem = 'StartBalance'
          DataType = ftFloat
          ParamType = ptInput
        end
        item
          Name = 'StartBalanceCurrency'
          Value = Null
          Component = FormParams
          ComponentItem = 'StartBalanceCurrency'
          DataType = ftFloat
          ParamType = ptInput
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = FormParams
          ComponentItem = 'JuridicalName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'JuridicalShortName'
          Value = Null
          Component = FormParams
          ComponentItem = 'JuridicalShortName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'PartnerName'
          Value = ''
          Component = FormParams
          ComponentItem = 'PartnerName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'CurrencyName'
          Value = Null
          Component = FormParams
          ComponentItem = 'CurrencyName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'AccounterName'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccounterName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'ContracNumber'
          Value = ''
          Component = FormParams
          ComponentItem = 'ContracNumber'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'ContractTagName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ContractTagName'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'ContractSigningDate'
          Value = 'NULL'
          Component = FormParams
          ComponentItem = 'ContractSigningDate'
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'JuridicalName_Basis'
          Value = ''
          Component = FormParams
          ComponentItem = 'JuridicalName_Basis'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'JuridicalShortName_Basis'
          Value = Null
          Component = FormParams
          ComponentItem = 'JuridicalShortName_Basis'
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'AccounterName_Basis'
          Value = Null
          Component = FormParams
          ComponentItem = 'AccounterName_Basis'
          DataType = ftString
          ParamType = ptInput
        end>
      ReportName = #1054#1073#1086#1088#1086#1090#1099' '#1080#1079' '#1072#1082#1090#1072' '#1089#1074#1077#1088#1082#1080
      ReportNameParam.Value = #1054#1073#1086#1088#1086#1090#1099' '#1080#1079' '#1072#1082#1090#1072' '#1089#1074#1077#1088#1082#1080
      ReportNameParam.DataType = ftString
    end
  end
  inherited MasterDS: TDataSource
    Top = 164
  end
  inherited MasterCDS: TClientDataSet
    IndexFieldNames = 'OperationSort;ItemName;OperDate'
    Top = 132
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_JuridicalCollation'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inJuridical_BasisId'
        Value = Null
        Component = JuridicalBasisGuide
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 184
    Top = 196
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 132
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenDocument'
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
          ItemName = 'bbPrintOfficial'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintCurrency'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintTurnover'
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
    object bbOpenDocument: TdxBarButton
      Action = actOpenDocument
      Category = 0
    end
    object bbPrintOfficial: TdxBarButton
      Action = actPrintOfficial
      Category = 0
      Visible = ivNever
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
      Visible = ivNever
    end
    object bbPrintTurnover: TdxBarButton
      Action = actPrintTurnover
      Category = 0
      Visible = ivNever
    end
    object bbPrintCurrency: TdxBarButton
      Action = actPrintCurrency
      Category = 0
      Visible = ivNever
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actOpenDocument
      end>
    ActionItemList = <
      item
        Action = actOpenDocument
        ShortCut = 13
      end>
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 24
    Top = 196
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = JuridicalGuides
      end
      item
        Component = JuridicalBasisGuide
      end>
    Left = 408
    Top = 72
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 624
  end
  object getMovementForm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
      end
      item
        Name = 'FormName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormName'
        DataType = ftString
      end>
    PackSize = 1
    Left = 296
    Top = 120
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'FormName'
        Value = Null
        DataType = ftString
      end>
    Left = 192
    Top = 144
  end
  object spJuridicalBalance: TdsdStoredProc
    StoredProcName = 'gpReport_JuridicalBalance'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'outStartBalance'
        Value = Null
        Component = FormParams
        ComponentItem = 'StartBalance'
        DataType = ftFloat
      end
      item
        Name = 'outStartBalanceCurrency'
        Value = Null
        Component = FormParams
        ComponentItem = 'StartBalanceCurrency'
        DataType = ftFloat
      end
      item
        Name = 'outJuridicalName'
        Value = Null
        Component = FormParams
        ComponentItem = 'JuridicalName'
        DataType = ftString
      end
      item
        Name = 'outJuridicalShortName'
        Value = Null
        Component = FormParams
        ComponentItem = 'JuridicalShortName'
        DataType = ftString
      end
      item
        Name = 'outJuridicalName_Basis'
        Value = Null
        Component = FormParams
        ComponentItem = 'JuridicalName_Basis'
        DataType = ftString
      end
      item
        Name = 'outJuridicalShortName_Basis'
        Value = Null
        Component = FormParams
        ComponentItem = 'JuridicalShortName_Basis'
        DataType = ftString
      end>
    PackSize = 1
    Left = 296
    Top = 240
  end
  object JuridicalBasisGuide: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridicalBasis
    FormNameParam.Value = 'TJuridicalCorporateForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridicalCorporateForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalBasisGuide
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalBasisGuide
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 688
    Top = 16
  end
end
