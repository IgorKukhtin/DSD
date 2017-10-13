inherited Report_Movement_AnotherRetailForm: TReport_Movement_AnotherRetailForm
  Caption = #1057#1087#1080#1089#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074', '#1082#1091#1076#1072' '#1087#1086#1087#1072#1083#1080' ID '#1090#1086#1074#1072#1088#1086#1074' '#1076#1088#1091#1075#1086#1081' '#1089#1077#1090#1080
  ClientHeight = 389
  ClientWidth = 893
  AddOnFormData.Params = FormParams
  ExplicitWidth = 909
  ExplicitHeight = 427
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 893
    Height = 330
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 893
    ExplicitHeight = 330
    ClientRectBottom = 330
    ClientRectRight = 893
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 893
      ExplicitHeight = 330
      inherited cxGrid: TcxGrid
        Width = 893
        Height = 330
        ExplicitWidth = 893
        ExplicitHeight = 330
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
            end
            item
              Format = ',0.00##'
              Kind = skSum
            end
            item
              Format = ',0.00##'
              Kind = skSum
            end
            item
              Format = ',0.00##'
              Kind = skSum
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.FooterMultiSummaries = True
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object ItemName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1082'.'
            DataBinding.FieldName = 'ItemName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 174
          end
          object Статус: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089
            DataBinding.FieldName = 'StatusCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 11
                Value = 1
              end
              item
                Description = #1055#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 12
                Value = 2
              end
              item
                Description = #1059#1076#1072#1083#1077#1085
                ImageIndex = 13
                Value = 3
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 96
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 133
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 134
          end
          object FromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 171
          end
          object ToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 171
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 893
    Height = 33
    ExplicitWidth = 893
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Left = 790
      Top = 10
      EditValue = 41640d
      Properties.SaveTime = False
      Visible = False
      ExplicitLeft = 790
      ExplicitTop = 10
    end
    inherited deEnd: TcxDateEdit
      Left = 794
      EditValue = 41640d
      Properties.SaveTime = False
      Visible = False
      ExplicitLeft = 794
    end
    inherited cxLabel1: TcxLabel
      Left = 697
      Top = 11
      Visible = False
      ExplicitLeft = 697
      ExplicitTop = 11
    end
    inherited cxLabel2: TcxLabel
      Left = 682
      Visible = False
      ExplicitLeft = 682
    end
    object cxLabel6: TcxLabel
      Left = 14
      Top = 8
      Caption = #1058#1086#1074#1072#1088':'
    end
    object edGoods: TcxButtonEdit
      Left = 53
      Top = 7
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 348
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 208
    Top = 272
  end
  inherited ActionList: TActionList
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
    end
  end
  inherited MasterDS: TDataSource
    Top = 164
  end
  inherited MasterCDS: TClientDataSet
    Top = 132
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_AnotherRetail'
    Params = <
      item
        Name = 'inContainerId'
        Value = ''
        Component = FormParams
        ComponentItem = 'inContainerId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 184
    Top = 196
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 132
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbOpenDocument'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbOpenDocument: TdxBarButton
      Action = actOpenDocument
      Category = 0
    end
    object bbPrintOfficial: TdxBarButton
      Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' ('#1073#1091#1093#1075#1072#1083#1090#1077#1088#1089#1082#1080#1081')'
      Category = 0
      Hint = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' ('#1073#1091#1093#1075#1072#1083#1090#1077#1088#1089#1082#1080#1081')'
      Visible = ivNever
      ImageIndex = 17
      ShortCut = 16464
    end
    object bbPrint: TdxBarButton
      Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080
      Category = 0
      Hint = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080
      Visible = ivNever
      ImageIndex = 3
    end
    object bbPrintTurnover: TdxBarButton
      Caption = #1054#1073#1086#1088#1086#1090#1099' '
      Category = 0
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1073#1086#1088#1086#1090#1072#1084
      Visible = ivNever
      ImageIndex = 20
    end
    object bbPrintCurrency: TdxBarButton
      Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' ('#1074' '#1074#1072#1083#1102#1090#1077')'
      Category = 0
      Hint = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' ('#1074' '#1074#1072#1083#1102#1090#1077')'
      Visible = ivNever
      ImageIndex = 21
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actOpenDocument
      end>
    ActionItemList = <
      item
        Action = actOpenDocument
        ShortCut = 13
      end>
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 24
    Top = 196
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end
      item
      end>
    Left = 496
    Top = 160
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
        Name = 'inContainerId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsName'
        Value = Null
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 144
  end
  object spJuridicalBalance: TdsdStoredProc
    StoredProcName = 'gpReport_JuridicalBalance'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStartBalance'
        Value = Null
        Component = FormParams
        ComponentItem = 'StartBalance'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStartBalanceCurrency'
        Value = Null
        Component = FormParams
        ComponentItem = 'StartBalanceCurrency'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'outJuridicalName'
        Value = Null
        Component = FormParams
        ComponentItem = 'JuridicalName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outJuridicalShortName'
        Value = Null
        Component = FormParams
        ComponentItem = 'JuridicalShortName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outJuridicalName_Basis'
        Value = Null
        Component = FormParams
        ComponentItem = 'JuridicalName_Basis'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outJuridicalShortName_Basis'
        Value = Null
        Component = FormParams
        ComponentItem = 'JuridicalShortName_Basis'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 240
  end
  object GuidesGoods: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGoods
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 192
  end
end
