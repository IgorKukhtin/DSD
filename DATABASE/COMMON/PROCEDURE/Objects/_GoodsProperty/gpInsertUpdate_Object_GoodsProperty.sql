-- Function: gpInsertUpdate_Object_GoodsProperty()

-- DROP FUNCTION gpInsertUpdate_Object_GoodsProperty();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsProperty(
INOUT ioId               Integer   ,   	/* ключ объекта <Классификатор свойств товаров> */
IN inCode                Integer   ,    /* Код объекта <Классификатор свойств товаров> */
IN inName                TVarChar  ,    /* Название объекта <Классификатор свойств товаров> */
IN inSession             TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsProperty());

   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_GoodsProperty(), inName);

   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsProperty(), inCode, inName);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_GoodsProperty(Integer, Integer, TVarChar, TVarChar)
  OWNER TO postgres;

  
                            