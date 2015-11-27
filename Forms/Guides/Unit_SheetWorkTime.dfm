inherited Unit_SheetWorkTimeForm: TUnit_SheetWorkTimeForm
  Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
  ExplicitWidth = 591
  ExplicitHeight = 346
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 575
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colParentName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072
            DataBinding.FieldName = 'ParentName'
            Width = 120
          end
          object colCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            Width = 42
          end
          object colName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            Width = 196
          end
          object colBranchName: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            Width = 125
          end
          object colisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            Width = 56
          end
        end
      end
    end
  end
  inherited MasterDS: TDataSource
    Top = 112
  end
  inherited MasterCDS: TClientDataSet
    Top = 104
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_UnitSheetWorkTime'
    Top = 112
  end
  inherited BarManager: TdxBarManager
    Left = 128
    Top = 120
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
