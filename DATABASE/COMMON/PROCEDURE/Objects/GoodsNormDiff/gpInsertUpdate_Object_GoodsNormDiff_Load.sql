 -- Function: gpInsertUpdate_Object_GoodsNormDiff_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsNormDiff_Load (Integer, TVarChar, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsNormDiff_Load(
    IN inGoodsCode     Integer    ,
    --IN inGoodsName     TVarChar    ,
    IN inGoodsKindName TVarChar    ,
    IN inValuePF       TFloat ,
    IN inValueGP       TFloat ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbGoodsNormDiffId Integer;
   DECLARE vbGoodsId      Integer;
   DECLARE vbGoodsKindId  Integer;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!Пустой код - Пропустили!!!
     IF COALESCE (inGoodsCode, 0) = 0 THEN
        RETURN; -- !!!ВЫХОД!!!
     END IF;


     IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode = inGoodsCode) AND inGoodsCode > 0
     THEN
         RAISE EXCEPTION 'Ошибка. Товар по коду <%> найден несколько раз.', inGoodsCode;
     END IF;

     -- находим товар по коду
     vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode = inGoodsCode AND inGoodsCode > 0);

     IF COALESCE (vbGoodsId,0) = 0 AND inGoodsCode > 0
     THEN
        RAISE EXCEPTION 'Ошибка. Товар по коду <%> не найден.', inGoodsCode;
     END IF;


     -- находим вид товара
     vbGoodsKindId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsKindName) AND Object.DescId = zc_Object_GoodsKind() AND TRIM (inGoodsKindName) <> '');

     IF COALESCE (vbGoodsKindId,0) = 0 AND TRIM (inGoodsKindName) <> ''
     THEN
        RAISE EXCEPTION 'Ошибка. Вид товара по названию <%> не найден.', inGoodsKindName;
     END IF;

     --пробуем найти Норму отклонения 
     vbGoodsNormDiffId := (SELECT Object_GoodsNormDiff.Id
                           FROM Object AS Object_GoodsNormDiff
                                INNER JOIN ObjectLink AS ObjectLink_Goods
                                                      ON ObjectLink_Goods.ObjectId = Object_GoodsNormDiff.Id
                                                     AND ObjectLink_Goods.DescId = zc_ObjectLink_GoodsNormDiff_Goods()
                                                     AND ObjectLink_Goods.ChildObjectId = vbGoodsId
   
                                LEFT JOIN ObjectLink AS ObjectLink_GoodsKind
                                                     ON ObjectLink_GoodsKind.ObjectId = Object_GoodsNormDiff.Id
                                                    AND ObjectLink_GoodsKind.DescId = zc_ObjectLink_GoodsNormDiff_GoodsKind()

                           WHERE Object_GoodsNormDiff.DescId = zc_Object_GoodsNormDiff()
                             AND Object_GoodsNormDiff.isErased = False  
                             AND COALESCE (ObjectLink_GoodsKind.ChildObjectId,0) = COALESCE (vbGoodsKindId,0)
                          );
     
     IF COALESCE (vbGoodsNormDiffId,0) = 0
     THEN
         PERFORM gpInsertUpdate_Object_GoodsNormDiff( ioId          := COALESCE (vbGoodsNormDiffId,0) :: Integer
                                                    , inGoodsId     := vbGoodsId     :: Integer
                                                    , inGoodsKindId := vbGoodsKindId :: Integer
                                                    , inValuePF     := inValuePF         :: TFloat
                                                    , inValueGP     := inValueGP         :: TFloat
                                                    , inComment     := NULL      :: TVarChar
                                                    , inSession     := inSession :: TVarChar
                                                    );
     ELSE
         PERFORM gpInsertUpdate_Object_GoodsNormDiff( ioId          := COALESCE (vbGoodsNormDiffId,0) :: Integer
                                                    , inGoodsId     := vbGoodsId     :: Integer
                                                    , inGoodsKindId := vbGoodsKindId :: Integer
                                                    , inValuePF     := inValuePF     :: TFloat
                                                    , inValueGP     := inValueGP     :: TFloat
                                                    , inComment     := tmp.Comment   :: TVarChar
                                                    , inSession     := inSession     :: TVarChar
                                                    )
         FROM gpSelect_Object_GoodsNormDiff (FALSE, inSession) AS tmp
         WHERE tmp.Id = vbGoodsNormDiffId;
     END IF;

     IF vbUserId = 9457 
     THEN 
          RAISE EXCEPTION 'ok.Test %,   %',  lfGet_Object_ValueData (vbGoodsId), lfGet_Object_ValueData (inGoodsKindName);
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.07.24         *
*/

-- тест
--