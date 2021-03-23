inherited MovementProtocol_InfoForm: TMovementProtocol_InfoForm
  Caption = #1055#1088#1086#1090#1086#1082#1086#1083
  ClientHeight = 323
  ClientWidth = 689
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitWidth = 705
  ExplicitHeight = 361
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 689
    Height = 264
    ExplicitTop = 59
    ExplicitWidth = 608
    ExplicitHeight = 264
    ClientRectBottom = 264
    ClientRectRight = 689
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 608
      ExplicitHeight = 264
      inherited cxGrid: TcxGrid
        Left = 4
        Width = 685
        Height = 264
        ExplicitLeft = 4
        ExplicitWidth = 604
        ExplicitHeight = 264
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsView.CellAutoHeight = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 190
          end
          object colUserName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 177
          end
          object TextInfo: TcxGridDBColumn
            Caption = 'Value'
            DataBinding.FieldName = 'TextInfo'
            HeaderAlignmentVert = vaCenter
            Width = 264
          end
        end
      end
      object cxSplitter: TcxSplitter
        Left = 0
        Top = 0
        Width = 4
        Height = 264
        Control = cxGrid
      end
    end
  end
  inherited Panel: TPanel
    Width = 689
    Height = 33
    ExplicitWidth = 689
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Left = 650
      Top = 29
      Visible = False
      ExplicitLeft = 650
      ExplicitTop = 29
    end
    inherited deEnd: TcxDateEdit
      Left = 735
      Visible = False
      ExplicitLeft = 735
    end
    inherited cxLabel1: TcxLabel
      Left = 625
      Visible = False
      ExplicitLeft = 625
    end
    object edMovementDesc: TcxButtonEdit [3]
      Left = 374
      Top = 5
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 179
    end
    object edObject: TcxButtonEdit [4]
      Left = 71
      Top = 5
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 183
    end
    inherited cxLabel2: TcxLabel
      Left = 625
      Visible = False
      ExplicitLeft = 625
    end
    object cxLabel4: TcxLabel
      Left = 317
      Top = 6
      Caption = #1069#1083#1077#1084#1077#1085#1090':'
    end
    object cxLabel5: TcxLabel
      Left = 7
      Top = 6
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090':'
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
  end
  inherited ActionList: TActionList
    Left = 103
  end
  inherited MasterDS: TDataSource
    Top = 119
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 119
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementProtocol_Info'
    Params = <
      item
        Name = 'inMovementId'
        Value = ''
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCodeInfo'
        Value = ''
        Component = FormParams
        ComponentItem = 'inCodeInfo'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 143
  end
  inherited BarManager: TdxBarManager
    Top = 111
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 424
    Top = 168
  end
  inherited PopupMenu: TPopupMenu
    Left = 152
    Top = 256
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 120
    Top = 160
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    RefreshAction = nil
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = deEnd
      end
      item
        Component = deStart
      end>
    Left = 224
    Top = 168
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = Null
        Component = edObject
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCodeInfo'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDescInfo'
        Value = Null
        Component = edMovementDesc
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 352
    Top = 152
  end
  object dsdXMLTransform: TdsdXMLTransform
    XMLDataFieldName = 'ProtocolData'
    Left = 496
    Top = 112
  end
  object ProtocolDataCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 584
    Top = 119
    object ProtocolDataCDSFieldName: TStringField
      FieldName = 'FieldName'
      Size = 100
    end
    object ProtocolDataCDSFieldValue: TStringField
      FieldName = 'FieldValue'
      Size = 255
    end
  end
  object ProtocolDataDS: TDataSource
    DataSet = ProtocolDataCDS
    Left = 528
    Top = 183
  end
end
