inherited InventoryPartionForm: TInventoryPartionForm
  Caption = '<'#1055#1072#1088#1090#1080#1080' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1080'>'
  ClientHeight = 658
  ClientWidth = 898
  ExplicitWidth = 914
  ExplicitHeight = 696
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 77
    Width = 898
    Height = 581
    ExplicitTop = 77
    ExplicitWidth = 898
    ExplicitHeight = 581
    ClientRectBottom = 581
    ClientRectRight = 898
    inherited tsMain: TcxTabSheet
      Caption = #1055#1072#1088#1090#1080#1080
      ExplicitWidth = 898
      ExplicitHeight = 557
      inherited cxGrid: TcxGrid
        Width = 898
        Height = 557
        ExplicitWidth = 898
        ExplicitHeight = 557
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmountDeficit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clSummAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = clAmount
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = colName
            end>
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colCode: TcxGridDBColumn [0]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 49
          end
          object colName: TcxGridDBColumn [1]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 214
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentVert = vaCenter
          end
          object clJuridicalPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'JuridicalPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object clAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1080#1079#1083#1080#1096#1077#1082
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 80
          end
          object clAmountDeficit: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1085#1077#1076#1086#1089#1090'.'
            DataBinding.FieldName = 'AmountDeficit'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 80
          end
          object clSummAmount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'SummAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 80
          end
          object PartionDescName: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' '#1042#1080#1076
            DataBinding.FieldName = 'PartionDescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PartionInvNumber: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' '#8470
            DataBinding.FieldName = 'PartionInvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PartionOperDate: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' '#1044#1072#1090#1072
            DataBinding.FieldName = 'PartionOperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PartionPriceDescName: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' '#1089'/'#1089' '#1042#1080#1076
            DataBinding.FieldName = 'PartionPriceDescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object PartionPriceInvNumber: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' '#1089'/'#1089' '#8470
            DataBinding.FieldName = 'PartionPriceInvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PartionPriceOperDate: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' '#1089'/'#1089' '#1044#1072#1090#1072
            DataBinding.FieldName = 'PartionPriceOperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 898
    Height = 51
    TabOrder = 3
    ExplicitWidth = 898
    ExplicitHeight = 51
    inherited edInvNumber: TcxTextEdit
      Left = 8
      Enabled = False
      ExplicitLeft = 8
      ExplicitWidth = 74
      Width = 74
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 89
      Enabled = False
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 89
      ExplicitWidth = 88
      Width = 88
    end
    inherited cxLabel2: TcxLabel
      Left = 89
      ExplicitLeft = 89
    end
    inherited cxLabel15: TcxLabel
      Left = 607
      ExplicitLeft = 607
    end
    inherited ceStatus: TcxButtonEdit
      Left = 607
      Enabled = False
      ExplicitLeft = 607
      ExplicitWidth = 154
      ExplicitHeight = 22
      Width = 154
    end
    object cxLabel3: TcxLabel
      Left = 179
      Top = 5
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object edUnit: TcxButtonEdit
      Left = 179
      Top = 23
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 270
    end
    object chbFullInvent: TcxCheckBox
      Left = 455
      Top = 23
      Caption = #1055#1086#1083#1085#1072#1103' '#1080#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
      Enabled = False
      ParentShowHint = False
      Properties.ReadOnly = True
      ShowHint = True
      TabOrder = 8
      Width = 146
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 83
    Top = 144
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 24
    Top = 144
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end
        item
        end
        item
        end>
      RefreshOnTabSetChanges = True
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProc = spGetTotalSumm
      StoredProcList = <
        item
          StoredProc = spGetTotalSumm
        end>
    end
    inherited actPrint: TdsdPrintAction
      StoredProcList = <
        item
        end>
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
      ReportNameParam.Value = #1048#1085#1074#1077#1085#1090#1072#1088#1080#1079#1072#1094#1080#1103
      ReportNameParam.ParamType = ptInput
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    object actStorageChoice: TOpenChoiceForm [13]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StorageChoice'
      FormName = 'TStoragePlace_ObjectForm'
      FormNameParam.Value = 'TStoragePlace_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actAssetChoice: TOpenChoiceForm [14]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'AssetChoice'
      FormName = 'TAssetForm'
      FormNameParam.Value = 'TAssetForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AssetId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'AssetName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actSelect: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = 'actSelect'
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 512
  end
  inherited MasterCDS: TClientDataSet
    Left = 88
    Top = 512
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_InventoryPartion'
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
        Name = 'ffff'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'ffff'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'ffff'
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'ffff'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 248
  end
  inherited BarManager: TdxBarManager
    Left = 88
    Top = 207
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
          ItemName = 'bbGridToExcel'
        end>
    end
    inherited bbShowErased: TdxBarButton
      Action = nil
    end
    inherited bbAddMask: TdxBarButton
      Action = nil
      Visible = ivNever
    end
    inherited bbMovementItemContainer: TdxBarButton
      Action = nil
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
        DataSummaryItemIndex = 5
      end>
    Left = 558
    Top = 161
  end
  inherited PopupMenu: TPopupMenu
    Left = 568
    Top = 416
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
    end
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
        Name = 'ReportNameInventory'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameInventoryTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameInventoryBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'FullInvent'
        Value = Null
        Component = chbFullInvent
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 320
    Top = 168
  end
  inherited StatusGuides: TdsdGuides
    Left = 832
    Top = 16
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Inventory'
    Left = 768
    Top = 8
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Inventory'
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
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FullInvent'
        Value = ''
        Component = FormParams
        ComponentItem = 'FullInvent'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 0d
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 224
    Top = 256
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
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
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFullInvent'
        Value = ''
        Component = FormParams
        ComponentItem = 'FullInvent'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = 0d
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 'False'
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesUnit
      end
      item
      end>
    ActionItemList = <
      item
      end
      item
      end>
    Left = 160
    Top = 192
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
      end
      item
      end
      item
        Control = edOperDate
      end
      item
      end
      item
        Control = edUnit
      end
      item
        Control = chbFullInvent
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 232
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 640
    Top = 216
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Inventory_SetErased'
    Left = 486
    Top = 464
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_Inventory_SetUnErased'
    Left = 486
    Top = 416
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Inventory'
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
        Name = 'ioAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInputOutput
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
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MIComment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSumma'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Summ'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outRemains'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Remains_Amount'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDeficit'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Deficit'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDeficitSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DeficitSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outProficit'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Proficit'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outProficitSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ProficitSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDiff'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Diff'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDiffSumm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DiffSumm'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 368
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_TotalSummInventory'
    Left = 420
    Top = 188
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    ComponentList = <>
    Left = 512
    Top = 328
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 788
    Top = 177
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 246
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
    Left = 360
    Top = 8
  end
end
