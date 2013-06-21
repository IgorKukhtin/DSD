
CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_Object_InfoMoneyDestination()
  RETURNS TVarChar AS
$BODY$BEGIN
  RETURN 'zc_Enum_Process_Select_Object_InfoMoneyDestination';
END;$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION zc_Enum_Process_Select_Object_InfoMoneyDestination() OWNER TO postgres;


CREATE OR REPLACE FUNCTION zc_Enum_Process_Get_Object_InfoMoneyDestination()
  RETURNS TVarChar AS
$BODY$BEGIN
  RETURN 'zc_Enum_Process_Get_Object_InfoMoneyDestination';
END;$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION zc_Enum_Process_Get_Object_InfoMoneyDestination() OWNER TO postgres;


CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_InfoMoneyDestination()
  RETURNS TVarChar AS
$BODY$BEGIN
  RETURN 'zc_Enum_Process_InsertUpdate_Object_InfoMoneyDestination';
END;$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION zc_Enum_Process_InsertUpdate_Object_InfoMoneyDestination() OWNER TO postgres;


 PERFORM lpInsertUpdate_Object_Process (zc_Enum_Process_Select_Object_InfoMoneyDestination(), 'Проверка получения данных');
 PERFORM lpInsertUpdate_Object_Process (zc_Enum_Process_Get_Object_InfoMoneyDestination(), 'Проверка выборки данных');
 PERFORM lpInsertUpdate_Object_Process (zc_Enum_Process_InsertUpdate_Object_InfoMoneyDestination(), 'Проверка сохранения данных');

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.06.13          *                             *

*/