
CREATE OR REPLACE FUNCTION zc_Enum_Process_Select_Object_ProfitLossGroup()
  RETURNS TVarChar AS
$BODY$BEGIN
  RETURN 'zc_Enum_Process_Select_Object_ProfitLossGroup';
END;$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION zc_Enum_Process_Select_Object_ProfitLossGroup() OWNER TO postgres;


CREATE OR REPLACE FUNCTION zc_Enum_Process_Get_Object_ProfitLossGroup()
  RETURNS TVarChar AS
$BODY$BEGIN
  RETURN 'zc_Enum_Process_Get_Object_ProfitLossGroup';
END;$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION zc_Enum_Process_Get_Object_ProfitLossGroup() OWNER TO postgres;


CREATE OR REPLACE FUNCTION zc_Enum_Process_InsertUpdate_Object_ProfitLossGroup()
  RETURNS TVarChar AS
$BODY$BEGIN
  RETURN 'zc_Enum_Process_InsertUpdate_Object_ProfitLossGroup';
END;$BODY$
LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION zc_Enum_Process_InsertUpdate_Object_ProfitLossGroup() OWNER TO postgres;


 PERFORM lpInsertUpdate_Object_Process (zc_Enum_Process_Select_Object_ProfitLossGroup(), 'Проверка получения данных');
 PERFORM lpInsertUpdate_Object_Process (zc_Enum_Process_Get_Object_ProfitLossGroup(), 'Проверка выборки данных');
 PERFORM lpInsertUpdate_Object_Process (zc_Enum_Process_InsertUpdate_Object_ProfitLossGroup(), 'Проверка сохранения данных');

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.06.13          *                             *

*/