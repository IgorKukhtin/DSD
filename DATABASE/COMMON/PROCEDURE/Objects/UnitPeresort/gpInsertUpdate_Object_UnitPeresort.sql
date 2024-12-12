-- Function: gpInsertUpdate_Object_UnitPeresort(Integer,Integer,TVarChar,Integer,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_UnitPeresort ( Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_UnitPeresort(
 INOUT ioId                  Integer,      --
    IN inGoodsByGoodsKindId  Integer,      --
    IN inUnitId              Integer,      --
    IN inSession             TVarChar
)

RETURNS Integer
AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbIsUpdate Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   

   -- проверка уникальности
   IF EXISTS (SELECT ObjectLink_UnitPeresort_GoodsByGoodsKind.ChildObjectId
              FROM ObjectLink AS ObjectLink_UnitPeresort_GoodsByGoodsKind
                   INNER JOIN ObjectLink AS ObjectLink_UnitPeresort_Unit
                                         ON ObjectLink_UnitPeresort_Unit.ObjectId = ObjectLink_UnitPeresort_GoodsByGoodsKind.ObjectId
                                        AND ObjectLink_UnitPeresort_Unit.DescId = zc_ObjectLink_UnitPeresort_Unit()
                                        AND ObjectLink_UnitPeresort_Unit.ObjectId = inUnitId
              WHERE ObjectLink_UnitPeresort_GoodsByGoodsKind.DescId = zc_ObjectLink_UnitPeresort_GoodsByGoodsKind()
                AND ObjectLink_UnitPeresort_GoodsByGoodsKind.ChildObjectId = inGoodsByGoodsKindId
                AND ObjectLink_UnitPeresort_GoodsByGoodsKind.ObjectId <> COALESCE (ioId, 0) )
   THEN 
       RAISE EXCEPTION 'Ошибка.Значение  <%> + <%> уже есть в справочнике. Дублирование запрещено.', lfGet_Object_ValueData (inGoodsByGoodsKindId), lfGet_Object_ValueData (inUnitId);
   END IF; 


   -- определили <Признак>
   vbIsUpdate:= COALESCE (ioId, 0) > 0;
   
    -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_UnitPeresort(), 0, '');
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UnitPeresort_GoodsByGoodsKind(), ioId, inGoodsByGoodsKindId);
   -- сохранили связь с <\>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_UnitPeresort_Unit(), ioId, inUnitId);
  

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol ( ioId, vbUserId, vbIsUpdate);

END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.12.24         *
*/


