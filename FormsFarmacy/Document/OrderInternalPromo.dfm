inherited OrderInternalPromoForm: TOrderInternalPromoForm
  Caption = #1047#1072#1103#1074#1082#1080' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1077' ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099')'
  ClientHeight = 564
  ClientWidth = 1025
  AddOnFormData.AddOnFormRefresh.ParentList = 'Sale'
  ExplicitWidth = 1041
  ExplicitHeight = 603
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 116
    Width = 1025
    Height = 348
    ExplicitTop = 116
    ExplicitWidth = 1025
    ExplicitHeight = 348
    ClientRectBottom = 348
    ClientRectRight = 1025
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1025
      ExplicitHeight = 324
      inherited cxGrid: TcxGrid
        Width = 1025
        Height = 144
        ExplicitWidth = 1025
        ExplicitHeight = 144
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountManual
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummSIP
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountManual
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummSIP
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end>
          OptionsBehavior.IncSearch = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object isReport: TcxGridDBColumn
            Caption = #1044#1083#1103' '#1086#1090#1095#1077#1090#1072', '#1076#1072'/'#1085#1077#1090
            DataBinding.FieldName = 'isReport'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1089#1090'. '#1074' '#1089#1087#1080#1089#1082#1077' '#1076#1083#1103' '#1086#1090#1095#1077#1090#1072
            Options.Editing = False
            Width = 63
          end
          object isChecked: TcxGridDBColumn
            Caption = #1044#1083#1103' '#1088#1072#1089#1095#1077#1090#1072
            DataBinding.FieldName = 'isChecked'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object isComplement: TcxGridDBColumn
            Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1100' '#1076#1086' N'
            DataBinding.FieldName = 'isComplement'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AddToM: TcxGridDBColumn
            Caption = #1041#1077#1079' '#1087#1088#1086#1076#1072#1078' '#1076#1086#1087#1086#1083#1085#1080#1090#1100' '#1076#1086' M'
            DataBinding.FieldName = 'AddToM'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 72
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 126
          end
          object GoodsGroupPromoName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1076#1083#1103' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072
            DataBinding.FieldName = 'GoodsGroupPromoName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 126
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 223
          end
          object minExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'minExpirationDate'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076'.'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084' ('#1079#1072#1082#1072#1079')'
            Width = 67
          end
          object AmountManual: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1088#1091#1095#1085#1086#1081' '#1074#1074#1086#1076', '#1096#1090
            DataBinding.FieldName = 'AmountManual'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 66
          end
          object Summ: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          object PriceSIP: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1057#1048#1055
            DataBinding.FieldName = 'PriceSIP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object SummSIP: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1057#1048#1055
            DataBinding.FieldName = 'SummSIP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'JuridicalName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actContractChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1070#1088'. '#1083#1080#1094#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082
            Width = 64
          end
          object ContractName: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'ContractName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actContractChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1075#1086#1074#1086#1088' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Width = 64
          end
          object InvNumber_Promo_Full: TcxGridDBColumn
            Caption = #8470' '#1052#1072#1088#1082#1077#1090'. '#1082#1086#1085#1090#1088#1072#1082#1090#1072
            DataBinding.FieldName = 'InvNumber_Promo_Full'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1082#1086#1085#1090#1088#1072#1082#1090
            Options.Editing = False
            Width = 67
          end
          object MakerName_Promo: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100' ('#1084#1072#1088#1082#1077#1090'. '#1082#1086#1085#1090#1088#1072#1082#1090')'
            DataBinding.FieldName = 'MakerName_Promo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 112
          end
          object AmountTotal: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1086#1089#1090#1072#1090#1086#1082' + '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'AmountTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1086#1089#1090#1072#1090#1086#1082' + '#1079#1072#1082#1072#1079
            Options.Editing = False
            Width = 70
          end
          object AmountOut_avg: TcxGridDBColumn
            Caption = #1057#1088'. '#1087#1088#1086#1076#1072#1078#1072
            DataBinding.FieldName = 'AmountOut_avg'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1088#1077#1076#1085#1103#1103' '#1087#1088#1086#1076#1072#1078#1072
            Options.Editing = False
            Width = 70
          end
          object RemainsDay: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081
            DataBinding.FieldName = 'RemainsDay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081
            Options.Editing = False
            Width = 70
          end
          object RemainsDay2: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' ('#1073#1077#1079' '#1091#1095'. '#1086#1090#1088'.'#1082#1086#1101#1092'.)'
            DataBinding.FieldName = 'RemainsDay2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 152
        Width = 1025
        Height = 172
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
              Column = chAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chRemains
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = chKoeff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountManual
            end
            item
              Format = ',0.###'
              Kind = skSum
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = chKoeff2
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chRemains
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = chKoeff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = chAmountManual
            end
            item
              Format = ',0.###'
              Kind = skSum
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = chKoeff2
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.IncSearch = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.Appending = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object chUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = UnitChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 235
          end
          object chAmount: TcxGridDBColumn
            Caption = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1085#1099#1081' '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1085#1099#1081' '#1079#1072#1082#1072#1079
            Options.Editing = False
            Width = 120
          end
          object chAmountManual: TcxGridDBColumn
            Caption = #1056#1091#1095#1085#1086#1081' '#1074#1074#1086#1076', '#1096#1090
            DataBinding.FieldName = 'AmountManual'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086', '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1085#1086#1077' '#1074#1088#1091#1095#1085#1091#1102
            Width = 88
          end
          object chAmountOut: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1092#1072#1082#1090' '#1087#1088#1086#1076#1072#1078
            DataBinding.FieldName = 'AmountOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1072#1082#1090' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 129
          end
          object chRemains: TcxGridDBColumn
            Caption = #1054#1089#1090'.'
            DataBinding.FieldName = 'Remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1082#1086#1085#1077#1094' '#1076#1085#1103
            Options.Editing = False
            Width = 133
          end
          object chKoeff: TcxGridDBColumn
            Caption = #1050#1086#1101#1092#1092'.'
            DataBinding.FieldName = 'Koeff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1087#1088#1080#1086#1088#1080#1090#1077#1090#1072
            Options.Editing = False
            Width = 100
          end
          object chKoeff2: TcxGridDBColumn
            Caption = #1050#1086#1101#1092#1092'.(2)'
            DataBinding.FieldName = 'Koeff2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090' '#1087#1088#1080#1086#1088#1080#1090#1077#1090#1072
            Options.Editing = False
            Width = 100
          end
          object chRemainsDay: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081
            DataBinding.FieldName = 'RemainsDay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object chIsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'IsErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 144
        Width = 1025
        Height = 8
        Touch.ParentTabletOptions = False
        Touch.TabletOptions = [toPressAndHold]
        AlignSplitter = salBottom
        Control = cxGrid1
      end
      object cxGridExport: TcxGrid
        Left = 646
        Top = 76
        Width = 370
        Height = 218
        TabOrder = 3
        Visible = False
        object cxGridExportDBTableView: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = ExportItemsDS
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsView.GroupByBox = False
          object geGoodsName: TcxGridDBColumn
            DataBinding.FieldName = 'GoodsName'
            Visible = False
            Options.Editing = False
            Options.ShowCaption = False
            Width = 140
          end
          object geJuridicalName: TcxGridDBColumn
            DataBinding.FieldName = 'JuridicalName'
            Visible = False
            Options.Editing = False
            Options.ShowCaption = False
            Width = 99
          end
        end
        object cxGridExportLevel1: TcxGridLevel
          GridView = cxGridExportDBTableView
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1025
    Height = 90
    TabOrder = 3
    ExplicitWidth = 1025
    ExplicitHeight = 90
    inherited edInvNumber: TcxTextEdit
      Left = 168
      ExplicitLeft = 168
    end
    inherited cxLabel1: TcxLabel
      Left = 168
      ExplicitLeft = 168
    end
    inherited edOperDate: TcxDateEdit
      Left = 372
      EditValue = 43790d
      ExplicitLeft = 372
    end
    inherited cxLabel2: TcxLabel
      Left = 372
      Top = 6
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085'. '#1087#1088#1086#1076#1072#1078
      ExplicitLeft = 372
      ExplicitTop = 6
      ExplicitWidth = 103
    end
    inherited cxLabel15: TcxLabel
      Top = 6
      ExplicitTop = 6
    end
    inherited ceStatus: TcxButtonEdit
      Top = 22
      ExplicitTop = 22
      ExplicitWidth = 153
      ExplicitHeight = 22
      Width = 153
    end
    object lblUnit: TcxLabel
      Left = 478
      Top = 6
      Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
    end
    object edRetail: TcxButtonEdit
      Left = 478
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 320
    end
    object cxLabel7: TcxLabel
      Left = 8
      Top = 45
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object edComment: TcxTextEdit
      Left = 8
      Top = 62
      Properties.ReadOnly = False
      TabOrder = 9
      Width = 412
    end
    object ceTotalAmount: TcxCurrencyEdit
      Left = 678
      Top = 62
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.ReadOnly = False
      TabOrder = 10
      Width = 120
    end
    object cxLabel5: TcxLabel
      Left = 678
      Top = 46
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1083#1103' '#1088#1072#1089#1087#1088'.'
    end
    object ceDaysGrace: TcxCurrencyEdit
      Left = 804
      Top = 62
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0; -0; ;'
      Properties.ReadOnly = False
      TabOrder = 12
      Width = 93
    end
    object cxLabel8: TcxLabel
      Left = 804
      Top = 47
      Caption = #1044#1085#1077#1081' '#1086#1090#1089#1088#1086#1095#1082#1080
    end
    object deDateSent: TcxDateEdit
      Left = 804
      Top = 23
      EditValue = 43790d
      TabOrder = 14
      Width = 93
    end
    object cxLabel9: TcxLabel
      Left = 804
      Top = 6
      Caption = #1044#1072#1090#1072' '#1086#1090#1087#1088#1072#1074#1082#1080
    end
  end
  object edStartSale: TcxDateEdit [2]
    Left = 264
    Top = 23
    EditValue = 43580d
    TabOrder = 6
    Width = 100
  end
  object cxLabel3: TcxLabel [3]
    Left = 264
    Top = 6
    Caption = #1044#1072#1090#1072' '#1085#1072#1095'. '#1087#1088#1086#1076#1072#1078
  end
  object cxSplitter2: TcxSplitter [4]
    Left = 0
    Top = 464
    Width = 1025
    Height = 8
    Touch.ParentTabletOptions = False
    Touch.TabletOptions = [toPressAndHold]
    AlignSplitter = salBottom
    Control = cxGrid2
  end
  object cxGrid2: TcxGrid [5]
    Left = 0
    Top = 472
    Width = 1025
    Height = 92
    Align = alBottom
    PopupMenu = PopupMenu
    TabOrder = 9
    object cxGridDBTableView2: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = PartnerDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsBehavior.IncSearch = True
      OptionsBehavior.FocusCellOnCycle = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.DataRowSizing = True
      OptionsData.Appending = True
      OptionsData.CancelOnExit = False
      OptionsData.DeletingConfirmation = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clIsReport: TcxGridDBColumn
        Caption = #1044#1083#1103' '#1086#1090#1095#1077#1090#1072', '#1076#1072'/'#1085#1077#1090
        DataBinding.FieldName = 'IsReport'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 101
      end
      object clJuridicalCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'JuridicalCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1076' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
        Width = 49
      end
      object clJuridicalName: TcxGridDBColumn
        Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082' ('#1076#1083#1103' '#1086#1090#1095#1077#1090#1072')'
        DataBinding.FieldName = 'JuridicalName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = PartnerChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 414
      end
      object clComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 343
      end
      object CorrPrice: TcxGridDBColumn
        Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1094#1077#1085#1099
        DataBinding.FieldName = 'CorrPrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '+ ,0.#### %;- ,0.#### %; ;'
        Width = 111
      end
    end
    object cxGridLevel2: TcxGridLevel
      GridView = cxGridDBTableView2
    end
  end
  object ceTotalSummPrice: TcxCurrencyEdit [6]
    Left = 426
    Top = 62
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = False
    TabOrder = 10
    Width = 120
  end
  object cxLabel4: TcxLabel [7]
    Left = 426
    Top = 46
    Caption = #1057#1091#1084#1084#1072' '#1087#1086' '#1094#1077#1085#1072#1084' '#1087#1088#1072#1081#1089#1072
  end
  object ceTotalSummSIP: TcxCurrencyEdit [8]
    Left = 552
    Top = 62
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = False
    TabOrder = 12
    Width = 120
  end
  object cxLabel6: TcxLabel [9]
    Left = 552
    Top = 46
    Caption = #1057#1091#1084#1084#1072' '#1087#1086' '#1094#1077#1085#1072#1084' '#1057#1048#1055
  end
  inherited ActionList: TActionList
    Left = 199
    Top = 303
    object actExecSPSelectExportJuridical: TdsdExecStoredProc [0]
      Category = 'SendEMail'
      MoveParams = <>
      BeforeAction = actLoadListUnit
      PostDataSetBeforeExecute = False
      StoredProc = spSelectExportJuridical
      StoredProcList = <
        item
          StoredProc = spSelectExportJuridical
        end>
      Caption = 'actExportStoredproc'
    end
    object actRefreshPromoPartner: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPromoPartner
      StoredProcList = <
        item
          StoredProc = spSelectPromoPartner
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshMI: TdsdDataSetRefresh [2]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MI_PromoChild
        end
        item
          StoredProc = spSelectPromoPartner
        end
        item
        end>
    end
    object actMISetErasedChild: TdsdUpdateErased [4]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedMIChild
      StoredProcList = <
        item
          StoredProc = spErasedMIChild
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1102
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = DetailDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actSetErasedPromoPartner: TdsdUpdateErased [6]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSetErasedPromoPartner
      StoredProcList = <
        item
          StoredProc = spSetErasedPromoPartner
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = PartnerDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actSetUnErasedPromoPartner: TdsdUpdateErased [8]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnCompletePromoPartner
      StoredProcList = <
        item
          StoredProc = spUnCompletePromoPartner
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = PartnerDS
    end
    object actMISetUnErasedChild: TdsdUpdateErased [9]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErasedMIChild
      StoredProcList = <
        item
          StoredProc = spUnErasedMIChild
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = DetailDS
    end
    inherited actShowErased: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectPromoPartner
        end
        item
          StoredProc = spSelect_MI_PromoChild
        end>
    end
    object InsertRecordPartner: TInsertRecord [13]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      View = cxGridDBTableView2
      Action = PartnerChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      ImageIndex = 0
    end
    object InsertRecordPromoMaster: TInsertRecord [14]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      View = cxGridDBTableView
      Action = actGoodsPromoChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088' '#1084#1072#1088#1082#1077#1090'. '#1082#1086#1085#1090#1088#1072#1082#1090#1072'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088' '#1084#1072#1088#1082#1077#1090'. '#1082#1086#1085#1090#1088#1072#1082#1090#1072'>'
      ImageIndex = 0
    end
    object InsertRecordMaster: TInsertRecord [15]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      View = cxGridDBTableView
      Action = actGoodsChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      ImageIndex = 0
    end
    object InsertRecordChild: TInsertRecord [16]
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      View = cxGridDBTableView1
      Action = UnitChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      ShortCut = 45
      ImageIndex = 0
    end
    inherited actShowAll: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MI_PromoChild
        end>
    end
    object actUpdatePartnerDS: TdsdUpdateDataSet [18]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdatePromoPartner
      StoredProcList = <
        item
          StoredProc = spInsertUpdatePromoPartner
        end
        item
          StoredProc = spSelect
        end>
      Caption = 'actUpdatePartnerDS'
      DataSource = PartnerDS
    end
    object actUpdateChildDS: TdsdUpdateDataSet [19]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIChild
        end
        item
          StoredProc = spSelect_MI_PromoChild
        end>
      Caption = 'actUpdateChildDS'
      DataSource = DetailDS
    end
    object actDoLoad: TExecuteImportSettingsAction [20]
      Category = 'Load'
      MoveParams = <>
      ImportSettingsId.Value = '0'
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
        end>
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      ReportName = #1055#1088#1086#1076#1072#1078#1072
      ReportNameParam.Value = #1055#1088#1086#1076#1072#1078#1072
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
          StoredProc = spGet
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
          StoredProc = spGet
        end>
    end
    object actContractChoice: TOpenChoiceForm [31]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ContractChoiceForm'
      FormName = 'TContract_ObjectForm'
      FormNameParam.Value = 'TContract_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ContractName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actGoodsPromoChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsPromoChoiceForm'
      FormName = 'TGoodsPromoChoiceForm'
      FormNameParam.Value = 'TGoodsPromoChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
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
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_Promo'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterOperDate'
          Value = Null
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterRetailId'
          Value = Null
          Component = GuidesRetail
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterRetailName'
          Value = Null
          Component = GuidesRetail
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object PartnerChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'JuridicalChoiceForm'
      FormName = 'TJuridicalForm'
      FormNameParam.Value = 'TJuridicalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = PartnerDCS
          ComponentItem = 'JuridicalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = PartnerDCS
          ComponentItem = 'JuridicalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actGoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsChoiceForm'
      FormName = 'TGoodsRetailForm'
      FormNameParam.Value = 'TGoodsRetailForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
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
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'RetailId'
          Value = Null
          Component = GuidesRetail
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'RetailName'
          Value = Null
          Component = GuidesRetail
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUnitForOrderInternalPromo: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103'> ('#1079#1072#1103#1074#1082#1080' '#1074#1085'. ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099'))'
      Hint = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103'> ('#1079#1072#1103#1074#1082#1080' '#1074#1085'. ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099'))'
      ImageIndex = 32
      FormName = 'TUnitForOrderInternalPromoForm'
      FormNameParam.Value = 'TUnitForOrderInternalPromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inRetailId'
          Value = ''
          Component = GuidesRetail
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inRetailName'
          Value = ''
          Component = GuidesRetail
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inStartDate'
          Value = 43580d
          Component = edStartSale
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = 43790d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPromoJournalChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'PromoJournalForm'
      FormName = 'TPromoJournalForm'
      FormNameParam.Value = 'TPromoJournalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = FormParams
          ComponentItem = 'MovementId_promo'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = FormParams
          ComponentItem = 'InvNumber_promo'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actOpenReport: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1054#1090#1095#1077#1090' <'#1047#1072#1103#1074#1082#1080' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1077' ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099')>'
      Hint = #1054#1090#1095#1077#1090' <'#1047#1072#1103#1074#1082#1080' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1077' ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099')>'
      ImageIndex = 26
      FormName = 'TReport_OrderInternalPromoOLAPForm'
      FormNameParam.Value = 'TReport_OrderInternalPromoOLAPForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inRetailId'
          Value = ''
          Component = GuidesRetail
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inRetailName'
          Value = Null
          Component = GuidesRetail
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inStartDate'
          Value = Null
          Component = edStartSale
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object UnitChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'UnitChoiceForm'
      FormName = 'TUnit_ObjectForm'
      FormNameParam.Value = 'TUnit_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'key'
          Value = Null
          Component = DetailDCS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = DetailDCS
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateMasterAmount: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMasterAmount
      StoredProcList = <
        item
          StoredProc = spUpdateMasterAmount
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103
      Hint = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103
      ImageIndex = 45
      QuestionBeforeExecute = #1056#1072#1089#1089#1095#1080#1090#1072#1090#1100' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1083#1103' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1103'?'
    end
    object macInsertPromoPartner: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actInsertPromoPartner
        end
        item
          Action = actRefreshPromoPartner
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1087#1086#1083#1085#1080#1090#1100' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084#1080' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102'?'
      InfoAfterExecute = #1055#1086#1089#1090#1072#1074#1097#1080#1082#1080' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' '#1079#1072#1087#1086#1083#1085#1077#1085#1099
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084#1080' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084#1080' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
      ImageIndex = 27
    end
    object actInsertUpdate_MovementItem_Promo_Set_Zero: TdsdExecStoredProc
      Category = 'Load'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate_MovementItem_Promo_Set_Zero
      StoredProcList = <
        item
          StoredProc = spInsertUpdate_MovementItem_Promo_Set_Zero
        end>
      Caption = 'actInsertUpdate_MovementItem_Promo_Set_Zero'
    end
    object actUpdateMaster_calc: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMaster_calc
      StoredProcList = <
        item
          StoredProc = spUpdateMaster_calc
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectPromoPartner
        end>
      Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1088#1072#1089#1095#1077#1090
      Hint = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1088#1072#1089#1095#1077#1090
      ImageIndex = 74
    end
    object actUpdate_Price: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Price
      StoredProcList = <
        item
          StoredProc = spUpdate_Price
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectPromoPartner
        end>
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1094#1077#1085#1099' '#1085#1072' '#1090#1077#1082'.'#1076#1072#1090#1091
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1094#1077#1085#1099' '#1085#1072' '#1090#1077#1082'.'#1076#1072#1090#1091
      ImageIndex = 56
    end
    object actGetImportSettingId: TdsdExecStoredProc
      Category = 'Load'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSettingId
      StoredProcList = <
        item
          StoredProc = spGetImportSettingId
        end>
      Caption = 'actGetImportSettingId'
    end
    object actStartLoad: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSettingId
        end
        item
          Action = actInsertUpdate_MovementItem_Promo_Set_Zero
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1076#1072#1085#1085#1099#1093' '#1074' '#1090#1077#1082#1091#1097#1080#1081' '#1076#1086#1082#1091#1084#1077#1085#1090'?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      ImageIndex = 41
    end
    object actInsertPromoPartner: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      StoredProc = spInsertPromoPartner
      StoredProcList = <
        item
          StoredProc = spInsertPromoPartner
        end>
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084#1080' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084#1080' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
      ImageIndex = 27
    end
    object actUpdateMovementItemContainer: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MovementItemContainer
      StoredProcList = <
        item
          StoredProc = spUpdate_MovementItemContainer
        end
        item
          StoredProc = spGet
        end>
      Caption = #1055#1088#1086#1087#1080#1089#1072#1090#1100' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1082#1086#1085#1090#1088#1072#1082#1090' '#1074' '#1087#1088#1080#1093#1086#1076#1099' '#1080' '#1095#1077#1082#1080
      Hint = #1055#1088#1086#1087#1080#1089#1072#1090#1100' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1082#1086#1085#1090#1088#1072#1082#1090' '#1074' '#1087#1088#1080#1093#1086#1076#1099' '#1080' '#1095#1077#1082#1080
      ImageIndex = 43
      QuestionBeforeExecute = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1087#1088#1086#1087#1080#1089#1100' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1086#1075#1086' '#1082#1086#1085#1090#1088#1072#1082#1090#1072' '#1074' '#1087#1088#1080#1093#1086#1076#1099' '#1080' '#1095#1077#1082#1080
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
    end
    object actInsertMaster: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertByPromo
      StoredProcList = <
        item
          StoredProc = spInsertByPromo
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectPromoPartner
        end>
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1086#1074#1072#1088#1072#1084#1080' '#1080#1079' '#1084#1072#1088#1082#1077#1090'- '#1082#1086#1085#1090#1088#1072#1082#1090#1072
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1086#1074#1072#1088#1072#1084#1080' '#1080#1079' '#1084#1072#1088#1082#1077#1090'- '#1082#1086#1085#1090#1088#1072#1082#1090#1072
      ImageIndex = 27
    end
    object actInsertOrderInternal: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertOrderInternal
      StoredProcList = <
        item
          StoredProc = spInsertOrderInternal
        end>
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1047#1072#1103#1074#1082#1080' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1077'>'
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1047#1072#1103#1074#1082#1080' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1077'>'
      ImageIndex = 30
      QuestionBeforeExecute = #1057#1086#1079#1076#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' <'#1047#1072#1103#1074#1082#1080' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1077'>?'
      InfoAfterExecute = #1044#1086#1082#1091#1084#1077#1085#1090#1099' <'#1047#1072#1103#1074#1082#1080' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1077'> '#1089#1086#1079#1076#1072#1085#1099
    end
    object actInsertChild: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actLoadListUnit
      PostDataSetBeforeExecute = False
      StoredProc = spInsertChild
      StoredProcList = <
        item
          StoredProc = spInsertChild
        end
        item
          StoredProc = spSelect_MI_PromoChild
        end>
      Caption = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1080#1090#1100' '#1079#1072#1082#1072#1079' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084
      Hint = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1080#1090#1100' '#1079#1072#1082#1072#1079' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084
      ImageIndex = 7
      QuestionBeforeExecute = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1080#1090#1100' '#1079#1072#1082#1072#1079' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084'?'
      InfoAfterExecute = #1047#1072#1082#1072#1079#1099' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1099
    end
    object macInsertByPromo: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actPromoJournalChoiceForm
        end
        item
          Action = actInsertMaster
        end>
      QuestionBeforeExecute = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1086#1074#1072#1088#1072#1084#1080' '#1080#1079' '#1084#1072#1088#1082#1077#1090'- '#1082#1086#1085#1090#1088#1072#1082#1090#1072'?'
      InfoAfterExecute = #1058#1086#1074#1072#1088#1099' '#1079#1072#1087#1086#1083#1085#1077#1085#1099
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1086#1074#1072#1088#1072#1084#1080' '#1080#1079' '#1084#1072#1088#1082#1077#1090'- '#1082#1086#1085#1090#1088#1072#1082#1090#1072
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1086#1074#1072#1088#1072#1084#1080' '#1080#1079' '#1084#1072#1088#1082#1077#1090'- '#1082#1086#1085#1090#1088#1072#1082#1090#1072
    end
    object actUnitTreeForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceUnitTreeForm'
      FormName = 'TUnitTreeForm'
      FormNameParam.Value = 'TUnitTreeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'UnitID'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actInsert_Movement_Send: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actUnitTreeForm
      PostDataSetBeforeExecute = False
      StoredProc = spInsert_Movement_Send
      StoredProcList = <
        item
          StoredProc = spInsert_Movement_Send
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1087#1086' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1105#1085#1085#1086#1084#1091' '#1090#1086#1074#1072#1088#1091
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1087#1086' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1105#1085#1085#1086#1084#1091' '#1090#1086#1074#1072#1088#1091
      ImageIndex = 28
      QuestionBeforeExecute = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1087#1086' '#1088#1072#1089#1087#1088#1077#1076#1077#1083#1105#1085#1085#1086#1084#1091' '#1090#1086#1074#1072#1088#1091'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
    end
    object actDistributionCalculation: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1087#1086' '#1089#1091#1084#1084#1077
      Hint = #1056#1072#1089#1087#1088#1077#1076#1077#1083#1077#1085#1080#1077' '#1087#1086' '#1089#1091#1084#1084#1077
      ImageIndex = 42
      FormName = 'TReport_OrderInternalPromo_DistributionCalculationForm'
      FormNameParam.Value = 'TReport_OrderInternalPromo_DistributionCalculationForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actSetChecked: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefreshMI
      ActionList = <
        item
          Action = actExecSetChecked
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1044#1083#1103' '#1088#1072#1089#1095#1077#1090#1072'" '#1085#1072' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1087#1086#1079#1080#1094#1080#1080'?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1044#1083#1103' '#1088#1072#1089#1095#1077#1090#1072'"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1044#1083#1103' '#1088#1072#1089#1095#1077#1090#1072'"'
      ImageIndex = 79
    end
    object actExecSetChecked: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSetChecked
      StoredProcList = <
        item
          StoredProc = spSetChecked
        end>
      Caption = 'actExecSetChecked'
    end
    object actClearChecked: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefreshMI
      ActionList = <
        item
          Action = actExecClearChecked
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1044#1083#1103' '#1088#1072#1089#1095#1077#1090#1072'" '#1085#1072' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1087#1086#1079#1080#1094#1080#1080'?'
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1044#1083#1103' '#1088#1072#1089#1095#1077#1090#1072'"'
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1044#1083#1103' '#1088#1072#1089#1095#1077#1090#1072'"'
      ImageIndex = 52
    end
    object actExecClearChecked: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spClearChecked
      StoredProcList = <
        item
          StoredProc = spClearChecked
        end>
      Caption = 'actExecClearComplement'
    end
    object actSetComplement: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefreshMI
      ActionList = <
        item
          Action = actExecSetComplement
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1044#1086#1087#1086#1083#1085#1080#1090#1100' '#1076#1086' N" '#1085#1072' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1087#1086#1079#1080#1094#1080#1080'?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1044#1086#1087#1086#1083#1085#1080#1090#1100' '#1076#1086' N"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1044#1086#1087#1086#1083#1085#1080#1090#1100' '#1076#1086' N"'
      ImageIndex = 79
    end
    object actExecSetComplement: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSetComplement
      StoredProcList = <
        item
          StoredProc = spSetComplement
        end>
      Caption = 'actExecSetComplement'
    end
    object actClearComplement: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefreshMI
      ActionList = <
        item
          Action = actExecClearComplement
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1044#1086#1087#1086#1083#1085#1080#1090#1100' '#1076#1086' N" '#1085#1072' '#1074#1099#1073#1088#1072#1085#1085#1099#1077' '#1087#1086#1079#1080#1094#1080#1080'?'
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1044#1086#1087#1086#1083#1085#1080#1090#1100' '#1076#1086' N"'
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1044#1086#1087#1086#1083#1085#1080#1090#1100' '#1076#1086' N"'
      ImageIndex = 52
    end
    object actExecClearComplement: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spClearComplement
      StoredProcList = <
        item
          StoredProc = spClearComplement
        end>
      Caption = 'actExecClearComplement'
    end
    object actExportStoredproc: TdsdExecStoredProc
      Category = 'SendEMail'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetExportParam
      StoredProcList = <
        item
          StoredProc = spGetExportParam
        end
        item
          StoredProc = spSelectExport
        end>
      Caption = 'actExportStoredproc'
    end
    object actExportToPartner: TExportGrid
      Category = 'SendEMail'
      TabSheet = tsMain
      MoveParams = <>
      ColumnNameDataSet = ExportHeaderCDS
      Grid = cxGridExport
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080
      OpenAfterCreate = False
    end
    object actGetDocumentDataForEmail: TdsdExecStoredProc
      Category = 'SendEMail'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetDocumentDataForEmail
      StoredProcList = <
        item
          StoredProc = spGetDocumentDataForEmail
        end>
      Caption = 'actGetDocumentDataForEmail'
    end
    object SMTPFileAction: TdsdSMTPFileAction
      Category = 'SendEMail'
      MoveParams = <>
      Host.Value = '0'
      Host.Component = FormParams
      Host.ComponentItem = 'Host'
      Host.MultiSelectSeparator = ','
      Port.Value = '0'
      Port.Component = FormParams
      Port.ComponentItem = 'Port'
      Port.MultiSelectSeparator = ','
      UserName.Value = '0'
      UserName.Component = FormParams
      UserName.ComponentItem = 'UserName'
      UserName.MultiSelectSeparator = ','
      Password.Value = '0'
      Password.Component = FormParams
      Password.ComponentItem = 'Password'
      Password.MultiSelectSeparator = ','
      Body.Value = '0'
      Body.Component = FormParams
      Body.ComponentItem = 'Body'
      Body.MultiSelectSeparator = ','
      Subject.Value = '0'
      Subject.Component = FormParams
      Subject.ComponentItem = 'Subject'
      Subject.MultiSelectSeparator = ','
      FromAddress.Value = '0'
      FromAddress.Component = FormParams
      FromAddress.ComponentItem = 'AddressFrom'
      FromAddress.MultiSelectSeparator = ','
      ToAddress.Value = '0'
      ToAddress.Component = FormParams
      ToAddress.ComponentItem = 'AddressTo'
      ToAddress.MultiSelectSeparator = ','
    end
    object mactSMTPSend: TMultiAction
      Category = 'SendEMail'
      MoveParams = <>
      ActionList = <
        item
          Action = actExportStoredproc
        end
        item
          Action = actExportToPartner
        end
        item
          Action = actGetDocumentDataForEmail
        end
        item
          Action = SMTPFileAction
        end>
      Caption = #1054#1090#1087#1088#1072#1074#1082#1072' E-mail'
      Hint = #1054#1090#1087#1088#1072#1074#1082#1072' E-mail'
      ImageIndex = 53
    end
    object actGetDocumentDataForEmailGroup: TdsdExecStoredProc
      Category = 'SendEMail'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetDocumentDataForEmailGroup
      StoredProcList = <
        item
          StoredProc = spGetDocumentDataForEmailGroup
        end>
      Caption = 'actGetDocumentDataForEmailGroup'
    end
    object SMTPAction: TdsdSMTPAction
      Category = 'SendEMail'
      MoveParams = <>
      Host.Value = Null
      Host.Component = FormParams
      Host.ComponentItem = 'Host'
      Host.DataType = ftString
      Host.MultiSelectSeparator = ','
      Port.Value = 25
      Port.Component = FormParams
      Port.ComponentItem = 'Port'
      Port.MultiSelectSeparator = ','
      UserName.Value = Null
      UserName.Component = FormParams
      UserName.ComponentItem = 'UserName'
      UserName.DataType = ftString
      UserName.MultiSelectSeparator = ','
      Password.Value = Null
      Password.Component = FormParams
      Password.ComponentItem = 'Password'
      Password.DataType = ftString
      Password.MultiSelectSeparator = ','
      Body.Value = Null
      Body.Component = FormParams
      Body.ComponentItem = 'Body'
      Body.DataType = ftWideString
      Body.MultiSelectSeparator = ','
      Subject.Value = Null
      Subject.Component = FormParams
      Subject.ComponentItem = 'Subject'
      Subject.DataType = ftString
      Subject.MultiSelectSeparator = ','
      FromAddress.Value = Null
      FromAddress.Component = FormParams
      FromAddress.ComponentItem = 'AddressFrom'
      FromAddress.DataType = ftString
      FromAddress.MultiSelectSeparator = ','
      ToAddress.Value = Null
      ToAddress.Component = FormParams
      ToAddress.ComponentItem = 'AddressTo'
      ToAddress.DataType = ftString
      ToAddress.MultiSelectSeparator = ','
    end
    object mactSMTPSendGroup: TMultiAction
      Category = 'SendEMail'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetDocumentDataForEmailGroup
        end
        item
          Action = SMTPAction
        end>
      Caption = #1054#1090#1087#1088#1072#1074#1082#1072' E-mail'
      Hint = #1054#1090#1087#1088#1072#1074#1082#1072' E-mail'
      ImageIndex = 53
    end
    object actSMTPSend: TMultiAction
      Category = 'SendEMail'
      MoveParams = <>
      AfterAction = mactSMTPSendGroup
      BeforeAction = actExecSPSelectExportJuridical
      ActionList = <
        item
          Action = mactSMTPSend
        end
        item
          Action = actUpdate_Sent
        end
        item
          Action = actCompleteMovement
        end>
      DataSource = ExportJuridicalDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1086#1090#1089#1099#1083#1082#1077' E-mail '#1087#1086' '#1074#1089#1077#1084' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084'?'
      InfoAfterExecute = 'E-mail '#1087#1086' '#1074#1089#1077#1084' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084' '#1086#1090#1087#1088#1072#1074#1083#1077#1085
      Caption = #1054#1090#1087#1088#1072#1074#1082#1072' E-mail '#1074#1089#1077#1084' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      Hint = #1054#1090#1087#1088#1072#1074#1082#1072' E-mail '#1074#1089#1077#1084' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      ImageIndex = 53
      ShortCut = 16467
    end
    object actLoadListUnit: TdsdLoadListValuesFileAction
      Category = 'SendEMail'
      MoveParams = <>
      Param.Value = ''
      Param.Component = FormParams
      Param.ComponentItem = 'UnitCodeList'
      Param.DataType = ftWideString
      Param.MultiSelectSeparator = ','
      FileName.Value = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072' '#1090#1086#1074#1072#1088#1072' '#1091' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074'.xlsx'
      FileName.DataType = ftString
      FileName.MultiSelectSeparator = ','
      StartColumns = 1
      Caption = 'actLoadListUnit'
    end
    object actUpdate_Sent: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Sent
      StoredProcList = <
        item
          StoredProc = spUpdate_Sent
        end>
      Caption = 'actUpdate_Sent'
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_OrderInternalPromo'
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
        Name = 'inShowAll'
        Value = False
        Component = FormParams
        ComponentItem = 'ShowAll'
        DataType = ftBoolean
        ParamType = ptUnknown
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
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecordMaster'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecordPromoMaster'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertByPromo'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecordChild'
        end
        item
          Visible = True
          ItemName = 'bbMISetErasedChild'
        end
        item
          Visible = True
          ItemName = 'bbMISetUnErasedChild'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUnitForOrderInternalPromo'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMaster_calc'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMasterAmount'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Price'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertChild'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertOrderInternal'
        end
        item
          Visible = True
          ItemName = 'bbInsert_Movement_Send'
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
          ItemName = 'bbReportMinPriceForm'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbSetChecked'
        end
        item
          Visible = True
          ItemName = 'bbClearChecked'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbSetComplement'
        end
        item
          Visible = True
          ItemName = 'bbClearComplement'
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
          ItemName = 'bbMovementItemProtocol'
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
          ItemName = 'dxBarButton4'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      Width = 18
    end
    inherited bbMovementItemProtocol: TdxBarButton
      UnclickAfterDoing = False
    end
    object bbMISetErasedChild: TdxBarButton
      Action = actMISetErasedChild
      Category = 0
    end
    object bbMISetUnErasedChild: TdxBarButton
      Action = actMISetUnErasedChild
      Category = 0
    end
    object bbactStartLoad: TdxBarButton
      Action = actStartLoad
      Category = 0
    end
    object bbInsertRecordChild: TdxBarButton
      Action = InsertRecordChild
      Category = 0
    end
    object bbOpenReportForm: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1094#1077#1085#1072#1084' '#1087#1088#1080#1093#1086#1076#1072'>'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' <'#1055#1086' '#1094#1077#1085#1072#1084' '#1087#1088#1080#1093#1086#1076#1072' '#1090#1086#1074#1072#1088#1086#1074' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1072'>'
      Visible = ivAlways
      ImageIndex = 25
    end
    object bbInsertRecordPartner: TdxBarButton
      Action = InsertRecordPartner
      Category = 0
    end
    object bbSetErasedPromoPartner: TdxBarButton
      Action = actSetErasedPromoPartner
      Category = 0
    end
    object bbSetUnErasedPromoPartner: TdxBarButton
      Action = actSetUnErasedPromoPartner
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      Category = 0
    end
    object bbInsertPromoPartner: TdxBarButton
      Action = macInsertPromoPartner
      Category = 0
    end
    object bbReportMinPriceForm: TdxBarButton
      Action = actOpenReport
      Category = 0
    end
    object bbInsertOrderInternal: TdxBarButton
      Action = actInsertOrderInternal
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actUpdateMovementItemContainer
      Category = 0
    end
    object bbUpdateMaster_calc: TdxBarButton
      Action = actUpdateMaster_calc
      Category = 0
    end
    object bbInsertChild: TdxBarButton
      Action = actInsertChild
      Category = 0
    end
    object bbInsertRecordMaster: TdxBarButton
      Action = InsertRecordMaster
      Category = 0
    end
    object bbInsertRecordPromoMaster: TdxBarButton
      Action = InsertRecordPromoMaster
      Category = 0
    end
    object bbUpdateMasterAmount: TdxBarButton
      Action = actUpdateMasterAmount
      Category = 0
    end
    object bbInsertByPromo: TdxBarButton
      Action = macInsertByPromo
      Category = 0
      ImageIndex = 27
    end
    object bbUpdate_Price: TdxBarButton
      Action = actUpdate_Price
      Category = 0
    end
    object bbUnitForOrderInternalPromo: TdxBarButton
      Action = actUnitForOrderInternalPromo
      Category = 0
    end
    object bbInsert_Movement_Send: TdxBarButton
      Action = actInsert_Movement_Send
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actDistributionCalculation
      Category = 0
    end
    object bbSetChecked: TdxBarButton
      Action = actSetChecked
      Category = 0
    end
    object bbClearChecked: TdxBarButton
      Action = actClearChecked
      Category = 0
    end
    object bbSetComplement: TdxBarButton
      Action = actSetComplement
      Category = 0
    end
    object bbClearComplement: TdxBarButton
      Action = actClearComplement
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Caption = #1050#1086#1088#1077#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1094#1077#1085#1099' '#1087#1088#1072#1081#1089#1072', -% '#1080#1083#1080' +%'
      Category = 0
      Hint = #1050#1086#1088#1077#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1094#1077#1085#1099' '#1087#1088#1072#1081#1089#1072', -% '#1080#1083#1080' +%'
      Visible = ivAlways
      ImageIndex = 40
    end
    object dxBarButton4: TdxBarButton
      Action = actSMTPSend
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SearchAsFilter = False
  end
  inherited PopupMenu: TPopupMenu
    Left = 80
    Top = 224
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
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitID'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceAdjustment'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceAdjustmentLabel'
        Value = #1042#1074#1086#1076' '#1087#1088#1086#1094#1077#1085#1090#1072' '#1082#1086#1088#1077#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1094#1077#1085#1099' '#1087#1088#1072#1081#1089#1072
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitCodeList'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 312
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_OrderInternalPromo'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderInternalPromo'
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
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
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
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
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
        Name = 'RetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailName'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartSale'
        Value = Null
        Component = edStartSale
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummSIP'
        Value = Null
        Component = ceTotalSummSIP
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummPrice'
        Value = Null
        Component = ceTotalSummPrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalAmount'
        Value = Null
        Component = ceTotalAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DaysGrace'
        Value = Null
        Component = ceDaysGrace
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateSent'
        Value = Null
        Component = deDateSent
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 240
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_OrderInternalPromo'
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
        Name = 'inOperDate'
        Value = 42132d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartSale'
        Value = Null
        Component = edStartSale
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTotalSummPrice'
        Value = Null
        Component = ceTotalSummPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTotalSummSIP'
        Value = Null
        Component = ceTotalSummSIP
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTotalAmount'
        Value = Null
        Component = ceTotalAmount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDaysGrace'
        Value = Null
        Component = ceDaysGrace
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 218
    Top = 240
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesRetail
      end
      item
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end
      item
      end>
    Left = 288
    Top = 216
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edOperDate
      end
      item
        Control = edRetail
      end
      item
        Control = edComment
      end
      item
        Control = edStartSale
      end
      item
        Control = ceTotalSummSIP
      end
      item
        Control = ceTotalSummPrice
      end
      item
        Control = ceTotalAmount
      end
      item
        Control = ceDaysGrace
      end>
    Left = 200
    Top = 177
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 112
    Top = 312
  end
  inherited spErasedMIMaster: TdsdStoredProc
    Left = 590
    Top = 208
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    Left = 654
    Top = 248
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_OrderInternalPromo'
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
        Name = 'inPromoMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId_Promo'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalId'
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
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAddToM'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AddToM'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summ'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Top = 160
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 304
    Top = 352
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 516
    Top = 212
  end
  object GuidesRetail: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 608
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderInternalPromo_Print'
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
    Left = 367
    Top = 216
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 492
    Top = 214
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 420
    Top = 209
  end
  object DetailDCS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'ParentId'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 32
    Top = 408
  end
  object DetailDS: TDataSource
    DataSet = DetailDCS
    Left = 80
    Top = 424
  end
  object spSelect_MI_PromoChild: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_OrderInternalPromoChild'
    DataSet = DetailDCS
    DataSets = <
      item
        DataSet = DetailDCS
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
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 216
    Top = 392
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
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
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 334
    Top = 409
  end
  object spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_OrderInternalPromoChild'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'ParentId'
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
        Name = 'inUnitId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountManual'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'AmountManual'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 424
    Top = 400
  end
  object spErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpSetErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 566
    Top = 352
  end
  object spUnErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpSetUnErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = DetailDCS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 686
    Top = 368
  end
  object spInsertUpdate_MovementItem_Promo_Set_Zero: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MI_OrderInternalPromo_Set_Zero'
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
    NeedResetData = True
    Left = 762
    Top = 224
  end
  object spGetImportSettingId: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TPromoForm;zc_Object_ImportSetting_Promo'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 784
    Top = 160
  end
  object PartnerDCS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 56
    Top = 496
  end
  object PartnerDS: TDataSource
    DataSet = PartnerDCS
    Left = 104
    Top = 512
  end
  object dsdDBViewAddOn2: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView2
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
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 278
    Top = 513
  end
  object spSelectPromoPartner: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderInternalPromoPartner'
    DataSet = PartnerDCS
    DataSets = <
      item
        DataSet = PartnerDCS
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
    Left = 192
    Top = 496
  end
  object spInsertUpdatePromoPartner: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_OrderInternalPromoPartner'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = PartnerDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = PartnerDCS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCorrPrice'
        Value = Null
        Component = PartnerDCS
        ComponentItem = 'CorrPrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisErased'
        Value = Null
        Component = PartnerDCS
        ComponentItem = 'IsReport'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 472
    Top = 520
  end
  object spSetErasedPromoPartner: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_OrderInternalPromo'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = PartnerDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 548
    Top = 480
  end
  object spUnCompletePromoPartner: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_OrderInternalPromo'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = PartnerDCS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 624
    Top = 496
  end
  object spInsertPromoPartner: TdsdStoredProc
    StoredProcName = 'gpInsert_Movement_OrderInternalPromoPartner'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inParentId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 344
    Top = 504
  end
  object spUpdate_MovementItemContainer: TdsdStoredProc
    StoredProcName = 'gpUpdate_MIContainer_OrderInternalPromo'
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
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 530
    Top = 312
  end
  object spInsert: TdsdStoredProc
    StoredProcName = 'gpInsert_MI_OrderInternalPromo'
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
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 744
    Top = 304
  end
  object spInsertChild: TdsdStoredProc
    StoredProcName = 'gpInsert_MI_OrderInternalPromoChild'
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
        Name = 'inUnitCodeList'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitCodeList'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 504
    Top = 160
  end
  object spInsertOrderInternal: TdsdStoredProc
    StoredProcName = 'gpInsert_Movement_OrderInternal_byPromoChild'
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
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 560
    Top = 240
  end
  object spUpdateMaster_calc: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_OrderInternalPromo_calc'
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
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 256
    Top = 168
  end
  object spUpdateMasterAmount: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_OrderInternalPromo_Amount'
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
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 720
    Top = 120
  end
  object spInsertByPromo: TdsdStoredProc
    StoredProcName = 'gpInsert_MI_OrderInternalPromo_byPromo'
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
        Name = 'inMovementId_promo'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId_promo'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 744
    Top = 352
  end
  object spUpdate_Price: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_OrderInternalPromo_Price'
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
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 448
    Top = 120
  end
  object spInsert_Movement_Send: TdsdStoredProc
    StoredProcName = 'gpInsert_Movement_OrderInternalPromo_Send'
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
        Name = 'inUnitID'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 106
    Top = 368
  end
  object spSetChecked: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_OrderInternalPromo_Checked'
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
      end
      item
        Name = 'inisChecked'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 536
    Top = 408
  end
  object spClearChecked: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_OrderInternalPromo_Checked'
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
      end
      item
        Name = 'inisChecked'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 608
    Top = 408
  end
  object spClearComplement: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_OrderInternalPromo_Complement'
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
      end
      item
        Name = 'inisChecked'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 752
    Top = 408
  end
  object spSetComplement: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_OrderInternalPromo_Complement'
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
      end
      item
        Name = 'inisChecked'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 680
    Top = 408
  end
  object spGetExportParam: TdsdStoredProc
    StoredProcName = 'gpGet_OrderInternalPromo_ExportParam'
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
        Name = 'inJuridicalId'
        Value = Null
        Component = ExportJuridicalCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DefaultFileName'
        Value = Null
        Component = actExportToPartner
        ComponentItem = 'DefaultFileName'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ExportType'
        Value = Null
        Component = actExportToPartner
        ComponentItem = 'ExportType'
        MultiSelectSeparator = ','
      end
      item
        Name = 'DefaultFileName'
        Value = Null
        Component = SMTPFileAction
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 840
    Top = 208
  end
  object spSelectExport: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_OrderInternalPromo_Export'
    DataSet = ExportHeaderCDS
    DataSets = <
      item
        DataSet = ExportHeaderCDS
      end
      item
        DataSet = ExportItemsCDS
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
        Name = 'inJuridicalId'
        Value = Null
        Component = ExportJuridicalCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitCodeList'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitCodeList'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 903
    Top = 160
  end
  object spGetDocumentDataForEmail: TdsdStoredProc
    StoredProcName = 'gpGet_OrderInternalPromoForEmail'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = ExportJuridicalCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Subject'
        Value = Null
        Component = FormParams
        ComponentItem = 'Subject'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Body'
        Value = Null
        Component = FormParams
        ComponentItem = 'Body'
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AddressFrom'
        Value = Null
        Component = FormParams
        ComponentItem = 'AddressFrom'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AddressTo'
        Value = Null
        Component = FormParams
        ComponentItem = 'AddressTo'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Host'
        Value = Null
        Component = FormParams
        ComponentItem = 'Host'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Port'
        Value = Null
        Component = FormParams
        ComponentItem = 'Port'
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
    Left = 944
    Top = 208
  end
  object ExportItemsDS: TDataSource
    DataSet = ExportItemsCDS
    Left = 960
    Top = 328
  end
  object ExportItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 796
    Top = 278
  end
  object ExportHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 684
    Top = 281
  end
  object spSelectExportJuridical: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_OrderInternalPromo_ExportJuridical'
    DataSet = ExportJuridicalCDS
    DataSets = <
      item
        DataSet = ExportJuridicalCDS
      end>
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
    Left = 903
    Top = 328
  end
  object ExportJuridicalCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 684
    Top = 334
  end
  object ExportJuridicalDS: TDataSource
    DataSet = ExportJuridicalCDS
    Left = 968
    Top = 376
  end
  object spGetDocumentDataForEmailGroup: TdsdStoredProc
    StoredProcName = 'gpGet_OrderInternalPromoForEmailGroup'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Subject'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Subject'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Body'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Body'
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AddressFrom'
        Value = '0'
        Component = FormParams
        ComponentItem = 'AddressFrom'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AddressTo'
        Value = '0'
        Component = FormParams
        ComponentItem = 'AddressTo'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Host'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Host'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Port'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Port'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = '0'
        Component = FormParams
        ComponentItem = 'UserName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Password'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Password'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 944
    Top = 264
  end
  object spUpdate_Sent: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_OrderInternalPromo_Sent'
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
    NeedResetData = True
    Left = 576
    Top = 144
  end
end
