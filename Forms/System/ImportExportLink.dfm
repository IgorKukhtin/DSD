inherited ImportExportLinkForm: TImportExportLinkForm
  Caption = #1057#1074#1103#1079#1080' '#1086#1073#1098#1077#1082#1090#1086#1074
  ClientHeight = 395
  ClientWidth = 847
  AddOnFormData.isAlwaysRefresh = False
  ExplicitLeft = -65
  ExplicitWidth = 855
  ExplicitHeight = 422
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 847
    Height = 369
    ExplicitWidth = 847
    ExplicitHeight = 369
    ClientRectBottom = 369
    ClientRectRight = 847
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 847
      ExplicitHeight = 369
      inherited cxGrid: TcxGrid
        Width = 847
        Height = 369
        ExplicitWidth = 847
        ExplicitHeight = 369
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Appending = True
          OptionsData.Inserting = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colIntegerKey: TcxGridDBColumn
            Caption = #1050#1083#1102#1095' '#1095#1080#1089#1083#1086
            DataBinding.FieldName = 'IntegerKey'
            HeaderAlignmentVert = vaCenter
            Width = 83
          end
          object colStringKey: TcxGridDBColumn
            Caption = #1050#1083#1102#1095' '#1089#1090#1088#1086#1082#1072
            DataBinding.FieldName = 'StringKey'
            HeaderAlignmentVert = vaCenter
            Width = 227
          end
          object colObjectMainName: TcxGridDBColumn
            Caption = #1054#1073#1098#1077#1082#1090
            DataBinding.FieldName = 'ObjectMainName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = OpenObjectForm
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentVert = vaCenter
            Width = 173
          end
          object colObjectChildName: TcxGridDBColumn
            Caption = #1054#1073#1098#1077#1082#1090
            DataBinding.FieldName = 'ObjectChildName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = OpenObjectChildForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 133
          end
          object colLinkTypeName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1089#1074#1103#1079#1080
            DataBinding.FieldName = 'LinkTypeName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = OpenLinkTypeForm
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentVert = vaCenter
            Width = 81
          end
          object colText: TcxGridDBColumn
            Caption = #1058#1077#1082#1089#1090
            DataBinding.FieldName = 'SomeText'
            PropertiesClassName = 'TcxBlobEditProperties'
            Properties.BlobPaintStyle = bpsText
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    object OpenObjectChildForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'OpenObjectForm'
      FormName = 'TObjectForm'
      FormNameParam.Value = 'TObjectForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ValueId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ObjectChildName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object OpenLinkTypeForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'OpenObjectForm'
      FormName = 'TImportExportLinkTypeForm'
      FormNameParam.Value = 'TImportExportLinkTypeForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LinkTypeId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'LinkTypeName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object OpenObjectForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'OpenObjectForm'
      FormName = 'TObjectForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MainId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ObjectMainName'
          DataType = ftString
        end>
      isShowModal = False
    end
    object UpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'UpdateDataSet'
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_ImportExportLink'
    Left = 88
    Top = 80
  end
  inherited BarManager: TdxBarManager
    Left = 128
    Top = 80
    DockControlHeights = (
      0
      0
      26
      0)
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ImportExportLink'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioid'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inIntegerKey'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IntegerKey'
        ParamType = ptInput
      end
      item
        Name = 'inStringKey'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'StringKey'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inObjectMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MainId'
        ParamType = ptInput
      end
      item
        Name = 'inObjectChildId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ValueId'
        ParamType = ptInput
      end
      item
        Name = 'inLinkTypeId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'LinkTypeId'
        ParamType = ptInput
      end
      item
        Name = 'inText'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'SomeText'
        DataType = ftWideString
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 248
    Top = 168
  end
end
