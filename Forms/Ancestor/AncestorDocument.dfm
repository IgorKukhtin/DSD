inherited AncestorDocumentForm: TAncestorDocumentForm
  Caption = #1055#1088#1086#1090#1086#1082#1086#1083' <'#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
  ClientHeight = 416
  ClientWidth = 829
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitWidth = 845
  ExplicitHeight = 455
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 86
    Width = 829
    Height = 330
    TabOrder = 5
    ExplicitTop = 60
    ExplicitWidth = 829
    ExplicitHeight = 356
    ClientRectBottom = 330
    ClientRectRight = 829
    ClientRectTop = 24
    inherited tsMain: TcxTabSheet
      Caption = #1057#1090#1088#1086#1095#1085#1072#1103' '#1095#1072#1089#1090#1100
      TabVisible = True
      ExplicitTop = 24
      ExplicitWidth = 829
      ExplicitHeight = 332
      inherited cxGrid: TcxGrid
        Width = 829
        Height = 306
        ExplicitWidth = 829
        ExplicitHeight = 332
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colIsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isErased'
            Visible = False
            Options.Editing = False
            Width = 50
          end
        end
      end
    end
  end
  object DataPanel: TPanel [1]
    Left = 0
    Top = 0
    Width = 829
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    object edInvNumber: TcxTextEdit
      Left = 170
      Top = 23
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 90
    end
    object cxLabel1: TcxLabel
      Left = 170
      Top = 5
      Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edOperDate: TcxDateEdit
      Left = 270
      Top = 23
      EditValue = 42132d
      TabOrder = 2
      Width = 100
    end
    object cxLabel2: TcxLabel
      Left = 270
      Top = 5
      Caption = #1044#1072#1090#1072
    end
    object cxLabel15: TcxLabel
      Left = 8
      Top = 5
      Caption = #1057#1090#1072#1090#1091#1089
    end
    object ceStatus: TcxButtonEdit
      Left = 8
      Top = 23
      Properties.Buttons = <
        item
          Action = actCompleteMovement
          Default = True
          Kind = bkGlyph
        end
        item
          Action = actUnCompleteMovement
          Kind = bkGlyph
        end
        item
          Action = actDeleteMovement
          Kind = bkGlyph
        end>
      Properties.Images = dmMain.ImageList
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 152
    end
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect
        end>
    end
    inherited actGridToExcel: TdsdGridToExcel
      TabSheet = tsMain
    end
    object actMISetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      Hint = #1059#1076#1072#1083#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080'?'
    end
    object actMISetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spUnErasedMIMaster
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object actInsertUpdateMovement: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMovement
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end>
      Caption = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1057#1086#1093#1088#1072#1085#1077#1085#1080#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 14
      ShortCut = 113
    end
    object actShowErased: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082' '#1080#1079' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object actUpdateMainDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMIMaster
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spGetTotalSumm
        end>
      Caption = 'actUpdateMainDS'
      DataSource = MasterDS
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <>
      Params = <>
      ReportName = #1055#1088#1080#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
      ReportNameParam.Value = ''
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actUnCompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end>
      Caption = 'UnCompleteMovement'
      ImageIndex = 11
      Status = mtUncomplete
      Guides = StatusGuides
    end
    object actCompleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end>
      Caption = 'CompleteMovement'
      ImageIndex = 12
      Status = mtComplete
      Guides = StatusGuides
    end
    object actDeleteMovement: TChangeGuidesStatus
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spChangeStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end>
      Caption = 'DeleteMovement'
      ImageIndex = 13
      Status = mtDelete
      Guides = StatusGuides
    end
    object actMovementItemContainer: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1074#1086#1076#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1074#1086#1076#1082#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 57
      FormName = 'TMovementItemContainerForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object MovementItemProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementItemProtocolForm'
      FormNameParam.Value = 'TMovementItemProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object MultiAction: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actFormClose
        end
        item
          Action = actNewDocument
        end>
      Caption = #1053#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1053#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 29
      ShortCut = 16462
    end
    object actNewDocument: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1053#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      Hint = #1053#1086#1074#1099#1081' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      IdFieldName = 'Id'
    end
    object actFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
    object actAddMask: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertMaskMIMaster
      StoredProcList = <
        item
          StoredProc = spInsertMaskMIMaster
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1086' '#1084#1072#1089#1082#1077
      ImageIndex = 54
    end
  end
  inherited MasterDS: TDataSource
    Left = 40
    Top = 176
  end
  inherited MasterCDS: TClientDataSet
    Left = 8
    Top = 176
  end
  inherited spSelect: TdsdStoredProc
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = FormParams
        ComponentItem = 'ShowAll'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 176
  end
  inherited BarManager: TdxBarManager
    Left = 104
    Top = 175
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
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddMask'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
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
          ItemName = 'bbMovementItemContainer'
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
          ItemName = 'bbPrint'
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
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Visible = ivAlways
    end
    object bbInsertUpdateMovement: TdxBarButton
      Action = actInsertUpdateMovement
      Category = 0
    end
    object bbErased: TdxBarButton
      Action = actMISetErased
      Category = 0
    end
    object bbUnErased: TdxBarButton
      Action = actMISetUnErased
      Category = 0
    end
    object bbShowErased: TdxBarButton
      Action = actShowErased
      Category = 0
    end
    object bbAddMask: TdxBarButton
      Action = actAddMask
      Category = 0
    end
    object bbMovementItemContainer: TdxBarButton
      Action = actMovementItemContainer
      Category = 0
    end
    object bbMovementItemProtocol: TdxBarButton
      Action = MovementItemProtocolOpenForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = -1
      end>
    Left = 318
    Top = 169
  end
  object FormParams: TdsdFormParams
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
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 264
  end
  object StatusGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceStatus
    FormNameParam.Value = ''
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 136
    Top = 176
  end
  object spChangeStatus: TdsdStoredProc
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 168
    Top = 176
  end
  object spGet: TdsdStoredProc
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 152
    Top = 232
  end
  object spInsertUpdateMovement: TdsdStoredProc
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 194
    Top = 256
  end
  object GuidesFiller: TGuidesFiller
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    GuidesList = <>
    ActionItemList = <
      item
        Action = actInsertUpdateMovement
      end>
    Left = 232
    Top = 176
  end
  object HeaderSaver: THeaderSaver
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    StoredProc = spInsertUpdateMovement
    ControlList = <
      item
        Control = edOperDate
      end>
    GetStoredProc = spGet
    Left = 248
    Top = 185
  end
  object RefreshAddOn: TRefreshAddOn
    DataSet = 'ClientDataSet'
    KeyField = 'Id'
    RefreshAction = 'actRefresh'
    FormParams = 'FormParams'
    Left = 256
    Top = 240
  end
  object spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpSetErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 326
    Top = 216
  end
  object spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpSetUnErased_MovementItem'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsErased'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isErased'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 358
    Top = 224
  end
  object spInsertUpdateMIMaster: TdsdStoredProc
    DataSets = <>
    OutputType = otResult
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
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 384
    Top = 240
  end
  object spInsertMaskMIMaster: TdsdStoredProc
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = '0'
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
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 392
    Top = 288
  end
  object spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TotalSumm'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSumm'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 436
    Top = 156
  end
end
