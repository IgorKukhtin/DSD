inherited UserProtocolForm: TUserProtocolForm
  Caption = #1055#1088#1086#1090#1086#1082#1086#1083' '#1086#1096#1080#1073#1086#1082
  ClientHeight = 319
  ClientWidth = 782
  AddOnFormData.isSingle = False
  ExplicitWidth = 798
  ExplicitHeight = 354
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 782
    Height = 262
    ExplicitWidth = 782
    ExplicitHeight = 266
    ClientRectBottom = 262
    ClientRectRight = 782
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 782
      ExplicitHeight = 266
      inherited cxGrid: TcxGrid
        Width = 782
        Height = 262
        ExplicitWidth = 782
        ExplicitHeight = 266
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
          object clMemberName: TcxGridDBColumn
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
          object BranchCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1092'.'
            DataBinding.FieldName = 'BranchCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object BranchName: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 782
    ExplicitWidth = 782
    inherited deStart: TcxDateEdit
      EditValue = 41640d
    end
    inherited deEnd: TcxDateEdit
      Left = 335
      EditValue = 41640d
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
    Top = 95
  end
  inherited BarManager: TdxBarManager
    Left = 144
    Top = 103
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
    PositionDataSet = 'ClientDataSet'
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
