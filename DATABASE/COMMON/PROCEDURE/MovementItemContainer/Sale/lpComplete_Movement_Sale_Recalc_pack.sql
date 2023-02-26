-- Function: lpComplete_Movement_Sale_Recalc_pack (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_Sale_Recalc_pack (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Sale_Recalc_pack(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
RETURNS VOID
AS
$BODY$
  DECLARE vbStatusId Integer;
BEGIN

     vbStatusId:= (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);


if inUserId = 5 
then
     IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME ILIKE '_tmp_test')
     THEN
         -- таблица - суммовые элементы документа, со всеми свойствами для формирования Аналитик в проводках
         CREATE TEMP TABLE _tmp_test (MovementItemId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     ELSE
         DELETE FROM  _tmp_test;
     END IF;

     --     
     INSERT INTO _tmp_test (MovementItemId, GoodsId, Amount)
        SELECT MovementItem.Id, MovementItem.ObjectId, MovementItem.Amount
        FROM MovementItem
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased   = FALSE
       ;
end if;

     --
     UPDATE Movement SET StatusId = zc_Enum_Status_UnComplete() WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete();

     -- Сохранили Протокол
     PERFORM lpInsert_MovementItemProtocol (tmpMI.MovementItemId, inUserId, FALSE)

     FROM (-- Сохранили
           SELECT lpInsertUpdate_MovementItem (tmpMI.MovementItemId, tmpMI.DescId, tmpMI.GoodsId, tmpMI.MovementId, tmpMI.Amount_cacl, tmpMI.ParentId)
                , lpInsertUpdate_MovementItemFloat (zc_MIFloat_CountPack(), tmpMI.MovementItemId, tmpMI.CountPack)
                , tmpMI.MovementItemId
           FROM
                -- элементы
               (WITH tmpMI AS (SELECT MovementItem.*
                                    , MILinkObject_GoodsKind.ObjectId      AS GoodsKindId
                                    , ObjectFloat_WeightPackage.ValueData  AS WeightPackage
                                    , ObjectFloat_WeightTotal.ValueData    AS WeightTotal
                               FROM MovementItem
                                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                    INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                                          ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = MovementItem.ObjectId
                                                         AND ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                                    INNER JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                          ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                         AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                         AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = MILinkObject_GoodsKind.ObjectId
                                    -- вес 1-ого пакета - Вес пакета для УПАКОВКИ
                                    LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                                          ON ObjectFloat_WeightPackage.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                         AND ObjectFloat_WeightPackage.DescId   = zc_ObjectFloat_GoodsByGoodsKind_WeightPackage()
                                    -- вес в упаковке - "чистый" вес + вес 1-ого пакета
                                    LEFT JOIN ObjectFloat AS ObjectFloat_WeightTotal
                                                          ON ObjectFloat_WeightTotal.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                         AND ObjectFloat_WeightTotal.DescId   = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()
                               WHERE MovementItem.MovementId = inMovementId
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE
                              )
                   , tmp AS (SELECT MovementItem.Id                           AS MovementItemId
                                  , MovementItem.DescId                       AS DescId
                                  , MovementItem.ObjectId                     AS GoodsId
                                  , MovementItem.GoodsKindId                  AS GoodsKindId
                                  , MovementItem.MovementId                   AS MovementId
                                  , MovementItem.ParentId                     AS ParentId
                                  , MIB_BarCode.ValueData                     AS isBarCode
                                  , OL_Measure.ChildObjectId                  AS MeasureId
                                  , MovementItem.Amount
                                    -- расчет кол-во шт. упаковки (пока округление до 4-х знаков)
                                  , CASE WHEN MovementItem.WeightTotal <> 0 AND MovementItem.WeightPackage <> 0 AND MovementItem.WeightTotal > MovementItem.WeightPackage
                                              THEN CAST (CAST (MIFloat_AmountPartner.ValueData / (1 - MovementItem.WeightPackage / MovementItem.WeightTotal) AS NUMERIC (16, 4)) / MovementItem.WeightTotal AS NUMERIC (16, 4))
                                         ELSE 0
                                    END :: TFloat AS CountPack
                                    -- расчет кол-во Склад
                                  , CAST ((COALESCE (MIFloat_AmountPartner.ValueData, 0)
                                           -- расчет кол-во шт. упаковки (пока округление до 4-х знаков)
                                         + CASE WHEN MovementItem.WeightTotal <> 0 AND MovementItem.WeightPackage <> 0 AND MovementItem.WeightTotal > MovementItem.WeightPackage
                                                     THEN CAST (CAST (MIFloat_AmountPartner.ValueData / (1 - MovementItem.WeightPackage / MovementItem.WeightTotal) AS NUMERIC (16, 4)) / MovementItem.WeightTotal AS NUMERIC (16, 4))
                                                ELSE 0
                                           END :: TFloat
                                           -- вес 1-ого пакета, после этого получаем вес всех пакетов
                                         * COALESCE (MovementItem.WeightPackage, 0)
                                          )
                                         -- % скидки Вес
                                        / (1 - CASE WHEN MIFloat_ChangePercentAmount.ValueData < 100 THEN MIFloat_ChangePercentAmount.ValueData/100 ELSE 0 END)
                                         AS NUMERIC (16, 4)) AS Amount_cacl
                     
                             FROM tmpMI AS MovementItem
                                  LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                              ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                             AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                                  -- % скидки Вес
                                  LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentAmount
                                                              ON MIFloat_ChangePercentAmount.MovementItemId = MovementItem.Id
                                                             AND MIFloat_ChangePercentAmount.DescId         = zc_MIFloat_ChangePercentAmount()
                                /*LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                  AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()*/
                                  LEFT JOIN MovementItemBoolean AS MIB_BarCode
                                                                ON MIB_BarCode.MovementItemId = MovementItem.Id
                                                               AND MIB_BarCode.DescId         = zc_MIBoolean_BarCode()
                                  LEFT JOIN ObjectLink AS OL_Measure
                                                       ON OL_Measure.ObjectId = MovementItem.ObjectId
                                                      AND OL_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                                  /*LEFT JOIN Object_GoodsByGoodsKind_View
                                         ON Object_GoodsByGoodsKind_View.GoodsId     = MovementItem.ObjectId
                                        AND Object_GoodsByGoodsKind_View.GoodsKindId = MILinkObject_GoodsKind.ObjectId
                                   -- вес 1-ого пакета - Вес пакета для УПАКОВКИ
                                   LEFT JOIN ObjectFloat AS ObjectFloat_WeightPackage
                                                         ON ObjectFloat_WeightPackage.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                        AND ObjectFloat_WeightPackage.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightPackage()
                                   -- вес в упаковке - "чистый" вес + вес 1-ого пакета
                                   LEFT JOIN ObjectFloat AS MovementItem.WeightTotal
                                                         ON MovementItem.WeightTotal.ObjectId = Object_GoodsByGoodsKind_View.Id
                                                        AND MovementItem.WeightTotal.DescId = zc_ObjectFloat_GoodsByGoodsKind_WeightTotal()*/
                           /*WHERE MovementItem.MovementId = inMovementId
                               AND MovementItem.DescId     = zc_MI_Master()
                               AND MovementItem.isErased   = FALSE*/
                            )
             -- элементы
             SELECT *
             FROM tmp
             WHERE tmp.Amount_cacl <> tmp.Amount
               AND tmp.isBarCode   = TRUE
               AND tmp.MeasureId   = zc_Measure_Kg()
               AND tmp.GoodsId     > 0
               AND tmp.GoodsKindId IN (6899005, 8349) -- нар. 200 + Флоу-пак
            ) AS tmpMI

           ) AS tmpMI
      ;

     -- Админу только отладка
     if inUserId = 5 AND 1=0
     then
         RAISE EXCEPTION 'Нет Прав и нет Проверки - что б ничего не делать.Склад = <%>.Покупатель = <%>. one = <%> <%> min= <%> max=<%> '
                        , (SELECT SUM (MovementItem.Amount)
                           FROM MovementItem
                                LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                            ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE)
                        , (SELECT SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0))
                           FROM MovementItem
                                LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                            ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE)
                        , (SELECT MovementItem.Amount :: TVarChar || ' ' || lfGet_Object_ValueData (MovementItem.ObjectId) FROM MovementItem WHERE MovementItem.Id = 233583423)
                      --, (SELECT MovementItem.Amount :: TVarChar || ' ' || lfGet_Object_ValueData (MovementItem.ObjectId) FROM MovementItem WHERE MovementItem.Id = 233663447)
                        , (SELECT COUNT(*)
                           FROM MovementItem
                                JOIN _tmp_test ON _tmp_test.MovementItemId = MovementItem.Id
                                              AND _tmp_test.Amount        <> MovementItem.Amount
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                          )
                        , (SELECT MIN (MovementItem.Id)
                           FROM MovementItem
                                JOIN _tmp_test ON _tmp_test.MovementItemId = MovementItem.Id
                                              AND _tmp_test.Amount        <> MovementItem.Amount
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                          )
                        , (SELECT MAX (MovementItem.Id)
                           FROM MovementItem
                                JOIN _tmp_test ON _tmp_test.MovementItemId = MovementItem.Id
                                              AND _tmp_test.Amount        <> MovementItem.Amount
                           WHERE MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                          )
                        ;
     end if;

     --
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN
         UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Movement.Id = inMovementId;
     END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.07.22                                        *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Sale_Recalc_pack (inMovementId:= 22903221, inUserId:= zfCalc_UserAdmin() :: Integer)
