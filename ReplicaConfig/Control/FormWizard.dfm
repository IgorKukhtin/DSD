object WizardForm: TWizardForm
  Left = 0
  Top = 0
  Caption = 'WizardForm'
  ClientHeight = 576
  ClientWidth = 976
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 120
  TextHeight = 16
  inline SchemaFrame: TSchemaFrame
    Left = 0
    Top = 0
    Width = 976
    Height = 253
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 976
    ExplicitHeight = 253
    inherited GridPanel: TGridPanel
      Width = 976
      Height = 253
      ControlCollection = <
        item
          Column = 1
          Control = SchemaFrame.lblSlave
          Row = 0
        end
        item
          Column = 0
          Control = SchemaFrame.lblMaster
          Row = 0
        end
        item
          Column = 0
          Control = SchemaFrame.dgMaster
          Row = 2
        end
        item
          Column = 1
          Control = SchemaFrame.dgSlave
          Row = 2
        end
        item
          Column = 0
          Control = SchemaFrame.edMasterSearch
          Row = 1
        end
        item
          Column = 1
          Control = SchemaFrame.edSlaveSearch
          Row = 1
        end>
      ExplicitWidth = 976
      ExplicitHeight = 253
      inherited lblSlave: TLabel
        Left = 486
        Width = 486
        ExplicitLeft = 486
      end
      inherited lblMaster: TLabel
        Width = 486
      end
      inherited dgMaster: TDrawGrid
        Width = 486
        Height = 203
        ExplicitWidth = 486
        ExplicitHeight = 203
      end
      inherited dgSlave: TDrawGrid
        Left = 486
        Width = 486
        Height = 203
        ExplicitLeft = 486
        ExplicitWidth = 486
        ExplicitHeight = 203
      end
      inherited edMasterSearch: TEdit
        Width = 486
        ExplicitWidth = 486
      end
      inherited edSlaveSearch: TEdit
        Left = 486
        Width = 486
        ExplicitLeft = 486
        ExplicitWidth = 486
      end
    end
  end
  inline TableFrame: TTableFrame
    Left = 0
    Top = 253
    Width = 976
    Height = 323
    Align = alClient
    TabOrder = 1
    ExplicitTop = 253
    ExplicitWidth = 976
    ExplicitHeight = 323
    inherited GridPanel: TGridPanel
      Width = 976
      Height = 323
      ControlCollection = <
        item
          Column = 1
          Control = TableFrame.lblSlave
          Row = 0
        end
        item
          Column = 0
          Control = TableFrame.lblMaster
          Row = 0
        end
        item
          Column = 0
          Control = TableFrame.dgMaster
          Row = 2
        end
        item
          Column = 1
          Control = TableFrame.dgSlave
          Row = 2
        end
        item
          Column = 0
          Control = TableFrame.edMasterSearch
          Row = 1
        end
        item
          Column = 1
          Control = TableFrame.edSlaveSearch
          Row = 1
        end>
      ExplicitWidth = 976
      ExplicitHeight = 323
      inherited lblSlave: TLabel
        Left = 486
        Width = 486
        ExplicitLeft = 486
      end
      inherited lblMaster: TLabel
        Width = 486
      end
      inherited dgMaster: TDrawGrid
        Width = 486
        Height = 273
        ExplicitWidth = 486
        ExplicitHeight = 273
      end
      inherited dgSlave: TDrawGrid
        Left = 486
        Width = 486
        Height = 273
        ExplicitLeft = 486
        ExplicitWidth = 486
        ExplicitHeight = 273
      end
      inherited edMasterSearch: TEdit
        Width = 486
        ExplicitWidth = 486
      end
      inherited edSlaveSearch: TEdit
        Left = 486
        Width = 486
        ExplicitLeft = 486
        ExplicitWidth = 486
      end
    end
  end
end
