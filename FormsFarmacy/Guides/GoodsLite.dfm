inherited GoodsLiteForm: TGoodsLiteForm
  Caption = #1042#1099#1073#1086#1088' '#1090#1086#1074#1072#1088#1086#1074
  ExplicitWidth = 583
  ExplicitHeight = 335
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 575
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'CodeInt'
            Width = 113
          end
          object colName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            Width = 448
          end
        end
      end
      object cxLabel1: TcxLabel
        Left = 24
        Top = 32
        Caption = #1057#1077#1090#1100': '
      end
      object beRetail: TcxButtonEdit
        Left = 24
        Top = 55
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 2
        Width = 201
      end
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Goods_Lite'
    Params = <
      item
        Name = 'inObject'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'Key'
        ParamType = ptInput
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
          ItemName = 'bbChoice'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRetailLabel'
        end
        item
          Visible = True
          ItemName = 'bbRetailEdit'
        end>
    end
    object bbRetailLabel: TdxBarControlContainerItem
      Caption = 'RetailLabel'
      Category = 0
      Visible = ivAlways
      Control = cxLabel1
    end
    object bbRetailEdit: TdxBarControlContainerItem
      Caption = 'RetailEdit'
      Category = 0
      Visible = ivAlways
      Control = beRetail
    end
  end
  object RetailGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = beRetail
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = RetailGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 48
    Top = 80
  end
end
