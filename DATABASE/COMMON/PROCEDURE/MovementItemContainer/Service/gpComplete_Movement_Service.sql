-- Function: gpComplete_Movement_Service()

DROP FUNCTION IF EXISTS gpCompletePeriod_Movement_Service (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Service (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Service(
    IN inMovementId        Integer              , -- ключ Документа
    IN inSession           TVarChar               -- сессия пользователя
)                              
RETURNS void
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbMovementId_Doc         Integer;
  DECLARE vbInfoMoneyId            Integer;
  DECLARE vbInfoMoneyId_CostPromo  Integer;
  DECLARE vbInfoMoneyId_Market     Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Service());

     -- Поиск
     vbInfoMoneyId:= (SELECT MILinkObject_InfoMoney.ObjectId
                      FROM MovementItem
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                            ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.isErased   = FALSE
                     );


     -- Поиск
     vbMovementId_Doc:= (SELECT MLM.MovementChildId FROM MovementLinkMovement AS MLM WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Doc());

     -- Проверили  - 
     IF vbMovementId_Doc > 0
     THEN
         -- 1. Акция - Компенсация,грн
         IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = vbMovementId_Doc AND Movement.DescId = zc_Movement_Promo())
         THEN
             -- Статья для Стоимость участия
             vbInfoMoneyId_CostPromo:= (SELECT MLO_InfoMoney_CostPromo.ObjectId
                                        FROM Movement
                                             JOIN MovementLinkObject AS MLO_InfoMoney_CostPromo
                                                                     ON MLO_InfoMoney_CostPromo.MovementId = Movement.Id
                                                                    AND MLO_InfoMoney_CostPromo.DescId     = zc_MovementLinkObject_InfoMoney_CostPromo()
                                                                    AND MLO_InfoMoney_CostPromo.ObjectId   > 0
                                        WHERE Movement.ParentId = vbMovementId_Doc
                                          AND Movement.DescId   = zc_Movement_InfoMoney()
                                       );

             -- Статья для Сумма компенсации
             vbInfoMoneyId_Market:= (SELECT MLO_InfoMoney_Market.ObjectId
                                     FROM Movement
                                          JOIN MovementLinkObject AS MLO_InfoMoney_Market
                                                                  ON MLO_InfoMoney_Market.MovementId = Movement.Id
                                                                 AND MLO_InfoMoney_Market.DescId     = zc_MovementLinkObject_InfoMoney_Market()
                                                                 AND MLO_InfoMoney_Market.ObjectId   > 0
                                     WHERE Movement.ParentId = vbMovementId_Doc
                                       AND Movement.DescId   = zc_Movement_InfoMoney()
                                    );

             -- Проверка
             IF   COALESCE (vbInfoMoneyId_CostPromo, 0) = 0
              AND COALESCE (vbInfoMoneyId_Market, 0)    = 0
             THEN
                 RAISE EXCEPTION 'Ошибка.В документе Акция значение <Уп статья> не установлено.';
             END IF;

             -- Проверка
             IF vbInfoMoneyId NOT IN (vbInfoMoneyId_CostPromo, vbInfoMoneyId_Market)
             THEN
                 RAISE EXCEPTION 'Ошибка.Необходимо выбрать значение <Уп статья> как в документе Акция % <%> % % % %.'
                               , CHR (13)
                               , lfGet_Object_ValueData (CASE WHEN vbInfoMoneyId_Market > 0 THEN vbInfoMoneyId_Market ELSE vbInfoMoneyId_CostPromo END)
                               , CHR (13)
                               , CASE WHEN vbInfoMoneyId_CostPromo > 0 THEN 'или' ELSE '' END
                               , CHR (13)
                               , CASE WHEN vbInfoMoneyId_CostPromo > 0 THEN '<' || lfGet_Object_ValueData (vbInfoMoneyId_CostPromo) || '>' ELSE '' END
                                ;
             END IF;

             -- Проверка
             IF COALESCE ((-- Сумма ИТОГО
                           SELECT SUM (tmpSumm.Summ_promo)
                           FROM (-- Сумма компенсации
                                 SELECT SUM (COALESCE (MIFloat_SummInMarket.ValueData, 0) - COALESCE (MIFloat_SummOutMarket.ValueData, 0)) AS Summ_promo
                                 FROM MovementItem
                                      LEFT JOIN MovementItemFloat AS MIFloat_SummOutMarket
                                                                  ON MIFloat_SummOutMarket.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_SummOutMarket.DescId         = zc_MIFloat_SummOutMarket()
                                      LEFT JOIN MovementItemFloat AS MIFloat_SummInMarket
                                                                  ON MIFloat_SummInMarket.MovementItemId = MovementItem.Id
                                                                 AND MIFloat_SummInMarket.DescId         = zc_MIFloat_SummInMarket()
                                 WHERE MovementItem.MovementId = vbMovementId_Doc
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = FALSE
                                   -- если Сумма компенсации
                                   AND vbInfoMoneyId_Market = vbInfoMoneyId

                                UNION
                                 -- Стоимость участия
                                 SELECT -1 * COALESCE (MF.ValueData, 0) AS Summ_promo
                                 FROM MovementFloat AS MF
                                 WHERE MF.MovementId = vbMovementId_Doc AND MF.DescId = zc_MovementFloat_CostPromo()
                                   -- если Стоимость участия
                                   AND vbInfoMoneyId_CostPromo = vbInfoMoneyId
                                ) AS tmpSumm
                          ), 0)
             <> (SELECT SUM (MovementItem.Amount)
                 FROM MovementItem
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.isErased   = FALSE
                )
            AND vbUserId <> 5
             THEN
                 RAISE EXCEPTION 'Ошибка.Не соответствует сумма %в документе Акция <%,грн> = <%> %и в документе Начислений = <%>.'
                               , CHR (13)
                               , CASE WHEN vbInfoMoneyId = vbInfoMoneyId_Market AND vbInfoMoneyId = vbInfoMoneyId_CostPromo
                                           THEN 'Компенсация + Стоимость участия'
                                      WHEN vbInfoMoneyId = vbInfoMoneyId_Market
                                           THEN 'Компенсация'
                                      WHEN vbInfoMoneyId = vbInfoMoneyId_CostPromo
                                           THEN 'Стоимость участия'
                                      ELSE 'Стоимость участия'
                                 END
                               , (SELECT CASE WHEN COALESCE (SUM (tmpSumm.Summ_promo), 0) <= 0
                                                   THEN 'Кредит: ' || zfConvert_FloatToString (-1 * COALESCE (SUM (tmpSumm.Summ_promo), 0))
                                              ELSE 'Дебет: ' || zfConvert_FloatToString (1 * COALESCE (SUM (tmpSumm.Summ_promo), 0))
                                         END
                                  FROM (-- Сумма компенсации
                                        SELECT SUM (COALESCE (MIFloat_SummInMarket.ValueData, 0) - COALESCE (MIFloat_SummOutMarket.ValueData, 0)) AS Summ_promo
                                        FROM MovementItem
                                             LEFT JOIN MovementItemFloat AS MIFloat_SummOutMarket
                                                                         ON MIFloat_SummOutMarket.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_SummOutMarket.DescId         = zc_MIFloat_SummOutMarket()
                                             LEFT JOIN MovementItemFloat AS MIFloat_SummInMarket
                                                                         ON MIFloat_SummInMarket.MovementItemId = MovementItem.Id
                                                                        AND MIFloat_SummInMarket.DescId         = zc_MIFloat_SummInMarket()
                                        WHERE MovementItem.MovementId = vbMovementId_Doc
                                          AND MovementItem.DescId     = zc_MI_Master()
                                          AND MovementItem.isErased   = FALSE
                                          -- если Сумма компенсации
                                          AND vbInfoMoneyId_Market = vbInfoMoneyId

                                       UNION
                                        -- Стоимость участия
                                        SELECT -1 * COALESCE (MF.ValueData, 0) AS Summ_promo
                                        FROM MovementFloat AS MF
                                        WHERE MF.MovementId = vbMovementId_Doc AND MF.DescId = zc_MovementFloat_CostPromo()
                                          -- если Сумма компенсации
                                          AND vbInfoMoneyId_CostPromo = vbInfoMoneyId
                                       ) AS tmpSumm
                                 )
                               , CHR (13)
                               , (SELECT CASE WHEN SUM (MovementItem.Amount) <= 0
                                                   THEN 'Кредит: ' || zfConvert_FloatToString (-1 * SUM (MovementItem.Amount))
                                              ELSE 'Дебет: ' || zfConvert_FloatToString (1 * SUM (MovementItem.Amount))
                                         END
                                  FROM MovementItem
                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                                 )
                                ;
             END IF;
         END IF;

         -- 2. Трейд-маркетинг - Сумма, грн
         IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = vbMovementId_Doc AND Movement.DescId = zc_Movement_PromoTrade())
            AND vbUserId <> 5
         THEN
             IF (SELECT 1 * SUM (COALESCE (MIFloat_Summ.ValueData, 0))
                 FROM MovementItem
                      LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                  ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                 AND MIFloat_Summ.DescId         = zc_MIFloat_Summ()
                 WHERE MovementItem.MovementId = vbMovementId_Doc
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.isErased   = FALSE
                )
             <> (SELECT -1 * SUM (MovementItem.Amount)
                 FROM MovementItem
                 WHERE MovementItem.MovementId = inMovementId
                   AND MovementItem.DescId     = zc_MI_Master()
                   AND MovementItem.isErased   = FALSE
                )
             THEN
                 RAISE EXCEPTION 'Ошибка.Не соответствует сумма %в документе Трейд-маркетинг <Сумма, грн> = <%> %и в документе Начислений = <%>.'
                               , CHR (13)
                               , (SELECT zfConvert_FloatToString (1 * SUM (COALESCE (MIFloat_Summ.ValueData, 0)))
                                  FROM MovementItem
                                       LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                                   ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                                  AND MIFloat_Summ.DescId         = zc_MIFloat_Summ()
                                  WHERE MovementItem.MovementId = vbMovementId_Doc
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                                 )
                               , CHR (13)
                               , (SELECT CASE WHEN SUM (MovementItem.Amount) < 0
                                                   THEN zfConvert_FloatToString (-1 * SUM (MovementItem.Amount))
                                              ELSE 'Дебет: ' || zfConvert_FloatToString (1 * SUM (MovementItem.Amount))
                                         END
                                  FROM MovementItem
                                  WHERE MovementItem.MovementId = inMovementId
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND MovementItem.isErased   = FALSE
                                 )
                                ;
             END IF;
         END IF;

     END IF;


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- проводим Документ
     PERFORM lpComplete_Movement_Service (inMovementId := inMovementId
                                        , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.11.14                                        * add lpComplete_Movement_Finance_CreateTemp
 12.09.14                                        * add PositionId and ServiceDateId and BusinessId_... and BranchId_...
 17.08.14                                        * add MovementDescId
 05.04.14                                        * add !!!ДЛЯ ОПТИМИЗАЦИИ!!! : _tmp1___ and _tmp2___
 25.03.14                                        * таблица - !!!ДЛЯ ОПТИМИЗАЦИИ!!!
 22.01.14                                        * add IsMaster
 28.12.13                                        *
*/

-- тест
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_Service (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
