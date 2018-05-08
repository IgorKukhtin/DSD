inherited ProcessForm: TProcessForm
  Caption = #1055#1088#1086#1094#1077#1089#1089#1099
  ClientHeight = 457
  ClientWidth = 859
  ExplicitWidth = 875
  ExplicitHeight = 492
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
          OnDblClick = nil
          OnKeyDown = nil
          OnKeyPress = nil
          OnCustomDrawCell = nil
          DataController.Filter.OnChanged = nil
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          OnColumnHeaderClick = nil
          OnCustomDrawColumnHeader = nil
          object clCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 20
          end
          object clName: TcxGridDBColumn
            Caption = #1055#1088#1086#1094#1077#1089#1089#1099
            DataBinding.FieldName = 'Name'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object clId: TcxGridDBColumn
            DataBinding.FieldName = 'Id'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
          object clEnumName: TcxGridDBColumn
            DataBinding.FieldName = 'EnumName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
        end
      end
    end
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    AfterInsert = nil
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Process'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
