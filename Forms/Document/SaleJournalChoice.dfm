inherited SaleJournalChoiceForm: TSaleJournalChoiceForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102'>'
  ClientHeight = 535
  ClientWidth = 1110
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1126
  ExplicitHeight = 574
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1110
    Height = 478
    TabOrder = 3
    ExplicitWidth = 1110
    ExplicitHeight = 478
    ClientRectBottom = 478
    ClientRectRight = 1110
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1110
      ExplicitHeight = 478
      inherited cxGrid: TcxGrid
        Width = 1110
        Height = 478
        ExplicitWidth = 1110
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
              Format = ',0.####'
              Kind = skSum
              Column = TotalCountPartner
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
              Column = TotalSummChange
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummCurrency
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
              Format = ',0.####'
              Kind = skSum
              Column = TotalCountPartner
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
              Column = TotalSummChange
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalSummCurrency
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
          object IsError: TcxGridDBColumn [1]
            Caption = #1054#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'isError'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 44
          end
          inherited colOperDate: TcxGridDBColumn [2]
            Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
            HeaderAlignmentHorz = taCenter
            Width = 55
          end
          object OperDatePartner: TcxGridDBColumn [3]
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'OperDatePartner'
            Visible = False
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
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object DocumentTaxKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
            DataBinding.FieldName = 'DocumentTaxKindName'
            Visible = False
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
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object InvNumber_TransportGoods: TcxGridDBColumn
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
          object FromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object ToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
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
            Visible = False
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
            Visible = False
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
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object TotalCountKg: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074#1077#1089' ('#1091' '#1087#1086#1082#1091#1087'.)'
            DataBinding.FieldName = 'TotalCountKg'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TotalSummChange: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' (-)'#1089#1082'.(+)'#1085#1072#1094
            DataBinding.FieldName = 'TotalSummChange'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
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
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
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
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
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
          object PaymentDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaymentDate'
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
            Visible = False
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
            Width = 80
          end
          object CurrencyPartnerValue: TcxGridDBColumn
            Caption = #1050#1091#1088#1089
            DataBinding.FieldName = 'CurrencyPartnerValue'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ParPartnerValue: TcxGridDBColumn
            Caption = #1053#1086#1084#1080#1085#1072#1083
            DataBinding.FieldName = 'ParPartnerValue'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object CurrencyValue: TcxGridDBColumn
            Caption = #1050#1091#1088#1089' '#1059#1055
            DataBinding.FieldName = 'CurrencyValue'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ParValue: TcxGridDBColumn
            Caption = #1053#1086#1084#1080#1085#1072#1083' '#1082#1091#1088#1089' '#1059#1055
            DataBinding.FieldName = 'ParValue'
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
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 36
          end
          object ReestrKindName: TcxGridDBColumn
            Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1087#1086' '#1088#1077#1077#1089#1090#1088#1091
            DataBinding.FieldName = 'ReestrKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1087#1086' '#1088#1077#1077#1089#1090#1088#1091
            Width = 74
          end
          object IsEDI: TcxGridDBColumn
            Caption = 'EXITE'
            DataBinding.FieldName = 'isEDI'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
          object IsElectron: TcxGridDBColumn
            Caption = #1069#1083#1077#1082#1090#1088'.'
            DataBinding.FieldName = 'isElectron'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 30
          end
          object IsMedoc: TcxGridDBColumn
            Caption = #1052#1077#1076#1086#1082
            DataBinding.FieldName = 'IsMedoc'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object EdiOrdspr: TcxGridDBColumn
            Caption = 'EDI - '#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077
            DataBinding.FieldName = 'EdiOrdspr'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object EdiInvoice: TcxGridDBColumn
            Caption = 'EDI - '#1057#1095#1077#1090
            DataBinding.FieldName = 'EdiInvoice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object EdiDesadv: TcxGridDBColumn
            Caption = 'EDI - '#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'EdiDesadv'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object DescName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'DescName'
            Options.Editing = False
            Width = 80
          end
          object InvNumber_Transport_Full: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1055#1051
            DataBinding.FieldName = 'InvNumber_Transport_Full'
            Options.Editing = False
            Width = 90
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1110
    ExplicitWidth = 1110
    inherited deStart: TcxDateEdit
      EditValue = 42005d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 42005d
    end
    object edPartner: TcxButtonEdit
      Left = 523
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 245
    end
  end
  object cxLabel6: TcxLabel [2]
    Left = 453
    Top = 6
    Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090':'
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 179
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 243
  end
  inherited ActionList: TActionList
    Left = 471
    inherited actMovementItemContainer: TdsdOpenForm
      Enabled = False
    end
    inherited actInsert: TdsdInsertUpdateAction
      Enabled = False
      FormName = 'TTaxForm'
      FormNameParam.Value = nil
    end
    inherited actInsertMask: TdsdInsertUpdateAction
      Enabled = False
    end
    inherited actUpdate: TdsdInsertUpdateAction
      Enabled = False
      FormName = 'TTaxForm'
      FormNameParam.Value = nil
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
    inherited actComplete: TdsdChangeMovementStatus
      Enabled = False
    end
    inherited actUnComplete: TdsdChangeMovementStatus
      Enabled = False
    end
    inherited actSetErased: TdsdChangeMovementStatus
      Enabled = False
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
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
          Name = 'FromId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FromId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'FromName'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ToId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ToName'
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_Full'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber_Full'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1078#1091#1088#1085#1072#1083#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1078#1091#1088#1085#1072#1083#1072
      ImageIndex = 7
      DataSource = MasterDS
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
    StoredProcName = 'gpSelect_Movement_Sale_Choice'
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
        Name = 'inPartnerId'
        Value = Null
        Component = PartnerGuides
        ComponentItem = 'Key'
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
          ItemName = 'bbSelect'
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
    inherited bbComplete: TdxBarButton
      Visible = ivNever
    end
    inherited bbUnComplete: TdxBarButton
      Visible = ivNever
    end
    inherited bbDelete: TdxBarButton
      Visible = ivNever
    end
    object bbSelect: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end>
    Left = 320
    Top = 224
  end
  inherited PopupMenu: TPopupMenu
    Left = 640
    Top = 152
    inherited N3: TMenuItem
      Visible = False
    end
    inherited N2: TMenuItem
      Visible = False
    end
    inherited N4: TMenuItem
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
    Left = 240
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = PartnerGuides
      end>
    Left = 408
    Top = 344
  end
  inherited spMovementComplete: TdsdStoredProc
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
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = Null
        Component = PartnerGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = Null
        Component = PartnerGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 304
    Top = 288
  end
  inherited spMovementReComplete: TdsdStoredProc
    Left = 368
    Top = 128
  end
  object PartnerGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartner_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PartnerGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PartnerGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 568
    Top = 8
  end
end
