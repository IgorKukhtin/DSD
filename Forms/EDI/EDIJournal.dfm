inherited EDIJournalForm: TEDIJournalForm
  Caption = 'EDI '#1078#1091#1088#1085#1072#1083
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 57
    Height = 251
    ExplicitTop = 57
    ExplicitHeight = 251
    ClientRectBottom = 251
    inherited tsMain: TcxTabSheet
      ExplicitHeight = 251
      inherited cxGrid: TcxGrid
        Height = 251
        ExplicitHeight = 251
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1079#1072#1082#1072#1079#1072
            DataBinding.FieldName = 'OperDate'
            Width = 60
          end
          object colInvNumber: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' '#1079#1072#1082#1072#1079#1072
            DataBinding.FieldName = 'InvNumber'
            Width = 60
          end
          object cxGridDBTableViewColumn3: TcxGridDBColumn
            Width = 60
          end
          object cxGridDBTableViewColumn4: TcxGridDBColumn
            Width = 60
          end
        end
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 575
    Height = 31
    Align = alTop
    TabOrder = 5
    object deStart: TcxDateEdit
      Left = 107
      Top = 5
      EditValue = 41640d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 310
      Top = 5
      EditValue = 41640d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object cxLabel1: TcxLabel
      Left = 10
      Top = 6
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel2: TcxLabel
      Left = 200
      Top = 6
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end>
  end
  inherited ActionList: TActionList
    object EDIActionComdocLoad: TEDIActionComdocLoad
      Category = 'EDI'
      MoveParams = <>
      spHeader = spHeader
      spList = spList
    end
  end
  inherited MasterDS: TDataSource
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_EDI'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Top = 80
  end
  inherited BarManager: TdxBarManager
    Top = 80
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbLoadComDoc'
        end>
    end
    object bbLoadComDoc: TdxBarButton
      Action = EDIActionComdocLoad
      Category = 0
      ImageIndex = 30
    end
  end
  object spHeader: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_EDI'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outId'
        Value = Null
      end
      item
        Name = 'inOrderInvNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOrderOperDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inSaleInvNumber'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inSaleOperDate'
        Value = Null
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inGLN'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inOKPO'
        Value = Null
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 168
    Top = 120
  end
  object spList: TdsdStoredProc
    DataSets = <>
    OutputType = otResult
    Params = <>
    Left = 168
    Top = 168
  end
end
