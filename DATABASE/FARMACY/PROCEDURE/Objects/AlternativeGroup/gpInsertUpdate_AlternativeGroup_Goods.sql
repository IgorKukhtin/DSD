DROP FUNCTION IF EXISTS gpInsertUpdate_AlternativeGroup_Goods (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_AlternativeGroup_Goods(
    IN inAlternativeGroupId       Integer   ,    -- группа альтернатив
    IN inGoodsId                  Integer   ,    -- Товар
    IN inInGroup                  Boolean   ,    -- True - добавить в группу/ false - удалить из группы
   OUT outAlternativeGroupId      Integer   ,    -- группа альтернатив
    IN inSession                  TVarChar       -- сессия пользователя
)
AS
$BODY$
   --DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_AlternativeGroup());
  -- vbUserId := inSession;
  IF inInGroup = True THEN
    PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_AlternativeGroup(), inGoodsId, inAlternativeGroupId);
  ELSE
    Delete from objectlink
    Where
      DescId = zc_ObjectLink_Goods_AlternativeGroup()
      AND 
      ObjectId = inGoodsId
      AND
      childobjectid = inAlternativeGroupId;
  END IF;  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_AlternativeGroup_Goods (Integer, Integer, BOOLEAN, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А. А.
 28.06.15                                                          *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_AlternativeGroup_Goods(0,0,False,'3')

