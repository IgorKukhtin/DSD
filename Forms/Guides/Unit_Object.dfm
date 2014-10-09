inherited Unit_ObjectForm: TUnit_ObjectForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103'>'
  ClientHeight = 420
  ClientWidth = 371
  ExplicitWidth = 379
  ExplicitHeight = 447
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 371
    Height = 394
    ExplicitWidth = 440
    ExplicitHeight = 394
    ClientRectBottom = 394
    ClientRectRight = 371
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 440
      ExplicitHeight = 394
      inherited cxGrid: TcxGrid
        Width = 371
        Height = 394
        ExplicitWidth = 440
        ExplicitHeight = 394
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsBehavior.IncSearch = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object ceCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
          object ceName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            SortIndex = 0
            SortOrder = soAscending
            Width = 301
          end
          object ceIsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 40
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 40
  end
  inherited MasterCDS: TClientDataSet
    Top = 40
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Unit'
    Top = 40
  end
  inherited BarManager: TdxBarManager
    ImageOptions.Images = dmMain.ImageList
    Top = 40
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SearchAsFilter = False
    Left = 136
    Top = 184
  end
end
