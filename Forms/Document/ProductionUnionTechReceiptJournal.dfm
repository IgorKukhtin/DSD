inherited ProductionUnionTechReceiptJournalForm: TProductionUnionTechReceiptJournalForm
  Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1058#1077#1093#1085#1086#1083#1086#1075' ('#1088#1077#1094#1077#1087#1090#1091#1088#1099')'
  ClientHeight = 685
  ClientWidth = 1203
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1219
  ExplicitHeight = 724
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 61
    Width = 1203
    Height = 624
    TabOrder = 2
    ExplicitTop = 61
    ExplicitWidth = 1203
    ExplicitHeight = 624
    ClientRectBottom = 624
    ClientRectRight = 1203
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1203
      ExplicitHeight = 600
      inherited cxGrid: TcxGrid
        Width = 1203
        Height = 292
        ExplicitWidth = 1203
        ExplicitHeight = 292
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CuterCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_order
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CuterCount_order
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CuterWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeightMsg
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeightShp
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountReal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountReal_LakTo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_LakFrom
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count_LakTo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count_LakFrom
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountReal_LAK
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountNext_out
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForm_two
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CuterCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_order
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CuterCount_order
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CuterWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeightMsg
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeightShp
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountReal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountReal_LakTo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_LakFrom
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count_LakTo
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Count_LakFrom
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountReal_LAK
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountNext_out
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountForm_two
            end>
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
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object StatusCode: TcxGridDBColumn [1]
            Caption = '*'#1057#1090#1072#1090#1091#1089
            DataBinding.FieldName = 'StatusCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 11
                Value = 4
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
                Description = '***'#1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 32
                Value = 1
              end>
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InvNumber: TcxGridDBColumn [2]
            Caption = #8470' '#1044#1086#1082
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object OperDate: TcxGridDBColumn [3]
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object DocumentKindName: TcxGridDBColumn [4]
            Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'DocumentKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          inherited colGoodsName: TcxGridDBColumn
            Options.Editing = False
          end
          object MeasureName: TcxGridDBColumn [7]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsKindName: TcxGridDBColumn [8]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object RealWeight: TcxGridDBColumn [9]
            Caption = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090
            DataBinding.FieldName = 'RealWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object RealWeightMsg: TcxGridDBColumn [10]
            Caption = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090' ('#1084#1089#1078')'
            DataBinding.FieldName = 'RealWeightMsg'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090' ('#1087#1086#1089#1083#1077' '#1084#1072#1089#1089#1072#1078#1077#1088#1072')'
            Options.Editing = False
            Width = 70
          end
          object RealWeightShp: TcxGridDBColumn [11]
            Caption = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090' ('#1096#1087#1088')'
            DataBinding.FieldName = 'RealWeightShp'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090' ('#1087#1086#1089#1083#1077' '#1096#1087#1088#1080#1094#1077#1074#1072#1085#1080#1103')'
            Options.Editing = False
            Width = 70
          end
          object GoodsKindName_Complete: TcxGridDBColumn [12]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1043#1055
            DataBinding.FieldName = 'GoodsKindName_Complete'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoiceMaster
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isOrderSecond: TcxGridDBColumn [13]
            Caption = #1044#1086#1079#1072#1103#1074#1082#1072
            DataBinding.FieldName = 'isOrderSecond'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object TermProduction: TcxGridDBColumn [14]
            Caption = #1050'. '#1076#1085'. '#1079#1072#1082#1088'. '#1087#1072#1088#1090'.'
            DataBinding.FieldName = 'TermProduction'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PartionGoodsDate: TcxGridDBColumn [15]
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoodsDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PartionGoodsDateClose: TcxGridDBColumn [16]
            Caption = #1055#1083#1072#1085' '#1074#1099#1093#1086#1076' '#1043#1055
            DataBinding.FieldName = 'PartionGoodsDateClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object IsPartionClose: TcxGridDBColumn [17]
            Caption = #1055#1072#1088#1090#1080#1103' '#1079#1072#1082#1088#1099#1090#1072' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isPartionClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountForm: TcxGridDBColumn [18]
            Caption = #1050#1086#1083'-'#1074#1086' '#1092#1086#1088#1084#1086#1074#1082#1072'+1'#1076#1077#1085#1100', '#1082#1075
            DataBinding.FieldName = 'AmountForm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1092#1086#1088#1084#1086#1074#1082#1072'+1'#1076#1077#1085#1100','#1082#1075
            Options.Editing = False
            Width = 69
          end
          object AmountForm_two: TcxGridDBColumn [19]
            Caption = #1050#1086#1083'-'#1074#1086' '#1092#1086#1088#1084#1086#1074#1082#1072'+2'#1076#1077#1085#1100', '#1082#1075
            DataBinding.FieldName = 'AmountForm_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1092#1086#1088#1084#1086#1074#1082#1072'+2'#1076#1077#1085#1100','#1082#1075
            Options.Editing = False
            Width = 69
          end
          object Amount: TcxGridDBColumn [20]
            Caption = #1060#1072#1082#1090' '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Amount_calc: TcxGridDBColumn [21]
            Caption = #1056#1072#1089#1095#1077#1090' '#1082#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Count: TcxGridDBColumn [22]
            Caption = #1050#1086#1083'-'#1074#1086' '#1073#1072#1090#1086#1085#1086#1074
            DataBinding.FieldName = 'Count'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object Amount_order: TcxGridDBColumn [23]
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1072#1103#1074#1082#1072
            DataBinding.FieldName = 'Amount_order'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object CuterCount_order: TcxGridDBColumn [24]
            Caption = #1050#1091#1090#1090#1077#1088#1086#1074' '#1079#1072#1103#1074#1082#1072
            DataBinding.FieldName = 'CuterCount_order'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object AmountNext_out: TcxGridDBColumn [25]
            Caption = #1055#1077#1088#1077#1093#1086#1076#1103#1097#1080#1081' '#1055'/'#1060' ('#1087#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'AmountNext_out'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object IsMain: TcxGridDBColumn [26]
            Caption = #1043#1083#1072#1074#1085'.'
            DataBinding.FieldName = 'isMain'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object ReceiptCode: TcxGridDBColumn [27]
            Caption = #1050#1086#1076' '#1088#1077#1094#1077#1087#1090'.'
            DataBinding.FieldName = 'ReceiptCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actReceiptChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object ReceiptName: TcxGridDBColumn [28]
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
            DataBinding.FieldName = 'ReceiptName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actReceiptChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object PartionGoods: TcxGridDBColumn [29]
            Caption = #1055#1072#1088#1090#1080#1103' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'PartionGoods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Comment_receipt: TcxGridDBColumn [30]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1088#1077#1094#1077#1087#1090#1091#1088#1072')'
            DataBinding.FieldName = 'Comment_receipt'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Comment: TcxGridDBColumn [31]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object InsertName: TcxGridDBColumn [32]
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object UpdateName: TcxGridDBColumn [33]
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
            DataBinding.FieldName = 'UpdateName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object InsertDate: TcxGridDBColumn [34]
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
            DataBinding.FieldName = 'InsertDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object UpdateDate: TcxGridDBColumn [35]
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object CuterWeight: TcxGridDBColumn [36]
            Caption = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090'('#1082#1091#1090#1090#1077#1088')'
            DataBinding.FieldName = 'CuterWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object CuterCount: TcxGridDBColumn [37]
            Caption = #1050#1091#1090#1090#1077#1088#1086#1074' '#1092#1072#1082#1090
            DataBinding.FieldName = 'CuterCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object CountReal: TcxGridDBColumn [38]
            Caption = #1050#1086#1083'. '#1096#1090'. '#1092#1072#1082#1090' ('#1090#1091#1096#1077#1085#1082#1072')'
            DataBinding.FieldName = 'CountReal'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object CountReal_LakTo: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1087#1077#1088#1077#1076' '#1083#1072#1082'-'#1077#1084
            DataBinding.FieldName = 'CountReal_LakTo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1087#1077#1088#1077#1076' '#1083#1072#1082#1080#1088#1086#1074#1072#1085#1080#1077#1084
            Options.Editing = False
            Width = 70
          end
          object Amount_LakFrom: TcxGridDBColumn
            Caption = #1042#1077#1089' '#1087#1086#1089#1083#1077' '#1083#1072#1082'-'#1080#1103
            DataBinding.FieldName = 'CountReal_LakFrom'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1077#1089' '#1087#1086#1089#1083#1077' '#1083#1072#1082#1080#1088#1086#1074#1072#1085#1080#1103
            Options.Editing = False
            Width = 70
          end
          object Count_LakTo: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1073#1072#1090'. '#1085#1072' '#1083#1072#1082'-'#1080#1080
            DataBinding.FieldName = 'Count_LakTo'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1073#1072#1090#1086#1085#1086#1074' '#1085#1072' '#1083#1072#1082#1080#1088#1086#1074#1072#1085#1080#1080
            Options.Editing = False
            Width = 70
          end
          object Count_LakFrom: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1073#1072#1090'. '#1087#1086#1089#1083#1077' '#1083#1072#1082'-'#1080#1103
            DataBinding.FieldName = 'Count_LakFrom'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1073#1072#1090#1086#1085#1086#1074' '#1087#1086#1089#1083#1077' '#1083#1072#1082#1080#1088#1086#1074#1072#1085#1080#1103
            Options.Editing = False
            Width = 70
          end
          object OperDate_LakTo: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1085#1072' '#1083#1072#1082'-'#1080#1077
            DataBinding.FieldName = 'OperDate_LakTo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1085#1072' '#1083#1072#1082#1080#1088#1086#1074#1072#1085#1080#1077
            Options.Editing = False
            Width = 70
          end
          object OperDate_LakFrom: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1089' '#1083#1072#1082'-'#1080#1103
            DataBinding.FieldName = 'OperDate_LakFrom'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1089' '#1083#1072#1082#1080#1088#1086#1074#1072#1085#1080#1103
            Options.Editing = False
            Width = 70
          end
          object CountReal_LAK: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1042#1077#1089' ('#1083#1072#1082')'
            DataBinding.FieldName = 'CountReal_LAK'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MovementItem_partion: TcxGridDBColumn
            Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088' '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'MovementItem_partion'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1090#1086#1088' '#1055#1072#1088#1090#1080#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1087#1092'-'#1075#1087
            Options.Editing = False
            Width = 70
          end
          object Partion: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1087#1092'-'#1075#1087
            DataBinding.FieldName = 'Partion'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1072#1088#1090#1080#1103' '#1079#1072#1082#1083#1072#1076#1082#1080' '#1087#1092'-'#1075#1087
            Options.Editing = False
            Width = 120
          end
        end
      end
      inherited cxGridChild: TcxGrid
        Top = 297
        Width = 1203
        ExplicitTop = 297
        ExplicitWidth = 1203
        inherited cxGridDBTableViewChild: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmountReceiptWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmountWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmountCalcWeight
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmountReceiptWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmountWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colChildAmountCalcWeight
            end>
          Styles.Content = nil
          object colChildGroupNumber: TcxGridDBColumn [0]
            Caption = #1043#1088#1091#1087#1087#1072' '#8470
            DataBinding.FieldName = 'GroupNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object colChildMeasureName: TcxGridDBColumn [3]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colChildGoodsKindName: TcxGridDBColumn [4]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoiceChild
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colChildGoodsKindCompleteName: TcxGridDBColumn [5]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' '#1043#1055
            DataBinding.FieldName = 'GoodsKindCompleteName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindCompleteChoiceChild
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colChildAmountReceipt: TcxGridDBColumn [6]
            Caption = #1050#1086#1083'-'#1074#1086' 1 '#1082#1091#1090#1077#1088
            DataBinding.FieldName = 'AmountReceipt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colChildAmount: TcxGridDBColumn [7]
            Caption = #1050#1086#1083'-'#1074#1086' '#1092#1072#1082#1090
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colChildAmountCalc: TcxGridDBColumn [8]
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1072#1089#1095#1077#1090
            DataBinding.FieldName = 'AmountCalc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colChildAmountReceiptWeight: TcxGridDBColumn [9]
            Caption = #1050#1086#1083'-'#1074#1086' 1 '#1082#1091#1090#1077#1088' ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountReceiptWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colChildAmountWeight: TcxGridDBColumn [10]
            Caption = #1050#1086#1083'-'#1074#1086' '#1092#1072#1082#1090' ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colChildAmountCalcWeight: TcxGridDBColumn [11]
            Caption = #1050#1086#1083'-'#1074#1086' '#1088#1072#1089#1095'. ('#1074#1077#1089')'
            DataBinding.FieldName = 'AmountCalcWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object isTaxExit: TcxGridDBColumn [12]
            Caption = #1047#1072#1074#1080#1089#1080#1090' '#1086#1090' % '#1074#1099#1093'.'
            DataBinding.FieldName = 'isTaxExit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isWeightMain: TcxGridDBColumn [13]
            Caption = #1042#1093#1086#1076#1080#1090' '#1074' '#1086#1089#1085'. '#1089#1099#1088#1100#1077' (100 '#1082#1075'.)'
            DataBinding.FieldName = 'isWeightMain'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colChildPartionGoodsDate: TcxGridDBColumn [14]
            Caption = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'PartionGoodsDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.SaveTime = False
            Properties.ShowTime = False
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colChildPartionGoods: TcxGridDBColumn [15]
            Caption = #1055#1072#1088#1090#1080#1103' '#1089#1099#1088#1100#1103
            DataBinding.FieldName = 'PartionGoods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colChildComment: TcxGridDBColumn [16]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object colChildInsertName: TcxGridDBColumn [17]
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object colChildUpdateName: TcxGridDBColumn [18]
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
            DataBinding.FieldName = 'UpdateName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object colChildInsertDate: TcxGridDBColumn [19]
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
            DataBinding.FieldName = 'InsertDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object colChildUpdateDate: TcxGridDBColumn [20]
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object colChildColor_calc: TcxGridDBColumn [21]
            DataBinding.FieldName = 'Color_calc'
            Visible = False
            VisibleForCustomization = False
            Width = 55
          end
          inherited colChildIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
        end
      end
      inherited cxBottomSplitter: TcxSplitter
        Top = 292
        Width = 1203
        ExplicitTop = 292
        ExplicitWidth = 1203
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1203
    Height = 35
    ExplicitWidth = 1203
    ExplicitHeight = 35
    inherited edInvNumber: TcxTextEdit
      Left = 989
      Top = 7
      Visible = False
      ExplicitLeft = 989
      ExplicitTop = 7
      ExplicitWidth = 75
      Width = 75
    end
    inherited cxLabel1: TcxLabel
      Left = 987
      Top = -2
      Visible = False
      ExplicitLeft = 987
      ExplicitTop = -2
    end
    inherited edOperDate: TcxDateEdit
      Left = 1068
      Top = 7
      Visible = False
      ExplicitLeft = 1068
      ExplicitTop = 7
      ExplicitWidth = 61
      Width = 61
    end
    inherited cxLabel2: TcxLabel
      Left = 1068
      Top = -2
      Visible = False
      ExplicitLeft = 1068
      ExplicitTop = -2
    end
    inherited cxLabel15: TcxLabel
      Left = 1135
      Top = -2
      Visible = False
      ExplicitLeft = 1135
      ExplicitTop = -2
    end
    inherited ceStatus: TcxButtonEdit
      Left = 1135
      Top = 17
      Visible = False
      ExplicitLeft = 1135
      ExplicitTop = 17
      ExplicitWidth = 100
      ExplicitHeight = 22
      Width = 100
    end
    inherited cxLabel3: TcxLabel
      Left = 279
      Top = 8
      Caption = #1054#1090' '#1082#1086#1075#1086' :'
      ExplicitLeft = 279
      ExplicitTop = 8
      ExplicitWidth = 51
    end
    inherited cxLabel4: TcxLabel
      Left = 530
      Top = 8
      Caption = #1050#1086#1084#1091' :'
      ExplicitLeft = 530
      ExplicitTop = 8
      ExplicitWidth = 36
    end
    inherited edFrom: TcxButtonEdit
      Left = 330
      Top = 7
      ExplicitLeft = 330
      ExplicitTop = 7
      ExplicitWidth = 192
      Width = 192
    end
    inherited edTo: TcxButtonEdit
      Left = 565
      Top = 7
      ExplicitLeft = 565
      ExplicitTop = 7
      ExplicitWidth = 200
      Width = 200
    end
    object cxLabel5: TcxLabel
      Left = 5
      Top = 8
      Caption = #1044#1072#1090#1072' '#1089' :'
    end
    object deStart: TcxDateEdit
      Left = 50
      Top = 7
      EditValue = 42522d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 11
      Width = 80
    end
    object cxLabel6: TcxLabel
      Left = 138
      Top = 8
      Caption = #1044#1072#1090#1072' '#1087#1086' :'
    end
    object deEnd: TcxDateEdit
      Left = 190
      Top = 7
      EditValue = 42522d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 13
      Width = 80
    end
    object cbisLak: TcxCheckBox
      Left = 794
      Top = 8
      Action = actRefresh_lak
      TabOrder = 14
      Width = 105
    end
  end
  object edJuridicalBasis: TcxButtonEdit [2]
    Left = 1008
    Top = 7
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 150
  end
  object cxLabel27: TcxLabel [3]
    Left = 930
    Top = 8
    Caption = #1055#1088#1077#1076#1087#1088#1080#1103#1090#1080#1077':'
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
      end>
  end
  inherited ActionList: TActionList
    object actRefresh_lak: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1083#1072#1082'-'#1077
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object actUpdate_isWeightMain: TdsdUpdateDataSet [1]
      Category = 'Child'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isWeightMain
      StoredProcList = <
        item
          StoredProc = spUpdate_isWeightMain
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1042#1093#1086#1076#1080#1090' '#1074' '#1086#1089#1085'. '#1089#1099#1088#1100#1077' (100 '#1082#1075'.)> '#1044#1072' / '#1053#1077#1090
      ImageIndex = 76
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      RefreshOnTabSetChanges = True
    end
    object actPrintDays2_cuter: TdsdPrintAction [3]
      Category = 'PrintDays'
      MoveParams = <
        item
          FromParam.Name = 'isDetail'
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'isDetail'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isDetail'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spPrintDays2
      StoredProcList = <
        item
          StoredProc = spPrintDays2
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1076#1083#1103' '#1089#1087#1077#1094#1080#1081' ('#1087#1086' '#1082#1091#1090#1090#1077#1088#1072#1084')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1047#1072#1082#1083#1072#1076#1082#1080' '#1089#1087#1077#1094#1080#1081' ('#1087#1086' '#1076#1085#1103#1084')'
      ImageIndex = 20
      DataSets = <
        item
          DataSet = PrintMasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'OperDate;GoodsName;GoodsKind_group;GoodsName_child;GoodsKindName' +
            '_Complete'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42522d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42522d
          Component = deEnd
          DataType = ftDateTime
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
          Name = 'isDetail'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLoss'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isCalc'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1087#1086' '#1076#1085#1103#1084' '#1076#1083#1103' '#1089#1099#1088#1100#1103')'
      ReportNameParam.Value = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1087#1086' '#1076#1085#1103#1084' '#1076#1083#1103' '#1089#1099#1088#1100#1103')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actMISetErased: TdsdUpdateErased
      Enabled = False
    end
    inherited actMISetUnErased: TdsdUpdateErased
      Enabled = False
    end
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      Enabled = False
      StoredProc = nil
      StoredProcList = <>
    end
    inherited actShowAll: TBooleanStoredProcAction
      Enabled = False
    end
    object ExecuteDialog_operdate: TExecuteDialog [10]
      Category = 'Update_OperDate'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = 'actDataDialog'
      ImageIndex = 67
      FormName = 'TDataDialogForm'
      FormNameParam.Value = 'TDataDialogForm'
      FormNameParam.DataType = ftDateTime
      FormNameParam.ParamType = ptInputOutput
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'inOperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actPrintCeh: TdsdPrintAction [12]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectPrintCeh
      StoredProcList = <
        item
          StoredProc = spSelectPrintCeh
        end>
      Caption = #1055#1077#1095#1072#1090#1100' - '#1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077' '#1087'/'#1092' '#1092#1072#1082#1090' '#1082#1091#1090#1090#1077#1088#1072
      Hint = #1055#1077#1095#1072#1090#1100' - '#1042#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077' '#1087'/'#1092' '#1092#1072#1082#1090' '#1082#1091#1090#1090#1077#1088#1072
      ImageIndex = 22
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <>
      ReportName = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1087#1086' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1102' '#1082#1091#1090#1090#1077#1088#1072
      ReportNameParam.Value = #1053#1072#1082#1083#1072#1076#1085#1072#1103' '#1087#1086' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1102' '#1082#1091#1090#1090#1077#1088#1072
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actPrint: TdsdPrintAction
      MoveParams = <
        item
          FromParam.Name = 'isDetail'
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'isDetail'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isDetail'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spReport_TaxExit
      StoredProcList = <
        item
          StoredProc = spReport_TaxExit
        end>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1093#1086#1076#1072' ('#1080#1090#1086#1075#1080')>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1093#1086#1076#1072' ('#1080#1090#1086#1075#1080')>'
      DataSets = <
        item
          DataSet = PrintMasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsName;PartionGoodsDate;GoodsKindName_Comp' +
            'lete'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
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
          Name = 'isDetail'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLoss'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1093#1086#1076#1072' ('#1080#1090#1086#1075#1080')'
      ReportNameParam.Value = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1093#1086#1076#1072' ('#1080#1090#1086#1075#1080')'
    end
    object actUpdateChildDS: TdsdUpdateDataSet [14]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIChild
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIChild
        end>
      Caption = 'actUpdateChildDS'
      DataSource = ChildDS
    end
    inherited actAddMask: TdsdExecStoredProc
      Enabled = False
    end
    inherited InsertRecordChild: TInsertRecord
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1088#1072#1089#1093#1086#1076')>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1088#1072#1089#1093#1086#1076')>'
    end
    inherited actMIChildSetErased: TdsdUpdateErased
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1088#1072#1089#1093#1086#1076')>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1088#1072#1089#1093#1086#1076')>'
    end
    inherited actMIChildSetUnErased: TdsdUpdateErased
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1088#1072#1089#1093#1086#1076')>'
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1088#1072#1089#1093#1086#1076')>'
    end
    object actGoodsKindChoiceChild: TOpenChoiceForm [23]
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
          Component = ChildCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGoodsKindChoiceMaster: TOpenChoiceForm [24]
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
          ComponentItem = 'GoodsKindCompleteId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindCompleteName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    inherited actMIMasterProtocol: TdsdOpenForm
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementItemId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object MovementProtocolOpenForm: TdsdOpenForm [26]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
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
          ComponentItem = 'MovementId'
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
    object actUpdate: TdsdInsertUpdateAction [27]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1087#1088#1080#1093#1086#1076')>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1087#1088#1080#1093#1086#1076')>'
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TProductionUnionTechEditForm'
      FormNameParam.Value = 'TProductionUnionTechEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MovementId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = 41791d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementItemId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementItemId_order'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementItemId_order'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToId'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DocumentKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'DocumentKindId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'MovementItemId'
    end
    object actInsert: TdsdInsertUpdateAction [28]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1087#1088#1080#1093#1086#1076')>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1087#1088#1080#1093#1086#1076')>'
      ImageIndex = 0
      FormName = 'TProductionUnionTechEditForm'
      FormNameParam.Value = 'TProductionUnionTechEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MovementId'
          Value = 0
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'OperDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Id'
          Value = 0
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MovementItemId_order'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToId'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'MovementItemId'
    end
    inherited actMIChildProtocol: TdsdOpenForm
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'MovementItemId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actPrintReceipt: TdsdPrintAction [30]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPrintReceipt
      StoredProcList = <
        item
          StoredProc = spPrintReceipt
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
      Hint = #1055#1077#1095#1072#1090#1100' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
      ImageIndex = 17
      DataSets = <
        item
          DataSet = PrintMasterCDS
          UserName = 'Master'
          IndexFieldNames = 'ReceiptCode;ReceiptId;GroupNumber;InfoMoneyName;GoodsName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41791d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41791d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1077#1095#1072#1090#1100'_'#1088#1077#1094#1077#1087#1090#1086#1074
      ReportNameParam.Value = #1055#1077#1095#1072#1090#1100'_'#1088#1077#1094#1077#1087#1090#1086#1074
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actUnCompleteList: TMultiAction [31]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleUncompleteList
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1088#1072#1089#1087#1088#1086#1074#1077#1076#1077#1085#1080#1080' '#1042#1089#1077#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'? '
      InfoAfterExecute = #1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1088#1072#1089#1087#1088#1086#1074#1077#1076#1077#1085#1099
      Caption = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      ImageIndex = 11
    end
    object actSetErasedList: TMultiAction [32]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleErased
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080' '#1042#1089#1077#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'? '
      InfoAfterExecute = #1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1091#1076#1072#1083#1077#1085#1099
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      ImageIndex = 13
    end
    object actSimpleErased: TMultiAction [33]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spErased
        end>
      View = cxGridDBTableView
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
    end
    object spErased: TdsdExecStoredProc [34]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementSetErased
      StoredProcList = <
        item
          StoredProc = spMovementSetErased
        end>
      Caption = 'spErased'
    end
    object actSimpleUncompleteList: TMultiAction [35]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spUncomplete
        end>
      View = cxGridDBTableView
      Caption = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
    end
    object spUncomplete: TdsdExecStoredProc [36]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementUnComplete
      StoredProcList = <
        item
          StoredProc = spMovementUnComplete
        end>
      Caption = 'spUncomplete'
    end
    object spCompete: TdsdExecStoredProc [37]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementComplete
      StoredProcList = <
        item
          StoredProc = spMovementComplete
        end>
      Caption = 'spCompete'
    end
    object actSimpleCompleteList: TMultiAction [38]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spCompete
        end>
      View = cxGridDBTableView
      Caption = #1055#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      Hint = #1055#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
    end
    object actCompleteList: TMultiAction [39]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleCompleteList
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1088#1086#1074#1077#1076#1077#1085#1080#1080' '#1042#1089#1077#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'? '
      InfoAfterExecute = #1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1088#1086#1074#1077#1076#1077#1085#1099
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      ImageIndex = 12
    end
    object actReCompleteList: TMultiAction [40]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimpleReCompleteList
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1087#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1080#1080' '#1042#1089#1077#1093' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'? '
      InfoAfterExecute = #1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1087#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1099
      Caption = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      Hint = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      ImageIndex = 12
    end
    object actSimpleReCompleteList: TMultiAction [41]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = spReCompete
        end>
      View = cxGridDBTableView
      Caption = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
      Hint = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
    end
    object spReCompete: TdsdExecStoredProc [42]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spMovementReComplete
      StoredProcList = <
        item
          StoredProc = spMovementReComplete
        end>
      Caption = 'spReCompete'
    end
    object actReport_TaxExit_Loss: TdsdPrintAction [43]
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'isDetail'
          FromParam.Value = True
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'isDetail'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isDetail'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spReport_TaxExit
      StoredProcList = <
        item
          StoredProc = spReport_TaxExit
        end>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1087#1086#1090#1077#1088#1100' ('#1080#1090#1086#1075#1080')>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1087#1086#1090#1077#1088#1100' ('#1080#1090#1086#1075#1080')>'
      ImageIndex = 18
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintMasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsName;PartionGoodsDate;GoodsKindName_Comp' +
            'lete'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41791d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41791d
          Component = deEnd
          DataType = ftDateTime
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
          Name = 'isDetail'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLoss'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1093#1086#1076#1072' ('#1080#1090#1086#1075#1080')'
      ReportNameParam.Value = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1093#1086#1076#1072' ('#1080#1090#1086#1075#1080')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actReport_TaxLoss: TdsdPrintAction [44]
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'isDetail'
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'isDetail'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isDetail'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spReport_TaxLoss
      StoredProcList = <
        item
          StoredProc = spReport_TaxLoss
        end>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1080#1093#1086#1076' '#1085#1072' '#1089#1082#1083#1072#1076' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1087#1086#1090#1077#1088#1100' ('#1080#1090#1086#1075#1080')>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1088#1080#1093#1086#1076' '#1085#1072' '#1089#1082#1083#1072#1076' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1087#1086#1090#1077#1088#1100' ('#1080#1090#1086#1075#1080')>'
      ImageIndex = 19
      DataSets = <
        item
          DataSet = PrintMasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41791d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41791d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToId'
          Value = Null
          Component = FormParams
          ComponentItem = 'ToId_baza'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ToName_baza'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDetail'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1080#1093#1086#1076' '#1085#1072' '#1089#1082#1083#1072#1076' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1087#1086#1090#1077#1088#1100' ('#1080#1090#1086#1075#1080')'
      ReportNameParam.Value = #1055#1088#1080#1093#1086#1076' '#1085#1072' '#1089#1082#1083#1072#1076' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1087#1086#1090#1077#1088#1100' ('#1080#1090#1086#1075#1080')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actReceiptChoice: TOpenChoiceForm [45]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actReceiptChoice'
      FormName = 'TReceipt_ObjectForm'
      FormNameParam.Value = 'TReceipt_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReceiptCode_user'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterReceiptId'
          Value = 0
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterGoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterGoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MasterGoodsKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUnComplete: TdsdChangeMovementStatus [49]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spMovementUnComplete
      StoredProcList = <
        item
          StoredProc = spMovementUnComplete
        end>
      Caption = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1056#1072#1089#1087#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 11
      Status = mtUncomplete
      DataSource = MasterDS
    end
    object actComplete: TdsdChangeMovementStatus [50]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spMovementComplete
      StoredProcList = <
        item
          StoredProc = spMovementComplete
        end>
      Caption = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1055#1088#1086#1074#1077#1089#1090#1080' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 12
      Status = mtComplete
      DataSource = MasterDS
    end
    object actSetErased: TdsdChangeMovementStatus [51]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spMovementSetErased
      StoredProcList = <
        item
          StoredProc = spMovementSetErased
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 13
      Status = mtDelete
      DataSource = MasterDS
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'Dialog'
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
          Value = 42156d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42156d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actGoodsKindCompleteChoiceChild: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actGoodsKindCompleteChoiceChild'
      FormName = 'TGoodsKind_ObjectForm'
      FormNameParam.Value = 'TGoodsKind_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsKindCompleteId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsKindCompleteName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserJuridicalBasis
      StoredProcList = <
        item
          StoredProc = spGet_UserJuridicalBasis
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actUpdate_OperDate: TdsdExecStoredProc
      Category = 'Update_OperDate'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Movement_OperDate
      StoredProcList = <
        item
          StoredProc = spUpdate_Movement_OperDate
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1090#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1090#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 67
    end
    object macUpdate_OperDate: TMultiAction
      Category = 'Update_OperDate'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_OperDate
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 67
    end
    object macUpdate_OperDateList: TMultiAction
      Category = 'Update_OperDate'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialog_operdate
        end
        item
          Action = macUpdate_OperDate
        end
        item
          Action = actRefresh
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 67
    end
    object actPrintDays1: TdsdPrintAction
      Category = 'PrintDays'
      MoveParams = <
        item
          FromParam.Name = 'isDetail'
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'isDetail'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isDetail'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spPrintDays1
      StoredProcList = <
        item
          StoredProc = spPrintDays1
        end>
      Caption = #1047#1072#1082#1083#1072#1076#1082#1072' '#1089#1099#1088#1100#1103' ('#1087#1086' '#1076#1085#1103#1084')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1047#1072#1082#1083#1072#1076#1082#1080' '#1089#1099#1088#1100#1103' ('#1087#1086' '#1076#1085#1103#1084')'
      ImageIndex = 17
      DataSets = <
        item
          DataSet = PrintMasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'OperDate;GoodsName;GoodsKind_group;GoodsName_child;GoodsKindName' +
            '_Complete'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42522d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42522d
          Component = deEnd
          DataType = ftDateTime
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
          Name = 'isDetail'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLoss'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isCalc'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1087#1086' '#1076#1085#1103#1084' '#1076#1083#1103' '#1089#1099#1088#1100#1103')'
      ReportNameParam.Value = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1087#1086' '#1076#1085#1103#1084' '#1076#1083#1103' '#1089#1099#1088#1100#1103')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintDays2: TdsdPrintAction
      Category = 'PrintDays'
      MoveParams = <
        item
          FromParam.Name = 'isDetail'
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'isDetail'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isDetail'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spPrintDays2
      StoredProcList = <
        item
          StoredProc = spPrintDays2
        end>
      Caption = #1047#1072#1082#1083#1072#1076#1082#1072' '#1089#1087#1077#1094#1080#1081' ('#1087#1086' '#1076#1085#1103#1084')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1047#1072#1082#1083#1072#1076#1082#1080' '#1089#1087#1077#1094#1080#1081' ('#1087#1086' '#1076#1085#1103#1084')'
      ImageIndex = 20
      DataSets = <
        item
          DataSet = PrintMasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'OperDate;GoodsName;GoodsKind_group;GoodsName_child;GoodsKindName' +
            '_Complete'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42522d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42522d
          Component = deEnd
          DataType = ftDateTime
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
          Name = 'isDetail'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLoss'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isCalc'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1087#1086' '#1076#1085#1103#1084' '#1076#1083#1103' '#1089#1099#1088#1100#1103')'
      ReportNameParam.Value = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1087#1086' '#1076#1085#1103#1084' '#1076#1083#1103' '#1089#1099#1088#1100#1103')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintDays4: TdsdPrintAction
      Category = 'PrintDays'
      MoveParams = <
        item
          FromParam.Name = 'isDetail'
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'isDetail'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isDetail'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spPrintDays4
      StoredProcList = <
        item
          StoredProc = spPrintDays4
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1055#1088#1086#1095#1077#1077' ('#1087#1086' '#1076#1085#1103#1084')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1055#1088#1086#1095#1077#1077' ('#1087#1086' '#1076#1085#1103#1084')'
      ImageIndex = 16
      DataSets = <
        item
          DataSet = PrintMasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'OperDate;GoodsName;GoodsKind_group;GoodsName_child;GoodsKindName' +
            '_Complete'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42522d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42522d
          Component = deEnd
          DataType = ftDateTime
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
          Name = 'isDetail'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLoss'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isCalc'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1087#1086' '#1076#1085#1103#1084' '#1076#1083#1103' '#1089#1099#1088#1100#1103')'
      ReportNameParam.Value = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1087#1086' '#1076#1085#1103#1084' '#1076#1083#1103' '#1089#1099#1088#1100#1103')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintDays3: TdsdPrintAction
      Category = 'PrintDays'
      MoveParams = <
        item
          FromParam.Name = 'isDetail'
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'isDetail'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isDetail'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spPrintDays3
      StoredProcList = <
        item
          StoredProc = spPrintDays3
        end>
      Caption = #1047#1072#1082#1083#1072#1076#1082#1072' '#1086#1073#1086#1083#1086#1095#1082#1080' ('#1087#1086' '#1076#1085#1103#1084')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1047#1072#1082#1083#1072#1076#1082#1080' '#1086#1073#1086#1083#1086#1095#1082#1080' ('#1087#1086' '#1076#1085#1103#1084')'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintMasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'OperDate;GoodsName;GoodsKind_group;GoodsName_child;GoodsKindName' +
            '_Complete'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42522d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42522d
          Component = deEnd
          DataType = ftDateTime
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
          Name = 'isDetail'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLoss'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isCalc'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1087#1086' '#1076#1085#1103#1084' '#1076#1083#1103' '#1089#1099#1088#1100#1103')'
      ReportNameParam.Value = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1087#1086' '#1076#1085#1103#1084' '#1076#1083#1103' '#1089#1099#1088#1100#1103')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintDays1_cuter: TdsdPrintAction
      Category = 'PrintDays'
      MoveParams = <
        item
          FromParam.Name = 'isDetail'
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'isDetail'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isDetail'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spPrintDays1_cuter
      StoredProcList = <
        item
          StoredProc = spPrintDays1_cuter
        end>
      Caption = #1047#1072#1082#1083#1072#1076#1082#1072' '#1076#1083#1103' '#1089#1099#1088#1100#1103' ('#1087#1086' '#1082#1091#1090#1090#1077#1088#1072#1084')'
      Hint = #1047#1072#1082#1083#1072#1076#1082#1072' '#1076#1083#1103' '#1089#1099#1088#1100#1103' ('#1087#1086' '#1082#1091#1090#1090#1077#1088#1072#1084')'
      ImageIndex = 17
      DataSets = <
        item
          DataSet = PrintMasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'OperDate;GoodsName;GoodsKind_group;GoodsName_child;GoodsKindName' +
            '_Complete'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42522d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42522d
          Component = deEnd
          DataType = ftDateTime
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
          Name = 'isDetail'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLoss'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isCalc'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1087#1086' '#1076#1085#1103#1084' '#1076#1083#1103' '#1089#1099#1088#1100#1103')'
      ReportNameParam.Value = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1087#1086' '#1076#1085#1103#1084' '#1076#1083#1103' '#1089#1099#1088#1100#1103')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintLak: TdsdPrintAction
      Category = 'PrintDays'
      MoveParams = <
        item
          FromParam.Name = 'isDetail'
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'isDetail'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isDetail'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spPrintLak
      StoredProcList = <
        item
          StoredProc = spPrintLak
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1051#1072#1082#1080#1088#1086#1074#1072#1085#1080#1077
      Hint = #1055#1077#1095#1072#1090#1100' '#1051#1072#1082#1080#1088#1086#1074#1072#1085#1080#1077
      ImageIndex = 18
      DataSets = <
        item
          DataSet = PrintMasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'OperDate;GoodsName;GoodsKindName_Complete;OperDate;OperDate_part' +
            'ion;InvNumber_partion'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42522d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42522d
          Component = deEnd
          DataType = ftDateTime
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
          Name = 'isDetail'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLoss'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isCalc'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1083#1072#1082#1080#1088#1086#1074#1072#1085#1080#1077
      ReportNameParam.Value = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1083#1072#1082#1080#1088#1086#1074#1072#1085#1080#1077
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actExecuteDialog_AmountForm: TExecuteDialog
      Category = 'AmountForm'
      MoveParams = <>
      Caption = 'actUpdate_InvnumberDialog'
      FormName = 'TAmountFormDialogForm'
      FormNameParam.Value = 'TAmountFormDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'AmountForm'
          Value = Null
          Component = FormParams
          ComponentItem = 'AmountForm'
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'AmountForm'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AmountForm'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actUpdate_AmountForm: TdsdUpdateDataSet
      Category = 'AmountForm'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_AmountForm
      StoredProcList = <
        item
          StoredProc = spUpdate_AmountForm
        end>
      Caption = 'actUpdate_Invnumber'
    end
    object mactUpdate_AmountForm: TMultiAction
      Category = 'AmountForm'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecuteDialog_AmountForm
        end
        item
          Action = actUpdate_AmountForm
        end
        item
        end>
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1086#1083'-'#1074#1086' '#1092#1086#1088#1084#1086#1074#1082#1072'?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1086#1083'-'#1074#1086' '#1092#1086#1088#1084#1086#1074#1082#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1050#1086#1083'-'#1074#1086' '#1092#1086#1088#1084#1086#1074#1082#1072
      ImageIndex = 43
    end
    object actPrint_ReportTaxExit: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPrint_TaxExitUpdate
      StoredProcList = <
        item
          StoredProc = spPrint_TaxExitUpdate
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1044#1077#1083#1080#1082#1072#1090#1077#1089#1099')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1044#1077#1083#1080#1082#1072#1090#1077#1089#1099')'
      ImageIndex = 3
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsCode;GoodsKindName_Complete;PartionGoods' +
            'Date'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42522d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42522d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
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
          Name = 'ToName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'_'#1058#1077#1093#1085#1086#1083#1086#1075'_new'
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'_'#1058#1077#1093#1085#1086#1083#1086#1075'_new'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintCEH_rep: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPrint_TaxExitUpdate
      StoredProcList = <
        item
          StoredProc = spPrint_TaxExitUpdate
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1094#1077#1093')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1094#1077#1093')'
      ImageIndex = 16
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsCode;GoodsKindName_Complete;PartionGoods' +
            'Date'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42522d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42522d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
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
          Name = 'ToName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PageNum'
          Value = '1'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1094#1077#1093')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1094#1077#1093')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintOUT_rep: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPrint_TaxExitUpdate
      StoredProcList = <
        item
          StoredProc = spPrint_TaxExitUpdate
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084
      ImageIndex = 18
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsCode;GoodsKindName_Complete;PartionGoods' +
            'Date'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42522d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42522d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
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
          Name = 'ToName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintTRM_rep: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPrint_TaxExitUpdate_term
      StoredProcList = <
        item
          StoredProc = spPrint_TaxExitUpdate_term
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1090#1077#1088#1084#1080#1095#1082#1072')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1090#1077#1088#1084#1080#1095#1082#1072')'
      ImageIndex = 17
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsCode;GoodsKindName_Complete;PartionGoods' +
            'Date'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42522d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42522d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
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
          Name = 'ToName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PageNum'
          Value = '1'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1090#1077#1088#1084#1080#1095#1082#1072')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1090#1077#1088#1084#1080#1095#1082#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actUpdate_AmountNext_out: TdsdUpdateDataSet
      Category = 'AmountNext_out'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MI_AmountNext_out
      StoredProcList = <
        item
          StoredProc = spUpdate_MI_AmountNext_out
        end>
      Caption = 'actUpdate_Invnumber'
    end
    object mactUpdate_AmountNext_out: TMultiAction
      Category = 'AmountNext_out'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_AmountNext_out
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1047#1072#1087#1086#1083#1085#1080#1090#1100' <'#1055#1077#1088#1077#1093#1086#1076#1103#1097#1080#1081' '#1055'/'#1060' ('#1088#1072#1089#1093#1086#1076')>?'
      Caption = #1047#1072#1087#1086#1083#1085#1080#1090#1100' <'#1055#1077#1088#1077#1093#1086#1076#1103#1097#1080#1081' '#1055'/'#1060' ('#1088#1072#1089#1093#1086#1076')>'
      Hint = #1047#1072#1087#1086#1083#1085#1080#1090#1100' <'#1055#1077#1088#1077#1093#1086#1076#1103#1097#1080#1081' '#1055'/'#1060' ('#1088#1072#1089#1093#1086#1076')>'
      ImageIndex = 80
    end
    object actPrintDays5: TdsdPrintAction
      Category = 'PrintDays'
      MoveParams = <
        item
          FromParam.Name = 'isDetail'
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'isDetail'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isDetail'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spPrintDays5
      StoredProcList = <
        item
          StoredProc = spPrintDays5
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1056#1072#1089#1093#1086#1076' '#1087#1086' '#1090#1086#1074#1072#1088#1091' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintMasterCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsName_child;OperDate;GoodsName;GoodsKind_group;GoodsKindName' +
            '_Complete'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42522d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42522d
          Component = deEnd
          DataType = ftDateTime
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
          Name = 'isDetail'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isLoss'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'isCalc'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1087#1086' '#1076#1085#1103#1084' '#1076#1083#1103' '#1089#1099#1088#1100#1103') '#1074' '#1089#1086#1089#1090#1072#1074#1077
      ReportNameParam.Value = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1087#1086' '#1076#1085#1103#1084' '#1076#1083#1103' '#1089#1099#1088#1100#1103') '#1074' '#1089#1086#1089#1090#1072#1074#1077
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_byGrid: TdsdExecStoredProc
      Category = 'Print_rep'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertPrint_byGrid
      StoredProcList = <
        item
          StoredProc = spInsertPrint_byGrid
        end>
      Caption = #1089#1086#1093#1088#1072#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1075#1088#1080#1076#1072' '#1076#1083#1103' '#1087#1077#1095#1072#1090#1080
      ImageIndex = 74
    end
    object actPrint_byGrid_list: TMultiAction
      Category = 'Print_rep'
      MoveParams = <>
      ActionList = <
        item
          Action = actPrint_byGrid
        end>
      View = cxGridDBTableView
      Caption = 'actPrint_byGrid_list'
      ImageIndex = 74
    end
    object actDelete_Object_Print: TdsdExecStoredProc
      Category = 'Print_rep'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDelete_Object_Print
      StoredProcList = <
        item
          StoredProc = spDelete_Object_Print
        end>
      Caption = #1091#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1075#1088#1080#1076#1072' '#1076#1083#1103' '#1087#1077#1095#1072#1090#1080
      ImageIndex = 74
    end
    object actPrint_ReportTaxExit_grid: TdsdPrintAction
      Category = 'Print_rep'
      MoveParams = <>
      StoredProc = spPrint_TaxExitUpdate_grid
      StoredProcList = <
        item
          StoredProc = spPrint_TaxExitUpdate_grid
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1080#1079' '#1075#1088#1080#1076#1072' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1044#1077#1083#1080#1082#1072#1090#1077#1089#1099')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1080#1079' '#1075#1088#1080#1076#1072' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1044#1077#1083#1080#1082#1072#1090#1077#1089#1099')'
      ImageIndex = 3
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsCode;GoodsKindName_Complete;PartionGoods' +
            'Date'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42522d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42522d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
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
          Name = 'ToName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'_'#1058#1077#1093#1085#1086#1083#1086#1075'_new'
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'_'#1058#1077#1093#1085#1086#1083#1086#1075'_new'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object macPrint_ReportTaxExit_grid: TMultiAction
      Category = 'Print_rep'
      MoveParams = <>
      ActionList = <
        item
          Action = actDelete_Object_Print
        end
        item
          Action = actPrint_byGrid_list
        end
        item
          Action = actPrint_ReportTaxExit_grid
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1074#1099#1073#1086#1088#1086#1095#1085#1086' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1044#1077#1083#1080#1082#1072#1090#1077#1089#1099')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1074#1099#1073#1086#1088#1086#1095#1085#1086' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1044#1077#1083#1080#1082#1072#1090#1077#1089#1099')'
      ImageIndex = 3
    end
    object actPrintCEH_rep_grid: TdsdPrintAction
      Category = 'Print_rep'
      MoveParams = <>
      StoredProc = spPrint_TaxExitUpdate_grid
      StoredProcList = <
        item
          StoredProc = spPrint_TaxExitUpdate_grid
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1094#1077#1093')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1094#1077#1093')'
      ImageIndex = 3
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsCode;GoodsKindName_Complete;PartionGoods' +
            'Date'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42522d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42522d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
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
          Name = 'ToName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1094#1077#1093')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1094#1077#1093')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintOUT_rep_grid: TdsdPrintAction
      Category = 'Print_rep'
      MoveParams = <>
      StoredProc = spPrint_TaxExitUpdate_grid
      StoredProcList = <
        item
          StoredProc = spPrint_TaxExitUpdate_grid
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084
      ImageIndex = 18
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsCode;GoodsKindName_Complete;PartionGoods' +
            'Date'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42522d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42522d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
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
          Name = 'ToName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintTRM_rep_grid: TdsdPrintAction
      Category = 'Print_rep'
      MoveParams = <>
      StoredProc = spPrint_TaxExitUpdate_grid_term
      StoredProcList = <
        item
          StoredProc = spPrint_TaxExitUpdate_grid_term
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1090#1077#1088#1084#1080#1095#1082#1072')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1090#1077#1088#1084#1080#1095#1082#1072')'
      ImageIndex = 3
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsCode;GoodsKindName_Complete;PartionGoods' +
            'Date'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42522d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42522d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
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
          Name = 'ToName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1090#1077#1088#1084#1080#1095#1082#1072')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1090#1077#1088#1084#1080#1095#1082#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object macPrintOUT_rep_grid: TMultiAction
      Category = 'Print_rep'
      MoveParams = <>
      ActionList = <
        item
          Action = actDelete_Object_Print
        end
        item
          Action = actPrint_byGrid_list
        end
        item
          Action = actPrintOUT_rep_grid
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1074#1099#1073#1086#1088#1086#1095#1085#1086' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084
      Hint = #1055#1077#1095#1072#1090#1100' '#1074#1099#1073#1086#1088#1086#1095#1085#1086' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084
      ImageIndex = 3
    end
    object macPrintTRM_rep_grid: TMultiAction
      Category = 'Print_rep'
      MoveParams = <>
      ActionList = <
        item
          Action = actDelete_Object_Print
        end
        item
          Action = actPrint_byGrid_list
        end
        item
          Action = actPrintTRM_rep_grid
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1074#1099#1073#1086#1088#1086#1095#1085#1086' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1090#1077#1088#1084#1080#1095#1082#1072')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1074#1099#1073#1086#1088#1086#1095#1085#1086' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1090#1077#1088#1084#1080#1095#1082#1072')'
      ImageIndex = 3
    end
    object macPrintCEH_rep_grid: TMultiAction
      Category = 'Print_rep'
      MoveParams = <>
      ActionList = <
        item
          Action = actDelete_Object_Print
        end
        item
          Action = actPrint_byGrid_list
        end
        item
          Action = actPrintCEH_rep_grid
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1074#1099#1073#1086#1088#1086#1095#1085#1086' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1094#1077#1093')'
      Hint = #1055#1077#1095#1072#1090#1100' '#1074#1099#1073#1086#1088#1086#1095#1085#1086' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1094#1077#1093')'
      ImageIndex = 3
    end
    object actPrintTRM_Group: TdsdPrintAction
      Category = 'Print_rep'
      MoveParams = <>
      StoredProc = spPrint_TaxExitUpdate_groupTRM
      StoredProcList = <
        item
          StoredProc = spPrint_TaxExitUpdate_groupTRM
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1090#1077#1088#1084#1080#1095#1082#1072') '#1075#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1090#1077#1088#1084#1080#1095#1082#1072') '#1075#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072
      ImageIndex = 3
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsCode;GoodsKindName_Complete;PartionGoods' +
            'Date'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42522d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42522d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
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
          Name = 'ToName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PageNum'
          Value = '2'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1090#1077#1088#1084#1080#1095#1082#1072')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1090#1077#1088#1084#1080#1095#1082#1072')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintCEH_Group: TdsdPrintAction
      Category = 'Print_rep'
      MoveParams = <>
      StoredProc = spPrint_TaxExitUpdate_groupCeh
      StoredProcList = <
        item
          StoredProc = spPrint_TaxExitUpdate_groupCeh
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1094#1077#1093') '#1075#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1093#1086#1076#1072#1084' ('#1094#1077#1093') '#1075#1088#1091#1087#1087#1080#1088#1086#1074#1082#1072
      ImageIndex = 3
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 
            'GoodsGroupNameFull;GoodsCode;GoodsKindName_Complete;PartionGoods' +
            'Date'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42522d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42522d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
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
          Name = 'ToName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PageNum'
          Value = '2'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1094#1077#1093')'
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1087#1086'_'#1074#1099#1093#1086#1076#1072#1084'('#1094#1077#1093')'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object macUpdate_isWeightMain: TMultiAction
      Category = 'Child'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_isWeightMain
        end>
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' <'#1042#1093#1086#1076#1080#1090' '#1074' '#1086#1089#1085'. '#1089#1099#1088#1100#1077' (100 '#1082#1075'.)>?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1042#1093#1086#1076#1080#1090' '#1074' '#1086#1089#1085'. '#1089#1099#1088#1100#1077' (100 '#1082#1075'.)> '#1044#1072'/'#1053#1077#1090
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1042#1093#1086#1076#1080#1090' '#1074' '#1086#1089#1085'. '#1089#1099#1088#1100#1077' (100 '#1082#1075'.)> '#1044#1072'/'#1053#1077#1090
      ImageIndex = 76
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionUnionTech'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41791d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41791d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = False
        Component = GuidesTo
        ComponentItem = 'Key'
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
        Name = 'inisLak'
        Value = Null
        Component = cbisLak
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInputOutput
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
          ItemName = 'bbComplete'
        end
        item
          Visible = True
          ItemName = 'bbUnComplete'
        end
        item
          Visible = True
          ItemName = 'bbSetErased'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddChild'
        end
        item
          Visible = True
          ItemName = 'bbErasedChild'
        end
        item
          Visible = True
          ItemName = 'bbUnErasedChild'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_OperDateList'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_AmountForm'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_AmountNext_out'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isWeightMain'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
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
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbsProtocol'
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
      ShowCaption = False
    end
    object bbEdit: TdxBarButton [18]
      Action = actUpdate
      Category = 0
    end
    object bbInsert: TdxBarButton [19]
      Action = actInsert
      Category = 0
    end
    object bbPrintReceipt: TdxBarButton [20]
      Action = actPrintReceipt
      Category = 0
    end
    object bbReport_TaxLoss: TdxBarButton [21]
      Action = actReport_TaxLoss
      Category = 0
    end
    object bbReport_TaxExit_Loss: TdxBarButton [22]
      Action = actReport_TaxExit_Loss
      Category = 0
    end
    object bbComplete: TdxBarButton [23]
      Action = actComplete
      Category = 0
    end
    object bbUnComplete: TdxBarButton [24]
      Action = actUnComplete
      Category = 0
    end
    object bbSetErased: TdxBarButton [25]
      Action = actSetErased
      Category = 0
    end
    object bbMovementProtocol: TdxBarButton [26]
      Action = MovementProtocolOpenForm
      Category = 0
    end
    object bbPrintCeh: TdxBarButton
      Action = actPrintCeh
      Category = 0
    end
    object bbUpdate_OperDateList: TdxBarButton
      Action = macUpdate_OperDateList
      Category = 0
    end
    object bbPrintDays1: TdxBarButton
      Action = actPrintDays1
      Category = 0
    end
    object bbactPrintDays2: TdxBarButton
      Action = actPrintDays2
      Category = 0
    end
    object bbactPrintDays3: TdxBarButton
      Action = actPrintDays3
      Category = 0
    end
    object bbactPrintDays4: TdxBarButton
      Action = actPrintDays4
      Category = 0
    end
    object bbPrintDays1_test: TdxBarButton
      Action = actPrintDays1_cuter
      Category = 0
    end
    object bbPrintDays2_cuter: TdxBarButton
      Action = actPrintDays2_cuter
      Category = 0
    end
    object bbactPrintLak: TdxBarButton
      Action = actPrintLak
      Category = 0
    end
    object bbUpdate_AmountForm: TdxBarButton
      Action = mactUpdate_AmountForm
      Category = 0
    end
    object bbsPrint: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 3
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrintReceipt'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator2'
        end
        item
          Visible = True
          ItemName = 'bbReport_TaxExit_Loss'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator2'
        end
        item
          Visible = True
          ItemName = 'bbReport_TaxLoss'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator2'
        end
        item
          Visible = True
          ItemName = 'bbPrintCeh'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator2'
        end
        item
          Visible = True
          ItemName = 'bbPrintDays1'
        end
        item
          Visible = True
          ItemName = 'bbactPrintDays2'
        end
        item
          Visible = True
          ItemName = 'bbactPrintDays3'
        end
        item
          Visible = True
          ItemName = 'bbactPrintDays4'
        end
        item
          Visible = True
          ItemName = 'bbPrintDays5'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator2'
        end
        item
          Visible = True
          ItemName = 'bbPrintDays1_test'
        end
        item
          Visible = True
          ItemName = 'bbPrintDays2_cuter'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator2'
        end
        item
          Visible = True
          ItemName = 'bbactPrintLak'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator2'
        end
        item
          Visible = True
          ItemName = 'bbPrint_ReportTaxExit'
        end
        item
          Visible = True
          ItemName = 'bbPrintCEH_rep'
        end
        item
          Visible = True
          ItemName = 'bbPrintTRM_rep'
        end
        item
          Visible = True
          ItemName = 'bbPrintOUT_rep'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator2'
        end
        item
          Visible = True
          ItemName = 'bbPrintCEH_Group'
        end
        item
          Visible = True
          ItemName = 'bbPrintTRM_Group'
        end
        item
          Visible = True
          ItemName = 'dxBarSeparator2'
        end
        item
          Visible = True
          ItemName = 'bbPrint_ReportTaxExit_grid'
        end
        item
          Visible = True
          ItemName = 'bbPrintCEH_rep_grid'
        end
        item
          Visible = True
          ItemName = 'bbPrintTRM_rep_grid'
        end
        item
          Visible = True
          ItemName = 'bbPrintOUT_rep_grid'
        end>
    end
    object bbsProtocol: TdxBarSubItem
      Caption = #1055#1088#1086#1090#1086#1082#1086#1083
      Category = 0
      Visible = ivAlways
      ImageIndex = 34
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbMovementProtocol'
        end
        item
          Visible = True
          ItemName = 'bbMIChildProtocol'
        end
        item
          Visible = True
          ItemName = 'bbMIMasterProtocol'
        end>
    end
    object dxBarSeparator2: TdxBarSeparator
      Caption = 'Separator'
      Category = 0
      Hint = 'Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbPrint_ReportTaxExit: TdxBarButton
      Action = actPrint_ReportTaxExit
      Category = 0
    end
    object bbPrintCEH_rep: TdxBarButton
      Action = actPrintCEH_rep
      Category = 0
    end
    object bbPrintTRM_rep: TdxBarButton
      Action = actPrintTRM_rep
      Category = 0
    end
    object bbPrintOUT_rep: TdxBarButton
      Action = actPrintOUT_rep
      Category = 0
    end
    object bbUpdate_AmountNext_out: TdxBarButton
      Action = mactUpdate_AmountNext_out
      Category = 0
    end
    object bbPrintDays5: TdxBarButton
      Action = actPrintDays5
      Category = 0
    end
    object bbPrint_ReportTaxExit_grid: TdxBarButton
      Action = macPrint_ReportTaxExit_grid
      Category = 0
    end
    object bbPrintCEH_rep_grid: TdxBarButton
      Action = macPrintCEH_rep_grid
      Category = 0
    end
    object bbPrintOUT_rep_grid: TdxBarButton
      Action = macPrintOUT_rep_grid
      Category = 0
    end
    object bbPrintTRM_rep_grid: TdxBarButton
      Action = macPrintTRM_rep_grid
      Category = 0
    end
    object bbPrintTRM_Group: TdxBarButton
      Action = actPrintTRM_Group
      Category = 0
      ImageIndex = 17
    end
    object bbPrintCEH_Group: TdxBarButton
      Action = actPrintCEH_Group
      Category = 0
      ImageIndex = 16
    end
    object bbUpdate_isWeightMain: TdxBarButton
      Action = macUpdate_isWeightMain
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actUpdate
      end>
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
    Top = 144
    object N7: TMenuItem [0]
      Action = actInsert
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
    end
    object N8: TMenuItem [1]
      Action = actUpdate
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
    end
    object N9: TMenuItem [2]
      Caption = '-'
    end
    inherited N6: TMenuItem [3]
      Action = actComplete
      Enabled = False
    end
    inherited N5: TMenuItem [4]
      Action = actUnComplete
      Enabled = False
    end
    object N11: TMenuItem [5]
      Action = actSetErased
    end
    object N12: TMenuItem [6]
      Caption = '-'
    end
    object N13: TMenuItem [7]
      Action = actReCompleteList
    end
    object N14: TMenuItem [8]
      Action = actCompleteList
    end
    object N15: TMenuItem [9]
      Action = actUnCompleteList
    end
    object N16: TMenuItem [10]
      Action = actSetErasedList
    end
    object N10: TMenuItem [11]
      Caption = '-'
    end
    inherited N1: TMenuItem [12]
    end
    inherited Excel1: TMenuItem [13]
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
        Name = 'TotalSumm'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MIOrderId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId_baza'
        Value = 8458
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName_baza'
        Value = #1057#1082#1083#1072#1076' '#1041#1072#1079#1072' '#1043#1055
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'isDetail'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
  inherited StatusGuides: TdsdGuides
    Left = 1152
    Top = 16
  end
  inherited spChangeStatus: TdsdStoredProc
    Left = 1032
    Top = 8
  end
  inherited spGet: TdsdStoredProc
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
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 42086d
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
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 288
    Top = 168
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    Left = 442
    Top = 136
  end
  inherited GuidesFiller: TGuidesFiller
    ActionItemList = <
      item
        Action = actRefresh
      end>
  end
  inherited HeaderSaver: THeaderSaver
    Left = 328
    Top = 137
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = ''
    Left = 614
    Top = 496
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = ''
    Left = 574
    Top = 536
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_ProductionUnionTech_Master'
    Params = <
      item
        Name = 'inMovementItemId_order'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId_order'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReceiptId'
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
        Name = 'inCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Count'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRealWeight'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RealWeight'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 376
    Top = 256
  end
  inherited ChildCDS: TClientDataSet
    MasterFields = 'MovementItemId'
    Left = 72
    Top = 561
  end
  inherited ChildDS: TDataSource
    Left = 164
    Top = 530
  end
  inherited spErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnionTech_SetErased'
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmount_master'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
  inherited spUnErasedMIChild: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ProductionUnionTech_SetUnErased'
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmount_master'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
  inherited GuidesTo: TdsdGuides
    PositionDataSet = 'MasterCDS'
    Left = 672
    Top = 65528
  end
  inherited GuidesFrom: TdsdGuides
    PositionDataSet = 'MasterCDS'
    Left = 448
    Top = 65528
  end
  inherited spInsertUpdateMIChild: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_ProductionUnionTech_Child'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmountReceipt'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountReceipt'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmount_master'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountWeight'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountWeight'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountReceiptWeight'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountReceiptWeight'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsWeightMain'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isWeightMain'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsTaxExit'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isTaxExit'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGroupNumber'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GroupNumber'
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsDate'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'PartionGoodsDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindCompleteId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsKindCompleteId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 576
  end
  inherited ChildDBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ColorColumn = colChildGroupNumber
        ValueColumn = colChildColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = colChildGoodsCode
        ValueColumn = colChildColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = colChildGoodsName
        ValueColumn = colChildColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = colChildMeasureName
        ValueColumn = colChildColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = colChildAmountReceipt
        ValueColumn = colChildColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = colChildAmount
        ValueColumn = colChildColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = colChildAmountCalc
        ValueColumn = colChildColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = colChildAmountWeight
        ValueColumn = colChildColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = colChildAmountCalcWeight
        ValueColumn = colChildColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = isTaxExit
        ValueColumn = colChildColor_calc
        ColorValueList = <>
      end>
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesFrom
      end
      item
        Component = GuidesTo
      end
      item
        Component = JuridicalBasisGuides
      end>
    Left = 288
    Top = 232
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 176
    Top = 56
  end
  object PrintMasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 708
    Top = 233
  end
  object spReport_TaxExit: TdsdStoredProc
    StoredProcName = 'gpReport_GoodsMI_ProductionUnion_TaxExit'
    DataSet = PrintMasterCDS
    DataSets = <
      item
        DataSet = PrintMasterCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41791d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41791d
        Component = deEnd
        DataType = ftDateTime
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
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDetail'
        Value = False
        Component = FormParams
        ComponentItem = 'isDetail'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 264
  end
  object spPrintReceipt: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Receipt_Print'
    DataSet = PrintMasterCDS
    DataSets = <
      item
        DataSet = PrintMasterCDS
      end>
    Params = <
      item
        Name = 'inReceiptId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = 41791d
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 424
    Top = 185
  end
  object spReport_TaxLoss: TdsdStoredProc
    StoredProcName = 'gpReport_GoodsMI_ProductionUnion_TaxLoss'
    DataSet = PrintMasterCDS
    DataSets = <
      item
        DataSet = PrintMasterCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41791d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41791d
        Component = deEnd
        DataType = ftDateTime
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
        Value = Null
        Component = FormParams
        ComponentItem = 'ToId_baza'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDetail'
        Value = False
        Component = FormParams
        ComponentItem = 'isDetail'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 528
    Top = 304
  end
  object spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_ProductionUnion'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 48
    Top = 288
  end
  object spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_ProductionUnion'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 80
    Top = 272
  end
  object spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_ProductionUnion'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsLastComplete'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 151
    Top = 299
  end
  object spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_ProductionUnion'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 912
    Top = 144
  end
  object spSelectPrintCeh: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionUnion_Ceh_Print'
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
        ComponentItem = 'MovementId'
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
        Name = 'inIsAll'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 551
    Top = 144
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
    Left = 824
    Top = 48
  end
  object spUpdate_Movement_OperDate: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_ProductionUnionTech_OperDate'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'InvNumber'
        DataType = ftString
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
      end>
    PackSize = 1
    Left = 952
    Top = 211
  end
  object spPrintDays1: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionUnionTech_Print'
    DataSet = PrintMasterCDS
    DataSets = <
      item
        DataSet = PrintMasterCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 43831d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 43831d
        Component = deEnd
        DataType = ftDateTime
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
        Name = 'inGoodsId_child'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGroupNum'
        Value = '1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCuterCount'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 272
    Top = 416
  end
  object spPrintDays2: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionUnionTech_Print'
    DataSet = PrintMasterCDS
    DataSets = <
      item
        DataSet = PrintMasterCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 43831d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 43831d
        Component = deEnd
        DataType = ftDateTime
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
        Name = 'inGoodsId_child'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGroupNum'
        Value = '2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCuterCount'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 336
    Top = 416
  end
  object spPrintDays3: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionUnionTech_Print'
    DataSet = PrintMasterCDS
    DataSets = <
      item
        DataSet = PrintMasterCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 43831d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 43831d
        Component = deEnd
        DataType = ftDateTime
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
        Name = 'inGoodsId_child'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGroupNum'
        Value = '3'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCuterCount'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 376
    Top = 416
  end
  object spPrintDays4: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionUnionTech_Print'
    DataSet = PrintMasterCDS
    DataSets = <
      item
        DataSet = PrintMasterCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 43831d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 43831d
        Component = deEnd
        DataType = ftDateTime
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
        Name = 'inGoodsId_child'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGroupNum'
        Value = '4'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCuterCount'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 416
    Top = 416
  end
  object spPrintDays1_cuter: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionUnionTech_Print'
    DataSet = PrintMasterCDS
    DataSets = <
      item
        DataSet = PrintMasterCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 42522d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42522d
        Component = deEnd
        DataType = ftDateTime
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
        Name = 'inGroupNum'
        Value = '1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCuterCount'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 272
    Top = 464
  end
  object spPrintLak: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionUnionLak_Print'
    DataSet = PrintMasterCDS
    DataSets = <
      item
        DataSet = PrintMasterCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 43831d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 43831d
        Component = deEnd
        DataType = ftDateTime
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
      end>
    PackSize = 1
    Left = 920
    Top = 440
  end
  object spUpdate_AmountForm: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_ProductionUnion_AmountForm'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountForm'
        Value = Null
        Component = FormParams
        ComponentItem = 'AmountForm'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 952
    Top = 507
  end
  object spPrint_TaxExitUpdate: TdsdStoredProc
    StoredProcName = 'gpReport_ProductionUnion_TaxExitUpdate'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 43831d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 43831d
        Component = deEnd
        DataType = ftDateTime
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
        Name = 'inParam'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisList'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsListReport'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartion'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTerm'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1112
    Top = 465
  end
  object spUpdate_MI_AmountNext_out: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_ProductionUnion_AmountNext_out'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 49
    Top = 424
  end
  object spPrintDays5: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionUnionTech_Print'
    DataSet = PrintMasterCDS
    DataSets = <
      item
        DataSet = PrintMasterCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 43831d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 43831d
        Component = deEnd
        DataType = ftDateTime
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
        Name = 'inGoodsId_child'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGroupNum'
        Value = '4'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCuterCount'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 376
    Top = 464
  end
  object spInsertPrint_byGrid: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_Print_byGrid'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
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
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoodsDate'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoodsDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1000
    Top = 555
  end
  object spDelete_Object_Print: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_Print_byUser'
    DataSets = <>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 1080
    Top = 555
  end
  object spPrint_TaxExitUpdate_grid: TdsdStoredProc
    StoredProcName = 'gpReport_ProductionUnion_TaxExitUpdate'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 43831d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 43831d
        Component = deEnd
        DataType = ftDateTime
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
        Name = 'inParam'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisList'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsListReport'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartion'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTerm'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1008
    Top = 401
  end
  object spPrint_TaxExitUpdate_groupTRM: TdsdStoredProc
    StoredProcName = 'gpReport_ProductionUnion_TaxExitUpdate'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 43831d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 43831d
        Component = deEnd
        DataType = ftDateTime
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
        Name = 'isParam'
        Value = '2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisList'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsListReport'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartion'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTerm'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 784
    Top = 497
  end
  object spPrint_TaxExitUpdate_groupCeh: TdsdStoredProc
    StoredProcName = 'gpReport_ProductionUnion_TaxExitUpdate'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 43831d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 43831d
        Component = deEnd
        DataType = ftDateTime
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
        Name = 'isParam'
        Value = '1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisList'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsListReport'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartion'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTerm'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 784
    Top = 545
  end
  object spPrint_TaxExitUpdate_term: TdsdStoredProc
    StoredProcName = 'gpReport_ProductionUnion_TaxExitUpdate'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 42522d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42522d
        Component = deEnd
        DataType = ftDateTime
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
        Name = 'inParam'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisList'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsListReport'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartion'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTerm'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1136
    Top = 433
  end
  object spPrint_TaxExitUpdate_grid_term: TdsdStoredProc
    StoredProcName = 'gpReport_ProductionUnion_TaxExitUpdate'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 42522d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42522d
        Component = deEnd
        DataType = ftDateTime
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
        Name = 'inParam'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisList'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsListReport'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartion'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsTerm'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1008
    Top = 433
  end
  object spUpdate_isWeightMain: TdsdStoredProc
    StoredProcName = 'gpUpdate_MI_ProductionUnion_isWeightMain'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisWeightMain'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isWeightMain'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 664
    Top = 587
  end
end
