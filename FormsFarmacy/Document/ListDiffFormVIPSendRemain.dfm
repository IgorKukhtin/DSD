inherited ListDiffFormVIPSendRemainForm: TListDiffFormVIPSendRemainForm
  Caption = #1053#1072#1083#1080#1095#1080#1077' '#1084#1077#1076#1080#1082#1072#1084#1077#1085#1090#1072' '#1087#1086' '#1072#1087#1090#1077#1082#1072#1084' l'#1076#1083#1103' '#1089#1086#1079#1076#1072#1085#1080#1103' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103
  ClientHeight = 407
  ClientWidth = 676
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitWidth = 692
  ExplicitHeight = 446
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 676
    Height = 348
    ExplicitTop = 59
    ExplicitWidth = 587
    ExplicitHeight = 348
    ClientRectBottom = 348
    ClientRectRight = 676
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 587
      ExplicitHeight = 348
      inherited cxGrid: TcxGrid
        Width = 676
        Height = 348
        ExplicitWidth = 587
        ExplicitHeight = 348
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
          object ExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'ExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 93
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
          object AmountSend: TcxGridDBColumn
            Caption = #1042' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
            DataBinding.FieldName = 'AmountSend'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 72
          end
        end
      end
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 676
    Height = 33
    Align = alTop
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 5
    ExplicitWidth = 587
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
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 219
    Top = 184
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 32
  end
  inherited ActionList: TActionList
    Left = 119
    Top = 191
    object actFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'UnitSendId'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'UnitId'
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'UnitSendId'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'UnitSendId'
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Name = 'UnitSendName'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'UnitName'
          FromParam.DataType = ftString
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'UnitSendName'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'UnitSendName'
          ToParam.DataType = ftString
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Name = 'AmountSend'
          FromParam.Value = Null
          FromParam.Component = MasterCDS
          FromParam.ComponentItem = 'AmountSend'
          FromParam.DataType = ftFloat
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'AmountSend'
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'AmountSend'
          ToParam.DataType = ftFloat
          ToParam.MultiSelectSeparator = ','
        end>
      PostDataSetBeforeExecute = False
      ModalResult = 1
      Caption = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100' '#1089' '#1072#1087#1090#1077#1082#1080
      Hint = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100' '#1089' '#1072#1087#1090#1077#1082#1080
      ShortCut = 13
      ImageIndex = 7
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
    StoredProcName = 'gpSelect_ListDiffFormVIPSendRemain'
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountDiff'
        Value = Null
        Component = FormParams
        ComponentItem = 'AmountDiff'
        DataType = ftFloat
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
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton3'
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
        end>
    end
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
      Caption = #1054#1089#1090#1072#1074#1080#1090#1100' '#1079#1072#1103#1074#1082#1091' '#1085#1072' '#1074#1086#1079#1084#1086#1078#1085#1086#1089#1090#1100' '#1079#1072#1082#1072#1079#1072' '#1073#1072#1079' '#1082#1086#1085#1090#1088#1086#1083#1103
      Category = 0
      Hint = #1054#1089#1090#1072#1074#1080#1090#1100' '#1079#1072#1103#1074#1082#1091' '#1085#1072' '#1074#1086#1079#1084#1086#1078#1085#1086#1089#1090#1100' '#1079#1072#1082#1072#1079#1072' '#1073#1072#1079' '#1082#1086#1085#1090#1088#1086#1083#1103
      Visible = ivAlways
      ImageIndex = 80
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton3: TdxBarButton
      Action = actFormClose
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actFormClose
      end>
    Left = 408
    Top = 216
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UnitId'
        Value = Null
        MultiSelectSeparator = ','
      end
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
        Name = 'AmountDiff'
        Value = Null
        Component = edAmount
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitSendId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitSendName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'AmountSend'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 104
  end
end
