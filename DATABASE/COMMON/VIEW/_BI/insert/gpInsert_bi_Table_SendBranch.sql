-- Function: gpInsert_bi_Table_SendBranch

DROP FUNCTION IF EXISTS gpInsert_bi_Table_SendBranch (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_bi_Table_SendBranch(
    IN inStartDate    TDateTime ,
    IN inEndDate      TDateTime ,
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
BEGIN
      -- inStartDate:='01.01.2025';
      --

      IF EXTRACT (HOUR FROM CURRENT_TIMESTAMP) NOT IN (11) OR 1=1
      THEN
          DELETE FROM _bi_Table_SendBranch WHERE OperDate BETWEEN inStartDate AND inEndDate;
      END IF;


      -- РЕЗУЛЬТАТ
      INSERT INTO _bi_Table_SendBranch (-- Id Документа
                                         MovementId
                                         -- Дата Получатель
                                       , OperDate
                                         -- Дата Отправитель
                                       , OperDate_sklad
                                         -- № Документа
                                       , InvNumber

                                         -- Подразделение - Филиал От кого
                                       , UnitId_from
                                         -- Подразделение - Филиал Кому - Днепр
                                       , UnitId_to

                                         -- Товар
                                       , GoodsId
                                         -- Вид Товара
                                       , GoodsKindId

                                         -- Документ Заявка покупателя
                                       , MovementId_order

                                         -- Документ Акция
                                       , MovementId_promo

                                         -- Вес Отправитель
                                       , Amount
                                         -- Шт.
                                       , Amount_sh

                                         -- Вес Получатель
                                       , AmountPartner
                                         -- Шт.
                                       , AmountPartner_sh

                                         -- Акция - Получатель
                                       , AmountPartner_promo
                                         -- Шт.
                                       , AmountPartner_promo_sh

                                         -- Сумма с НДС Получатель
                                       , SummPartner
                                         -- Акция - Сумма с НДС Получатель
                                       , SummPartner_promo
                                        )
              -- Результат
              SELECT -- Id Документа
                     Movement.Id                            AS MovementId
                     -- Дата Получатель
                   , MovementDate_OperDatePartner.ValueData AS OperDate
                     -- Дата Отправитель
                   , Movement.OperDate                      AS OperDate_sklad
                     -- № Документа
                   , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber

                     -- Подразделение - Филиал От кого
                   , Object_From.Id                              AS UnitId_from
                   --, Object_From.ValueData                       AS UnitName_from

                     -- Подразделение - Филиал Кому - Днепр
                   , Object_To.Id                                AS UnitId_to
                   --, Object_To.ValueData                         AS UnitName_to

                     -- Товар
                   , MovementItem.ObjectId                       AS GoodsId
                   --, Object_Goods.ObjectCode                     AS GoodsCode
                   --, Object_Goods.ValueData                      AS GoodsName
                     -- Вид Товара
                   , MILinkObject_GoodsKind.ObjectId             AS GoodsKindId
                   --, Object_GoodsKind.ObjectCode                 AS GoodsKindCode
                   --, Object_GoodsKind.ValueData                  AS GoodsKindName
                     -- Ед.изм. Товара
                   --, Object_Measure.ObjectCode                   AS MeasureCode
                   --, Object_Measure.ValueData                    AS MeasureName

                     -- Документ Заявка покупателя
                   , MLM_Order.MovementChildId                   AS MovementId_order
                     -- Документ Акция
                   , MIFloat_PromoMovement.ValueData  :: Integer AS MovementId_promo
                     -- Признак Акция да/нет
                   --, CASE WHEN MIFloat_PromoMovement.ValueData > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPromo

                     -- Вес Отправитель
                   ,  (MovementItem.Amount * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                      ) :: TFloat AS Amount
                     -- Шт.
                   ,  (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                 THEN MovementItem.Amount
                            ELSE 0
                       END) :: TFloat AS Amount_sh

                     -- Вес Получатель
                   ,  (COALESCE (MIFloat_AmountPartner.ValueData, 0) * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                      ) :: TFloat AS AmountPartner
                     -- Шт.
                   ,  (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                            ELSE 0
                       END) :: TFloat AS AmountPartner_sh

                     -- Акция - Получатель
                   ,  (CASE WHEN MIFloat_PromoMovement.ValueData > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END
                     * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                      ) :: TFloat AS AmountPartner_promo
                     -- Шт.
                   ,  (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND MIFloat_PromoMovement.ValueData > 0
                                 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0)
                            ELSE 0
                      END) :: TFloat AS AmountPartner_promo_sh

                     -- Сумма с НДС Получатель
                   ,  (1.2 * COALESCE (MIFloat_AmountPartner.ValueData, 0) * COALESCE (MIFloat_Price.ValueData, 0)
                     / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                      ) :: TFloat AS Summ

                     -- Акция - Сумма с НДС Получатель
                   ,  (CASE WHEN MIFloat_PromoMovement.ValueData > 0
                                    THEN 1.2 * COALESCE (MIFloat_AmountPartner.ValueData, 0) * COALESCE (MIFloat_Price.ValueData, 0)
                                       / CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END
                               ELSE 0
                          END) :: TFloat AS Summ_promo


              FROM Movement
                   -- Подразделение - Филиал От кого
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                               AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                   LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                   -- Подразделение - Филиал Кому - Днепр
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                               AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                   LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                   -- Дата отгрузки контрагенту
                   LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                          ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                         AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                   -- Комментарий
                   LEFT JOIN MovementString AS MovementString_Comment
                                            ON MovementString_Comment.MovementId = Movement.Id
                                           AND MovementString_Comment.DescId     = zc_MovementString_Comment()
                   -- Документ Заявка покупателя
                   LEFT JOIN MovementLinkMovement AS MLM_Order
                                                  ON MLM_Order.MovementId = Movement.Id
                                                 AND MLM_Order.DescId     = zc_MovementLinkMovement_Order()

                   -- Строки документа
                   LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased   = FALSE
                   -- Товар
                   LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                   -- Вид товаров
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId         = zc_MILinkObject_GoodsKind()
                   LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

                   -- Количество дозаказ
                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                               ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                   -- Цена
                   LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   -- Цена за количество
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                   -- Документ Акция
                   LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                               ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                              AND MIFloat_PromoMovement.DescId         = zc_MIFloat_PromoMovementId()

                   -- Ед.изм. Товара
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                        ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                       AND ObjectLink_Goods_Measure.DescId   = zc_ObjectLink_Goods_Measure()
                   LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                   -- Вес Товара
                   LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                         ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                        AND ObjectFloat_Weight.DescId   = zc_ObjectFloat_Goods_Weight()

              WHERE Movement.DescId   = zc_Movement_SendOnPrice()
                AND Movement.StatusId = zc_Enum_Status_Complete()
                AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                -- !!! только Дільниця обліку і реалізації м`ясної сировини + РК
                AND Object_From.Id IN (zc_Unit_RK()) -- 133049,
             ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.07.25                                        * all
*/

-- тест
-- DELETE FROM  _bi_Table_SendBranch WHERE OperDate between '20.07.2025 9:00' and '20.07.2025 9:10'
-- SELECT DATE_TRUNC ('MONTH', OperDate), sum(Amount), sum(SummPartner), COUNT(*) FROM _bi_Table_SendBranch where  OperDate between '01.01.2025' and '28.09.2025' GROUP BY DATE_TRUNC ('MONTH', OperDate) ORDER BY 1 DESC
-- SELECT * FROM gpInsert_bi_Table_SendBranch (inStartDate:= '01.01.2025', inEndDate:= '28.09.2025', inSession:= zfCalc_UserAdmin())
