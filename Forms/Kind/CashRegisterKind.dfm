inherited CashRegisterKindForm: TCashRegisterKindForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1058#1080#1087' '#1082#1072#1089#1089#1086#1074#1086#1075#1086' '#1072#1087#1087#1072#1088#1072#1090#1072'>'
  ClientWidth = 308
  ExplicitWidth = 316
  ExplicitHeight = 335
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 308
    ClientRectRight = 308
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 575
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 308
        inherited cxGridDBTableView: TcxGridDBTableView
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
            Width = 268
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
    StoredProcName = 'gpSelect_Object_CashRegisterKind'
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
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 256
    Top = 256
  end
end
