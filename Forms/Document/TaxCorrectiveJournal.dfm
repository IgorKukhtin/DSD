inherited TaxCorrectiveJournalForm: TTaxCorrectiveJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081'>'
  ClientHeight = 535
  ClientWidth = 1097
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog1
  ExplicitWidth = 1113
  ExplicitHeight = 574
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 76
    Width = 1097
    Height = 459
    TabOrder = 3
    ExplicitTop = 76
    ExplicitWidth = 1097
    ExplicitHeight = 459
    ClientRectBottom = 459
    ClientRectRight = 1097
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1097
      ExplicitHeight = 459
      inherited cxGrid: TcxGrid
        Width = 1097
        Height = 459
        ExplicitLeft = 10
        ExplicitTop = -96
        ExplicitWidth = 1097
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
              Column = TotalCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummMVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummPVAT
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
              Column = TotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummMVAT
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummPVAT
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = FromName
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
          object isNPP_calc: TcxGridDBColumn [1]
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'isNPP_calc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '#8470' '#1087'/'#1087' ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 40
          end
          object DateisNPP_calc: TcxGridDBColumn [2]
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#8470' '#1087'/'#1087
            DataBinding.FieldName = 'DateisNPP_calc'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
            Properties.EditFormat = 'dd.mm.yyyy hh:mm'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1103' '#8470' '#1087'/'#1087
            Options.Editing = False
            Width = 65
          end
          object IsError: TcxGridDBColumn [3]
            Caption = #1054#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'isError'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object BranchName: TcxGridDBColumn [4]
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          inherited colOperDate: TcxGridDBColumn [5]
            HeaderAlignmentHorz = taCenter
            Width = 50
          end
          inherited colInvNumber: TcxGridDBColumn [6]
            Caption = #8470' '#1076#1086#1082'.'
            Visible = False
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          object InvNumberPartner: TcxGridDBColumn
            Caption = #8470' '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'InvNumberPartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object InvNumber_Master: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'#1074#1086#1079#1074#1088'.'
            DataBinding.FieldName = 'InvNumber_Master'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 89
          end
          object InvNumberPartner_Master: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'#1074#1086#1079#1074#1088'.'#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'InvNumberPartner_Master'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object InvNumberPartner_Child: TcxGridDBColumn
            Caption = #8470' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'InvNumberPartner_Child'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object OperDate_Child: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'OperDate_Child'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object isAuto: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
            DataBinding.FieldName = 'isAuto'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
            Options.Editing = False
            Width = 57
          end
          object TaxKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
            DataBinding.FieldName = 'TaxKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object PartnerCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
            DataBinding.FieldName = 'PartnerCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object PartnerName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'PartnerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OKPO_From: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO_From'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object OKPO_Retail: TcxGridDBColumn
            Caption = #1054#1050#1055#1054' '#1076#1083#1103' '#1090#1086#1088#1075'. '#1089#1077#1090#1080
            DataBinding.FieldName = 'OKPO_Retail'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object isOKPO_Retail: TcxGridDBColumn
            Caption = #1054#1050#1055#1054' '#1076#1083#1103' '#1090#1086#1088#1075'. '#1089#1077#1090#1080
            DataBinding.FieldName = 'isOKPO_Retail'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1050#1055#1054' '#1076#1083#1103' '#1090#1086#1088#1075'. '#1089#1077#1090#1080' ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 50
          end
          object INN_From: TcxGridDBColumn
            Caption = #1048#1053#1053
            DataBinding.FieldName = 'INN_From'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object isINN: TcxGridDBColumn
            Caption = #1048#1053#1053' '#1076#1086#1082'.'
            DataBinding.FieldName = 'isINN'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1053#1053' '#1080#1089#1087#1088#1072#1074#1083#1077#1085' '#1076#1083#1103' 1-'#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 40
          end
          object RetailName_From: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName_From'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object FromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object ToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object TotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1091' '#1087#1086#1082#1091#1087'.)'
            DataBinding.FieldName = 'TotalCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'PriceWithVAT'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object VATPercent: TcxGridDBColumn
            Caption = '% '#1053#1044#1057
            DataBinding.FieldName = 'VATPercent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object TotalSummVAT: TcxGridDBColumn
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
          object TotalSummMVAT: TcxGridDBColumn
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
          object TotalSummPVAT: TcxGridDBColumn
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
          object ContractCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ContractName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ContractName_detail: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'. ('#1076#1077#1090#1072#1083#1100#1085#1086')'
            DataBinding.FieldName = 'ContractName_detail'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 138
          end
          object ContractName_detail_Child: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'. '#1085#1072#1083#1086#1075'. ('#1076#1077#1090#1072#1083#1100#1085#1086')'
            DataBinding.FieldName = 'ContractName_detail_Child'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 138
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object InfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object InvNumberBranch: TcxGridDBColumn
            Caption = #8470' '#1092#1080#1083#1080#1072#1083#1072
            DataBinding.FieldName = 'InvNumberBranch'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object DateRegistered: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1088#1077#1075#1080#1089#1090#1088'.'
            DataBinding.FieldName = 'DateRegistered'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object Checked: TcxGridDBColumn
            Caption = #1055#1088#1086#1074#1077#1088#1077#1085
            DataBinding.FieldName = 'Checked'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object Document: TcxGridDBColumn
            Caption = #1055#1086#1076#1087#1080#1089#1072#1085
            DataBinding.FieldName = 'Document'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object IsEDI: TcxGridDBColumn
            Caption = 'EXITE'
            DataBinding.FieldName = 'isEDI'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 30
          end
          object IsElectron: TcxGridDBColumn
            Caption = #1069#1083#1077#1082#1090#1088'.'
            DataBinding.FieldName = 'isElectron'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 30
          end
          object IsMedoc: TcxGridDBColumn
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
          object InvNumberRegistered: TcxGridDBColumn
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
          object PersonalSigningName: TcxGridDBColumn
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1087#1086#1076#1087#1080#1089#1072#1085#1090')'
            DataBinding.FieldName = 'PersonalSigningName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PersonalCode_Collation: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1089#1086#1090#1088'. '#1089#1074#1077#1088#1082#1072')'
            DataBinding.FieldName = 'PersonalCode_Collation'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PersonalName_Collation: TcxGridDBColumn
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1089#1074#1077#1088#1082#1072')'
            DataBinding.FieldName = 'PersonalName_Collation'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object UnitName_Collation: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1089#1086#1090#1088'. '#1089#1074#1077#1088#1082#1072')'
            DataBinding.FieldName = 'UnitName_Collation'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object BranchName_Collation: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083' ('#1089#1086#1090#1088'. '#1089#1074#1077#1088#1082#1072')'
            DataBinding.FieldName = 'BranchName_Collation'
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
          object isPartner: TcxGridDBColumn
            Caption = #1040#1082#1090' '#1085#1077#1076#1086#1074#1086#1079#1072
            DataBinding.FieldName = 'isPartner'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
          object isUKTZ_new: TcxGridDBColumn
            Caption = #1053#1086#1074#1099#1081' '#1059#1050#1058#1047
            DataBinding.FieldName = 'isUKTZ_new'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1080#1085#1091#1076#1080#1090#1077#1083#1100#1085#1086' '#1087#1086#1076#1082#1083#1102#1095#1077#1085' '#1085#1086#1074#1099#1081' '#1059#1050#1058#1047' '#1076#1083#1103' '#1089#1090#1072#1088#1086#1075#1086' '#1087#1077#1088#1080#1086#1076#1072
            Options.Editing = False
            Width = 70
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1097
    Height = 50
    ExplicitWidth = 1097
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
      Left = 822
      Top = 6
      Caption = #1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077':'
    end
    object edJuridicalBasis: TcxButtonEdit
      Left = 900
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 150
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
    object actUpdateMI_NPP_Null: TdsdExecStoredProc [0]
      Category = 'NPP'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMI_NPP_Null
      StoredProcList = <
        item
          StoredProc = spUpdateMI_NPP_Null
        end>
      Caption = #1054#1073#1085#1091#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#8470' '#1087'/'#1087
      Hint = #1054#1073#1085#1091#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#8470' '#1087'/'#1087
      ImageIndex = 46
    end
    object macUpdate_NPP_Null_All: TMultiAction [1]
      Category = 'NPP'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_NPP_Null
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1041#1091#1076#1091#1090' '#1059#1044#1040#1051#1045#1053#1067' '#1042#1057#1045' '#1076#1072#1085#1085#1085#1099#1077' '#1076#1083#1103' '#8470' '#1087'/'#1087' '#1076#1083#1103' '#1042#1057#1045#1061' '#1044#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1080#1079' '#1089#1087#1080#1089#1082 +
        #1072', '#1041#1045#1047' '#1042#1054#1047#1052#1054#1046#1053#1054#1057#1058#1048' '#1042#1054#1057#1057#1058#1040#1053#1054#1042#1051#1045#1053#1048#1071'. '#1055#1088#1086#1076#1086#1083#1078#1080#1090#1100' ?'
      InfoAfterExecute = #1059#1044#1040#1051#1045#1053#1067' '#1042#1057#1045' '#1076#1072#1085#1085#1085#1099#1077' '#1076#1083#1103' '#8470' '#1087'/'#1087
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#8470' '#1087'/'#1087
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#8470' '#1087'/'#1087
      ImageIndex = 46
    end
    object MedocListAction: TMedocCorrectiveAction [2]
      Category = 'TaxLib'
      MoveParams = <>
      Caption = 'MedocListAction'
      HeaderDataSet = PrintItemsCDS
      ItemsDataSet = PrintItemsCDS
      AskFilePath = False
    end
    object macUpdate_NPP_Null: TMultiAction [3]
      Category = 'NPP'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateMI_NPP_Null
        end>
      View = cxGridDBTableView
      Caption = 'macUpdate_NPP_Null'
      ImageIndex = 46
    end
    inherited actMovementItemContainer: TdsdOpenForm
      Enabled = False
    end
    object actMedocFalse: TdsdExecStoredProc [5]
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
    object actElectron: TdsdExecStoredProc [7]
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
    object actChecked: TdsdExecStoredProc [8]
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
    object actDocument: TdsdExecStoredProc [9]
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
    inherited actInsertMask: TdsdInsertUpdateAction [10]
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
          Value = False
          DataType = ftBoolean
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
    object actInsertMaskMulti: TMultiAction [11]
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
    inherited actUpdate: TdsdInsertUpdateAction [12]
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
    inherited actInsert: TdsdInsertUpdateAction [13]
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
    inherited actShowErased: TBooleanStoredProcAction [14]
    end
    inherited actRefresh: TdsdDataSetRefresh [15]
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spGetInfo
        end>
    end
    object actMovementCheck: TdsdOpenForm [16]
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
    inherited actGridToExcel: TdsdGridToExcel [17]
    end
    object ExecuteDialog: TExecuteDialog [26]
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
          Value = Null
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
          Value = Null
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
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
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
          Action = actSelect_Medoc
        end
        item
          Action = MedocAction
        end
        item
          Action = actRefresh
        end>
      InfoAfterExecute = #1060#1072#1081#1083' '#1091#1089#1087#1077#1096#1085#1086' '#1074#1099#1075#1088#1091#1078#1077#1085' '#1076#1083#1103' '#1052#1077#1044#1086#1082
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' '#1052#1077#1044#1086#1082
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' '#1052#1077#1044#1086#1082
      ImageIndex = 30
    end
    object actSelect_Medoc: TdsdExecStoredProc
      Category = 'TaxLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectPrintTaxCorrective_Client
      StoredProcList = <
        item
          StoredProc = spSelectPrintTaxCorrective_Client
        end>
      Caption = 'actSelect_Medoc'
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
          Value = False
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
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
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
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
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
    object mactMedocALL: TMultiAction
      Category = 'TaxLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetDirectory
        end
        item
          Action = mactMEDOCGrid
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1074#1099#1075#1088#1091#1079#1082#1077' '#1074' '#1052#1045#1044#1054#1050' '#1042#1057#1045#1061' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'?'
      InfoAfterExecute = #1042#1057#1045' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1074#1099#1075#1088#1091#1078#1077#1085#1099' '#1074' '#1052#1045#1044#1054#1050
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1042#1057#1045#1061' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1086#1082' '#1074' '#1052#1045#1044#1054#1050
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1042#1057#1045#1061' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1086#1082' '#1074' '#1052#1045#1044#1054#1050
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
    object mactMEDOCGrid: TMultiAction
      Category = 'TaxLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateIsMedoc
        end
        item
          Action = actSelect_Medoc_list
        end
        item
          Action = MedocListAction
        end>
      View = cxGridDBTableView
      Caption = 'mactMEDOCGrid'
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
    object actSelect_Medoc_list: TdsdExecStoredProc
      Category = 'TaxLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectPrintTaxCorrective_Client
      StoredProcList = <
        item
          StoredProc = spSelectPrintTaxCorrective_Client
        end>
      Caption = 'actSelect_Medoc_list'
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
    object mactIFin: TMultiAction
      Category = 'TaxLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateIsMedoc
        end
        item
          Action = actSelect_Medoc
        end
        item
          Action = IFinAction
        end
        item
          Action = actRefresh
        end>
      InfoAfterExecute = #1060#1072#1081#1083' '#1091#1089#1087#1077#1096#1085#1086' '#1074#1099#1075#1088#1091#1078#1077#1085' '#1076#1083#1103' IFin'
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' IFin'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' IFin'
      ImageIndex = 47
    end
    object mactIFinALL: TMultiAction
      Category = 'TaxLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetDirectoryIFIN
        end
        item
          Action = mactIFinGrid
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1074#1099#1075#1088#1091#1079#1082#1077' '#1074' IFin '#1042#1057#1045#1061' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'?'
      InfoAfterExecute = #1042#1057#1045' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1074#1099#1075#1088#1091#1078#1077#1085#1099' '#1074' IFin'
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1042#1057#1045#1061' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1086#1082' '#1074' IFin'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1042#1057#1045#1061' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1086#1082' '#1074' IFin'
      ImageIndex = 48
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
    object macUpdateBranch: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      ActionList = <
        item
          Action = actBranchChoiceForm
        end
        item
          Action = actUpdate_Branch
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1060#1080#1083#1080#1072#1083
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1060#1080#1083#1080#1072#1083
      ImageIndex = 60
    end
    object IFinListAction: TMedocCorrectiveAction
      Category = 'TaxLib'
      MoveParams = <>
      Caption = 'MedocListAction'
      HeaderDataSet = PrintItemsCDS
      ItemsDataSet = PrintItemsCDS
      AskFilePath = False
      IsMedoc = False
    end
    object IFinAction: TMedocCorrectiveAction
      Category = 'TaxLib'
      MoveParams = <>
      Caption = 'IFinAction'
      HeaderDataSet = PrintItemsCDS
      ItemsDataSet = PrintItemsCDS
      IsMedoc = False
    end
    object mactIFinGrid: TMultiAction
      Category = 'TaxLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateIsMedoc
        end
        item
          Action = actSelect_Medoc_list
        end
        item
          Action = IFinListAction
        end>
      View = cxGridDBTableView
      Caption = 'mactMEDOCGrid'
    end
    object actGetDirectoryIFIN: TdsdExecStoredProc
      Category = 'TaxLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetDirectoryNameIFIN
      StoredProcList = <
        item
          StoredProc = spGetDirectoryNameIFIN
        end>
      Caption = 'actGetDirectoryIFIN'
    end
    object actUpdateINN: TdsdDataSetRefresh
      Category = 'INN'
      MoveParams = <>
      StoredProc = spUpdate_INN
      StoredProcList = <
        item
          StoredProc = spUpdate_INN
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 26
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object ExecuteDialogINN: TExecuteDialog
      Category = 'INN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = 'ExecuteDialogINN'
      Hint = 'ExecuteDialogINN'
      ImageIndex = 26
      FormName = 'TMovementString_INNEditForm'
      FormNameParam.Value = 'TMovementString_INNEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inINN'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'INN_From'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macUpdateINN: TMultiAction
      Category = 'INN'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogINN
        end
        item
          Action = actUpdateINN
        end>
      Caption = #1048#1089#1087#1088#1072#1074#1080#1090#1100' '#1048#1053#1053' '#1076#1083#1103' 1-'#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1048#1089#1087#1088#1072#1074#1080#1090#1100' '#1048#1053#1053' '#1076#1083#1103' 1-'#1086#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 76
    end
    object actChangeNPP_calc: TdsdExecStoredProc
      Category = 'NPP'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMI_NPP_calc
      StoredProcList = <
        item
          StoredProc = spUpdateMI_NPP_calc
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#8470' '#1087'/'#1087' '#1044#1051#1071' '#1082#1086#1083#1086#1085#1082#1080' 1/2'#1089#1090#1088#1086#1082#1072
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#8470' '#1087'/'#1087' '#1044#1051#1071' '#1082#1086#1083#1086#1085#1082#1080' 1/2'#1089#1090#1088#1086#1082#1072
      ImageIndex = 45
    end
    object macChangeNPP: TMultiAction
      Category = 'NPP'
      MoveParams = <>
      ActionList = <
        item
          Action = actChangeNPP_calc
        end>
      View = cxGridDBTableView
      Caption = 'macChangeNPP'
      ImageIndex = 45
    end
    object macChangeNPP_Calc: TMultiAction
      Category = 'NPP'
      MoveParams = <>
      ActionList = <
        item
          Action = macChangeNPP
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1080' '#1076#1083#1103' '#1042#1057#1045#1061' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1086#1082' '#8470' '#1087'/'#1087' '#1044#1051#1071' '#1082#1086#1083#1086#1085 +
        #1082#1080' 1/2'#1089#1090#1088#1086#1082#1072'?'
      InfoAfterExecute = #8470#8470' '#1087'/'#1087' '#1044#1051#1071' '#1082#1086#1083#1086#1085#1082#1080' 1/2'#1089#1090#1088#1086#1082#1072' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1083#1103' '#1042#1057#1045#1061' '#8470' '#1087'/'#1087' '#1044#1051#1071' '#1082#1086#1083#1086#1085#1082#1080' 1/2'#1089#1090#1088#1086#1082#1072
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1083#1103' '#1042#1057#1045#1061' '#8470' '#1087'/'#1087' '#1044#1051#1071' '#1082#1086#1083#1086#1085#1082#1080' 1/2'#1089#1090#1088#1086#1082#1072
      ImageIndex = 45
    end
    object actReport_Check_NPP: TdsdOpenForm
      Category = 'NPP'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#8470#1087'/'#1087'>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#8470#1087'/'#1087'>'
      ImageIndex = 40
      FormName = 'TReport_CheckTaxCorrective_NPPForm'
      FormNameParam.Value = 'TReport_CheckTaxCorrective_NPPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'GoodsId'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ' '
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'DocumentChildId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actInsert_isAutoPrepay: TdsdExecStoredProc
      Category = 'Prepay'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_isAutoPrepay
      StoredProcList = <
        item
          StoredProc = spInsert_isAutoPrepay
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1086#1095#1085#1099#1077' '#1053#1072#1082#1083#1072#1076#1085#1099#1077' '#1087#1088#1077#1076#1086#1087#1083#1072#1090#1099
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1086#1095#1085#1099#1077' '#1053#1072#1082#1083#1072#1076#1085#1099#1077' '#1087#1088#1077#1076#1086#1087#1083#1072#1090#1099
      ImageIndex = 56
    end
    object macInsert_isAutoPrepay: TMultiAction
      Category = 'Prepay'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsert_isAutoPrepay
        end>
      QuestionBeforeExecute = 
        #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1086#1095#1085#1099#1077' '#1053#1072#1082#1083#1072#1076#1085#1099#1077' '#1087#1088#1077#1076#1086#1087#1083#1072#1090#1099' '#1079#1072' '#1074#1099#1073#1088#1072#1085#1085#1099#1081' ' +
        #1087#1077#1088#1080#1086#1076'?'
      InfoAfterExecute = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1086#1095#1085#1099#1077' '#1053#1072#1082#1083#1072#1076#1085#1099#1077' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1085#1099
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1086#1095#1085#1099#1077' '#1053#1072#1082#1083#1072#1076#1085#1099#1077' '#1087#1088#1077#1076#1086#1087#1083#1072#1090#1099
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1086#1095#1085#1099#1077' '#1053#1072#1082#1083#1072#1076#1085#1099#1077' '#1087#1088#1077#1076#1086#1087#1083#1072#1090#1099
      ImageIndex = 56
    end
    object actBranchChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actBranchChoiceForm'
      ImageIndex = 60
      FormName = 'TBranch_ObjectForm'
      FormNameParam.Value = 'TBranch_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'BranchId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdate_Branch: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Branch
      StoredProcList = <
        item
          StoredProc = spUpdate_Branch
        end
        item
        end>
      Caption = 'actUpdate_Branch'
      ImageIndex = 60
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
        Value = False
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
          ItemName = 'bbUpdateINN'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChangeNPP_Calc'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_NPP_Null'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateBranch'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReport_Check_NPP'
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
          ItemName = 'bbInsert_isAutoPrepay'
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
          ItemName = 'bbIFin'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbIFinALL'
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
      Action = mactMedocALL
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
    object bbIFin: TdxBarButton
      Action = mactIFin
      Category = 0
    end
    object bbIFinALL: TdxBarButton
      Action = mactIFinALL
      Category = 0
    end
    object bbUpdateINN: TdxBarButton
      Action = macUpdateINN
      Category = 0
    end
    object bbChangeNPP_Calc: TdxBarButton
      Action = macChangeNPP_Calc
      Category = 0
    end
    object bbReport_Check_NPP: TdxBarButton
      Action = actReport_Check_NPP
      Category = 0
    end
    object bbUpdate_NPP_Null: TdxBarButton
      Action = macUpdate_NPP_Null_All
      Category = 0
    end
    object bbInsert_isAutoPrepay: TdxBarButton
      Action = macInsert_isAutoPrepay
      Category = 0
    end
    object bbUpdateBranch: TdxBarButton
      Action = macUpdateBranch
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
        Component = MedocListAction
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
        Value = Null
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
    Left = 880
  end
  object spGetDirectoryNameIFIN: TdsdStoredProc
    StoredProcName = 'gpGetDirectoryNameIFIN'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Directory'
        Value = Null
        Component = IFinListAction
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 512
    Top = 192
  end
  object spUpdate_INN: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_INN'
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
        Name = 'ioINN'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'INN_From'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsINN'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isINN'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 906
    Top = 216
  end
  object spUpdateMI_NPP_calc: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_TaxCorrective_NPP_calc'
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
    Left = 920
    Top = 297
  end
  object spUpdateMI_NPP_Null: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_TaxCorrective_NPP_Null'
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
    Left = 808
    Top = 353
  end
  object spInsert_isAutoPrepay: TdsdStoredProc
    StoredProcName = 'gpInsert_Movement_TaxCorrective_isAutoPrepay'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inStartDate'
        Value = 42705d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 648
    Top = 411
  end
  object spUpdate_Branch: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Tax_Branch'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'MovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'BranchId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 953
    Top = 184
  end
end
