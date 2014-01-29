inherited SaleForm: TSaleForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1055#1088#1086#1076#1072#1078#1072' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102'>'
  ClientHeight = 759
  ClientWidth = 1049
  ExplicitWidth = 1057
  ExplicitHeight = 793
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 157
    Width = 1049
    Height = 602
    ExplicitTop = 157
    ExplicitWidth = 1049
    ExplicitHeight = 602
    ClientRectBottom = 598
    ClientRectRight = 1045
    inherited tsMain: TcxTabSheet
      ExplicitLeft = 2
      ExplicitWidth = 1043
      ExplicitHeight = 576
      inherited cxGrid: TcxGrid
        Width = 1043
        Height = 576
        ExplicitWidth = 1043
        ExplicitHeight = 576
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colHeadCount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountChangePercent
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountPartner
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmountSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colHeadCount
            end>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = False
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object colName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 200
          end
          object colGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object colPartionGoods: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoods'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object colAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colAmountChangePercent: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1089#1086' '#1089#1082#1080#1076#1082#1086#1081
            DataBinding.FieldName = 'AmountChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colAmountPartner: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1091' '#1082#1086#1085#1090#1088'.'
            DataBinding.FieldName = 'AmountPartner'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object colChangePercentAmount: TcxGridDBColumn
            Caption = '% '#1089#1082#1080#1076#1082#1080' '#1074#1077#1089
            DataBinding.FieldName = 'ChangePercentAmount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
          end
          object colPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colCountForPrice: TcxGridDBColumn
            Caption = #1050#1086#1083' '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object colAmountSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'AmountSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object colHeadCount: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1075#1086#1083#1086#1074
            DataBinding.FieldName = 'HeadCount'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object colAssetName: TcxGridDBColumn
            Caption = #1054#1089#1085'.'#1089#1088#1077#1076#1089#1090#1074#1072' '
            DataBinding.FieldName = 'AssetName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 65
          end
        end
      end
    end
    inherited tsEntry: TcxTabSheet
      ExplicitLeft = 2
      ExplicitTop = 22
      ExplicitWidth = 1043
      ExplicitHeight = 576
      inherited cxGridEntry: TcxGrid
        Width = 1043
        Height = 576
        ExplicitWidth = 1043
        ExplicitHeight = 576
        inherited cxGridEntryDBTableView: TcxGridDBTableView
          DataController.DataSource = EntryDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          Images = dmMain.SortImageList
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1049
    Height = 129
    TabOrder = 3
    ExplicitWidth = 1049
    ExplicitHeight = 129
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 112
      ExplicitLeft = 112
    end
    inherited cxLabel2: TcxLabel
      Left = 112
      ExplicitLeft = 112
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 63
      ExplicitTop = 63
      ExplicitHeight = 24
    end
    object cxLabel3: TcxLabel
      Left = 227
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object edFrom: TcxButtonEdit
      Left = 227
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 7
      Width = 140
    end
    object edTo: TcxButtonEdit
      Left = 374
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 8
      Width = 130
    end
    object cxLabel4: TcxLabel
      Left = 374
      Top = 5
      Caption = #1050#1086#1084#1091
    end
    object edContract: TcxButtonEdit
      Left = 598
      Top = 23
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 10
      Width = 286
    end
    object cxLabel9: TcxLabel
      Left = 598
      Top = 5
      Caption = #1044#1086#1075#1086#1074#1086#1088
    end
    object cxLabel6: TcxLabel
      Left = 512
      Top = 5
      Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
    end
    object edPaidKind: TcxButtonEdit
      Left = 512
      Top = 23
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 13
      Width = 77
    end
    object cxLabel5: TcxLabel
      Left = 166
      Top = 45
      Caption = #8470' '#1079#1072#1103#1074#1082#1080' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
    end
    object edInvNumberOrder: TcxTextEdit
      Left = 166
      Top = 63
      TabOrder = 15
      Width = 121
    end
    object edPriceWithVAT: TcxCheckBox
      Left = 288
      Top = 63
      Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 16
      Width = 137
    end
    object edVATPercent: TcxCurrencyEdit
      Left = 423
      Top = 63
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = ',0'
      TabOrder = 17
      Width = 65
    end
    object cxLabel7: TcxLabel
      Left = 423
      Top = 45
      Caption = '% '#1053#1044#1057
    end
    object edChangePercent: TcxCurrencyEdit
      Left = 502
      Top = 63
      Properties.DecimalPlaces = 3
      Properties.DisplayFormat = ',0.###'
      TabOrder = 19
      Width = 129
    end
    object cxLabel8: TcxLabel
      Left = 494
      Top = 45
      Caption = '(-)% '#1057#1082#1080#1076#1082#1080' (+)% '#1053#1072#1094#1077#1085#1082#1080
    end
    object cxLabel13: TcxLabel
      Left = 652
      Top = 46
      Caption = #1057#1086#1088#1090#1080#1088#1086#1074#1082#1072
    end
    object edRouteSorting: TcxButtonEdit
      Left = 652
      Top = 63
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 22
      Width = 121
    end
    object edOperDatePartner: TcxDateEdit
      Left = 779
      Top = 63
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 23
      Width = 108
    end
    object cxLabel10: TcxLabel
      Left = 779
      Top = 45
      Caption = #1044#1072#1090#1072' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
    end
    object edIsChecked: TcxCheckBox
      Left = 893
      Top = 63
      Caption = #1055#1088#1086#1074#1077#1088#1077#1085' ('#1076#1072'/'#1085#1077#1090')'
      TabOrder = 25
      Width = 137
    end
    object cxLabel11: TcxLabel
      Left = 890
      Top = 5
      Caption = #1055#1088#1072#1081#1089'-'#1083#1080#1089#1090
    end
    object edPriceList: TcxButtonEdit
      Left = 891
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 27
      Width = 77
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 171
    Top = 552
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 640
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    inherited actRefresh: TdsdDataSetRefresh
      RefreshOnTabSetChanges = True
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
          StoredProc = spSelectMIContainer
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
          StoredProc = spSelectMIContainer
        end>
    end
    object actGoodsKindChoice: TOpenChoiceForm [13]
      Category = 'DSDLib'
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
        end
        item
          Name = 'TextValue'
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
        end>
      isShowModal = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 512
  end
  inherited MasterCDS: TClientDataSet
    Left = 88
    Top = 520
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Sale'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inPriceListId'
        Value = ''
        Component = GuidesPricelist
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
      end>
    Left = 160
    Top = 248
  end
  inherited BarManager: TdxBarManager
    Left = 80
    Top = 207
    DockControlHeights = (
      0
      0
      28
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 782
    Top = 273
  end
  inherited PopupMenu: TPopupMenu
    Left = 800
    Top = 464
  end
  inherited EntryCDS: TClientDataSet
    Left = 629
    Top = 236
  end
  inherited EntryDS: TDataSource
    Left = 581
    Top = 236
  end
  inherited spSelectMIContainer: TdsdStoredProc
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 421
    Top = 468
  end
  inherited FormParams: TdsdFormParams
    Left = 280
    Top = 552
  end
  inherited StatusGuides: TdsdGuides
    Left = 48
    Top = 56
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Sale'
    Left = 104
    Top = 88
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Sale'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'Checked'
        Value = 'False'
        Component = edIsChecked
        DataType = ftBoolean
      end
      item
        Name = 'OperDatePartner'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
      end
      item
        Name = 'PriceWithVAT'
        Value = 'False'
        Component = edPriceWithVAT
        DataType = ftBoolean
      end
      item
        Name = 'VATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
      end
      item
        Name = 'ChangePercent'
        Value = 0.000000000000000000
        Component = edChangePercent
        DataType = ftFloat
      end
      item
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
      end
      item
        Name = 'ContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ContractName'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'RouteSortingId'
        Value = ''
        Component = GuidesRouteSorting
        ComponentItem = 'Key'
      end
      item
        Name = 'RouteSortingName'
        Value = ''
        Component = GuidesRouteSorting
        ComponentItem = 'TextValue'
      end
      item
        Name = 'InvNumberOrder'
        Value = ''
        Component = edInvNumberOrder
        DataType = ftString
      end>
    Left = 224
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Sale'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inOperDatePartner'
        Value = 0d
        Component = edOperDatePartner
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inChecked'
        Value = 'False'
        Component = edIsChecked
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inPriceWithVAT'
        Value = 'False'
        Component = edPriceWithVAT
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inVATPercent'
        Value = 0.000000000000000000
        Component = edVATPercent
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inChangePercent'
        Value = 0.000000000000000000
        Component = edChangePercent
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inInvNumberOrder'
        Value = ''
        Component = edInvNumberOrder
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inPaidKindId'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inRouteSortingId'
        Value = ''
        Component = GuidesRouteSorting
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
        Guides = GuidesFrom
      end
      item
        Guides = GuidesTo
      end>
    Left = 168
    Top = 192
  end
  inherited HeaderSaver: THeaderSaver
    Left = 232
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn
    FormName = 'SaleJournalForm'
    Left = 696
    Top = 272
  end
  inherited spErasedMIMaster: TdsdStoredProc
    Left = 718
    Top = 512
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    Left = 718
    Top = 464
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Sale'
    Params = <
      item
        Name = 'ioId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inAmount'
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inAmountPartner'
        Component = MasterCDS
        ComponentItem = 'AmountPartner'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inAmountChangePercent'
        Component = MasterCDS
        ComponentItem = 'AmountChangePercent'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inChangePercentAmount'
        Component = MasterCDS
        ComponentItem = 'ChangePercentAmount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPrice'
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'ioCountForPrice'
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInputOutput
      end
      item
        Name = 'outAmountSumm'
        Component = MasterCDS
        ComponentItem = 'AmountSumm'
        DataType = ftFloat
      end
      item
        Name = 'inHeadCount'
        Component = MasterCDS
        ComponentItem = 'HeadCount'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPartionGoods'
        Component = MasterCDS
        ComponentItem = 'PartionGoods'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inGoodsKindId'
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
      end
      item
        Name = 'inAssetId'
        Component = MasterCDS
        ComponentItem = 'AssetId'
        ParamType = ptInput
      end>
    Left = 160
    Top = 368
  end
  inherited EntryViewAddOn: TdsdDBViewAddOn
    Left = 864
    Top = 270
  end
  object GuidesRouteSorting: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRouteSorting
    FormNameParam.Value = 'TRouteSortingForm'
    FormNameParam.DataType = ftString
    FormName = 'TRouteSortingForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRouteSorting
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRouteSorting
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 704
    Top = 48
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TUnitForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnitForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 312
    Top = 8
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    FormNameParam.Value = 'TContractChoicePartnerForm'
    FormNameParam.DataType = ftString
    FormName = 'TContractChoicePartnerForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'PartnerId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
      end
      item
        Name = 'PartnerName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PaidKindId'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PaidKindName'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'PriceListId'
        Value = ''
        Component = GuidesPricelist
        ComponentItem = 'Key'
      end
      item
        Name = 'PriceListName'
        Value = ''
        Component = GuidesPricelist
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 416
    Top = 8
  end
  object PaidKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TPaidKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PaidKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 528
  end
  object ContractGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract
    FormNameParam.Value = 'TContractForm'
    FormNameParam.DataType = ftString
    FormName = 'TContractForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 728
  end
  object GuidesPricelist: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceList
    FormNameParam.Value = 'TPriceListForm'
    FormNameParam.DataType = ftString
    FormName = 'TPriceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPricelist
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPricelist
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 916
  end
end
