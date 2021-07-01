inherited ReturnDescKindForm: TReturnDescKindForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1088#1080#1079#1085#1072#1082' '#1074#1086#1079#1074#1088#1072#1090#1072'>'
  ClientHeight = 254
  ClientWidth = 367
  AddOnFormData.isAlwaysRefresh = True
  ExplicitWidth = 383
  ExplicitHeight = 292
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 367
    Height = 228
    ExplicitWidth = 393
    ExplicitHeight = 228
    ClientRectBottom = 228
    ClientRectRight = 367
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 393
      ExplicitHeight = 228
      inherited cxGrid: TcxGrid
        Width = 367
        Height = 228
        ExplicitWidth = 393
        ExplicitHeight = 228
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 64
          end
          object clName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 292
          end
          object clErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 78
          end
          object EnumName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1092#1091#1085#1082#1094#1080#1080
            DataBinding.FieldName = 'EnumName'
            Visible = False
            Width = 70
          end
        end
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 160
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 160
  end
  inherited ActionList: TActionList
    Top = 159
  end
  inherited MasterDS: TDataSource
    Left = 224
    Top = 72
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 96
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ReturnDescKind'
    Left = 120
    Top = 96
  end
  inherited BarManager: TdxBarManager
    Left = 288
    Top = 88
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
    Left = 256
    Top = 152
  end
  inherited PopupMenu: TPopupMenu
    Top = 160
  end
end
