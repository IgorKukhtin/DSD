inherited ObjectForm: TObjectForm
  Caption = #1054#1073#1098#1077#1082#1090#1099
  AddOnFormData.Params = FormParams
  ExplicitWidth = 583
  ExplicitHeight = 335
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    ExplicitTop = 26
    ExplicitHeight = 282
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 575
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 575
        Height = 282
        ExplicitWidth = 575
        ExplicitHeight = 282
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            Options.Editing = False
            Width = 78
          end
          object colName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            Options.Editing = False
            Width = 344
          end
          object colDesc: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
            DataBinding.FieldName = 'DescName'
            Options.Editing = False
            Width = 139
          end
        end
      end
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 48
  end
  inherited MasterCDS: TClientDataSet
    Top = 48
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
    Left = 96
    Top = 56
  end
  inherited BarManager: TdxBarManager
    Left = 144
    Top = 48
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
    Left = 184
    Top = 56
  end
end
