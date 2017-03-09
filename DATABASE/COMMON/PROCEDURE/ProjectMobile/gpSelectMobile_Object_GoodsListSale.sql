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
   DECLARE vbOperDate TDateTime;
   DECLARE vbStoreRealId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      SELECT PersonalId, UnitId INTO vbPersonalId, vbUnitId FROM gpGetMobile_Object_Const (inSession);

      -- Результат
      IF vbPersonalId IS NOT NULL
      THEN
           SELECT MAX (Movement_StoreReal.OperDate) AS OperDate
             INTO vbOperDate
           FROM Movement AS Movement_StoreReal
                JOIN MovementLinkObject AS MovementLinkObject_Partner
                                        ON MovementLinkObject_Partner.MovementId = Movement_StoreReal.Id
                                       AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                ON ObjectLink_Partner_PersonalTrade.ObjectId = MovementLinkObject_Partner.ObjectId
                               AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                               AND ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
           WHERE Movement_StoreReal.DescId = zc_Movement_StoreReal()
             AND Movement_StoreReal.StatusId = zc_Enum_Status_Complete();

           IF FOUND 
           THEN
                SELECT MAX (Movement_StoreReal.Id) AS StoreRealId
                  INTO vbStoreRealId
                FROM Movement AS Movement_StoreReal
                     JOIN MovementLinkObject AS MovementLinkObject_Partner
                                             ON MovementLinkObject_Partner.MovementId = Movement_StoreReal.Id
                                            AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                     JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                     ON ObjectLink_Partner_PersonalTrade.ObjectId = MovementLinkObject_Partner.ObjectId
                                    AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                    AND ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                WHERE Movement_StoreReal.DescId = zc_Movement_StoreReal()
                  AND Movement_StoreReal.OperDate = vbOperDate
                  AND Movement_StoreReal.StatusId = zc_Enum_Status_Complete();
           END IF;  

           vbStoreRealId:= COALESCE (vbStoreRealId, 0::Integer);
           vbOperDate:= COALESCE (vbOperDate, DATE_TRUNC ('day', CURRENT_TIMESTAMP));

           RETURN QUERY
             SELECT Object_GoodsListSale.Id
                  , COALESCE (ObjectLink_GoodsListSale_Goods.ChildObjectId, 0)     AS GoodsId
                  , COALESCE (ObjectLink_GoodsListSale_GoodsKind.ChildObjectId, 0) AS GoodsKindId 
                  , ObjectLink_GoodsListSale_Partner.ChildObjectId                 AS PartnerId
                  , CAST(0.0 AS TFloat)                                            AS AmountCalc
                  , Object_GoodsListSale.isErased
                  , CAST(true AS Boolean) AS isSync
             FROM Object AS Object_GoodsListSale
                  JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                  ON ObjectLink_GoodsListSale_Partner.ObjectId = Object_GoodsListSale.Id
                                 AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
                                 AND ObjectLink_GoodsListSale_Partner.ChildObjectId > 0
                  JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                  ON ObjectLink_Partner_PersonalTrade.ObjectId = ObjectLink_GoodsListSale_Partner.ChildObjectId
                                 AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                 AND ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                                       ON ObjectLink_GoodsListSale_Goods.ObjectId = Object_GoodsListSale.Id
                                      AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_GoodsKind
                                       ON ObjectLink_GoodsListSale_GoodsKind.ObjectId = Object_GoodsListSale.Id
                                      AND ObjectLink_GoodsListSale_GoodsKind.DescId = zc_ObjectLink_GoodsListSale_GoodsKind()
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
