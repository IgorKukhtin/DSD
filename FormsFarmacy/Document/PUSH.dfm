inherited PUSHForm: TPUSHForm
  Caption = 'PUSH '#1089#1086#1086#1073#1097#1077#1085#1080't '#1076#1083#1103' '#1082#1072#1089#1089#1080#1088#1086#1074
  ClientHeight = 500
  ClientWidth = 638
  AddOnFormData.AddOnFormRefresh.ParentList = 'PUSH'
  ExplicitWidth = 654
  ExplicitHeight = 539
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 153
    Width = 638
    Height = 347
    ExplicitTop = 153
    ExplicitWidth = 638
    ExplicitHeight = 347
    ClientRectBottom = 347
    ClientRectRight = 638
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 638
      ExplicitHeight = 323
      inherited cxGrid: TcxGrid
        Width = 638
        Height = 323
        ExplicitWidth = 638
        ExplicitHeight = 323
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsBehavior.IncSearch = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object UserCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'UserCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
          object UserName: TcxGridDBColumn
            AlternateCaption = 'UserName'
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 282
          end
          object DateViewed: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103' '#1087#1088#1086#1089#1084#1086#1090#1088#1072
            DataBinding.FieldName = 'DateViewed'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.Kind = ckDateTime
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 170
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 638
    Height = 127
    TabOrder = 3
    ExplicitWidth = 638
    ExplicitHeight = 127
    inherited edInvNumber: TcxTextEdit
      Left = 8
      Top = 62
      ExplicitLeft = 8
      ExplicitTop = 62
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      Top = 43
      ExplicitLeft = 8
      ExplicitTop = 43
    end
    inherited edOperDate: TcxDateEdit
      Left = 8
      Top = 101
      Properties.Kind = ckDateTime
      ExplicitLeft = 8
      ExplicitTop = 101
      ExplicitWidth = 152
      Width = 152
    end
    inherited cxLabel2: TcxLabel
      Left = 8
      Top = 83
      ExplicitLeft = 8
      ExplicitTop = 83
    end
    inherited cxLabel15: TcxLabel
      Top = 4
      ExplicitTop = 4
    end
    inherited ceStatus: TcxButtonEdit
      Top = 22
      ExplicitTop = 22
      ExplicitHeight = 22
    end
    object cxLabel3: TcxLabel
      Left = 184
      Top = 4
      Caption = #1058#1077#1082#1089#1090' '#1089#1086#1086#1073#1097#1077#1085#1080#1103
    end
    object edMessage: TcxDBMemo
      Left = 184
      Top = 27
      DataBinding.DataField = 'Message'
      DataBinding.DataSource = MessageDS
      TabOrder = 7
      Height = 100
      Width = 441
    end
  end
  inherited ActionList: TActionList
    inherited actShowAll: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end>
    end
    inherited actPrint: TdsdPrintAction
      StoredProcList = <
        item
        end>
      DataSets = <
        item
          UserName = 'frxDBDHeader'
        end
        item
          UserName = 'frxDBDMaster'
        end>
      ReportName = #1050#1086#1084#1084#1077#1088#1095#1077#1089#1082#1086#1077' '#1087#1088#1077#1076#1083#1086#1078#1077#1085#1080#1077
      ReportNameParam.Value = #1050#1086#1084#1084#1077#1088#1095#1077#1089#1082#1086#1077' '#1087#1088#1077#1076#1083#1086#1078#1077#1085#1080#1077
    end
  end
  inherited MasterDS: TDataSource
    Top = 224
  end
  inherited MasterCDS: TClientDataSet
    Top = 224
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_PUSH'
    Left = 64
    Top = 224
  end
  inherited BarManager: TdxBarManager
    Left = 96
    Top = 223
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
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
          ItemName = 'dxBarStatic'
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
          ItemName = 'bbMovementItemProtocol'
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
    inherited bbPrint: TdxBarButton
      Action = nil
    end
    object bbPrintCheck: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      Visible = ivAlways
      ImageIndex = 15
    end
    object bbGet_SP_Prior: TdxBarButton
      Caption = #1040#1042#1058#1054#1047#1040#1055#1054#1051#1053#1048#1058#1068
      Category = 0
      Visible = ivAlways
      ImageIndex = 74
    end
    object dxBarButton1: TdxBarButton
      Caption = 'actPrintXLSScope'
      Category = 0
      Visible = ivAlways
      ImageIndex = 3
    end
    object dxBarButton2: TdxBarButton
      Caption = #1042#1089#1090#1072#1074#1082#1072' '#1074' '#1079#1072#1082#1072#1079
      Category = 0
      Hint = #1042#1089#1090#1072#1074#1082#1072' '#1074' '#1079#1072#1082#1072#1079
      Visible = ivAlways
      ImageIndex = 0
    end
    object dxBarButton3: TdxBarButton
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1087#1088#1086#1076#1072#1078#1091
      Category = 0
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1087#1088#1086#1076#1072#1078#1091
      Visible = ivAlways
      ImageIndex = 43
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 0
      end>
    SearchAsFilter = False
    Top = 241
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 328
  end
  inherited StatusGuides: TdsdGuides
    Top = 232
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_PUSH'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Top = 232
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_PUSH'
    Left = 176
    Top = 272
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_PUSH'
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 282
    Top = 272
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
      end
      item
      end>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end
      item
        Action = actRefresh
      end>
    Left = 248
    Top = 240
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edOperDate
      end
      item
        Control = edInvNumber
      end
      item
      end>
    Left = 208
    Top = 233
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 32
    Top = 384
  end
  inherited spErasedMIMaster: TdsdStoredProc
    Left = 534
    Top = 232
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    Left = 534
    Top = 296
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_PUSH'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsNameUkr'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsNameUkr'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountOrder'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountOrder'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summ'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSummOrder'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SummOrder'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCodeUKTZED'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CodeUKTZED'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inExchangeId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ExchangeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 424
    Top = 232
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 448
    Top = 368
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_PUSH_TotalSumm'
    DataSet = MessageCDS
    DataSets = <
      item
        DataSet = MessageCDS
      end>
    OutputType = otDataSet
    Left = 284
    Top = 348
  end
  object MessageDS: TDataSource
    DataSet = MessageCDS
    Left = 312
    Top = 400
  end
  object MessageCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 280
    Top = 400
  end
end
