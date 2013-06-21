
CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_Object_Account()
  RETURNS TVarChar AS
$BODY$BEGIN
  RETURN 'zc_Enum_Process_Select_Object_Account';
END;$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION zc_Enum_Process_Select_Object_Account() OWNER TO postgres;


CREATE OR REPLACE FUNCTION zc_Enum_Process_Get_Object_Account()
  RETURNS TVarChar AS
$BODY$BEGIN
  RETURN 'zc_Enum_Process_Get_Object_Account';
END;$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION zc_Enum_Process_Get_Object_Account() OWNER TO postgres;


CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_Account()
  RETURNS TVarChar AS
$BODY$BEGIN
  RETURN 'zc_Enum_Process_InsertUpdate_Object_Account';
END;$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION zc_Enum_Process_InsertUpdate_Object_Account() OWNER TO postgres;


 PERFORM lpInsertUpdate_Object_Process (zc_Enum_Process_Select_Object_Account(), 'Проверка получения данных');
 PERFORM lpInsertUpdate_Object_Process (zc_Enum_Process_Get_Object_Account(), 'Проверка выборки данных');
 PERFORM lpInsertUpdate_Object_Process (zc_Enum_Process_InsertUpdate_Object_Account(), 'Проверка сохранения данных');

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.06.13          *                             *

*/