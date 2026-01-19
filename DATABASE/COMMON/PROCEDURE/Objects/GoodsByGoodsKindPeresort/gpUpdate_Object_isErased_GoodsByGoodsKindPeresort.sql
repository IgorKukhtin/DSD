 -- Function: gpUpdate_Object_isErased_GoodsByGoodsKindPeresort (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_GoodsByGoodsKindPeresort (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_GoodsByGoodsKindPeresort(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_isErased_GoodsByGoodsKindPeresort());

   -- изменили
   PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);

   if vbUserId = 9457 
   then 
       RAISE EXCEPTION 'Тест ОК. Админ.';
   end if; 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
  19.01.26        *
*/
