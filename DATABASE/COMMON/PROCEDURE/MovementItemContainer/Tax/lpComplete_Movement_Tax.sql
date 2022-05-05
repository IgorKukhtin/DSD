-- Function: lpComplete_Movement_Tax()

DROP FUNCTION IF EXISTS lpComplete_Movement_Tax (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_Tax(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)
 RETURNS VOID
AS
$BODY$
  DECLARE vbOperDate     TDateTime;
  DECLARE vbOperDate_rus TDateTime;
  DECLARE vbObjectId     Integer;
  DECLARE vbPrice        TFloat;
BEGIN
     -- определили
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     -- определили
     vbOperDate_rus:= (SELECT CASE WHEN MovementString_InvNumberRegistered.ValueData <> '' THEN COALESCE (MovementDate_DateRegistered.ValueData, Movement.OperDate) ELSE CURRENT_DATE END
                       FROM Movement
                            LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                                     ON MovementString_InvNumberRegistered.MovementId = Movement.Id
                                                    AND MovementString_InvNumberRegistered.DescId     = zc_MovementString_InvNumberRegistered()
                            LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                                   ON MovementDate_DateRegistered.MovementId = Movement.Id
                                                  AND MovementDate_DateRegistered.DescId     = zc_MovementDate_DateRegistered()
                       WHERE Movement.Id = inMovementId
                      );

     -- получили цену для DocumentTaxKind
     vbPrice := (SELECT ObjectFloat_Price.ValueData
                 FROM MovementLinkObject AS MovementLinkObject_DocumentTaxKind
                      LEFT JOIN ObjectFloat AS ObjectFloat_Price
                                            ON ObjectFloat_Price.ObjectId = MovementLinkObject_DocumentTaxKind.ObjectId
                                           AND ObjectFloat_Price.DescId = zc_objectFloat_DocumentTaxKind_Price()
                 WHERE MovementLinkObject_DocumentTaxKind.MovementId = inMovementId
                   AND MovementLinkObject_DocumentTaxKind.DescId     = zc_MovementLinkObject_DocumentTaxKind()
                 );
     -- проверка цены
     IF vbPrice <> 0
     THEN
         IF EXISTS (SELECT 1
                    FROM MovementItem
                         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                     ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId     = zc_MI_Master()
                      AND MovementItem.isErased   = FALSE
                      AND MovementItem.Amount     <> 0
                      AND COALESCE (MIFloat_Price.ValueData, 0) <> vbPrice
                   )
         THEN
             RAISE EXCEPTION 'Ошибка.Для документа <%> должна быть цена = <%>'
                            , lfGet_Object_ValueData_sh ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_DocumentTaxKind()))
                            , vbPrice
                             ;
         END IF;
     END IF;

     -- поиск
     vbObjectId:= (SELECT MovementItem.ObjectId
                   FROM MovementItem
                        INNER JOIN Object AS Object_GoodsExternal ON Object_GoodsExternal.Id = MovementItem.ObjectId
                                                                 AND Object_GoodsExternal.DescId = zc_Object_GoodsExternal()
                        LEFT JOIN ObjectLink AS ObjectLink_GoodsExternal_Goods
                                             ON ObjectLink_GoodsExternal_Goods.ObjectId = Object_GoodsExternal.Id
                                            AND ObjectLink_GoodsExternal_Goods.DescId = zc_ObjectLink_GoodsExternal_Goods()
                        LEFT JOIN ObjectLink AS ObjectLink_GoodsExternal_GoodsKind
                                             ON ObjectLink_GoodsExternal_GoodsKind.ObjectId = Object_GoodsExternal.Id
                                            AND ObjectLink_GoodsExternal_GoodsKind.DescId = zc_ObjectLink_GoodsExternal_GoodsKind()
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.isErased = FALSE
                     AND MovementItem.DescId = zc_MI_Master()
                     AND (COALESCE (ObjectLink_GoodsExternal_Goods.ChildObjectId, 0) = 0 OR COALESCE (ObjectLink_GoodsExternal_GoodsKind.ChildObjectId, 0) = 0)
                   LIMIT 1
                  );

     -- проверка
     IF vbObjectId > 0
     THEN
         RAISE EXCEPTION 'Ошибка.Для товара Медка <%> не заполнено значение <Товар> и/или <Вид товара>.',  lfGet_Object_ValueData (vbObjectId);
     END IF;


     -- замена zc_Object_GoodsExternal -> zc_Object_Goods and zc_Object_GoodsKind
     PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, ObjectLink_GoodsExternal_Goods.ChildObjectId, MovementItem.MovementId, MovementItem.Amount, MovementItem.ParentId)
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), MovementItem.Id, ObjectLink_GoodsExternal_GoodsKind.ChildObjectId)
     FROM MovementItem
          INNER JOIN Object AS Object_GoodsExternal ON Object_GoodsExternal.Id = MovementItem.ObjectId
                                                   AND Object_GoodsExternal.DescId = zc_Object_GoodsExternal()
          INNER JOIN ObjectLink AS ObjectLink_GoodsExternal_Goods
                                ON ObjectLink_GoodsExternal_Goods.ObjectId = Object_GoodsExternal.Id
                               AND ObjectLink_GoodsExternal_Goods.DescId = zc_ObjectLink_GoodsExternal_Goods()
                               AND ObjectLink_GoodsExternal_Goods.ChildObjectId > 0
          INNER JOIN ObjectLink AS ObjectLink_GoodsExternal_GoodsKind
                                ON ObjectLink_GoodsExternal_GoodsKind.ObjectId = Object_GoodsExternal.Id
                               AND ObjectLink_GoodsExternal_GoodsKind.DescId = zc_ObjectLink_GoodsExternal_GoodsKind()
                               AND ObjectLink_GoodsExternal_GoodsKind.ChildObjectId > 0
     WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.isErased = FALSE
         AND MovementItem.DescId = zc_MI_Master()
    ;


     -- № п/п НН
     IF NOT EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.ValueData = TRUE AND MB.DescId = zc_MovementBoolean_DisableNPP_auto())
     THEN
         PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_NPP(), tmp.Id, tmp.LineNum)
         FROM (SELECT MovementItem.Id
                    , CASE WHEN vbOperDate < '01.03.2016' AND 1=1
                                THEN ROW_NUMBER() OVER (ORDER BY MovementItem.Id)
                           ELSE ROW_NUMBER() OVER (ORDER BY CASE WHEN vbOperDate_rus < zc_DateEnd_GoodsRus() AND ObjectString_Goods_RUS.ValueData <> ''
                                                                      THEN ObjectString_Goods_RUS.ValueData
                                                                 ELSE /*CASE WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData ELSE Object_Goods.ValueData END*/
                                                                      CASE WHEN ObjectString_Goods_BUH.ValueData <> '' AND vbOperDate >= ObjectDate_BUH.ValueData THEN Object_Goods.ValueData
                                                                           WHEN COALESCE (MIBoolean_Goods_Name_new.ValueData, FALSE) = TRUE THEN Object_Goods.ValueData
                                                                           WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData
                                                                           ELSE Object_Goods.ValueData
                                                                      END
                                                            END
                                                          , Object_GoodsKind.ValueData
                                                          , MovementItem.Id
                                                  )
                      END AS LineNum
               FROM MovementItem
                    LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                    LEFT JOIN ObjectString AS ObjectString_Goods_RUS
                                           ON ObjectString_Goods_RUS.ObjectId = Object_Goods.Id
                                          AND ObjectString_Goods_RUS.DescId = zc_ObjectString_Goods_RUS()
                            LEFT JOIN ObjectString AS ObjectString_Goods_BUH
                                                   ON ObjectString_Goods_BUH.ObjectId = Object_Goods.Id
                                                  AND ObjectString_Goods_BUH.DescId = zc_ObjectString_Goods_BUH()
                            LEFT JOIN ObjectDate AS ObjectDate_BUH
                                                 ON ObjectDate_BUH.ObjectId = Object_Goods.Id
                                                AND ObjectDate_BUH.DescId = zc_ObjectDate_Goods_BUH()
                    LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                    LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

                    LEFT JOIN MovementItemBoolean AS MIBoolean_Goods_Name_new
                                                  ON MIBoolean_Goods_Name_new.MovementItemId = MovementItem.Id
                                                 AND MIBoolean_Goods_Name_new.DescId = zc_MIBoolean_Goods_Name_new()
               WHERE MovementItem.MovementId = inMovementId
                 AND MovementItem.DescId     = zc_MI_Master()
                 AND MovementItem.isErased   = FALSE
                 AND MovementItem.Amount     <> 0
              ) AS tmp
         ;
     END IF;


     -- Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_Tax()
                                , inUserId     := inUserId
                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 25.05.14                                        * add lpComplete_Movement
 10.05.14                                        * set lp
 10.05.14                                        * add lpInsert_MovementProtocol
 11.02.14                                                       *
*/

-- тест
-- SELECT * FROM lpComplete_Movement_Tax (inMovementId:= 10154, inUserId:= zfCalc_UserAdmin() :: Integer)
