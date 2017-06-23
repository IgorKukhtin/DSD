inherited MovementItemsLoadForm: TMovementItemsLoadForm
  Caption = #1069#1083#1077#1084#1077#1085#1090' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  ClientHeight = 410
  ClientWidth = 763
  AddOnFormData.Params = FormParams
  ExplicitWidth = 779
  ExplicitHeight = 449
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 75
    Width = 763
    Height = 335
    ExplicitTop = 75
    ExplicitWidth = 763
    ExplicitHeight = 335
    ClientRectBottom = 335
    ClientRectRight = 763
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 763
      ExplicitHeight = 335
      inherited cxGrid: TcxGrid
        Width = 763
        Height = 335
        ExplicitWidth = 763
        ExplicitHeight = 335
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 98
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 159
          end
          object GoodsId: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088#1099
            DataBinding.FieldName = 'GoodsId'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object LoadMovementId: TcxGridDBColumn
            Caption = #1057#1089#1099#1083#1082#1072' '#1085#1072' '#1076#1086#1082#1091#1084#1077#1085#1090
            DataBinding.FieldName = 'LoadMovementId'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actChoiceGoods
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentVert = vaCenter
            Width = 43
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 204
          end
          object PackageAmount: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1074' '#1091#1087#1072#1082#1086#1074#1082#1077
            DataBinding.FieldName = 'PackageAmount'
            HeaderAlignmentVert = vaCenter
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object Summ: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'Summ'
            HeaderAlignmentVert = vaCenter
          end
          object ExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'ExpirationDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 106
          end
        end
      end
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 763
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
    object cxLabel2: TcxLabel
      Left = 1
      Top = 4
      Caption = #1044#1072#1090#1072
    end
    object edOperDate: TcxDateEdit
      Left = 1
      Top = 22
      Enabled = False
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 100
    end
    object cxLabel3: TcxLabel
      Left = 107
      Top = 4
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
    end
    object edFrom: TcxButtonEdit
      Left = 107
      Top = 22
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 270
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 272
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Top = 232
  end
  inherited ActionList: TActionList
    Left = 151
    Top = 255
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spGet
        end>
    end
    object actChoiceGoods: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceGoods'
      FormName = 'TGoodsForm'
      FormNameParam.Value = 'TGoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 152
  end
  inherited MasterCDS: TClientDataSet
    Top = 128
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_MovementItemsLoad'
    Params = <
      item
        Name = 'inLoadPriceListId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 152
  end
  inherited BarManager: TdxBarManager
    Left = 192
    Top = 144
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited PopupMenu: TPopupMenu
    Left = 176
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 176
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_LoadPriceList'
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
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 288
    Top = 152
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 352
    Top = 32
  end
end
