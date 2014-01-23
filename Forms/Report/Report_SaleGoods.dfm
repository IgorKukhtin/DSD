inherited Report_SaleGoodsForm: TReport_SaleGoodsForm
  Caption = #1054#1090#1095#1077#1090' <'#1087#1086' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080' '#1090#1086#1074#1072#1088#1072'>'
  ClientHeight = 344
  ClientWidth = 973
  ExplicitWidth = 981
  ExplicitHeight = 378
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 973
    Height = 287
    TabOrder = 3
    ExplicitWidth = 973
    ExplicitHeight = 287
    ClientRectBottom = 287
    ClientRectRight = 973
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 973
      ExplicitHeight = 287
      inherited cxGrid: TcxGrid
        Width = 973
        Height = 287
        ExplicitWidth = 973
        ExplicitHeight = 287
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmount_Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmount_Count
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmount_Summ
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmount_Count
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clTradeMarkName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
            DataBinding.FieldName = 'TradeMarkName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object clGoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object clGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clAmount_Count: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
            DataBinding.FieldName = 'Amount_Count'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clAmount_Summ: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'Amount_Summ'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 973
    ExplicitWidth = 973
    inherited deStart: TcxDateEdit
      EditValue = 41579d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 41608d
    end
    object cxLabel4: TcxLabel
      Left = 435
      Top = 6
      Caption = #1043#1088'.'#1090#1086#1074#1072#1088#1072
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 513
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
    StoredProcName = 'gpReport_SaleGoods'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41579d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41608d
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
    Left = 144
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
end
