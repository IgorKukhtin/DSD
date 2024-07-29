 -- Function: gpInsertUpdate_Object_ChoiceCell_Load()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ChoiceCell_Load (Integer, Integer, TVarChar, Integer, TVarChar, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ChoiceCell_Load(
    IN inNPP           Integer    ,
    IN inCode          Integer    ,
    IN inName          TVarChar    ,
    IN inGoodsCode     Integer    ,
    IN inGoodsName     TVarChar    ,
    IN inGoodsKindName TVarChar    ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId       Integer;
   DECLARE vbChoiceCellId Integer;
   DECLARE vbGoodsId      Integer;
   DECLARE vbGoodsKindId  Integer;

BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!Пустой код - Пропустили!!!
     IF COALESCE (inCode, 0) = 0 THEN
        RETURN; -- !!!ВЫХОД!!!
     END IF;

     IF COALESCE (inNPP,0) = 0
     THEN
        RAISE EXCEPTION 'Ошибка. № п/п для ячейки = <(%)%> + товар = <(%)%> не указан.', inCode, inName, inGoodsCode, inGoodsName;
     END IF;


     -- пробуем найти ячейку по коду
     vbChoiceCellId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_ChoiceCell() AND Object.ObjectCode = inCode);


     IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode = inGoodsCode) AND inGoodsCode > 0
     THEN
         RAISE EXCEPTION 'Ошибка. Товар <%> по коду <%> найден несколько раз.', inGoodsName, inGoodsCode;
     END IF;

     -- находим товар по коду
     vbGoodsId := (SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_Goods() AND Object.ObjectCode = inGoodsCode AND inGoodsCode > 0);

     IF COALESCE (vbGoodsId,0) = 0 AND inGoodsCode > 0
     THEN
        RAISE EXCEPTION 'Ошибка. Товар <%> по коду <%> не найден.', inGoodsName, inGoodsCode;
     END IF;


     -- находим вид товара
     vbGoodsKindId := (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inGoodsKindName) AND Object.DescId = zc_Object_GoodsKind() AND TRIM (inGoodsKindName) <> '');

     IF COALESCE (vbGoodsKindId,0) = 0 AND TRIM (inGoodsKindName) <> ''
     THEN
        RAISE EXCEPTION 'Ошибка. Вид товара по названию <%> не найден.', inGoodsKindName;
     END IF;


     IF COALESCE (vbChoiceCellId,0) = 0
     THEN
         PERFORM gpInsertUpdate_Object_ChoiceCell( ioId          := COALESCE (vbChoiceCellId,0) :: Integer
                                                 , inCode        := inCode                      :: Integer
                                                 , inName        := TRIM (inName) :: TVarChar
                                                 , inGoodsId     := vbGoodsId     :: Integer
                                                 , inGoodsKindId := vbGoodsKindId :: Integer
                                                 , inBoxCount    := NULL         :: TFloat
                                                 , inNPP         := NULL         :: TFloat
                                                 , inComment     := NULL      :: TVarChar
                                                 , inSession     := (-1 * vbUserId) :: TVarChar
                                                 );
     ELSE
         PERFORM gpInsertUpdate_Object_ChoiceCell( ioId          := COALESCE (vbChoiceCellId,0) :: Integer
                                                 , inCode        := inCode                      :: Integer
                                                 , inName        := TRIM (inName) :: TVarChar
                                                 , inGoodsId     := vbGoodsId     :: Integer
                                                 , inGoodsKindId := vbGoodsKindId :: Integer
                                                 , inBoxCount    := tmp.BoxCount  :: TFloat
                                                 , inNPP         := inNPP       :: TFloat
                                                 , inComment     := tmp.Comment   :: TVarChar
                                                 , inSession     := (-1 * vbUserId) :: TVarChar
                                                 )
         FROM gpSelect_Object_ChoiceCell (FALSE, inSession) AS tmp
         WHERE tmp.Id = vbChoiceCellId;

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