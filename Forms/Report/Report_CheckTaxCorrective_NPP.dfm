inherited Report_CheckTaxCorrective_NPPForm: TReport_CheckTaxCorrective_NPPForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#1056#1077#1077#1089#1090#1088#1072' '#1085#1072#1083#1086#1075#1086#1074#1099#1093' '#1085#1072#1082#1083#1072#1076#1085#1099#1093'>'
  ClientHeight = 319
  ClientWidth = 837
  AddOnFormData.Params = FormParams
  ExplicitWidth = 853
  ExplicitHeight = 357
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 837
    Height = 262
    TabOrder = 3
    ExplicitWidth = 837
    ExplicitHeight = 262
    ClientRectBottom = 262
    ClientRectRight = 837
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 837
      ExplicitHeight = 262
      inherited cxGrid: TcxGrid
        Width = 837
        Height = 262
        ExplicitWidth = 837
        ExplicitHeight = 262
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object ItemName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'.'
            DataBinding.FieldName = 'ItemName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 72
          end
          object Invnumber: TcxGridDBColumn
            Caption = #8470' '#1085#1072#1083#1086#1075'. '#1076#1086#1082'.'
            DataBinding.FieldName = 'Invnumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 72
          end
          object LineNum: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'LineNum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object LineNumTax: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087' ('#1053#1053')'
            DataBinding.FieldName = 'LineNumTax'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1087'/'#1087' '#1074' '#1082#1086#1083#1086#1085#1082#1077' 1/1'#1089#1090#1088#1086#1082#1072' - '#1076#1083#1103' '#1082#1086#1083#1086#1085#1082#1080' 7 '#1089' "'#1084#1080#1085#1091#1089#1086#1084'"'
            Options.Editing = False
            Width = 75
          end
          object LineNumTaxCorr_calc: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087' '#1053#1053'-'#1050#1086#1088#1088'. ('#1085#1072#1083#1086#1075'.)'
            DataBinding.FieldName = 'LineNumTaxCorr_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1087'/'#1087' '#1074' '#1082#1086#1083#1086#1085#1082#1077' 1/1'#1089#1090#1088#1086#1082#1072' - '#1076#1083#1103' '#1082#1086#1083#1086#1085#1082#1080' 7 '#1089' "'#1084#1080#1085#1091#1089#1086#1084'"'
            Options.Editing = False
            Width = 75
          end
          object LineNumTaxCorr: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087' '#1053#1053'-'#1050#1086#1088#1088'.'
            DataBinding.FieldName = 'LineNumTaxCorr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '0.;-0.; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = 
              #8470' '#1087'/'#1087' '#1074' '#1082#1086#1083#1086#1085#1082#1077' 1/2'#1089#1090#1088#1086#1082#1072' - '#1076#1083#1103' '#1082#1086#1083#1086#1085#1082#1080' 7 '#1089' "'#1087#1083#1102#1089#1086#1084'" - '#1092#1086#1088#1084#1080#1088#1091#1077#1090 +
              #1089#1103' '#1074' '#1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1077' '#1087#1086' '#1087#1088#1072#1074#1080#1083#1091': '#8470' '#1087'/'#1087' + 1'
            Options.Editing = False
            Width = 70
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074'.'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 36
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 42
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 45
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1085#1072#1083#1086#1075'.)'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 67
          end
          object AmountTax_calc: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1083#1103' '#1053#1053'-'#1050#1086#1088#1088'. ('#1085#1072#1083#1086#1075'.)'
            DataBinding.FieldName = 'AmountTax_calc'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1074' '#1082#1086#1083#1086#1085#1082#1077' 7/1'#1089#1090#1088#1086#1082#1072
            Options.Editing = False
            Width = 85
          end
          object AmountSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' ('#1085#1072#1083#1086#1075'.)'
            DataBinding.FieldName = 'AmountSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 127
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 837
    ExplicitWidth = 837
    inherited deStart: TcxDateEdit
      Left = 683
      Properties.SaveTime = False
      Visible = False
      ExplicitLeft = 683
    end
    inherited deEnd: TcxDateEdit
      Left = 745
      Properties.SaveTime = False
      Visible = False
      ExplicitLeft = 745
    end
    inherited cxLabel1: TcxLabel
      Left = 635
      Visible = False
      ExplicitLeft = 635
    end
    inherited cxLabel2: TcxLabel
      Left = 720
      Visible = False
      ExplicitLeft = 720
    end
    object cxLabel4: TcxLabel
      Left = 18
      Top = 6
      Caption = #1058#1086#1074#1072#1088':'
    end
    object edGoods: TcxButtonEdit
      Left = 57
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 340
    end
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_CheckTaxDialogForm'
      FormNameParam.Value = 'TReport_CheckTaxDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DocumentTaxKindId'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DocumentTaxKindName'
          Value = ''
          Component = GuidesGoods
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
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
    StoredProcName = 'Report_CheckTaxCorrective_NPP'
    Params = <
      item
        Name = 'inMovementId'
        Value = 41640d
        Component = FormParams
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
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
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
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
        Component = GuidesGoods
      end>
    Left = 184
    Top = 136
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoods_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoods_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 272
    Top = 8
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'GoodsId'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end>
    Left = 344
    Top = 176
  end
end
