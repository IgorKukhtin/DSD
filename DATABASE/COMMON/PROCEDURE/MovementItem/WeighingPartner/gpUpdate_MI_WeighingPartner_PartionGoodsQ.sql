-- Function: gpUpdate_MI_WeighingPartner_PartionGoodsQ()

DROP FUNCTION IF EXISTS gpUpdate_MI_WeighingPartner_PartionGoodsQ (Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_WeighingPartner_PartionGoodsQ (
    IN inMovementId                 Integer   , -- 
    IN inId                         Integer   , -- идентификатор строки
    IN inGoodsId                    Integer   , -- товар
    IN inGoodsKindId                Integer   , -- вид товара
    IN inPartionGoodsDate_q         TDateTime  , -- новое значение 
    IN inPartionGoodsDate_q_old     TDateTime  , -- ранее сохраненное , для поиска
    IN inSession                    TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_MI_WeighingPartner_PartionGoodsQ());
     vbUserId:= lpGetUserBySession (inSession);


     IF inId <> 0
     THEN
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods_q(), inId, inPartionGoodsDate_q);
         -- сохранили протокол
         PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

     ELSE
         /*IF inId > 0
         THEN
              RAISE EXCEPTION 'Ошибка.Перейдите в режим "Показать весь список".';
         END IF;
         */

         --находим все строки с ключем   inGoodsId+ inGoodsKindId +inPartionGoodsDate_q_old  - и заменяем для них партию
         --зампеняем для всех   MovementItem
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartionGoods_q(), tmp.Id, inPartionGoodsDate_q)
         FROM
         (WITH
          tmpMI AS (
                    SELECT MovementItem.*
                    FROM MovementItem
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                      AND MovementItem.ObjectId   = inGoodsId
                    )
        , tmpMILO AS (SELECT MovementItemLinkObject.*
                      FROM MovementItemLinkObject
                      WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                        AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                      )
        , tmpMIDate AS (SELECT MovementItemDate.*
                        FROM MovementItemDate
                        WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                          AND MovementItemDate.DescId = zc_MIDate_PartionGoods_q()
                        )
 
         SELECT MovementItem.Id
         FROM tmpMI AS MovementItem
              LEFT JOIN tmpMIDate AS MIDate_PartionGoods_q
                                  ON MIDate_PartionGoods_q.MovementItemId = MovementItem.Id

              LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
         WHERE COALESCE (MILinkObject_GoodsKind.ObjectId, 0) = COALESCE (inGoodsKindId,0)
           AND (COALESCE (MIDate_PartionGoods_q.ValueData, zc_DateStart()) = inPartionGoodsDate_q_old OR COALESCE (inPartionGoodsDate_q_old, zc_DateStart()) = zc_DateStart())
         ) AS tmp;

     END IF;

  if vbUserId = 9457 then RAISE EXCEPTION 'Test.Ок.';  end if;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.11.25         *
*/

-- тест
--