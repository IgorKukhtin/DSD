inherited SaleJournalForm: TSaleJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' ('#1074#1089#1077')>'
  ClientHeight = 641
  ClientWidth = 1374
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1390
  ExplicitHeight = 680
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 81
    Width = 1374
    Height = 475
    TabOrder = 3
    ExplicitTop = 81
    ExplicitWidth = 1374
    ExplicitHeight = 475
    ClientRectBottom = 475
    ClientRectRight = 1374
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1374
      ExplicitHeight = 475
      inherited cxGrid: TcxGrid
        Width = 1374
        Height = 475
        ExplicitWidth = 1374
        ExplicitHeight = 475
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
              Column = TotalCountPartner
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
              Format = ',0.####'
              Kind = skSum
              Column = TotalCountTare
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCountSh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCountKg
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummCurrency
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummChange
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
              Column = TotalCountPartner
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
              Format = ',0.####'
              Kind = skSum
              Column = TotalCountTare
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCountSh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalCountKg
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummCurrency
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummChange
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = ToName
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
            Caption = '*'#1057#1090#1072#1090#1091#1089
            Properties.Items = <
              item
                Description = '***'#1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 32
                Value = 1
              end
              item
                Description = #1055#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 12
                Value = 2
              end
              item
                Description = #1059#1076#1072#1083#1077#1085
                ImageIndex = 13
                Value = 3
              end
              item
                Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 11
                Value = 4
              end>
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          object ReestrKindName: TcxGridDBColumn [1]
            Caption = #1042#1080#1079#1072' '#1074' '#1085#1072#1082#1083#1072#1076#1085#1086#1081
            DataBinding.FieldName = 'ReestrKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1087#1086' '#1088#1077#1077#1089#1090#1088#1091
            Width = 74
          end
          inherited colOperDate: TcxGridDBColumn [2]
            Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          object OperDatePartner: TcxGridDBColumn [3]
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'OperDatePartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          inherited colInvNumber: TcxGridDBColumn [4]
            Caption = #8470' '#1076#1086#1082'.'
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          object InvNumberPartner_Master: TcxGridDBColumn
            Caption = #8470' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'InvNumberPartner_Master'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object DocumentTaxKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
            DataBinding.FieldName = 'DocumentTaxKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object InvNumberPartner: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'InvNumberPartner'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object InvNumberOrder: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1079#1072#1103#1074#1082#1072
            DataBinding.FieldName = 'InvNumberOrder'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object InvNumber_ReturnInFull: TcxGridDBColumn
            Caption = #1053#1072' '#1086#1089#1085'. '#8470' ('#1074#1086#1079#1074#1088#1072#1090')'
            DataBinding.FieldName = 'InvNumber_ReturnInFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#8470' ('#1074#1086#1079#1074#1088#1072#1090')'
            Options.Editing = False
            Width = 78
          end
          object InvNumber_TransportGoods: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1058#1058#1053
            DataBinding.FieldName = 'InvNumber_TransportGoods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperDate_TransportGoods: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1058#1058#1053
            DataBinding.FieldName = 'OperDate_TransportGoods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PersonalDriverName_TTN: TcxGridDBColumn
            Caption = #1042#1086#1076#1080#1090#1077#1083#1100' '#1058#1058#1053
            DataBinding.FieldName = 'PersonalDriverName_TTN'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PersonalName_4_TTN: TcxGridDBColumn
            Caption = #1050#1083#1072#1076#1086#1074#1097#1080#1080#1082' '#1058#1058#1053
            DataBinding.FieldName = 'PersonalName_4_TTN'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object FromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object ToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object isPav: TcxGridDBColumn
            Caption = #1055#1072#1074#1080#1083#1100#1086#1085#1099
            DataBinding.FieldName = 'isPav'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object OKPO_To: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO_To'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object JuridicalName_To: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName_To'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object RetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalCount: TcxGridDBColumn
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
          object TotalCountPartner: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1091' '#1087#1086#1082#1091#1087'.)'
            DataBinding.FieldName = 'TotalCountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object TotalCountTare: TcxGridDBColumn
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
          object TotalCountSh: TcxGridDBColumn
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
          object TotalCountKg: TcxGridDBColumn
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
          object TotalSummChange: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' (-)'#1089#1082'.(+)'#1085#1072#1094
            DataBinding.FieldName = 'TotalSummChange'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object TotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSummCurrency: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074' '#1074#1072#1083#1102#1090#1077' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'TotalSummCurrency'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object ChangePercent: TcxGridDBColumn
            Caption = '(-)% '#1089#1082'. (+)% '#1085#1072#1094
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object PriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'PriceWithVAT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object VATPercent: TcxGridDBColumn
            Caption = '% '#1053#1044#1057
            DataBinding.FieldName = 'VATPercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
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
            Width = 80
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
            Width = 80
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object ContractCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
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
            Width = 60
          end
          object PaymentDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaymentDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PriceListName: TcxGridDBColumn
            Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
            DataBinding.FieldName = 'PriceListName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object PriceListInName: TcxGridDBColumn
            Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' '#1074#1093'.'
            DataBinding.FieldName = 'PriceListInName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' '#1074#1093'. ('#1089#1093#1077#1084#1072' '#1055#1072#1074#1080#1083#1100#1086#1085#1099')'
            Width = 80
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
            Width = 80
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object PersonalName: TcxGridDBColumn
            Caption = #1069#1082#1089#1087#1077#1076#1080#1090#1086#1088' ('#1079#1072#1103#1074#1082#1072')'
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object RouteGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1084'. / '#1052#1072#1088#1096#1088#1091#1090
            DataBinding.FieldName = 'RouteGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object RouteName: TcxGridDBColumn
            Caption = #1052#1072#1088#1096#1088#1091#1090
            DataBinding.FieldName = 'RouteName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object InvNumber_Transport: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1055'.'#1083'.'
            DataBinding.FieldName = 'InvNumber_Transport'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1044#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
            Options.Editing = False
            Width = 61
          end
          object OperDate_Transport: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1055'.'#1083'.'
            DataBinding.FieldName = 'OperDate_Transport'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1044#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1088#1086#1076#1072#1078#1080
            Options.Editing = False
            Width = 70
          end
          object CarModelName: TcxGridDBColumn
            Caption = #1052#1072#1088#1082'a '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
            DataBinding.FieldName = 'CarModelName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1091#1090#1077#1074#1086#1081' '#1051#1080#1089#1090
            Options.Editing = False
            Width = 89
          end
          object CarName: TcxGridDBColumn
            Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
            DataBinding.FieldName = 'CarName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1091#1090#1077#1074#1086#1081' '#1051#1080#1089#1090
            Options.Editing = False
            Width = 80
          end
          object PersonalDriverName: TcxGridDBColumn
            Caption = #1042#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'PersonalDriverName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1055#1091#1090#1077#1074#1086#1081' '#1051#1080#1089#1090
            Options.Editing = False
            Width = 70
          end
          object isCurrencyUser: TcxGridDBColumn
            Caption = #1056#1091#1095#1085#1086#1081' '#1074#1074#1086#1076' '#1082#1091#1088#1089#1072
            DataBinding.FieldName = 'isCurrencyUser'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object CurrencyPartnerValue: TcxGridDBColumn
            Caption = #1050#1091#1088#1089
            DataBinding.FieldName = 'CurrencyPartnerValue'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ParPartnerValue: TcxGridDBColumn
            Caption = #1053#1086#1084#1080#1085#1072#1083
            DataBinding.FieldName = 'ParPartnerValue'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object CurrencyValue: TcxGridDBColumn
            Caption = #1050#1091#1088#1089' '#1059#1055
            DataBinding.FieldName = 'CurrencyValue'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ParValue: TcxGridDBColumn
            Caption = #1053#1086#1084#1080#1085#1072#1083' '#1082#1091#1088#1089' '#1059#1055
            DataBinding.FieldName = 'ParValue'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object CurrencyDocumentName: TcxGridDBColumn
            Caption = #1042#1072#1083#1102#1090#1072' ('#1094#1077#1085#1072')'
            DataBinding.FieldName = 'CurrencyDocumentName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 54
          end
          object CurrencyPartnerName: TcxGridDBColumn
            Caption = #1042#1072#1083#1102#1090#1072' ('#1087#1086#1082'.)'
            DataBinding.FieldName = 'CurrencyPartnerName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 54
          end
          object Checked: TcxGridDBColumn
            Caption = #1055#1088#1086#1074#1077#1088#1077#1085
            DataBinding.FieldName = 'Checked'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 36
          end
          object isTotalSumm_GoodsReal: TcxGridDBColumn
            Caption = #1056#1072#1089#1095'. '#1087#1086' '#1089#1093'. '#1058#1086#1074#1072#1088' ('#1092#1072#1082#1090')'
            DataBinding.FieldName = 'isTotalSumm_GoodsReal'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090' '#1089#1091#1084#1084#1099' '#1087#1086' '#1089#1093#1077#1084#1077' - '#1058#1086#1074#1072#1088' ('#1092#1072#1082#1090')'
            Options.Editing = False
            Width = 85
          end
          object IsEDI: TcxGridDBColumn
            Caption = 'EXITE'
            DataBinding.FieldName = 'isEDI'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
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
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
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
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076#1072#1085#1080#1077' '#1101#1082#1089#1087'.)'
            DataBinding.FieldName = 'InsertDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object InsertDate_order: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'. '#1079#1072#1103#1074#1082#1072')'
            DataBinding.FieldName = 'InsertDate_order'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object InsertDatediff_min: TcxGridDBColumn
            Caption = #1054#1090#1082#1083'. '#1084#1080#1085' ('#1089#1086#1079#1076'. '#1087#1088#1086#1076'. '#1080' '#1079#1072#1103#1074#1082#1072')'
            DataBinding.FieldName = 'InsertDatediff_min'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1074'  '#1084#1080#1085#1091#1090#1072#1093' ('#1089#1086#1079#1076#1072#1085#1080#1077' '#1087#1088#1086#1076#1072#1078#1080' '#1080' '#1079#1072#1103#1074#1082#1080')'
            Options.Editing = False
            Width = 107
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object MovementId_Order: TcxGridDBColumn
            DataBinding.FieldName = 'MovementId_Order'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            VisibleForCustomization = False
            Width = 20
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
          object InvNumber_ProductionFull: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1087#1077#1088#1077#1089#1086#1088#1090
            DataBinding.FieldName = 'InvNumber_ProductionFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 108
          end
          object isPrinted: TcxGridDBColumn
            Caption = #1056#1072#1089#1087#1077#1095#1072#1090#1072#1085
            DataBinding.FieldName = 'isPrinted'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
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
            Width = 89
          end
          object BranchName_Collation: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083' ('#1089#1086#1090#1088'. '#1089#1074#1077#1088#1082#1072')'
            DataBinding.FieldName = 'BranchName_Collation'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object IsError: TcxGridDBColumn
            Caption = #1054#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'isError'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 44
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1374
    Height = 55
    ExplicitWidth = 1374
    ExplicitHeight = 55
    inherited deStart: TcxDateEdit
      Left = 98
      EditValue = 42614d
      ExplicitLeft = 98
    end
    inherited deEnd: TcxDateEdit
      Left = 299
      EditValue = 42614d
      ExplicitLeft = 299
    end
    inherited cxLabel1: TcxLabel
      Left = 7
      ExplicitLeft = 7
    end
    inherited cxLabel2: TcxLabel
      Left = 189
      ExplicitLeft = 189
    end
    object edIsPartnerDate: TcxCheckBox
      Left = 7
      Top = 27
      Action = actRefresh
      Caption = #1055#1077#1088#1080#1086#1076' '#1076#1083#1103' <'#1044#1072#1090#1072' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      TabOrder = 4
      Width = 203
    end
    object cxLabel14: TcxLabel
      Left = 394
      Top = 31
      Caption = #1058#1080#1087' '#1076#1083#1103'  '#1085#1072#1083#1086#1075'.'#1076#1086#1082'.:'
    end
    object edDocumentTaxKind: TcxButtonEdit
      Left = 505
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 6
      Width = 187
    end
    object cxLabel3: TcxLabel
      Left = 394
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' <'#1050#1086#1084#1091'>:'
    end
    object edTo: TcxButtonEdit
      Left = 526
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 8
      Width = 166
    end
    object cxLabel27: TcxLabel
      Left = 934
      Top = 5
      Caption = #1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077':'
    end
    object edJuridicalBasis: TcxButtonEdit
      Left = 1016
      Top = 3
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 150
    end
    object edInvNumberTransport: TcxButtonEdit
      Left = 794
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 372
    end
    object cxLabel30: TcxLabel
      Left = 711
      Top = 31
      Caption = #1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090':'
    end
  end
  object ExportXmlGrid: TcxGrid [2]
    Left = 0
    Top = 556
    Width = 1374
    Height = 85
    Align = alBottom
    TabOrder = 6
    Visible = False
    object ExportXmlGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = ExportDS
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.IncSearch = True
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsView.CellAutoHeight = True
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.Header = False
      object RowData: TcxGridDBColumn
        DataBinding.FieldName = 'RowData'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 100
      end
    end
    object ExportXmlGridLevel: TcxGridLevel
      GridView = ExportXmlGridDBTableView
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 539
    Top = 371
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
    Left = 15
    Top = 194
    object actPrintBoxTotalPartner: TdsdPrintAction [0]
      Category = 'Print'
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
      StoredProc = spSelectPrintBox_PartnerTotal
      StoredProcList = <
        item
          StoredProc = spSelectPrintBox_PartnerTotal
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1048#1090#1086#1075#1086' '#1075#1086#1092#1088#1086#1090#1072#1088#1072' ('#1087#1086' '#1076#1072#1090#1077' '#1087#1086#1082'.)'
      Hint = #1055#1077#1095#1072#1090#1100' '#1048#1090#1086#1075#1086' '#1075#1086#1092#1088#1086#1090#1072#1088#1072' ('#1087#1086' '#1076#1072#1090#1077' '#1087#1086#1082'.)'
      ImageIndex = 19
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
      ReportName = 'PrintMovement_SalePackWeightTotal'
      ReportNameParam.Value = 'PrintMovement_SalePackWeightTotal'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Quality_ReportName_list: TdsdExecStoredProc [1]
      Category = 'Group_TTN_Quality'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReportNameQuality_list
      StoredProcList = <
        item
          StoredProc = spGetReportNameQuality_list
        end>
      Caption = 'actPrint_Quality_ReportName'
    end
    object actPrintBoxTotal: TdsdPrintAction [2]
      Category = 'Print'
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
      StoredProc = spSelectPrintBoxTotal
      StoredProcList = <
        item
          StoredProc = spSelectPrintBoxTotal
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1043#1086#1092#1088#1086#1090#1072#1088#1099' ('#1087#1086' '#1082#1083#1080#1077#1085#1090#1091')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1043#1086#1092#1088#1086#1090#1072#1088#1099' ('#1087#1086' '#1082#1083#1080#1077#1085#1090#1091')'
      ImageIndex = 21
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
      ReportName = 'PrintMovement_SalePackWeightTotal'
      ReportNameParam.Value = 'PrintMovement_SalePackWeightTotal'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintSaleOrderTax: TdsdPrintAction [3]
      Category = 'Print'
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
      StoredProc = spSelectPrint_SaleOrderTax
      StoredProcList = <
        item
          StoredProc = spSelectPrint_SaleOrderTax
        end>
      Caption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1085#1072' %'
      Hint = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1085#1072' %'
      ImageIndex = 18
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName;GoodsKindName;PartionGoods'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Sale_Order'
      ReportNameParam.Value = 'PrintMovement_Sale_Order'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object macUpdate_PriceList: TMultiAction [4]
      Category = 'UpdatePriceList'
      MoveParams = <>
      ActionList = <
        item
          Action = actOpenChoicePriceList
        end
        item
          Action = macUpdate_PriceList_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1054#1073#1085#1086#1074#1080#1090#1100' '#1094#1077#1085#1099' '#1087#1086' '#1055#1088#1072#1081#1089#1091' '#1074' '#1074#1099#1073#1088#1072#1085#1085#1099#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1093'?'
      InfoAfterExecute = #1042' '#1074#1099#1073#1088#1072#1085#1085#1099#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1093' '#1091#1089#1087#1077#1096#1085#1086' '#1086#1073#1085#1086#1074#1083#1077#1085#1099' '#1094#1077#1085#1099
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1094#1077#1085#1099' '#1087#1086' '#1055#1088#1072#1081#1089#1091
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1094#1077#1085#1099' '#1087#1086' '#1055#1088#1072#1081#1089#1091
      ImageIndex = 56
    end
    object macUpdate_PriceList_list: TMultiAction [5]
      Category = 'UpdatePriceList'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_PriceList
        end>
      View = cxGridDBTableView
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1094#1077#1085#1099' '#1087#1086' '#1055#1088#1072#1081#1089#1091
      ImageIndex = 56
    end
    object actPrint_QualityDoc_list: TdsdPrintAction [6]
      Category = 'Group_TTN_Quality'
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
      StoredProc = spSelectPrint_Quality_list
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Quality_list
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
      Hint = #1055#1077#1095#1072#1090#1100' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
      WithOutPreview = True
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'QualityCode;GoodsGroupName;GoodsName;GoodsKindName'
        end
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDMaster2'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Quality'
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameQuality'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actUpdate_PriceList: TdsdExecStoredProc [7]
      Category = 'UpdatePriceList'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_PriceList
      StoredProcList = <
        item
          StoredProc = spUpdate_PriceList
        end>
      Caption = 'actUpdate_PriceList'
      ImageIndex = 56
    end
    object macPrint_TTN_Copy1_list: TMultiAction [8]
      Category = 'Group_TTN_Quality'
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
          Action = actSPPrintTTNProcName_list
        end
        item
          Action = actPrint_TTN_copy1_list
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053
      Hint = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053
      ImageIndex = 15
    end
    object actInsertUpdate_Quality_byTransport: TdsdExecStoredProc [9]
      Category = 'Group_TTN_Quality'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_Quality_byTransport
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_Quality_byTransport
        end>
      Caption = 'InsertUpdate_Quality_byTransport'
      Hint = 'InsertUpdate_TTN_byTransport'
    end
    object mactPrint_Sale_list: TMultiAction [10]
      Category = 'Group_TTN_Quality'
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
          Action = actSPPrintSaleProcName
        end
        item
          Action = actPrint
        end
        item
          Action = actSPSavePrintState
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1053#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1053#1072#1082#1083#1072#1076#1085#1072#1103
      ImageIndex = 3
      ShortCut = 16464
    end
    object actSPPrintTTNProcName_list: TdsdExecStoredProc [11]
      Category = 'Group_TTN_Quality'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReporNameTTN
      StoredProcList = <
        item
          StoredProc = spGetReporNameTTN
        end>
      Caption = 'actSPPrintTTNProcName_list'
    end
    object actInsertUpdate_TTN_byTransport: TdsdExecStoredProc [12]
      Category = 'Group_TTN_Quality'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_TTN_byTransport
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_TTN_byTransport
        end>
      Caption = 'InsertUpdate_TTN_byTransport'
    end
    object macPrint_TTN_final: TMultiAction [13]
      Category = 'Print_TTN'
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
          Action = actSPPrintTTNProcName
        end
        item
          Action = actPrint_TTN_final
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1080#1090#1086#1075#1086#1074#1086#1081' '#1058#1058#1053
      Hint = #1055#1077#1095#1072#1090#1100' '#1080#1090#1086#1075#1086#1074#1086#1081' '#1058#1058#1053
      ImageIndex = 15
    end
    object actPrintReturnInDay_2copy: TdsdPrintAction [14]
      Category = 'Group_TTN_Quality'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrintReturnInDay
      StoredProcList = <
        item
          StoredProc = spSelectPrintReturnInDay
        end>
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1079#1072' '#1076#1072#1090#1091
      Hint = #1042#1086#1079#1074#1088#1072#1090' '#1079#1072' '#1076#1072#1090#1091
      ImageIndex = 19
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'Id;GoodsName'
        end>
      CopiesCount = 2
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_ReturnInDay'
      ReportNameParam.Value = 'PrintMovement_ReturnInDay'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object macPrintPack_2copy: TMultiAction [15]
      Category = 'Group_TTN_Quality'
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
          Action = actSPPrintSaleProcName
        end
        item
          Action = actPrintPack_2copy
        end
        item
          Action = actSPSavePrintState
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
    end
    object actPrint_TTN_final: TdsdPrintAction [16]
      Category = 'Print_TTN'
      MoveParams = <>
      StoredProc = spSelectPrint_TTN_final
      StoredProcList = <
        item
          StoredProc = spSelectPrint_TTN_final
        end>
      Caption = 'actPrint_TTN'
      Hint = 'actPrint_TTN'
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
      ReportName = 'PrintMovement_TTN'
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTTN'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_TTN_copy1_list: TdsdPrintAction [17]
      Category = 'Group_TTN_Quality'
      MoveParams = <>
      StoredProc = spSelectPrint_TTN
      StoredProcList = <
        item
          StoredProc = spSelectPrint_TTN
        end>
      Caption = 'actPrint_TTN'
      Hint = 'actPrint_TTN'
      WithOutPreview = True
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
      ReportName = 'PrintMovement_TTN'
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTTN'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintPack_2copy: TdsdPrintAction [18]
      Category = 'Group_TTN_Quality'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      WithOutPreview = True
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
      CopiesCount = 2
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Sale1_test'
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = 'PrintMovement_Sale1_test'
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSale'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object macPrintPack_3copy: TMultiAction [19]
      Category = 'Group_TTN_Quality'
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
          Action = actSPPrintSaleProcName
        end
        item
          Action = actPrintPack_3copy
        end
        item
          Action = actSPSavePrintState
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
    end
    object macPrint_TTN_Copy3_list: TMultiAction [20]
      Category = 'Group_TTN_Quality'
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
          Action = actSPPrintTTNProcName_list
        end
        item
          Action = actPrint_TTN_copy3_list
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053' (3 '#1082#1086#1087#1080#1080')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053
      ImageIndex = 15
    end
    object actPrint_TTN_copy3_list: TdsdPrintAction [21]
      Category = 'Group_TTN_Quality'
      MoveParams = <>
      StoredProc = spSelectPrint_TTN
      StoredProcList = <
        item
          StoredProc = spSelectPrint_TTN
        end>
      Caption = 'actPrint_TTN'
      Hint = 'actPrint_TTN'
      WithOutPreview = True
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      CopiesCount = 3
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_TTN'
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTTN'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintPack_3copy: TdsdPrintAction [22]
      Category = 'Group_TTN_Quality'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      WithOutPreview = True
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
      CopiesCount = 3
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Sale1_test'
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = 'PrintMovement_Sale1_test'
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSale'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object macPrint_QualityDoc_list: TMultiAction [23]
      Category = 'Group_TTN_Quality'
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
          Action = actPrint_Quality_ReportName_list
        end
        item
          Action = actPrint_QualityDoc_list
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
      Hint = #1055#1077#1095#1072#1090#1100' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
      ImageIndex = 16
    end
    object macPrint_TTN_Copy2_list: TMultiAction [24]
      Category = 'Group_TTN_Quality'
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
          Action = actSPPrintTTNProcName_list
        end
        item
          Action = actPrint_TTN_copy2_list
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053
      Hint = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053
      ImageIndex = 15
    end
    object actPrint_TTN_copy2_list: TdsdPrintAction [25]
      Category = 'Group_TTN_Quality'
      MoveParams = <>
      StoredProc = spSelectPrint_TTN
      StoredProcList = <
        item
          StoredProc = spSelectPrint_TTN
        end>
      Caption = 'actPrint_TTN'
      Hint = 'actPrint_TTN'
      WithOutPreview = True
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      CopiesCount = 2
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_TTN'
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTTN'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object macPrint_Group_list_cash_Ret: TMultiAction [26]
      Category = 'Group_TTN_Quality'
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
          Action = actInsertUpdate_Quality_byTransport
        end
        item
          Action = macPrintPack_2copy
        end
        item
          Action = macPrint_QualityDoc_list
        end
        item
          Action = actPrintReturnInDay_2copy
        end
        item
          Action = actUpdatePrintAuto_True
        end>
      View = cxGridDBTableView
      Caption = #1055#1077#1095#1072#1090#1100' '#1074' '#1087#1072#1082#1077#1090#1077
      Hint = #1055#1077#1095#1072#1090#1100' '#1074' '#1087#1072#1082#1077#1090#1077
      ImageIndex = 44
    end
    object macPrint_Group_list: TMultiAction [27]
      Category = 'Group_TTN_Quality'
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
          Action = actInsertUpdate_TTN_byTransport
        end
        item
          Action = actInsertUpdate_Quality_byTransport
        end
        item
          Action = macPrintPack_2copy
        end
        item
          Action = macPrint_TTN_Copy2_list
        end
        item
          Action = macPrint_QualityDoc_list
        end>
      View = cxGridDBTableView
      Caption = #1055#1077#1095#1072#1090#1100' '#1074' '#1087#1072#1082#1077#1090#1077
      Hint = #1055#1077#1095#1072#1090#1100' '#1074' '#1087#1072#1082#1077#1090#1077
      ImageIndex = 44
    end
    object macPrint_Group_cash: TMultiAction [28]
      Category = 'Group_TTN_Quality'
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
          Action = macPrint_Group_list_cash
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1074#1099#1087#1086#1083#1085#1080#1090#1100' '#1087#1072#1082#1077#1090#1085#1091#1102' '#1087#1077#1095#1072#1090#1100' ('#1089#1086#1079#1076#1072#1085#1080#1077' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1075#1086',' +
        ' '#1087#1077#1095#1072#1090#1100' '#1053#1072#1082#1083#1072#1076#1085#1086#1081'  '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1075#1086')? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1089#1086#1079#1076#1072#1085#1099', '#1087#1077#1095#1072#1090#1100' '#1074#1099#1087#1086#1083#1085#1077#1085#1072
      Caption = #1055#1077#1095#1072#1090#1100' '#1074' '#1087#1072#1082#1077#1090#1077' ('#1053#1040#1051')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1074' '#1087#1072#1082#1077#1090#1077' ('#1053#1040#1051')'
      ImageIndex = 15
    end
    object macPrint_Group_list_cash: TMultiAction [29]
      Category = 'Group_TTN_Quality'
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
          Action = actInsertUpdate_Quality_byTransport
        end
        item
          Action = macPrintPack_2copy
        end
        item
          Action = macPrint_QualityDoc_list
        end>
      View = cxGridDBTableView
      Caption = #1055#1077#1095#1072#1090#1100' '#1074' '#1087#1072#1082#1077#1090#1077
      Hint = #1055#1077#1095#1072#1090#1100' '#1074' '#1087#1072#1082#1077#1090#1077
      ImageIndex = 44
    end
    object macPrint_Group: TMultiAction [30]
      Category = 'Group_TTN_Quality'
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
          Action = macPrint_Group_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1074#1099#1087#1086#1083#1085#1080#1090#1100' '#1087#1072#1082#1077#1090#1085#1091#1102' '#1087#1077#1095#1072#1090#1100' ('#1089#1086#1079#1076#1072#1085#1080#1077' '#1058#1058#1053' '#1080'  '#1050#1072#1095#1077#1089#1090#1074 +
        #1077#1085#1085#1086#1075#1086', '#1087#1077#1095#1072#1090#1100' '#1053#1072#1082#1083#1072#1076#1085#1086#1081', '#1058#1058#1053', '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1075#1086')? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1089#1086#1079#1076#1072#1085#1099', '#1087#1077#1095#1072#1090#1100' '#1074#1099#1087#1086#1083#1085#1077#1085#1072
      Caption = #1055#1077#1095#1072#1090#1100' '#1074' '#1087#1072#1082#1077#1090#1077' ('#1041#1053')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1074' '#1087#1072#1082#1077#1090#1077' ('#1041#1053')'
      ImageIndex = 44
    end
    object macPrint_Group_cash_Ret: TMultiAction [31]
      Category = 'Group_TTN_Quality'
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
          Action = actUpdatePrintAuto_False
        end
        item
          Action = macPrint_Group_list_cash_Ret
        end
        item
          Action = actUpdatePrintAuto_False
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1074#1099#1087#1086#1083#1085#1080#1090#1100' '#1087#1072#1082#1077#1090#1085#1091#1102' '#1087#1077#1095#1072#1090#1100' ('#1089#1086#1079#1076#1072#1085#1080#1077' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1075#1086',' +
        ' '#1087#1077#1095#1072#1090#1100' '#1053#1072#1082#1083#1072#1076#1085#1086#1081', '#1042#1086#1079#1074#1088#1072#1090#1072', '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1075#1086')? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1089#1086#1079#1076#1072#1085#1099', '#1087#1077#1095#1072#1090#1100' '#1074#1099#1087#1086#1083#1085#1077#1085#1072
      Caption = #1055#1077#1095#1072#1090#1100' '#1074' '#1087#1072#1082#1077#1090#1077' + '#1074#1086#1079#1074#1088#1072#1090' ('#1053#1040#1051')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1074' '#1087#1072#1082#1077#1090#1077' + '#1074#1086#1079#1074#1088#1072#1090' ('#1053#1040#1051')'
      ImageIndex = 15
    end
    object actUpdatePrintAuto_True: TdsdExecStoredProc [32]
      Category = 'Group_TTN_Quality'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdatePrintAuto_True
      StoredProcList = <
        item
          StoredProc = spUpdatePrintAuto_True
        end>
      Caption = 'actUpdatePrintAuto_True'
      Hint = #1091#1089#1090#1072#1085#1086#1074#1080#1090#1100' PrintAuto = True'
    end
    object actUpdatePrintAuto_False: TdsdExecStoredProc [33]
      Category = 'Group_TTN_Quality'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdatePrintAuto_False
      StoredProcList = <
        item
          StoredProc = spUpdatePrintAuto_False
        end>
      Caption = 'actUpdatePrintAuto_False'
      Hint = #1091#1089#1090#1072#1085#1086#1074#1080#1090#1100' PrintAuto = False'
    end
    object macPrint_Sale2_TTN_Quality: TMultiAction [34]
      Category = 'Group_TTN_Quality'
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
          Action = macPrint_Sale2_TTN_Quality_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1074#1099#1087#1086#1083#1085#1080#1090#1100' '#1087#1072#1082#1077#1090#1085#1091#1102' '#1087#1077#1095#1072#1090#1100' ('#1089#1086#1079#1076#1072#1085#1080#1077' '#1058#1058#1053' '#1080'  '#1050#1072#1095#1077#1089#1090#1074 +
        #1077#1085#1085#1086#1075#1086', '#1087#1077#1095#1072#1090#1100' 2 '#1053#1072#1082#1083#1072#1076#1085#1099#1093' , '#1058#1058#1053', '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1075#1086')? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1089#1086#1079#1076#1072#1085#1099', '#1087#1077#1095#1072#1090#1100' '#1074#1099#1087#1086#1083#1085#1077#1085#1072
      Caption = #1055#1077#1095#1072#1090#1100' '#1074' '#1087#1072#1082#1077#1090#1077' ('#1041#1053') (2 '#1088#1072#1089#1093#1086#1076'+'#1090#1090#1085'+'#1082#1072#1095#1077#1089#1090#1074')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1074' '#1087#1072#1082#1077#1090#1077' ('#1041#1053') (2 '#1088#1072#1089#1093#1086#1076'+'#1090#1090#1085'+'#1082#1072#1095#1077#1089#1090#1074')'
      ImageIndex = 44
    end
    object macPrint_Sale2_TTN_Quality_list: TMultiAction [35]
      Category = 'Group_TTN_Quality'
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
          Action = actInsertUpdate_TTN_byTransport
        end
        item
          Action = actInsertUpdate_Quality_byTransport
        end
        item
          Action = macPrintPack_2copy
        end
        item
          Action = macPrint_TTN_Copy1_list
        end
        item
          Action = macPrint_QualityDoc_list
        end>
      View = cxGridDBTableView
      Caption = #1055#1077#1095#1072#1090#1100' '#1074' '#1087#1072#1082#1077#1090#1077
      Hint = #1055#1077#1095#1072#1090#1100' '#1074' '#1087#1072#1082#1077#1090#1077
      ImageIndex = 44
    end
    object macPrint_Sale3_TTN_Quality: TMultiAction [36]
      Category = 'Group_TTN_Quality'
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
          Action = macPrint_Sale3_TTN_Quality_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1074#1099#1087#1086#1083#1085#1080#1090#1100' '#1087#1072#1082#1077#1090#1085#1091#1102' '#1087#1077#1095#1072#1090#1100' ('#1089#1086#1079#1076#1072#1085#1080#1077' '#1058#1058#1053' '#1080'  '#1050#1072#1095#1077#1089#1090#1074 +
        #1077#1085#1085#1086#1075#1086', '#1087#1077#1095#1072#1090#1100' 3 '#1053#1072#1082#1083#1072#1076#1085#1099#1093', 3 '#1058#1058#1053', '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1075#1086')? '
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1089#1086#1079#1076#1072#1085#1099', '#1087#1077#1095#1072#1090#1100' '#1074#1099#1087#1086#1083#1085#1077#1085#1072
      Caption = #1055#1077#1095#1072#1090#1100' '#1074' '#1087#1072#1082#1077#1090#1077' ('#1041#1053') (3 '#1088#1072#1089#1093#1086#1076'+3'#1090#1090#1085'+'#1082#1072#1095#1077#1089#1090#1074')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1074' '#1087#1072#1082#1077#1090#1077' ('#1041#1053') (3 '#1088#1072#1089#1093#1086#1076'+3'#1090#1090#1085'+'#1082#1072#1095#1077#1089#1090#1074')'
      ImageIndex = 44
    end
    object macPrint_Sale3_TTN_Quality_list: TMultiAction [37]
      Category = 'Group_TTN_Quality'
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
          Action = actInsertUpdate_TTN_byTransport
        end
        item
          Action = actInsertUpdate_Quality_byTransport
        end
        item
          Action = macPrintPack_3copy
        end
        item
          Action = macPrint_TTN_Copy3_list
        end
        item
          Action = macPrint_QualityDoc_list
        end>
      View = cxGridDBTableView
      Caption = #1055#1077#1095#1072#1090#1100' '#1074' '#1087#1072#1082#1077#1090#1077
      Hint = #1055#1077#1095#1072#1090#1100' '#1074' '#1087#1072#1082#1077#1090#1077
      ImageIndex = 44
    end
    object macRoundAmountPartner: TMultiAction [38]
      Category = 'UpdateAmount'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogUpdateAmountPartner
        end
        item
          Action = macRoundAmountPartner_list
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1054#1082#1088#1091#1075#1083#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' '#1074' '#1074#1099#1073#1088#1072#1085#1085#1099#1093' '#1076#1086#1082#1091#1084#1077#1085#1090 +
        #1072#1093'?'
      InfoAfterExecute = #1042' '#1074#1099#1073#1088#1072#1085#1085#1099#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1093' '#1091#1089#1087#1077#1096#1085#1086' '#1086#1082#1088#1091#1075#1083#1077#1085#1086' '#1082#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'.'
      Caption = #1054#1082#1088#1091#1075#1083#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
      Hint = #1054#1082#1088#1091#1075#1083#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
      ImageIndex = 45
    end
    object actPrintBox: TdsdPrintAction [39]
      Category = 'Print'
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
      StoredProc = spSelectPrintBox
      StoredProcList = <
        item
          StoredProc = spSelectPrintBox
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1043#1086#1092#1088#1086#1090#1072#1088#1099
      Hint = #1055#1077#1095#1072#1090#1100' '#1043#1086#1092#1088#1086#1090#1072#1088#1099
      ImageIndex = 17
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
      ReportName = 'PrintMovement_SalePackWeight'
      ReportNameParam.Value = 'PrintMovement_SalePackWeight'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintSaleOrder: TdsdPrintAction [40]
      Category = 'Print'
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
      StoredProc = spSelectPrint_SaleOrder
      StoredProcList = <
        item
          StoredProc = spSelectPrint_SaleOrder
        end>
      Caption = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072
      Hint = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072
      ImageIndex = 21
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName;GoodsKindName;PartionGoods'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Sale_Order'
      ReportNameParam.Value = 'PrintMovement_Sale_Order'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object mactPrint_Account_List: TMultiAction [41]
      Category = 'Print_Account'
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
          Action = actPrint_Account_ReportName
        end
        item
          Action = actDelete_LockUnique
        end
        item
          Action = macInsert_LockUnique
        end
        item
          Action = actPrint_Account_List
        end>
      QuestionBeforeExecute = #1053#1072#1087#1077#1095#1072#1090#1072#1090#1100' '#1048#1090#1086#1075#1086#1074#1099#1081' '#1089#1095#1077#1090' '#1076#1083#1103' '#1074#1099#1073#1088#1072#1085#1085#1099#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'?'
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090#1072' '#1087#1086' '#1089#1087#1080#1089#1082#1091
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090#1072' '#1087#1086' '#1089#1087#1080#1089#1082#1091
      ImageIndex = 15
    end
    object actUpdateMI_Sale_PriceIn: TdsdExecStoredProc [42]
      Category = 'UpdatePriceIn'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMI_Sale_PriceIn
      StoredProcList = <
        item
          StoredProc = spUpdateMI_Sale_PriceIn
        end>
      Caption = 'actUpdateMI_Sale_PriceIn'
      ImageIndex = 80
    end
    object actPrintPackGross: TdsdPrintAction [43]
      Category = 'Print'
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
      StoredProc = spSelectPrint_Pack
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Pack
        end>
      Caption = #1059#1087#1072#1082'. '#1051#1080#1089#1090' '#1074#1077#1089' '#1041#1056#1059#1058#1058#1054
      Hint = #1059#1087#1072#1082'. '#1051#1080#1089#1090' '#1074#1077#1089' '#1041#1056#1059#1058#1058#1054
      ImageIndex = 16
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'MovementId;WeighingNumber;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_SalePackGross'
      ReportNameParam.Name = 'PrintMovement_SalePackGross'
      ReportNameParam.Value = 'PrintMovement_SalePackGross'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actSPPrintTTNProcName: TdsdExecStoredProc [44]
      Category = 'Print_TTN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReporNameTTN
      StoredProcList = <
        item
          StoredProc = spGetReporNameTTN
        end>
      Caption = 'actSPPrintTTNProcName'
    end
    object actPrintTEST: TdsdPrintAction [45]
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrint_test
      StoredProcList = <
        item
          StoredProc = spSelectPrint_test
        end>
      Caption = 'TEST '#1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = 'TEST '#1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ImageIndex = 37
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
      ReportName = 'PrintMovement_Sale1_test'
      ReportNameParam.Value = 'PrintMovement_Sale1_test'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Account_List: TdsdPrintAction [46]
      Category = 'Print_Account'
      MoveParams = <>
      StoredProc = spSelectPrint_Total_List
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Total_List
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090
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
      ReportNameParam.Name = #1057#1095#1077#1090
      ReportNameParam.Value = ''
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSaleBill'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Quality_ReportName: TdsdExecStoredProc [47]
      Category = 'Print_QualityDoc'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReportNameQuality
      StoredProcList = <
        item
          StoredProc = spGetReportNameQuality
        end>
      Caption = 'actPrint_Quality_ReportName'
    end
    object mactPrint_TTN2: TMultiAction [48]
      Category = 'Print_TTN'
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
          Action = actDialog_TTN
        end
        item
          Action = actGet_TTN
        end
        item
          Action = actSPPrintTTNProcName
        end
        item
          Action = actPrint_TTN2
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053' ('#1073#1088#1091#1090#1090#1086')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053' ('#1073#1088#1091#1090#1090#1086')'
      ImageIndex = 15
    end
    object macInsert_LockUnique: TMultiAction [49]
      Category = 'Print_Total'
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
          Action = actInsert_LockUnique
        end>
      View = cxGridDBTableView
      Caption = #1055#1077#1095#1072#1090#1100' '#1048#1090#1086#1075#1086#1074#1072#1103' '#1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1087#1086' '#1089#1087#1080#1089#1082#1091
      Hint = #1055#1077#1095#1072#1090#1100' '#1048#1090#1086#1075#1086#1074#1072#1103' '#1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1087#1086' '#1089#1087#1080#1089#1082#1091
      ImageIndex = 3
    end
    object actPrint_PackWeight: TdsdPrintAction [50]
      Category = 'Print_Fozzy'
      MoveParams = <
        item
          FromParam.Name = 'Id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'Id'
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
      Caption = #1055#1077#1095#1072#1090#1100' '#1090#1072#1088#1072' ('#1092#1086#1079#1079#1080')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1090#1072#1088#1072' ('#1092#1086#1079#1079#1080')'
      ImageIndex = 19
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
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_SalePackWeight_Fozzy'
      ReportNameParam.Value = 'PrintMovement_SalePackWeight_Fozzy'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object mactPrint_Sale_Total_List: TMultiAction [51]
      Category = 'Print_Total'
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
          Action = actSPPrintSaleProcName
        end
        item
          Action = actDelete_LockUnique
        end
        item
          Action = macInsert_LockUnique
        end
        item
          Action = actPrint_Total_List
        end>
      QuestionBeforeExecute = #1053#1072#1087#1077#1095#1072#1090#1072#1090#1100' '#1048#1090#1086#1075#1086#1074#1091#1102' '#1085#1072#1082#1083#1072#1076#1085#1091#1102' '#1076#1083#1103' '#1074#1099#1073#1088#1072#1085#1085#1099#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'?'
      Caption = #1055#1077#1095#1072#1090#1100' '#1048#1090#1086#1075#1086#1074#1072#1103' '#1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1087#1086' '#1089#1087#1080#1089#1082#1091
      Hint = #1055#1077#1095#1072#1090#1100' '#1048#1090#1086#1075#1086#1074#1072#1103' '#1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1087#1086' '#1089#1087#1080#1089#1082#1091
      ImageIndex = 3
    end
    object actPrint_TTN2: TdsdPrintAction [52]
      Category = 'Print_TTN'
      MoveParams = <>
      StoredProc = spSelectPrint_TTN2
      StoredProcList = <
        item
          StoredProc = spSelectPrint_TTN2
        end>
      Caption = 'actPrint_TTN'
      Hint = 'actPrint_TTN'
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
      ReportName = 'PrintMovement_TTN'
      ReportNameParam.Value = 'PrintMovement_TTN'
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTTN'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object mactPrint_Sale_Total_To: TMultiAction [53]
      Category = 'Print_Total'
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
          Action = actSPPrintSaleProcName
        end
        item
          Action = actPrint_Total_To
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1048#1090#1086#1075#1086#1074#1072#1103' '#1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1076#1083#1103' '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1048#1090#1086#1075#1086#1074#1072#1103' '#1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1076#1083#1103' '#1050#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
      ImageIndex = 3
    end
    object mactPrint_Sale_Total: TMultiAction [54]
      Category = 'Print_Total'
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
          Action = actSPPrintSaleProcName
        end
        item
          Action = actPrint_Total
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1048#1090#1086#1075#1086#1074#1072#1103' '#1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1076#1083#1103' '#1070#1088'.'#1083#1080#1094#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1048#1090#1086#1075#1086#1074#1072#1103' '#1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1076#1083#1103' '#1070#1088'.'#1083#1080#1094#1072
      ImageIndex = 3
    end
    object mactPrint_Sale: TMultiAction [55]
      Category = 'Print'
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
          Action = actSPPrintSaleProcName
        end
        item
          Action = actPrint
        end
        item
          Action = actSPSavePrintState
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1053#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1053#1072#1082#1083#1072#1076#1085#1072#1103
      ImageIndex = 3
      ShortCut = 16464
    end
    object actPrint_Total_To: TdsdPrintAction [56]
      Category = 'Print_Total'
      MoveParams = <>
      StoredProc = spSelectPrint_Total_To
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Total_To
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
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
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSale'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Total_List: TdsdPrintAction [57]
      Category = 'Print_Total'
      MoveParams = <>
      StoredProc = spSelectPrint_Total_List
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Total_List
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1048#1090#1086#1075#1086#1074#1072#1103' '#1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1087#1086' '#1089#1087#1080#1089#1082#1091
      Hint = #1055#1077#1095#1072#1090#1100' '#1048#1090#1086#1075#1086#1074#1072#1103' '#1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1087#1086' '#1089#1087#1080#1089#1082#1091
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
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSale'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Total: TdsdPrintAction [58]
      Category = 'Print_Total'
      MoveParams = <>
      StoredProc = spSelectPrint_Total
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Total
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
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
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSale'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actSPPrintSaleProcName: TdsdExecStoredProc [59]
      Category = 'Print'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReportName
      StoredProcList = <
        item
          StoredProc = spGetReportName
        end>
      Caption = 'actSPPrintSaleProcName'
    end
    object actPrintReturnInDay: TdsdPrintAction [60]
      Category = 'Print'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrintReturnInDay
      StoredProcList = <
        item
          StoredProc = spSelectPrintReturnInDay
        end>
      Caption = #1042#1086#1079#1074#1088#1072#1090' '#1079#1072' '#1076#1072#1090#1091
      Hint = #1042#1086#1079#1074#1088#1072#1090' '#1079#1072' '#1076#1072#1090#1091
      ImageIndex = 19
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'Id;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_ReturnInDay'
      ReportNameParam.Value = 'PrintMovement_ReturnInDay'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actSPSavePrintState: TdsdExecStoredProc [61]
      Category = 'Print'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSavePrintState
      StoredProcList = <
        item
          StoredProc = spSavePrintState
        end>
      Caption = 'actSPSavePrintState'
    end
    object actPrint: TdsdPrintAction [62]
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
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
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSale'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actDelete_LockUnique: TdsdExecStoredProc [63]
      Category = 'Print_Total'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDelete_LockUnique
      StoredProcList = <
        item
          StoredProc = spDelete_LockUnique
        end>
      Caption = 'actDelete_LockUnique'
    end
    object actPrint_Tax_ReportName: TdsdExecStoredProc [64]
      Category = 'Print_Tax'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReporNameTax
      StoredProcList = <
        item
          StoredProc = spGetReporNameTax
        end>
      Caption = 'actPrint_Tax_ReportName'
    end
    object actPrintPack_Transport: TdsdPrintAction [65]
      Category = 'Print_TTN'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1085#1086#1081
      Hint = #1055#1077#1095#1072#1090#1100' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1085#1086#1081
      WithOutPreview = True
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
      ReportNameParam.Name = #1057#1095#1077#1090
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTransport'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object mactPrint_Tax_Us: TMultiAction [66]
      Category = 'Print_Tax'
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
          Action = actPrint_Tax_ReportName
        end
        item
          Action = actPrintTax_Us
        end>
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1088#1086#1076#1072#1074#1077#1094')'
      ImageIndex = 16
    end
    object actPrint_ExpInvoice: TdsdPrintAction [67]
      Category = 'Print_Export'
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
      StoredProc = spSelectPrint_ExpInvoice
      StoredProcList = <
        item
          StoredProc = spSelectPrint_ExpInvoice
        end>
      Caption = #1048#1085#1074#1086#1081#1089' ('#1101#1082#1089#1087#1086#1088#1090')'
      Hint = #1048#1085#1074#1086#1081#1089' ('#1101#1082#1089#1087#1086#1088#1090')'
      ImageIndex = 22
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GroupName_Juridical;GoodsName_Juridical;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_SaleInvoice'
      ReportNameParam.Name = 'PrintMovement_SaleInvoice'
      ReportNameParam.Value = 'PrintMovement_SaleInvoice'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintTax_Us: TdsdPrintAction [68]
      Category = 'Print_Tax'
      MoveParams = <>
      StoredProc = spSelectTax_Us
      StoredProcList = <
        item
          StoredProc = spSelectTax_Us
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
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
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSaleTax'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object macRoundAmountPartner_list: TMultiAction [69]
      Category = 'UpdateAmount'
      MoveParams = <>
      ActionList = <
        item
          Action = actRoundAmountPartner
        end>
      View = cxGridDBTableView
      Caption = #1054#1082#1088#1091#1075#1083#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
      ImageIndex = 45
    end
    object actRoundAmountPartner: TdsdExecStoredProc [70]
      Category = 'UpdateAmount'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MI_AmountPartner_round
      StoredProcList = <
        item
          StoredProc = spUpdate_MI_AmountPartner_round
        end>
      Caption = 'actUpdate_MI_AmountPartner_round'
    end
    object actPrint_Pack: TdsdPrintAction [71]
      Category = 'Print_Fozzy'
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
      StoredProc = spSelectPrint_Pack
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Pack
        end>
      Caption = #1059#1087#1072#1082#1086#1074#1086#1095#1085#1099#1081' '#1083#1080#1089#1090' ('#1060#1086#1079#1079#1080' + '#1040#1096#1072#1085' + '#1076#1088#1091#1075#1080#1077'...)'
      Hint = #1059#1087#1072#1082#1086#1074#1086#1095#1085#1099#1081' '#1083#1080#1089#1090' ('#1060#1086#1079#1079#1080' + '#1040#1096#1072#1085' + '#1076#1088#1091#1075#1080#1077'...)'
      ImageIndex = 23
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'WeighingNumber;NumOrder'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_SalePack21'
      ReportNameParam.Value = 'PrintMovement_SalePack21'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actOpenReportForm: TdsdOpenForm [72]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1080#1074#1103#1079#1082#1080' '#1074#1086#1079#1074#1088#1072#1090#1086#1074' '#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1091' '#1055#1088#1086#1076#1072#1078#1080'>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1088#1080#1074#1103#1079#1082#1080' '#1074#1086#1079#1074#1088#1072#1090#1086#1074' '#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1091' '#1055#1088#1086#1076#1072#1078#1080'>'
      ImageIndex = 25
      FormName = 'TReport_Goods_ReturnInBySaleForm'
      FormNameParam.Value = 'TReport_Goods_ReturnInBySaleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inPartnerId'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'ToId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'ToName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPaidKindId'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'PaidKindId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPaidKindName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'PaidKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsId'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsName'
          Value = #1042#1089#1077' '#1090#1086#1074#1072#1088#1099
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPrice'
          Value = 0.000000000000000000
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inContractId'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'ContractId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inContractName'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'Contractname'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsKindId'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsKindName'
          Value = #1042#1089#1077
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inInvNumber'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actInsert_LockUnique: TdsdExecStoredProc [73]
      Category = 'Print_Total'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_LockUnique
      StoredProcList = <
        item
          StoredProc = spInsert_LockUnique
        end>
      Caption = 'spInsert_LockUnique'
    end
    object actPrint_ExpSpec: TdsdPrintAction [74]
      Category = 'Print_Export'
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
      StoredProc = spSelectPrint_ExpInvoice
      StoredProcList = <
        item
          StoredProc = spSelectPrint_ExpInvoice
        end>
      Caption = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103' ('#1101#1082#1089#1087#1086#1088#1090')'
      Hint = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103' ('#1101#1082#1089#1087#1086#1088#1090')'
      ImageIndex = 22
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'goodsgroupname;GroupName_Juridical;GoodsName_Juridical;GoodsName' +
            ';GoodsKindName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_SaleSpec'
      ReportNameParam.Value = 'PrintMovement_SaleSpec'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object macPrintPack_Transport: TMultiAction [76]
      Category = 'Print_TTN'
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
          Action = actPrint_Transport_ReportName
        end
        item
          Action = actPrintPack_Transport
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
    end
    object macPrintPackList_Transport: TMultiAction [77]
      Category = 'Print_TTN'
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
          Action = macPrintPack_Transport
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1077#1095#1072#1090#1080' '#1087#1072#1082#1077#1090#1072'?'
      Caption = #1055#1072#1082#1077#1090#1085#1072#1103' '#1087#1077#1095#1072#1090#1100' <'#1058#1088#1072#1085#1089#1087#1086#1088#1090#1085#1072#1103'>'
      Hint = #1055#1072#1082#1077#1090#1085#1072#1103' '#1087#1077#1095#1072#1090#1100' <'#1058#1088#1072#1085#1089#1087#1086#1088#1090#1085#1072#1103'>'
      ImageIndex = 20
    end
    object actPrintPack: TdsdPrintAction [78]
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      WithOutPreview = True
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
      ReportNameParam.Name = #1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSale'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actChecked: TdsdExecStoredProc [82]
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
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TSaleForm'
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
          Name = 'inChangePercentAmount'
          Value = Null
          Component = FormParams
          ComponentItem = 'inChangePercentAmount'
          DataType = ftFloat
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TSaleForm'
      FormNameParam.Value = 'TSaleForm'
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
          Name = 'inChangePercentAmount'
          Value = Null
          Component = FormParams
          ComponentItem = 'inChangePercentAmount'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actMovementCheck: TdsdOpenForm [91]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1096#1080#1073#1082#1080
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1086#1096#1080#1073#1082#1080' '#1087#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1091
      ImageIndex = 43
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
    object actTax: TdsdExecStoredProc [100]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spTax
      StoredProcList = <
        item
          StoredProc = spTax
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1085#1072#1083#1086#1075#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1085#1072#1083#1086#1075#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 41
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>?'
      InfoAfterExecute = #1047#1072#1074#1077#1088#1096#1077#1085#1086' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>.'
    end
    object mactPrint_Account: TMultiAction [101]
      Category = 'Print_Account'
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
          Action = actPrint_Account_ReportName
        end
        item
          Action = actPrint_Account
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090
      ImageIndex = 21
    end
    object mactPrint_Tax_Client: TMultiAction [102]
      Category = 'Print_Tax'
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
          Action = actPrint_Tax_ReportName
        end
        item
          Action = actPrintTax_Client
        end>
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      ImageIndex = 18
    end
    object actPrintTax_Client: TdsdPrintAction [103]
      Category = 'Print_Tax'
      MoveParams = <>
      StoredProc = spSelectTax_Client
      StoredProcList = <
        item
          StoredProc = spSelectTax_Client
        end>
      Caption = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
      Hint = #1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
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
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSaleTax'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object ExecuteDialog: TExecuteDialog [104]
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
          Value = Null
          Component = edIsPartnerDate
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object mactPrint_Transport: TMultiAction [105]
      Category = 'Print_TTN'
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
          Action = actPrint_Transport_ReportName
        end
        item
          Action = actPrint_Transport
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1085#1086#1081
      Hint = #1055#1077#1095#1072#1090#1100' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1085#1086#1081
      ImageIndex = 20
    end
    object actPrint_Account: TdsdPrintAction [106]
      Category = 'Print_Account'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090
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
      ReportNameParam.Name = #1057#1095#1077#1090
      ReportNameParam.Value = ''
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameSaleBill'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Transport: TdsdPrintAction [107]
      Category = 'Print_TTN'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1085#1086#1081
      Hint = #1055#1077#1095#1072#1090#1100' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1085#1086#1081
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
      ReportNameParam.Name = #1057#1095#1077#1090
      ReportNameParam.Value = ''
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTransport'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Account_ReportName: TdsdExecStoredProc [108]
      Category = 'Print_Account'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReporNameBill
      StoredProcList = <
        item
          StoredProc = spGetReporNameBill
        end>
      Caption = 'actPrint_Account_ReportName'
    end
    object actPrint_Transport_ReportName: TdsdExecStoredProc [109]
      Category = 'Print_TTN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReportNameTransport
      StoredProcList = <
        item
          StoredProc = spGetReportNameTransport
        end>
      Caption = 'actPrint_Transport_ReportName'
    end
    object actPrint_ExpPack: TdsdPrintAction [110]
      Category = 'Print_Export'
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
      StoredProc = spSelectPrint_ExpPack
      StoredProcList = <
        item
          StoredProc = spSelectPrint_ExpPack
        end>
      Caption = #1059#1087#1072#1082#1086#1074#1086#1095#1085#1099#1081' '#1083#1080#1089#1090' ('#1101#1082#1089#1087#1086#1088#1090')'
      Hint = #1059#1087#1072#1082#1086#1074#1086#1095#1085#1099#1081' '#1083#1080#1089#1090' ('#1101#1082#1089#1087#1086#1088#1090')'
      ImageIndex = 20
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GroupName_Juridical;GoodsName_Juridical;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_SalePack'
      ReportNameParam.Name = 'PrintMovement_SalePack'
      ReportNameParam.Value = 'PrintMovement_SalePack'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Spec: TdsdPrintAction [111]
      Category = 'Print_Fozzy'
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
      StoredProc = spSelectPrint_Spec
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Spec
        end>
      Caption = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103' ('#1092#1086#1079#1079#1080')'
      Hint = #1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103' ('#1092#1086#1079#1079#1080')'
      ImageIndex = 17
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'WeighingNumber;BoxNumber;NumOrder'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_SalePack22'
      ReportNameParam.Value = 'PrintMovement_SalePack22'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_QualityDoc: TdsdPrintAction
      Category = 'Print_QualityDoc'
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
      StoredProc = spSelectPrint_Quality
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Quality
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
      Hint = #1055#1077#1095#1072#1090#1100' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'QualityCode;GoodsGroupName;GoodsName;GoodsKindName'
        end
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDMaster2'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Quality'
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameQuality'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object mactPrint_TTN: TMultiAction
      Category = 'Print_TTN'
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
          Action = actDialog_TTN
        end
        item
          Action = actGet_TTN
        end
        item
          Action = actSPPrintTTNProcName
        end
        item
          Action = actPrint_TTN
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053
      Hint = #1055#1077#1095#1072#1090#1100' '#1058#1058#1053
      ImageIndex = 15
    end
    object actDialog_TTN: TdsdOpenForm
      Category = 'Print_TTN'
      MoveParams = <>
      Caption = 'actDialog_TTN'
      Hint = 'actDialog_TTN'
      FormName = 'TTransportGoodsForm'
      FormNameParam.Value = 'TTransportGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_TransportGoods'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_Sale'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate_TransportGoods_calc'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGet_TTN: TdsdExecStoredProc
      Category = 'Print_TTN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_TTN
      StoredProcList = <
        item
          StoredProc = spGet_TTN
        end>
      Caption = 'actGet_TTN'
      Hint = 'actGet_TTN'
    end
    object actPrint_TTN: TdsdPrintAction
      Category = 'Print_TTN'
      MoveParams = <>
      StoredProc = spSelectPrint_TTN
      StoredProcList = <
        item
          StoredProc = spSelectPrint_TTN
        end>
      Caption = 'actPrint_TTN'
      Hint = 'actPrint_TTN'
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
      ReportName = 'PrintMovement_TTN'
      ReportNameParam.Value = ''
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTTN'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actInvoice: TEDIAction
      Category = 'EDI'
      MoveParams = <>
      StartDateParam.Value = Null
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = Null
      EndDateParam.MultiSelectSeparator = ','
      EDI = EDI
      EDIDocType = ediInvoice
      HeaderDataSet = PrintHeaderCDS
      ListDataSet = PrintItemsCDS
    end
    object actOrdSpr: TEDIAction
      Category = 'EDI'
      MoveParams = <>
      StartDateParam.Value = Null
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = Null
      EndDateParam.MultiSelectSeparator = ','
      EDI = EDI
      EDIDocType = ediOrdrsp
      HeaderDataSet = PrintHeaderCDS
      ListDataSet = PrintItemsCDS
    end
    object actDesadv: TEDIAction
      Category = 'EDI'
      MoveParams = <>
      StartDateParam.Value = Null
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = Null
      EndDateParam.MultiSelectSeparator = ','
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
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'Id'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.MultiSelectSeparator = ','
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
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'Id'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.MultiSelectSeparator = ','
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
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'Id'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.MultiSelectSeparator = ','
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
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'Id'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.MultiSelectSeparator = ','
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
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'Id'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.MultiSelectSeparator = ','
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
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'Id'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.MultiSelectSeparator = ','
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
    object mactUpdateMovementDesc: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateMovementDesc
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1090#1080' '#1042#1057#1045' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1074' '#1078#1091#1088#1085#1072#1083' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1094 +
        #1077#1085#1077'> '#1085#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' <'#1050#1086#1084#1091'>?'
      InfoAfterExecute = #1042#1057#1045' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1091#1089#1087#1077#1096#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1077#1085#1099' '#1074' '#1078#1091#1088#1085#1072#1083' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077' '#1087#1086' '#1094#1077#1085#1077'>'
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1085#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' <'#1050#1086#1084#1091'>'
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1085#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' <'#1050#1086#1084#1091'>'
      ImageIndex = 10
    end
    object actUpdateMovementDesc: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMovementDesc
      StoredProcList = <
        item
          StoredProc = spUpdateMovementDesc
        end>
      Caption = 'actUpdateMovementDesc'
    end
    object actDialog_QualityDoc: TdsdOpenForm
      Category = 'Print_QualityDoc'
      MoveParams = <>
      Caption = 'actDialog_QualityDoc'
      Hint = 'actDialog_QualityDoc'
      FormName = 'TQualityDocForm'
      FormNameParam.Value = 'TQualityDocForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_Sale'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object mactPrint_QualityDoc: TMultiAction
      Category = 'Print_QualityDoc'
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
          Action = actDialog_QualityDoc
        end
        item
          Action = actPrint_Quality_ReportName
        end
        item
          Action = actPrint_QualityDoc
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
      Hint = #1055#1077#1095#1072#1090#1100' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
      ImageIndex = 16
    end
    object actElectron: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spElectron
      StoredProcList = <
        item
          StoredProc = spElectron
        end>
      Caption = #1044#1083#1103' '#1085#1072#1083#1086#1075'. '#1048#1079#1084#1077#1085#1080#1090#1100' "'#1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1044#1072'/'#1053#1077#1090'"'
      Hint = #1044#1083#1103' '#1085#1072#1083#1086#1075'. '#1048#1079#1084#1077#1085#1080#1090#1100' "'#1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1044#1072'/'#1053#1077#1090'"'
      ImageIndex = 52
    end
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
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
    object macPrintPack: TMultiAction
      Category = 'Print'
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
          Action = actSPPrintSaleProcName
        end
        item
          Action = actPrintPack
        end
        item
          Action = actSPSavePrintState
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
    end
    object macPrintPacklist: TMultiAction
      Category = 'Print'
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
          Action = macPrintPack
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1077#1095#1072#1090#1080' '#1087#1072#1082#1077#1090#1072'?'
      Caption = #1055#1072#1082#1077#1090#1085#1072#1103' '#1087#1077#1095#1072#1090#1100' <'#1053#1072#1082#1083#1072#1076#1085#1072#1103'>'
      Hint = #1055#1072#1082#1077#1090#1085#1072#1103' '#1087#1077#1095#1072#1090#1100' <'#1053#1072#1082#1083#1072#1076#1085#1072#1103'>'
      ImageIndex = 3
    end
    object mactExport: TMultiAction
      Category = 'Export_Email'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_Email
        end
        item
          Action = actGet_Export_FileName
        end
        item
          Action = actSelect_Export
        end
        item
          Action = actExport_Grid
        end
        item
          Action = actSMTPFile
        end
        item
          Action = actUpdate_isMail
        end>
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1102' '#1087#1086' '#1087#1086#1095#1090#1077 +
        '?'
      InfoAfterExecute = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1091#1089#1087#1077#1096#1085#1086' '#1086#1090#1087#1088#1072#1074#1083#1077#1085' '#1087#1086' '#1087#1086#1095#1090#1077' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1102
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1102
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1102
      ImageIndex = 53
    end
    object actGet_Export_Email: TdsdExecStoredProc
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_Email
      StoredProcList = <
        item
          StoredProc = spGet_Export_Email
        end>
      Caption = 'actGet_Export_Email'
    end
    object actGet_Export_FileName: TdsdExecStoredProc
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_FileName
      StoredProcList = <
        item
          StoredProc = spGet_Export_FileName
        end>
      Caption = 'actGet_Export_FileName'
    end
    object actSelect_Export: TdsdExecStoredProc
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect_Export
      StoredProcList = <
        item
          StoredProc = spSelect_Export
        end>
      Caption = 'actSelect_Export'
    end
    object actExport_Grid: TExportGrid
      Category = 'Export_Email'
      MoveParams = <>
      ExportType = cxegExportToText
      Grid = ExportXmlGrid
      Caption = 'actExport_Grid'
      OpenAfterCreate = False
      DefaultFileName = 'Report_'
      DefaultFileExt = 'XML'
    end
    object actSMTPFile: TdsdSMTPFileAction
      Category = 'Export_Email'
      MoveParams = <>
      Host.Value = Null
      Host.Component = ExportEmailCDS
      Host.ComponentItem = 'Host'
      Host.DataType = ftString
      Host.MultiSelectSeparator = ','
      Port.Value = 25
      Port.Component = ExportEmailCDS
      Port.ComponentItem = 'Port'
      Port.DataType = ftString
      Port.MultiSelectSeparator = ','
      UserName.Value = Null
      UserName.Component = ExportEmailCDS
      UserName.ComponentItem = 'UserName'
      UserName.DataType = ftString
      UserName.MultiSelectSeparator = ','
      Password.Value = Null
      Password.Component = ExportEmailCDS
      Password.ComponentItem = 'Password'
      Password.DataType = ftString
      Password.MultiSelectSeparator = ','
      Body.Value = Null
      Body.Component = ExportEmailCDS
      Body.ComponentItem = 'Body'
      Body.DataType = ftString
      Body.MultiSelectSeparator = ','
      Subject.Value = Null
      Subject.Component = ExportEmailCDS
      Subject.ComponentItem = 'Subject'
      Subject.DataType = ftString
      Subject.MultiSelectSeparator = ','
      FromAddress.Value = Null
      FromAddress.Component = ExportEmailCDS
      FromAddress.ComponentItem = 'AddressFrom'
      FromAddress.DataType = ftString
      FromAddress.MultiSelectSeparator = ','
      ToAddress.Value = Null
      ToAddress.Component = ExportEmailCDS
      ToAddress.ComponentItem = 'AddressTo'
      ToAddress.DataType = ftString
      ToAddress.MultiSelectSeparator = ','
    end
    object actUpdate_isMail: TdsdExecStoredProc
      Category = 'Export_Email'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isMail
      StoredProcList = <
        item
          StoredProc = spUpdate_isMail
        end>
      Caption = 'actUpdate_isMail'
    end
    object macExportAll: TMultiAction
      Category = 'Export_Email'
      MoveParams = <>
      ActionList = <
        item
          Action = mactExport
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1042#1057#1045#1052' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084'?'
      InfoAfterExecute = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1042#1057#1045#1052' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084' '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1099
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1042#1057#1045#1052' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090' '#1042#1057#1045#1052' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1103#1084
      ImageIndex = 55
    end
    object actPrint_two: TdsdPrintAction
      Category = 'Print_QualityDoc'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'Id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint_two
      StoredProcList = <
        item
          StoredProc = spSelectPrint_two
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
      Hint = #1055#1077#1095#1072#1090#1100' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
      ImageIndex = 17
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDMaster2'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'MovementId;QualityCode;GoodsGroupName;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Quality'
      ReportNameParam.Value = Null
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameQuality'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object mactPrint_QualityDoc_two: TMultiAction
      Category = 'Print_QualityDoc'
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
          Action = actPrint_Quality_ReportName
        end
        item
          Action = actPrint_two
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1042#1089#1077#1093' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1081' '#1087#1086' '#1090#1077#1082'. '#1070#1088'.'#1083#1080#1094#1091
      Hint = #1055#1077#1095#1072#1090#1100' '#1042#1089#1077#1093' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1081' '#1087#1086' '#1090#1077#1082'. '#1070#1088'.'#1083#1080#1094#1091
      ImageIndex = 17
    end
    object macUpdateMI_Sale_PriceIn_list: TMultiAction
      Category = 'UpdatePriceIn'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateMI_Sale_PriceIn
        end>
      View = cxGridDBTableView
      Caption = 'macUpdateMI_Sale_PriceIn_list'
      ImageIndex = 80
    end
    object macUpdateMI_Sale_PriceIn: TMultiAction
      Category = 'UpdatePriceIn'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateMI_Sale_PriceIn_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1074#1093'. '#1094#1077#1085#1099' ('#1089#1093#1077#1084#1072' '#1055#1072#1074#1080#1083#1100#1086#1085#1099') '#1076#1083#1103' '#1042#1057#1045#1061' '#1074#1099#1073#1088#1072#1085#1085#1099#1093' '#1076#1086#1082#1091#1084#1077#1085#1090 +
        #1086#1074'?'
      InfoAfterExecute = #1042#1093'. '#1094#1077#1085#1099' ('#1089#1093#1077#1084#1072' '#1055#1072#1074#1080#1083#1100#1086#1085#1099') '#1079#1072#1087#1086#1083#1085#1077#1085#1099
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1074#1093'. '#1094#1077#1085#1099' ('#1089#1093#1077#1084#1072' '#1055#1072#1074#1080#1083#1100#1086#1085#1099')'
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1074#1093'. '#1094#1077#1085#1099' ('#1089#1093#1077#1084#1072' '#1055#1072#1074#1080#1083#1100#1086#1085#1099')'
      ImageIndex = 80
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
    object MedocAction: TMedocAction
      Category = 'TaxLib'
      MoveParams = <>
      Caption = 'MedocAction'
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
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' '#1052#1077#1044#1086#1082' '#1076#1086#1082'. '#1055#1088#1086#1076#1072#1078#1080
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' '#1052#1077#1044#1086#1082' '#1076#1086#1082'. '#1055#1088#1086#1076#1072#1078#1080
      ImageIndex = 30
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
    object MedocListAction: TMedocAction
      Category = 'TaxLib'
      MoveParams = <>
      Caption = 'MedocListAction'
      HeaderDataSet = PrintHeaderCDS
      ItemsDataSet = PrintItemsCDS
      AskFilePath = False
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
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1074#1099#1075#1088#1091#1079#1082#1077' '#1074' '#1052#1045#1044#1054#1050' '#1042#1057#1045#1061' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' '#1055#1088#1086#1076#1072#1078#1080'?'
      InfoAfterExecute = #1042#1057#1045' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1055#1088#1086#1076#1072#1078#1080' '#1074#1099#1075#1088#1091#1078#1077#1085#1099' '#1074' '#1052#1045#1044#1054#1050
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1042#1057#1045#1061' '#1076#1086#1082'. '#1055#1088#1086#1076#1072#1078' '#1074' '#1052#1045#1044#1054#1050
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1042#1057#1045#1061' '#1076#1086#1082'. '#1055#1088#1086#1076#1072#1078' '#1074' '#1052#1045#1044#1054#1050
      ImageIndex = 28
    end
    object ExecuteDialogUpdateAmountPartner: TExecuteDialog
      Category = 'UpdateAmount'
      MoveParams = <>
      Caption = 'actAmountDialog'
      FormName = 'TAmountDialogForm'
      FormNameParam.Value = 'TAmountDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Amount'
          Value = Null
          Component = FormParams
          ComponentItem = 'Amount'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = #1050#1086#1083'-'#1074#1086' '#1079#1085#1072#1082#1086#1074' '#1076#1083#1103' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1103
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actGet_Export_FileNameXml: TdsdExecStoredProc
      Category = 'Export_file'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_FileNameXML
      StoredProcList = <
        item
          StoredProc = spGet_Export_FileNameXML
        end>
      Caption = 'actGet_Export_FileName'
    end
    object actExport_fileXml: TdsdStoredProcExportToFile
      Category = 'Export_file'
      MoveParams = <>
      dsdStoredProcName = spSelectSale_xml
      FilePathParam.Value = ''
      FilePathParam.DataType = ftString
      FilePathParam.MultiSelectSeparator = ','
      FileNameParam.Value = ''
      FileNameParam.Component = FormParams
      FileNameParam.ComponentItem = 'FileName'
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      FileExt = '.xml'
      FileExtParam.Value = ''
      FileExtParam.Component = FormParams
      FileExtParam.ComponentItem = 'FileExt'
      FileExtParam.DataType = ftString
      FileExtParam.MultiSelectSeparator = ','
      FileNamePrefixParam.Value = ''
      FileNamePrefixParam.DataType = ftString
      FileNamePrefixParam.MultiSelectSeparator = ','
      FieldDefs = <>
      Left = 1208
      Top = 168
    end
    object macExport_XML: TMultiAction
      Category = 'Export_file'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_FileNameXml
        end
        item
          Action = actExport_fileXml
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1074#1099#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1076#1083#1103' <'#1052#1103#1089#1085#1072#1103' '#1074#1077#1089#1085#1072'>?'
      InfoAfterExecute = #1060#1072#1081#1083' '#1091#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1092#1072#1081#1083' <'#1052#1103#1089#1085#1072#1103' '#1074#1077#1089#1085#1072'>'
      Hint = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1092#1072#1081#1083' <'#1052#1103#1089#1085#1072#1103' '#1074#1077#1089#1085#1072'>'
      ImageIndex = 60
    end
    object actFileDirectoryDialog: TFileDialogAction
      Category = 'Export_file_2'
      MoveParams = <>
      FileOpenDialog.FavoriteLinks = <>
      FileOpenDialog.FileTypes = <>
      FileOpenDialog.Options = [fdoPickFolders]
      FileOpenDialog.Title = #1055#1072#1087#1082#1072' '#1082#1091#1076#1072' '#1074#1099#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1092#1072#1081#1083#1099' '#1042#1057#1045' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Param.Value = Null
      Param.Component = FormParams
      Param.ComponentItem = 'Directory'
      Param.DataType = ftString
      Param.MultiSelectSeparator = ','
    end
    object actGet_Export_FileName_fromMail: TdsdExecStoredProc
      Category = 'Export_file_2'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_Export_FileName_2
      StoredProcList = <
        item
          StoredProc = spGet_Export_FileName_2
        end>
      Caption = 'actGet_Export_FileName'
    end
    object actExport_file_fromEmail: TdsdStoredProcExportToFile
      Category = 'Export_file_2'
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
      dsdStoredProcName = spSelect_Export
      FilePathParam.Value = ''
      FilePathParam.Component = FormParams
      FilePathParam.ComponentItem = 'Directory'
      FilePathParam.DataType = ftString
      FilePathParam.MultiSelectSeparator = ','
      FileNameParam.Value = ''
      FileNameParam.Component = FormParams
      FileNameParam.ComponentItem = 'FileName'
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      FileExt = '.txt'
      FileExtParam.Value = ''
      FileExtParam.Component = FormParams
      FileExtParam.ComponentItem = 'FileExt'
      FileExtParam.DataType = ftString
      FileExtParam.MultiSelectSeparator = ','
      FileNamePrefixParam.Value = ''
      FileNamePrefixParam.DataType = ftString
      FileNamePrefixParam.MultiSelectSeparator = ','
      ShowSaveDialog = False
      FieldDefs = <>
      Left = 1208
      Top = 168
    end
    object macExportFile_fromMail: TMultiAction
      Category = 'Export_file_2'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_Export_FileName_fromMail
        end
        item
          Action = actExport_file_fromEmail
        end>
      View = cxGridDBTableView
      Caption = 'macExportFile_fromMail'
      ImageIndex = 32
    end
    object macExportFile_fromMail_All: TMultiAction
      Category = 'Export_file_2'
      MoveParams = <>
      ActionList = <
        item
          Action = actFileDirectoryDialog
        end
        item
          Action = macExportFile_fromMail
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1092#1072#1081#1083#1099' '#1042#1057#1045' '#1101#1083#1077#1082#1090#1088#1086#1085#1085#1099#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099'?'
      InfoAfterExecute = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1091#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1092#1072#1081#1083#1099' '#1042#1057#1045' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1092#1072#1081#1083#1099' '#1042#1057#1045' '#1069#1083#1077#1082#1090#1088#1086#1085#1085#1099#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      ImageIndex = 32
    end
    object actOpenChoicePriceList: TOpenChoiceForm
      Category = 'UpdatePriceList'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TPriceList_ObjectForm'
      ImageIndex = 56
      FormName = 'TPriceList_ObjectForm'
      FormNameParam.Value = 'TPriceList_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'PriceListId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUpdateTotalSumm_GoodsReal: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateTotalSumm_GoodsReal
      StoredProcList = <
        item
          StoredProc = spUpdateTotalSumm_GoodsReal
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1056#1072#1089#1095#1077#1090' '#1089#1091#1084#1084#1099' '#1087#1086' '#1089#1093#1077#1084#1077' - '#1058#1086#1074#1072#1088' ('#1092#1074#1082#1090')'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1056#1072#1089#1095#1077#1090' '#1089#1091#1084#1084#1099' '#1087#1086' '#1089#1093#1077#1084#1077' - '#1058#1086#1074#1072#1088' ('#1092#1074#1082#1090')'
      ImageIndex = 45
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
    StoredProcName = 'gpSelect_Movement_Sale'
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
        Value = False
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
      end
      item
        Name = 'inJuridicalBasisId'
        Value = Null
        Component = JuridicalBasisGuides
        ParamType = ptInput
        MultiSelectSeparator = ','
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
          ItemName = 'bbMovementItemContainer'
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
          ItemName = 'bbspChecked'
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
          ItemName = 'bbUpdateMovementDesc'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbsEdit'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbsUnLoad'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenReportForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbsPrintGroup'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbsPrint'
        end
        item
          BeginGroup = True
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
          ItemName = 'bbsSend'
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
    object bbTax: TdxBarButton
      Action = actTax
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = mactPrint_Sale
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
    object bbPrint_Bill: TdxBarButton
      Action = mactPrint_Account
      Category = 0
    end
    object bbMovementCheck: TdxBarButton
      Action = actMovementCheck
      Category = 0
    end
    object bbspChecked: TdxBarButton
      Action = actChecked
      Category = 0
    end
    object bbPrint_Invoice: TdxBarButton
      Action = actPrint_ExpInvoice
      Category = 0
    end
    object bbPrint_Pack: TdxBarButton
      Action = actPrint_ExpPack
      Category = 0
    end
    object bbPrint_Pack21: TdxBarButton
      Action = actPrint_Pack
      Category = 0
    end
    object bbPrint_Pack22: TdxBarButton
      Action = actPrint_Spec
      Category = 0
    end
    object bbPrint_Spec: TdxBarButton
      Action = actPrint_ExpSpec
      Category = 0
    end
    object bbTTN: TdxBarButton
      Action = mactPrint_TTN
      Category = 0
    end
    object bbPrint_Quality: TdxBarButton
      Action = mactPrint_QualityDoc
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
    object bbDesadv: TdxBarButton
      Action = mactDesadv
      Category = 0
    end
    object bbPrintSaleOrder: TdxBarButton
      Action = actPrintSaleOrder
      Category = 0
    end
    object bbUpdateMovementDesc: TdxBarButton
      Action = mactUpdateMovementDesc
      Category = 0
    end
    object bbPrintReturnInDay: TdxBarButton
      Action = actPrintReturnInDay
      Category = 0
    end
    object bbElectron: TdxBarButton
      Action = actElectron
      Category = 0
    end
    object bbPrint_Transport: TdxBarButton
      Action = mactPrint_Transport
      Category = 0
    end
    object bbOpenReportForm: TdxBarButton
      Action = actOpenReportForm
      Category = 0
    end
    object bbPrint_Sale_Total: TdxBarButton
      Action = mactPrint_Sale_Total
      Category = 0
    end
    object bbPrintPacklist: TdxBarButton
      Action = macPrintPacklist
      Category = 0
    end
    object bbPackList_Transport: TdxBarButton
      Action = macPrintPackList_Transport
      Category = 0
    end
    object bbPrint_Sale_Total_To: TdxBarButton
      Action = mactPrint_Sale_Total_To
      Category = 0
      ImageIndex = 19
    end
    object bbPrint_Sale_Total_List: TdxBarButton
      Action = mactPrint_Sale_Total_List
      Category = 0
      ImageIndex = 15
    end
    object bbPrint_Account_List: TdxBarButton
      Action = mactPrint_Account_List
      Category = 0
    end
    object bbPrintPackGross: TdxBarButton
      Action = actPrintPackGross
      Category = 0
    end
    object bbPrintSaleOrderTax: TdxBarButton
      Action = actPrintSaleOrderTax
      Category = 0
    end
    object bbPrint_PackWeight: TdxBarButton
      Action = actPrint_PackWeight
      Category = 0
    end
    object bbPrint_TTN2: TdxBarButton
      Action = mactPrint_TTN2
      Category = 0
    end
    object bbExport: TdxBarButton
      Action = mactExport
      Category = 0
    end
    object bbPrint_QualityDoc_two: TdxBarButton
      Action = mactPrint_QualityDoc_two
      Category = 0
    end
    object bbUpdateMI_Sale_PriceIn: TdxBarButton
      Action = macUpdateMI_Sale_PriceIn
      Category = 0
    end
    object bbmactMeDoc: TdxBarButton
      Action = mactMeDoc
      Category = 0
    end
    object bbRoundAmountPartner: TdxBarButton
      Action = macRoundAmountPartner
      Category = 0
    end
    object bbTEST: TdxBarButton
      Action = actPrintTEST
      Category = 0
    end
    object bbExport_XML: TdxBarButton
      Action = macExport_XML
      Category = 0
    end
    object bbPrintBox: TdxBarButton
      Action = actPrintBox
      Category = 0
    end
    object bbExportFile_fromMail_All: TdxBarButton
      Action = macExportFile_fromMail_All
      Category = 0
    end
    object bbPrint_Group: TdxBarButton
      Action = macPrint_Group
      Category = 0
    end
    object bbUpdate_PriceList: TdxBarButton
      Action = macUpdate_PriceList
      Category = 0
    end
    object bbPrint_Group_cash: TdxBarButton
      Action = macPrint_Group_cash
      Category = 0
    end
    object bbsPrint: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100
      Visible = ivAlways
      ImageIndex = 3
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Transport'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrint_PackWeight'
        end
        item
          Visible = True
          ItemName = 'bbPrintBox'
        end
        item
          Visible = True
          ItemName = 'bbtPrintBoxTotal'
        end
        item
          Visible = True
          ItemName = 'bb'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Sale_Total'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Sale_Total_To'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Sale_Total_List'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Bill'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Account_List'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
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
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Invoice'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Spec'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Pack'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Pack21'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Pack22'
        end
        item
          Visible = True
          ItemName = 'bbPrintPackGross'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbTTN'
        end
        item
          Visible = True
          ItemName = 'bbPrint_TTN2'
        end
        item
          Visible = True
          ItemName = 'bbPrint_TTN_final'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Quality'
        end
        item
          Visible = True
          ItemName = 'bbPrint_QualityDoc_two'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrintSaleOrderTax'
        end
        item
          Visible = True
          ItemName = 'bbPrintSaleOrder'
        end
        item
          Visible = True
          ItemName = 'bbPrintReturnInDay'
        end>
    end
    object bbsPrintGroup: TdxBarSubItem
      Caption = #1055#1072#1082#1077#1090#1085#1072#1103' '#1087#1077#1095#1072#1090#1100
      Category = 0
      Hint = #1055#1072#1082#1077#1090#1085#1072#1103' '#1087#1077#1095#1072#1090#1100
      Visible = ivAlways
      ImageIndex = 44
      LargeImageIndex = 44
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrint_Group'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Group_cash'
        end
        item
          Visible = True
          ItemName = 'bbPrintPacklist'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Group_cash_Ret'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Sale3_TTN_Quality'
        end>
    end
    object bbSeparator: TdxBarSeparator
      Caption = 'Separator'
      Category = 0
      Hint = 'Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbsSend: TdxBarSubItem
      Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 50
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbExport'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbInvoice'
        end
        item
          Visible = True
          ItemName = 'bbOrdSpr'
        end
        item
          Visible = True
          ItemName = 'bbDesadv'
        end>
    end
    object bbsEdit: TdxBarSubItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 79
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMI_Sale_PriceIn'
        end
        item
          Visible = True
          ItemName = 'bbRoundAmountPartner'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_PriceList'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbUpdateTotalSumm_GoodsReal'
        end>
    end
    object bbsUnLoad: TdxBarSubItem
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 5
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbExport_XML'
        end
        item
          Visible = True
          ItemName = 'bbExportFile_fromMail_All'
        end>
    end
    object bbPrint_Group_cash_Ret: TdxBarButton
      Action = macPrint_Group_cash_Ret
      Category = 0
    end
    object bbPrint_Sale2_TTN_Quality: TdxBarButton
      Action = macPrint_Sale2_TTN_Quality
      Category = 0
    end
    object bbPrint_Sale3_TTN_Quality: TdxBarButton
      Action = macPrint_Sale3_TTN_Quality
      Category = 0
    end
    object bbUpdateTotalSumm_GoodsReal: TdxBarButton
      Action = actUpdateTotalSumm_GoodsReal
      Category = 0
    end
    object bbPrint_TTN_final: TdxBarButton
      Action = macPrint_TTN_final
      Category = 0
    end
    object bbtPrintBoxTotal: TdxBarButton
      Action = actPrintBoxTotal
      Category = 0
    end
    object bb: TdxBarButton
      Action = actPrintBoxTotalPartner
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 224
  end
  inherited PopupMenu: TPopupMenu
    Left = 632
    Top = 168
    object N13: TMenuItem [2]
      Caption = '-'
    end
    object miInvoice: TMenuItem [3]
      Action = mactInvoice_All
    end
    object miOrdSpr: TMenuItem [4]
      Action = mactOrdSpr_All
    end
    object miDesadv: TMenuItem [5]
      Action = mactDesadv_All
    end
    object N15: TMenuItem [16]
      Action = macPrintPacklist
    end
    object N14: TMenuItem [17]
      Action = macPrintPackList_Transport
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 280
    Top = 192
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = JuridicalBasisGuides
      end>
    Left = 408
    Top = 344
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_Sale'
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
        Name = 'inIsLastComplete'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsRecalcPrice'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 65
    Top = 370
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_Sale'
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
        Name = 'outPrinted'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPrinted'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 65
    Top = 434
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_Sale'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 193
    Top = 426
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
        Name = 'ReportNameSale'
        Value = 'PrintMovement_Sale1_test'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSaleTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameTransport'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameTTN'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChangePercentAmount'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPrinted'
        Value = True
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameQuality'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 440
    Top = 80
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_Sale'
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
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 185
    Top = 354
  end
  object spSelectPrint_Pack: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_Pack_Print'
    DataSet = PrintItemsCDS
    DataSets = <
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
      end
      item
        Name = 'inMovementId_by'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 407
    Top = 488
  end
  object spSelectPrint_Spec: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_Spec_Print'
    DataSet = PrintItemsCDS
    DataSets = <
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
      end
      item
        Name = 'inMovementId_by'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 495
    Top = 504
  end
  object spSelectPrint_ExpInvoice: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_ExpInvoice_Print'
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
    Left = 351
    Top = 408
  end
  object spGetReporNameBill: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Sale_ReportNameBill'
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
        Name = 'gpGet_Movement_Sale_ReportNameBill'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameSaleBill'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 536
    Top = 408
  end
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 644
    Top = 302
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
    Left = 256
    Top = 507
  end
  object spSelectPrint_ExpPack: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_ExpPack_Print'
    DataSet = PrintItemsCDS
    DataSets = <
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
    Left = 271
    Top = 368
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
    Left = 1127
    Top = 280
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
    Left = 535
    Top = 344
  end
  object spGetReporNameTax: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Sale_ReportNameTax'
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
        Name = 'gpGet_Movement_Sale_ReportNameTax'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameSaleTax'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 704
    Top = 360
  end
  object spGetReportName: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Sale_ReportName'
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
        Name = 'gpGet_Movement_Sale_ReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameSale'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 704
    Top = 416
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
    Left = 632
    Top = 8
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
    StoredProcName = 'gpSelect_Movement_Sale_Print'
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
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 447
    Top = 280
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
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInvNumberPartner_Master'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InvNumberPartner_Master'
        DataType = ftString
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
  object spSelectPrint_TTN: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TTN_Print'
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
    Left = 623
    Top = 416
  end
  object spSelectPrint_Quality: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Quality_Print'
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
      end>
    PackSize = 1
    Left = 623
    Top = 512
  end
  object spGet_TTN: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Sale'
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
        Component = MasterCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChangePercentAmount'
        Value = Null
        Component = FormParams
        ComponentItem = 'inChangePercentAmount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_TransportGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_TransportGoods'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_TransportGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InvNumber_TransportGoods'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_TransportGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate_TransportGoods'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 208
    Top = 288
  end
  object EDI: TEDI
    ConnectionParams.Host.Value = Null
    ConnectionParams.Host.Component = FormParams
    ConnectionParams.Host.ComponentItem = 'Host'
    ConnectionParams.Host.DataType = ftString
    ConnectionParams.Host.MultiSelectSeparator = ','
    ConnectionParams.User.Value = Null
    ConnectionParams.User.Component = FormParams
    ConnectionParams.User.ComponentItem = 'UserName'
    ConnectionParams.User.DataType = ftString
    ConnectionParams.User.MultiSelectSeparator = ','
    ConnectionParams.Password.Value = Null
    ConnectionParams.Password.Component = FormParams
    ConnectionParams.Password.ComponentItem = 'Password'
    ConnectionParams.Password.DataType = ftString
    ConnectionParams.Password.MultiSelectSeparator = ','
    Left = 816
    Top = 232
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
        Value = 'zc_MovementBoolean_EdiOrdspr'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 712
    Top = 144
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
        Value = 'zc_MovementBoolean_EdiInvoice'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 856
    Top = 176
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescCode'
        Value = 'zc_MovementBoolean_EdiDesadv'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 920
    Top = 200
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Password'
        Value = Null
        Component = FormParams
        ComponentItem = 'Password'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 888
    Top = 248
  end
  object spSelectPrint_SaleOrder: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_Order_Print'
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
        Value = ''
        Component = MasterCDS
        ComponentItem = 'MovementId_Order'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Weighing'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDiff'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDiffTax'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 535
    Top = 168
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
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 824
    Top = 281
  end
  object spUpdateMovementDesc: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_Desc'
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
        Name = 'inMovementDescId_new'
        Value = 'zc_Movement_SendOnPrice'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId_new'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FromId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId_new'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 49
    Top = 306
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 568
  end
  object spSelectPrintReturnInDay: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ReturnIn_PrintDay'
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
    Left = 535
    Top = 216
  end
  object spSavePrintState: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Sale_Print'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNewPrinted'
        Value = True
        Component = FormParams
        ComponentItem = 'isPrinted'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPrinted'
        Value = False
        Component = MasterCDS
        ComponentItem = 'isPrinted'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 840
    Top = 352
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
        ComponentItem = 'MovementId_Master'
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
    Left = 1040
    Top = 195
  end
  object spGetReportNameTransport: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Transport_ReportName'
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
        Name = 'gpGet_Movement_Transport_ReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameTransport'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 824
    Top = 448
  end
  object spSelectPrint_Total: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_TotalPrint'
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
        Name = 'inStartDate'
        Value = 42614d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42614d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsList'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 375
    Top = 160
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
    Left = 1127
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
    Left = 1232
    Top = 8
  end
  object spSelectPrint_Total_To: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_TotalPrint'
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
        Name = 'inStartDate'
        Value = 42370d
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
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ToId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsList'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 439
    Top = 184
  end
  object spInsert_LockUnique: TdsdStoredProc
    StoredProcName = 'gpInsert_LockUnique_byPrint'
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
    Left = 1007
    Top = 312
  end
  object spSelectPrint_Total_List: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_TotalPrint'
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
        Name = 'inStartDate'
        Value = 42614d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42614d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ToId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisList'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 503
    Top = 320
  end
  object spDelete_LockUnique: TdsdStoredProc
    StoredProcName = 'gpDelete_LockUnique_byPrint'
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
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 999
    Top = 248
  end
  object spSelectPrint_SaleOrderTax: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_Order_Print'
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
        ComponentItem = 'MovementId_Order'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Weighing'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDiff'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDiffTax'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 623
    Top = 240
  end
  object spGetReportNameQuality: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Quality_ReportName'
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
        Name = 'gpGet_Movement_Quality_ReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameQuality'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 816
    Top = 504
  end
  object spSelectPrint_TTN2: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TTN_Print2'
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
    Left = 735
    Top = 472
  end
  object spSelect_Export: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Email_Send'
    DataSet = ExportCDS
    DataSets = <
      item
        DataSet = ExportCDS
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
    Left = 448
    Top = 576
  end
  object spUpdate_isMail: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_isMail'
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
      end>
    PackSize = 1
    Left = 336
    Top = 568
  end
  object spGet_Export_Email: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Email_Send'
    DataSet = ExportEmailCDS
    DataSets = <
      item
        DataSet = ExportEmailCDS
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
    Left = 248
    Top = 592
  end
  object ExportCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    Left = 56
    Top = 584
  end
  object ExportDS: TDataSource
    DataSet = ExportCDS
    Left = 88
    Top = 584
  end
  object ExportEmailDS: TDataSource
    DataSet = ExportEmailCDS
    Left = 88
    Top = 537
  end
  object ExportEmailCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 48
    Top = 536
  end
  object spGet_Export_FileName: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Email_FileName'
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
        Name = 'outFileName'
        Value = Null
        Component = actExport_Grid
        ComponentItem = 'DefaultFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        Component = actExport_Grid
        ComponentItem = 'DefaultFileExt'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEncodingANSI'
        Value = Null
        Component = actExport_Grid
        ComponentItem = 'EncodingANSI'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        Component = actSMTPFile
        ComponentItem = 'FileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outExportType'
        Value = Null
        Component = actExport_Grid
        ComponentItem = 'ExportType'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 168
    Top = 552
  end
  object spSelectPrint_two: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Quality_Print_two'
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
        Name = 'inisAll'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 967
    Top = 424
  end
  object spGetReporNameTTN: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TransportGoods_ReportName'
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
        Name = 'gpGet_Movement_TransportGoods_ReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameTTN'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 776
    Top = 336
  end
  object spUpdateMI_Sale_PriceIn: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_Sale_PriceIn'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId '
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1088
    Top = 419
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
    Left = 1232
    Top = 200
  end
  object spGetDirectoryName: TdsdStoredProc
    StoredProcName = 'gpGetDirectoryName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Directory'
        Value = Null
        ComponentItem = 'Directory'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1184
    Top = 328
  end
  object spUpdate_MI_AmountPartner_round: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_Sale_AmountPartner_round'
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
        Name = 'inAmount'
        Value = ''
        Component = FormParams
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1185
    Top = 386
  end
  object spSelectPrint_test: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_Print'
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
      end>
    PackSize = 1
    Left = 351
    Top = 280
  end
  object spGet_Export_FileNameXML: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Sale_FileNameXML'
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
        Name = 'outFileName'
        Value = Null
        Component = actExport_Grid
        ComponentItem = 'DefaultFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        Component = FormParams
        ComponentItem = 'FileExt'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEncodingANSI'
        Value = Null
        Component = actExport_Grid
        ComponentItem = 'EncodingANSI'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 192
    Top = 480
  end
  object spSelectSale_xml: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_XML'
    DataSet = ExportCDS
    DataSets = <
      item
        DataSet = ExportCDS
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
    Left = 296
    Top = 472
  end
  object spSelectPrintBox: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_BoxPrint'
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
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 511
    Top = 280
  end
  object spGet_Export_FileName_2: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Email_FileName'
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
        Name = 'outFileName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        Component = FormParams
        ComponentItem = 'FileExt'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEncodingANSI'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outExportType'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 456
  end
  object GuidesTransport: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumberTransport
    Key = '0'
    FormNameParam.Value = 'TTransportJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TTransportJournalChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesTransport
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesTransport
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 868
    Top = 8
  end
  object spInsertUpdate_TTN_byTransport: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TransportGoods_byTransport'
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
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId_Sale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_TransportGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_TransportGoods'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMovementId_TransportGoods'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId_TransportGoods'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Transport'
        Value = Null
        Component = GuidesTransport
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1295
    Top = 256
  end
  object spInsertUpdate_Quality_byTransport: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_QualityDoc_byTransport'
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
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId_Sale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_QualityDoc'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMovementId_QualityDoc'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId_QualityDoc'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Transport'
        Value = '0'
        Component = GuidesTransport
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1295
    Top = 304
  end
  object spGetReporNameTTN_list: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TransportGoods_ReportName'
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
        Name = 'gpGet_Movement_TransportGoods_ReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameTTN'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1312
    Top = 160
  end
  object spGetReportNameQuality_list: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Quality_ReportName'
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
        Name = 'gpGet_Movement_Quality_ReportName'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameQuality'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1320
    Top = 208
  end
  object spSelectPrint_TTN_list: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TTN_Print'
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
    Left = 1303
    Top = 360
  end
  object spSelectPrint_Quality_list: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Quality_Print'
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
      end>
    PackSize = 1
    Left = 1303
    Top = 408
  end
  object spUpdate_PriceList: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Sale_PriceList'
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
        Name = 'inPriceListId'
        Value = Null
        Component = FormParams
        ComponentItem = 'PriceListId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 608
    Top = 584
  end
  object spUpdatePrintAuto_False: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_ReturnIn_PrintAuto_False'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = 'zc_MovementBoolean_EdiDesadv'
        Component = MasterCDS
        ComponentItem = 'FromId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1144
    Top = 176
  end
  object spUpdatePrintAuto_True: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_ReturnIn_PrintAuto_True'
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
    Left = 1136
    Top = 224
  end
  object spUpdateTotalSumm_GoodsReal: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Sale_TotalSumm_GoodsReal'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioisTotalSumm_GoodsReal'
        Value = True
        Component = MasterCDS
        ComponentItem = 'isTotalSumm_GoodsReal'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 968
    Top = 579
  end
  object spSelectPrint_TTN_final: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TTN_final_Print'
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
    Left = 623
    Top = 464
  end
  object spSelectPrintBoxTotal: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_BoxTotalPrint'
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
    Left = 575
    Top = 296
  end
  object spSelectPrintBox_PartnerTotal: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Sale_BoxPartnerTotalPrint'
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
    Left = 591
    Top = 344
  end
end
