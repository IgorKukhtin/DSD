inherited ColorForm: TColorForm
  Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1094#1074#1077#1090#1086#1074' '#1074' '#1075#1088#1080#1076#1077
  ClientHeight = 320
  ClientWidth = 490
  ExplicitWidth = 506
  ExplicitHeight = 358
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 490
    Height = 294
    ExplicitWidth = 421
    ClientRectBottom = 294
    ClientRectRight = 490
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 421
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 490
        Height = 294
        ExplicitWidth = 421
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsView.ColumnAutoWidth = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
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
        end
      end
    end
  end
  inherited MasterDS: TDataSource
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Color'
    Top = 80
  end
  inherited BarManager: TdxBarManager
    Top = 72
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
