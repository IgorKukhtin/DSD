inherited MovementItemProtocolForm: TMovementItemProtocolForm
  Caption = #1055#1088#1086#1090#1086#1082#1086#1083' <'#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'> '
  ClientHeight = 341
  ClientWidth = 769
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitWidth = 777
  ExplicitHeight = 375
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 769
    ExplicitTop = 59
    ExplicitWidth = 769
    ClientRectRight = 769
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 769
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 769
        ExplicitWidth = 769
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object clMovementItemId: TcxGridDBColumn
            Caption = 'Id '#1089#1090#1088#1086#1082#1080
            DataBinding.FieldName = 'MovementItemId'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 123
          end
          object clUserName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 162
          end
          object clProtocolData: TcxGridDBColumn
            Caption = #1044#1072#1085#1085#1099#1077
            DataBinding.FieldName = 'ProtocolData'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 388
          end
        end
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 769
    Height = 33
    Align = alTop
    TabOrder = 5
    object deStart: TcxDateEdit
      Left = 101
      Top = 5
      EditValue = 42005d
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 312
      Top = 5
      EditValue = 42005d
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object cxLabel1: TcxLabel
      Left = 10
      Top = 6
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object edUser: TcxButtonEdit
      Left = 497
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 3
      Width = 206
    end
    object cxLabel3: TcxLabel
      Left = 413
      Top = 6
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
    end
    object cxLabel2: TcxLabel
      Left = 201
      Top = 6
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
  end
  inherited MasterDS: TDataSource
    Left = 40
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    Top = 112
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItemProtocol'
    Params = <
      item
        Name = 'inStartDate'
        Value = 42005d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 42005d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inUserId'
        Value = '0'
        Component = UserGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 88
    Top = 96
  end
  inherited BarManager: TdxBarManager
    Left = 152
    Top = 136
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 456
    Top = 256
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInput
      end>
    Left = 272
    Top = 216
  end
  object UserGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUser
    Key = '0'
    FormNameParam.Value = 'TUserForm'
    FormNameParam.DataType = ftString
    FormName = 'TUserForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UserGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UserGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 544
  end
end
