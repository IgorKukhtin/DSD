inherited PartionGoodsListForm: TPartionGoodsListForm
  Caption = #1053#1072#1083#1080#1095#1080#1077' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1072' '#1087#1086' '#1089#1088#1086#1082#1072#1084
  AddOnFormData.Params = FormParams
  ExplicitWidth = 591
  ExplicitHeight = 347
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 575
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 48
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 267
          end
          object PartionDateKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1089#1088#1086#1082#1072
            DataBinding.FieldName = 'PartionDateKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 164
          end
          object Remains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
        end
      end
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PartionGoods'
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsID'
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
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UnitID'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsID'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 264
  end
end
