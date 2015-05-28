unit RunScript;

interface

type

  TRunScript = class
  private
    class function CallMethod(Instance: TObject; ClassType: TClass;
          const MethodName: String; var Params: Variant): Variant;
    class procedure SetProperty(Obj: TObject; PropertyName: string; Value: Variant);
  public
    class procedure RunScript(ScriptFile: string);
  end;

implementation

uses ScriptXML, ParentForm, FormStorage, ActnList, Classes, SysUtils,
     dsdAction, Log, RTTI, fs_ipascal, fs_iinterpreter, DateUtils, Variants;

{ TRunScript }
var fsScript: TfsScript;
    fsPascal: TfsPascal;

type
  TAccessdsdAction = class(TdsdCustomAction)

  end;

class function TRunScript.CallMethod(Instance: TObject; ClassType: TClass;
  const MethodName: String; var Params: Variant): Variant;
begin
  if LowerCase(MethodName) = 'incmonth' then
     result := IncMonth(Params[0], Params[1]);
end;

class procedure TRunScript.RunScript(ScriptFile: string);
var
   SCRIPT: IXMLSCRIPTType;
   i, j: integer;
   Form: TParentForm;
   Action, Component: TComponent;
begin
   SCRIPT := LoadSCRIPT(ScriptFile);
   for i := 0 to SCRIPT.Count - 1 do begin
       Form := TdsdFormStorageFactory.GetStorage.Load(SCRIPT.FORM[i].Name);
       Form.Execute(nil, nil);
       for j := 0 to SCRIPT.FORM[i].COMPONENTS.Count - 1 do begin
           Component := Form.FindComponent(SCRIPT.FORM[i].COMPONENTS.COMPONENT[j].Name);
           SetProperty(Component, SCRIPT.FORM[i].COMPONENTS.COMPONENT[j].PropertyName
                                , fsScript.Evaluate(SCRIPT.FORM[i].COMPONENTS.COMPONENT[j].Value));
       end;
       for j := 0 to SCRIPT.FORM[i].ACTIONS.Count - 1 do begin
           Action := Form.FindComponent(SCRIPT.FORM[i].ACTIONS.ACTION[j].Name);
           if Assigned(Action) and (Action is TCustomAction) then begin
              if Action is TdsdCustomAction then begin
                 TAccessdsdAction(Action).QuestionBeforeExecute := '';
                 TAccessdsdAction(Action).InfoAfterExecute := '';
              end;
              try
                TCustomAction(Action).Execute;
              except
                on E: Exception do
                   Logger.AddToLog(E.Message);
              end;
           end;
       end;
       FreeAndNil(Form);
   end;
end;

class procedure TRunScript.SetProperty(Obj: TObject; PropertyName: string;
  Value: Variant);
var ctx : TRttiContext;
    RttiType : TRttiType;
    RttiProperty : TRttiProperty;
    Val: TValue;
    vDate: TDateTime;
begin
    ctx := TRttiContext.Create();
    PropertyName := LowerCase(PropertyName);
    try
      RttiType := ctx.GetType(obj.ClassType);
      if RttiType = nil then exit;

      for RttiProperty in RttiType.GetProperties() do begin
          if LowerCase(RttiProperty.Name) <> PropertyName then continue;
          case VarType(Value) of
             varDate: begin
                  vDate := Value;
                  Val := TValue.From<TDateTime>(vDate);
             end
             else
               Val.FromVariant(Value);
          end;
          RttiProperty.SetValue(obj, Val);
      end;
    finally
      ctx.Free();
    end;
end;

initialization
  fsScript := TfsScript.Create(nil);
  fsPascal := TfsPascal.Create(nil);
  fsScript.Parent := fsGlobalUnit;
  fsScript.SyntaxType := 'PascalScript';  fsScript.AddMethod('function IncMonth(ADate: TDateTime; NumberOfMonths: integer): TDateTime',           TRunScript.CallMethod);
finalization
  FreeAndNil(fsScript);
  FreeAndNil(fsPascal);

end.
