inherited ProductionUnionTechJournalForm: TProductionUnionTechJournalForm
  Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1058#1077#1093#1085#1086#1083#1086#1075
  ClientHeight = 685
  ClientWidth = 1020
  ExplicitWidth = 1036
  ExplicitHeight = 720
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 61
    Width = 1020
    Height = 624
    TabOrder = 2
    ExplicitTop = 61
    ExplicitWidth = 1020
    ExplicitHeight = 624
    ClientRectBottom = 624
    ClientRectRight = 1020
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1020
      ExplicitHeight = 600
      inherited cxGrid: TcxGrid
        Width = 1020
        Height = 292
        ExplicitWidth = 1020
        ExplicitHeight = 292
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colRealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colCuterCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount_order
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colCuterCount_order
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount_calc
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colRealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colCuterCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount_order
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colCuterCount_order
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount_calc
            end>
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
          object colStatus: TcxGridDBColumn [1]
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
            Width = 55
          end
          object colInvNumber: TcxGridDBColumn [2]
            Caption = #8470' '#1044#1086#1082
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colOperDate: TcxGridDBColumn [3]
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colMeasureName: TcxGridDBColumn [6]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colGoodsKindName: TcxGridDBColumn [7]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colGoodsKindName_Complete: TcxGridDBColumn [8]
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
          object colCuterCount: TcxGridDBColumn [9]
            Caption = #1050#1091#1090#1077#1088#1086#1074' '#1092#1072#1082#1090
            DataBinding.FieldName = 'CuterCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colAmount: TcxGridDBColumn [10]
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
          object colAmount_calc: TcxGridDBColumn [11]
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
          object colRealWeight: TcxGridDBColumn [12]
            Caption = #1042#1077#1089' '#1087'/'#1092' '#1092#1072#1082#1090
            DataBinding.FieldName = 'RealWeight'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colCount: TcxGridDBColumn [13]
            Caption = #1050#1086#1083'-'#1074#1086' '#1073#1072#1090#1086#1085#1086#1074
            DataBinding.FieldName = 'Count'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colAmount_order: TcxGridDBColumn [14]
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
          object colCuterCount_order: TcxGridDBColumn [15]
            Caption = #1050#1091#1090#1077#1088#1086#1074' '#1079#1072#1103#1074#1082#1072
            DataBinding.FieldName = 'CuterCount_order'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colIsMain: TcxGridDBColumn [16]
            Caption = #1043#1083#1072#1074#1085'.'
            DataBinding.FieldName = 'isMain'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object colReceiptCode: TcxGridDBColumn [17]
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
          object colReceiptName: TcxGridDBColumn [18]
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
          object colPartionClose: TcxGridDBColumn [19]
            Caption = #1055#1072#1088#1090#1080#1103' '#1079#1072#1082#1088#1099#1090#1072' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'PartionClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colPartionGoods: TcxGridDBColumn [20]
            Caption = #1055#1072#1088#1090#1080#1103' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'PartionGoods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object colComment_receipt: TcxGridDBColumn [21]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1088#1077#1094#1077#1087#1090#1091#1088#1072')'
            DataBinding.FieldName = 'Comment_receipt'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object colComment: TcxGridDBColumn [22]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' ('#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object colInsertName: TcxGridDBColumn [23]
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object colUpdateName: TcxGridDBColumn [24]
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
            DataBinding.FieldName = 'UpdateName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object colInsertDate: TcxGridDBColumn [25]
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
            DataBinding.FieldName = 'InsertDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object colUpdateDate: TcxGridDBColumn [26]
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
      inherited cxGridChild: TcxGrid
        Top = 297
        Width = 1020
        ExplicitTop = 297
        ExplicitWidth = 1020
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
          object colChildAmountReceipt: TcxGridDBColumn [5]
            Caption = #1050#1086#1083'-'#1074#1086' 1 '#1082#1091#1090#1077#1088
            DataBinding.FieldName = 'AmountReceipt'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colChildAmount: TcxGridDBColumn [6]
            Caption = #1050#1086#1083'-'#1074#1086' '#1092#1072#1082#1090
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colChildAmountCalc: TcxGridDBColumn [7]
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
          object colChildAmountReceiptWeight: TcxGridDBColumn [8]
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
          object colChildAmountWeight: TcxGridDBColumn [9]
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
          object colChildAmountCalcWeight: TcxGridDBColumn [10]
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
          object isTaxExit: TcxGridDBColumn [11]
            Caption = #1047#1072#1074#1080#1089#1080#1090' '#1086#1090' % '#1074#1099#1093'.'
            DataBinding.FieldName = 'isTaxExit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isWeightMain: TcxGridDBColumn [12]
            Caption = #1042#1093#1086#1076#1080#1090' '#1074' '#1086#1089#1085'. '#1089#1099#1088#1100#1077' (100 '#1082#1075'.)'
            DataBinding.FieldName = 'isWeightMain'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colChildPartionGoodsDate: TcxGridDBColumn [13]
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
          object colChildPartionGoods: TcxGridDBColumn [14]
            Caption = #1055#1072#1088#1090#1080#1103' '#1089#1099#1088#1100#1103
            DataBinding.FieldName = 'PartionGoods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object colChildComment: TcxGridDBColumn [15]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object colChildInsertName: TcxGridDBColumn [16]
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object colChildUpdateName: TcxGridDBColumn [17]
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
            DataBinding.FieldName = 'UpdateName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object colChildInsertDate: TcxGridDBColumn [18]
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
            DataBinding.FieldName = 'InsertDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object colChildUpdateDate: TcxGridDBColumn [19]
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object colChildColor_calc: TcxGridDBColumn [20]
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
        Width = 1020
        ExplicitTop = 292
        ExplicitWidth = 1020
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1020
    Height = 35
    ExplicitWidth = 1020
    ExplicitHeight = 35
    inherited edInvNumber: TcxTextEdit
      Left = 835
      Top = 7
      Visible = False
      ExplicitLeft = 835
      ExplicitTop = 7
      ExplicitWidth = 75
      Width = 75
    end
    inherited cxLabel1: TcxLabel
      Left = 835
      Top = -2
      Visible = False
      ExplicitLeft = 835
      ExplicitTop = -2
    end
    inherited edOperDate: TcxDateEdit
      Left = 916
      Top = 7
      Visible = False
      ExplicitLeft = 916
      ExplicitTop = 7
      ExplicitWidth = 61
      Width = 61
    end
    inherited cxLabel2: TcxLabel
      Left = 916
      Top = -2
      Visible = False
      ExplicitLeft = 916
      ExplicitTop = -2
    end
    inherited cxLabel15: TcxLabel
      Left = 983
      Top = -2
      Visible = False
      ExplicitLeft = 983
      ExplicitTop = -2
    end
    inherited ceStatus: TcxButtonEdit
      Left = 983
      Top = 17
      Visible = False
      ExplicitLeft = 983
      ExplicitTop = 17
      ExplicitWidth = 100
      ExplicitHeight = 22
      Width = 100
    end
    inherited cxLabel3: TcxLabel
      Left = 315
      Top = 8
      Caption = #1054#1090' '#1082#1086#1075#1086' :'
      ExplicitLeft = 315
      ExplicitTop = 8
      ExplicitWidth = 51
    end
    inherited cxLabel4: TcxLabel
      Left = 590
      Top = 8
      Caption = #1050#1086#1084#1091' :'
      ExplicitLeft = 590
      ExplicitTop = 8
      ExplicitWidth = 36
    end
    inherited edFrom: TcxButtonEdit
      Left = 366
      Top = 7
      ExplicitLeft = 366
      ExplicitTop = 7
      ExplicitWidth = 200
      Width = 200
    end
    inherited edTo: TcxButtonEdit
      Left = 628
      Top = 7
      ExplicitLeft = 628
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
      Left = 52
      Top = 7
      EditValue = 42156d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 11
      Width = 85
    end
    object cxLabel6: TcxLabel
      Left = 150
      Top = 8
      Caption = #1044#1072#1090#1072' '#1087#1086' :'
    end
    object deEnd: TcxDateEdit
      Left = 204
      Top = 7
      EditValue = 42156d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 13
      Width = 85
    end
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
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      RefreshOnTabSetChanges = True
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
    inherited actPrint: TdsdPrintAction
      MoveParams = <
        item
          FromParam.Name = 'isDetail'
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          ToParam.Name = 'isDetail'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isDetail'
          ToParam.DataType = ftBoolean
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
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'FromId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
        end
        item
          Name = 'FromName'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
        end
        item
          Name = 'ToId'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'Key'
        end
        item
          Name = 'ToName'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
        end
        item
          Name = 'isDetail'
          Value = False
          DataType = ftBoolean
        end
        item
          Name = 'isLoss'
          Value = False
          DataType = ftBoolean
        end>
      ReportName = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1093#1086#1076#1072' ('#1080#1090#1086#1075#1080')'
      ReportNameParam.Value = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1093#1086#1076#1072' ('#1080#1090#1086#1075#1080')'
    end
    object actUpdateChildDS: TdsdUpdateDataSet [9]
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
    object actGoodsKindChoiceChild: TOpenChoiceForm [18]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsKindId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ChildCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object actGoodsKindChoiceMaster: TOpenChoiceForm [19]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindCompleteId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindCompleteName'
          DataType = ftString
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
        end>
    end
    object MovementProtocolOpenForm: TdsdOpenForm [21]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementProtocolForm'
      FormNameParam.Value = 'TMovementProtocolForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
        end
        item
          Name = 'InvNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          ParamType = ptInput
        end>
      isShowModal = False
    end
    object actUpdate: TdsdInsertUpdateAction [22]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1087#1088#1080#1093#1086#1076')>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1087#1088#1080#1093#1086#1076')>'
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TProductionUnionTechEditForm'
      FormNameParam.Value = 'TProductionUnionTechEditForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'MovementId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
        end
        item
          Name = 'OperDate'
          Value = 41791d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementItemId'
          ParamType = ptInput
        end
        item
          Name = 'MovementItemId_order'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementItemId_order'
          ParamType = ptInput
        end
        item
          Name = 'FromId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
        end
        item
          Name = 'ToId'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'Key'
          ParamType = ptInput
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = MasterDS
      DataSetRefresh = actRefresh
      IdFieldName = 'MovementItemId'
    end
    object actInsert: TdsdInsertUpdateAction [23]
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1087#1088#1080#1093#1086#1076')>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090' ('#1087#1088#1080#1093#1086#1076')>'
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TProductionUnionTechEditForm'
      FormNameParam.Value = 'TProductionUnionTechEditForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'MovementId'
          Value = 0
          ParamType = ptInput
        end
        item
          Name = 'OperDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
        end
        item
          Name = 'Id'
          Value = 0
          ParamType = ptInput
        end
        item
          Name = 'MovementItemId_order'
          Value = 0
        end
        item
          Name = 'FromId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
          ParamType = ptInput
        end
        item
          Name = 'ToId'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'Key'
          ParamType = ptInput
        end>
      isShowModal = True
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
        end>
    end
    object actPrintReceipt: TdsdPrintAction [25]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spPrintReceipt
      StoredProcList = <
        item
          StoredProc = spPrintReceipt
        end
        item
          StoredProc = spPrintReceiptChild
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
      Hint = #1055#1077#1095#1072#1090#1100' '#1088#1077#1094#1077#1087#1090#1091#1088#1099
      ImageIndex = 17
      DataSets = <
        item
          DataSet = PrintMasterCDS
          UserName = 'Master'
        end
        item
          DataSet = PrintChildCDS
          UserName = 'Client'
          IndexFieldNames = 'ReceiptId;GroupNumber;InfoMoneyName;GoodsName'
        end>
      CopiesCount = 1
      Params = <
        item
          Name = 'StartDate'
          Value = 41791d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41791d
          Component = deEnd
          DataType = ftDateTime
        end>
      ReportName = #1055#1077#1095#1072#1090#1100'_'#1088#1077#1094#1077#1087#1090#1086#1074
      ReportNameParam.Value = #1055#1077#1095#1072#1090#1100'_'#1088#1077#1094#1077#1087#1090#1086#1074
      ReportNameParam.DataType = ftString
    end
    object actReport_TaxExit_Loss: TdsdPrintAction [26]
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'isDetail'
          FromParam.Value = True
          FromParam.DataType = ftBoolean
          ToParam.Name = 'isDetail'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isDetail'
          ToParam.DataType = ftBoolean
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
      CopiesCount = 1
      Params = <
        item
          Name = 'StartDate'
          Value = 41791d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41791d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'FromId'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'Key'
        end
        item
          Name = 'FromName'
          Value = ''
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
        end
        item
          Name = 'ToId'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'Key'
        end
        item
          Name = 'ToName'
          Value = ''
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
        end
        item
          Name = 'isDetail'
          Value = False
          DataType = ftBoolean
        end
        item
          Name = 'isLoss'
          Value = True
          DataType = ftBoolean
        end>
      ReportName = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1093#1086#1076#1072' ('#1080#1090#1086#1075#1080')'
      ReportNameParam.Value = #1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1074#1099#1093#1086#1076#1072' ('#1080#1090#1086#1075#1080')'
      ReportNameParam.DataType = ftString
    end
    object actReport_TaxLoss: TdsdPrintAction [27]
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'isDetail'
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          ToParam.Name = 'isDetail'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'isDetail'
          ToParam.DataType = ftBoolean
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
      CopiesCount = 1
      Params = <
        item
          Name = 'StartDate'
          Value = 41791d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41791d
          Component = deEnd
          DataType = ftDateTime
        end
        item
          Name = 'FromId'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'Key'
        end
        item
          Name = 'FromName'
          Value = Null
          Component = GuidesFrom
          ComponentItem = 'TextValue'
          DataType = ftString
        end
        item
          Name = 'ToId'
          Value = Null
          Component = FormParams
          ComponentItem = 'ToId_baza'
        end
        item
          Name = 'ToName'
          Value = Null
          Component = FormParams
          ComponentItem = 'ToName_baza'
          DataType = ftString
        end
        item
          Name = 'isDetail'
          Value = False
          DataType = ftBoolean
        end>
      ReportName = #1055#1088#1080#1093#1086#1076' '#1085#1072' '#1089#1082#1083#1072#1076' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1087#1086#1090#1077#1088#1100' ('#1080#1090#1086#1075#1080')'
      ReportNameParam.Value = #1055#1088#1080#1093#1086#1076' '#1085#1072' '#1089#1082#1083#1072#1076' '#1080' '#1087#1088#1086#1094#1077#1085#1090' '#1087#1086#1090#1077#1088#1100' ('#1080#1090#1086#1075#1080')'
      ReportNameParam.DataType = ftString
    end
    object actReceiptChoice: TOpenChoiceForm [28]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actReceiptChoice'
      FormName = 'TReceipt_ObjectForm'
      FormNameParam.Value = 'TReceipt_ObjectForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptId'
        end
        item
          Name = 'ReceiptCode_user'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptCode'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ReceiptName'
          DataType = ftString
        end
        item
          Name = 'MasterReceiptId'
          Value = 0
        end
        item
          Name = 'MasterGoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
        end
        item
          Name = 'MasterGoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
        end
        item
          Name = 'MasterGoodsKindId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
        end>
      isShowModal = True
    end
    object actUnComplete: TdsdChangeMovementStatus [32]
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
    object actComplete: TdsdChangeMovementStatus [33]
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
    object actSetErased: TdsdChangeMovementStatus [34]
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
      end
      item
        Name = 'inEndDate'
        Value = 41791d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inFromId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inToId'
        Value = False
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inIsErased'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInputOutput
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
          ItemName = 'bbPrintReceipt'
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
          ItemName = 'bbReport_TaxExit_Loss'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReport_TaxLoss'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
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
          ItemName = 'bbMIMasterProtocol'
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
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actUpdate
      end>
  end
  inherited PopupMenu: TPopupMenu
    Left = 152
    Top = 240
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
      end
      item
        Name = 'TotalSumm'
        Value = Null
        DataType = ftString
      end
      item
        Name = 'MIOrderId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'FromId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'FromName'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ToId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'ToName'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'ToId_baza'
        Value = 8458
      end
      item
        Name = 'ToName_baza'
        Value = #1057#1082#1083#1072#1076' '#1041#1072#1079#1072' '#1043#1055
        DataType = ftString
      end
      item
        Name = 'isDetail'
        Value = Null
        DataType = ftBoolean
      end>
  end
  inherited StatusGuides: TdsdGuides
    Left = 968
    Top = 8
  end
  inherited spChangeStatus: TdsdStoredProc
    Left = 1032
    Top = 8
  end
  inherited spGet: TdsdStoredProc
    OutputType = otResult
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
    Left = 694
    Top = 512
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = ''
    Left = 646
    Top = 528
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
      end
      item
        Name = 'ioMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInputOutput
      end
      item
        Name = 'ioMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInputOutput
      end
      item
        Name = 'inReceiptId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReceiptId'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inCount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Count'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inRealWeight'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'RealWeight'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
      end>
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 376
    Top = 256
  end
  inherited ChildCDS: TClientDataSet
    MasterFields = 'MovementItemId'
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
      end
      item
        Name = 'outAmount_master'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
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
      end
      item
        Name = 'outAmount_master'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
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
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'ioAmount'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInputOutput
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementItemId'
        ParamType = ptInput
      end
      item
        Name = 'ioAmountReceipt'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountReceipt'
        DataType = ftFloat
        ParamType = ptInputOutput
      end
      item
        Name = 'outAmount_master'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
      end
      item
        Name = 'outAmountWeight'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountWeight'
        DataType = ftFloat
      end
      item
        Name = 'outAmountReceiptWeight'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'AmountReceiptWeight'
        DataType = ftFloat
      end
      item
        Name = 'outIsWeightMain'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isWeightMain'
        DataType = ftBoolean
      end
      item
        Name = 'outIsTaxExit'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'isTaxExit'
        DataType = ftBoolean
      end
      item
        Name = 'outGroupNumber'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GroupNumber'
      end
      item
        Name = 'inPartionGoodsDate'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'PartionGoodsDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ChildCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
      end>
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
  object PrintChildCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 708
    Top = 278
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
      end
      item
        Name = 'inEndDate'
        Value = 41791d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inToId'
        Value = Null
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inIsDetail'
        Value = False
        Component = FormParams
        ComponentItem = 'isDetail'
        DataType = ftBoolean
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 496
    Top = 264
  end
  object spPrintReceipt: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Receipt'
    DataSet = PrintMasterCDS
    DataSets = <
      item
        DataSet = PrintMasterCDS
      end>
    Params = <
      item
        Name = 'inReceiptId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReceiptId'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindId'
        Value = 41791d
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
      end
      item
        Name = 'inShowAll'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 424
    Top = 185
  end
  object spPrintReceiptChild: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ReceiptChild'
    DataSet = PrintChildCDS
    DataSets = <
      item
        DataSet = PrintChildCDS
      end>
    Params = <
      item
        Name = 'inReceiptId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ReceiptId'
        ParamType = ptInput
      end
      item
        Name = 'inShowAll'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 440
    Top = 201
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
      end
      item
        Name = 'inEndDate'
        Value = 41791d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inToId'
        Value = Null
        Component = FormParams
        ComponentItem = 'ToId_baza'
        ParamType = ptInput
      end
      item
        Name = 'inIsDetail'
        Value = False
        Component = FormParams
        ComponentItem = 'isDetail'
        DataType = ftBoolean
        ParamType = ptInput
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
      end
      item
        Name = 'inIsLastComplete'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 151
    Top = 299
  end
end
