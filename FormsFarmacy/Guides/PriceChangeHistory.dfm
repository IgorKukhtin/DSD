inherited PriceChangeHistoryForm: TPriceChangeHistoryForm
  Caption = #1048#1089#1090#1086#1088#1080#1103' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1094#1077#1085#1099' '#1057#1054' '#1057#1050#1048#1044#1050#1054#1049
  ClientHeight = 406
  ClientWidth = 807
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.Params = FormParams
  ExplicitWidth = 823
  ExplicitHeight = 445
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 807
    Height = 380
    ExplicitWidth = 639
    ExplicitHeight = 380
    ClientRectBottom = 380
    ClientRectRight = 807
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 639
      ExplicitHeight = 380
      inherited cxGrid: TcxGrid
        Width = 807
        Height = 380
        ExplicitWidth = 639
        ExplicitHeight = 380
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
          object PriceChange: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'PriceChange'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 118
          end
          object PercentMarkup: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'PercentMarkup'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
          end
          object FixValue: TcxGridDBColumn
            Caption = #1060#1080#1082#1089'. '#1094#1077#1085#1072
            DataBinding.FieldName = 'FixValue'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1072#1103' '#1094#1077#1085#1072
            Width = 95
          end
          object FixPercent: TcxGridDBColumn
            Caption = #1060#1080#1082#1089'. %'
            DataBinding.FieldName = 'FixPercent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1060#1080#1082#1089#1080#1088#1086#1074#1072#1085#1085#1099#1081' % '#1089#1082#1080#1076#1082#1080
            Width = 95
          end
          object FixDiscount: TcxGridDBColumn
            Caption = #1060#1080#1082#1089'. '#1089#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' ('#1089#1082')'
            DataBinding.FieldName = 'FixDiscount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 89
          end
          object Multiplicity: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1086#1090#1087#1091#1089#1082#1072
            DataBinding.FieldName = 'Multiplicity'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object FixEndDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1076#1077#1081#1089#1090#1074#1080#1103' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'FixEndDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
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
    StoredProcName = 'gpSelect_ObjectHistory_PriceChange'
    Params = <
      item
        Name = 'inPriceChangeId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 112
  end
  inherited BarManager: TdxBarManager
    Left = 152
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
        Name = 'Id'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 16
    Top = 168
  end
end
