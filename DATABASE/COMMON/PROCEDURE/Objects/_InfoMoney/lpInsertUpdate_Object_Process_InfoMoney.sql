
CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_Object_InfoMoney()
  RETURNS TVarChar AS
$BODY$BEGIN
  RETURN 'zc_Enum_Process_Select_Object_InfoMoney';
END;$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION zc_Enum_Process_Select_Object_InfoMoney() OWNER TO postgres;


CREATE OR REPLACE FUNCTION zc_Enum_Process_Get_Object_InfoMoney()
  RETURNS TVarChar AS
$BODY$BEGIN
  RETURN 'zc_Enum_Process_Get_Object_InfoMoney';
END;$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION zc_Enum_Process_Get_Object_InfoMoney() OWNER TO postgres;


CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_InfoMoney()
  RETURNS TVarChar AS
$BODY$BEGIN
  RETURN 'zc_Enum_Process_InsertUpdate_Object_InfoMoney';
END;$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION zc_Enum_Process_InsertUpdate_Object_InfoMoney() OWNER TO postgres;


 PERFORM lpInsertUpdate_Object_Process (zc_Enum_Process_Select_Object_InfoMoney(), 'Проверка получения данных');
 PERFORM lpInsertUpdate_Object_Process (zc_Enum_Process_Get_Object_InfoMoney(), 'Проверка выборки данных');
 PERFORM lpInsertUpdate_Object_Process (zc_Enum_Process_InsertUpdate_Object_InfoMoney(), 'Проверка сохранения данных');

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.06.13          *                             *

*/