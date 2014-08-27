-- Function: gpInsert_Object_GoodsByGoodsKind1CLink (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsert_Object_GoodsByGoodsKind1CLink (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_GoodsByGoodsKind1CLink(
    IN inBranchTopId            Integer,    -- 
    IN inSession                TVarChar DEFAULT ''       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Insert_Object_GoodsByGoodsKind1CLink());
   vbUserId := lpGetUserBySession (inSession);

   -- проверка
   IF COALESCE (inBranchTopId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка.Не установлен <Филиал>.';
   END IF;

   -- сохраняем всех
   PERFORM gpInsertUpdate_Object_GoodsByGoodsKind1CLink (inId         := 0
                                                       , inCode       := Sale1C.GoodsCode
                                                       , inName       := Sale1C.GoodsName
                                                       , inGoodsId    := NULL
                                                       , inGoodsKindId:= NULL
                                                       , inBranchId   := NULL
                                                       , inBranchTopId:= inBranchTopId
                                                       , inIsSybase   := FALSE
                                                       , inSession    := inSession)
   FROM (SELECT Sale1C.GoodsCode, Sale1C.GoodsName
         FROM Sale1C
         WHERE zfGetBranchLinkFromBranchPaidKind(zfGetBranchFromUnitId (Sale1C.UnitId), zfGetPaidKindFrom1CType(Sale1C.VidDoc)) = inBranchTopId
           AND Sale1C.GoodsCode <> 0
         GROUP BY Sale1C.GoodsCode, Sale1C.GoodsName
        ) AS Sale1C
        LEFT JOIN (SELECT Object_GoodsByGoodsKind1CLink.ObjectCode
                        , ObjectLink_GoodsByGoodsKind1CLink_Branch.ChildObjectId  AS BranchId
                   FROM Object AS Object_GoodsByGoodsKind1CLink
                        LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind1CLink_Branch
                                             ON ObjectLink_GoodsByGoodsKind1CLink_Branch.ObjectId = Object_GoodsByGoodsKind1CLink.Id
                                            AND ObjectLink_GoodsByGoodsKind1CLink_Branch.DescId = zc_ObjectLink_GoodsByGoodsKind1CLink_Branch()
                   WHERE Object_GoodsByGoodsKind1CLink.DescId =  zc_Object_GoodsByGoodsKind1CLink()
                     AND Object_GoodsByGoodsKind1CLink.ObjectCode <> 0
                  ) AS tmpGoodsByGoodsKind1CLink ON tmpGoodsByGoodsKind1CLink.BranchId = inBranchTopId
                                                AND tmpGoodsByGoodsKind1CLink.ObjectCode = Sale1C.GoodsCode
   WHERE tmpGoodsByGoodsKind1CLink.ObjectCode IS NULL;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsert_Object_GoodsByGoodsKind1CLink (Integer, TVarChar)  OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.08.14                                        *
*/
