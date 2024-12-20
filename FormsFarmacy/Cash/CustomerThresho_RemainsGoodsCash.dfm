inherited CustomerThresho_RemainsGoodsCashForm: TCustomerThresho_RemainsGoodsCashForm
  Caption = #1053#1072#1083#1080#1095#1080#1077' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1072' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084
  ClientHeight = 407
  ClientWidth = 525
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitWidth = 541
  ExplicitHeight = 446
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 83
    Width = 525
    Height = 324
    ExplicitTop = 95
    ExplicitWidth = 525
    ExplicitHeight = 312
    ClientRectBottom = 324
    ClientRectRight = 525
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 525
      ExplicitHeight = 312
      inherited cxGrid: TcxGrid
        Width = 525
        Height = 324
        ExplicitWidth = 525
        ExplicitHeight = 312
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object UnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'UnitCode'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 336
          end
          object Amount: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 69
          end
        end
      end
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 525
    Height = 57
    Align = alTop
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 5
    object cxLabel1: TcxLabel
      Left = 16
      Top = 4
      Caption = #1058#1086#1074#1072#1088
    end
    object edGoodsName: TcxTextEdit
      Left = 64
      Top = 2
      TabOrder = 1
      Text = 'edGoodsName'
      Width = 249
    end
    object cxLabel2: TcxLabel
      Left = 328
      Top = 3
      Caption = #1047#1072#1082#1072#1079
    end
    object edAmount: TcxCurrencyEdit
      Left = 367
      Top = 2
      Properties.DecimalPlaces = 3
      Properties.DisplayFormat = ',0.###;-,0.###; ;'
      TabOrder = 3
      Width = 66
    end
    object cxLabel3: TcxLabel
      Left = 16
      Top = 27
      Caption = #1047#1072#1082#1072#1079#1099#1074#1072#1077#1084#1099#1081' '#1090#1086#1074#1072#1088' '#1077#1089#1090#1100' '#1074' '#1085#1072#1083#1080#1095#1080#1080' '#1087#1086' '#1076#1088#1091#1075#1080#1084' '#1072#1087#1090#1077#1082#1072#1084'.'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -12
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = []
      Style.IsFontAssigned = True
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 219
    Top = 216
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 32
  end
  inherited ActionList: TActionList
    Left = 119
    Top = 191
    object dsdExecStoredProc1: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSetRequestDistribListDiff
      StoredProcList = <
        item
          StoredProc = spSetRequestDistribListDiff
        end>
      Caption = #1054#1089#1090#1072#1074#1080#1090#1100' '#1079#1072#1103#1074#1082#1091' '#1085#1072' '#1074#1086#1079#1084#1086#1078#1085#1086#1089#1090#1100' '#1079#1072#1082#1072#1079#1072' '#1073#1072#1079' '#1082#1086#1085#1090#1088#1086#1083#1103
      Hint = #1054#1089#1090#1072#1074#1080#1090#1100' '#1079#1072#1103#1074#1082#1091' '#1085#1072' '#1074#1086#1079#1084#1086#1078#1085#1086#1089#1090#1100' '#1079#1072#1082#1072#1079#1072' '#1073#1072#1079' '#1082#1086#1085#1090#1088#1086#1083#1103
      ImageIndex = 80
      QuestionBeforeExecute = #1054#1089#1090#1072#1074#1080#1090#1100' '#1079#1072#1103#1074#1082#1091' '#1085#1072' '#1074#1086#1079#1084#1086#1078#1085#1086#1089#1090#1100' '#1079#1072#1082#1072#1079#1072' '#1073#1072#1079' '#1082#1086#1085#1090#1088#1086#1083#1103'?'
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 184
  end
  inherited MasterCDS: TClientDataSet
    Left = 32
    Top = 104
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_CustomerThresho_RemainsGoodsCash'
    Params = <
      item
        Name = 'inGoodsId'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 104
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 104
    DockControlHeights = (
      0
      0
      26
      0)
    inherited bbRefresh: TdxBarButton
      Left = 280
    end
    inherited dxBarStatic: TdxBarStatic
      Left = 208
      Top = 65528
    end
    inherited bbGridToExcel: TdxBarButton
      Left = 232
    end
    object bbOpen: TdxBarButton
      Caption = #1054#1090#1082#1088#1099#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      Left = 160
    end
    object dxBarButton1: TdxBarButton
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1072#1083#1080#1095#1080#1077' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      Category = 0
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1072#1083#1080#1095#1080#1077' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
      Visible = ivAlways
      ImageIndex = 28
      ShortCut = 13
    end
    object dxBarButton2: TdxBarButton
      Action = dsdExecStoredProc1
      Category = 0
      PaintStyle = psCaptionGlyph
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
      end>
    Left = 368
    Top = 208
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'GoodsId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsCode'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = Null
        Component = edGoodsName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Amount'
        Value = Null
        Component = edAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 104
  end
  object spSetRequestDistribListDiff: TdsdStoredProc
    StoredProcName = 'gpUpdate_Unit_SetRequestDistribListDiffCash'
    DataSets = <>
    OutputType = otResult
    Params = <>
    PackSize = 1
    Left = 368
    Top = 139
  end
end
