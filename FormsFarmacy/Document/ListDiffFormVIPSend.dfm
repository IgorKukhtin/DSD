inherited ListDiffFormVIPSendForm: TListDiffFormVIPSendForm
  Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' VIP '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1081' '
  ClientHeight = 316
  ClientWidth = 820
  AddOnFormData.Params = FormParams
  ExplicitWidth = 836
  ExplicitHeight = 355
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 58
    Width = 820
    Height = 258
    ExplicitTop = 58
    ExplicitWidth = 820
    ExplicitHeight = 258
    ClientRectBottom = 258
    ClientRectRight = 820
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 820
      ExplicitHeight = 258
      inherited cxGrid: TcxGrid
        Width = 820
        Height = 258
        ExplicitWidth = 820
        ExplicitHeight = 258
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object UnitName: TcxGridDBColumn
            Caption = #1040#1087#1090#1077#1082#1072
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 127
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1080#1087#1099' '#1091#1089#1090#1072#1085#1086#1074#1086#1082' '#1076#1083#1103' '#1087#1086#1095#1090#1099
            Options.Editing = False
            Width = 158
          end
          object DiffKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1086#1090#1082#1072#1079#1072
            DataBinding.FieldName = 'DiffKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 103
          end
          object Amount: TcxGridDBColumn
            Caption = #1047#1072#1082#1072#1079#1072#1085#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
          object UnitSendName: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100' '#1089' '#1072#1087#1090#1077#1082#1080
            DataBinding.FieldName = 'UnitSendName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actListDiffFormVIPSendRemain
                Default = True
                Kind = bkEllipsis
              end
              item
                Action = actSetDefaultParams
                Kind = bkGlyph
              end>
            Properties.Images = dmMain.ImageList
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1091#1089#1090#1072#1085#1086#1074#1086#1082' '#1076#1083#1103' '#1087#1086#1095#1090#1099
            Width = 115
          end
          object AmountSend: TcxGridDBColumn
            Caption = #1055#1077#1088#1077#1084#1077#1089#1090#1080#1090#1100' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086
            DataBinding.FieldName = 'AmountSend'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 98
          end
          object isUrgently: TcxGridDBColumn
            Caption = #1057#1088#1086#1095#1085#1086
            DataBinding.FieldName = 'isUrgently'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 64
          end
          object isOrder: TcxGridDBColumn
            Caption = #1042' '#1079#1072#1082#1072#1079
            DataBinding.FieldName = 'isOrder'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 62
          end
        end
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 820
    Height = 32
    Align = alTop
    TabOrder = 5
    object cxLabel4: TcxLabel
      Left = 8
      Top = 7
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object ceUnit: TcxButtonEdit
      Left = 98
      Top = 6
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1072#1087#1090#1077#1082#1091'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 1
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1072#1087#1090#1077#1082#1091'>'
      Width = 252
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = UnitGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
  end
  inherited ActionList: TActionList
    object actListDiffFormVIPSendRemain: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'ExecuteDialog1'
      FormName = 'TListDiffFormVIPSendRemainForm'
      FormNameParam.Value = 'TListDiffFormVIPSendRemainForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsCode'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AmountDiff'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Amount'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitSendId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitSendId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitSendName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitSendName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'AmountSend'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AmountSend'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actSetDefaultParams: TdsdSetDefaultParams
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' '#1072#1087#1090#1077#1082#1091
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' '#1072#1087#1090#1077#1082#1091
      ImageIndex = 52
      DefaultParams = <
        item
          Param.Value = Null
          Param.Component = MasterCDS
          Param.ComponentItem = 'UnitSendId'
          Param.MultiSelectSeparator = ','
          Value = Null
        end
        item
          Param.Value = Null
          Param.Component = MasterCDS
          Param.ComponentItem = 'UnitSendName'
          Param.MultiSelectSeparator = ','
          Value = Null
        end
        item
          Param.Value = Null
          Param.Component = MasterCDS
          Param.ComponentItem = 'AmountSend'
          Param.MultiSelectSeparator = ','
          Value = '0'
        end>
    end
    object actDataToJsonAction: TdsdDataToJsonAction
      Category = 'DSDLib'
      MoveParams = <>
      View = cxGridDBTableView
      JsonParam.Name = 'Json'
      JsonParam.Value = Null
      JsonParam.Component = FormParams
      JsonParam.ComponentItem = 'Json'
      JsonParam.DataType = ftWideString
      JsonParam.MultiSelectSeparator = ','
      PairParams = <
        item
          FieldName = 'Id'
          PairName = 'Id'
        end
        item
          FieldName = 'MovementId'
          PairName = 'MovementId'
        end
        item
          FieldName = 'UnitId'
          PairName = 'UnitId'
        end
        item
          FieldName = 'UnitSendId'
          PairName = 'UnitSendId'
        end
        item
          FieldName = 'AmountSend'
          PairName = 'AmountSend'
        end
        item
          FieldName = 'isUrgently'
          PairName = 'isUrgently'
        end
        item
          FieldName = 'isOrder'
          PairName = 'isOrder'
        end>
      Caption = 'actDataToJsonAction'
    end
    object actExecSPCreateVIPSend: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actDataToJsonAction
      PostDataSetBeforeExecute = False
      StoredProc = spCreateVIPSend
      StoredProcList = <
        item
          StoredProc = spCreateVIPSend
        end>
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' VIP '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1080' '#1086#1073#1088#1072#1073#1086#1090#1072#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1074' '#1079#1072#1082#1072#1079
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' VIP '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1080' '#1086#1073#1088#1072#1073#1086#1090#1072#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1074' '#1079#1072#1082#1072#1079
      ImageIndex = 80
    end
  end
  inherited MasterDS: TDataSource
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_ListDiffFormVIPSend'
    Params = <
      item
        Name = 'inUnitId'
        Value = '0'
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 80
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 80
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
    object bbLabel: TdxBarControlContainerItem
      Caption = 'bbLabel'
      Category = 0
      Hint = 'bbLabel'
      Visible = ivAlways
    end
    object bbGuides: TdxBarControlContainerItem
      Caption = 'bbGuides'
      Category = 0
      Hint = 'bbGuides'
      Visible = ivAlways
    end
    object bbShowAll: TdxBarButton
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Category = 0
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Visible = ivAlways
      ImageIndex = 63
    end
    object bbInsertUpdate: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1086#1074#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1085#1086#1074#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077
      Visible = ivAlways
      ImageIndex = 27
    end
    object dxBarButton1: TdxBarButton
      Action = actExecSPCreateVIPSend
      Category = 0
    end
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    Key = '0'
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 8
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = UnitGuides
      end>
    Left = 104
    Top = 152
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'UnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Json'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 152
  end
  object spCreateVIPSend: TdsdStoredProc
    StoredProcName = 'gpInsert_Movement_ListDiffVIPSend'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inJson'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Json'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 320
    Top = 152
  end
end
