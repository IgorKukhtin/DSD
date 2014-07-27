-- Function: lpInsertFind_Object_PartionGoods (Integer, TVarChar)

DROP FUNCTION IF EXISTS lpInsertFind_Object_PartionGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertFind_Object_PartionGoods(
    IN inStorageId  Integer -- Место хранения
    IN inInvNumber  TVarChar  -- Инвентарный номер
)
  RETURNS Integer AS
$BODY$
   DECLARE vbPartionGoodsId Integer;
BEGIN
     -- меняем параметр
     IF COALESCE (inInvNumber, '') = ''
     THEN
         inInvNumber:= '0';
     END IF;

     -- Находим
     IF COALESCE (inStorageId, 0) = 0
     THEN 
         vbPartionGoodsId:= (SELECT Object.Id
                             FROM Object
                                  INNER JOIN ObjectLink ON ObjectLink.ObjectId = Object.Id
                                                       AND ObjectLink.DescId = zc_ObjectLink_PartionGoods_Storage()
                                                       AND ObjectLink.ChildObjectId IS NULL
                             WHERE Object.ValueData = inInvNumber
                               AND Object.DescId = zc_Object_PartionGoods()
                            );
     THEN 
         vbPartionGoodsId:= (SELECT Object.Id
                             FROM Object
                                  INNER JOIN ObjectLink ON ObjectLink.ObjectId = Object.Id
                                                       AND ObjectLink.DescId = zc_ObjectLink_PartionGoods_Storage()
                                                       AND ObjectLink.ChildObjectId = inStorageId
                             WHERE Object.ValueData = inInvNumber
                               AND Object.DescId = zc_Object_PartionGoods()
                            );
     END IF;

     -- Если не нашли
     IF COALESCE (vbPartionGoodsId, 0) = 0
     THEN
         -- сохранили <Объект>
         vbPartionGoodsId := lpInsertUpdate_Object (vbPartionGoodsId, zc_Object_PartionGoods(), 0, inInvNumber);

         -- сохранили
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PartionGoods_Storage(), vbPartionGoodsId, CASE WHEN inStorageId = 0 THEN NULL ELSE inStorageId END);

     END IF;

     -- Возвращаем значение
     RETURN (vbPartionGoodsId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertFind_Object_PartionGoods (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.07.14                                        *
*/

-- тест
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inOperDate:= '31.01.2013');
-- SELECT * FROM lpInsertFind_Object_PartionGoods (inOperDate:= NULL);