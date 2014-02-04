inherited Report_Goods_MovementForm: TReport_Goods_MovementForm
  Caption = #1054#1090#1095#1077#1090' < '#1055#1088#1086#1076#1072#1078#1072' / '#1042#1086#1079#1074#1088#1072#1090' '#1090#1086#1074#1072#1088#1086#1074' '#1086#1090' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081'> '
  ClientHeight = 339
  ClientWidth = 1137
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1145
  ExplicitHeight = 373
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1137
    Height = 282
    TabOrder = 3
    ExplicitWidth = 1137
    ExplicitHeight = 282
    ClientRectBottom = 282
    ClientRectRight = 1137
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1137
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 1137
        Height = 282
        ExplicitWidth = 1137
        ExplicitHeight = 282
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSale_Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSale_Amount_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSale_Amount_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountReturn_CountSh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountReturn_CountWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountReturn_Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSale_AmountPartner_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSale_AmountPartner_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clReturn_AmountPartner_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clReturn_AmountPartner_Sh
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSale_Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSale_Amount_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSale_Amount_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountReturn_CountSh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountReturn_CountWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountReturn_Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSale_AmountPartner_Sh
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSale_AmountPartner_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clReturn_AmountPartner_Weight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clReturn_AmountPartner_Sh
            end>
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clJuridicalName: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 93
          end
          object clPartnerName: TcxGridDBColumn
            Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'PartnerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 136
          end
          object clPaidKindName: TcxGridDBColumn
            Caption = #1060#1054
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 24
          end
          object clTradeMarkName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 68
          end
          object clGoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 56
          end
          object clGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 44
          end
          object clGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 102
          end
          object clSale_Amount_Sh: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1085#1086', '#1096#1090' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'Sale_Amount_Sh'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 76
          end
          object clSale_Amount_Weight: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1085#1086', '#1082#1075' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'Sale_Amount_Weight'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clSale_AmountPartner_Sh: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1085#1086', '#1096#1090' ('#1087#1086#1082#1091#1087')'
            DataBinding.FieldName = 'Sale_AmountPartner_Sh'
          end
          object clSale_AmountPartner_Weight: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1085#1086', '#1082#1075' ('#1087#1086#1082#1091#1087')'
            DataBinding.FieldName = 'Sale_AmountPartner_Weight'
          end
          object clSale_Summ: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1085#1086', '#1075#1088#1085
            DataBinding.FieldName = 'Sale_Summ'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 62
          end
          object clAmountReturn_CountWeight: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'AmountReturn_CountWeight'
            Width = 54
          end
          object clAmountReturn_CountSh: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1096#1090' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'AmountReturn_CountSh'
            Width = 54
          end
          object clReturn_AmountPartner_Weight: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1082#1075' ('#1087#1086#1082#1091#1087')'
            DataBinding.FieldName = 'Return_AmountPartner_Weight'
          end
          object clReturn_AmountPartner_Sh: TcxGridDBColumn
            Caption = #1074#1086#1079#1074#1088#1072#1090', '#1096#1090' ('#1087#1086#1082#1091#1087')'
            DataBinding.FieldName = 'Return_AmountPartner_Sh'
          end
          object clAmountReturn_Summ: TcxGridDBColumn
            Caption = #1042#1086#1079#1074#1088#1072#1090', '#1075#1088#1085
            DataBinding.FieldName = 'AmountReturn_Summ'
            Width = 55
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1137
    ExplicitWidth = 1137
    inherited deStart: TcxDateEdit
      Left = 95
      EditValue = 41609d
      ExplicitLeft = 95
    end
    inherited deEnd: TcxDateEdit
      Left = 304
      EditValue = 41609d
      ExplicitLeft = 304
    end
    inherited cxLabel1: TcxLabel
      Left = 4
      ExplicitLeft = 4
    end
    inherited cxLabel2: TcxLabel
      Left = 194
      ExplicitLeft = 194
    end
    object cxLabel4: TcxLabel
      Left = 402
      Top = 6
      Caption = #1043#1088'.'#1090#1086#1074#1072#1088#1072
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 462
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 240
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Goods_Movement'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41609d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41609d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 112
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 208
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 232
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 112
    Top = 128
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GoodsGroupGuides
      end
      item
        Component = deEnd
      end
      item
        Component = deStart
      end>
    Left = 184
    Top = 136
  end
  object GoodsGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroupForm'
    FormNameParam.DataType = ftString
    FormName = 'TGoodsGroupForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 600
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 328
    Top = 170
  end
end
