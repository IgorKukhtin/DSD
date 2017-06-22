inherited ConfirmedKindForm: TConfirmedKindForm
  Caption = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072
  ClientHeight = 457
  ClientWidth = 859
  ExplicitWidth = 875
  ExplicitHeight = 496
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 859
    Height = 431
    ExplicitWidth = 859
    ExplicitHeight = 431
    ClientRectBottom = 431
    ClientRectRight = 859
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 859
      ExplicitHeight = 431
      inherited cxGrid: TcxGrid
        Width = 859
        Height = 431
        ExplicitWidth = 859
        ExplicitHeight = 431
        inherited cxGridDBTableView: TcxGridDBTableView
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
            Width = 39
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 176
          end
          object Id: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 51
          end
          object EnumName: TcxGridDBColumn
            DataBinding.FieldName = 'EnumName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 236
          end
        end
      end
    end
  end
  inherited MasterDS: TDataSource
    Left = 40
    Top = 64
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ConfirmedKind'
    Left = 72
    Top = 64
  end
  inherited BarManager: TdxBarManager
    Left = 104
    Top = 56
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
