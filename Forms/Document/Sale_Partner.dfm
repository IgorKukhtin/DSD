inherited Sale_PartnerForm: TSale_PartnerForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' ('#1073#1091#1093#1075#1072#1083#1090#1077#1088')>'
  ClientHeight = 490
  ClientWidth = 1370
  ExplicitWidth = 1386
  ExplicitHeight = 529
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 166
    Width = 1370
    Height = 324
    ExplicitTop = 166
    ExplicitWidth = 1370
    ExplicitHeight = 324
    ClientRectBottom = 324
    ClientRectRight = 1370
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1370
      ExplicitHeight = 300
      inherited cxGrid: TcxGrid
        Width = 1370
        Height = 300
        ExplicitWidth = 1370
        ExplicitHeight = 300
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
              Column = AmountChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = HeadCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = BoxCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPercentAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountPack
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = HeadCount
            end
            item
              Kind = skSum
              Column = Price
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = BoxCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = TotalPercentAmount
            end
            item
              Kind = skSum
              Column = CountPack
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
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
          object LineNum: TcxGridDBColumn [0]
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'LineNum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object GoodsGroupNameFull: TcxGridDBColumn [1]
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsCode: TcxGridDBColumn [2]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsName: TcxGridDBColumn [3]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 200
          end
          object GoodsKindName: TcxGridDBColumn [4]
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
          object PartionGoods: TcxGridDBColumn [5]
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object PartionGoodsDate: TcxGridDBColumn [6]
            Caption = #1055#1072#1088#1090#1080#1103' ('#1076#1072#1090#1072')'
            DataBinding.FieldName = 'PartionGoodsDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.ReadOnly = True
            Properties.SaveTime = False
            Properties.ShowTime = False
            Properties.UseNullString = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object MeasureName: TcxGridDBColumn [7]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object MovementPromo: TcxGridDBColumn [8]
            Caption = #8470' '#1076#1086#1082'. '#1072#1082#1094#1080#1103
            DataBinding.FieldName = 'MovementPromo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object isBarCode: TcxGridDBColumn [9]
            Caption = #1057#1082#1080#1076#1082#1072' '#1089#1082#1072#1085'. '#1091#1087'.'
            DataBinding.FieldName = 'isBarCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Count: TcxGridDBColumn [10]
            Caption = #1050#1086#1083'-'#1074#1086' '#1073#1072#1090#1086#1085#1086#1074
            DataBinding.FieldName = 'Count'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object CountPack: TcxGridDBColumn [11]
            Caption = #1050#1086#1083'-'#1074#1086' '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'CountPack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object WeightTotal: TcxGridDBColumn [12]
            Caption = #1042#1077#1089' 1'#1077#1076'.  '#1089' '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'WeightTotal'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object WeightPack: TcxGridDBColumn [13]
            Caption = #1042#1077#1089' 1'#1077#1076'. '#1091#1087#1072#1082'.'
            DataBinding.FieldName = 'WeightPack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object ChangePercentAmount: TcxGridDBColumn [14]
            Caption = '% '#1089#1082#1080#1076#1082#1080' '#1074#1077#1089
            DataBinding.FieldName = 'ChangePercentAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object Amount: TcxGridDBColumn [15]
            Caption = #1050#1086#1083'-'#1074#1086' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountChangePercent: TcxGridDBColumn [16]
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
            DataBinding.FieldName = 'AmountChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object TotalPercentAmount: TcxGridDBColumn [17]
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1082#1080#1076#1082#1072
            DataBinding.FieldName = 'TotalPercentAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountPartner: TcxGridDBColumn [18]
            Caption = #1050#1086#1083'-'#1074#1086' '#1091' '#1087#1086#1082#1091#1087'.'
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object ChangePercent: TcxGridDBColumn [19]
            Caption = '(-)% '#1057#1082'. (+)% '#1053#1072#1094'.'
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object CountForPrice: TcxGridDBColumn [20]
            Caption = #1050#1086#1083'. '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object Price: TcxGridDBColumn [21]
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PriceTare: TcxGridDBColumn [22]
            Caption = #1062#1077#1085#1072' '#1086#1073'. '#1090#1072#1088#1099'.'
            DataBinding.FieldName = 'PriceTare'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1086#1073#1086#1088#1086#1090#1085#1086#1081' '#1090#1072#1088#1099'.'
            Options.Editing = False
            Width = 70
          end
          object PriceIn: TcxGridDBColumn [23]
            Caption = #1062#1077#1085#1072' '#1074#1093'.'
            DataBinding.FieldName = 'PriceIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1074#1093'.'
            Options.Editing = False
            Width = 70
          end
          object PricePromo: TcxGridDBColumn [24]
            Caption = #1062#1077#1085#1072' '#1072#1082#1094#1080#1103
            DataBinding.FieldName = 'PricePromo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.########;-,0.########; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Price_Pricelist: TcxGridDBColumn [25]
            Caption = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' ('#1073#1077#1079' '#1053#1044#1057')'
            DataBinding.FieldName = 'Price_Pricelist'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Price_Pricelist_vat: TcxGridDBColumn [26]
            Caption = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091' ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'Price_Pricelist_vat'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isCheck_Pricelist: TcxGridDBColumn [27]
            Caption = #1054#1096#1080#1073#1082#1072' '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'isCheck_Pricelist'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object HeadCount: TcxGridDBColumn [28]
            Caption = #1050#1086#1083'. '#1075#1086#1083#1086#1074
            DataBinding.FieldName = 'HeadCount'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object AssetName: TcxGridDBColumn [29]
            Caption = #1054#1089#1085'.'#1089#1088#1077#1076#1089#1090#1074#1072' '
            DataBinding.FieldName = 'AssetName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object BoxCount: TcxGridDBColumn [30]
            Caption = #1050#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074
            DataBinding.FieldName = 'BoxCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object BoxName: TcxGridDBColumn [31]
            Caption = #1042#1080#1076' '#1103#1097#1080#1082#1086#1074
            DataBinding.FieldName = 'BoxName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsBoxChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object InfoMoneyCode: TcxGridDBColumn [32]
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object InfoMoneyGroupName: TcxGridDBColumn [33]
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyDestinationName: TcxGridDBColumn [34]
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object InfoMoneyName: TcxGridDBColumn [35]
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object InfoMoneyName_all: TcxGridDBColumn [36]
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'InfoMoneyName_all'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object isPeresort: TcxGridDBColumn [37]
            Caption = #1055#1077#1088#1077#1089#1086#1088#1090' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPeresort'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object AmountSumm: TcxGridDBColumn [38]
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'AmountSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsRealCode: TcxGridDBColumn [39]
            Caption = #1050#1086#1076' '#1090#1086#1074'.('#1092#1072#1082#1090' '#1086#1090#1075#1088')'
            DataBinding.FieldName = 'GoodsRealCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1090#1086#1074'.('#1092#1072#1082#1090' '#1086#1090#1075#1088#1091#1079#1082#1072')'
            Options.Editing = False
            Width = 74
          end
          object GoodsRealName: TcxGridDBColumn [40]
            Caption = #1058#1086#1074#1072#1088' ('#1092#1072#1082#1090' '#1086#1090#1075#1088')'
            DataBinding.FieldName = 'GoodsRealName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1086#1074#1072#1088' ('#1092#1072#1082#1090' '#1086#1090#1075#1088#1091#1079#1082#1072')'
            Options.Editing = False
            Width = 78
          end
          object GoodsKindRealName: TcxGridDBColumn [41]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1092#1072#1082#1090' '#1086#1090#1075#1088')'
            DataBinding.FieldName = 'GoodsKindRealName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1092#1072#1082#1090' '#1086#1090#1075#1088#1091#1079#1082#1072')'
            Options.Editing = False
            Width = 89
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1370
    Height = 140
    TabOrder = 3
    ExplicitWidth = 1370
    ExplicitHeight = 140
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 255
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 255
      ExplicitWidth = 102
      Width = 102
    end
    inherited cxLabel2: TcxLabel
      Left = 255
      Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
      ExplicitLeft = 255
      ExplicitWidth = 71
    end
    inherited cxLabel15: TcxLabel
      Left = -38
      Top = 80
      ExplicitLeft = -38
      ExplicitTop = 80
    end
    inherited ceStatus: TcxButtonEdit
      Top = 63
      ExplicitTop = 63
      ExplicitWidth = 161
      ExplicitHeight = 22
      Width = 161
    end
    object cxLabel3: TcxLabel
      Left = 360
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object edFrom: TcxButtonEdit
      Left = 360
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 170
    end
    object edTo: TcxButtonEdit
      Left = 535
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 265
    end
    object cxLabel4: TcxLabel
      Left = 535
      Top = 5
      Caption = #1050#1086#1084#1091
    end
    object edContract: TcxButtonEdit
      Left = 948
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 120
    end
    object cxLabel9: TcxLabel
      Left = 948
      Top = 5
      Caption = #1044#1086#1075#1086#1074#1086#1088
    end
    object cxLabel6: TcxLabel
      Left = 804
      Top = 5
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
    end
    object edPaidKind: TcxButtonEdit
      Left = 804
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 140
    end
    object cxLabel5: TcxLabel
      Left = 171
      Top = 5
      Caption = #8470' '#1079#1072#1103#1074#1082#1080
    end
    object edPriceWithVAT: TcxCheckBox
      Left = 360
      Top = 63
      Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 128
    end
    object edVATPercent: TcxCurrencyEdit
      Left = 490
      Top = 63
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = True
      TabOrder = 16
      Width = 40
    end
    object cxLabel7: TcxLabel
      Left = 490
      Top = 45
      Caption = '% '#1053#1044#1057
    end
    object edChangePercent: TcxCurrencyEdit
      Left = 535
      Top = 63
      Properties.DecimalPlaces = 3
      Properties.DisplayFormat = ',0.###'
      Properties.ReadOnly = True
      TabOrder = 18
      Width = 144
    end
    object cxLabel8: TcxLabel
      Left = 535
      Top = 45
      Caption = '(-)% '#1057#1082#1080#1076#1082#1080' (+)% '#1053#1072#1094#1077#1085#1082#1080
    end
    object cxLabel13: TcxLabel
      Left = 1274
      Top = 50
      Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1084#1072#1088#1096#1088#1091#1090#1072
      Visible = False
    end
    object edRouteSorting: TcxButtonEdit
      Left = 1330
      Top = 50
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 21
      Visible = False
      Width = 170
    end
    object edOperDatePartner: TcxDateEdit
      Left = 255
      Top = 63
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 22
      Width = 102
    end
    object cxLabel10: TcxLabel
      Left = 255
      Top = 45
      Caption = #1044#1072#1090#1072' '#1076#1086#1082'. '#1091' '#1087#1086#1082#1091#1087'.'
    end
    object edIsChecked: TcxCheckBox
      Left = 684
      Top = 43
      Caption = #1055#1088#1086#1074#1077#1088#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 24
      Width = 118
    end
    object cxLabel11: TcxLabel
      Left = 804
      Top = 45
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
    end
    object edPriceList: TcxButtonEdit
      Left = 804
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 26
      Width = 140
    end
    object cxLabel12: TcxLabel
      Left = 85
      Top = 5
      Caption = #8470' '#1076#1086#1082'.'#1091' '#1087#1086#1082#1091#1087'.'
    end
    object edInvNumberPartner: TcxTextEdit
      Left = 85
      Top = 23
      TabOrder = 28
      Width = 84
    end
    object edDocumentTaxKind: TcxButtonEdit
      Left = 1156
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 29
      Width = 94
    end
    object cxLabel14: TcxLabel
      Left = 1156
      Top = 85
      Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
    end
    object cxLabel16: TcxLabel
      Left = 1072
      Top = 85
      Caption = #8470' '#1085#1072#1083#1086#1075#1086#1074#1086#1081
    end
    object edTax: TcxTextEdit
      Left = 1072
      Top = 103
      Properties.ReadOnly = True
      TabOrder = 32
      Width = 78
    end
    object cbCOMDOC: TcxCheckBox
      Left = 171
      Top = 63
      Caption = 'COMDOC'
      Properties.ReadOnly = True
      TabOrder = 33
      Width = 81
    end
    object edCurrencyDocument: TcxButtonEdit
      Left = 1072
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 34
      Width = 78
    end
    object cxLabel17: TcxLabel
      Left = 1072
      Top = 45
      Caption = #1042#1072#1083#1102#1090#1072' ('#1094#1077#1085#1072')'
    end
    object edCurrencyPartnerValue: TcxCurrencyEdit
      Left = 1155
      Top = 63
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Properties.ReadOnly = False
      TabOrder = 36
      Width = 58
    end
    object cxLabel18: TcxLabel
      Left = 1155
      Top = 45
      Caption = #1050#1091#1088#1089
    end
    object edCurrencyPartner: TcxButtonEdit
      Left = 1072
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 38
      Width = 78
    end
    object cxLabel19: TcxLabel
      Left = 1072
      Top = 5
      Caption = #1042#1072#1083#1102#1090#1072' ('#1087#1086#1082')'
    end
    object cxLabel20: TcxLabel
      Left = 948
      Top = 45
      Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075#1086#1074#1086#1088#1072
    end
    object edContractTag: TcxButtonEdit
      Left = 948
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 41
      Width = 120
    end
    object edInvNumberOrder: TcxButtonEdit
      Left = 171
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 42
      Width = 81
    end
    object cxLabel21: TcxLabel
      Left = 1220
      Top = 44
      Caption = #1053#1086#1084#1080#1085#1072#1083
    end
    object edParPartnerValue: TcxCurrencyEdit
      Left = 1220
      Top = 63
      EditValue = 1.000000000000000000
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Properties.ReadOnly = False
      TabOrder = 44
      Width = 48
    end
    object cxLabel22: TcxLabel
      Left = 684
      Top = 85
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 684
      Top = 103
      TabOrder = 46
      Width = 116
    end
    object cbCalcAmountPartner: TcxCheckBox
      Left = 8
      Top = 103
      Caption = #1056#1072#1089#1095#1077#1090' '#1087#1086' % '#1089#1082#1080#1076#1082#1080' '#1074#1077#1089' :'
      Properties.ReadOnly = False
      State = cbsChecked
      TabOrder = 47
      Width = 157
    end
    object edChangePercentAmount: TcxCurrencyEdit
      Left = 171
      Top = 103
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      Properties.ReadOnly = False
      TabOrder = 48
      Width = 81
    end
    object cxLabel23: TcxLabel
      Left = 1156
      Top = 5
      Caption = #1050#1091#1088#1089' '#1059#1055
    end
    object cxLabel24: TcxLabel
      Left = 1220
      Top = 5
      Caption = #1053#1086#1084'. '#1059#1055
    end
    object edCurrencyValue: TcxCurrencyEdit
      Left = 1155
      Top = 23
      Properties.Alignment.Horz = taRightJustify
      Properties.Alignment.Vert = taVCenter
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Properties.ReadOnly = True
      TabOrder = 51
      Width = 58
    end
    object edParValue: TcxCurrencyEdit
      Left = 1220
      Top = 23
      EditValue = 1.000000000000000000
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####;-,0.####; ;'
      Properties.ReadOnly = True
      TabOrder = 52
      Width = 48
    end
    object edInvNumberTransport: TcxButtonEdit
      Left = 360
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 53
      Width = 170
    end
    object cxLabel25: TcxLabel
      Left = 360
      Top = 85
      Caption = #1055#1091#1090#1077#1074#1086#1081' '#1083#1080#1089#1090
    end
    object cxLabel26: TcxLabel
      Left = 535
      Top = 85
      Caption = #1042#1080#1079#1072' '#1074' '#1076#1086#1082#1091#1084#1077#1085#1090#1077
    end
    object edReestrKind: TcxButtonEdit
      Left = 534
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 56
      Width = 144
    end
    object cxLabel27: TcxLabel
      Left = 948
      Top = 85
      Caption = #8470' '#1076#1086#1082'. '#1087#1077#1088#1077#1089#1086#1088#1090#1080#1094#1099
    end
    object edInvNumberProduction: TcxButtonEdit
      Left = 948
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 58
      Width = 120
    end
    object cxLabel29: TcxLabel
      Left = 804
      Top = 85
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090' '#1074#1093'.'
    end
    object edPriceListIn: TcxButtonEdit
      Left = 804
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 60
      Width = 140
    end
    object cxLabel31: TcxLabel
      Left = 1255
      Top = 85
      Caption = #1053#1072' '#1086#1089#1085#1086#1074#1072#1085#1080#1080' '#8470' ('#1074#1086#1079#1074#1088#1072#1090')'
    end
    object edReturnIn: TcxButtonEdit
      Left = 1255
      Top = 103
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 62
      Width = 116
    end
    object cbCurrencyUser: TcxCheckBox
      Left = 1274
      Top = 23
      Caption = #1056#1091#1095#1085#1086#1081' '#1074#1074#1086#1076' '#1082#1091#1088#1089#1072
      Properties.ReadOnly = True
      TabOrder = 63
      Width = 120
    end
    object cbTotalSumm_GoodsReal: TcxCheckBox
      Left = 1274
      Top = 63
      Hint = 
        #1055#1077#1088#1077#1089#1095#1077#1090' '#1094#1077#1085' '#1080#1079' '#1055#1088#1072#1081#1089#1072' '#1080#1083#1080' '#1040#1082#1094#1080#1081' '#1087#1088#1080' '#1055#1088#1086#1074#1077#1076#1077#1085#1080#1080', '#1089' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077#1084' ' +
        #1055#1088#1072#1074
      Caption = #1056#1072#1089#1095#1077#1090' '#1089#1091#1084#1084#1099' '#1087#1086' '#1089#1093#1077#1084#1077' - '#1058#1086#1074#1072#1088' ('#1092#1072#1082#1090')'
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 64
      Width = 219
    end
    object cxLabel30: TcxLabel
      Left = 8
      Top = 45
      Caption = '*'#1057#1090#1072#1090#1091#1089
    end
  end
  object cbPromo: TcxCheckBox [2]
    Left = 684
    Top = 66
    Caption = #1040#1082#1094#1080#1103' ('#1076#1072'/'#1085#1077#1090')'
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 100
  end
  object cxLabel28: TcxLabel [3]
    Left = 255
    Top = 85
    Caption = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080
  end
  object edPartionGoodsDate: TcxDateEdit [4]
    Left = 255
    Top = 103
    EditValue = 43831d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 8
    Width = 102
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 171
    Top = 552
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    Left = 56
    Top = 456
  end
  inherited ActionList: TActionList
    Left = 39
    Top = 255
    object actPrintPackGross: TdsdPrintAction [0]
      Category = 'Print'
      MoveParams = <>
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
      ReportNameParam.Value = 'PrintMovement_SalePackGross'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_Pack: TdsdPrintAction [1]
      Category = 'Print_Fozzy'
      MoveParams = <>
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
    inherited actRefresh: TdsdDataSetRefresh
      RefreshOnTabSetChanges = True
    end
    object actPrint_Transport_ReportName: TdsdExecStoredProc [4]
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
    object mactPrint_Transport: TMultiAction [5]
      Category = 'Print_TTN'
      MoveParams = <>
      ActionList = <
        item
          Action = actPrint_Transport_ReportName
        end
        item
          Action = actPrint_Transport
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1085#1072#1103
      ImageIndex = 20
    end
    object actGoodsChoiceForm: TOpenChoiceForm [7]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsForm'
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
        end>
      isShowModal = True
    end
    object actOpenReportForm: TdsdOpenForm [10]
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
          Component = GuidesTo
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerName'
          Value = ''
          Component = GuidesTo
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
          Name = 'inMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
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
        end>
      isShowModal = False
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ImageIndex = -1
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
      ReportNameParam.ParamType = ptInput
    end
    object actPrint_ExpInvoice: TdsdPrintAction [15]
      Category = 'Print_Export'
      MoveParams = <>
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
    object actPrint_ExpSpec: TdsdPrintAction [16]
      Category = 'Print_Export'
      MoveParams = <>
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
    object actPrint_Spec: TdsdPrintAction [17]
      Category = 'Print_Fozzy'
      MoveParams = <>
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
    object actPrint_ExpPack: TdsdPrintAction [18]
      Category = 'Print_Export'
      MoveParams = <>
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
    object mactPrint_Sale: TMultiAction [19]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSPPrintSaleProcName
        end
        item
          Action = actPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1053#1072#1082#1083#1072#1076#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100' '#1053#1072#1082#1083#1072#1076#1085#1072#1103
      ImageIndex = 3
      ShortCut = 16464
    end
    object mactPrint_Tax_Us: TMultiAction [20]
      Category = 'Print_Tax'
      MoveParams = <>
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
    object mactPrint_Tax_Client: TMultiAction [21]
      Category = 'Print_Tax'
      MoveParams = <>
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
    object mactPrint_Account: TMultiAction [22]
      Category = 'Print_Account'
      MoveParams = <>
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
    object actPrintTax_Us: TdsdPrintAction [23]
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
    object actPrintTax_Client: TdsdPrintAction [24]
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
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    object actPrint_Account: TdsdPrintAction [26]
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
      ReportNameParam.ComponentItem = 'ReportNameSaleBill'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    object actGoodsBoxChoice: TOpenChoiceForm [30]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'BoxForm'
      FormName = 'TBoxForm'
      FormNameParam.Value = 'TBoxForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'BoxName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGoodsKindChoice: TOpenChoiceForm [31]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
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
    object actPrint_Account_ReportName: TdsdExecStoredProc [36]
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
    object actSPPrintSaleProcName: TdsdExecStoredProc [37]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReportName
      StoredProcList = <
        item
          StoredProc = spGetReportName
        end>
      Caption = 'actSPPrintSaleProcName'
    end
    object actPrint_Tax_ReportName: TdsdExecStoredProc [38]
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
    object actRefreshPrice: TdsdDataSetRefresh [39]
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
    object actTax: TdsdExecStoredProc [40]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spTax
      StoredProcList = <
        item
          StoredProc = spTax
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>'
      ImageIndex = 41
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>?'
      InfoAfterExecute = #1047#1072#1074#1077#1088#1096#1077#1085#1086' '#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1053#1072#1083#1086#1075#1086#1074#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103'>.'
    end
    object actUpdatePriceCurrency: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMovement
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end
        item
          StoredProc = spUpdatePriceCurrency
        end
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1094#1077#1085#1099' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1074' '#1074#1072#1083#1102#1090#1077
      Hint = #1055#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1094#1077#1085#1099' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1074' '#1074#1072#1083#1102#1090#1077
      ImageIndex = 45
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1089#1095#1080#1090#1072#1090#1100' '#1094#1077#1085#1099' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1074' '#1074#1072#1083#1102#1090#1077'?'
      InfoAfterExecute = #1047#1072#1074#1077#1088#1096#1077#1085' '#1087#1077#1088#1077#1089#1095#1077#1090' '#1094#1077#1085' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1074' '#1074#1072#1083#1102#1090#1077'.'
    end
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
    end
    object actPrint_QualityDoc: TdsdPrintAction
      Category = 'Print_QualityDoc'
      MoveParams = <>
      StoredProc = spSelectPrint_Quality
      StoredProcList = <
        item
          StoredProc = spSelectPrint_Quality
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
      Hint = #1055#1077#1095#1072#1090#1100' '#1050#1072#1095#1077#1089#1090#1074#1077#1085#1085#1086#1077' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077
      ImageIndex = 16
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
      ReportNameParam.Value = 'PrintMovement_Quality'
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
      MoveParams = <>
      ActionList = <
        item
          Action = actDialog_TTN
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
          Component = FormParams
          ComponentItem = 'MovementId_TransportGoods'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementId_Sale'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'OperDate_TransportGoods'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
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
    object actPrint_Transport: TdsdPrintAction
      Category = 'Print_TTN'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1058#1088#1072#1085#1089#1087#1086#1088#1090#1085#1072#1103
      Hint = #1055#1077#1095#1072#1090#1100#1058#1088#1072#1085#1089#1087#1086#1088#1090#1085#1072#1103
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
    object actOpenProductionForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1077#1088#1077#1089#1086#1088#1090#1080#1094#1072'>'
      ImageIndex = 26
      FormName = 'TProductionPeresortForm'
      FormNameParam.Value = 'TProductionPeresortForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '-1'
          Component = GuidesProductionDoc
          ComponentItem = 'Key'
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
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenProductionUnitForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1089#1084#1077#1096#1080#1074#1072#1085#1080#1077'>'
      ImageIndex = 32
      FormName = 'TProductionUnionForm'
      FormNameParam.Value = 'TProductionUnionForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          Component = GuidesProductionDoc
          ComponentItem = 'Key'
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
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPrint_PackWeight: TdsdPrintAction
      Category = 'Print_Fozzy'
      MoveParams = <>
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
    object actPrint_Quality_ReportName: TdsdExecStoredProc
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
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object mactPrint_QualityDoc: TMultiAction
      Category = 'Print_QualityDoc'
      MoveParams = <>
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
    object actOpenFormOrderExternal: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1047#1072#1103#1074#1082#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1047#1072#1103#1074#1082#1072'>'
      ImageIndex = 24
      FormName = 'TOrderExternalForm'
      FormNameParam.Value = 'TOrderExternalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = ''
          Component = GuidesInvNumberOrder
          ComponentItem = 'Key'
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
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actOpenFormPromo: TdsdOpenForm
      Category = 'Promo'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1040#1082#1094#1080#1103'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1040#1082#1094#1080#1103'>'
      ImageIndex = 29
      FormName = 'TPromoForm'
      FormNameParam.Value = 'TPromoForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId_Promo'
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
          Value = 42132d
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actCheckRight: TdsdExecStoredProc
      Category = 'Promo'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spCheckRight
      StoredProcList = <
        item
          StoredProc = spCheckRight
        end>
      Caption = 'actCheckRight'
    end
    object macOpenFormPromo: TMultiAction
      Category = 'Promo'
      MoveParams = <>
      ActionList = <
        item
          Action = actCheckRight
        end
        item
          Action = actOpenFormPromo
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1040#1082#1094#1080#1103'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1040#1082#1094#1080#1103'>'
      ImageIndex = 29
    end
    object actUpdate_PartionGoodsDate: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MI_PartionGoodsDate
      StoredProcList = <
        item
          StoredProc = spUpdate_MI_PartionGoodsDate
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1090#1091' '#1087#1072#1088#1090#1080#1080
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1090#1091' '#1087#1072#1088#1090#1080#1080
      ImageIndex = 67
    end
    object macUpdate_PartionGoodsDate: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_PartionGoodsDate
        end>
      View = cxGridDBTableView
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1087#1072#1088#1090#1080#1080
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1087#1072#1088#1090#1080#1080
      ImageIndex = 67
    end
    object macUpdate_PartionGoodsDateList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_PartionGoodsDate
        end
        item
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1080#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1087#1072#1088#1090#1080#1080'?'
      InfoAfterExecute = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080' '#1080#1079#1084#1077#1085#1077#1085#1072
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1087#1072#1088#1090#1080#1080
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1087#1072#1088#1090#1080#1080
      ImageIndex = 67
    end
    object actUpdate_Invnumber: TdsdUpdateDataSet
      Category = 'Invnumber'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Invnumber
      StoredProcList = <
        item
          StoredProc = spUpdate_Invnumber
        end>
      Caption = 'actUpdate_Invnumber'
    end
    object actUpdate_InvnumberDialog: TExecuteDialog
      Category = 'Invnumber'
      MoveParams = <>
      Caption = 'actUpdate_InvnumberDialog'
      FormName = 'TChangeInvNumberDialogForm'
      FormNameParam.Value = 'TChangeInvNumberDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inInvNumber'
          Value = ''
          Component = edInvNumber
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macUpdate_Invnumber: TMultiAction
      Category = 'Invnumber'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_InvnumberDialog
        end
        item
          Action = actUpdate_Invnumber
        end>
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1082#1083#1072#1076#1089#1082#1086#1081' '#8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1082#1083#1072#1076#1089#1082#1086#1081' '#8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1089#1082#1083#1072#1076#1089#1082#1086#1081' '#8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 43
    end
    object actSPPrintTTNProcName: TdsdExecStoredProc
      Category = 'Print_TTN'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReporNameTTN
      StoredProcList = <
        item
          StoredProc = spGetReporNameTTN
        end>
      Caption = 'actPrint_Transport_ReportName'
    end
    object actUpdateMI_Sale_PriceIn: TdsdExecStoredProc
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
    object macUpdateMI_Sale_PriceIn: TMultiAction
      Category = 'UpdatePriceIn'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateMI_Sale_PriceIn
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1074#1093'. '#1094#1077#1085#1099'?'
      InfoAfterExecute = #1042#1093'. '#1094#1077#1085#1099' '#1079#1072#1087#1086#1083#1085#1077#1085#1099
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1074#1093'. '#1094#1077#1085#1099
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' '#1074#1093'. '#1094#1077#1085#1099
      ImageIndex = 80
    end
    object actUpdateMask: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateMask
      StoredProcList = <
        item
          StoredProc = spUpdateMask
        end>
      Caption = 'actUpdateMask'
    end
    object actSendJournalChoiceMasc: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'SendJournalChoice'
      FormName = 'TSendJournalChoiceForm'
      FormNameParam.Value = 'TSendJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'MaskId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object mactUpdateMaskSend: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSendJournalChoiceMasc
        end
        item
          Action = actUpdateMask
        end
        item
          Action = actRefresh
        end>
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'>'
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077'>'
      ImageIndex = 59
    end
    object actReturnJournalChoiceMasc: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'SendJournalChoice'
      FormName = 'TReturnInJournalChoiceForm'
      FormNameParam.Value = 'TReturnInJournalChoiceForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = '0'
          Component = FormParams
          ComponentItem = 'MaskId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerId'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inPartnerName'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object mactUpdateMaskReturn: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actReturnJournalChoiceMasc
        end
        item
          Action = actUpdateMask
        end
        item
          Action = actRefresh
        end>
      Caption = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      Hint = #1055#1077#1088#1077#1085#1077#1089#1090#1080' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1042#1086#1079#1074#1088#1072#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      ImageIndex = 30
    end
    object actExport_fileXml: TdsdStoredProcExportToFile
      Category = 'Export_file'
      MoveParams = <>
      dsdStoredProcName = spSelectSale_xml
      FilePathParam.Value = ''
      FilePathParam.DataType = ftString
      FilePathParam.MultiSelectSeparator = ','
      FileNameParam.Value = ''
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      FileExt = '.xml'
      FileExtParam.Value = ''
      FileExtParam.DataType = ftString
      FileExtParam.MultiSelectSeparator = ','
      FileNamePrefixParam.Value = ''
      FileNamePrefixParam.DataType = ftString
      FileNamePrefixParam.MultiSelectSeparator = ','
      FieldDefs = <>
      Left = 1192
      Top = 144
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
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1074#1099#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1074' '#1092#1072#1081#1083'?'
      InfoAfterExecute = #1060#1072#1081#1083' '#1091#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085
      Caption = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1092#1072#1081#1083' <'#1052#1103#1089#1085#1072#1103' '#1074#1077#1089#1085#1072'>'
      Hint = #1042#1099#1075#1088#1091#1079#1080#1090#1100' '#1074' '#1092#1072#1081#1083' <'#1052#1103#1089#1085#1072#1103' '#1074#1077#1089#1085#1072'>'
      ImageIndex = 60
    end
    object actUpdate_CurrencyDialog: TExecuteDialog
      Category = 'CurrUser'
      MoveParams = <>
      Caption = 'actUpdate_CurrencyDialog'
      FormName = 'TChange'#1057'urrencyUserDialogForm'
      FormNameParam.Value = 'TChange'#1057'urrencyUserDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'isCurrencyUser'
          Value = False
          Component = cbCurrencyUser
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CurrencyDocumentId'
          Value = ''
          Component = CurrencyDocumentGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CurrencyDocumentName'
          Value = ''
          Component = CurrencyDocumentGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CurrencyPartnerId'
          Value = ''
          Component = CurrencyPartnerGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CurrencyPartnerName'
          Value = ''
          Component = CurrencyPartnerGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'CurrencyValue'
          Value = 0.000000000000000000
          Component = edCurrencyValue
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ParValue'
          Value = 1.000000000000000000
          Component = edParValue
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_Currency: TdsdUpdateDataSet
      Category = 'CurrUser'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_CurrencyUser
      StoredProcList = <
        item
          StoredProc = spUpdate_CurrencyUser
        end>
      Caption = 'actUpdate_Currency'
    end
    object mactUpdate_Currency: TMultiAction
      Category = 'CurrUser'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_CurrencyDialog
        end
        item
          Action = actUpdate_Currency
        end>
      Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1056#1091#1095#1085#1086#1081' '#1074#1074#1086#1076' '#1082#1091#1088#1089#1072
      Hint = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1056#1091#1095#1085#1086#1081' '#1074#1074#1086#1076' '#1082#1091#1088#1089#1072
      ImageIndex = 56
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
    object actPrintBox: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
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
    object actPrintBoxTotal: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
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
    object actPrintBoxTotalPartner: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
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
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 512
  end
  inherited MasterCDS: TClientDataSet
    Left = 88
    Top = 512
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Sale'
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
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDatePartner
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
    Left = 120
    Top = 264
  end
  inherited BarManager: TdxBarManager
    Left = 80
    Top = 207
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
          ItemName = 'bbTax'
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
          ItemName = 'bbStatic'
        end
        item
          BeginGroup = True
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
          ItemName = 'bbsShow'
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
    inherited dxBarStatic: TdxBarStatic
      Caption = '    '
      Hint = '    '
    end
    inherited bbPrint: TdxBarButton
      Action = mactPrint_Sale
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
    end
    object bbPrint_Bill: TdxBarButton [5]
      Action = mactPrint_Account
      Category = 0
    end
    object bbPrintTax: TdxBarButton [6]
      Action = mactPrint_Tax_Us
      Category = 0
    end
    object bbPrintTax_Client: TdxBarButton [7]
      Action = mactPrint_Tax_Client
      Category = 0
    end
    object bbTax: TdxBarButton
      Action = actTax
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
    object bbSalePack21: TdxBarButton
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
    object bbUpdatePriceCurrency: TdxBarButton
      Action = actUpdatePriceCurrency
      Category = 0
    end
    object bbPrint_TTN: TdxBarButton
      Action = mactPrint_TTN
      Category = 0
    end
    object bbPrint_Quality: TdxBarButton
      Action = mactPrint_QualityDoc
      Category = 0
    end
    object bbPrint_Transport: TdxBarButton
      Action = mactPrint_Transport
      Category = 0
    end
    object bbOpenReport: TdxBarButton
      Action = actOpenReportForm
      Category = 0
    end
    object bbOpenProduction: TdxBarButton
      Action = actOpenProductionForm
      Category = 0
    end
    object bbPrintPackGross: TdxBarButton
      Action = actPrintPackGross
      Category = 0
    end
    object bbPrint_PackWeight: TdxBarButton
      Action = actPrint_PackWeight
      Category = 0
    end
    object bbOrderExternal: TdxBarButton
      Action = actOpenFormOrderExternal
      Category = 0
    end
    object bbPromo: TdxBarButton
      Action = macOpenFormPromo
      Category = 0
    end
    object bbUpdate_PartionGoodsDateList: TdxBarButton
      Action = macUpdate_PartionGoodsDateList
      Category = 0
    end
    object bbUpdate_Invnumber: TdxBarButton
      Action = macUpdate_Invnumber
      Category = 0
    end
    object bbUpdateMI_Sale_PriceIn: TdxBarButton
      Action = macUpdateMI_Sale_PriceIn
      Category = 0
    end
    object bbUpdateMaskReturn: TdxBarButton
      Action = mactUpdateMaskReturn
      Category = 0
    end
    object bbUpdateMaskSend: TdxBarButton
      Action = mactUpdateMaskSend
      Category = 0
    end
    object bbExport_XML: TdxBarButton
      Action = macExport_XML
      Category = 0
    end
    object bbOpenProductionUnitForm: TdxBarButton
      Action = actOpenProductionUnitForm
      Category = 0
    end
    object bbsSeparator: TdxBarSeparator
      Caption = 'Separator'
      Category = 0
      Hint = 'Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbsEdit: TdxBarSubItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 79
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbUpdatePriceCurrency'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMI_Sale_PriceIn'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Currency'
        end
        item
          Visible = True
          ItemName = 'bbsSeparator'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_PartionGoodsDateList'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Invnumber'
        end
        item
          Visible = True
          ItemName = 'bbsSeparator'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMaskReturn'
        end
        item
          Visible = True
          ItemName = 'bbUpdateMaskSend'
        end
        item
          Visible = True
          ItemName = 'bbsSeparator'
        end
        item
          Visible = True
          ItemName = 'bbUpdateTotalSumm_GoodsReal'
        end>
    end
    object bbsShow: TdxBarSubItem
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088
      Category = 0
      Visible = ivAlways
      ImageIndex = 24
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbOpenReport'
        end
        item
          Visible = True
          ItemName = 'bbsSeparator'
        end
        item
          Visible = True
          ItemName = 'bbOpenProduction'
        end
        item
          Visible = True
          ItemName = 'bbOpenProductionUnitForm'
        end
        item
          Visible = True
          ItemName = 'bbOrderExternal'
        end
        item
          Visible = True
          ItemName = 'bbPromo'
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
        end>
    end
    object bbsPrint: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
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
          ItemName = 'bbPrint_PackWeight'
        end
        item
          Visible = True
          ItemName = 'bbPrintBox'
        end
        item
          Visible = True
          ItemName = 'bbPrintBoxTotal'
        end
        item
          Visible = True
          ItemName = 'bbPrintBoxTotalPartner'
        end
        item
          Visible = True
          ItemName = 'bbsSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Bill'
        end
        item
          Visible = True
          ItemName = 'bbsSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrintTax_Client'
        end
        item
          Visible = True
          ItemName = 'bbPrintTax'
        end
        item
          Visible = True
          ItemName = 'bbsSeparator'
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
          ItemName = 'bbsSeparator'
        end
        item
          Visible = True
          ItemName = 'bbSalePack21'
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
          ItemName = 'bbsSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrint_TTN'
        end
        item
          Visible = True
          ItemName = 'bbsSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Quality'
        end>
    end
    object bbUpdate_Currency: TdxBarButton
      Action = mactUpdate_Currency
      Category = 0
    end
    object bbUpdateTotalSumm_GoodsReal: TdxBarButton
      Action = actUpdateTotalSumm_GoodsReal
      Category = 0
    end
    object bbPrintBox: TdxBarButton
      Action = actPrintBox
      Category = 0
    end
    object bbPrintBoxTotal: TdxBarButton
      Action = actPrintBoxTotal
      Category = 0
    end
    object bbPrintBoxTotalPartner: TdxBarButton
      Action = actPrintBoxTotalPartner
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnlyEditingCellOnEnter = True
    ColumnEnterList = <
      item
        Column = GoodsName
      end
      item
        Column = AmountPartner
      end>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    Left = 830
    Top = 265
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
        Name = 'ReportNameSale'
        Value = Null
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
        Name = 'ReportNameSaleBill'
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
        Name = 'ReportNameTransport'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameQuality'
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
      end>
    Left = 32
    Top = 304
  end
  inherited StatusGuides: TdsdGuides
    Tag = 123
    Left = 56
    Top = 56
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Sale'
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
        Name = 'inStatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsReCalcPrice'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 80
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Sale'
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
        Name = 'inChangePercentAmount'
        Value = Null
        Component = FormParams
        ComponentItem = 'inChangePercentAmount'
        DataType = ftFloat
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
        DataType = ftDateTime
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
        Name = 'Checked'
        Value = False
        Component = edIsChecked
        DataType = ftBoolean
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
        Name = 'InvNumberPartner'
        Value = ''
        Component = edInvNumberPartner
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = False
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
        DataType = ftString
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
        DataType = ftString
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
        Name = 'RouteSortingId'
        Value = ''
        Component = GuidesRouteSorting
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteSortingName'
        Value = ''
        Component = GuidesRouteSorting
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
        Name = 'CurrencyPartnerValue'
        Value = 0.000000000000000000
        Component = edCurrencyPartnerValue
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParPartnerValue'
        Value = Null
        Component = edParPartnerValue
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Order'
        Value = Null
        Component = GuidesInvNumberOrder
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberOrder'
        Value = ''
        Component = GuidesInvNumberOrder
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListId'
        Value = ''
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
        Name = 'InvNumberPartner_Master'
        Value = ''
        Component = edTax
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCOMDOC'
        Value = False
        Component = cbCOMDOC
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_TransportGoods'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementId_TransportGoods'
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_TransportGoods'
        Value = Null
        Component = FormParams
        ComponentItem = 'OperDate_TransportGoods'
        DataType = ftDateTime
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
        Name = 'CurrencyValue'
        Value = Null
        Component = edCurrencyValue
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParValue'
        Value = Null
        Component = edParValue
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Transport'
        Value = Null
        Component = TransportChoiceGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Transport'
        Value = Null
        Component = TransportChoiceGuides
        ComponentItem = 'TextValue'
        DataType = ftString
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
        Name = 'ReestrKindId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReestrKindName'
        Value = Null
        Component = edReestrKind
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_Production'
        Value = '0'
        Component = GuidesProductionDoc
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_ProductionFull'
        Value = Null
        Component = GuidesProductionDoc
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartionGoodsDate'
        Value = Null
        Component = edPartionGoodsDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListIn'
        Value = Null
        Component = GuidesPriceListIn
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListName'
        Value = Null
        Component = GuidesPriceListIn
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_ReturnIn'
        Value = Null
        Component = GuidesReturnIn
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_ReturnInFull'
        Value = Null
        Component = GuidesReturnIn
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCurrencyUser'
        Value = Null
        Component = cbCurrencyUser
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Sale_Partner'
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
        Name = 'inInvNumberOrder'
        Value = ''
        Component = GuidesInvNumberOrder
        ComponentItem = 'TextValue'
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
        Name = 'inOperDatePartner'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChecked'
        Value = False
        Component = edIsChecked
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPriceWithVAT'
        Value = False
        Component = edPriceWithVAT
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outVATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioChangePercent'
        Value = 0.000000000000000000
        Component = edChangePercent
        DataType = ftFloat
        ParamType = ptInputOutput
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
        Name = 'inRouteSortingId'
        Value = ''
        Component = GuidesRouteSorting
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
        Name = 'inDocumentTaxKindId_inf'
        Value = ''
        Component = DocumentTaxKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Order'
        Value = Null
        Component = GuidesInvNumberOrder
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_ReturnIn'
        Value = Null
        Component = GuidesReturnIn
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioPriceListId'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPriceListName'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCurrencyValue'
        Value = Null
        Component = edCurrencyValue
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outParValue'
        Value = Null
        Component = edParValue
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCurrencyPartnerValue'
        Value = 0.000000000000000000
        Component = edCurrencyPartnerValue
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioParPartnerValue'
        Value = Null
        Component = edParPartnerValue
        DataType = ftFloat
        ParamType = ptInputOutput
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
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
      end>
    Left = 160
    Top = 232
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
        Control = edInvNumberOrder
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
        Control = edIsChecked
      end
      item
        Control = edPaidKind
      end
      item
        Control = edContract
      end
      item
        Control = edPriceList
      end
      item
        Control = edRouteSorting
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
        Control = edCurrencyPartnerValue
      end
      item
        Control = edParPartnerValue
      end
      item
        Control = ceComment
      end
      item
        Control = edReestrKind
      end
      item
        Control = edReturnIn
      end>
    Left = 232
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 912
    Top = 320
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Sale_Partner_SetErased'
    Left = 718
    Top = 544
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Sale_Partner_SetUnErased'
    Left = 718
    Top = 464
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Sale_Partner'
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
        Name = 'inAmountPartner'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountPartner'
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
        Name = 'inCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Count'
        DataType = ftFloat
        ParamType = ptInput
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
        Name = 'inBoxCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BoxCount'
        DataType = ftFloat
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
        Name = 'inBoxId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BoxId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsRealCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsRealCode'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsRealName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsRealName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsKindRealName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindRealName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Sale_Partner'
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
        Name = 'inAmountPartner'
        Value = 0.000000000000000000
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
        Name = 'inCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Count'
        DataType = ftFloat
        ParamType = ptInput
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
        Name = 'inBoxCount'
        Value = 0.000000000000000000
        DataType = ftFloat
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
        Name = 'inBoxId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BoxId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsRealCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsRealCode'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsRealName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsRealName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGoodsKindRealName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindRealName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 64
    Top = 368
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
    Left = 319
    Top = 360
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
    Top = 448
  end
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 652
    Top = 286
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 476
    Top = 246
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
    Left = 1184
    Top = 32
  end
  object spTax: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Tax_From_Kind'
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
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInvNumberPartner_Master'
        Value = ''
        Component = edTax
        DataType = ftString
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
    Left = 456
    Top = 304
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
    Left = 319
    Top = 304
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
    Left = 552
    Top = 384
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
      end>
    Left = 528
    Top = 320
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 404
    Top = 241
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
    Left = 440
    Top = 384
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
    Left = 808
    Top = 8
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
    Left = 968
    Top = 168
  end
  object PriceListGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
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
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = Null
        Component = edVATPercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = Null
        Component = CurrencyDocumentGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = Null
        Component = CurrencyDocumentGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 876
    Top = 16
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
    Left = 319
    Top = 208
  end
  object GuidesRouteSorting: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRouteSorting
    FormNameParam.Value = 'TRouteSortingForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRouteSortingForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRouteSorting
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRouteSorting
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 888
    Top = 65520
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 408
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
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
      end
      item
        Name = 'ContractTagId'
        Value = Null
        Component = ContractTagGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagName'
        Value = Null
        Component = ContractTagGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteSortingId'
        Value = Null
        Component = GuidesRouteSorting
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteSortingName'
        Value = Null
        Component = GuidesRouteSorting
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListId'
        Value = Null
        Component = PriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListName'
        Value = Null
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercent'
        Value = 0.000000000000000000
        Component = edChangePercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 616
  end
  object CurrencyPartnerGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCurrencyPartner
    FormNameParam.Value = 'TCurrencyValue_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCurrencyValue_ObjectForm'
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
      end
      item
        Name = 'CurrencyValue'
        Value = Null
        Component = edCurrencyPartnerValue
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ParValue'
        Value = Null
        Component = edParPartnerValue
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = edOperDatePartner
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyFromId'
        Value = Null
        Component = CurrencyDocumentGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end>
    Left = 1096
    Top = 8
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
    Left = 1096
    Top = 136
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
    Left = 995
    Top = 36
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
    Left = 311
    Top = 472
  end
  object GuidesInvNumberOrder: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumberOrder
    FormNameParam.Value = 'TOrderExternalJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderExternalJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesInvNumberOrder
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesInvNumberOrder
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDatePartner'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDatePartner_Sale'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteSortingId'
        Value = ''
        Component = GuidesRouteSorting
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteSortingName'
        Value = ''
        Component = GuidesRouteSorting
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagId'
        Value = ''
        Component = ContractTagGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagName'
        Value = ''
        Component = ContractTagGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListId'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListName'
        Value = ''
        Component = PriceListGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = 'False'
        Component = edPriceWithVAT
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ChangePercent'
        Value = 0.000000000000000000
        Component = edChangePercent
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 172
    Top = 16
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
    Left = 415
    Top = 501
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
    Left = 415
    Top = 520
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
    Left = 311
    Top = 456
  end
  object spUpdatePriceCurrency: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_Price_Currency'
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
    Left = 400
    Top = 328
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
    Left = 679
    Top = 360
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
    Left = 679
    Top = 408
  end
  object TransportChoiceGuides: TdsdGuides
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
        Component = TransportChoiceGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = TransportChoiceGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
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
      end>
    Left = 396
    Top = 88
  end
  object spInsertUpdateMovement_Params: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Sale_Transport'
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
        Name = 'inMovementId_Transport'
        Value = '0'
        Component = TransportChoiceGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 161
    Top = 432
  end
  object HeaderSaver2: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spInsertUpdateMovement_Params
    ControlList = <
      item
        Control = edInvNumberTransport
      end>
    GetStoredProc = spGet
    Left = 280
    Top = 265
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
    Left = 984
    Top = 256
  end
  object GuidesProductionDoc: TdsdGuides
    KeyField = 'Id'
    LookupControl = edInvNumberProduction
    Key = '0'
    FormNameParam.Value = 'TProductionPeresortJournalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TProductionPeresortJournalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '-1'
        Component = GuidesProductionDoc
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ' '
        Component = GuidesProductionDoc
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 836
    Top = 104
  end
  object spGetReportNameQuality: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Quality_ReportName'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
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
    Left = 936
    Top = 496
  end
  object spCheckRight: TdsdStoredProc
    StoredProcName = 'gpCheckRight_Movement_Promo'
    DataSets = <>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 240
    Top = 360
  end
  object spUpdate_MI_PartionGoodsDate: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_Sale_PartionGoodsDate'
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
        Name = 'inPartionGoodsDate'
        Value = 43831d
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1136
    Top = 307
  end
  object spUpdate_Invnumber: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Sale_Invnumber'
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
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1208
    Top = 267
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
    Left = 992
    Top = 360
  end
  object GuidesPriceListIn: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceListIn
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPriceList_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceList_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPriceListIn
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPriceListIn
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = False
        Component = edPriceWithVAT
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 876
    Top = 72
  end
  object spUpdateMI_Sale_PriceIn: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_Sale_PriceIn'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId '
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1120
    Top = 235
  end
  object GuidesReturnIn: TdsdGuides
    KeyField = 'Id'
    LookupControl = edReturnIn
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
        Component = GuidesReturnIn
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesReturnIn
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 1300
    Top = 96
  end
  object spUpdateMask: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_Sale_isMask'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId '
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementMaskId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'MaskId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 272
    Top = 507
  end
  object spGet_Export_FileNameXML: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Sale_FileNameXML'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        ComponentItem = 'DefaultFileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDefaultFileExt'
        Value = Null
        ComponentItem = 'DefaultFileExt'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outEncodingANSI'
        Value = Null
        ComponentItem = 'EncodingANSI'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFileName'
        Value = Null
        ComponentItem = 'FileName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 816
    Top = 344
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
        Value = '0'
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 864
    Top = 392
  end
  object ExportCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 880
    Top = 552
  end
  object ExportDS: TDataSource
    DataSet = ExportCDS
    Left = 912
    Top = 552
  end
  object spUpdate_CurrencyUser: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Sale_Currency'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
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
        Name = 'ioCurrencyValue'
        Value = 0.000000000000000000
        Component = edCurrencyValue
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioParValue'
        Value = 1.000000000000000000
        Component = edParValue
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCurrencyUser'
        Value = False
        Component = cbCurrencyUser
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1280
    Top = 339
  end
  object spUpdateTotalSumm_GoodsReal: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_Sale_TotalSumm_GoodsReal'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioisTotalSumm_GoodsReal'
        Value = False
        Component = cbTotalSumm_GoodsReal
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1088
    Top = 371
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
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 567
    Top = 240
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
    Left = 623
    Top = 232
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
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 583
    Top = 360
  end
end
