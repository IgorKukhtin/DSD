inherited GoodsUnitRetail_CashForm: TGoodsUnitRetail_CashForm
  Caption = #1053#1072#1083#1080#1095#1080#1077' '#1090#1086#1074#1072#1088#1072' '#1087#1086' '#1089#1077#1090#1080' '#1087#1086' '#1089#1086#1094'. '#1087#1088#1086#1075#1088#1072#1084#1084#1077
  ClientHeight = 418
  ClientWidth = 637
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitWidth = 653
  ExplicitHeight = 457
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 80
    Width = 637
    Height = 338
    ExplicitTop = 67
    ExplicitWidth = 637
    ExplicitHeight = 351
    ClientRectBottom = 338
    ClientRectRight = 637
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 637
      ExplicitHeight = 351
      inherited cxGrid: TcxGrid
        Width = 637
        Height = 338
        ExplicitWidth = 637
        ExplicitHeight = 351
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object UnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'UnitCode'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 375
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1086' '#1087#1088#1072#1081#1089#1091
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Amount: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
        end
      end
    end
  end
  object Panel1: TPanel [1]
    Left = 0
    Top = 0
    Width = 637
    Height = 54
    Align = alTop
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 5
    object edGoodsCode: TcxTextEdit
      Left = 76
      Top = 3
      TabStop = False
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 73
    end
    object cxLabel1: TcxLabel
      Left = 7
      Top = 4
      Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
    end
    object edGoodsName: TcxTextEdit
      Left = 250
      Top = 3
      TabStop = False
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 359
    end
    object cxLabel2: TcxLabel
      Left = 167
      Top = 4
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
    end
    object edMedicalProgramSP: TcxButtonEdit
      Left = 250
      Top = 27
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 359
    end
    object cxLabel5: TcxLabel
      Left = 116
      Top = 28
      Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1072#1103' '#1087#1088#1086#1075#1088#1072#1084#1084#1072
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 219
    Top = 216
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 32
  end
  inherited ActionList: TActionList
    Left = 119
    Top = 191
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 184
  end
  inherited MasterCDS: TClientDataSet
    Left = 32
    Top = 104
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_GoodsUnitRetail_Cash'
    Params = <
      item
        Name = 'inGoodsId'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMedicalProgramSPId'
        Value = Null
        Component = GuidesMedicalProgramSP
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 104
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 104
    DockControlHeights = (
      0
      0
      26
      0)
    inherited bbRefresh: TdxBarButton
      Left = 280
    end
    inherited dxBarStatic: TdxBarStatic
      Left = 208
      Top = 65528
    end
    inherited bbGridToExcel: TdxBarButton
      Left = 232
    end
    object bbOpen: TdxBarButton
      Caption = #1054#1090#1082#1088#1099#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      Left = 160
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 368
    Top = 208
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'GoodsId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsCode'
        Value = Null
        Component = edGoodsCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsName'
        Value = Null
        Component = edGoodsName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MedicalProgramSPId'
        Value = Null
        Component = GuidesMedicalProgramSP
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MedicalProgramSPName'
        Value = Null
        Component = GuidesMedicalProgramSP
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 104
  end
  object GuidesMedicalProgramSP: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMedicalProgramSP
    FormNameParam.Value = 'TMedicalProgramSPForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMedicalProgramSPForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMedicalProgramSP
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMedicalProgramSP
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 497
    Top = 17
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesMedicalProgramSP
      end>
    Left = 368
    Top = 120
  end
end
