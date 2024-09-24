inherited TaxJournalForm: TTaxJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1053#1072#1083#1086#1075#1086#1074#1099#1077' '#1085#1072#1082#1083#1072#1076#1085#1099#1077'>'
  ClientHeight = 510
  ClientWidth = 1110
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog1
  ExplicitWidth = 1126
  ExplicitHeight = 549
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 77
    Width = 1110
    Height = 433
    TabOrder = 3
    ExplicitTop = 77
    ExplicitWidth = 1110
    ExplicitHeight = 433
    ClientRectBottom = 433
    ClientRectRight = 1110
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1110
      ExplicitHeight = 433
      inherited cxGrid: TcxGrid
        Width = 1110
        Height = 433
        ExplicitWidth = 1110
        ExplicitHeight = 433
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
            Width = 63
          end
          object ReestrKindName: TcxGridDBColumn [1]
            Caption = #1042#1080#1079#1072' '#1074' '#1085#1072#1082#1083#1072#1076#1085#1086#1081
            DataBinding.FieldName = 'ReestrKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1087#1086' '#1088#1077#1077#1089#1090#1088#1091
            Options.Editing = False
            Width = 74
          end
          object BranchName: TcxGridDBColumn [2]
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object IsError: TcxGridDBColumn [3]
            Caption = #1054#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'isError'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 57
          end
          inherited colOperDate: TcxGridDBColumn [4]
            HeaderAlignmentHorz = taCenter
            Width = 57
          end
          inherited colInvNumber: TcxGridDBColumn [5]
            Caption = #8470' '#1076#1086#1082'.'
            Visible = False
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          object InvNumberPartner: TcxGridDBColumn
            Caption = #8470' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'InvNumberPartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 63
          end
          object InvNumber_Master: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1087#1088#1086#1076'.'#1087#1086#1082'.'
            DataBinding.FieldName = 'InvNumber_Master'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 68
          end
          object OperDatePartner_Master: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1086#1082#1091#1087'. ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'OperDatePartner_Master'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1077' '#1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102
            Options.Editing = False
            Width = 80
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
            Width = 75
          end
          object FromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 101
          end
          object ToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 102
          end
          object OKPO_To: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO_To'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object RetailName_To: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName_To'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
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
          object INN_To: TcxGridDBColumn
            Caption = #1048#1053#1053
            DataBinding.FieldName = 'INN_To'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
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
          object UnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1076#1088'.'
            DataBinding.FieldName = 'UnitCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PartnerCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
            DataBinding.FieldName = 'PartnerCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object PartnerName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'PartnerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 78
          end
          object TotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1091' '#1087#1086#1082#1091#1087'.)'
            DataBinding.FieldName = 'TotalCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 62
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 78
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
            Width = 49
          end
          object ContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object ContractName_detail: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'. ('#1076#1077#1090#1072#1083#1100#1085#1086')'
            DataBinding.FieldName = 'ContractName_detail'
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
            Width = 76
          end
          object InvNumberBranch: TcxGridDBColumn
            Caption = #8470' '#1092#1080#1083#1080#1072#1083#1072
            DataBinding.FieldName = 'InvNumberBranch'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Checked: TcxGridDBColumn
            Caption = #1055#1088#1086#1074#1077#1088#1077#1085
            DataBinding.FieldName = 'Checked'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 47
          end
          object IsMedoc: TcxGridDBColumn
            Caption = #1052#1077#1076#1086#1082
            DataBinding.FieldName = 'IsMedoc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object Document: TcxGridDBColumn
            Caption = #1055#1086#1076#1087#1080#1089#1072#1085
            DataBinding.FieldName = 'Document'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 59
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
          object RegisteredNumber: TcxGridDBColumn
            Caption = #8470' '#1074' '#1044#1055#1040
            DataBinding.FieldName = 'InvNumberRegistered'
            HeaderAlignmentVert = vaCenter
            Width = 65
          end
          object DateRegistered: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1088#1077#1075#1080#1089#1090#1088'.'
            DataBinding.FieldName = 'DateRegistered'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 65
          end
          object isCopy: TcxGridDBColumn
            Caption = #1050#1086#1087#1080#1103' '#1074' '#1082#1086#1088#1088#1077#1082#1090'.'
            DataBinding.FieldName = 'isCopy'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 65
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
            Width = 55
          end
          object isDisableNPP: TcxGridDBColumn
            Caption = #1054#1090#1082#1083'. '#1087#1077#1088#1077#1089#1095#1077#1090' '#8470' '#1087'/'#1087
            DataBinding.FieldName = 'isDisableNPP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1082#1083#1102#1095#1080#1090#1100' '#1087#1077#1088#1077#1089#1095#1077#1090' '#8470' '#1087'/'#1087' '#1087#1088#1080' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1080
            Options.Editing = False
            Width = 70
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
    Width = 1110
    Height = 51
    ExplicitWidth = 1110
    ExplicitHeight = 51
    inherited deStart: TcxDateEdit
      EditValue = 42705d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42370d
    end
    object edIsRegisterDate: TcxCheckBox
      Left = 10
      Top = 26
      Action = actRefresh
      Caption = #1055#1077#1088#1080#1086#1076' '#1087#1086' <'#1044#1072#1090#1072' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080'>'
      TabOrder = 4
      Width = 198
    end
    object cxLabel14: TcxLabel
      Left = 416
      Top = 6
      Caption = #1058#1080#1087' '#1076#1083#1103'  '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1103' '#1085#1072#1083#1086#1075'.'#1076#1086#1082'.'
    end
    object edDocumentTaxKind: TcxButtonEdit
      Left = 601
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 6
      Width = 250
    end
    object cxTextEdit1: TcxTextEdit
      Left = 328
      Top = 26
      Enabled = False
      ParentColor = True
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Style.BorderStyle = ebsNone
      TabOrder = 7
      Text = #1047#1072#1075#1088#1091#1079#1082#1072' '#1076#1072#1085#1085#1099#1093' '#1079#1072' '
      Width = 133
    end
    object edLoadData: TcxDateEdit
      Left = 581
      Top = 26
      EditValue = 42121.4513888889d
      Enabled = False
      ParentColor = True
      Style.BorderStyle = ebsNone
      TabOrder = 8
      Width = 135
    end
    object edPeriod: TcxDateEdit
      Left = 459
      Top = 26
      EditValue = 42121d
      Enabled = False
      ParentColor = True
      Properties.DisplayFormat = 'mmmm yyyy'
      Style.BorderStyle = ebsNone
      TabOrder = 9
      Width = 91
    end
    object cxTextEdit2: TcxTextEdit
      Left = 546
      Top = 26
      Enabled = False
      ParentColor = True
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Style.BorderStyle = ebsNone
      TabOrder = 10
      Text = #1073#1099#1083#1072
      Width = 34
    end
    object cxLabel27: TcxLabel
      Left = 922
      Top = 6
      Caption = #1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077':'
    end
    object edJuridicalBasis: TcxButtonEdit
      Left = 1000
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 150
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 179
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 243
  end
  inherited ActionList: TActionList
    Left = 23
    Top = 194
    object MedocListAction: TMedocAction [0]
      Category = 'TaxLib'
      MoveParams = <>
      Caption = 'MedocListAction'
      HeaderDataSet = PrintHeaderCDS
      ItemsDataSet = PrintItemsCDS
      AskFilePath = False
    end
    inherited actMovementItemContainer: TdsdOpenForm
      Enabled = False
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
    object actUpdate_IsUKTZ_new: TdsdExecStoredProc [3]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_IsUKTZ_new
      StoredProcList = <
        item
          StoredProc = spUpdate_IsUKTZ_new
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1053#1086#1074#1099#1081' '#1059#1050#1058#1047' '#1044#1072'/'#1053#1077#1090'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1053#1086#1074#1099#1081' '#1059#1050#1058#1047' '#1044#1072'/'#1053#1077#1090'"'
      ImageIndex = 77
    end
    object actInsert_isAutoPrepay: TdsdExecStoredProc [4]
      Category = 'Prepay'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_isAutoPrepay
      StoredProcList = <
        item
          StoredProc = spInsert_isAutoPrepay
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1053#1072#1082#1083#1072#1076#1085#1099#1077' '#1087#1088#1077#1076#1086#1087#1083#1072#1090#1099
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1053#1072#1082#1083#1072#1076#1085#1099#1077' '#1087#1088#1077#1076#1086#1087#1083#1072#1090#1099
      ImageIndex = 56
    end
    object actChecked: TdsdExecStoredProc [6]
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
    object actDocument: TdsdExecStoredProc [8]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDocument
      StoredProcList = <
        item
          StoredProc = spDocument
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1055#1086#1076#1087#1080#1089#1072#1085' '#1044#1072'/'#1053#1077#1090'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1055#1086#1076#1087#1080#1089#1072#1085' '#1044#1072'/'#1053#1077#1090'"'
      ImageIndex = 33
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
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TTaxForm'
      FormNameParam.Name = 'TTaxForm'
      FormNameParam.Value = 'TTaxForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMask'
          Value = False
          DataType = ftBoolean
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
      ImageIndex = -1
      FormName = 'TTaxForm'
      FormNameParam.Value = 'TTaxForm'
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
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TTaxForm'
      FormNameParam.Name = 'TTaxForm'
      FormNameParam.Value = 'TTaxForm'
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
          Value = False
          DataType = ftBoolean
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
    object actTax: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spTax
      StoredProcList = <
        item
          StoredProc = spTax
        end>
      Caption = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1085#1072#1083#1086#1075#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1085#1072#1083#1086#1075#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 41
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>?'
      InfoAfterExecute = #1047#1072#1074#1077#1088#1096#1077#1085' '#1087#1077#1088#1077#1089#1095#1077#1090' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>.'
    end
    object actPrintTax_Us: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectTax_Us
      StoredProcList = <
        item
          StoredProc = spSelectTax_Us
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ImageIndex = 16
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintItemsSverkaCDS
          UserName = 'frxDBDSverka'
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
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = ''
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTax'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintTax_Client: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectTax_Client
      StoredProcList = <
        item
          StoredProc = spSelectTax_Client
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ImageIndex = 18
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end
        item
          DataSet = PrintItemsSverkaCDS
          UserName = 'frxDBDSverka'
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
      ReportNameParam.Name = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = ''
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTax'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actGetReporNameTax: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReporNameTax
      StoredProcList = <
        item
          StoredProc = spGetReporNameTax
        end>
      Caption = 'actGetReporNameTax'
    end
    object mactPrint_Tax_Client: TMultiAction
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
          Action = actGetReporNameTax
        end
        item
          Action = actPrintTax_Client
        end>
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      ImageIndex = 18
    end
    object mactPrint_Tax_Us: TMultiAction
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
          Action = actGetReporNameTax
        end
        item
          Action = actPrintTax_Us
        end>
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      ImageIndex = 16
    end
    object ExecuteDialog: TExecuteDialog
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
          Value = 41640d
          Component = MasterCDS
          ComponentItem = 'DateRegistered_notNull'
          DataType = ftDateTime
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isElectron'
          Value = False
          Component = MasterCDS
          ComponentItem = 'isElectron'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberRegistered'
          Value = ''
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
    object mactCopyTaxCorrective: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actCopyTaxCorrective
        end>
      View = cxGridDBTableView
      Caption = 
        #1057#1086#1079#1076#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072'> '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1053#1072#1083#1086#1075#1086 +
        #1074#1072#1103'>'
      ImageIndex = 10
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
    object mactCopyTaxCorrectiveList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialog2
        end
        item
          Action = mactCopyTaxCorrective
        end>
      Caption = 
        #1057#1086#1079#1076#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072'> '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1053#1072#1083#1086#1075#1086 +
        #1074#1072#1103'>'
      Hint = 
        #1057#1086#1079#1076#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072'> '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1053#1072#1083#1086#1075#1086 +
        #1074#1072#1103'>'
      ImageIndex = 10
    end
    object ExecuteDialog2: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = 'actDataDialog'
      ImageIndex = 10
      FormName = 'TDataDialogForm'
      FormNameParam.Value = 'TDataDialogForm'
      FormNameParam.DataType = ftDateTime
      FormNameParam.ParamType = ptInputOutput
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = 42705d
          Component = FormParams
          ComponentItem = 'inOperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actCopyTaxCorrective: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spCopyTaxCorrective
      StoredProcList = <
        item
          StoredProc = spCopyTaxCorrective
        end>
      Caption = 'actCopyTaxCorrective'
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
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
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
    object MedocAction: TMedocAction
      Category = 'TaxLib'
      MoveParams = <>
      HeaderDataSet = PrintHeaderCDS
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
      StoredProc = spSelectTax_Client
      StoredProcList = <
        item
          StoredProc = spSelectTax_Client
        end>
      Caption = 'actSelect_Medoc'
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
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1042#1057#1045#1061' '#1085#1072#1083#1086#1075#1086#1074#1099#1093' '#1074' '#1052#1045#1044#1054#1050
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1042#1057#1045#1061' '#1085#1072#1083#1086#1075#1086#1074#1099#1093' '#1074' '#1052#1045#1044#1054#1050
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
      EDI = EDI
      EDIDocType = ediDeclar
      HeaderDataSet = PrintHeaderCDS
      ListDataSet = PrintItemsCDS
    end
    object actSelect_Medoc_list: TdsdExecStoredProc
      Category = 'TaxLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectTax_Client
      StoredProcList = <
        item
          StoredProc = spSelectTax_Client
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
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1042#1057#1045#1061' '#1085#1072#1083#1086#1075#1086#1074#1099#1093' '#1074' IFin'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1042#1057#1045#1061' '#1085#1072#1083#1086#1075#1086#1074#1099#1093' '#1074' IFin'
      ImageIndex = 48
    end
    object IFinListAction: TMedocAction
      Category = 'TaxLib'
      MoveParams = <>
      Caption = 'IFinListAction'
      HeaderDataSet = PrintHeaderCDS
      ItemsDataSet = PrintItemsCDS
      AskFilePath = False
      IsMedoc = False
    end
    object IFinAction: TMedocAction
      Category = 'TaxLib'
      MoveParams = <>
      Caption = 'IFinAction'
      HeaderDataSet = PrintHeaderCDS
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
      Caption = 'mactMEDOCList'
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
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1048#1053#1053
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1048#1053#1053
      ImageIndex = 26
      FormName = 'TMovementString_INNEditForm'
      FormNameParam.Value = 'TMovementString_INNEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inINN'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'INN_To'
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
    object actOpenFormTaxCorrective: TdsdOpenForm
      Category = 'TaxCorrective'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081'>'
      Hint = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081' '#1085#1072#1082#1083#1072#1076#1085#1086#1081'>'
      ImageIndex = 25
      FormName = 'TTaxCorrectiveJournalChoiceForm'
      FormNameParam.Value = 'TTaxCorrectiveJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
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
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumberPartner'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object macInsert_isAutoPrepay: TMultiAction
      Category = 'Prepay'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsert_isAutoPrepay
        end>
      QuestionBeforeExecute = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1099#1077' '#1087#1088#1077#1076#1086#1087#1083#1072#1090#1099' '#1079#1072' '#1074#1099#1073#1088#1072#1085#1085#1099#1081' '#1087#1077#1088#1080#1086#1076'?'
      InfoAfterExecute = #1053#1072#1083#1086#1075#1086#1074#1099#1077' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1085#1099
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1099#1077' '#1087#1088#1077#1076#1086#1087#1083#1072#1090#1099
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1099#1077' '#1087#1088#1077#1076#1086#1087#1083#1072#1090#1099
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
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 139
  end
  inherited MasterCDS: TClientDataSet
    Top = 139
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Tax'
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
          ItemName = 'bbTax'
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
          ItemName = 'bbMovementCheck'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenFormTaxCorrective'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChange'
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
          ItemName = 'bbCopyTaxCorrective'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbPrintTax_Client'
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
    object bbTax: TdxBarButton
      Action = actTax
      Category = 0
    end
    object bbPrintTax_Us: TdxBarButton
      Action = mactPrint_Tax_Us
      Category = 0
    end
    object bbPrintTax_Client: TdxBarButton
      Action = mactPrint_Tax_Client
      Category = 0
    end
    object bbMeDoc: TdxBarButton
      Action = mactMeDoc
      Category = 0
    end
    object bbMovementCheck: TdxBarButton
      Action = actMovementCheck
      Category = 0
      ImageIndex = 43
    end
    object bbChecked: TdxBarButton
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
    object bbCopyTaxCorrective: TdxBarButton
      Action = mactCopyTaxCorrectiveList
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
    object bbOpenFormTaxCorrective: TdxBarButton
      Action = actOpenFormTaxCorrective
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
    object bbUpdate_IsUKTZ_new: TdxBarButton
      Action = actUpdate_IsUKTZ_new
      Category = 0
    end
    object bbChange: TdxBarSubItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 85
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbChecked'
        end
        item
          Visible = True
          ItemName = 'bbElectron'
        end
        item
          Visible = True
          ItemName = 'bbMedocFalse'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_IsUKTZ_new'
        end
        item
          Visible = True
          ItemName = 'bbUpdateBranch'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator1'
        end
        item
          Visible = True
          ItemName = 'bbUpdateINN'
        end>
    end
    object dxBarSeparator1: TdxBarSeparator
      Caption = 'Separator'
      Category = 0
      Hint = 'Separator'
      Visible = ivAlways
      ShowCaption = False
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
    StoredProcName = 'gpComplete_Movement_Tax'
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
    StoredProcName = 'gpUnComplete_Movement_Tax'
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
    StoredProcName = 'gpSetErased_Movement_Tax'
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
        Name = 'inOperDate'
        Value = 42705d
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 312
    Top = 168
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_Tax'
    Left = 368
    Top = 168
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 628
    Top = 305
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 628
    Top = 358
  end
  object spSelectTax_Client: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Tax_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintItemsSverkaCDS
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
    Left = 535
    Top = 304
  end
  object spSelectTax_Us: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Tax_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintItemsSverkaCDS
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
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 535
    Top = 360
  end
  object spGetReporNameTax: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Tax_ReportName'
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
        Name = 'gpGet_Movement_Tax_ReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameTax'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 560
    Top = 224
  end
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 620
    Top = 422
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
    Left = 688
    Top = 8
  end
  object spTax: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Tax_From_Kind'
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
        ComponentItem = 'TaxKindId'
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
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInvNumberPartner_Master'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InvNumberPartner'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDocumentTaxKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TaxKindId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDocumentTaxKindName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TaxKindName'
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
    Left = 288
    Top = 419
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
    Left = 232
    Top = 435
  end
  object spDocument: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementBoolean_Document'
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
        Name = 'inDocument'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Document'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 328
    Top = 451
  end
  object EDI: TEDI
    ConnectionParams.Host.Value = Null
    ConnectionParams.Host.MultiSelectSeparator = ','
    ConnectionParams.User.Value = Null
    ConnectionParams.User.MultiSelectSeparator = ','
    ConnectionParams.Password.Value = Null
    ConnectionParams.Password.MultiSelectSeparator = ','
    SendToFTP = False
    Left = 776
    Top = 192
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
    Top = 112
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
    Left = 904
    Top = 272
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
        Value = False
        Component = MasterCDS
        ComponentItem = 'isMedoc'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 824
    Top = 307
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
    Top = 8
  end
  object spSelectTax_Medoc: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Tax_Medoc'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end
      item
        DataSet = PrintItemsSverkaCDS
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
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 535
    Top = 416
  end
  object spCopyTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpInsert_Movement_TaxCorrective_Tax'
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
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
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
    Left = 201
    Top = 298
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
    Left = 991
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
    Left = 976
    Top = 16
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
        ComponentItem = 'Directory'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 528
    Top = 176
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
        Value = ''
        Component = MasterCDS
        ComponentItem = 'INN_To'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsINN'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isINN'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 994
    Top = 200
  end
  object spInsert_isAutoPrepay: TdsdStoredProc
    StoredProcName = 'gpInsert_Movement_Tax_isAutoPrepay'
    DataSets = <>
    OutputType = otResult
    Params = <
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
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 416
    Top = 403
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
    Left = 905
    Top = 192
  end
  object spUpdate_IsUKTZ_new: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Tax_UKTZ_new'
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
        Name = 'ioIsUKTZ_new'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isUKTZ_new'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1000
    Top = 296
  end
end
