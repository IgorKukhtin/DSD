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
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      SELECT PersonalId, UnitId INTO vbPersonalId, vbUnitId FROM gpGetMobile_Object_Const (inSession);

      -- Результат
      IF vbPersonalId IS NOT NULL
      THEN
      
             WITH -- список доступных контрагентов для торгового агента
                  tmpPartner AS (SELECT lfSelect.Id AS PartnerId
                                 FROM lfSelectMobile_Object_Partner (FALSE, inSession) AS lfSelect
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
                                              -- !!!обязательно ДО сегодняшнего дня!!!
                                              AND Movement_StoreReal.OperDate BETWEEN CURRENT_DATE - INTERVAL '28 DAY' AND CURRENT_DATE - INTERVAL '1 DAY'
                                           ) AS SR
                                      WHERE SR.RowNum = 1
                                     )
             SELECT MIN (COALESCE (tmpStoreRealDoc.OperDate, (CURRENT_DATE - INTERVAL '7 DAY')::TDateTime))
                  , CURRENT_DATE - INTERVAL '1 DAY'
                    INTO vbStartDate, vbEndDate
             FROM tmpPartner
                  LEFT JOIN tmpStoreRealDoc ON tmpStoreRealDoc.PartnerId = tmpPartner.PartnerId
            ;
 

           RETURN QUERY
             WITH -- список доступных контрагентов для торгового агента
                  tmpPartner AS (SELECT lfSelect.Id AS PartnerId
                                 FROM lfSelectMobile_Object_Partner (FALSE, inSession) AS lfSelect
                                )
                  -- список - только разрешенные товары
                , tmpGoodsByGoodsKind AS (SELECT gpSelect.GoodsId, gpSelect.GoodsKindId FROM gpSelectMobile_Object_GoodsByGoodsKind (inSyncDateIn, inSession) AS gpSelect)
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
                                              -- !!!обязательно ДО сегодняшнего дня!!!
                                              AND Movement_StoreReal.OperDate BETWEEN CURRENT_DATE - INTERVAL '28 DAY' AND CURRENT_DATE - INTERVAL '1 DAY'
                                           ) AS SR
                                      WHERE SR.RowNum = 1
                                     )
                  -- список периодов для анализа по каждому контрагенту
                , tmpPartnerPeriod AS (SELECT tmpPartner.PartnerId
                                            , COALESCE (tmpStoreRealDoc.OperDate, (CURRENT_DATE - INTERVAL '7 DAY')::TDateTime) AS StartDate -- захаркодили 7 дней для анализа
                                            , (CURRENT_DATE - INTERVAL '1 DAY')::TDateTime                                      AS EndDate
                                       FROM tmpPartner
                                            LEFT JOIN tmpStoreRealDoc ON tmpStoreRealDoc.PartnerId = tmpPartner.PartnerId
                                      )
                  -- развернутые виды товара  
                , tmpGoodsListSaleKind_all AS (SELECT Object_GoodsListSale.Id 
                                                    , ObjectLink_GoodsListSale_Goods.ChildObjectId   AS GoodsId
                                                    , GoodsKindArr :: Integer                        AS GoodsKindId
                                                    , ObjectLink_GoodsListSale_Partner.ChildObjectId AS PartnerId
                                                    , Object_GoodsListSale.isErased
                                                      --  № п/п - !!!ВРЕМЕННО!!!
                                                    , ROW_NUMBER() OVER (PARTITION BY ObjectLink_GoodsListSale_Goods.ChildObjectId, ObjectLink_GoodsListSale_Partner.ChildObjectId) AS Ord
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
                                                    JOIN Object AS Object_Goods 
                                                                ON Object_Goods.Id       = ObjectLink_GoodsListSale_Goods.ChildObjectId
                                                               AND Object_Goods.isErased = FALSE
                                                    JOIN ObjectString AS ObjectString_GoodsListSale_GoodsKind
                                                                      ON ObjectString_GoodsListSale_GoodsKind.ObjectId = Object_GoodsListSale.Id
                                                                     AND ObjectString_GoodsListSale_GoodsKind.DescId = zc_ObjectString_GoodsListSale_GoodsKind() 
                                                    JOIN regexp_split_to_table(ObjectString_GoodsListSale_GoodsKind.ValueData, E'\,+') AS GoodsKindArr ON 1 = 1
                                              )
                  -- остатки по ТТ - список товар + вид товара + контрагент доступный торговому агенту
                , tmpGoodsListSale_add AS (SELECT DISTINCT 
                                                  MovementLinkObject_Partner.ObjectId               AS PartnerId
                                                , MI_StoreReal.ObjectId                             AS GoodsId
                                                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)     AS GoodsKindId
                                           FROM Movement AS Movement_StoreReal
                                                JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                                        ON MovementLinkObject_Partner.MovementId = Movement_StoreReal.Id
                                                                       AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                                JOIN tmpPartner ON tmpPartner.PartnerId = MovementLinkObject_Partner.ObjectId
                                                JOIN MovementItem AS MI_StoreReal
                                                                  ON MI_StoreReal.MovementId = Movement_StoreReal.Id
                                                                 AND MI_StoreReal.DescId     = zc_MI_Master()
                                                                 AND MI_StoreReal.isErased   = FALSE
                                                                 AND MI_StoreReal.Amount     > 0
                                                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                                 ON MILinkObject_GoodsKind.MovementItemId = MI_StoreReal.Id
                                                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind() 
                                           WHERE Movement_StoreReal.DescId   = zc_Movement_StoreReal()
                                             AND Movement_StoreReal.StatusId = zc_Enum_Status_Complete()
                                             AND Movement_StoreReal.OperDate BETWEEN CURRENT_DATE - INTERVAL '14 DAY' AND CURRENT_DATE
                                          )
                  -- развернутые виды товара - добавили tmpGoodsListSale_add
                , tmpGoodsListSaleKind AS (SELECT tmpGoodsListSaleKind_all.Id 
                                                , tmpGoodsListSaleKind_all.GoodsId
                                                , tmpGoodsListSaleKind_all.GoodsKindId
                                                , tmpGoodsListSaleKind_all.PartnerId
                                                , tmpGoodsListSaleKind_all.isErased
                                                  --  № п/п - !!!ВРЕМЕННО!!!
                                                , tmpGoodsListSaleKind_all.Ord
                                           FROM tmpGoodsListSaleKind_all
                                          UNION
                                           SELECT tmpGoodsListSale_add.GoodsId AS Id  -- !!!тоже криво!!!
                                                , tmpGoodsListSale_add.GoodsId
                                                , tmpGoodsListSale_add.GoodsKindId
                                                , tmpGoodsListSale_add.PartnerId
                                                , FALSE AS isErased
                                                  --  № п/п - !!!ВРЕМЕННО!!!
                                                , ROW_NUMBER() OVER (PARTITION BY tmpGoodsListSale_add.GoodsId ORDER BY tmpGoodsListSale_add.PartnerId) AS Ord
                                                -- , ROW_NUMBER() OVER (PARTITION BY tmpGoodsListSale_add.GoodsId, tmpGoodsListSale_add.PartnerId) AS Ord
                                           FROM tmpGoodsListSale_add
                                                LEFT JOIN tmpGoodsListSaleKind_all ON tmpGoodsListSaleKind_all.GoodsId     = tmpGoodsListSale_add.GoodsId
                                                                                  AND tmpGoodsListSaleKind_all.GoodsKindId = tmpGoodsListSale_add.GoodsKindId
                                                                                  AND tmpGoodsListSaleKind_all.PartnerId   = tmpGoodsListSale_add.PartnerId
                                           WHERE tmpGoodsListSaleKind_all.GoodsId IS NULL
                                          )
                  -- шаблон - список товар + вид товара + контрагент доступный торговому агенту
                , tmpGoodsListSale AS (SELECT MAX (tmpGoodsListSaleKind.Id)  AS Id
                                            , MIN (tmpGoodsListSaleKind.Ord) AS Ord
                                            , tmpGoodsListSaleKind.GoodsId
                                            , COALESCE (Object_GoodsKind.Id, zc_GoodsKind_Basis()) AS GoodsKindId
                                            , tmpGoodsListSaleKind.PartnerId
                                            , tmpGoodsListSaleKind.isErased
                                       FROM tmpGoodsListSaleKind
                                            LEFT JOIN Object AS Object_GoodsKind
                                                             ON Object_GoodsKind.Id       = tmpGoodsListSaleKind.GoodsKindId
                                                            AND Object_GoodsKind.isErased = FALSE

                                            -- Ограничим - ТОЛЬКО если ГП
                                            LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                                 ON ObjectLink_Goods_InfoMoney.ObjectId = tmpGoodsListSaleKind.GoodsId
                                                                AND ObjectLink_Goods_InfoMoney.DescId   = zc_ObjectLink_Goods_InfoMoney()
                                            JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId
                                                                      AND Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                                                                                                                         , zc_Enum_InfoMoneyDestination_21000() -- Общефирменные + Чапли
                                                                                                                         , zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция
                                                                                                                          )
                                       WHERE Object_GoodsKind.Id > 0
                                          -- Тушенка
                                          OR Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30102()

                                       GROUP BY tmpGoodsListSaleKind.GoodsId
                                              , COALESCE (Object_GoodsKind.Id, zc_GoodsKind_Basis())
                                              , tmpGoodsListSaleKind.PartnerId
                                              , tmpGoodsListSaleKind.isErased
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
                                                             AND MI_StoreReal.Amount   > 0
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
                                       , SUM (CASE WHEN MovementDate_OperDatePartner.ValueData >= tmpPartnerPeriod.StartDate
                                                    AND MovementDate_OperDatePartner.ValueData <= tmpPartnerPeriod.EndDate
                                                        THEN COALESCE (MIFloat_AmountPartner.ValueData, 0.0)
                                                   ELSE 0
                                              END) :: TFloat AS AmountSale
                                  FROM tmpPartnerPeriod
                                       JOIN MovementDate AS MovementDate_OperDatePartner
                                                         ON MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                        AND MovementDate_OperDatePartner.ValueData BETWEEN vbStartDate AND vbEndDate
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
                                           , SUM (CASE WHEN MovementDate_OperDatePartner.ValueData >= tmpPartnerPeriod.StartDate
                                                        AND MovementDate_OperDatePartner.ValueData <= tmpPartnerPeriod.EndDate
                                                            THEN COALESCE (MIFloat_AmountPartner.ValueData, 0.0)
                                                       ELSE 0
                                                  END) :: TFloat AS AmountReturnIn
                                      FROM tmpPartnerPeriod
                                           JOIN MovementDate AS MovementDate_OperDatePartner
                                                             ON MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                            AND MovementDate_OperDatePartner.ValueData BETWEEN vbStartDate AND vbEndDate
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
             -- SELECT (tmpGoodsListSale.Id + CASE WHEN Ord = 1 THEN 0 ELSE Ord * 100000000 END) :: Integer AS Id
             SELECT (tmpGoodsListSale.Id + CASE WHEN Ord = 1 THEN 0 ELSE Ord * 10000000 END) :: Integer AS Id
                  , tmpGoodsListSale.GoodsId
                  , tmpGoodsListSale.GoodsKindId 
                  , tmpGoodsListSale.PartnerId
                  , (COALESCE (tmpStoreRealItem.AmountStoreReal, 0.0) + COALESCE (tmpSaleItem.AmountSale, 0.0) - COALESCE (tmpReturnInItem.AmountReturnIn, 0.0))::TFloat AS AmountCalc
                  , tmpGoodsListSale.isErased
                  , CAST (TRUE AS Boolean) AS isSync
             FROM tmpGoodsListSale
                  INNER JOIN tmpGoodsByGoodsKind ON tmpGoodsByGoodsKind.GoodsId     = tmpGoodsListSale.GoodsId
                                                AND tmpGoodsByGoodsKind.GoodsKindId = tmpGoodsListSale.GoodsKindId

                  LEFT JOIN tmpStoreRealItem ON tmpStoreRealItem.GoodsId     = tmpGoodsListSale.GoodsId
                                            AND tmpStoreRealItem.GoodsKindId = tmpGoodsListSale.GoodsKindId
                                            AND tmpStoreRealItem.PartnerId   = tmpGoodsListSale.PartnerId                     
                  LEFT JOIN tmpSaleItem ON tmpSaleItem.GoodsId     = tmpGoodsListSale.GoodsId
                                       AND tmpSaleItem.GoodsKindId = tmpGoodsListSale.GoodsKindId
                                       AND tmpSaleItem.PartnerId   = tmpGoodsListSale.PartnerId                     
                  LEFT JOIN tmpReturnInItem ON tmpReturnInItem.GoodsId     = tmpGoodsListSale.GoodsId
                                           AND tmpReturnInItem.GoodsKindId = tmpGoodsListSale.GoodsKindId
                                           AND tmpReturnInItem.PartnerId   = tmpGoodsListSale.PartnerId
           --LIMIT CASE WHEN vbUserId = 1072129 THEN 0 ELSE 500000 END
             LIMIT CASE WHEN vbUserId = zfCalc_UserMobile_limit0() THEN 0 ELSE 500000 END
            ;

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
-- SELECT * FROM gpSelectMobile_Object_GoodsListSale (inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
-- SELECT * FROM gpSelectMobile_Object_GoodsListSale (inSyncDateIn := CURRENT_DATE, inSession := '2149406')
