inherited GuideGoodsMovementForm: TGuideGoodsMovementForm
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1088#1086#1076#1091#1082#1094#1080#1080' '#1076#1083#1103' '#1079#1072#1103#1074#1082#1080
  PixelsPerInch = 96
  TextHeight = 14
  inherited GridPanel: TPanel
    inherited DBGrid: TDBGrid
      Columns = <
        item
          Expanded = False
          FieldName = 'GoodsCode'
          Title.Alignment = taCenter
          Title.Caption = #1050#1086#1076
          Width = 70
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'GoodsName'
          Title.Alignment = taCenter
          Title.Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          Width = 200
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'GoodsKindName'
          Title.Caption = #1042#1080#1076
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'MeasureName'
          Title.Alignment = taCenter
          Title.Caption = #1045#1076'.'#1080#1079#1084'.'
          Width = 45
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Price'
          Title.Alignment = taCenter
          Title.Caption = #1062#1077#1085#1072
          Width = 55
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Price_Return'
          Title.Alignment = taCenter
          Title.Caption = #1062#1077#1085#1072'('#1074#1086#1079#1074#1088')'
          Width = -1
          Visible = False
        end
        item
          Expanded = False
          FieldName = 'Amount_Order'
          Title.Caption = #1047#1072#1103#1074#1082#1072
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Amount_Weighing'
          Title.Caption = #1054#1090#1075#1088#1091#1079#1082#1072
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Amount_diff'
          Title.Caption = #1056#1072#1079#1085#1080#1094#1072
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'GoodsGroupNameFull'
          Title.Alignment = taCenter
          Title.Caption = #1043#1088#1091#1087#1087#1072
          Width = 200
          Visible = True
        end>
    end
  end
end
