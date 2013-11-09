inherited ObjectForm: TObjectForm
  Caption = #1054#1073#1098#1077#1082#1090#1099
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.Params = FormParams
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
          object colCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            Width = 87
          end
          object colName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            Width = 474
          end
        end
      end
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object'
    Params = <
      item
        Name = 'inObjectDescId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'ObjectDescId'
        ParamType = ptInput
      end>
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ObjectDescId'
        Value = '0'
      end>
    Left = 160
    Top = 16
  end
end
