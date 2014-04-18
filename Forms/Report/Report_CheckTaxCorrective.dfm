inherited Report_CheckTaxCorrectiveForm: TReport_CheckTaxCorrectiveForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#1056#1077#1077#1089#1090#1088#1072' '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1086#1082' '#1082' '#1085#1072#1083#1086#1075#1086#1074#1099#1084' '#1085#1072#1082#1083#1072#1076#1085#1099#1084'>'
  ClientHeight = 319
  ClientWidth = 990
  ExplicitWidth = 1006
  ExplicitHeight = 354
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 990
    Height = 262
    TabOrder = 3
    ExplicitWidth = 990
    ExplicitHeight = 262
    ClientRectBottom = 262
    ClientRectRight = 990
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 990
      ExplicitHeight = 262
      inherited cxGrid: TcxGrid
        Width = 990
        Height = 262
        ExplicitWidth = 990
        ExplicitHeight = 262
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmount_ReturnIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmount_TaxCorrective
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmount_ReturnIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmount_TaxCorrective
            end>
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clOperDate_ReturnIn: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1074#1086#1079#1074#1088#1072#1090#1072
            DataBinding.FieldName = 'OperDate_ReturnIn'
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 55
          end
          object clInvNumber_ReturnIn: TcxGridDBColumn
            Caption = #8470' '#1042#1086#1079#1074#1088#1072#1090#1072
            DataBinding.FieldName = 'InvNumber_ReturnIn'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 47
          end
          object clOperDate_TaxCorrective: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1082#1086#1088#1088'.'
            DataBinding.FieldName = 'OperDate_TaxCorrective'
            HeaderAlignmentVert = vaCenter
            Width = 56
          end
          object clInvNumber_TaxCorrective: TcxGridDBColumn
            Caption = #8470' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1080
            DataBinding.FieldName = 'InvNumber_TaxCorrective'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 66
          end
          object clDocumentTaxKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1085#1072#1083#1086#1075'.'#1076#1086#1082'.'
            DataBinding.FieldName = 'DocumentTaxKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clFromCode: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1086#1090' '#1082#1086#1075#1086')'
            DataBinding.FieldName = 'FromCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 98
          end
          object clFromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 58
          end
          object clToCode: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1082#1086#1084#1091')'
            DataBinding.FieldName = 'ToCode'
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 61
          end
          object clToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 60
          end
          object clGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 45
          end
          object clGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 39
          end
          object clGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 61
          end
          object clPrice_ReturnIn: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' ('#1074#1086#1079#1074#1088#1072#1090')'
            DataBinding.FieldName = 'Price_ReturnIn'
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 62
          end
          object clPrice_TaxCorrective: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' ('#1050#1086#1088#1088')'
            DataBinding.FieldName = 'Price_TaxCorrective'
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 56
          end
          object clAmount_ReturnIn: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' ('#1074#1086#1079#1074#1088#1072#1090')'
            DataBinding.FieldName = 'Amount_ReturnIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 60
          end
          object clAmount_TaxCorrective: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' ('#1050#1086#1088#1088')'
            DataBinding.FieldName = 'Amount_TaxCorrective'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 53
          end
          object clDifference: TcxGridDBColumn
            Caption = #1054#1090#1083#1080#1095#1080#1077
            DataBinding.FieldName = 'Difference'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 990
    ExplicitWidth = 990
    inherited deStart: TcxDateEdit
      EditValue = 41640d
      Properties.SaveTime = False
    end
    inherited deEnd: TcxDateEdit
      EditValue = 41640d
      Properties.SaveTime = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_CheckTaxCorrective'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 112
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 144
    Top = 208
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 368
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 80
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
    Left = 184
    Top = 136
  end
end
