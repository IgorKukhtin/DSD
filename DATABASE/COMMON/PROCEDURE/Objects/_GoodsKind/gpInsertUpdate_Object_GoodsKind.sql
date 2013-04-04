-- Function: gpInsertUpdate_Object_GoodsKind()

-- DROP FUNCTION gpInsertUpdate_Object_GoodsKind();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsKind(
INOUT ioId	         Integer   ,   	/* ключ объекта < Тип товара> */
IN inCode                Integer   ,    /* Код объекта <Тип товара> */
IN inName                TVarChar  ,    /* Название объекта <Тип товара> */
IN inSession             TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsKind());

   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_GoodsKind(), inName);

   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsKind(), inCode, inName);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            