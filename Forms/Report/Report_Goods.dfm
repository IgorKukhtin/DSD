inherited Report_GoodsForm: TReport_GoodsForm
  Caption = #1054#1090#1095#1077#1090' <'#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
  ClientHeight = 341
  ClientWidth = 754
  ExplicitWidth = 770
  ExplicitHeight = 376
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 754
    Height = 284
    TabOrder = 3
    ExplicitTop = 57
    ExplicitWidth = 754
    ExplicitHeight = 284
    ClientRectBottom = 284
    ClientRectRight = 754
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 754
      ExplicitHeight = 284
      inherited cxGrid: TcxGrid
        Top = 0
        Width = 754
        Height = 284
        ExplicitTop = 0
        ExplicitWidth = 754
        ExplicitHeight = 284
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clUnit_infName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'Unit_infName'
          end
          object clDirectionName: TcxGridDBColumn
            Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'DirectionName'
          end
          object clGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
          end
          object clGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
          end
          object clMovementDescName: TcxGridDBColumn
            Caption = #1044#1086#1082#1091#1084#1077#1085#1090
            DataBinding.FieldName = 'MovementDescName'
          end
          object clInvNumber: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' '#1076#1086#1082'-'#1090#1072
            DataBinding.FieldName = 'InvNumber'
          end
          object clSummStart: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1085#1072#1095#1072#1083#1086
            DataBinding.FieldName = 'SummStart'
          end
          object clSummIn: TcxGridDBColumn
            Caption = #1044#1077#1073#1077#1090
            DataBinding.FieldName = 'SummIn'
          end
          object clSummOut: TcxGridDBColumn
            Caption = #1050#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'SummOut'
          end
          object clSummEnd: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1082#1086#1085#1077#1094
            DataBinding.FieldName = 'SummEnd'
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 754
    ExplicitWidth = 754
    inherited deEnd: TcxDateEdit
      EditValue = 41399d
    end
    object cxLabel3: TcxLabel
      Left = 416
      Top = 6
      Caption = #1058#1086#1074#1072#1088
    end
    object edGoods: TcxButtonEdit
      Left = 464
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 225
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Goods'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41399d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = GoodsGuides
        ParamType = ptInput
      end>
    Left = 88
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 368
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 80
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
      end>
    Left = 184
    Top = 136
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormName = 'TGoodsForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 544
    Top = 3
  end
end
