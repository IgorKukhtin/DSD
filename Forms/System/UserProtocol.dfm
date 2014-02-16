inherited UserProtocolForm: TUserProtocolForm
  Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1086#1096#1080#1073#1086#1082
  ClientHeight = 323
  ClientWidth = 782
  AddOnFormData.RefreshAction = nil
  ExplicitWidth = 790
  ExplicitHeight = 350
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 782
    Height = 266
    ExplicitTop = 82
    ExplicitWidth = 782
    ExplicitHeight = 241
    ClientRectBottom = 266
    ClientRectRight = 782
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 782
      ExplicitHeight = 241
      inherited cxGrid: TcxGrid
        Width = 782
        Height = 266
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
    ExplicitWidth = 782
    inherited deEnd: TcxDateEdit
      Left = 335
      ExplicitLeft = 335
    end
    object edUser: TcxButtonEdit [3]
      Left = 525
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 4
      Width = 121
    end
    object cxLabel3: TcxLabel [4]
      Left = 445
      Top = 6
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
    end
    inherited cxLabel2: TcxLabel
      Left = 225
      ExplicitLeft = 225
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
        ParamType = ptInput
      end
      item
        Name = 'inObjectId'
        Value = ''
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
    Left = 560
    Top = 32
  end
end
