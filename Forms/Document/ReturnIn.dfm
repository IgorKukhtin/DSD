inherited ReturnInForm: TReturnInForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1042#1086#1079#1074#1088#1072#1090' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103' ('#1074#1089#1077')>'
  ClientHeight = 650
  ClientWidth = 1244
  ExplicitWidth = 1260
  ExplicitHeight = 688
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 166
    Width = 1244
    Height = 484
    ExplicitTop = 166
    ExplicitWidth = 1244
    ExplicitHeight = 484
    ClientRectBottom = 484
    ClientRectRight = 1244
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1244
      ExplicitHeight = 460
      inherited cxGrid: TcxGrid
        Width = 1244
        Height = 344
        ExplicitWidth = 1244
        ExplicitHeight = 344
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountSummVat
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountChild
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountChildDiff
              Sorted = True
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Kind = skSum
              Column = colPrice
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountSummVat
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountChild
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountChildDiff
            end>
          OptionsBehavior.GoToNextCellOnEnter = False
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colLineNum: TcxGridDBColumn [0]
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'LineNum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object clGoodsGroupNameFull: TcxGridDBColumn [1]
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object colCode: TcxGridDBColumn [2]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object colName: TcxGridDBColumn [3]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 200
          end
          object colGoodsKindName: TcxGridDBColumn [4]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object colPartionGoods: TcxGridDBColumn [5]
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object colMeasureName: TcxGridDBColumn [6]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colAmount: TcxGridDBColumn [7]
            Caption = #1050#1086#1083'-'#1074#1086' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colAmountPartner: TcxGridDBColumn [8]
            Caption = #1050#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colAmountChild: TcxGridDBColumn [9]
            Caption = #1050#1086#1083'-'#1074#1086' ('#1087#1088#1080#1074#1103#1079#1082#1072')'
            DataBinding.FieldName = 'AmountChild'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 73
          end
          object colAmountChildDiff: TcxGridDBColumn [10]
            Caption = #1050#1086#1083'-'#1074#1086' ('#1088#1072#1079#1085#1080#1094#1072')'
            DataBinding.FieldName = 'AmountChildDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object colPrice: TcxGridDBColumn [11]
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 63
          end
          object colCountForPrice: TcxGridDBColumn [12]
            Caption = #1050#1086#1083' '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object Price_Pricelist: TcxGridDBColumn [13]
            Caption = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' ('#1073#1077#1079' '#1053#1044#1057')'
            DataBinding.FieldName = 'Price_Pricelist'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
          end
          object Price_Pricelist_vat: TcxGridDBColumn [14]
            Caption = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'Price_Pricelist_vat'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isCheck_Pricelist: TcxGridDBColumn [15]
            Caption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1086#1090' '#1087#1088#1072#1081#1089#1072
            DataBinding.FieldName = 'isCheck_Pricelist'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object colAmountSumm: TcxGridDBColumn [16]
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'AmountSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object colAmountSummVat: TcxGridDBColumn [17]
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'AmountSummVat'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object clPartionMovementName: TcxGridDBColumn [18]
            Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'PartionMovementName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actSaleJournalChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 145
          end
          object PricePromo: TcxGridDBColumn [19]
            Caption = #1062#1077#1085#1072' '#1072#1082#1094#1080#1103
            DataBinding.FieldName = 'PricePromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MovementPromo: TcxGridDBColumn [20]
            Caption = #8470' '#1076#1086#1082'. '#1072#1082#1094#1080#1080
            DataBinding.FieldName = 'MovementPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 352
        Width = 1244
        Height = 108
        Align = alBottom
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DetailDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = childAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = childAmountPartner
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = childAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = childAmountPartner
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.IncSearch = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object childGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object childGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 209
          end
          object childGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            FooterAlignmentHorz = taCenter
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object childAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1082#1091#1087'. ('#1087#1088#1080#1074#1103#1079#1082#1072')'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object childAmountPartner: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1082#1091#1087'. ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object childPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 97
          end
          object childInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceSale
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object childInvNumberPartner: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'InvNumberPartner'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object childOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'OperDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object childOperDatePartner: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'OperDatePartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object childContractCode_Sale: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'. ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'ContractCode_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object childContractName_Sale: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'. ('#1087#1088#1086#1076#1072#1078#1072')'
            DataBinding.FieldName = 'ContractName_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 67
          end
          object childDocumentTaxKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
            DataBinding.FieldName = 'DocumentTaxKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 160
          end
          object childInvNumber_Master: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'. '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'InvNumber_Master'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object childInvNumberPartner_Master: TcxGridDBColumn
            Caption = #8470' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'InvNumberPartner_Master'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object childOperDate_Master: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'OperDate_Master'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object childContractCode_Tax: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'. ('#1085#1072#1083#1086#1075'.)'
            DataBinding.FieldName = 'ContractCode_Tax'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 62
          end
          object childContractName_Tax: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'. ('#1085#1072#1083#1086#1075'.)'
            DataBinding.FieldName = 'ContractName_Tax'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 67
          end
          object FromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object ToCode: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1082#1086#1084#1091')'
            DataBinding.FieldName = 'ToCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object childIsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 344
        Width = 1244
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = cxGrid1
      end
    end
    object cxTabSheetTaxCorrective: TcxTabSheet
      Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080
      ImageIndex = 2
      object l: TcxGrid
        Left = 0
        Top = 0
        Width = 1244
        Height = 460
        Align = alClient
        TabOrder = 0
        object lDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = TaxCorrectiveDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSummVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSummMVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalCount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSummPVAT
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSummVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSummMVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalCount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colTotalSummPVAT
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object colStatus: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089
            DataBinding.FieldName = 'StatusCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 11
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
              end>
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 56
          end
          object colIsError: TcxGridDBColumn
            Caption = #1054#1096#1080#1073#1082#1072
            DataBinding.FieldName = 'IsError'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 46
          end
          object colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object colTaxKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
            DataBinding.FieldName = 'TaxKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object clincInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
          object clincInvNumberPartner: TcxGridDBColumn
            Caption = #8470' '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'InvNumberPartner'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 37
          end
          object colInvNumberPartner_Child: TcxGridDBColumn
            Caption = #8470' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'InvNumberPartner_Child'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actTaxJournalChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 46
          end
          object colOperDate_Child: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072#1083#1086#1075'.'
            DataBinding.FieldName = 'OperDate_Child'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 53
          end
          object colPartnerName: TcxGridDBColumn
            Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
            DataBinding.FieldName = 'PartnerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object colOKPO_From: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO_From'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 41
          end
          object colFromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object colToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object colTotalCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1091' '#1087#1086#1082#1091#1087'.)'
            DataBinding.FieldName = 'TotalCount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object colTotalSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057' ('#1080#1090#1086#1075')'
            DataBinding.FieldName = 'TotalSumm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 66
          end
          object colPriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'PriceWithVAT'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
          object colVATPercent: TcxGridDBColumn
            Caption = '% '#1053#1044#1057
            DataBinding.FieldName = 'VATPercent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 41
          end
          object colTotalSummVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1053#1044#1057
            DataBinding.FieldName = 'TotalSummVAT'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 46
          end
          object colTotalSummMVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1073#1077#1079' '#1053#1044#1057
            DataBinding.FieldName = 'TotalSummMVAT'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 46
          end
          object colTotalSummPVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'TotalSummPVAT'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colContractCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colContractName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 43
          end
          object colContractTagName: TcxGridDBColumn
            Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractTagName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colChecked: TcxGridDBColumn
            Caption = #1055#1088#1086#1074#1077#1088#1077#1085
            DataBinding.FieldName = 'Checked'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 49
          end
          object colDocument: TcxGridDBColumn
            Caption = #1055#1086#1076#1087#1080#1089#1072#1085
            DataBinding.FieldName = 'Document'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 29
          end
          object colIsEDI: TcxGridDBColumn
            Caption = 'EXITE'
            DataBinding.FieldName = 'isEDI'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
          object colIsElectron: TcxGridDBColumn
            Caption = #1069#1083#1077#1082#1090#1088'.'
            DataBinding.FieldName = 'isElectron'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
          object colIsMedoc: TcxGridDBColumn
            Caption = #1052#1077#1076#1086#1082
            DataBinding.FieldName = 'IsMedoc'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
        end
        object lLevel: TcxGridLevel
          GridView = lDBTableView
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1244
    Height = 140
    TabOrder = 3
    ExplicitWidth = 1244
    ExplicitHeight = 140
    inherited edInvNumber: TcxTextEdit
      Left = 8
      Properties.ReadOnly = False
      ExplicitLeft = 8
      ExplicitWidth = 114
      Width = 114
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 212
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 212
    end
    inherited cxLabel2: TcxLabel
      Left = 212
      Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
      ExplicitLeft = 212
      ExplicitWidth = 71
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 63
      TabOrder = 8
      ExplicitTop = 63
      ExplicitWidth = 114
      ExplicitHeight = 22
      Width = 114
    end
    object cxLabel3: TcxLabel
      Left = 496
      Top = 5
      Caption = #1050#1086#1084#1091
    end
    object edTo: TcxButtonEdit
      Left = 496
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 132
    end
    object edFrom: TcxButtonEdit
      Left = 320
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 170
    end
    object cxLabel4: TcxLabel
      Left = 320
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object edContract: TcxButtonEdit
      Left = 759
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 98
    end
    object cxLabel9: TcxLabel
      Left = 759
      Top = 5
      Caption = #1044#1086#1075#1086#1074#1086#1088
    end
    object cxLabel6: TcxLabel
      Left = 635
      Top = 5
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
    end
    object edPaidKind: TcxButtonEdit
      Left = 635
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 118
    end
    object edPriceWithVAT: TcxCheckBox
      Left = 320
      Top = 63
      Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
      Properties.ReadOnly = True
      TabOrder = 16
      Width = 128
    end
    object edVATPercent: TcxCurrencyEdit
      Left = 450
      Top = 63
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = True
      TabOrder = 17
      Width = 40
    end
    object cxLabel7: TcxLabel
      Left = 450
      Top = 45
      Caption = '% '#1053#1044#1057
    end
    object edChangePercent: TcxCurrencyEdit
      Left = 496
      Top = 63
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      Properties.ReadOnly = False
      TabOrder = 19
      Width = 132
    end
    object cxLabel8: TcxLabel
      Left = 496
      Top = 45
      Caption = '(-)% '#1057#1082#1080#1076' (+)% '#1053#1072#1094
    end
    object edOperDatePartner: TcxDateEdit
      Left = 213
      Top = 63
      EditValue = 42181d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 13
      Width = 100
    end
    object cxLabel10: TcxLabel
      Left = 212
      Top = 45
      Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1091' '#1087#1086#1082#1091#1087'.'
    end
    object edIsChecked: TcxCheckBox
      Left = 635
      Top = 56
      Caption = #1055#1088#1086#1074#1077#1088#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 22
      Width = 118
    end
    object edPriceList: TcxButtonEdit
      Left = 761
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 23
      Width = 96
    end
    object cxLabel11: TcxLabel
      Left = 761
      Top = 85
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
    end
    object cxLabel12: TcxLabel
      Left = 123
      Top = 5
      Caption = #8470' '#1076#1086#1082'.'#1091' '#1087#1086#1082#1091#1087'.'
    end
    object edInvNumberPartner: TcxTextEdit
      Left = 123
      Top = 23
      TabOrder = 14
      Width = 84
    end
    object edInvNumberMark: TcxTextEdit
      Left = 123
      Top = 63
      TabOrder = 26
      Width = 84
    end
    object cxLabel13: TcxLabel
      Left = 123
      Top = 45
      Caption = #8470' '#1079'.'#1084'.'
    end
    object cxLabel20: TcxLabel
      Left = 865
      Top = 5
      Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075#1086#1074#1086#1088#1072
    end
    object edContractTag: TcxButtonEdit
      Left = 865
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 29
      Width = 97
    end
    object cxLabel19: TcxLabel
      Left = 320
      Top = 85
      Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077' '#8470' ('#1087#1088#1086#1076#1072#1078#1072')'
    end
    object edInvNumberSale: TcxButtonEdit
      Left = 320
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 31
      Width = 171
    end
    object cxLabel18: TcxLabel
      Left = 867
      Top = 85
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 867
      Top = 103
      TabOrder = 33
      Width = 230
    end
    object cxLabel21: TcxLabel
      Left = 8
      Top = 85
      Caption = #1054#1089#1085#1086#1074#1072#1085#1080#1077' '#8470' ('#1074#1086#1079#1074#1088#1072#1090' '#1085#1072' '#1089#1082#1083#1072#1076')'
    end
    object edInvNumberParent: TcxButtonEdit
      Left = 8
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 35
      Width = 199
    end
    object cbPartner: TcxCheckBox
      Left = 213
      Top = 103
      Hint = #1040#1082#1090' '#1085#1077#1076#1086#1074#1086#1079#1072
      Caption = #1040#1082#1090' '#1085#1077#1076#1086#1074#1086#1079#1072
      Properties.ReadOnly = False
      TabOrder = 36
      Width = 100
    end
    object edJuridicalFrom: TcxButtonEdit
      Left = 321
      Top = 41
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 37
      Visible = False
      Width = 64
    end
  end
  object edDocumentTaxKind: TcxButtonEdit [2]
    Left = 867
    Top = 63
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 97
  end
  object cxLabel5: TcxLabel [3]
    Left = 867
    Top = 45
    Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
  end
  object cxLabel14: TcxLabel [4]
    Left = 970
    Top = 45
    Caption = #1042#1072#1083#1102#1090#1072' ('#1094#1077#1085#1072')'
  end
  object edCurrencyDocument: TcxButtonEdit [5]
    Left = 970
    Top = 63
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 78
  end
  object cxLabel16: TcxLabel [6]
    Left = 1053
    Top = 45
    Caption = #1050#1091#1088#1089
  end
  object edCurrencyValue: TcxCurrencyEdit [7]
    Left = 1053
    Top = 63
    Properties.Alignment.Horz = taRightJustify
    Properties.Alignment.Vert = taVCenter
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####;-,0.####; ;'
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 44
  end
  object cxLabel17: TcxLabel [8]
    Left = 970
    Top = 5
    Caption = #1042#1072#1083#1102#1090#1072' ('#1087#1086#1082#1091#1087#1072#1090#1077#1083#1100')'
  end
  object edCurrencyPartner: TcxButtonEdit [9]
    Left = 970
    Top = 23
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 127
  end
  object cbCalcAmountPartner: TcxCheckBox [10]
    Left = 497
    Top = 95
    Caption = #1056#1072#1089#1095#1077#1090' <'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
    Properties.ReadOnly = False
    State = cbsChecked
    TabOrder = 14
    Width = 215
  end
  object cbPromo: TcxCheckBox [11]
    Left = 635
    Top = 79
    Caption = #1040#1082#1094#1080#1103' ('#1076#1072'/'#1085#1077#1090')'
    Properties.ReadOnly = True
    TabOrder = 15
    Width = 102
  end
  object edStartDateTax: TcxDateEdit [12]
    Left = 761
    Top = 62
    EditValue = 42181d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 16
    Width = 96
  end
  object cxLabel22: TcxLabel [13]
    Left = 761
    Top = 45
    Caption = #1053#1072#1095'. '#1076#1072#1090#1072' '#1085#1072#1083#1086#1075'.'
  end
  object cbList: TcxCheckBox [14]
    Left = 497
    Top = 114
    Caption = #1087#1088#1080#1074#1103#1079#1082#1072' '#1082' '#1054#1089#1085#1086#1074'. '#8470' ('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 18
    Width = 204
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 187
    Top = 448
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = actAddMask
        Properties.Strings = (
          'Caption'
          'Category'
          'Hint'
          'ImageIndex'
          'InfoAfterExecute'
          'MoveParams'
          'Name'
          'QuestionBeforeExecute'
          'SecondaryShortCuts'
          'ShortCut'
          'StoredProc'
          'StoredProcList'
          'TabSheet'
          'Tag')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    Left = 64
    Top = 408
  end
  inherited ActionList: TActionList
    Left = 31
    Top = 247
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MI_Child
        end
        item
          StoredProc = spSelectTaxCorrective
        end>
      RefreshOnTabSetChanges = True
    end
    inherited actMISetErased: TdsdUpdateErased
      TabSheet = tsMain
    end
    inherited actMISetUnErased: TdsdUpdateErased
      TabSheet = tsMain
    end
    inherited actShowErased: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MI_Child
        end>
    end
    object actOpenReportCheckAmountForm: TdsdOpenForm [7]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072' '#1074' '#1087#1088#1080#1074#1103#1079#1082#1077' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1082' '#1087#1088#1086#1076#1072#1078#1072#1084'>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072' '#1074' '#1087#1088#1080#1074#1103#1079#1082#1077' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1082' '#1087#1088#1086#1076#1072#1078#1072#1084'>'
      ImageIndex = 26
      FormName = 'TReport_CheckAmount_ReturnInToSaleForm'
      FormNameParam.Value = 'TReport_CheckAmount_ReturnInToSaleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inStartDate'
          Value = 42181d
          Component = edStartDateTax
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = 42181d
          Component = edOperDatePartner
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalId'
          Value = ''
          Component = JuridicalFromGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalName'
          Value = ''
          Component = JuridicalFromGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inInvNumber'
          Value = Null
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 'NULL'
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenReportCheckForm: TdsdOpenForm [8]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1082' '#1087#1088#1086#1076#1072#1078#1072#1084'>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1082' '#1087#1088#1086#1076#1072#1078#1072#1084'>'
      ImageIndex = 24
      FormName = 'TReport_Check_ReturnInToSaleForm'
      FormNameParam.Value = 'TReport_Check_ReturnInToSaleForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inStartDate'
          Value = 42181d
          Component = edStartDateTax
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = 42181d
          Component = edOperDatePartner
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalId'
          Value = ''
          Component = JuridicalFromGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalName'
          Value = ''
          Component = JuridicalFromGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inInvNumber'
          Value = Null
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 'NULL'
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenReportForm: TdsdOpenForm [9]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1076#1072#1078#1072' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1076#1072#1078#1072' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      ImageIndex = 25
      FormName = 'TReport_Goods_SalebyReturnInForm'
      FormNameParam.Value = 'TReport_Goods_SalebyReturnInForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inStartDate'
          Value = 'NULL'
          Component = edStartDateTax
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = 'NULL'
          Component = edOperDatePartner
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = 'False'
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerName'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPaidKindId'
          Value = 'False'
          Component = PaidKindGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPaidKindName'
          Value = Null
          Component = PaidKindGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPrice'
          Value = '0'
          Component = MasterCDS
          ComponentItem = 'Price'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inContractId'
          Value = Null
          Component = ContractGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inContractName'
          Value = Null
          Component = ContractGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalId'
          Value = Null
          Component = JuridicalFromGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalName'
          Value = Null
          Component = JuridicalFromGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenTax: TdsdOpenForm [10]
      Category = 'DSDLib'
      TabSheet = cxTabSheetTaxCorrective
      MoveParams = <>
      Enabled = False
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103'>'
      ImageIndex = 26
      FormName = 'TTaxForm'
      FormNameParam.Value = 'TTaxForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'DocumentChildId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inmask'
          Value = 'False'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = 'False'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 'NULL'
          Component = TaxCorrectiveCDS
          ComponentItem = 'OperDate_Child'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenTaxCorrective: TdsdOpenForm [11]
      Category = 'DSDLib'
      TabSheet = cxTabSheetTaxCorrective
      MoveParams = <>
      Enabled = False
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      ImageIndex = 1
      FormName = 'TTaxCorrectiveForm'
      FormNameParam.Value = 'TTaxCorrectiveForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inmask'
          Value = 'False'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 'NULL'
          Component = TaxCorrectiveCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateTaxCorrectiveDS: TdsdUpdateDataSet [12]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = gpUpdateTaxCorrective
      StoredProcList = <
        item
          StoredProc = gpUpdateTaxCorrective
        end>
      Caption = 'actUpdateTaxCorrectiveDS'
      DataSource = TaxCorrectiveDS
    end
    object actUpdateDetailDS: TdsdUpdateDataSet [14]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spUpdateMIChild
        end
        item
          StoredProc = spSelect_MI_Child
        end>
      Caption = 'actUpdateDetailDS'
      DataSource = DetailDS
    end
    object actUnCompleteTaxCorrective: TdsdChangeMovementStatus [15]
      Category = 'DSDLib'
      TabSheet = cxTabSheetTaxCorrective
      MoveParams = <>
      Enabled = False
      StoredProc = spMovementUnCompleteTaxCorrective
      StoredProcList = <
        item
          StoredProc = spMovementUnCompleteTaxCorrective
        end
        item
          StoredProc = spSelectTaxCorrective
        end>
      Caption = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      Hint = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      ImageIndex = 11
      Status = mtUncomplete
      DataSource = TaxCorrectiveDS
    end
    object actSetErasedTaxCorrective: TdsdChangeMovementStatus [16]
      Category = 'DSDLib'
      TabSheet = cxTabSheetTaxCorrective
      MoveParams = <>
      Enabled = False
      StoredProc = spMovementSetErasedTaxCorrective
      StoredProcList = <
        item
          StoredProc = spMovementSetErasedTaxCorrective
        end
        item
        end
        item
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      ImageIndex = 13
      Status = mtDelete
      DataSource = TaxCorrectiveDS
    end
    object actCompleteTaxCorrective: TdsdChangeMovementStatus [17]
      Category = 'DSDLib'
      TabSheet = cxTabSheetTaxCorrective
      MoveParams = <>
      Enabled = False
      StoredProc = spMovementCompleteTaxCorrective
      StoredProcList = <
        item
          StoredProc = spMovementCompleteTaxCorrective
        end
        item
          StoredProc = spSelectTaxCorrective
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1086#1081'>'
      ImageIndex = 12
      Status = mtComplete
      DataSource = TaxCorrectiveDS
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
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
      ReportName = 'PrintMovement_TaxCorrective'
      ReportNameParam.Name = #1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = 'PrintMovement_TaxCorrective'
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportName'
      ReportNameParam.ParamType = ptInput
    end
    object actPrint_TaxCorrective_Us: TdsdPrintAction [19]
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
      ReportNameParam.Value = 'PrintMovement_TaxCorrective'
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTaxCorrective'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
    end
    object actPrint_TaxCorrective_Client: TdsdPrintAction [20]
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
      ReportNameParam.Value = 'PrintMovement_TaxCorrective'
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameTaxCorrective'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    object mactPrintPriceCorr: TMultiAction [22]
      Category = 'DSDLib'
      MoveParams = <>
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
    object mactPrint: TMultiAction [23]
      Category = 'DSDLib'
      MoveParams = <>
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
    object actPrint_ReturnIn_by_TaxCorrective: TdsdPrintAction [24]
      Category = 'DSDLib'
      MoveParams = <>
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
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    object actTaxJournalChoice: TOpenChoiceForm [28]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TaxJournalSelectForm'
      FormName = 'TTaxJournalChoiceForm'
      FormNameParam.Value = 'TTaxJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'DocumentChildId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'InvNumberPartner_Child'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate_Tax'
          Value = 'NULL'
          Component = TaxCorrectiveCDS
          ComponentItem = 'OperDate_Child'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'FromId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'FromName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'PartnerId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = TaxCorrectiveCDS
          ComponentItem = 'PartnerName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object MIChildProtocolOpenForm: TdsdOpenForm [29]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1087#1088#1080#1074#1103#1079#1082#1080'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1087#1088#1080#1074#1103#1079#1082#1080'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    inherited MovementItemProtocolOpenForm: TdsdOpenForm
      TabSheet = tsMain
    end
    inherited actAddMask: TdsdExecStoredProc
      TabSheet = tsMain
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
    object actTaxCorrective: TdsdExecStoredProc
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
    object actCorrective: TdsdExecStoredProc
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
    object actRefreshPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actSaleJournalChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TSaleJournalChoiceForm'
      FormName = 'TSaleJournalChoiceForm'
      FormNameParam.Value = 'TSaleJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'InvNumber_Full'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionMovementName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_Partion'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartnerName'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGoodsChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actGoodsChoice'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = 'TGoods_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupNameFull'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasureName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGoodsKindChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'TGoodsKind_ObjectForm'
      FormName = 'TGoodsKind_ObjectForm'
      FormNameParam.Value = 'TGoodsKind_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
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
    end
    object mactPrint_TaxCorrective_Client: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
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
      MoveParams = <>
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
    object actUpdateAmountPartner: TdsdExecStoredProc
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MI_ReturnIn_AmountPartner
      StoredProcList = <
        item
          StoredProc = spUpdate_MI_ReturnIn_AmountPartner
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1054#1073#1085#1091#1083#1080#1090#1100' '#1087#1086' '#1074#1089#1077#1084#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1091' "'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'"'
      Hint = #1054#1073#1085#1091#1083#1080#1090#1100' '#1087#1086' '#1074#1089#1077#1084#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1091' "'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'"'
      ImageIndex = 39
      QuestionBeforeExecute = 
        #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1086#1073#1085#1091#1083#1080#1090#1100' '#1087#1086' '#1074#1089#1077#1084#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1091' "'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077 +
        #1083#1103'"?'
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' "'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'" '#1086#1073#1085#1091#1083#1077#1085#1086' '#1087#1086' '#1074#1089#1077#1084#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1091
    end
    object actUpdatePrice: TdsdExecStoredProc
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMovement
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end
        item
          StoredProc = spUpdate_MI_ReturnIn_Price
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1048#1089#1087#1088#1072#1074#1080#1090#1100' '#1094#1077#1085#1099' '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#1087#1088#1072#1081#1089#1072
      Hint = #1048#1089#1087#1088#1072#1074#1080#1090#1100' '#1094#1077#1085#1099' '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#1087#1088#1072#1081#1089#1072
      ImageIndex = 44
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1080#1089#1087#1088#1072#1074#1080#1090#1100' '#1094#1077#1085#1099' '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#1087#1088#1072#1081#1089#1072'?'
      InfoAfterExecute = #1047#1072#1074#1077#1088#1096#1077#1085#1086' '#1080#1089#1087#1088#1072#1074#1083#1077#1085#1080#1077' '#1094#1077#1085' '#1085#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#1087#1088#1072#1081#1089#1072'.'
    end
    object actUpdateAuto: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateAuto
      StoredProcList = <
        item
          StoredProc = spUpdateAuto
        end
        item
          StoredProc = spSelect_MI_Child
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' <'#1055#1088#1086#1076#1072#1078#1072'>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' <'#1055#1088#1086#1076#1072#1078#1072'>'
      ImageIndex = 7
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' <'#1055#1088#1086#1076#1072#1078#1072'>?'
      InfoAfterExecute = #1047#1072#1074#1077#1088#1096#1077#1085#1086' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1087#1088#1080#1074#1103#1079#1082#1080' '#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072#1084' <'#1055#1088#1086#1076#1072#1078#1072'>.'
    end
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
    end
    object actChoiceSale: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Report_Goods_SalebyReturnIn_ChoiceForm'
      FormName = 'TReport_Goods_SalebyReturnIn_ChoiceForm'
      FormNameParam.Name = 'TReport_Goods_SalebyReturnIn_ChoiceForm'
      FormNameParam.Value = 'TReport_Goods_SalebyReturnIn_ChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'MovementId_sale'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 'NULL'
          Component = DetailCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementItemId'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'MovementItemId_sale'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inStartDate'
          Value = 42181d
          Component = edStartDateTax
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = 42181d
          Component = edOperDatePartner
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPaidKindId'
          Value = ''
          Component = PaidKindGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPaidKindName'
          Value = ''
          Component = PaidKindGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPrice'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Price'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inContractId'
          Value = ''
          Component = ContractGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inContractName'
          Value = ''
          Component = ContractGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsKindId'
          Value = '0'
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inGoodsKindName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalId'
          Value = ''
          Component = JuridicalFromGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inJuridicalName'
          Value = ''
          Component = JuridicalFromGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsKindName'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToCode'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'ToCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'ToName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberPartner'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'InvNumberPartner'
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDatePartner'
          Value = 'NULL'
          Component = DetailCDS
          ComponentItem = 'OperDatePartner'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumberPartner_Master'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'InvNumberPartner_Master'
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate_Master'
          Value = 'NULL'
          Component = DetailCDS
          ComponentItem = 'OperDate_Master'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'AmountPartner'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'AmountPartner'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Price'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'Price'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'FromName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber_Master'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'InvNumber_Master'
          MultiSelectSeparator = ','
        end
        item
          Name = 'DocumentTaxKindName'
          Value = Null
          Component = DetailCDS
          ComponentItem = 'DocumentTaxKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 24
    Top = 384
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 464
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_ReturnIn'
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
        Name = 'inPriceListId'
        Value = '0'
        Component = PriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = actShowAll
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
    Left = 160
    Top = 248
  end
  inherited BarManager: TdxBarManager
    Left = 80
    Top = 231
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddMask'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbTaxCorrective'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbCorrective'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdatePrice'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateAmountPartner'
        end
        item
          Visible = True
          ItemName = 'bbCompleteTaxCorrective'
        end
        item
          Visible = True
          ItemName = 'bbUnCompleteTaxCorrective'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedTaxCorrective'
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
          ItemName = 'bbReportCheck'
        end
        item
          Visible = True
          ItemName = 'bbOpenReportCheckAmount'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenTax'
        end
        item
          Visible = True
          ItemName = 'bbOpenTaxCorrective'
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
          ItemName = 'bbMovementItemContainer'
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
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMIChildProtocol'
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
    inherited bbPrint: TdxBarButton
      Action = mactPrint
      Caption = #1055#1077#1095#1072#1090#1100' '#1042#1086#1079#1074#1088#1072#1090#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
    end
    object bbTaxCorrective: TdxBarButton
      Action = actTaxCorrective
      Category = 0
    end
    object bbCorrective: TdxBarButton
      Action = actCorrective
      Category = 0
    end
    object bbPrintTaxCorrective_Client: TdxBarButton
      Action = mactPrint_TaxCorrective_Client
      Category = 0
    end
    object bbPrintTaxCorrective_Us: TdxBarButton
      Action = mactPrint_TaxCorrective_Us
      Category = 0
    end
    object bbPrint_Return_By_TaxCorrective: TdxBarButton
      Action = actPrint_ReturnIn_by_TaxCorrective
      Category = 0
    end
    object bbCompleteTaxCorrective: TdxBarButton
      Action = actCompleteTaxCorrective
      Category = 0
    end
    object bbSetErasedTaxCorrective: TdxBarButton
      Action = actSetErasedTaxCorrective
      Category = 0
    end
    object bbUnCompleteTaxCorrective: TdxBarButton
      Action = actUnCompleteTaxCorrective
      Category = 0
    end
    object bbCalcAmountPartner: TdxBarControlContainerItem
      Caption = #1056#1072#1089#1095#1077#1090' <'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      Category = 0
      Hint = #1056#1072#1089#1095#1077#1090' <'#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      Visible = ivAlways
      Control = cbCalcAmountPartner
    end
    object bbOpenTaxCorrective: TdxBarButton
      Action = actOpenTaxCorrective
      Category = 0
    end
    object bbUpdatePrice: TdxBarButton
      Action = actUpdatePrice
      Category = 0
    end
    object bbPrintPriceCorr: TdxBarButton
      Action = mactPrintPriceCorr
      Category = 0
    end
    object bbUpdateAmountPartner: TdxBarButton
      Action = actUpdateAmountPartner
      Category = 0
    end
    object bbOpenTax: TdxBarButton
      Action = actOpenTax
      Category = 0
    end
    object bbOpenReportForm: TdxBarButton
      Action = actOpenReportForm
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actUpdateAuto
      Category = 0
    end
    object bbReportCheck: TdxBarButton
      Action = actOpenReportCheckForm
      Category = 0
    end
    object bbOpenReportCheckAmount: TdxBarButton
      Action = actOpenReportCheckAmountForm
      Category = 0
    end
    object bbMIChildProtocol: TdxBarButton
      Action = MIChildProtocolOpenForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnlyEditingCellOnEnter = True
    ColumnEnterList = <
      item
        Column = colName
      end
      item
        Column = colAmount
      end>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 4
      end>
    Left = 582
    Top = 345
  end
  inherited PopupMenu: TPopupMenu
    Left = 800
    Top = 464
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
    end
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
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportName'
        Value = 'PrintMovement_TaxCorrective'
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
    Top = 240
  end
  inherited StatusGuides: TdsdGuides
    Left = 56
    Top = 16
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_ReturnIn'
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
        Name = 'ioStatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDateSale'
        Value = 'NULL'
        Component = edStartDateTax
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
    Left = 56
    Top = 184
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ReturnIn'
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
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberMark'
        Value = ''
        Component = edInvNumberMark
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParentId'
        Value = Null
        Component = ParentChoiceGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Parent'
        Value = Null
        Component = ParentChoiceGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDatePartner'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = 'False'
        Component = edPriceWithVAT
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercent'
        Value = 0.000000000000000000
        Component = edChangePercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyValue'
        Value = 0.000000000000000000
        Component = edCurrencyValue
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagName'
        Value = Null
        Component = ContractTagGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyDocumentId'
        Value = ''
        Component = CurrencyDocumentGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyDocumentName'
        Value = ''
        Component = CurrencyDocumentGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyPartnerId'
        Value = ''
        Component = CurrencyPartnerGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyPartnerName'
        Value = ''
        Component = CurrencyPartnerGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Checked'
        Value = 'False'
        Component = edIsChecked
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListId'
        Value = '0'
        Component = PriceListGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListName'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DocumentTaxKindId'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DocumentTaxKindName'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Partion'
        Value = Null
        Component = SaleChoiceGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionMovementName'
        Value = Null
        Component = SaleChoiceGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPartner'
        Value = Null
        Component = cbPartner
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPromo'
        Value = Null
        Component = cbPromo
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDateTax'
        Value = 'NULL'
        Component = edStartDateTax
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'isList'
        Value = Null
        Component = cbList
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId_From'
        Value = Null
        Component = JuridicalFromGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName_From'
        Value = Null
        Component = JuridicalFromGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 224
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_ReturnIn'
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
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberMark'
        Value = ''
        Component = edInvNumberMark
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = ParentChoiceGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDatePartner'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChecked'
        Value = 'False'
        Component = edIsChecked
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartner'
        Value = Null
        Component = cbPartner
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceWithVAT'
        Value = 'False'
        Component = edPriceWithVAT
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisList'
        Value = Null
        Component = cbList
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inVATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChangePercent'
        Value = 0.000000000000000000
        Component = edChangePercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPaidKindId'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyDocumentId'
        Value = ''
        Component = CurrencyDocumentGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyPartnerId'
        Value = ''
        Component = CurrencyPartnerGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 328
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
      end>
    Left = 264
    Top = 264
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edInvNumberPartner
      end
      item
        Control = edInvNumberMark
      end
      item
        Control = edOperDate
      end
      item
        Control = edOperDatePartner
      end
      item
        Control = edFrom
      end
      item
        Control = edTo
      end
      item
        Control = edPriceWithVAT
      end
      item
        Control = edVATPercent
      end
      item
        Control = edChangePercent
      end
      item
        Control = edPaidKind
      end
      item
        Control = edContract
      end
      item
        Control = edContractTag
      end
      item
        Control = edIsChecked
      end
      item
        Control = edDocumentTaxKind
      end
      item
        Control = edCurrencyDocument
      end
      item
        Control = edCurrencyPartner
      end
      item
        Control = edCurrencyValue
      end
      item
        Control = cbPartner
      end
      item
        Control = edInvNumberParent
      end
      item
        Control = ceComment
      end
      item
        Control = cbList
      end>
    Left = 376
    Top = 305
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 560
    Top = 288
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ReturnIn_SetErased'
    Left = 694
    Top = 344
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ReturnIn_SetUnErased'
    Left = 718
    Top = 464
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_ReturnIn'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountPartner'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPartner'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsCalcAmountPartner'
        Value = Null
        Component = cbCalcAmountPartner
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountSummVat'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountSummVat'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHeadCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'HeadCount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_PartionTop'
        Value = Null
        Component = SaleChoiceGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_PartionMI'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Partion'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAssetId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AssetId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMovementId_Partion'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Partion'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPartionMovementName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionMovementName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 392
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_ReturnIn'
    Params = <
      item
        Name = 'ioId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountPartner'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsCalcAmountPartner'
        Value = Null
        Component = cbCalcAmountPartner
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHeadCount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_PartionTop'
        Value = Null
        Component = SaleChoiceGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_PartionMI'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Partion'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAssetId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AssetId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMovementId_Partion'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Partion'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPartionMovementName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionMovementName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 80
    Top = 312
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 468
    Top = 196
  end
  object RefreshDispatcher: TRefreshDispatcher
    CheckIdParam = True
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshPrice
    ComponentList = <
      item
        Component = PriceListGuides
      end
      item
        Component = ParentChoiceGuides
      end>
    Left = 464
    Top = 360
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
    Left = 250
    Top = 442
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
    Left = 426
    Top = 458
  end
  object spCorrective: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TaxCorrective_From_Kind'
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
        Name = 'inDocumentTaxKindId'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
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
        Component = edStartDateTax
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
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDocumentTaxKindName'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'TextValue'
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
    Left = 224
    Top = 300
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 469
    Top = 294
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
    Left = 944
    Top = 88
  end
  object PriceListGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList
    Key = '0'
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = PriceListGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = Null
        Component = edPriceWithVAT
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = Null
        Component = edVATPercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 812
    Top = 56
  end
  object spTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TaxCorrective_From_Kind'
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
        Name = 'inDocumentTaxKindId'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
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
        Component = edStartDateTax
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
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDocumentTaxKindName'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'TextValue'
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
    Left = 280
    Top = 336
  end
  object ContractGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract
    FormNameParam.Value = 'TContractForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 816
    Top = 11
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 468
    Top = 242
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
    Left = 306
    Top = 266
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
        Value = 'PrintMovement_TaxCorrective'
        Component = FormParams
        ComponentItem = 'ReportName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
    Top = 392
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
        DataType = ftString
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
    Left = 539
    Top = 4
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TContractChoicePartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoicePartnerForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagId'
        Value = Null
        Component = ContractTagGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagName'
        Value = Null
        Component = ContractTagGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercent'
        Value = 0.000000000000000000
        Component = edChangePercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 360
    Top = 1
  end
  object PaidKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 680
    Top = 12
  end
  object CurrencyDocumentGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCurrencyDocument
    FormNameParam.Value = 'TCurrency_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCurrency_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = CurrencyDocumentGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = CurrencyDocumentGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 1080
    Top = 40
  end
  object CurrencyPartnerGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCurrencyPartner
    FormNameParam.Value = 'TCurrency_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCurrency_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = CurrencyPartnerGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = CurrencyPartnerGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 992
  end
  object TaxCorrectiveCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 616
    Top = 226
  end
  object TaxCorrectiveDS: TDataSource
    DataSet = TaxCorrectiveCDS
    Left = 733
    Top = 226
  end
  object gpUpdateTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_TaxCorrective_DocChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = TaxCorrectiveCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = Null
        Component = TaxCorrectiveCDS
        ComponentItem = 'InvNumberPartner'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovement_ChildId'
        Value = Null
        Component = TaxCorrectiveCDS
        ComponentItem = 'DocumentChildId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 827
    Top = 250
  end
  object spSelectTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_TaxCorrective_DocChild'
    DataSet = TaxCorrectiveCDS
    DataSets = <
      item
        DataSet = TaxCorrectiveCDS
      end>
    Params = <
      item
        Name = 'inDocumentMasterId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 930
    Top = 226
  end
  object spMovementCompleteTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_TaxCorrective'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = TaxCorrectiveCDS
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
    PackSize = 1
    Left = 888
    Top = 321
  end
  object spMovementSetErasedTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_TaxCorrective'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = TaxCorrectiveCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 984
    Top = 281
  end
  object spMovementUnCompleteTaxCorrective: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_TaxCorrective'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = TaxCorrectiveCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 712
    Top = 289
  end
  object TaxCorrectiveViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = lDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = True
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 775
    Top = 388
  end
  object ContractTagGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContractTag
    FormNameParam.Value = 'TContractTagForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractTagForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractTagGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractTagGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 939
    Top = 65524
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
    Top = 408
  end
  object SaleChoiceGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumberSale
    Key = '0'
    FormNameParam.Value = 'TSaleJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TSaleJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = SaleChoiceGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = SaleChoiceGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = 42005d
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 396
    Top = 96
  end
  object ParentChoiceGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumberParent
    Key = '0'
    FormNameParam.Value = 'TReturnInJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TReturnInJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = ParentChoiceGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = ParentChoiceGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 'NULL'
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = 'NULL'
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 'NULL'
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerName'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 124
    Top = 88
  end
  object spUpdate_MI_ReturnIn_Price: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_ReturnIn_Price'
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
        Name = 'inPriceListId'
        Value = Null
        Component = PriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 664
    Top = 408
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
        Value = 'PrintMovement_TaxCorrective'
        Component = FormParams
        ComponentItem = 'ReportName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 376
    Top = 392
  end
  object spUpdate_MI_ReturnIn_AmountPartner: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_ReturnIn_AmountPartner'
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
      end>
    PackSize = 1
    Left = 536
    Top = 424
  end
  object DetailCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'ParentId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 72
    Top = 592
  end
  object DetailDS: TDataSource
    DataSet = DetailCDS
    Left = 136
    Top = 584
  end
  object spSelect_MI_Child: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItemChild_ReturnIn'
    DataSet = DetailCDS
    DataSets = <
      item
        DataSet = DetailCDS
      end>
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
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 232
    Top = 592
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = 0.000000000000000000
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = -1
      end>
    SearchAsFilter = False
    Left = 1094
    Top = 393
  end
  object spUpdateAuto: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_ReturnIn_Auto'
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
        Name = 'inStartDateTax'
        Value = 42181d
        Component = edStartDateTax
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
    Left = 224
    Top = 364
  end
  object JuridicalFromGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridicalFrom
    FormNameParam.Name = 'TJuridical_ObjectForm'
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 425
    Top = 16
  end
  object spUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_ReturnIn_Child'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Sale'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'MovementId_Sale'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementItemId_sale'
        Value = Null
        Component = DetailCDS
        ComponentItem = 'MovementItemId_sale'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 576
  end
end
