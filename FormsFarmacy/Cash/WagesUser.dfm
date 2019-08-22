inherited WagesUserForm: TWagesUserForm
  Caption = #1047#1072#1088#1087#1083#1072#1090#1072
  ClientHeight = 391
  ClientWidth = 559
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = actDataDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 575
  ExplicitHeight = 430
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 75
    Width = 559
    Height = 316
    TabOrder = 5
    ExplicitTop = 75
    ExplicitWidth = 559
    ExplicitHeight = 316
    ClientRectBottom = 316
    ClientRectRight = 559
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 559
      ExplicitHeight = 316
      inherited cxGrid: TcxGrid
        Width = 559
        Height = 216
        ExplicitWidth = 559
        ExplicitHeight = 216
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsView.Footer = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object cxGridDBTableViewColumn1: TcxGridDBColumn
            Caption = #8470' '#1087'.'#1087
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 56
          end
          object cxGridDBTableViewColumn2: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 367
          end
          object cxGridDBTableViewColumn3: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 98
          end
        end
      end
      object PanelBottom: TPanel
        Left = 0
        Top = 216
        Width = 559
        Height = 100
        Align = alBottom
        ShowCaption = False
        TabOrder = 1
        object ceTotal: TcxCurrencyEdit
          Left = 157
          Top = 6
          ParentFont = False
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00;-,0.00;;'
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -16
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = []
          Style.IsFontAssigned = True
          TabOrder = 0
          Width = 156
        end
        object cxLabel4: TcxLabel
          Left = 15
          Top = 6
          Caption = #1048#1090#1086#1075#1086' '#1085#1072#1095#1080#1089#1083#1077#1085#1086':'
          ParentFont = False
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -16
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = []
          Style.IsFontAssigned = True
        end
        object ceCard: TcxCurrencyEdit
          Left = 157
          Top = 35
          ParentFont = False
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00;-,0.00;;'
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -16
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = []
          Style.IsFontAssigned = True
          TabOrder = 2
          Width = 156
        end
        object cxLabel1: TcxLabel
          Left = 15
          Top = 35
          Caption = #1047'/'#1055' '#1085#1072' '#1082#1072#1088#1090#1091' :'
          ParentFont = False
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -16
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = []
          Style.IsFontAssigned = True
        end
        object ceOnHand: TcxCurrencyEdit
          Left = 157
          Top = 64
          ParentFont = False
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00;-,0.00;;'
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -16
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = []
          Style.IsFontAssigned = True
          TabOrder = 4
          Width = 156
        end
        object cxLabel3: TcxLabel
          Left = 15
          Top = 64
          Caption = #1048#1090#1086#1075#1086' '#1085#1072' '#1088#1091#1082#1080':'
          ParentFont = False
          Style.Font.Charset = DEFAULT_CHARSET
          Style.Font.Color = clWindowText
          Style.Font.Height = -16
          Style.Font.Name = 'Tahoma'
          Style.Font.Style = []
          Style.IsFontAssigned = True
        end
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 559
    Height = 49
    Align = alTop
    ShowCaption = False
    TabOrder = 0
    object edOperDate: TcxDateEdit
      Left = 111
      Top = 15
      TabStop = False
      EditValue = 42132d
      Properties.DisplayFormat = 'mmmm yyyy'
      Properties.EditFormat = 'dd.mm.yyyy'
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 100
    end
    object cxLabel2: TcxLabel
      Left = 26
      Top = 16
      Caption = #1047#1072#1088#1087#1083#1072#1090#1072' '#1079#1072
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 235
    Top = 256
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 32
  end
  inherited ActionList: TActionList
    Left = 119
    Top = 191
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spGet
        end>
    end
    object actDataDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actDataDialog'
      ImageIndex = 35
      FormName = 'TDataDialogForm'
      FormNameParam.Value = 'TDataDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = 'NULL'
          Component = FormParams
          ComponentItem = 'inOperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
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
    StoredProcName = 'gpSelect_MovementItem_WagesUser'
    Params = <
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 104
  end
  inherited BarManager: TdxBarManager
    Left = 152
    Top = 104
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
          ItemName = 'dxBarButton2'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
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
    object dxBarButton1: TdxBarButton
      Caption = #1043#1088#1072#1092#1080#1082' '#1088#1072#1073#1086#1090#1099' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102
      Category = 0
      Hint = #1043#1088#1072#1092#1080#1082' '#1088#1072#1073#1086#1090#1099' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1102
      Visible = ivAlways
      ImageIndex = 55
    end
    object dxBarButton2: TdxBarButton
      Action = actDataDialog
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    KeepSelectColor = True
    Left = 232
    Top = 184
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inOperDate'
        Value = 'NULL'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 104
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MovementItem_WagesUser'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 'NULL'
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Total'
        Value = Null
        Component = ceTotal
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Card'
        Value = Null
        Component = ceCard
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'OnHand'
        Value = Null
        Component = ceOnHand
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 328
    Top = 104
  end
end
