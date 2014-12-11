inherited ImportExportLinkTypeForm: TImportExportLinkTypeForm
  Caption = #1042#1080#1076#1099' '#1089#1074#1103#1079#1077#1081
  ClientWidth = 261
  ExplicitWidth = 269
  ExplicitHeight = 335
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 261
    ExplicitWidth = 261
    ClientRectRight = 261
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 261
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 261
        ExplicitWidth = 261
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1089#1074#1103#1079#1080
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 252
          end
        end
      end
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ImportExportLinkType'
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
  end
end
