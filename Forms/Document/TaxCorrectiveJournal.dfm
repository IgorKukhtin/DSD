inherited TaxCorrectiveJournalForm: TTaxCorrectiveJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081'>'
  ClientHeight = 535
  ClientWidth = 1118
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog1
  ExplicitWidth = 1134
  ExplicitHeight = 573
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 76
    Width = 1118
    Height = 459
    TabOrder = 3
    ExplicitTop = 76
    ExplicitWidth = 1118
    ExplicitHeight = 459
    ClientRectBottom = 459
    ClientRectRight = 1118
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1118
      ExplicitHeight = 459
      inherited cxGrid: TcxGrid
        Width = 1118
        Height = 459
        ExplicitWidth = 1118
        ExplicitHeight = 459
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
          object colIsError: TcxGridDBColumn [1]
            Caption = #1054#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'isError'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colBranchName: TcxGridDBColumn [2]
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          inherited colOperDate: TcxGridDBColumn [3]
            HeaderAlignmentHorz = taCenter
            Width = 50
          end
          inherited colInvNumber: TcxGridDBColumn [4]
            Caption = #8470' '#1076#1086#1082'.'
            Visible = False
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          object colInvNumberPartner: TcxGridDBColumn
            Caption = #8470' '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'InvNumberPartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colInvNumber_Master: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'#1074#1086#1079#1074#1088'.'
            DataBinding.FieldName = 'InvNumber_Master'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 89
          end
          object colInvNumberPartner_Master: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'#1074#1086#1079#1074#1088'.'#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'InvNumberPartner_Master'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colInvNumberPartner_Child: TcxGridDBColumn
            Caption = #8470' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'InvNumberPartner_Child'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colOperDate_Child: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'OperDate_Child'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colTaxKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
            DataBinding.FieldName = 'TaxKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colPartnerCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
            DataBinding.FieldName = 'PartnerCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object colPartnerName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'PartnerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colOKPO_From: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO_From'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object colINN_From: TcxGridDBColumn
            Caption = #1048#1053#1053
            DataBinding.FieldName = 'INN_From'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
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
            Caption = #1050#1086#1083'-'#1074#1086' ('#1091' '#1087#1086#1082#1091#1087'.)'
            DataBinding.FieldName = 'TotalCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
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
          object colPriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'PriceWithVAT'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colVATPercent: TcxGridDBColumn
            Caption = '% '#1053#1044#1057
            DataBinding.FieldName = 'VATPercent'
            Visible = False
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
          object colContractCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colContractName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colInfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object colInfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colInfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colInfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colInvNumberBranch: TcxGridDBColumn
            Caption = #8470' '#1092#1080#1083#1080#1072#1083#1072
            DataBinding.FieldName = 'InvNumberBranch'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colDateRegistered: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1088#1077#1075#1080#1089#1090#1088'.'
            DataBinding.FieldName = 'DateRegistered'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object colChecked: TcxGridDBColumn
            Caption = #1055#1088#1086#1074#1077#1088#1077#1085
            DataBinding.FieldName = 'Checked'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object colDocument: TcxGridDBColumn
            Caption = #1055#1086#1076#1087#1080#1089#1072#1085
            DataBinding.FieldName = 'Document'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object colIsEDI: TcxGridDBColumn
            Caption = 'EXITE'
            DataBinding.FieldName = 'isEDI'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 30
          end
          object colIsElectron: TcxGridDBColumn
            Caption = #1069#1083#1077#1082#1090#1088'.'
            DataBinding.FieldName = 'isElectron'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 30
          end
          object colIsMedoc: TcxGridDBColumn
            Caption = #1052#1077#1076#1086#1082
            DataBinding.FieldName = 'IsMedoc'
            HeaderAlignmentVert = vaCenter
            Width = 46
          end
          object DocumentValue: TcxGridDBColumn
            DataBinding.FieldName = 'DocumentValue'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          object colInvNumberRegistered: TcxGridDBColumn
            Caption = #8470' '#1074' '#1044#1055#1040
            DataBinding.FieldName = 'InvNumberRegistered'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
          end
          object isCopy: TcxGridDBColumn
            Caption = #1050#1086#1087#1080#1103' '#1080#1079' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'isCopy'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colPersonalSigningName: TcxGridDBColumn
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1087#1086#1076#1087#1080#1089#1072#1085#1090')'
            DataBinding.FieldName = 'PersonalSigningName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object DateRegistered_notNull: TcxGridDBColumn
            DataBinding.FieldName = 'DateRegistered_notNull'
            Visible = False
            VisibleForCustomization = False
          end
          object colisPartner: TcxGridDBColumn
            Caption = #1040#1082#1090' '#1085#1077#1076#1086#1074#1086#1079#1072
            DataBinding.FieldName = 'isPartner'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1118
    Height = 50
    ExplicitWidth = 1118
    ExplicitHeight = 50
    inherited deStart: TcxDateEdit
      EditValue = 42370d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42370d
    end
    object edIsRegisterDate: TcxCheckBox
      Left = 10
      Top = 27
      Action = actRefresh
      Caption = #1055#1077#1088#1080#1086#1076' '#1087#1086' <'#1044#1072#1090#1072' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080'>'
      TabOrder = 4
      Width = 262
    end
    object cxTextEdit1: TcxTextEdit
      Left = 417
      Top = 5
      Enabled = False
      ParentColor = True
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Style.BorderStyle = ebsNone
      TabOrder = 6
      Text = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1079#1072' '
      Width = 113
    end
    object edLoadData: TcxDateEdit
      Left = 652
      Top = 5
      EditValue = 42121.4513888889d
      Enabled = False
      ParentColor = True
      Style.BorderStyle = ebsNone
      TabOrder = 8
      Width = 135
    end
    object edPeriod: TcxDateEdit
      Left = 531
      Top = 5
      EditValue = 42121d
      Enabled = False
      ParentColor = True
      Properties.DisplayFormat = 'mmmm yyyy'
      Style.BorderStyle = ebsNone
      TabOrder = 5
      Width = 91
    end
    object cxTextEdit2: TcxTextEdit
      Left = 618
      Top = 5
      Enabled = False
      ParentColor = True
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Style.BorderStyle = ebsNone
      TabOrder = 7
      Text = #1073#1099#1083#1072
      Width = 34
    end
    object cxLabel27: TcxLabel
      Left = 862
      Top = 6
      Caption = #1043#1083#1072#1074#1085#1086#1077' '#1102#1088'. '#1083#1080#1094#1086':'
    end
    object edJuridicalBasis: TcxButtonEdit
      Left = 963
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 155
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 179
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 24
    Top = 211
  end
  inherited ActionList: TActionList
    Left = 47
    Top = 266
    object MedocCorrectiveActionList: TMedocCorrectiveAction [0]
      Category = 'TaxLib'
      MoveParams = <>
      Caption = 'MedocCorrectiveActionList'
      HeaderDataSet = PrintItemsCDS
      ItemsDataSet = PrintItemsCDS
      AskFilePath = False
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spGetInfo
        end>
    end
    object actMedocFalse: TdsdExecStoredProc [2]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMedoc_False
      StoredProcList = <
        item
          StoredProc = spMedoc_False
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1052#1077#1076#1086#1082' - '#1053#1077#1090'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1052#1077#1076#1086#1082' - '#1053#1077#1090'"'
      ImageIndex = 72
    end
    object actElectron: TdsdExecStoredProc [4]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spElectron
      StoredProcList = <
        item
          StoredProc = spElectron
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1044#1072'/'#1053#1077#1090'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1044#1072'/'#1053#1077#1090'"'
      ImageIndex = 52
    end
    object actChecked: TdsdExecStoredProc [5]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spChecked
      StoredProcList = <
        item
          StoredProc = spChecked
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1055#1088#1086#1074#1077#1088#1077#1085' '#1044#1072'/'#1053#1077#1090'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1055#1088#1086#1074#1077#1088#1077#1085' '#1044#1072'/'#1053#1077#1090'"'
      ImageIndex = 58
    end
    object actDocument: TdsdExecStoredProc [6]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDocument
      StoredProcList = <
        item
          StoredProc = spDocument
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1055#1086#1076#1087#1080#1089#1072#1085' '#1044#1072'/'#1053#1077#1090'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1055#1086#1076#1087#1080#1089#1072#1085' '#1044#1072'/'#1053#1077#1090'"'
      ImageIndex = 33
    end
    inherited actInsertMask: TdsdInsertUpdateAction [7]
      FormName = 'TTaxCorrectiveForm'
      FormNameParam.Value = 'TTaxCorrectiveForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = 'False'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMask'
          Value = 'True'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 'NULL'
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
    end
    object actInsertMaskMulti: TMultiAction [8]
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
    inherited actUpdate: TdsdInsertUpdateAction [9]
      FormName = 'TTaxCorrectiveForm'
      FormNameParam.Name = 'TTaxCorrectiveForm'
      FormNameParam.Value = 'TTaxCorrectiveForm'
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
    inherited actInsert: TdsdInsertUpdateAction [10]
      FormName = 'TTaxCorrectiveForm'
      FormNameParam.Name = 'TTaxCorrectiveForm'
      FormNameParam.Value = 'TTaxCorrectiveForm'
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
    object actMovementCheck: TdsdOpenForm [13]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1096#1080#1073#1082#1080
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1086#1096#1080#1073#1082#1080' '#1087#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1091
      ImageIndex = 30
      FormName = 'TMovementCheckForm'
      FormNameParam.Value = 'TMovementCheckForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    inherited actMovementItemContainer: TdsdOpenForm
      Enabled = False
    end
    object ExecuteDialog: TExecuteDialog [23]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1086' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080' '#1052#1077#1076#1086#1082
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1086' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080' '#1052#1077#1076#1086#1082
      ImageIndex = 24
      FormName = 'TTaxJournalDialogForm'
      FormNameParam.Value = 'TTaxJournalDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'DateRegistered'
          Value = 'NULL'
          Component = MasterCDS
          ComponentItem = 'DateRegistered_notNull'
          DataType = ftDateTime
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isElectron'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'isElectron'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberRegistered'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumberRegistered'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 'NULL'
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actPrint_TaxCorrective_Reestr: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1056#1077#1077#1089#1090#1088
      Hint = #1056#1077#1077#1089#1090#1088
      ImageIndex = 21
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          GridView = cxGridDBTableView
        end>
      Params = <
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
      ReportName = 'PrintMovement_TaxCorrectiveReestr'
      ReportNameParam.Name = 'PrintMovement_TaxCorrectiveReestr'
      ReportNameParam.Value = 'PrintMovement_TaxCorrectiveReestr'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
    end
    object MedocAction: TMedocCorrectiveAction
      Category = 'TaxLib'
      MoveParams = <>
      HeaderDataSet = PrintItemsCDS
      ItemsDataSet = PrintItemsCDS
    end
    object mactMeDoc: TMultiAction
      Category = 'TaxLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateIsMedoc
        end
        item
          Action = actMedocProcedure
        end
        item
          Action = MedocAction
        end
        item
          Action = actRefresh
        end>
      InfoAfterExecute = #1060#1072#1081#1083' '#1091#1089#1087#1077#1096#1085#1086' '#1074#1099#1075#1088#1091#1078#1077#1085
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' '#1052#1077#1044#1086#1082
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' '#1052#1077#1044#1086#1082
      ImageIndex = 30
    end
    object actMedocProcedure: TdsdExecStoredProc
      Category = 'TaxLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectPrintTaxCorrective_Client
      StoredProcList = <
        item
          StoredProc = spSelectPrintTaxCorrective_Client
        end>
      Caption = 'actMedocProcedure'
    end
    object ExecuteDialog1: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TMovement_DateDialogForm'
      FormNameParam.Value = 'TMovement_DateDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsPartnerDate'
          Value = 'False'
          Component = edIsRegisterDate
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actSPPrintTaxCorrectiveProcName: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReportNameTaxCorrective
      StoredProcList = <
        item
          StoredProc = spGetReportNameTaxCorrective
        end>
      Caption = 'actSPPrintTaxCorrectiveProcName'
    end
    object actPrint_TaxCorrective_Us: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintTaxCorrective_Us
      StoredProcList = <
        item
          StoredProc = spSelectPrintTaxCorrective_Us
        end>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      ImageIndex = 19
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_TaxCorrective'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTaxCorrective'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
    end
    object actPrint_TaxCorrective_Client: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintTaxCorrective_Client
      StoredProcList = <
        item
          StoredProc = spSelectPrintTaxCorrective_Client
        end>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      ImageIndex = 18
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_TaxCorrective'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' ('#1082#1083#1080#1077#1085#1090#1091')'
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTaxCorrective'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
    end
    object mactPrint_TaxCorrective_Client: TMultiAction
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
      ActionList = <
        item
          Action = actSPPrintTaxCorrectiveProcName
        end
        item
          Action = actPrint_TaxCorrective_Client
        end>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      ImageIndex = 18
    end
    object mactPrint_TaxCorrective_Us: TMultiAction
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
      ActionList = <
        item
          Action = actSPPrintTaxCorrectiveProcName
        end
        item
          Action = actPrint_TaxCorrective_Us
        end>
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Hint = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      ImageIndex = 19
    end
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
    end
    object mactMedocDECLAR: TMultiAction
      Category = 'TaxLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetDirectory
        end
        item
          Action = mactMEDOCList
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1074#1099#1075#1088#1091#1079#1082#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'?'
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1074#1099#1075#1088#1091#1078#1077#1085#1099
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1085#1072#1083#1086#1075#1086#1074#1099#1093' '#1074' '#1052#1045#1044#1054#1050
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1085#1072#1083#1086#1075#1086#1074#1099#1093' '#1074' '#1052#1045#1044#1054#1050
      ImageIndex = 28
    end
    object actGetDirectory: TdsdExecStoredProc
      Category = 'TaxLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetDirectoryName
      StoredProcList = <
        item
          StoredProc = spGetDirectoryName
        end>
      Caption = 'actGetDirectory'
    end
    object mactMEDOCList: TMultiAction
      Category = 'TaxLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateIsMedoc
        end
        item
          Action = spTaxPrint
        end
        item
          Action = MedocCorrectiveActionList
        end>
      View = cxGridDBTableView
      Caption = 'mactMEDOCList'
    end
    object EDIAction: TEDIAction
      Category = 'TaxLib'
      MoveParams = <>
      StartDateParam.Value = Null
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = Null
      EndDateParam.MultiSelectSeparator = ','
      EDIDocType = ediDeclarReturn
      HeaderDataSet = PrintHeaderCDS
      ListDataSet = PrintItemsCDS
    end
    object spTaxPrint: TdsdExecStoredProc
      Category = 'TaxLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectPrintTaxCorrective_Client
      StoredProcList = <
        item
          StoredProc = spSelectPrintTaxCorrective_Client
        end>
      Caption = 'spTaxPrint'
    end
    object actUpdateIsMedoc: TdsdExecStoredProc
      Category = 'TaxLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateIsMedoc
      StoredProcList = <
        item
          StoredProc = spUpdateIsMedoc
        end>
      Caption = 'actUpdateIsMedoc'
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
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 139
  end
  inherited MasterCDS: TClientDataSet
    Top = 139
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TaxCorrective'
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
        Name = 'inJuridicalBasisId'
        Value = Null
        Component = JuridicalBasisGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsRegisterDate'
        Value = 'False'
        Component = edIsRegisterDate
        DataType = ftBoolean
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
    Left = 104
    Top = 171
  end
  inherited BarManager: TdxBarManager
    Left = 168
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementCheck'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbactChecked'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbElectron'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMedocFalse'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbDocument'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintTaxCorrective_Client'
        end
        item
          Visible = True
          ItemName = 'bbPrintTaxCorrective_Us'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintTaxCorrective_Reestr'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMeDoc'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbSaveDeclarForMedoc'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbExecuteDialog'
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
    object bbPrintTaxCorrective_Us: TdxBarButton
      Action = mactPrint_TaxCorrective_Us
      Category = 0
    end
    object bbPrintTaxCorrective_Client: TdxBarButton
      Action = mactPrint_TaxCorrective_Client
      Category = 0
    end
    object bbPrintTaxCorrective_Reestr: TdxBarButton
      Action = actPrint_TaxCorrective_Reestr
      Category = 0
    end
    object bbMovementCheck: TdxBarButton
      Action = actMovementCheck
      Category = 0
      ImageIndex = 43
    end
    object bbMeDoc: TdxBarButton
      Action = mactMeDoc
      Category = 0
    end
    object bbactChecked: TdxBarButton
      Action = actChecked
      Category = 0
    end
    object bbElectron: TdxBarButton
      Action = actElectron
      Category = 0
    end
    object bbDocument: TdxBarButton
      Action = actDocument
      Category = 0
    end
    object bbSaveDeclarForMedoc: TdxBarButton
      Action = mactMedocDECLAR
      Category = 0
    end
    object bbMedocFalse: TdxBarButton
      Action = actMedocFalse
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
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
    Left = 240
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = edIsRegisterDate
      end
      item
        Component = JuridicalBasisGuides
      end>
    Left = 408
    Top = 344
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_TaxCorrective'
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
        Name = 'ouStatusCode'
        Value = Null
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
    Left = 80
    Top = 320
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_TaxCorrective'
    Left = 80
    Top = 384
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_TaxCorrective'
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
        Name = 'ReportNameTaxCorrective'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 376
    Top = 168
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_TaxCorrective'
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
        Name = 'ouStatusCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StatusCode'
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
    Left = 160
    Top = 336
  end
  object spSelectPrintTaxCorrective_Us: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TaxCorrective_Print'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintHeaderCDS
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
      end
      item
        Name = 'inisClientCopy'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 671
    Top = 232
  end
  object spSelectPrintTaxCorrective_Client: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TaxCorrective_Print'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintHeaderCDS
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
      end
      item
        Name = 'inisClientCopy'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 674
    Top = 282
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 788
    Top = 233
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 788
    Top = 286
  end
  object spChecked: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_Checked'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId '
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChecked'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Checked'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
    Top = 435
  end
  object spElectron: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_Electron'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId '
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inElectron'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isElectron'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 248
    Top = 443
  end
  object spDocument: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TaxCorrective_IsDocument'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId '
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioIsDocument'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Document'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsCalculate'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 392
    Top = 435
  end
  object EDI: TEDI
    ConnectionParams.Host.Value = Null
    ConnectionParams.Host.MultiSelectSeparator = ','
    ConnectionParams.User.Value = Null
    ConnectionParams.User.MultiSelectSeparator = ','
    ConnectionParams.Password.Value = Null
    ConnectionParams.Password.MultiSelectSeparator = ','
    SendToFTP = False
    Left = 544
    Top = 144
  end
  object spGetReportNameTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TaxCorrective_ReportName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_Movement_TaxCorrective_ReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameTaxCorrective'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 504
    Top = 392
  end
  object spGetDirectoryName: TdsdStoredProc
    StoredProcName = 'gpGetDirectoryName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Directory'
        Value = Null
        Component = MedocCorrectiveActionList
        ComponentItem = 'Directory'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 512
    Top = 144
  end
  object spUpdateIsMedoc: TdsdStoredProc
    StoredProcName = 'gpUpdate_IsMedoc'
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
    Left = 520
    Top = 224
  end
  object spMedoc_False: TdsdStoredProc
    StoredProcName = 'gpUpdate_IsMedoc_False'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId '
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'onisMedoc'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isMedoc'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 736
    Top = 387
  end
  object spGetInfo: TdsdStoredProc
    StoredProcName = 'gpGet_Object_MedocLoadInfo'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inDate'
        Value = 'NULL'
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Period'
        Value = 'cxTextEdit1'
        Component = edPeriod
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'LoadDateTime'
        Value = 42121d
        Component = edLoadData
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 736
    Top = 152
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
    Left = 1031
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
    Left = 936
    Top = 48
  end
end
