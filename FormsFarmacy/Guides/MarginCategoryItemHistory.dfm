inherited MarginCategoryItemHistoryForm: TMarginCategoryItemHistoryForm
  Caption = #1048#1089#1090#1086#1088#1080#1103' '#1069#1083#1077#1084#1077#1085#1090#1072' '#1082#1072#1090#1077#1075#1086#1088#1080#1080' '#1085#1072#1094#1077#1085#1082#1080' ('#1085#1072#1094#1077#1085#1082#1080' '#1074' '#1072#1087#1090#1077#1082#1077')'
  ClientHeight = 354
  ClientWidth = 504
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.Params = FormParams
  ExplicitWidth = 520
  ExplicitHeight = 393
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 504
    Height = 328
    ExplicitWidth = 504
    ExplicitHeight = 328
    ClientRectBottom = 328
    ClientRectRight = 504
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 504
      ExplicitHeight = 328
      inherited cxGrid: TcxGrid
        Width = 504
        Height = 328
        ExplicitWidth = 504
        ExplicitHeight = 328
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object StartDate: TcxGridDBColumn
            Caption = #1057' '#1076#1072#1090#1099
            DataBinding.FieldName = 'StartDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 104
          end
          object Price: TcxGridDBColumn
            Caption = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1072#1103' '#1094#1077#1085#1072
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 126
          end
          object Value: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'Value'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 114
          end
        end
      end
    end
  end
  inherited MasterDS: TDataSource
    Top = 112
  end
  inherited MasterCDS: TClientDataSet
    Top = 112
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_ObjectHistory_MarginCategoryItem'
    Params = <
      item
        Name = 'inMarginCategoryItemId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMarginCategoryItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 112
  end
  inherited BarManager: TdxBarManager
    Top = 112
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChoice'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 176
    Top = 184
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inMarginCategoryItemId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 16
    Top = 168
  end
end
