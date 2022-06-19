-- Документ <>
CREATE OR REPLACE FUNCTION zc_Enum_Process_Update_Movement_CashSend_CommentMoveMoney() RETURNS Integer AS $BODY$BEGIN RETURN (SELECT ObjectId AS Id FROM ObjectString WHERE ValueData = 'zc_Enum_Process_Update_Movement_CashSend_CommentMoveMoney' AND DescId = zc_ObjectString_Enum()); END; $BODY$ LANGUAGE plpgsql IMMUTABLE;

DO $$
BEGIN

-- Документ <>
PERFORM lpInsertUpdate_Object_Enum (inId:= zc_Enum_Process_Update_Movement_CashSend_CommentMoveMoney()
                                  , inDescId:= zc_Object_Process()
                                  , inCode:= 1
                                  , inName:= 'Документ <'||(SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_CashSend())||'> - сохранение данных.'
                                  , inEnumName:= 'zc_Enum_Process_Update_Movement_CashSend_CommentMoveMoney');

END $$;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.06.22         *
*/
