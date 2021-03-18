inherited PSLExportKindForm: TPSLExportKindForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1058#1080#1087#1099' '#1074#1099#1075#1088#1091#1079#1082#1080' '#1074#1077#1076#1086#1084#1086#1089#1090#1080' '#1074' '#1073#1072#1085#1082'>'
  ClientWidth = 438
  ExplicitWidth = 454
  ExplicitHeight = 346
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 438
    ClientRectRight = 438
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 575
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 438
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsView.Footer = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 152
          end
          object EnumName: TcxGridDBColumn
            Caption = #1060#1091#1085#1082#1094#1080#1103
            DataBinding.FieldName = 'EnumName'
            Options.Editing = False
            Width = 117
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    inherited ChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
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
    StoredProcName = 'gpSelect_Object_PSLExportKind'
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
