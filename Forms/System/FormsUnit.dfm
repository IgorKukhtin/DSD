inherited FormsForm: TFormsForm
  Caption = #1060#1086#1088#1084#1099' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1103
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
          object colName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1092#1086#1088#1084
            DataBinding.FieldName = 'Name'
            Options.Editing = False
          end
        end
      end
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Form'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
