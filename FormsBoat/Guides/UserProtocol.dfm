inherited UserProtocolForm: TUserProtocolForm
  Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1086#1096#1080#1073#1086#1082
  ClientHeight = 319
  ClientWidth = 937
  AddOnFormData.isSingle = False
  ExplicitWidth = 953
  ExplicitHeight = 357
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 937
    Height = 262
    ExplicitWidth = 937
    ExplicitHeight = 262
    ClientRectBottom = 262
    ClientRectRight = 937
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 937
      ExplicitHeight = 262
      inherited cxGrid: TcxGrid
        Width = 937
        Height = 262
        ExplicitWidth = 937
        ExplicitHeight = 262
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsView.CellAutoHeight = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Date: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 54
          end
          object UserName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'UserName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 99
          end
          object ProtocolData: TcxGridDBColumn
            Caption = #1044#1072#1085#1085#1099#1077
            DataBinding.FieldName = 'ProtocolData'
            PropertiesClassName = 'TcxMemoProperties'
            Properties.ScrollBars = ssVertical
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 505
          end
          object MemberName: TcxGridDBColumn
            Caption = #1060#1048#1054
            DataBinding.FieldName = 'MemberName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object PositionName: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 95
          end
          object UnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087'.'
            DataBinding.FieldName = 'UnitCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 102
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 937
    ExplicitWidth = 937
    inherited deStart: TcxDateEdit
      EditValue = 42736d
    end
    inherited deEnd: TcxDateEdit
      Left = 335
      EditValue = 42736d
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
    Left = 48
    Top = 103
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 95
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_UserProtocol'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserId'
        Value = ''
        Component = UserGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 120
    Top = 95
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 95
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = UserGuides
      end>
  end
  object UserGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUser
    FormNameParam.Value = 'TUserForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUserForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UserGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UserGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 584
    Top = 112
  end
end
