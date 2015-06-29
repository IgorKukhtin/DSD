DROP FUNCTION IF EXISTS gpDelete_AlternativeGroup_Goods (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_AlternativeGroup_Goods(
    IN inAlternativeGroupId       Integer   ,    -- группа альтернатив
    IN inGoodsId                  Integer   ,    -- Товар
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   --DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_AlternativeGroup());
  -- vbUserId := inSession;
  IF COALESCE(inGoodsId,0) <> 0 THEN
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
ALTER FUNCTION gpDelete_AlternativeGroup_Goods (Integer, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А. А.
 29.06.15                                                          *
*/

-- тест
-- SELECT * FROM gpDelete_AlternativeGroup_Goods(0,0,'3')

