inherited Report_Check_byPromoCodeForm: TReport_Check_byPromoCodeForm
  Caption = #1054#1090#1095#1077#1090' <'#1063#1077#1082#1080' '#1087#1086' '#1087#1088#1086#1084#1086' '#1082#1086#1076#1091'>'
  ClientWidth = 920
  AddOnFormData.Params = FormParams
  ExplicitWidth = 936
  ExplicitHeight = 346
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 77
    Width = 920
    Height = 231
    ExplicitTop = 77
    ExplicitWidth = 920
    ExplicitHeight = 231
    ClientRectBottom = 231
    ClientRectRight = 920
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 920
      ExplicitHeight = 231
      inherited cxGrid: TcxGrid
        Width = 920
        Height = 231
        ExplicitWidth = 920
        ExplicitHeight = 231
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
            end
            item
              Kind = skSum
              Position = spFooter
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = UnitName
            end>
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Operdate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
            DataBinding.FieldName = 'Operdate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072' '#1076#1086#1082'. '#1095#1077#1082
            Width = 85
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1076#1086#1082'. '#1095#1077#1082
            Width = 135
          end
          object UnitName: TcxGridDBColumn
            Caption = #1040#1087#1090#1077#1082#1072
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100' '#1076#1086#1082'.'
            Options.Editing = False
            Width = 279
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086' ('#1072#1087#1090#1077#1082#1072')'
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 201
          end
          object RetailName: TcxGridDBColumn
            Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
            DataBinding.FieldName = 'RetailName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 177
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 920
    Height = 51
    ExplicitWidth = 920
    ExplicitHeight = 51
    inherited deStart: TcxDateEdit
      Left = 10
      Top = 23
      EditValue = 43009d
      TabOrder = 1
      Visible = False
      ExplicitLeft = 10
      ExplicitTop = 23
      ExplicitWidth = 91
      Width = 91
    end
    inherited deEnd: TcxDateEdit
      Left = 113
      Top = 23
      EditValue = 43009d
      TabOrder = 0
      Visible = False
      ExplicitLeft = 113
      ExplicitTop = 23
      ExplicitWidth = 110
      Width = 110
    end
    inherited cxLabel1: TcxLabel
      Visible = False
    end
    inherited cxLabel2: TcxLabel
      Left = 113
      Visible = False
      ExplicitLeft = 113
    end
    object cxLabel25: TcxLabel
      Left = 521
      Top = 5
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1055#1088#1086#1084#1086' '#1082#1086#1076
    end
    object edPromo: TcxButtonEdit
      Left = 521
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 117
    end
    object cxLabel4: TcxLabel
      Left = 645
      Top = 5
      Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
    end
    object deOperdate: TcxDateEdit
      Left = 645
      Top = 23
      EditValue = 41640d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 7
      Width = 85
    end
    object edGUID: TcxTextEdit
      Left = 267
      Top = 23
      Hint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072' ('#1054#1090#1087#1088#1072#1074#1083#1077#1085' '#1082#1083#1080#1077#1085#1090#1091')'
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 174
    end
    object cxLabel19: TcxLabel
      Left = 267
      Top = 5
      Hint = #1057#1090#1072#1090#1091#1089' '#1079#1072#1082#1072#1079#1072' ('#1054#1090#1087#1088#1072#1074#1083#1077#1085' '#1082#1083#1080#1077#1085#1090#1091')'
      Caption = #1055#1088#1086#1084#1086' '#1082#1086#1076
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 51
    Top = 192
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 8
    Top = 232
  end
  inherited ActionList: TActionList
    Left = 87
    Top = 191
    object actRefreshSearch: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = gpGetObjectGoods
      StoredProcList = <
        item
          StoredProc = gpGetObjectGoods
        end>
      Caption = 'actRefreshSearch'
      ShortCut = 13
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormName = 'NULL'
      FormNameParam.Value = Null
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 'NULL'
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actGetForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementForm
      StoredProcList = <
        item
          StoredProc = getMovementForm
        end>
      Caption = 'actGetForm'
    end
    object actOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetForm
        end
        item
          Action = actOpenForm
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 28
      ShortCut = 115
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'form'
      FormNameParam.Value = 'form'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42491d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42491d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Persent'
          Value = ''
          DataType = ftFloat
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 48
    Top = 160
  end
  inherited MasterCDS: TClientDataSet
    Left = 0
    Top = 152
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Check_byPromoCode'
    Params = <
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementItemId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = 'NULL'
        Component = deStart
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 'NULL'
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 120
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 88
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
          ItemName = 'bbGridToExcel'
        end>
    end
    object bbOpenDocument: TdxBarButton
      Action = actOpenDocument
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actOpenDocument
      end>
  end
  inherited PopupMenu: TPopupMenu
    Left = 128
    Top = 216
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 32
    Top = 152
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
    Left = 128
    Top = 144
  end
  object gpGetObjectGoods: TdsdStoredProc
    StoredProcName = 'gpGet_Object_GoodsByCode'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsCode'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 592
    Top = 120
  end
  object getMovementForm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 120
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'FormName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementItemId'
        Value = Null
        Component = GuidesPromo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = Null
        Component = GuidesPromo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = deOperdate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGUID'
        Value = Null
        Component = edGUID
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 232
    Top = 176
  end
  object GuidesPromo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPromo
    Key = '0'
    FormNameParam.Value = 'TPromoJournalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPromoJournalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesPromo
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesPromo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 564
    Top = 16
  end
end
