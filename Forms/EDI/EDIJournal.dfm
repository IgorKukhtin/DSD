inherited EDIJournalForm: TEDIJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <EXITE>'
  ClientHeight = 453
  ClientWidth = 1368
  AddOnFormData.OnLoadAction = actSetDefaults
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1384
  ExplicitHeight = 492
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 57
    Width = 1368
    Height = 396
    ExplicitTop = 57
    ExplicitWidth = 1368
    ExplicitHeight = 396
    ClientRectBottom = 396
    ClientRectRight = 1368
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1368
      ExplicitHeight = 396
      inherited cxGrid: TcxGrid
        Width = 1368
        Height = 209
        Align = alTop
        ExplicitWidth = 1368
        ExplicitHeight = 209
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clTotalCountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clTotalCountPartner_Sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clTotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clTotalSumm_Sale
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clTotalCountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clTotalCountPartner_Sale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clTotalSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clTotalSumm_Sale
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = clUnitName
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clError: TcxGridDBColumn
            Caption = #1054#1096
            DataBinding.FieldName = 'IsError'
            HeaderAlignmentVert = vaCenter
            Width = 25
          end
          object clOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1079#1072#1103#1074#1082'. (EDI)'
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clOperDate_Order: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'  '#1079#1072#1103#1074#1082#1080
            DataBinding.FieldName = 'OperDate_Order'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clInvNumber: TcxGridDBColumn
            Caption = #8470' '#1079#1072#1103#1074#1082'. (EDI)'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object clInvNumber_Order: TcxGridDBColumn
            Caption = #8470' '#1079#1072#1103#1074#1082#1080
            DataBinding.FieldName = 'InvNumber_Order'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object InvNumberRecadv: TcxGridDBColumn
            Caption = #8470' '#1091#1074#1077#1076#1086#1084#1083'. (EDI)'
            DataBinding.FieldName = 'InvNumberRecadv'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clOperDatePartner: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'. (EDI)'
            DataBinding.FieldName = 'OperDatePartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clOperDatePartner_Sale: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'OperDatePartner_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clOperDate_Tax: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'OperDate_Tax'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clOperDate_TaxCorrective: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'OperDate_TaxCorrective'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clOperDateTax: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1083#1086#1075'. (EDI)'
            DataBinding.FieldName = 'OperDateTax'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clInvNumberPartner: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. (EDI)'
            DataBinding.FieldName = 'InvNumberPartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object clInvNumber_Sale: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object clInvNumberPartner_Tax: TcxGridDBColumn
            Caption = #8470' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'InvNumberPartner_Tax'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object clInvNumberTax: TcxGridDBColumn
            Caption = #8470' '#1085#1072#1083#1086#1075'. (EDI)'
            DataBinding.FieldName = 'InvNumberTax'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clInvNumberPartner_TaxCorrective: TcxGridDBColumn
            Caption = #8470' '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'InvNumberPartner_TaxCorrective'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clFromName_Sale: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName_Sale'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object clToName_Sale: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object clJuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086' (EDI)'
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clJuridicalNameFind: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086' ('#1085#1072#1081#1076#1077#1085#1086')'
            DataBinding.FieldName = 'JuridicalNameFind'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clOKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054' (EDI)'
            DataBinding.FieldName = 'OKPO'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clGLNCode: TcxGridDBColumn
            Caption = 'GLN - '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100' (EDI)'
            DataBinding.FieldName = 'GLNCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clGLNPlaceCode: TcxGridDBColumn
            Caption = 'GLN - '#1084#1077#1089#1090#1086' '#1076#1086#1089#1090#1072#1074#1082#1080' (EDI)'
            DataBinding.FieldName = 'GLNPlaceCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object clPartnerNameFind: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090' ('#1085#1072#1081#1076#1077#1085')'
            DataBinding.FieldName = 'PartnerNameFind'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' (EDI)'
            DataBinding.FieldName = 'UnitName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceUnit
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object clContractCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'. (EDI)'
            DataBinding.FieldName = 'ContractCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object clContractName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'. (EDI)'
            DataBinding.FieldName = 'ContractName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceContract
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object clContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'. (EDI)'
            DataBinding.FieldName = 'ContractTagName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clGoodsPropertyName: TcxGridDBColumn
            Caption = #1050#1083#1072#1089#1089#1080#1092#1080#1082#1072#1090#1086#1088
            DataBinding.FieldName = 'GoodsPropertyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object clTotalCountPartner: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' (EDI)'
            DataBinding.FieldName = 'TotalCountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object clTotalCountPartner_Sale: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1076#1086#1082'.)'
            DataBinding.FieldName = 'TotalCountPartner_Sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object clTotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' (EDI)'
            DataBinding.FieldName = 'TotalSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clTotalSumm_Sale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1076#1086#1082'.)'
            DataBinding.FieldName = 'TotalSumm_Sale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clDescName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'DescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object clmovIsCheck: TcxGridDBColumn
            Caption = #1056#1072#1079#1085#1080#1094#1072
            DataBinding.FieldName = 'isCheck'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clisElectron: TcxGridDBColumn
            Caption = #1050#1074#1080#1090#1072#1085#1094#1080#1103', '#1101#1083#1077#1082#1090#1088'.'
            DataBinding.FieldName = 'isElectron'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object DateRegistered: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1088#1077#1075#1080#1089#1090#1088'. ('#1085#1072#1083#1086#1075'.)'
            DataBinding.FieldName = 'DateRegistered'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InvNumberRegistered: TcxGridDBColumn
            Caption = #8470' '#1088#1077#1075#1080#1089#1090#1088'. ('#1085#1072#1083#1086#1075'.)'
            DataBinding.FieldName = 'KassaMoveMoney'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object FileName: TcxGridDBColumn
            Caption = #1060#1072#1081#1083' DECLAR'
            DataBinding.FieldName = 'FileName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clPersonalSigningName: TcxGridDBColumn
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1087#1086#1076#1087#1080#1089#1072#1085#1090')'
            DataBinding.FieldName = 'PersonalSigningName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object Id: TcxGridDBColumn
            Caption = #1050#1083#1102#1095
            DataBinding.FieldName = 'Id'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object DealId: TcxGridDBColumn
            Caption = 'DealId ('#1042#1095#1072#1089#1085#1086'-EDI)'
            DataBinding.FieldName = 'DealId'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1085#1091#1090#1088#1110#1096#1085#1110#1081' DealId '#1079#1072#1084#1086#1074#1083#1077#1085#1085#1103' '#1042#1095#1072#1089#1085#1086'-EDI'
            Width = 89
          end
          object DocumentId_vch: TcxGridDBColumn
            Caption = 'DocumentId ('#1042#1095#1072#1089#1085#1086'-EDI)'
            DataBinding.FieldName = 'DocumentId_vch'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1085#1091#1090#1088#1110#1096#1085#1110#1081' DocumentId '#1042#1095#1072#1089#1085#1086'-EDI'
            Width = 103
          end
          object VchasnoId: TcxGridDBColumn
            Caption = 'VchasnoId ('#1042#1095#1072#1089#1085#1086'-EDI)'
            DataBinding.FieldName = 'VchasnoId'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1085#1091#1090#1088#1110#1096#1085#1110#1081' VchasnoId '#1042#1095#1072#1089#1085#1086'-EDI'
            Width = 107
          end
          object isVchasno: TcxGridDBColumn
            Caption = #1042#1095#1072#1089#1085#1086'-EDI ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isVchasno'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
      end
      object Splitter: TcxSplitter
        Left = 0
        Top = 209
        Width = 1368
        Height = 5
        AlignSplitter = salTop
        Control = cxGrid
      end
      object BottomPanel: TPanel
        Left = 0
        Top = 214
        Width = 1368
        Height = 182
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 2
        object cxChildGrid: TcxGrid
          Left = 0
          Top = 0
          Width = 953
          Height = 182
          Align = alLeft
          PopupMenu = PopupMenu
          TabOrder = 0
          object cxChildGridDBTableView: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = ClientDS
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Summary.DefaultGroupSummaryItems = <
              item
                Format = ',0.####'
                Kind = skSum
                Column = clAmountOrder
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = clAmountPartner
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = clAmountPartnerEDI
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = clSummPartner
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = clSummPartnerEDI
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = clAmountOrderEDI
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = clAmountNotice
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = clAmountNoticeEDI
              end>
            DataController.Summary.FooterSummaryItems = <
              item
                Format = ',0.####'
                Kind = skSum
                Column = clSummPartner
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = clAmountOrder
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = clAmountPartner
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = clAmountPartnerEDI
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = clSummPartnerEDI
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = clAmountOrderEDI
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = clAmountNotice
              end
              item
                Format = ',0.####'
                Kind = skSum
                Column = clAmountNoticeEDI
              end>
            DataController.Summary.SummaryGroups = <>
            Images = dmMain.SortImageList
            OptionsBehavior.GoToNextCellOnEnter = True
            OptionsBehavior.FocusCellOnCycle = True
            OptionsCustomize.ColumnHiding = True
            OptionsCustomize.ColumnsQuickCustomization = True
            OptionsCustomize.DataRowSizing = True
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Editing = False
            OptionsData.Inserting = False
            OptionsView.Footer = True
            OptionsView.GroupByBox = False
            OptionsView.GroupSummaryLayout = gslAlignWithColumns
            OptionsView.HeaderAutoHeight = True
            OptionsView.Indicator = True
            Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
            object OperDate_Insert: TcxGridDBColumn
              Caption = #1044#1072#1090#1072'/'#1074#1088'. '#1089#1086#1079#1076#1072#1085#1080#1077
              DataBinding.FieldName = 'OperDate_Insert'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              HeaderHint = #1055#1088#1086#1090#1086#1082#1086#1083' '#1079#1072#1075#1088#1091#1079#1082#1080' '#1080#1079' EDI'
              Width = 70
            end
            object clGoodsGLNCode: TcxGridDBColumn
              Caption = #1050#1086#1076' GLN'
              DataBinding.FieldName = 'GLNCode'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 55
            end
            object clGoodsCode: TcxGridDBColumn
              Caption = #1050#1086#1076
              DataBinding.FieldName = 'GoodsCode'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 40
            end
            object clGoodsName: TcxGridDBColumn
              Caption = #1058#1086#1074#1072#1088
              DataBinding.FieldName = 'GoodsName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 78
            end
            object clGoodsNameEDI: TcxGridDBColumn
              Caption = #1058#1086#1074#1072#1088' (EDI)'
              DataBinding.FieldName = 'GoodsNameEDI'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 77
            end
            object clGoodsKind: TcxGridDBColumn
              Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
              DataBinding.FieldName = 'GoodsKindName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 55
            end
            object clPrice: TcxGridDBColumn
              Caption = #1062#1077#1085#1072
              DataBinding.FieldName = 'Price'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 45
            end
            object clPrice_EDI: TcxGridDBColumn
              Caption = #1062#1077#1085#1072' (EDI)'
              DataBinding.FieldName = 'Price_EDI'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 45
            end
            object clAmountOrder: TcxGridDBColumn
              Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074'.'
              DataBinding.FieldName = 'AmountOrder'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 55
            end
            object clAmountOrderEDI: TcxGridDBColumn
              Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074'. (EDI)'
              DataBinding.FieldName = 'AmountOrderEDI'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 55
            end
            object clAmountNotice: TcxGridDBColumn
              Caption = #1050#1086#1083'-'#1074#1086' '#1089#1082#1083'. ('#1091#1074#1077#1076#1086#1084#1083'.)'
              DataBinding.FieldName = 'AmountNotice'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 55
            end
            object clAmountNoticeEDI: TcxGridDBColumn
              Caption = #1050#1086#1083'-'#1074#1086' '#1089#1082#1083'. ('#1091#1074#1077#1076#1086#1084#1083'. EDI)'
              DataBinding.FieldName = 'AmountNoticeEDI'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              Visible = False
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 55
            end
            object clAmountPartner: TcxGridDBColumn
              Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086#1082#1091#1087'. '
              DataBinding.FieldName = 'AmountPartner'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 55
            end
            object clAmountPartnerEDI: TcxGridDBColumn
              Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086#1082#1091#1087'. (EDI)'
              DataBinding.FieldName = 'AmountPartnerEDI'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 55
            end
            object clSummPartner: TcxGridDBColumn
              Caption = #1057#1091#1084#1084#1072' '#1087#1086#1082#1091#1087'.'
              DataBinding.FieldName = 'SummPartner'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 55
            end
            object clSummPartnerEDI: TcxGridDBColumn
              Caption = #1057#1091#1084#1084#1072' '#1087#1086#1082#1091#1087'. (EDI)'
              DataBinding.FieldName = 'SummPartnerEDI'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DecimalPlaces = 4
              Properties.DisplayFormat = ',0.####;-,0.####; ;'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 55
            end
            object clIsCheck: TcxGridDBColumn
              Caption = #1056#1072#1079#1085#1080#1094#1072
              DataBinding.FieldName = 'isCheck'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 30
            end
          end
          object cxGridLevel1: TcxGridLevel
            GridView = cxChildGridDBTableView
          end
        end
        object cxProtocolGrid: TcxGrid
          Left = 957
          Top = 0
          Width = 411
          Height = 182
          Align = alClient
          PopupMenu = PopupMenu
          TabOrder = 1
          object cxProtocolGridView: TcxGridDBTableView
            Navigator.Buttons.CustomButtons = <>
            DataController.DataSource = ProtocolDS
            DataController.Filter.Options = [fcoCaseInsensitive]
            DataController.Summary.DefaultGroupSummaryItems = <>
            DataController.Summary.FooterSummaryItems = <
              item
                Format = ',0.00'
                Kind = skSum
              end>
            DataController.Summary.SummaryGroups = <>
            Images = dmMain.SortImageList
            OptionsBehavior.GoToNextCellOnEnter = True
            OptionsBehavior.FocusCellOnCycle = True
            OptionsCustomize.ColumnHiding = True
            OptionsCustomize.ColumnsQuickCustomization = True
            OptionsCustomize.DataRowSizing = True
            OptionsData.Deleting = False
            OptionsData.DeletingConfirmation = False
            OptionsData.Editing = False
            OptionsData.Inserting = False
            OptionsView.ColumnAutoWidth = True
            OptionsView.Footer = True
            OptionsView.GroupByBox = False
            OptionsView.GroupSummaryLayout = gslAlignWithColumns
            OptionsView.HeaderAutoHeight = True
            OptionsView.Indicator = True
            Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
            object colProtocolOperDate: TcxGridDBColumn
              Caption = #1044#1072#1090#1072
              DataBinding.FieldName = 'OperDate'
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 60
            end
            object colProtocolText: TcxGridDBColumn
              Caption = #1054#1087#1080#1089#1072#1085#1080#1077
              DataBinding.FieldName = 'ProtocolText'
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 100
            end
            object colProtocolUserName: TcxGridDBColumn
              Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
              DataBinding.FieldName = 'UserName'
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 60
            end
          end
          object cxGridProtocolLevel: TcxGridLevel
            GridView = cxProtocolGridView
          end
        end
        object cxVerticalSplitter: TcxSplitter
          Left = 953
          Top = 0
          Width = 4
          Height = 182
          Control = cxChildGrid
        end
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 1368
    Height = 31
    Align = alTop
    TabOrder = 5
    object deStart: TcxDateEdit
      Left = 107
      Top = 5
      EditValue = 43313d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 310
      Top = 5
      EditValue = 43313d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object cxLabel1: TcxLabel
      Left = 10
      Top = 6
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel2: TcxLabel
      Left = 200
      Top = 6
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 184
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = BottomPanel
        Properties.Strings = (
          'Height'
          'Left'
          'Width')
      end
      item
        Component = cxChildGrid
        Properties.Strings = (
          'Height'
          'Width')
      end
      item
        Component = cxGrid
        Properties.Strings = (
          'Height')
      end
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
      end
      item
        Component = Splitter
        Properties.Strings = (
          'Top')
      end>
    Top = 184
  end
  inherited ActionList: TActionList
    Top = 184
    object ClientRefresh: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spClient
      StoredProcList = <
        item
          StoredProc = spClient
        end
        item
          StoredProc = spProtocol
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
      DataSet = MasterCDS
    end
    object actInvoice: TEDIAction [2]
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
    object actOrdSpr: TEDIAction [3]
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
    object EDIActionRecadvLoad: TEDIAction [4]
      Category = 'EDI Load'
      MoveParams = <>
      StartDateParam.Value = 42125d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = 42125d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
      EndDateParam.MultiSelectSeparator = ','
      EDI = EDI
      EDIDocType = ediRecadv
      spHeader = spInsertRecadv
      Directory = '/inbox'
    end
    object maEDIRecadvLoad: TMultiAction [5]
      Category = 'EDI Load'
      MoveParams = <>
      ActionList = <
        item
          Action = EDIActionRecadvLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1103' '#1086' '#1087#1088#1080#1077#1084#1082#1077' '#1080#1079' EXITE?'
      InfoAfterExecute = #1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1103' '#1086' '#1087#1088#1080#1077#1084#1082#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1103' '#1086' '#1087#1088#1080#1077#1084#1082#1077' '#1080#1079' EXITE'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1103' '#1086' '#1087#1088#1080#1077#1084#1082#1077' '#1080#1079' EXITE'
      ImageIndex = 74
    end
    object mactInvoice: TMultiAction [6]
      Category = 'EDI'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecPrintStoredProc
        end
        item
          Action = actInvoice
        end
        item
          Action = actUpdateEdiInvoiceTrue
        end>
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1057#1095#1077#1090'/'#1056#1072#1089#1093'. '#1085#1072#1082#1083'. '#1045#1087#1080#1094#1077#1085#1090#1088'> '#1086#1090#1087#1088#1072#1074#1083#1077#1085' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1057#1095#1077#1090'/'#1056#1072#1089#1093'. '#1085#1072#1082#1083'. '#1045#1087#1080#1094#1077#1085#1090#1088
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1057#1095#1077#1090'/'#1056#1072#1089#1093'. '#1085#1072#1082#1083'. '#1045#1087#1080#1094#1077#1085#1090#1088'> '#1074' EXITE'
    end
    object mactErrorEDI: TMultiAction [7]
      Category = 'EDI Load'
      MoveParams = <>
      ActionList = <
        item
          Action = EDIError
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1086#1096#1080#1073#1082#1072#1084' '#1080#1079' EXITE?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1087#1086' '#1086#1096#1080#1073#1082#1072#1084' '#1091#1089#1087#1077#1096#1085#1086' '#1079#1072#1075#1088#1091#1078#1077#1085#1099
      Caption = #1047#1072#1075#1088#1091#1079'.'#1086#1096#1080#1073'.'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1086#1096#1080#1073#1082#1080
    end
    object EDIError: TEDIAction [8]
      Category = 'EDI Load'
      MoveParams = <>
      StartDateParam.Value = 42005d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = 42005d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
      EndDateParam.MultiSelectSeparator = ','
      EDI = EDI
      EDIDocType = ediError
      Directory = '/error'
    end
    object mactDeclarSilent: TMultiAction [9]
      Category = 'EDI COMDOC DataSet'
      MoveParams = <>
      ActionList = <
        item
          Action = actStoredProcTaxPrint
        end
        item
          Action = EDIDeclar
        end>
    end
    object mactOrdSpr: TMultiAction [10]
      Category = 'EDI'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecPrintStoredProc
        end
        item
          Action = actOrdSpr
        end
        item
          Action = actUpdateEdiOrdsprTrue
        end>
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1079#1072#1082#1072#1079#1072'> '#1086#1090#1087#1088#1072#1074#1083#1077#1085' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1055#1086#1076#1090#1074#1077#1088#1078#1076'.'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1055#1086#1076#1090#1074#1077#1088#1078#1076#1077#1085#1080#1077' '#1079#1072#1082#1072#1079#1072'> '#1074' EXITE'
    end
    object actDesadv: TEDIAction [11]
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
    object mactDesadv: TMultiAction [12]
      Category = 'EDI'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecPrintStoredProc
        end
        item
          Action = actDesadv
        end
        item
          Action = actUpdateEdiDesadvTrue
        end>
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' '#1086#1073' '#1086#1090#1075#1088#1091#1079#1082#1077'> '#1086#1090#1087#1088#1072#1074#1083#1077#1085' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1059#1074#1077#1076#1086#1084#1083'.'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1059#1074#1077#1076#1086#1084#1083#1077#1085#1080#1077' '#1086#1073' '#1086#1090#1075#1088#1091#1079#1082#1077'> '#1074' EXITE'
    end
    inherited actGridToExcel: TdsdGridToExcel
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel ('#1078#1091#1088#1085#1072#1083')'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel ('#1078#1091#1088#1085#1072#1083')'
    end
    object actStoredProcTaxCorrectivePrint: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectTaxCorrective_Client
      StoredProcList = <
        item
          StoredProc = spSelectTaxCorrective_Client
        end>
      Caption = 'actExecPrintStoredProc'
    end
    object MovementProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementProtocolForm'
      FormNameParam.Value = 'TMovementProtocolForm'
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
        end
        item
          Name = 'InvNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object maEDIReceiptLoad: TMultiAction
      Category = 'EDI Load'
      MoveParams = <>
      ActionList = <
        item
          Action = EDIReceipt
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1074#1080#1090#1072#1085#1094#1080#1080' '#1080#1079' EXITE?'
      InfoAfterExecute = #1050#1074#1080#1090#1072#1085#1094#1080#1080' '#1079#1072#1075#1088#1091#1078#1077#1085#1099' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1047#1072#1075#1088#1091#1079'.'#1082#1074#1080#1090#1072#1085'.'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1074#1080#1090#1072#1085#1094#1080#1080
    end
    object EDIActionComdocLoad: TEDIAction
      Category = 'EDI Load'
      MoveParams = <>
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
      EndDateParam.MultiSelectSeparator = ','
      EDI = EDI
      EDIDocType = ediComDoc
      spHeader = spHeaderComDoc
      spList = spListComDoc
      Directory = '/inbox'
    end
    object maEDIComDocLoad: TMultiAction
      Category = 'EDI Load'
      MoveParams = <>
      ActionList = <
        item
          Action = EDIActionComdocLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1075#1088#1091#1079#1080#1090#1100' ComDoc '#1080#1079' EXITE?'
      InfoAfterExecute = 'ComDoc '#1079#1072#1075#1088#1091#1078#1077#1085#1099' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' ComDoc '#1080#1079' EXITE'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' ComDoc '#1080#1079' EXITE'
      ImageIndex = 30
    end
    object mactReturnComdoc: TMultiAction
      Category = 'EDI COMDOC'
      MoveParams = <>
      ActionList = <
        item
          Action = EDIReturnComDoc
        end
        item
          Action = actUpdate_DateRegistered
        end
        item
          Action = actStoredProcTaxCorrectivePrint
        end
        item
          Action = EDIDeclarReturn
        end
        item
          Action = actRefresh
        end>
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1042#1086#1079#1074#1088#1072#1090'> '#1086#1090#1087#1088#1072#1074#1083#1077#1085' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1086#1090#1087#1088'. '#1042#1086#1079#1074#1088#1072#1090
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1042#1086#1079#1074#1088#1072#1090'> '#1074' EXITE'
    end
    object maEDIOrdersLoad: TMultiAction
      Category = 'EDI Load'
      MoveParams = <>
      ActionList = <
        item
          Action = EDIActionOrdersLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1079#1072#1103#1074#1082#1080' '#1080#1079' EXITE?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1087#1086' '#1079#1072#1103#1074#1082#1072#1084' '#1079#1072#1075#1088#1091#1078#1077#1085#1099' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1079#1072#1103#1074#1082#1080' '#1080#1079' EXITE'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1079#1072#1103#1074#1082#1080' '#1080#1079' EXITE'
    end
    object EDIActionOrdersLoad: TEDIAction
      Category = 'EDI Load'
      MoveParams = <>
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
      EndDateParam.MultiSelectSeparator = ','
      EDI = EDI
      EDIDocType = ediOrder
      spHeader = spHeaderOrder
      spList = spListOrder
      Directory = '/inbox'
    end
    object actStoredProcTaxPrint: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectTax_Client
      StoredProcList = <
        item
          StoredProc = spSelectTax_Client
        end>
      Caption = 'actExecPrintStoredProc'
    end
    object actSetDefaults: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetDefaultEDI
      StoredProcList = <
        item
          StoredProc = spGetDefaultEDI
        end>
      Caption = 'actSetDefaults'
    end
    object actOpenSaleForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1053#1072#1082#1083#1072#1076#1085#1072#1103'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1053#1072#1082#1083#1072#1076#1085#1072#1103'>'
      ImageIndex = 39
      FormName = 'TSale_PartnerForm'
      FormNameParam.Value = 'TSale_PartnerForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_Sale'
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
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inChangePercentAmount'
          Value = 1.000000000000000000
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdate_EDIComdoc_Params: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      StoredProc = spUpdate_EDIComdoc_Params
      StoredProcList = <
        item
          StoredProc = spUpdate_EDIComdoc_Params
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1103#1079#1100' '#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1084
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1103#1079#1100' '#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1084
      ImageIndex = 41
      InfoAfterExecute = #1057#1074#1103#1079#1100' '#1089' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1084' '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1072
    end
    object actUpdateMI_EDIComdoc: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end
        item
          StoredProc = spInsertUpdate_SaleLinkEDI
        end>
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' EDI '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' EDI '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 42
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' EDI '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090'?'
      InfoAfterExecute = #1047#1072#1074#1077#1088#1096#1077#1085' '#1087#1077#1088#1077#1085#1086#1089' '#1076#1072#1085#1085#1099#1093' '#1080#1079' EDI '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090
    end
    object macUpdateMI_EDIComdoc: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdateMI_EDIComdoc_list
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1074#1099#1073#1088#1072#1085#1085#1099#1093' EDI '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1099'?'
      InfoAfterExecute = #1047#1072#1074#1077#1088#1096#1077#1085' '#1087#1077#1088#1077#1085#1086#1089' '#1076#1072#1085#1085#1099#1093' '#1080#1079' EDI '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1074#1099#1073#1088#1072#1085#1085#1099#1093' EDI '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1074#1099#1073#1088#1072#1085#1085#1099#1093' EDI '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      ImageIndex = 5
    end
    object macUpdateMI_EDIComdoc_list: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateMI_EDIComdoc_list
        end>
      View = cxGridDBTableView
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' EDI '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' EDI '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 5
    end
    object actUpdateMI_EDIComdoc_list: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end
        item
          StoredProc = spInsertUpdate_SaleLinkEDI_list
        end>
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' EDI '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' EDI '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 5
    end
    object mactCOMDOC: TMultiAction
      Category = 'EDI COMDOC'
      MoveParams = <>
      ActionList = <
        item
          Action = EDIReturnComDoc
        end
        item
          Action = actRefresh
        end>
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1056#1072#1089#1093#1086#1076'> '#1086#1090#1087#1088#1072#1074#1083#1077#1085' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1086#1090#1087#1088'. '#1056#1072#1089#1093#1086#1076
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1056#1072#1089#1093#1086#1076'> '#1074' EXITE'
    end
    object mactDECLAR: TMultiAction
      Category = 'EDI'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_DateRegistered
        end
        item
          Action = actStoredProcTaxPrint
        end
        item
          Action = EDIDeclar
        end>
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103'> '#1086#1090#1087#1088#1072#1074#1083#1077#1085' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1086#1090#1087#1088'. '#1053#1072#1083#1086#1075'.'
      Hint = #1054#1090#1087#1088#1072#1074#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103'> '#1074' EXITE'
    end
    object EDIDeclar: TEDIAction
      Category = 'EDI'
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
    object actExecPrintStoredProc: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = 'actExecPrintStoredProc'
    end
    object EDIReceipt: TEDIAction
      Category = 'EDI'
      MoveParams = <>
      StartDateParam.Value = Null
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = Null
      EndDateParam.MultiSelectSeparator = ','
      EDI = EDI
      EDIDocType = ediReceipt
      spHeader = spInsert_Protocol_EDIReceipt
      Directory = '/inbox'
    end
    object EDIReturnComDoc: TEDIAction
      Category = 'EDI COMDOC'
      MoveParams = <>
      StartDateParam.Value = Null
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = Null
      EndDateParam.MultiSelectSeparator = ','
      EDI = EDI
      EDIDocType = ediReturnComDoc
      spHeader = spGetFileName
      spList = spGetFileBlob
      HeaderDataSet = MasterCDS
      Directory = '/outbox'
    end
    object EDIDeclarReturn: TEDIAction
      Category = 'EDI'
      MoveParams = <>
      StartDateParam.Value = Null
      StartDateParam.MultiSelectSeparator = ','
      EndDateParam.Value = Null
      EndDateParam.MultiSelectSeparator = ','
      EDI = EDI
      EDIDocType = ediDeclarReturn
      HeaderDataSet = PrintHeaderCDS
      Directory = '/outbox'
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
    object mactSendComdoc: TMultiAction
      Category = 'EDI COMDOC DataSet'
      MoveParams = <>
      ActionList = <
        item
          Action = EDIReturnComDoc
        end>
      View = cxGridDBTableView
      Caption = 'mactSendComdoc'
    end
    object mactSendComdocAndRefresh: TMultiAction
      Category = 'EDI COMDOC DataSet'
      MoveParams = <>
      ActionList = <
        item
          Action = mactSendComdoc
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' <'#1056#1072#1089#1093#1086#1076'>.'#1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1042#1089#1077'?'
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' <'#1056#1072#1089#1093#1086#1076'> '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1099' '#1091#1089#1087#1077#1096#1085#1086
      Caption = 'EDI '#1056#1072#1089#1093#1086#1076' - '#1087#1072#1082#1077#1090#1085#1072#1103' '#1086#1090#1087#1088#1072#1074#1082#1072
    end
    object mactSendDeclar: TMultiAction
      Category = 'EDI COMDOC DataSet'
      MoveParams = <>
      ActionList = <
        item
          Action = mactDeclarSilent
        end>
      View = cxGridDBTableView
      Caption = 'EDI '#1053#1072#1083#1086#1075#1086#1074#1072#1103
    end
    object mactSendDeclarAndRefresh: TMultiAction
      Category = 'EDI COMDOC DataSet'
      MoveParams = <>
      ActionList = <
        item
          Action = mactSendDeclar
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103'>.'#1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1042#1089#1077'?'
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103'> '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1099' '#1091#1089#1087#1077#1096#1085#1086
      Caption = 'EDI '#1053#1072#1083#1086#1075#1086#1074#1072#1103' - '#1087#1072#1082#1077#1090#1085#1072#1103' '#1086#1090#1087#1088#1072#1074#1082#1072
    end
    object mactSendReturn: TMultiAction
      Category = 'EDI COMDOC DataSet'
      MoveParams = <>
      ActionList = <
        item
          Action = EDIReturnComDoc
        end
        item
          Action = actStoredProcTaxCorrectivePrint
        end
        item
          Action = EDIDeclarReturn
        end>
      View = cxGridDBTableView
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1077#1088#1077#1085#1077#1089#1077#1085#1099
      Caption = 'mactSendReturn'
    end
    object mactSendReturnAndRefresh: TMultiAction
      Category = 'EDI COMDOC DataSet'
      MoveParams = <>
      ActionList = <
        item
          Action = mactSendReturn
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' <'#1042#1086#1079#1074#1088#1072#1090'>.'#1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1090#1087#1088#1072#1074#1080#1090#1100' '#1042#1089#1077'?'
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' <'#1042#1086#1079#1074#1088#1072#1090'> '#1086#1090#1087#1088#1072#1074#1083#1077#1085#1099' '#1091#1089#1087#1077#1096#1085#1086
      Caption = 'EDI '#1042#1086#1079#1074#1088#1072#1090' - '#1087#1072#1082#1077#1090#1085#1072#1103' '#1086#1090#1087#1088#1072#1074#1082#1072
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
    end
    object actChoiceContract: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ContractChoiceForm'
      FormName = 'TContractChoiceForm'
      FormNameParam.Value = 'TContractChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractCode'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId_Find'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterJuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalNameFind'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractTagName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractTagName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actChoiceUnit: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Unit_ObjectForm'
      FormName = 'TUnit_ObjectForm'
      FormNameParam.Value = 'TUnit_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
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
    object actUpdate_DateRegistered: TdsdExecStoredProc
      Category = 'EDI'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_DateRegistered
      StoredProcList = <
        item
          StoredProc = spUpdate_DateRegistered
        end>
      Caption = 'actUpdate_DateRegistered'
    end
    object actOpenOrderForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1047#1072#1103#1074#1082#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1047#1072#1103#1074#1082#1072'>'
      FormName = 'TOrderExternalForm'
      FormNameParam.Value = 'TOrderExternalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = ''
          Component = MasterCDS
          ComponentItem = 'MovementId_Order'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
          Value = 42125d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42125d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actGridItemToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxChildGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel ('#1101#1083#1077#1084#1077#1085#1090#1099')'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel ('#1101#1083#1077#1084#1077#1085#1090#1099')'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actGridProtocolToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxProtocolGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel ('#1087#1088#1086#1090#1086#1082#1086#1083')'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel ('#1087#1088#1086#1090#1086#1082#1086#1083')'
      ImageIndex = 6
      ShortCut = 16472
    end
    object maEDIOrdersNOLoad: TMultiAction
      Category = 'EDI Load'
      MoveParams = <>
      ActionList = <
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1047#1072#1075#1088#1091#1079#1082#1072' '#1079#1072#1103#1074#1086#1082' '#1080#1079' EXITE '#1087#1088#1086#1080#1089#1093#1086#1076#1080#1090' '#1074' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1086#1084' '#1088#1077#1078#1080#1084#1077'. '#1055#1088#1086 +
        #1076#1086#1083#1078#1080#1090#1100'?'
      InfoAfterExecute = 
        #1047#1072#1075#1088#1091#1079#1082#1072' '#1079#1072#1103#1074#1086#1082' '#1080#1079' EXITE '#1087#1088#1086#1080#1089#1093#1086#1076#1080#1090' '#1074' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1086#1084' '#1088#1077#1078#1080#1084#1077'. '#1055#1086#1083 +
        #1100#1079#1086#1074#1072#1090#1077#1083#1103#1084' '#1076#1072#1085#1085#1072#1103' '#1092#1091#1085#1082#1094#1080#1103' '#1086#1090#1082#1083#1102#1095#1077#1085#1072'.'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1079#1072#1103#1074#1082#1080' '#1080#1079' EXITE'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1079#1072#1103#1074#1082#1080' '#1080#1079' EXITE'
      ImageIndex = 27
    end
  end
  inherited MasterDS: TDataSource
    Top = 56
  end
  inherited MasterCDS: TClientDataSet
    Top = 56
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_EDI'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 56
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 56
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
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
          ItemName = 'bbGotoSale'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenOrderForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbNOLoadOrder'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbLoadComDoc'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbEDIRecadvLoad'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbEDIError'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReceipt'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_EDIComdoc_Params'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertUpdate_SaleLinkEDI'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbmacUpdateMI_EDIComdoc'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bb_mactComDoc'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbDeclar'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReturnCOMDOC'
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
          ItemName = 'bbOrderSp'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbDecadv'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementProtocolOpenForm'
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
          ItemName = 'bbGridItemToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridProtocolToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      Caption = '   '
      Hint = '   '
      ShowCaption = False
    end
    object bbLoadComDoc: TdxBarButton
      Action = maEDIComDocLoad
      Category = 0
    end
    object bbNOLoadOrder: TdxBarButton
      Action = maEDIOrdersNOLoad
      Category = 0
    end
    object bbUpdate_EDIComdoc_Params: TdxBarButton
      Action = actUpdate_EDIComdoc_Params
      Category = 0
    end
    object bbInsertUpdate_SaleLinkEDI: TdxBarButton
      Action = actUpdateMI_EDIComdoc
      Category = 0
    end
    object bb_mactComDoc: TdxBarButton
      Action = mactCOMDOC
      Category = 0
    end
    object bbDeclar: TdxBarButton
      Action = mactDECLAR
      Category = 0
    end
    object bbReceipt: TdxBarButton
      Action = maEDIReceiptLoad
      Category = 0
    end
    object bbReturnCOMDOC: TdxBarButton
      Action = mactReturnComdoc
      Category = 0
    end
    object bbInvoice: TdxBarButton
      Action = mactInvoice
      Category = 0
    end
    object bbOrderSp: TdxBarButton
      Action = mactOrdSpr
      Category = 0
    end
    object bbDecadv: TdxBarButton
      Action = mactDesadv
      Category = 0
    end
    object bbEDIError: TdxBarButton
      Action = mactErrorEDI
      Category = 0
    end
    object bbEDIRecadvLoad: TdxBarButton
      Action = maEDIRecadvLoad
      Category = 0
    end
    object bbGotoSale: TdxBarButton
      Action = actOpenSaleForm
      Category = 0
    end
    object bbOpenOrderForm: TdxBarButton
      Action = actOpenOrderForm
      Category = 0
    end
    object bbMovementProtocolOpenForm: TdxBarButton
      Action = MovementProtocolOpenForm
      Category = 0
    end
    object bbGridItemToExcel: TdxBarButton
      Action = actGridItemToExcel
      Category = 0
    end
    object bbGridProtocolToExcel: TdxBarButton
      Action = actGridProtocolToExcel
      Category = 0
    end
    object bbmacUpdateMI_EDIComdoc: TdxBarButton
      Action = macUpdateMI_EDIComdoc
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 448
    Top = 120
  end
  inherited PopupMenu: TPopupMenu
    Top = 184
    object EDI4: TMenuItem [0]
      Action = mactSendComdocAndRefresh
    end
    object EDI5: TMenuItem [1]
      Action = mactSendDeclarAndRefresh
    end
    object mactSendReturnAndRefresh1: TMenuItem [2]
      Action = mactSendReturnAndRefresh
    end
    object N4: TMenuItem [3]
      Caption = '-'
    end
    object N5: TMenuItem [4]
      Action = actUpdate_EDIComdoc_Params
    end
    object ComDoc1: TMenuItem [5]
      Action = actUpdateMI_EDIComdoc
    end
    object N3: TMenuItem [6]
      Caption = '-'
    end
    object EDI1: TMenuItem [7]
      Action = maEDIOrdersLoad
    end
    object EDI2: TMenuItem [8]
      Action = maEDIComDocLoad
    end
    object EDI3: TMenuItem [9]
      Action = maEDIReceiptLoad
    end
    object N2: TMenuItem [10]
      Caption = '-'
    end
  end
  object spHeaderOrder: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_EDIOrder'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOrderInvNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOrderOperDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGLN'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGLNPlace'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gIsDelete'
        Value = Null
        Component = FormParams
        ComponentItem = 'gIsDelete'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsPropertyId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 168
    Top = 120
  end
  object spListOrder: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_EDIOrder'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsPropertyId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGLNCode'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountOrder'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceOrder'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 168
    Top = 168
  end
  object spClient: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_EDI'
    DataSet = ClientCDS
    DataSets = <
      item
        DataSet = ClientCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = 41640d
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 96
    Top = 312
  end
  object ClientDS: TDataSource
    DataSet = ClientCDS
    Left = 64
    Top = 312
  end
  object ClientCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'MovementId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 32
    Top = 312
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 320
    Top = 128
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end>
    Left = 328
    Top = 152
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
    Left = 416
    Top = 56
  end
  object spHeaderComDoc: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_EDIComdoc'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOrderInvNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOrderOperDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerInvNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerOperDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateTax'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberSaleLink'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDateSaleLink'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOKPO'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDesc'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGLNPlace'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComDocDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsPropertyId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 144
  end
  object spListComDoc: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_EDIComDoc'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsPropertyId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGLNCode'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountPartner'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPricePartner'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSummPartner'
        Value = Null
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 376
    Top = 136
  end
  object DBChildViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxChildGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 168
    Top = 344
  end
  object ProtocolCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'MovementId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 880
    Top = 296
  end
  object ProtocolDS: TDataSource
    DataSet = ProtocolCDS
    Left = 808
    Top = 296
  end
  object spProtocol: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_EDIProtocol'
    DataSet = ProtocolCDS
    DataSets = <
      item
        DataSet = ProtocolCDS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = 41640d
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 840
    Top = 304
  end
  object DBProtocolViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxProtocolGridView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    ViewDocumentList = <>
    PropertiesCellList = <>
    Left = 808
    Top = 328
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
      end
      item
        Name = 'gIsDelete'
        Value = Null
        Component = FormParams
        ComponentItem = 'gIsDelete'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 464
    Top = 48
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Host'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Password'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'gIsDelete'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 520
    Top = 48
  end
  object spInsertUpdate_SaleLinkEDI: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_SaleLinkEDI'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId_EDI'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Sale'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Sale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Sale'
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDatePartner_Sale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDatePartner_Sale'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_Tax'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate_Tax'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_TaxCorrective'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate_TaxCorrective'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Sale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InvNumber_Sale'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberPartner_Tax'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InvNumberPartner_Tax'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberPartner_TaxCorrective'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InvNumberPartner_TaxCorrective'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Tax'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Tax'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_TaxCorrective'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_TaxCorrective'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Order'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Order'
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_Order'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate_Order'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Order'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InvNumber_Order'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName_Sale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FromName_Sale'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName_Sale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ToName_Sale'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm_Sale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalSumm_Sale'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalCountPartner_Sale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalCountPartner_Sale'
        DataType = ftFloat
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
        Name = 'ContractCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractCode'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractTagName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalNameFind'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalNameFind'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerNameFind'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartnerNameFind'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 608
    Top = 144
  end
  object spUpdate_EDIComdoc_Params: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_EDIComdoc_Params'
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
        Name = 'MovementId_Sale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Sale'
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDatePartner_Sale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDatePartner_Sale'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Sale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InvNumber_Sale'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Order'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Order'
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_Order'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'OperDate_Order'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Order'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InvNumber_Order'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName_Sale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FromName_Sale'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName_Sale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ToName_Sale'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm_Sale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalSumm_Sale'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalCountPartner_Sale'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TotalCountPartner_Sale'
        DataType = ftFloat
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
        Name = 'ContractCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractCode'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractTagName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 712
    Top = 152
  end
  object spSelectPrint: TdsdStoredProc
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
        Component = MasterCDS
        ComponentItem = 'MovementId_Sale'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 679
    Top = 80
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 724
    Top = 73
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 732
    Top = 62
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
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Sale'
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
    Left = 647
    Top = 64
  end
  object spInsert_Protocol_EDIReceipt: TdsdStoredProc
    StoredProcName = 'gpInsert_Protocol_EDIReceipt'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inisOk'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEDIEvent'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperMonth'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFileName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberRegistered'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateRegistered'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 256
    Top = 64
  end
  object spGetFileBlob: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ComDoc'
    DataSets = <>
    OutputType = otBlob
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 392
    Top = 192
  end
  object spGetFileName: TdsdStoredProc
    StoredProcName = 'gpGet_FileName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 400
    Top = 240
  end
  object spSelectTaxCorrective_Client: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TaxCorrective_Print'
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
        ComponentItem = 'MovementId_TaxCorrective'
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
    Left = 679
    Top = 112
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_EDI_Params'
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
        Name = 'inContractId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 536
    Top = 160
  end
  object spUpdateEdiOrdspr: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_Edi'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Sale'
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
    Left = 848
    Top = 136
  end
  object spUpdateEdiInvoice: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_Edi'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Sale'
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
    Left = 904
    Top = 136
  end
  object spUpdateEdiDesadv: TdsdStoredProc
    StoredProcName = 'gpUpdateMovement_Edi'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Sale'
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
    Left = 968
    Top = 136
  end
  object spInsertRecadv: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_EDIRecadv'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOrderInvNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGLNPlace'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDesadvNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 192
  end
  object spUpdate_DateRegistered: TdsdStoredProc
    StoredProcName = 'gpUpdate_DateRegistered'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId_Tax'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Tax'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Corrective'
        Value = 'zc_MovementBoolean_EdiOrdspr'
        Component = MasterCDS
        ComponentItem = 'MovementId_TaxCorrective'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 856
    Top = 200
  end
  object spInsertUpdate_SaleLinkEDI_list: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_SaleLinkEDI'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId_EDI'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Sale'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 608
    Top = 192
  end
end
