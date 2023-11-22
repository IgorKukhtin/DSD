inherited ObjectDescForm: TObjectDescForm
  Caption = #1058#1080#1087#1099' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1086#1074
  ClientWidth = 546
  ExplicitWidth = 562
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 546
    ExplicitWidth = 546
    ClientRectRight = 546
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 546
      inherited cxGrid: TcxGrid
        Width = 546
        ExplicitWidth = 546
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            Width = 30
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 407
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited actChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
    end
  end
  inherited MasterDS: TDataSource
    Top = 48
  end
  inherited MasterCDS: TClientDataSet
    Top = 48
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_ObjectDesc'
    Top = 48
  end
  inherited BarManager: TdxBarManager
    Top = 48
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
