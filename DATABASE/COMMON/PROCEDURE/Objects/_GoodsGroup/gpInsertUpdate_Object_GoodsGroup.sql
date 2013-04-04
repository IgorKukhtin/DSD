-- Function: gpInsertUpdate_Object_GoodsGroup()

-- DROP FUNCTION gpInsertUpdate_Object_GoodsGroup();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroup(
INOUT ioId	         Integer   ,   	/* ключ объекта <Группа подразделений> */
IN inCode                Integer   ,    /* Код объекта <Группа товаров> */
IN inName                TVarChar  ,    /* Название объекта <Группа товаров> */
IN inGoodsGroupId         Integer   ,    /* ссылка на группу товаров */
IN inSession             TVarChar       /* текущий пользователь */
)
  RETURNS integer AS
$BODY$BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());

   -- Проверем уникальность имени
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_GoodsGroup(), inName);
   -- Проверем цикл у дерева
   PERFORM lpCheck_Object_CycleLink(ioId, zc_ObjectLink_GoodsGroup_GoodsGroup(), inGoodsGroupId);

   -- Вставляем объект
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsGroup(), inCode, inName);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsGroup_GoodsGroup(), ioId, inGoodsGroupId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_GoodsGroup(Integer, Integer, TVarChar, Integer, tvarchar)
  OWNER TO postgres;

  
                            