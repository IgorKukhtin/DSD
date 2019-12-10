inherited Report_GoodsNotSalePastForm: TReport_GoodsNotSalePastForm
  Caption = #1058#1086#1074#1072#1088#1099' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078
  ClientHeight = 375
  ClientWidth = 690
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 706
  ExplicitHeight = 414
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 67
    Width = 690
    Height = 308
    TabOrder = 3
    ExplicitTop = 67
    ExplicitWidth = 686
    ExplicitHeight = 308
    ClientRectBottom = 308
    ClientRectRight = 690
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 686
      ExplicitHeight = 308
      inherited cxGrid: TcxGrid
        Width = 690
        Height = 308
        ExplicitWidth = 686
        ExplicitHeight = 308
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1079#1072#1087#1080#1089#1077#1081' 0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = Remains
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 182
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 71
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 142
          end
          object Remains: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Remains'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Options.Editing = False
            Width = 87
          end
          object InvNumber: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 61
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 67
          end
          object PriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'PriceWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object SumWithVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'SumWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 690
    Height = 41
    ExplicitWidth = 686
    ExplicitHeight = 41
    inherited deStart: TcxDateEdit
      Left = 459
      Top = 37
      Visible = False
      ExplicitLeft = 459
      ExplicitTop = 37
    end
    inherited deEnd: TcxDateEdit
      Left = 668
      Top = 37
      Visible = False
      ExplicitLeft = 668
      ExplicitTop = 37
    end
    inherited cxLabel1: TcxLabel
      Left = 368
      Top = 38
      Visible = False
      ExplicitLeft = 368
      ExplicitTop = 38
    end
    inherited cxLabel2: TcxLabel
      Left = 558
      Top = 38
      Visible = False
      ExplicitLeft = 558
      ExplicitTop = 38
    end
    object cxLabel4: TcxLabel
      Left = 16
      Top = 9
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object edUnit: TcxButtonEdit
      Left = 101
      Top = 7
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 184
    end
    object ceNotSalePastDay: TcxCurrencyEdit
      Left = 479
      Top = 7
      EditValue = 100.000000000000000000
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      TabOrder = 6
      Width = 90
    end
    object cxLabel6: TcxLabel
      Left = 315
      Top = 9
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078':'
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = GuidesUnit
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_GoodsNotSalePastDialogForm'
      FormNameParam.Value = 'TReport_GoodsNotSalePastDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Day'
          Value = Null
          Component = ceNotSalePastDay
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 296
    Top = 152
  end
  inherited MasterCDS: TClientDataSet
    Left = 192
    Top = 144
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_GoodsNotSalePast'
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountDay'
        Value = 41395d
        Component = ceNotSalePastDay
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 376
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 448
    Top = 168
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
          ItemName = 'bbExecuteDialog'
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
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Top = 104
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 80
    Top = 152
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 232
    Top = 24
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Day'
        Value = Null
        Component = ceNotSalePastDay
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 264
  end
end
