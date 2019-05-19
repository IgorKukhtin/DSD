inherited OrderInternalPromoForm: TOrderInternalPromoForm
  Caption = #1047#1072#1103#1074#1082#1080' '#1074#1085#1091#1090#1088#1077#1085#1085#1080#1077' ('#1084#1072#1088#1082#1077#1090'-'#1090#1086#1074#1072#1088#1099')'
  ClientHeight = 564
  ClientWidth = 824
  AddOnFormData.AddOnFormRefresh.ParentList = 'Sale'
  ExplicitWidth = 840
  ExplicitHeight = 602
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 76
    Width = 824
    Height = 388
    ExplicitTop = 76
    ExplicitWidth = 824
    ExplicitHeight = 388
    ClientRectBottom = 388
    ClientRectRight = 824
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 824
      ExplicitHeight = 364
      inherited cxGrid: TcxGrid
        Width = 824
        Height = 184
        ExplicitWidth = 824
        ExplicitHeight = 184
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
            Caption = #1062#1077#1085#1072' '#1087#1086#1089#1090'.'
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
            Properties.DisplayFormat = ',0.00'
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
        Top = 192
        Width = 824
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
        Top = 184
        Width = 824
        Height = 8
        Touch.ParentTabletOptions = False
        Touch.TabletOptions = [toPressAndHold]
        AlignSplitter = salBottom
        Control = cxGrid1
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 824
    Height = 50
    TabOrder = 3
    ExplicitWidth = 824
    ExplicitHeight = 50
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
      Width = 142
    end
    object cxLabel7: TcxLabel
      Left = 628
      Top = 6
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object edComment: TcxTextEdit
      Left = 628
      Top = 23
      Properties.ReadOnly = False
      TabOrder = 9
      Width = 181
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
    Width = 824
    Height = 8
    Touch.ParentTabletOptions = False
    Touch.TabletOptions = [toPressAndHold]
    AlignSplitter = salBottom
    Control = cxGrid2
  end
  object cxGrid2: TcxGrid [5]
    Left = 0
    Top = 472
    Width = 824
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
        Width = 86
      end
      object clJuridicalCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'JuridicalCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1076' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
        Width = 41
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
        Width = 385
      end
      object clComment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 288
      end
    end
    object cxGridLevel2: TcxGridLevel
      GridView = cxGridDBTableView2
    end
  end
  inherited ActionList: TActionList
    Left = 199
    Top = 303
    object actRefreshPromoPartner: TdsdDataSetRefresh [0]
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
    object actRefreshMI: TdsdDataSetRefresh [1]
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
    object actMISetErasedChild: TdsdUpdateErased [3]
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
    object actSetErasedPromoPartner: TdsdUpdateErased [5]
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
    object actSetUnErasedPromoPartner: TdsdUpdateErased [7]
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
    object actMISetUnErasedChild: TdsdUpdateErased [8]
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
    object InsertRecordPartner: TInsertRecord [12]
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
    object InsertRecordPromoMaster: TInsertRecord [13]
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
    object InsertRecordMaster: TInsertRecord [14]
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
    object InsertRecordChild: TInsertRecord [15]
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
    object actUpdatePartnerDS: TdsdUpdateDataSet [17]
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
    object actUpdateChildDS: TdsdUpdateDataSet [18]
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
    object actDoLoad: TExecuteImportSettingsAction [19]
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
    object actContractChoice: TOpenChoiceForm [30]
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
          Name = 'MasterOperDate'
          Value = 'NULL'
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
          Value = 'NULL'
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
      StoredProc = spInsert
      StoredProcList = <
        item
          StoredProc = spInsert
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectPromoPartner
        end>
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1086#1074#1072#1088#1072#1084#1080'  '#1084#1072#1088#1082#1077#1090'-'#1082#1086#1085#1090#1088#1072#1082#1090#1086#1074
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1090#1086#1074#1072#1088#1072#1084#1080'  '#1084#1072#1088#1082#1077#1090'-'#1082#1086#1085#1090#1088#1072#1082#1090#1086#1074
      ImageIndex = 74
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
          ItemName = 'bbUpdateMaster_calc'
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
        end>
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
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 0
      end>
    SearchAsFilter = False
  end
  inherited PopupMenu: TPopupMenu
    Left = 128
    Top = 240
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
        Value = 'NULL'
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
        Value = 'NULL'
        Component = edStartSale
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 224
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
        Value = 'NULL'
        Component = edStartSale
        DataType = ftDateTime
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
      end>
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 202
    Top = 248
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
      end>
    Left = 200
    Top = 177
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 112
    Top = 312
  end
  inherited spErasedMIMaster: TdsdStoredProc
    Left = 550
    Top = 224
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
    Left = 512
    Top = 16
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
    Left = 476
    Top = 206
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 444
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
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    SearchAsFilter = False
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
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    SearchAsFilter = False
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
    Left = 562
    Top = 288
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
    Left = 416
    Top = 136
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
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 504
    Top = 144
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
    Left = 568
    Top = 152
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
    Left = 248
    Top = 160
  end
end
