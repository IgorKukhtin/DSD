inherited IncomeForm: TIncomeForm
  Caption = #1055#1088#1080#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
  ClientHeight = 382
  ClientWidth = 757
  KeyPreview = True
  PopupMenu = PopupMenu
  ExplicitWidth = 765
  ExplicitHeight = 409
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 108
    Width = 757
    Height = 274
    Align = alBottom
    TabOrder = 0
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsView.ColumnAutoWidth = True
      object colCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        Width = 58
      end
      object colName: TcxGridDBColumn
        Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        Width = 417
      end
      object colAmount: TcxGridDBColumn
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
        DataBinding.FieldName = 'Amount'
        Width = 100
      end
      object colPrice: TcxGridDBColumn
        Caption = #1062#1077#1085#1072
        DataBinding.FieldName = 'Price'
        Width = 89
      end
      object colSumm: TcxGridDBColumn
        Caption = #1057#1091#1084#1084#1072
        DataBinding.FieldName = 'Summ'
        Width = 91
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object DataPanel: TPanel
    Left = 0
    Top = 0
    Width = 757
    Height = 113
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
    object edInvNumber: TcxTextEdit
      Left = 8
      Top = 27
      TabOrder = 0
      Width = 121
    end
    object cxLabel1: TcxLabel
      Left = 8
      Top = 5
      Caption = #1053#1086#1084#1077#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edOperDate: TcxDateEdit
      Left = 144
      Top = 27
      TabOrder = 2
      Width = 121
    end
    object cxLabel2: TcxLabel
      Left = 144
      Top = 4
      Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edFrom: TcxButtonEdit
      Left = 288
      Top = 27
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 4
      Width = 137
    end
    object edTo: TcxButtonEdit
      Left = 440
      Top = 27
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 145
    end
    object cxLabel3: TcxLabel
      Left = 288
      Top = 4
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object cxLabel4: TcxLabel
      Left = 440
      Top = 4
      Caption = #1050#1086#1084#1091
    end
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        DataType = ftInteger
        ParamType = ptInputOutput
        Value = '0'
      end>
    Left = 176
    Top = 256
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Income'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inMovementId'
        Component = dsdFormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'inShowAll'
        DataType = ftBoolean
        ParamType = ptInput
        Value = 'False'
      end>
    Left = 96
    Top = 256
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 152
    Top = 152
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 51
      FloatClientHeight = 71
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbRefresh'
        end>
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = colCode
        Properties.Strings = (
          'SortIndex'
          'SortOrder'
          'Width')
      end
      item
        Component = colName
        Properties.Strings = (
          'SortIndex'
          'SortOrder'
          'Width')
      end
      item
        Component = colAmount
        Properties.Strings = (
          'SortIndex'
          'SortOrder'
          'Width')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    Left = 224
    Top = 200
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 216
    Top = 152
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 144
    Top = 192
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 96
    Top = 152
  end
  object dsdGuidesFrom: TdsdGuides
    LookupControl = edFrom
    FormName = 'TJuridicalForm'
    Left = 304
    Top = 56
  end
  object dsdGuidesTo: TdsdGuides
    LookupControl = edTo
    FormName = 'TUnitForm'
    Left = 448
    Top = 56
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Income'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Component = dsdFormParams
        ComponentItem = 'Id'
        DataType = ftInteger
        ParamType = ptInput
        Value = '0'
      end
      item
        Name = 'InvNumber'
        Component = edInvNumber
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'OperDate'
        Component = edOperDate
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'FromId'
        Component = dsdGuidesFrom
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'FromName'
        Component = dsdGuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'ToId'
        Component = dsdGuidesTo
        ComponentItem = 'Key'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end
      item
        Name = 'ToName'
        Component = dsdGuidesTo
        ComponentItem = 'TextValue'
        DataType = ftInteger
        ParamType = ptOutput
        Value = ''
      end>
    Left = 136
    Top = 72
  end
  object PopupMenu: TPopupMenu
    Images = dmMain.ImageList
    Left = 288
    Top = 216
    object N1: TMenuItem
      Action = actRefresh
    end
  end
end
