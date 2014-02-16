inherited MovementProtocolForm: TMovementProtocolForm
  Caption = #1055#1088#1086#1090#1086#1082#1086#1083
  ClientHeight = 323
  ClientWidth = 782
  AddOnFormData.RefreshAction = nil
  ExplicitWidth = 790
  ExplicitHeight = 350
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 82
    Width = 782
    Height = 241
    ExplicitTop = 82
    ExplicitWidth = 782
    ExplicitHeight = 241
    ClientRectBottom = 241
    ClientRectRight = 782
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 782
      ExplicitHeight = 241
      inherited cxGrid: TcxGrid
        Width = 782
        Height = 241
        ExplicitWidth = 782
        ExplicitHeight = 241
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsView.CellAutoHeight = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 54
          end
          object colObjectName: TcxGridDBColumn
            Caption = #1054#1073#1098#1077#1082#1090
            DataBinding.FieldName = 'ObjectName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object colObjectTypeName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1086#1073#1098#1077#1082#1090#1072
            DataBinding.FieldName = 'ObjectTypeName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
          end
          object colUserName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 99
          end
          object colProtocolData: TcxGridDBColumn
            Caption = #1044#1072#1085#1085#1099#1077
            DataBinding.FieldName = 'ProtocolData'
            PropertiesClassName = 'TcxMemoProperties'
            Properties.ScrollBars = ssVertical
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 505
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 782
    Height = 56
    ExplicitWidth = 782
    ExplicitHeight = 56
    inherited deEnd: TcxDateEdit
      Left = 335
      ExplicitLeft = 335
    end
    object edUser: TcxButtonEdit [3]
      Left = 101
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 4
      Width = 121
    end
    object edObjectDesc: TcxButtonEdit [4]
      Left = 335
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 121
    end
    object edObject: TcxButtonEdit [5]
      Left = 583
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 6
      Width = 183
    end
    object cxLabel3: TcxLabel [6]
      Left = 21
      Top = 30
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
    end
    inherited cxLabel2: TcxLabel
      Left = 225
      ExplicitLeft = 225
    end
    object cxLabel4: TcxLabel
      Left = 241
      Top = 30
      Caption = #1058#1080#1087' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072':'
    end
    object cxLabel5: TcxLabel
      Left = 463
      Top = 30
      Caption = #1069#1083#1077#1084#1077#1085#1090' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072':'
    end
  end
  inherited MasterDS: TDataSource
    Top = 55
  end
  inherited MasterCDS: TClientDataSet
    Top = 55
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Protocol'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inUserId'
        Value = ''
        Component = UserGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inObjectDescId'
        Value = ''
        Component = ObjectDescGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inObjectId'
        Value = ''
        Component = ObjectGuides
        ComponentItem = 'Key'
        ParamType = ptInputOutput
      end>
    Top = 55
  end
  inherited BarManager: TdxBarManager
    Top = 55
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    RefreshAction = nil
  end
  object UserGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUser
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
    Left = 160
    Top = 32
  end
  object ObjectDescGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edObjectDesc
    FormNameParam.Value = 'TObjectDescForm'
    FormNameParam.DataType = ftString
    FormName = 'TObjectDescForm'
    PositionDataSet = 'MainDataCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ObjectDescGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ObjectDescGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 376
    Top = 48
  end
  object ObjectGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edObject
    FormNameParam.Value = 'TObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TObjectForm'
    PositionDataSet = 'MainDataCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ObjectGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ObjectGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ObjectDescId'
        Value = ''
        Component = ObjectDescGuides
        ComponentItem = 'Key'
      end>
    Left = 560
    Top = 48
  end
end
