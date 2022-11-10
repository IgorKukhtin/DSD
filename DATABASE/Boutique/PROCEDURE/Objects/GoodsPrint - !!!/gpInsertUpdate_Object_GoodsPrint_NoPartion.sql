-- Function: gpInsertUpdate_Object_GoodsPrint (Integer, Integer, Integer, Integer, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPrint_NoPartion (Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPrint_NoPartion(
 INOUT ioOrd               Integer,      -- № п/п сессии GoodsPrint
 INOUT ioUserId            Integer,      -- Пользователь сессии GoodsPrint
    IN inUnitId            Integer,      --
    --IN inPartionId         Integer,      --
    IN inGoodsId           Integer,      --
    IN inAmount            TFloat,       --
   OUT outGoodsPrintName   TVarChar,     --
   OUT outUserName         TVarChar,     -- 
    IN inSession           TVarChar      -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId      Integer;
  DECLARE vbInsertDate  TDateTime;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_GoodsPrint());

   --находим по товару все партии  и добавляем в список печати
   SELECT DISTINCT tmp.ioOrd, tmp.outUserName, tmp.outGoodsPrintName
          INTO ioOrd, outUserName, outGoodsPrintName
   FROM (
         SELECT tmp.ioOrd, tmp.outUserName, tmp.outGoodsPrintName
         FROM ( 
               SELECT Container.PartionId     AS PartionId
                    , Container.ObjectId      AS GoodsId
                    , Container.WhereObjectId AS UnitId
                    , SUM (CASE WHEN CLO_Client.ContainerId IS NULL THEN COALESCE (Container.Amount, 0) ELSE 0 END)  AS Amount
                    --, SUM (CASE WHEN CLO_Client.ContainerId > 0     THEN COALESCE (Container.Amount, 0) ELSE 0 END)  AS AmountDebt
               FROM Container
                    LEFT JOIN ContainerLinkObject AS CLO_Client
                                                  ON CLO_Client.ContainerId = Container.Id
                                                 AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
               WHERE Container.DescId        = zc_Container_Count()
                 AND (Container.WhereObjectId = inUnitId)
                 AND Container.Amount        > 0
                 AND Container.ObjectId       = inGoodsId
               GROUP BY Container.PartionId
                      , Container.ObjectId
                      , Container.WhereObjectId
               ) AS tmpPart
               LEFT JOIN lpInsertUpdate_Object_GoodsPrint (ioOrd       := ioOrd
                                                         , ioUserId    := ioUserId
                                                         , inUnitId    := inUnitId
                                                         , inPartionId := tmpPart.PartionId
                                                         , inAmount    := tmpPart.Amount
                                                         , inIsReprice := FALSE      -- может измениться
                                                         , inUserId    := vbUserId
                                                          ) AS tmp ON 1=1
        ) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 08.11.22         *
*/

-- тест
--