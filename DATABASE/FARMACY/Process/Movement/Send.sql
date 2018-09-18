-- Status
CREATE OR REPLACE FUNCTION zc_Enum_Process_CompleteDate_Send() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_CompleteDate_Send' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;
CREATE OR REPLACE FUNCTION zc_Enum_Process_Insert_MI_Send_Remains() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Insert_MI_Send_Remains' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$


BEGIN

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_CompleteDate_Send()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Send())||'> - Проведение задним числом.'
                                  , inEnumName:= 'zc_Enum_Process_CompleteDate_Send');

PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Insert_MI_Send_Remains()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Элемент документа <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_OrderInternal())||'> - Списание всего остаток с точки.'
                                  , inEnumName:= 'zc_Enum_Process_Insert_MI_Send_Remains');
END $$;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 04.08.17         *
*/
