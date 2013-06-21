
CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_Object_ProfitLossDirection()
  RETURNS TVarChar AS
$BODY$BEGIN
  RETURN 'zc_Enum_Process_Select_Object_ProfitLossDirection';
END;$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION zc_Enum_Process_Select_Object_ProfitLossDirection() OWNER TO postgres;


CREATE OR REPLACE FUNCTION zc_Enum_Process_Get_Object_ProfitLossDirection()
  RETURNS TVarChar AS
$BODY$BEGIN
  RETURN 'zc_Enum_Process_Get_Object_ProfitLossDirection';
END;$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION zc_Enum_Process_Get_Object_ProfitLossDirection() OWNER TO postgres;


CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_ProfitLossDirection()
  RETURNS TVarChar AS
$BODY$BEGIN
  RETURN 'zc_Enum_Process_InsertUpdate_Object_ProfitLossDirection';
END;$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION zc_Enum_Process_InsertUpdate_Object_ProfitLossDirection() OWNER TO postgres;


 PERFORM lpInsertUpdate_Object_Process (zc_Enum_Process_Select_Object_ProfitLossDirection(), 'Проверка получения данных');
 PERFORM lpInsertUpdate_Object_Process (zc_Enum_Process_Get_Object_ProfitLossDirection(), 'Проверка выборки данных');
 PERFORM lpInsertUpdate_Object_Process (zc_Enum_Process_InsertUpdate_Object_ProfitLossDirection(), 'Проверка сохранения данных');

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.06.13          *                             *

*/