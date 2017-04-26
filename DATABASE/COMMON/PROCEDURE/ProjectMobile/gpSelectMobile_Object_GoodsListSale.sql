-- Function: gpSelectMobile_Object_GoodsListSale (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_GoodsListSale (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_GoodsListSale (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id            Integer
             , GoodsId       Integer  -- Товар
             , GoodsKindId   Integer  -- Вид товара
             , PartnerId     Integer  -- Контрагент
             , AmountCalc    TFloat   -- Предварительное значение, потом используется для расчета на мобильном  устройстве "рекомендованного заказа", формируется в Главной БД = предыдущий остаток факт на ТТ + Реализация на ТТ - Возвраты с ТТ, причем все это за "определенный" период
             , isErased      Boolean  -- Удаленный ли элемент
             , isSync        Boolean  -- Синхронизируется (да/нет)
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
   DECLARE vbUnitId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      SELECT PersonalId, UnitId INTO vbPersonalId, vbUnitId FROM gpGetMobile_Object_Const (inSession);

      -- Результат
      IF vbPersonalId IS NOT NULL
      THEN
           RETURN QUERY
             WITH -- список доступных контрагентов для торгового агента
                  tmpPartner AS (SELECT ObjectLink_Partner_PersonalTrade.ObjectId AS PartnerId
                                 FROM ObjectLink AS ObjectLink_Partner_PersonalTrade
                                 WHERE ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                                   AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                )
                  -- список последних актуальных документов "Фактический остаток по ТТ"
                , tmpStoreRealDoc AS (SELECT SR.PartnerId, SR.StoreRealId, SR.OperDate
                                      FROM (SELECT MovementLinkObject_Partner.ObjectId AS PartnerId
                                                 , Movement_StoreReal.Id AS StoreRealId
                                                 , Movement_StoreReal.OperDate
                                                 , ROW_NUMBER () OVER (PARTITION BY MovementLinkObject_Partner.ObjectId ORDER BY Movement_StoreReal.OperDate DESC) AS RowNum
                                            FROM Movement AS Movement_StoreReal
                                                 JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                                         ON MovementLinkObject_Partner.MovementId = Movement_StoreReal.Id
                                                                        AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                                 JOIN tmpPartner ON tmpPartner.PartnerId = MovementLinkObject_Partner.ObjectId
                                            WHERE Movement_StoreReal.DescId = zc_Movement_StoreReal()
                                              AND Movement_StoreReal.StatusId = zc_Enum_Status_Complete()
                                              AND Movement_StoreReal.OperDate < CURRENT_DATE
                                           ) AS SR
                                      WHERE SR.RowNum = 1
                                     )
                  -- список периодов для анализа по каждому контрагенту
                , tmpPartnerPeriod AS (SELECT tmpPartner.PartnerId
                                            , COALESCE (tmpStoreRealDoc.OperDate, (CURRENT_DATE - 7)::TDateTime) AS StartDate -- захаркодили 7 дней для анализа
                                            , (CURRENT_DATE - 1)::TDateTime                                      AS EndDate
                                       FROM tmpPartner
                                            LEFT JOIN tmpStoreRealDoc ON tmpStoreRealDoc.PartnerId = tmpPartner.PartnerId
                                      )
                  -- предопределенный список товар+вид товара+контрагент доступный торговому агенту
                , tmpGoodsListSale AS (SELECT MAX (Object_GoodsListSale.Id)                                  AS Id
                                            , ObjectLink_GoodsListSale_Goods.ChildObjectId                   AS GoodsId
                                            , COALESCE (ObjectLink_GoodsListSale_GoodsKind.ChildObjectId, 0) AS GoodsKindId 
                                            , ObjectLink_GoodsListSale_Partner.ChildObjectId                 AS PartnerId
                                            , Object_GoodsListSale.isErased
                                       FROM tmpPartner
                                            JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                                            ON ObjectLink_GoodsListSale_Partner.ChildObjectId = tmpPartner.PartnerId
                                                           AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
                                            JOIN Object AS Object_GoodsListSale 
                                                        ON Object_GoodsListSale.Id       = ObjectLink_GoodsListSale_Partner.ObjectId
                                                       AND Object_GoodsListSale.isErased = FALSE
                                            JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                                                            ON ObjectLink_GoodsListSale_Goods.ObjectId = Object_GoodsListSale.Id
                                                           AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                                                           AND ObjectLink_GoodsListSale_Goods.ChildObjectId > 0
                                            LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_GoodsKind
                                                                 ON ObjectLink_GoodsListSale_GoodsKind.ObjectId = Object_GoodsListSale.Id
                                                                AND ObjectLink_GoodsListSale_GoodsKind.DescId = zc_ObjectLink_GoodsListSale_GoodsKind()
                                       GROUP BY ObjectLink_GoodsListSale_Goods.ChildObjectId
                                              , COALESCE (ObjectLink_GoodsListSale_GoodsKind.ChildObjectId, 0)
                                              , ObjectLink_GoodsListSale_Partner.ChildObjectId
                                              , Object_GoodsListSale.isErased
                                      )
                  -- строки фактического остатка
                , tmpStoreRealItem AS (SELECT tmpStoreRealDoc.PartnerId
                                            , MI_StoreReal.ObjectId                             AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)     AS GoodsKindId
                                            , SUM (COALESCE (MI_StoreReal.Amount, 0.0))::TFloat AS AmountStoreReal
                                       FROM tmpStoreRealDoc 
                                            JOIN MovementItem AS MI_StoreReal
                                                              ON MI_StoreReal.MovementId = tmpStoreRealDoc.StoreRealId
                                                             AND MI_StoreReal.DescId = zc_MI_Master()
                                                             AND MI_StoreReal.isErased = FALSE
                                                             AND MI_StoreReal.ObjectId > 0 
                                                             AND COALESCE (MI_StoreReal.Amount, 0.0) > 0.0
                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MI_StoreReal.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind() 
                                       GROUP BY tmpStoreRealDoc.PartnerId
                                              , MI_StoreReal.ObjectId
                                              , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                      )
                  -- продажи по партнерам
                , tmpSaleItem AS (SELECT tmpPartnerPeriod.PartnerId
                                       , MI_Sale.ObjectId                                              AS GoodsId
                                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)                 AS GoodsKindId
                                       , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0.0))::TFloat AS AmountSale
                                  FROM tmpPartnerPeriod
                                       JOIN MovementDate AS MovementDate_OperDatePartner
                                                         ON MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                        AND MovementDate_OperDatePartner.ValueData >= tmpPartnerPeriod.StartDate
                                                        AND MovementDate_OperDatePartner.ValueData <= tmpPartnerPeriod.EndDate
                                       JOIN Movement AS Movement_Sale 
                                                     ON Movement_Sale.Id = MovementDate_OperDatePartner.MovementId
                                                    AND Movement_Sale.DescId = zc_Movement_Sale()
                                                    AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                                       JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                              AND MovementLinkObject_To.ObjectId = tmpPartnerPeriod.PartnerId     
                                       JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement_Sale.Id
                                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                              AND MovementLinkObject_From.ObjectId = vbUnitId                             
                                       JOIN MovementItem AS MI_Sale
                                                         ON MI_Sale.MovementId = Movement_Sale.Id
                                                        AND MI_Sale.DescId = zc_MI_Master()
                                                        AND MI_Sale.isErased = FALSE
                                       LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                        ON MILinkObject_GoodsKind.MovementItemId = MI_Sale.Id
                                                                       AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind() 
                                       LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                                   ON MIFloat_AmountPartner.MovementItemId = MI_Sale.Id
                                                                  AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                                       JOIN tmpGoodsListSale ON tmpGoodsListSale.GoodsId = MI_Sale.ObjectId
                                                            AND tmpGoodsListSale.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                                            AND tmpGoodsListSale.PartnerId = tmpPartnerPeriod.PartnerId
                                  GROUP BY tmpPartnerPeriod.PartnerId
                                         , MI_Sale.ObjectId
                                         , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  
                                 )
                  -- возвраты по партнерам
                , tmpReturnInItem AS (SELECT tmpPartnerPeriod.PartnerId
                                           , MI_ReturnIn.ObjectId                                          AS GoodsId
                                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)                 AS GoodsKindId
                                           , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0.0))::TFloat AS AmountReturnIn
                                      FROM tmpPartnerPeriod
                                           JOIN MovementDate AS MovementDate_OperDatePartner
                                                             ON MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                            AND MovementDate_OperDatePartner.ValueData >= tmpPartnerPeriod.StartDate
                                                            AND MovementDate_OperDatePartner.ValueData <= tmpPartnerPeriod.EndDate
                                           JOIN Movement AS Movement_ReturnIn
                                                         ON Movement_ReturnIn.Id = MovementDate_OperDatePartner.MovementId
                                                        AND Movement_ReturnIn.DescId = zc_Movement_ReturnIn()
                                                        AND Movement_ReturnIn.StatusId = zc_Enum_Status_Complete()
                                           JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement_ReturnIn.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                  AND MovementLinkObject_From.ObjectId = tmpPartnerPeriod.PartnerId
                                           JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement_ReturnIn.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_To.ObjectId = vbUnitId     
                                           JOIN MovementItem AS MI_ReturnIn
                                                             ON MI_ReturnIn.MovementId = Movement_ReturnIn.Id
                                                            AND MI_ReturnIn.DescId = zc_MI_Master()
                                                            AND MI_ReturnIn.isErased = FALSE
                                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                            ON MILinkObject_GoodsKind.MovementItemId = MI_ReturnIn.Id
                                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind() 
                                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                                       ON MIFloat_AmountPartner.MovementItemId = MI_ReturnIn.Id
                                                                      AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()                                                
                                           JOIN tmpGoodsListSale ON tmpGoodsListSale.GoodsId = MI_ReturnIn.ObjectId
                                                                AND tmpGoodsListSale.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                                                AND tmpGoodsListSale.PartnerId = tmpPartnerPeriod.PartnerId
                                      GROUP BY tmpPartnerPeriod.PartnerId
                                             , MI_ReturnIn.ObjectId
                                             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  
                                 )
             SELECT tmpGoodsListSale.Id
                  , tmpGoodsListSale.GoodsId
                  , tmpGoodsListSale.GoodsKindId 
                  , tmpGoodsListSale.PartnerId
                  , (COALESCE (tmpStoreRealItem.AmountStoreReal, 0.0) + COALESCE (tmpSaleItem.AmountSale, 0.0) - COALESCE (tmpReturnInItem.AmountReturnIn, 0.0))::TFloat AS AmountCalc
                  , tmpGoodsListSale.isErased
                  , CAST(true AS Boolean) AS isSync
             FROM tmpGoodsListSale
                  LEFT JOIN tmpStoreRealItem ON tmpStoreRealItem.GoodsId = tmpGoodsListSale.GoodsId
                                            AND tmpStoreRealItem.GoodsKindId = tmpGoodsListSale.GoodsKindId
                                            AND tmpStoreRealItem.PartnerId = tmpGoodsListSale.PartnerId                     
                  LEFT JOIN tmpSaleItem ON tmpSaleItem.GoodsId = tmpGoodsListSale.GoodsId
                                       AND tmpSaleItem.GoodsKindId = tmpGoodsListSale.GoodsKindId
                                       AND tmpSaleItem.PartnerId = tmpGoodsListSale.PartnerId                     
                  LEFT JOIN tmpReturnInItem ON tmpReturnInItem.GoodsId = tmpGoodsListSale.GoodsId
                                           AND tmpReturnInItem.GoodsKindId = tmpGoodsListSale.GoodsKindId
                                           AND tmpReturnInItem.PartnerId = tmpGoodsListSale.PartnerId;
      END IF;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 04.03.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelectMobile_Object_GoodsListSale(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
