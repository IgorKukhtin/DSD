-- Function: gpInsertUpdate_Object_Goods()

-- DROP FUNCTION gpInsertUpdate_Object_Goods();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods(
INOUT ioId	         Integer   ,   	/* ключ объекта <Товар> */
IN inCode                Integer   ,    /* Код объекта <Товар> */
IN inName                TVarChar  ,    /* Название объекта <Товар> */
IN inGoodsGroupId        Integer   ,    /* ссылка на группу Товаров */
IN inMeasureId           Integer   ,    /* ссылка на единицу измерения */
IN inWeight              TFloat    ,    /* */
IN inSession             TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());

   -- Проверем уникальность имени
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Goods(), inName);

   -- Вставляем объект
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Goods(), inCode, inName);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- Вставляем вес
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Goods_Weight(), ioId, inWeight);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, Integer, Integer, TFloat, tvarchar)
  OWNER TO postgres;

  
                            