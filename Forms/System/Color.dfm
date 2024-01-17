inherited ColorForm: TColorForm
  Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1094#1074#1077#1090#1086#1074' '#1074' '#1075#1088#1080#1076#1077
  ClientHeight = 323
  ClientWidth = 434
  ExplicitWidth = 450
  ExplicitHeight = 362
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 434
    Height = 297
    ExplicitWidth = 434
    ExplicitHeight = 297
    ClientRectBottom = 297
    ClientRectRight = 434
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 434
      ExplicitHeight = 297
      inherited cxGrid: TcxGrid
        Width = 434
        Height = 297
        ExplicitWidth = 434
        ExplicitHeight = 297
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Deleting = False
          OptionsData.Editing = False
          OptionsView.ColumnAutoWidth = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'ColorName'
            PropertiesClassName = 'TcxTextEditProperties'
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 255
          end
          object colText1: TcxGridDBColumn
            Caption = #1062#1074#1077#1090' '#1090#1077#1082#1089#1090#1072
            DataBinding.FieldName = 'Text1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 100
          end
          object colText2: TcxGridDBColumn
            Caption = #1062#1074#1077#1090' '#1092#1086#1085#1072
            DataBinding.FieldName = 'Text2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 100
          end
          object ColorValue: TcxGridDBColumn
            DataBinding.FieldName = 'ColorValue'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
          object ColorValueDop: TcxGridDBColumn
            DataBinding.FieldName = 'ColorValueDop'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
          object colId: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            Visible = False
            VisibleForCustomization = False
            Width = 30
          end
        end
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 83
    Top = 256
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 248
  end
  inherited ActionList: TActionList
    Left = 87
    Top = 183
    inherited ChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ColorValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ColorName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 136
  end
  inherited MasterCDS: TClientDataSet
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Color'
    Left = 72
    Top = 136
  end
  inherited BarManager: TdxBarManager
    Left = 152
    Top = 96
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
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        ColorColumn = colText1
        ValueColumn = ColorValue
        BackGroundValueColumn = ColorValueDop
        ColorValueList = <>
      end
      item
        ColorColumn = colText2
        BackGroundValueColumn = ColorValue
        ColorValueList = <>
      end>
    Left = 288
    Top = 128
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
    Top = 256
  end
end
