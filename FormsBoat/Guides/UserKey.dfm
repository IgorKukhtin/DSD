inherited UserKeyForm: TUserKeyForm
  Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1080' '#1080' '#1088#1086#1083#1080
  ExplicitWidth = 583
  ExplicitHeight = 335
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    inherited tsMain: TcxTabSheet
      inherited cxGrid: TcxGrid
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colDescName: TcxGridDBColumn
            Caption = #1044#1045#1057#1050
            DataBinding.FieldName = 'DescName'
            Options.Editing = False
            Width = 129
          end
          object colCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            Options.Editing = False
            Width = 74
          end
          object colName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            Options.Editing = False
            Width = 358
          end
        end
      end
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_UserKey'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
