-- Function: gpInsert_bi_Table_OrderClient

DROP FUNCTION IF EXISTS gpInsert_bi_Table_OrderClient (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_bi_Table_OrderClient(
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
          DELETE FROM _bi_Table_OrderClient WHERE OperDate BETWEEN inStartDate AND inEndDate;
      END IF;


      -- РЕЗУЛЬТАТ
      INSERT INTO _bi_Table_OrderClient (-- Id Документа
                                         MovementId
                                         -- Дата покупателя
                                       , OperDate
                                         -- Дата Склад
                                       , OperDate_sklad
                                         -- Дата Заявки
                                       , OperDate_order
                                         -- № Документа
                                       , InvNumber
                                       , InvNumberPartner

                                         -- Юр. Лицо
                                       , JuridicalId
                                         -- Контрагент
                                       , PartnerId
                                         -- Подразделение
                                       , UnitId

                                       , Comment
                                       , Comment_car

                                         -- УП Статья назначения
                                       , InfoMoneyId
                                         -- Форма оплаты
                                       , PaidKindId
                                         -- Договор
                                       , ContractId

                                         -- % Скидки
                                       , ChangePercent

                                         -- Товар
                                       , GoodsId
                                         -- Вид Товара
                                       , GoodsKindId

                                         -- Документ Акция
                                       , MovementId_promo

                                         -- Вес Заказ ИТОГО
                                       , Amount
                                         -- Шт.
                                       , Amount_sh

                                         -- Вес Заказ
                                       , AmountFirst
                                         -- Шт.
                                       , AmountFirst_sh

                                         -- Вес дозаказ
                                       , AmountSecond
                                         -- Шт.
                                       , AmountSecond_sh

                                         -- Акция - Заказ ИТОГО
                                       , Amount_promo
                                         -- Шт.
                                       , Amount_promo_sh


                                         -- Сумма с НДС Заказ ИТОГО
                                       , Summ
                                         -- Акция - Сумма с НДС ИТОГО
                                       , Summ_promo

                                       , isEdi
                                       , isVchasno

                                        )
              -- Результат
              SELECT -- Id Документа
                     Movement.Id                            AS MovementId
                     -- Дата покупателя
                   , (MovementDate_OperDatePartner.ValueData + (COALESCE (ObjectFloat_DocumentDayCount.ValueData, 0) :: TVarChar || ' DAY') :: INTERVAL) :: TDateTime AS OperDate
                     -- Дата Склад
                   , MovementDate_OperDatePartner.ValueData AS OperDate_sklad
                     -- Дата Заявки
                   , Movement.OperDate AS OperDate_order
                     -- № Документа
                   , zfConvert_StringToNumber (Movement.InvNumber)            AS InvNumber
                   , COALESCE (MovementString_InvNumberPartner.ValueData, '') AS InvNumberPartner

                     -- Юр. Лицо
                   , OL_Partner_Juridical.ChildObjectId          AS JuridicalId
                   --, Object_Juridical.ValueData                AS JuridicalName
                     -- Контрагент
                   , MovementLinkObject_From.ObjectId            AS PartnerId
                   --, COALESCE (Object_From.DescId, 0)            AS DescId_partner
                   --, Object_From.ValueData                       AS PartnerName

                     -- Подразделение
                   , Object_To.Id                                AS UnitId
                   --, Object_To.ValueData                         AS UnitName

                     -- Примечание
                   , MovementString_Comment.ValueData            AS Comment
                   , MovementString_CarComment.ValueData         AS Comment_car

                     -- УП Статья назначения
                   , OL_Contract_InfoMoney.ObjectId              AS InfoMoneyId
                   --, Object_InfoMoney.ValueData                  AS InfoMoneyName
                     -- Форма оплаты
                   , MovementLinkObject_PaidKind.ObjectId        AS PaidKindId
                   --, Object_PaidKind.ValueData                   AS PaidKindName

                     -- Договор
                   , MovementLinkObject_Contract.ObjectId        AS ContractId
                   --, Object_Contract.ValueData                   AS ContractName

                     -- (+)% Скидки (-)% Наценки
                   , -1 * COALESCE (MovementFloat_ChangePercent.ValueData, 0) AS ChangePercent

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

                     -- Документ Акция
                   , MIFloat_PromoMovement.ValueData  :: Integer AS MovementId_promo
                     -- Признак Акция да/нет
                   --, CASE WHEN MIFloat_PromoMovement.ValueData > 0 THEN TRUE ELSE FALSE END :: Boolean AS isPromo

                     -- Вес Заказ ИТОГО
                   ,  ((MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0))
                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                         ) :: TFloat AS Amount
                     -- Шт.
                   ,  (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                    THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                               ELSE 0
                          END) :: TFloat AS Amount_sh

                     -- Вес Заказ
                   ,  (MovementItem.Amount
                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                         ) :: TFloat AS AmountFirst
                     -- Шт.
                   ,  (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                    THEN MovementItem.Amount
                               ELSE 0
                          END) :: TFloat AS AmountFirst_sh

                     -- Вес дозаказ
                   ,  (COALESCE (MIFloat_AmountSecond.ValueData, 0)
                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                         ) :: TFloat AS AmountSecond
                     -- Шт.
                   ,  (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                    THEN COALESCE (MIFloat_AmountSecond.ValueData, 0)
                               ELSE 0
                          END) :: TFloat AS AmountSecond_sh

                     -- Акция - Заказ ИТОГО
                   ,  (CASE WHEN MIFloat_PromoMovement.ValueData > 0 THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END
                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END
                         ) :: TFloat AS Amount_promo
                     -- Шт.
                   ,  (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() AND MIFloat_PromoMovement.ValueData > 0
                                    THEN MovementItem.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0)
                               ELSE 0
                          END) :: TFloat AS Amount_promo_sh

                     -- Сумма с НДС и скидкой - Заказ ИТОГО
                   ,  (COALESCE (MIFloat_Summ.ValueData, 0)) :: TFloat AS Summ
                     --
                   ,  (CASE WHEN MIFloat_PromoMovement.ValueData > 0
                                    THEN COALESCE (MIFloat_Summ.ValueData, 0)
                               ELSE 0
                          END) :: TFloat AS Summ_promo

                   , CASE WHEN COALESCE (TRIM (MovementString_DealId.ValueData), '')    <> '' THEN FALSE 
                          WHEN COALESCE (MovementLinkMovement_Order.MovementChildId, 0) <> 0  THEN TRUE ELSE FALSE END ::Boolean AS isEdi
                   , CASE WHEN COALESCE (TRIM (MovementString_DealId.ValueData), '')    <> '' THEN TRUE ELSE FALSE END ::Boolean AS isVchasno

              FROM Movement
                   -- Покупатель
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                               AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                   LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                   LEFT JOIN ObjectFloat AS ObjectFloat_DocumentDayCount
                                         ON ObjectFloat_DocumentDayCount.ObjectId = MovementLinkObject_From.ObjectId
                                        AND ObjectFloat_DocumentDayCount.DescId   = zc_ObjectFloat_Partner_DocumentDayCount()

                   -- Подразделение
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                               AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                   LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                   -- Документ EDI
                   LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Order
                                                  ON MovementLinkMovement_Order.MovementId = Movement.Id
                                                 AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                   LEFT JOIN MovementString AS MovementString_DealId
                                            ON MovementString_DealId.MovementId = MovementLinkMovement_Order.MovementChildId
                                           AND MovementString_DealId.DescId     = zc_MovementString_DealId()

                   -- Юр. Лицо
                   INNER JOIN ObjectLink AS OL_Partner_Juridical
                                         ON OL_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                        AND OL_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                   LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = OL_Partner_Juridical.ChildObjectId
                   -- Форма оплаты
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                                ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                               AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
                   LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

                   -- Договор
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                ON MovementLinkObject_Contract.MovementId = Movement.Id
                                               AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                   LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
                   -- УП Статья назначения
                   INNER JOIN ObjectLink AS OL_Contract_InfoMoney
                                         ON OL_Contract_InfoMoney.ObjectId = MovementLinkObject_Contract.ObjectId
                                        AND OL_Contract_InfoMoney.DescId   = zc_ObjectLink_Contract_InfoMoney()
                   LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = OL_Contract_InfoMoney.ChildObjectId

                   -- Дата отгрузки контрагенту
                   LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                          ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                         AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                   -- Номер заявки у контрагента
                   LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                            ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                           AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

                  -- Цена с НДС (да/нет)
                  /*LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                            ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                           AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                  -- % НДС
                  LEFT JOIN MovementFloat AS MovementFloat_VATPercent
                                          ON MovementFloat_VATPercent.MovementId =  Movement.Id
                                         AND MovementFloat_VATPercent.DescId = zc_MovementFloat_VATPercent()*/
                  -- (-)% Скидки (+)% Наценки
                  LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                          ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                         AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

                   -- Комментарий
                   LEFT JOIN MovementString AS MovementString_Comment
                                            ON MovementString_Comment.MovementId = Movement.Id
                                           AND MovementString_Comment.DescId     = zc_MovementString_Comment()
                   -- Примечание к отгрузке
                   LEFT JOIN MovementString AS MovementString_CarComment
                                            ON MovementString_CarComment.MovementId = Movement.Id
                                           AND MovementString_CarComment.DescId     = zc_MovementString_CarComment()

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
                   LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                               ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                              AND MIFloat_AmountSecond.DescId         = zc_MIFloat_AmountSecond()
                   -- Сумма с ндс и скидкой
                   LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                               ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                              AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

                   -- Цена
                   /*LEFT JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
                   -- Цена за количество
                   LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                               ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                              AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()*/

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

              WHERE Movement.DescId   = zc_Movement_OrderExternal()
                AND Movement.StatusId = zc_Enum_Status_Complete()
                AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                -- !!! только покупатели
                AND Object_From.DescId <> zc_Object_Unit()
             ;


  -- Протокол
  INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        SELECT inSession :: Integer AS UserId
               -- во сколько началась
             , CURRENT_TIMESTAMP
             , 0 AS Value1
             , 0 AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - CURRENT_TIMESTAMP) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц ДО 
             , NULL AS Time2
               -- сколько всего выполнялась проц 
             , NULL AS Time3
               -- сколько всего выполнялась проц ПОСЛЕ 
             , NULL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpInsert_bi_Table_OrderClient'
               -- ProtocolData
             , zfConvert_DateToString (inStartDate)
   || ' - ' || zfConvert_DateToString (inEndDate)
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
-- DELETE FROM  _bi_Table_OrderClient WHERE OperDate between '20.07.2025 9:00' and '20.07.2025 9:10'
-- SELECT DATE_TRUNC ('MONTH', OperDate), count(*), sum(Amount), isEdi, isVchasno FROM _bi_Table_OrderClient where OperDate between '01.01.2025' and '31.12.2025' GROUP BY DATE_TRUNC ('MONTH', OperDate), isEdi, isVchasno ORDER BY 1, isEdi, isVchasno
-- SELECT * FROM gpInsert_bi_Table_OrderClient (inStartDate:= '01.09.2025', inEndDate:= '28.09.2025', inSession:= zfCalc_UserAdmin())
