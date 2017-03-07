inherited DiscountKindForm: TDiscountKindForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1042#1080#1076' '#1089#1082#1080#1076#1082#1080'>'
  ClientWidth = 393
  ExplicitWidth = 409
  ExplicitHeight = 347
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 393
    ExplicitWidth = 393
    ClientRectRight = 393
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 393
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 393
        ExplicitWidth = 393
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsView.ColumnAutoWidth = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 292
          end
        end
      end
    end
  end
  inherited MasterDS: TDataSource
    Left = 96
    Top = 24
  end
  inherited MasterCDS: TClientDataSet
    Left = 32
    Top = 72
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_DiscountKind'
    Left = 120
    Top = 72
  end
  inherited BarManager: TdxBarManager
    Left = 176
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
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
          ItemName = 'bbChoice'
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
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 256
    Top = 256
  end
end
