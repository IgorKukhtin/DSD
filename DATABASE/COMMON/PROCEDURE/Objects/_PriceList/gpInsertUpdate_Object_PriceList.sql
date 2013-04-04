-- Function: gpInsertUpdate_Object_PriceList()

-- DROP FUNCTION gpInsertUpdate_Object_PriceList();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PriceList(
INOUT ioId	         Integer   ,   	/* ключ объекта < Бизнес> */
IN inCode                Integer   ,    /* Код объекта <Бизнес> */
IN inName                TVarChar  ,    /* Название объекта <Бизнес> */
IN inSession             TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_PriceList());

   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PriceList(), inName);

   ioId := lpInsertUpdate_Object(ioId, zc_Object_PriceList(), inCode, inName);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            