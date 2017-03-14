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
             WITH tmpPartner AS (SELECT ObjectLink_Partner_PersonalTrade.ObjectId AS PartnerId
                                 FROM ObjectLink AS ObjectLink_Partner_PersonalTrade
                                 WHERE ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                                   AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                )
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
                                           ) AS SR
                                      WHERE SR.RowNum = 1
                                     )
                , tmpStoreRealItem AS (SELECT tmpStoreRealDoc.PartnerId
                                            , tmpStoreRealDoc.OperDate
                                            , MI_StoreReal.ObjectId                             AS GoodsId
                                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)     AS GoodsKindId
                                            , SUM (COALESCE (MI_StoreReal.Amount, 0.0))::TFloat AS AmountStoreReal
                                       FROM MovementItem AS MI_StoreReal
                                            JOIN tmpStoreRealDoc ON tmpStoreRealDoc.StoreRealId = MI_StoreReal.MovementId
                                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                             ON MILinkObject_GoodsKind.MovementItemId = MI_StoreReal.Id
                                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind() 
                                       WHERE MI_StoreReal.DescId = zc_MI_Master()
                                         AND NOT MI_StoreReal.isErased
                                         AND MI_StoreReal.ObjectId > 0 
                                         AND COALESCE (MI_StoreReal.Amount, 0.0) > 0.0
                                       GROUP BY tmpStoreRealDoc.PartnerId
                                              , tmpStoreRealDoc.OperDate
                                              , MI_StoreReal.ObjectId
                                              , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                      )
                , tmpSaleItem AS (SELECT tmpStoreRealItem.PartnerId
                                       , MI_Sale.ObjectId                                              AS GoodsId
                                       , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)                 AS GoodsKindId
                                       , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0.0))::TFloat AS AmountSale
                                  FROM MovementItem AS MI_Sale
                                       LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                        ON MILinkObject_GoodsKind.MovementItemId = MI_Sale.Id
                                                                       AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind() 
                                       JOIN tmpStoreRealItem ON tmpStoreRealItem.GoodsId = MI_Sale.ObjectId
                                                            AND tmpStoreRealItem.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0) 
                                       JOIN Movement AS Movement_Sale
                                                     ON Movement_Sale.Id = MI_Sale.MovementId
                                                    AND Movement_Sale.DescId = zc_Movement_Sale()
                                                    AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                                       JOIN MovementDate AS MovementDate_OperDatePartner
                                                         ON MovementDate_OperDatePartner.MovementId = Movement_Sale.Id
                                                        AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                        AND MovementDate_OperDatePartner.ValueData >= tmpStoreRealItem.OperDate
                                                        AND MovementDate_OperDatePartner.ValueData < CURRENT_DATE
                                       JOIN MovementLinkObject AS MovementLinkObject_From
                                                               ON MovementLinkObject_From.MovementId = Movement_Sale.Id
                                                              AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                              AND MovementLinkObject_From.ObjectId = vbUnitId                             
                                       JOIN MovementLinkObject AS MovementLinkObject_To
                                                               ON MovementLinkObject_To.MovementId = Movement_Sale.Id
                                                              AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                              AND MovementLinkObject_To.ObjectId = tmpStoreRealItem.PartnerId     
                                       LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                                   ON MIFloat_AmountPartner.MovementItemId = MI_Sale.Id
                                                                  AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()                                                
                                  WHERE MI_Sale.DescId = zc_MI_Master()
                                    AND NOT MI_Sale.isErased
                                  GROUP BY tmpStoreRealItem.PartnerId
                                         , MI_Sale.ObjectId
                                         , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  
                                 )
                , tmpReturnInItem AS (SELECT tmpStoreRealItem.PartnerId
                                           , MI_ReturnIn.ObjectId                                          AS GoodsId
                                           , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)                 AS GoodsKindId
                                           , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0.0))::TFloat AS AmountReturnIn
                                      FROM MovementItem AS MI_ReturnIn
                                           LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                            ON MILinkObject_GoodsKind.MovementItemId = MI_ReturnIn.Id
                                                                           AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind() 
                                           JOIN tmpStoreRealItem ON tmpStoreRealItem.GoodsId = MI_ReturnIn.ObjectId
                                                                AND tmpStoreRealItem.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0) 
                                           JOIN Movement AS Movement_ReturnIn
                                                     ON Movement_ReturnIn.Id = MI_ReturnIn.MovementId
                                                    AND Movement_ReturnIn.DescId = zc_Movement_ReturnIn()
                                                    AND Movement_ReturnIn.StatusId = zc_Enum_Status_Complete()
                                           JOIN MovementDate AS MovementDate_OperDatePartner
                                                             ON MovementDate_OperDatePartner.MovementId = Movement_ReturnIn.Id
                                                            AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                            AND MovementDate_OperDatePartner.ValueData >= tmpStoreRealItem.OperDate
                                                            AND MovementDate_OperDatePartner.ValueData < CURRENT_DATE
                                           JOIN MovementLinkObject AS MovementLinkObject_From
                                                                   ON MovementLinkObject_From.MovementId = Movement_ReturnIn.Id
                                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                  AND MovementLinkObject_From.ObjectId = tmpStoreRealItem.PartnerId                             
                                           JOIN MovementLinkObject AS MovementLinkObject_To
                                                                   ON MovementLinkObject_To.MovementId = Movement_ReturnIn.Id
                                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                  AND MovementLinkObject_To.ObjectId = vbUnitId     
                                           LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                                       ON MIFloat_AmountPartner.MovementItemId = MI_ReturnIn.Id
                                                                      AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()                                                
                                      WHERE MI_ReturnIn.DescId = zc_MI_Master()
                                        AND NOT MI_ReturnIn.isErased
                                      GROUP BY tmpStoreRealItem.PartnerId
                                             , MI_ReturnIn.ObjectId
                                             , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)  
                                 )
             SELECT Object_GoodsListSale.Id
                  , ObjectLink_GoodsListSale_Goods.ChildObjectId                   AS GoodsId
                  , COALESCE (ObjectLink_GoodsListSale_GoodsKind.ChildObjectId, 0) AS GoodsKindId 
                  , ObjectLink_GoodsListSale_Partner.ChildObjectId                 AS PartnerId
                  , (COALESCE (tmpStoreRealItem.AmountStoreReal, 0.0) + COALESCE (tmpSaleItem.AmountSale, 0.0) - COALESCE (tmpReturnInItem.AmountReturnIn, 0.0))::TFloat AS AmountCalc
                  , Object_GoodsListSale.isErased
                  , CAST(true AS Boolean) AS isSync
             FROM Object AS Object_GoodsListSale
                  JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                  ON ObjectLink_GoodsListSale_Partner.ObjectId = Object_GoodsListSale.Id
                                 AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
                                 AND ObjectLink_GoodsListSale_Partner.ChildObjectId > 0
                  JOIN tmpPartner ON tmpPartner.PartnerId = ObjectLink_GoodsListSale_Partner.ChildObjectId
                  JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                                  ON ObjectLink_GoodsListSale_Goods.ObjectId = Object_GoodsListSale.Id
                                 AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                                 AND ObjectLink_GoodsListSale_Goods.ChildObjectId > 0
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_GoodsKind
                                       ON ObjectLink_GoodsListSale_GoodsKind.ObjectId = Object_GoodsListSale.Id
                                      AND ObjectLink_GoodsListSale_GoodsKind.DescId = zc_ObjectLink_GoodsListSale_GoodsKind()
                  LEFT JOIN tmpStoreRealItem ON tmpStoreRealItem.GoodsId = ObjectLink_GoodsListSale_Goods.ChildObjectId
                                            AND tmpStoreRealItem.GoodsKindId = COALESCE (ObjectLink_GoodsListSale_GoodsKind.ChildObjectId, 0)
                                            AND tmpStoreRealItem.PartnerId = ObjectLink_GoodsListSale_Partner.ChildObjectId                     
                  LEFT JOIN tmpSaleItem ON tmpSaleItem.GoodsId = ObjectLink_GoodsListSale_Goods.ChildObjectId
                                       AND tmpSaleItem.GoodsKindId = COALESCE (ObjectLink_GoodsListSale_GoodsKind.ChildObjectId, 0)
                                       AND tmpSaleItem.PartnerId = ObjectLink_GoodsListSale_Partner.ChildObjectId                     
                  LEFT JOIN tmpReturnInItem ON tmpReturnInItem.GoodsId = ObjectLink_GoodsListSale_Goods.ChildObjectId
                                           AND tmpReturnInItem.GoodsKindId = COALESCE (ObjectLink_GoodsListSale_GoodsKind.ChildObjectId, 0)
                                           AND tmpReturnInItem.PartnerId = ObjectLink_GoodsListSale_Partner.ChildObjectId                     
             WHERE Object_GoodsListSale.DescId = zc_Object_GoodsListSale();
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
