inherited PriceHistoryForm: TPriceHistoryForm
  Caption = #1048#1089#1090#1086#1088#1080#1103' '#1080#1079#1084#1077#1085#1077#1085#1080#1103' '#1094#1077#1085' '#1080' '#1053#1058#1047
  ClientHeight = 406
  ClientWidth = 504
  AddOnFormData.isAlwaysRefresh = True
  AddOnFormData.Params = FormParams
  ExplicitWidth = 520
  ExplicitHeight = 444
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 504
    Height = 380
    ExplicitWidth = 338
    ExplicitHeight = 380
    ClientRectBottom = 380
    ClientRectRight = 504
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 338
      ExplicitHeight = 380
      inherited cxGrid: TcxGrid
        Width = 504
        Height = 380
        ExplicitWidth = 338
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
          object colStartDate: TcxGridDBColumn
            Caption = #1057' '#1076#1072#1090#1099
            DataBinding.FieldName = 'StartDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 104
          end
          object colPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 98
          end
          object colMCSValue: TcxGridDBColumn
            Caption = #1053#1058#1047
            DataBinding.FieldName = 'MCSValue'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 95
          end
          object colMCSPeriod: TcxGridDBColumn
            Caption = #1053#1058#1047' '#1087#1077#1088#1080#1086#1076' '#1072#1085#1072#1083#1080#1079#1072
            DataBinding.FieldName = 'MCSPeriod'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' '#1072#1085#1072#1083#1080#1079#1072' '#1053#1058#1047
            Width = 95
          end
          object colMCSDay: TcxGridDBColumn
            Caption = #1053#1058#1047' '#1079#1072#1087#1072#1089' '#1076#1085#1077#1081
            DataBinding.FieldName = 'MCSDay'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1057#1090#1088#1072#1093#1086#1074#1086#1081' '#1079#1072#1087#1072#1089' '#1076#1085#1077#1081' '#1076#1083#1103' '#1053#1058#1047
            Width = 95
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
    StoredProcName = 'gpSelect_ObjectHistory_Price'
    Params = <
      item
        Name = 'inPriceId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
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
      end>
    Left = 16
    Top = 168
  end
end
