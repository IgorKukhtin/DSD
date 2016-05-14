inherited ReturnInJournalForm: TReturnInJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' ('#1074#1089#1077')>'
  ClientHeight = 535
  ClientWidth = 1114
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1130
  ExplicitHeight = 573
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1114
    Height = 478
    TabOrder = 3
    ExplicitWidth = 1106
    ExplicitHeight = 478
    ClientRectBottom = 478
    ClientRectRight = 1114
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1106
      ExplicitHeight = 478
      inherited cxGrid: TcxGrid
        Width = 1114
        Height = 478
        ExplicitWidth = 1106
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
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalSummChange
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
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colTotalSummChange
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
            Width = 49
          end
          inherited colOperDate: TcxGridDBColumn [1]
            Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
            Visible = False
            HeaderAlignmentHorz = taCenter
            Width = 70
          end
          object colOperDatePartner: TcxGridDBColumn [2]
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'OperDatePartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          inherited colInvNumber: TcxGridDBColumn [3]
            Caption = #8470' '#1076#1086#1082'.'
            HeaderAlignmentHorz = taCenter
            Width = 70
          end
          object colInvNumberPartner: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'InvNumberPartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colInvNumberMark: TcxGridDBColumn
            Caption = #8470' '#1079'.'#1084'.'
            DataBinding.FieldName = 'InvNumberMark'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colInvNumber_Parent: TcxGridDBColumn
            Caption = #1054#1089#1085'. '#8470' ('#1074#1086#1079#1074#1088#1072#1090')'
            DataBinding.FieldName = 'InvNumber_Parent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colDocumentTaxKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
            DataBinding.FieldName = 'DocumentTaxKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colOKPO_From: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO_From'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object colJuridicalName_From: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName_From'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 92
          end
          object colFromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 102
          end
          object colToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 102
          end
          object colTotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1089#1082#1083#1072#1076')'
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
            Caption = #1050#1086#1083'-'#1074#1086' ('#1091' '#1087#1086#1082#1091#1087'.)'
            DataBinding.FieldName = 'TotalCountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colTotalCountTare: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1090#1072#1088#1099' ('#1091' '#1087#1086#1082#1091#1087'.)'
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
            Caption = #1050#1086#1083'-'#1074#1086' '#1096#1090'. ('#1091' '#1087#1086#1082#1091#1087'.)'
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
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1077#1089' ('#1091' '#1087#1086#1082#1091#1087'.)'
            DataBinding.FieldName = 'TotalCountKg'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colTotalSummChange: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' (-)'#1089#1082'.(+)'#1085#1072#1094
            DataBinding.FieldName = 'TotalSummChange'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object colTotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object colChangePercent: TcxGridDBColumn
            Caption = '(-)% '#1057#1082', (+)% '#1053#1072#1094
            DataBinding.FieldName = 'ChangePercent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 65
          end
          object colPriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1099' '#1089' '#1053#1044#1057' '
            DataBinding.FieldName = 'PriceWithVAT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 47
          end
          object colVATPercent: TcxGridDBColumn
            Caption = '% '#1053#1044#1057
            DataBinding.FieldName = 'VATPercent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 38
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
          object colPaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
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
            Width = 46
          end
          object colContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
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
            Width = 80
          end
          object colInfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colInfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colCurrencyValue: TcxGridDBColumn
            Caption = #1050#1091#1088#1089
            DataBinding.FieldName = 'CurrencyValue'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 52
          end
          object colCurrencyDocumentName: TcxGridDBColumn
            Caption = #1042#1072#1083#1102#1090#1072' ('#1094#1077#1085#1072')'
            DataBinding.FieldName = 'CurrencyDocumentName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 54
          end
          object colCurrencyPartnerName: TcxGridDBColumn
            Caption = #1042#1072#1083#1102#1090#1072' ('#1087#1086#1082'.)'
            DataBinding.FieldName = 'CurrencyPartnerName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 54
          end
          object colChecked: TcxGridDBColumn
            Caption = #1055#1088#1086#1074#1077#1088#1077#1085
            DataBinding.FieldName = 'Checked'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 39
          end
          object colIsEDI: TcxGridDBColumn
            Caption = 'EXITE'
            DataBinding.FieldName = 'isEDI'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 30
          end
          object isPartner: TcxGridDBColumn
            Caption = #1040#1082#1090' '#1085#1077#1076#1086#1074#1086#1079#1072
            DataBinding.FieldName = 'isPartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object isPromo: TcxGridDBColumn
            Caption = #1040#1082#1094#1080#1103
            DataBinding.FieldName = 'isPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object MovementPromo: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1072#1082#1094#1080#1103
            DataBinding.FieldName = 'MovementPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colisList: TcxGridDBColumn
            Caption = #1044#1083#1103' '#1089#1087#1080#1089#1082#1072' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isList'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1083#1103' '#1089#1087#1080#1089#1082#1072' ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 58
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1114
    ExplicitWidth = 1106
    inherited deStart: TcxDateEdit
      EditValue = 42370d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42370d
    end
    object edIsPartnerDate: TcxCheckBox
      Left = 427
      Top = 5
      Action = actRefresh
      Caption = #1055#1077#1088#1080#1086#1076' '#1076#1083#1103' <'#1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      TabOrder = 4
      Width = 270
    end
    object edDocumentTaxKind: TcxButtonEdit
      Left = 875
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 200
    end
    object cxLabel14: TcxLabel
      Left = 690
      Top = 6
      Caption = #1058#1080#1087' '#1076#1083#1103'  '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1103' '#1085#1072#1083#1086#1075'.'#1076#1086#1082'.'
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
        Component = edIsPartnerDate
        Properties.Strings = (
          'Checked')
      end>
    Left = 40
    Top = 243
  end
  inherited ActionList: TActionList
    Left = 31
    Top = 138
    inherited actInsert: TdsdInsertUpdateAction [0]
      FormName = 'TReturnInForm'
      FormNameParam.Value = 'TReturnInForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction [1]
      FormName = 'TReturnInForm'
      FormNameParam.Value = 'TReturnInForm'
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
    inherited actRefresh: TdsdDataSetRefresh [2]
    end
    inherited actUnComplete: TdsdChangeMovementStatus [3]
    end
    inherited actComplete: TdsdChangeMovementStatus [4]
    end
    inherited actSetErased: TdsdChangeMovementStatus [5]
    end
    inherited actCompleteList: TMultiAction [6]
      View = cxGridDBTableView
    end
    inherited actUnCompleteList: TMultiAction [7]
      View = cxGridDBTableView
    end
    inherited actSetErasedList: TMultiAction [8]
      View = cxGridDBTableView
    end
    object actTaxCorrective: TdsdExecStoredProc [9]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spTaxCorrective
      StoredProcList = <
        item
          StoredProc = spTaxCorrective
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1089' '#1087#1088#1080#1074#1103#1079#1082#1086#1081')>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1089' '#1087#1088#1080#1074#1103#1079#1082#1086#1081')>'
      ImageIndex = 41
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1089 +
        ' '#1087#1088#1080#1074#1103#1079#1082#1086#1081')>?'
      InfoAfterExecute = 
        #1047#1072#1074#1077#1088#1096#1077#1085#1086' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1089' '#1087#1088 +
        #1080#1074#1103#1079#1082#1086#1081')>.'
    end
    object actCorrective: TdsdExecStoredProc [10]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spCorrective
      StoredProcList = <
        item
          StoredProc = spCorrective
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1073#1077#1079' '#1087#1088#1080#1074#1103#1079#1082#1080')>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1073#1077#1079' '#1087#1088#1080#1074#1103#1079#1082#1080')>'
      ImageIndex = 42
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1073 +
        #1077#1079' '#1087#1088#1080#1074#1103#1079#1082#1080')>?'
      InfoAfterExecute = 
        #1047#1072#1074#1077#1088#1096#1077#1085#1086' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'('#1073#1077#1079' ' +
        #1087#1088#1080#1074#1103#1079#1082#1080')>.'
    end
    inherited actMovementItemContainer: TdsdOpenForm [11]
    end
    inherited actShowErased: TBooleanStoredProcAction [12]
    end
    object actPrint: TdsdPrintAction [13]
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
      Caption = #1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
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
      ReportName = 'NULL'
      ReportNameParam.Name = #1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportName'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
    end
    inherited actGridToExcel: TdsdGridToExcel [14]
    end
    inherited actInsertMask: TdsdInsertUpdateAction [15]
    end
    inherited actReCompleteList: TMultiAction [16]
    end
    inherited spReCompete: TdsdExecStoredProc [17]
    end
    inherited MovementProtocolOpenForm: TdsdOpenForm [18]
    end
    object actSPPrintProcNamePriceCorr: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReportNamePriceCorr
      StoredProcList = <
        item
          StoredProc = spGetReportNamePriceCorr
        end>
      Caption = 'actSPPrintProcName'
    end
    object actSPPrintProcName: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReportName
      StoredProcList = <
        item
          StoredProc = spGetReportName
        end>
      Caption = 'actSPPrintProcName'
    end
    object mactPrintPriceCorr: TMultiAction
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
          Action = actSPPrintProcNamePriceCorr
        end
        item
          Action = actPrint
        end>
      Caption = #1050#1054#1056#1045#1043#1059#1070#1063#1040' '#1058#1054#1042#1040#1056#1053#1040' '#1053#1040#1050#1051#1040#1044#1053#1040
      Hint = #1050#1054#1056#1045#1043#1059#1070#1063#1040' '#1058#1054#1042#1040#1056#1053#1040' '#1053#1040#1050#1051#1040#1044#1053#1040
      ImageIndex = 16
    end
    object mactPrint: TMultiAction
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
          Action = actSPPrintProcName
        end
        item
          Action = actPrint
        end>
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1053#1072#1082#1083#1072#1076#1085#1072#1103
      ImageIndex = 3
      ShortCut = 16464
    end
    object actPrint_ReturnIn_by_TaxCorrective: TdsdPrintAction
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
      StoredProc = spSelectPrintTaxCorrective_Client
      StoredProcList = <
        item
          StoredProc = spSelectPrintTaxCorrective_Client
        end>
      Caption = #1053#1072#1082#1083#1072#1076#1085#1072#1103' ('#1089' '#1087#1088#1080#1074#1103#1079#1082#1086#1081' '#1082' '#1082#1086#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072#1084')'
      Hint = #1053#1072#1082#1083#1072#1076#1085#1072#1103' ('#1089' '#1087#1088#1080#1074#1103#1079#1082#1086#1081' '#1082' '#1082#1086#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072#1084')'
      ImageIndex = 21
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
      ReportName = 'PrintMovement_ReturnIn_By_TaxCorrective'
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081' ('#1082#1083#1080#1077#1085#1090#1091')'
      ReportNameParam.Value = 'PrintMovement_ReturnIn_By_TaxCorrective'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
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
      ReportNameParam.Value = ''
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
      ReportNameParam.Value = ''
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
    object actSimpleCheckedList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actspChecked
        end>
      View = cxGridDBTableView
      Caption = #1055#1086#1084#1077#1090#1082#1072' '#1087#1088#1086#1074#1077#1088#1077#1085
      Hint = #1055#1086#1084#1077#1090#1082#1072' '#1087#1088#1086#1074#1077#1088#1077#1085
      ImageIndex = 58
    end
    object actspChecked: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spCheckedTrue
      StoredProcList = <
        item
          StoredProc = spCheckedTrue
        end>
      Caption = 'spChecked'
    end
    object actCheckedList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleCheckedList
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1091#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1088#1086#1074#1077#1088#1077#1085'" '#1074#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084'? '
      InfoAfterExecute = #1055#1088#1080#1079#1085#1072#1082' "'#1055#1088#1086#1074#1077#1088#1077#1085'" '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085' '#1074#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1088#1086#1074#1077#1088#1077#1085'" '#1074#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      Hint = #1059#1089#1090#1072#1085#1086#1074#1083#1077#1085' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1088#1086#1074#1077#1088#1077#1085'" '#1074#1089#1077#1084' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084
      ImageIndex = 58
    end
    object actChecked: TdsdExecStoredProc
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
    object ExecuteDialog: TExecuteDialog
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
          Component = edIsPartnerDate
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
    end
  end
  inherited MasterDS: TDataSource
    Left = 80
    Top = 171
  end
  inherited MasterCDS: TClientDataSet
    Left = 32
    Top = 179
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ReturnIn'
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
        Name = 'inIsPartnerDate'
        Value = 'False'
        Component = edIsPartnerDate
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
    Left = 128
    Top = 179
  end
  inherited BarManager: TdxBarManager
    Left = 152
    Top = 139
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
          ItemName = 'bbTaxCorrective'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbCorrective'
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
          ItemName = 'bbactChecked'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintReturnIn'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintPriceCorr'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Return_By_TaxCorrective'
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
    object bbTaxCorrective: TdxBarButton
      Action = actTaxCorrective
      Category = 0
    end
    object bbCorrective: TdxBarButton
      Action = actCorrective
      Category = 0
    end
    object bbPrintReturnIn: TdxBarButton
      Action = mactPrint
      Category = 0
    end
    object bbPrintTaxCorrective_Client: TdxBarButton
      Action = mactPrint_TaxCorrective_Client
      Category = 0
    end
    object bbPrintTaxCorrective_Us: TdxBarButton
      Action = actPrint_TaxCorrective_Us
      Category = 0
    end
    object bbPrint_Return_By_TaxCorrective: TdxBarButton
      Action = actPrint_ReturnIn_by_TaxCorrective
      Category = 0
    end
    object bbactChecked: TdxBarButton
      Action = actChecked
      Category = 0
    end
    object bbPrintPriceCorr: TdxBarButton
      Action = mactPrintPriceCorr
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
    object N13: TMenuItem [12]
      Action = actCheckedList
    end
    object N14: TMenuItem [13]
      Caption = '-'
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 328
    Top = 224
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
    StoredProcName = 'gpComplete_Movement_ReturnIn'
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
        Name = 'inislastcomplete'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 320
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_ReturnIn'
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
    StoredProcName = 'gpSetErased_Movement_ReturnIn'
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
        Name = 'ReportName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameTaxCorrective'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 384
    Top = 176
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_ReturnIn'
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
        Name = 'inislastcomplete'
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 400
    Top = 112
  end
  object DocumentTaxKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edDocumentTaxKind
    FormNameParam.Value = 'TDocumentTaxKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TDocumentTaxKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 912
  end
  object spTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TaxCorrective_From_Kind'
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
        Name = 'inDocumentTaxKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DocumentTaxKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocumentTaxKindId_inf'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDateTax'
        Value = 'NULL'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTaxLink'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDocumentTaxKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DocumentTaxKindId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDocumentTaxKindName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DocumentTaxKindName'
        DataType = ftString
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
    PackSize = 1
    Left = 296
    Top = 312
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ReturnIn_Print'
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
    Left = 650
    Top = 210
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
        Component = FormParams
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
    Left = 650
    Top = 306
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
    Left = 650
    Top = 258
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 764
    Top = 210
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 765
    Top = 258
  end
  object spCorrective: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TaxCorrective_From_Kind'
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
        Name = 'inDocumentTaxKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DocumentTaxKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDocumentTaxKindId_inf'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDateTax'
        Value = 'NULL'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTaxLink'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDocumentTaxKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DocumentTaxKindId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDocumentTaxKindName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DocumentTaxKindName'
        DataType = ftString
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
    PackSize = 1
    Left = 296
    Top = 280
  end
  object spGetReportName: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ReturnIn_ReportName'
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
        Name = 'inDescName'
        Value = 'zc_Movement_ReturnIn'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_Movement_ReturnIn_ReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 584
    Top = 376
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
    Left = 424
    Top = 416
  end
  object spGetReportNamePriceCorr: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ReturnIn_ReportName'
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
        Name = 'inDescName'
        Value = 'zc_Movement_PriceCorrective'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_Movement_ReturnIn_ReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 584
    Top = 424
  end
  object spCheckedTrue: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_Checked'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId '
        Value = 0
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChecked'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 272
    Top = 435
  end
end
