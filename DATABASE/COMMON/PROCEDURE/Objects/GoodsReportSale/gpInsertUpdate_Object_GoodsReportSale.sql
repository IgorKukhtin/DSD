-- Function: gpInsertUpdate_Object_GoodsReportSale()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsReportSale (TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsReportSale(
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsPack  Boolean;
   DECLARE vbIsBasis Boolean;
   DECLARE vbOperDate  TDateTime;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
   DECLARE vbWeek      TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsReportSale());
     

     


     -- Проверка
     IF (vbStartDate + (((vbWeek * 7 - 1) :: Integer) :: TVarChar || ' DAY') :: INTERVAL) <> vbEndDate
     THEN
         RAISE EXCEPTION 'Период с <%> по <%> должен быть кратен <%> недель. <%> ', zfConvert_DateToString (vbStartDate), zfConvert_DateToString (vbEndDate), vbWeek :: Integer
                        , zfConvert_DateToString ((vbStartDate + (((vbWeek * 7 - 1) :: Integer) :: TVarChar || ' DAY') :: INTERVAL));
         -- 'Повторите действие через 3 мин.'
     END IF;

     -- сохраняем zc_Object_GoodsReportSaleInf
     PERFORM lpInsertUpdate_Object_GoodsReportSaleInf (inId := COALESCE ((SELECT Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsReportSaleInf()) , 0) ::Integer
                                                     , inStartDate := vbStartDate
                                                     , inEndDate   := vbEndDate
                                                     , inWeek      := vbWeek
                                                     , inUserId    := vbUserId
                                                       );
     --
-- таблица -
     CREATE TEMP TABLE tmpAll (NumberDay Integer, UnitId Integer, GoodsId Integer, GoodsKindId Integer, AmountOrder TFloat, AmountOrderPromo TFloat, AmountOrderBranch TFloat, AmountSale TFloat, AmountSalePromo TFloat, AmountBranch TFloat) ON COMMIT DROP;
    
     -- 
      WITH tmpGoods AS (SELECT ObjectLink_Goods_InfoMoney.ObjectId AS GoodsId
                             , CASE WHEN Object_InfoMoney_View.InfoMoneyId IN (zc_Enum_InfoMoney_20901() -- Ирна
                                                                             , zc_Enum_InfoMoney_30101() -- Готовая продукция
                                                                             , zc_Enum_InfoMoney_30201() -- Мясное сырье
                                                                              )
                                         THEN TRUE
                                    ELSE FALSE
                               END AS isGoodsKind
                        FROM Object_InfoMoney_View
                             LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                  ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                        WHERE (Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30100() -- Доходы + Продукция + Готовая продукция and Тушенка and Хлеб
                             OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30200() -- Доходы + Мясное сырье : запечена...
                             OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                               )
                             
                        OR (Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30101() -- Доходы + Продукция + Готовая продукция
                             OR Object_InfoMoney_View.InfoMoneyId = zc_Enum_InfoMoney_30201() -- Доходы + Продукция + Готовая продукция
                             OR Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20900() -- Общефирменные + Ирна
                               )
 
                        OR (Object_InfoMoney_View.InfoMoneyGroupId = zc_Enum_InfoMoneyGroup_10000() -- Основное сырье
                               )
                       )
         , tmpOrder AS (SELECT Movement.OperDate
                             , Movement.UnitId
                             , MovementItem.ObjectId AS GoodsId
                             , MovementItem.Amount   AS Amount
                             , MovementItem.Id       AS MovementItemId
                             , Movement.isUnit
                        FROM ( SELECT Movement.Id
                                    --, Movement.OperDate
                                    , MD_OperDatePartner.ValueData AS OperDate
                                    , MovementLinkObject_To.ObjectId AS UnitId
                                    , CASE WHEN Object_From.DescId = zc_Object_Unit() THEN TRUE ELSE FALSE END AS isUnit 
                               FROM MovementDate AS MD_OperDatePartner
                                    INNER JOIN Movement ON Movement.Id       = MD_OperDatePartner.MovementId
                                                       AND Movement.DescId   = zc_Movement_OrderExternal()
                                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                               -- FROM Movement
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                  ON MovementLinkObject_From.MovementId = Movement.Id
                                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                    LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId 
                                   
                               -- WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                               --   AND Movement.DescId = zc_Movement_OrderExternal()
                               --   AND Movement.StatusId = zc_Enum_Status_Complete()
                               WHERE MD_OperDatePartner.ValueData BETWEEN vbStartDate AND vbEndDate
                                 AND MD_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                              ) AS Movement
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                     )
                          
         , tmpSale AS (SELECT Movement.OperDate
                             , Movement.UnitId
                             , MovementItem.ObjectId AS GoodsId
                             , MovementItem.Amount
                             , MovementItem.Id       AS MovementItemId
                        FROM ( SELECT Movement.Id
                                    , Movement.OperDate
                                    , MovementLinkObject_From.ObjectId AS UnitId
                               FROM Movement
                                    INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                  ON MovementLinkObject_From.MovementId = Movement.Id 
                                                                 AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                   
                               WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                                 AND Movement.DescId = zc_Movement_Sale()
                                 AND Movement.StatusId = zc_Enum_Status_Complete()
                              ) AS Movement
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                    AND MovementItem.isErased   = FALSE
                      ) 
                      
         , tmpSendOnPrice AS (SELECT Movement.OperDate
                                   , Movement.UnitId
                                   , MovementItem.ObjectId AS GoodsId
                                   , MovementItem.Amount
                                   , MovementItem.Id       AS MovementItemId
                              FROM ( SELECT Movement.Id
                                          , Movement.OperDate
                                          , MovementLinkObject_From.ObjectId AS UnitId
                                     FROM Movement
                                          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                        ON MovementLinkObject_From.MovementId = Movement.Id 
                                                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                         
                                     WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
                                       AND Movement.DescId = zc_Movement_SendOnPrice()
                                       AND Movement.StatusId = zc_Enum_Status_Complete()
                                    ) AS Movement
                                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                          AND MovementItem.DescId     = zc_MI_Master()
                                                          AND MovementItem.isErased   = FALSE
                            ) 
         , tmpMI AS (SELECT tmpSale.MovementItemId
                     FROM tmpSale
                    UNION
                     SELECT tmpOrder.MovementItemId
                     FROM tmpOrder
                    UNION
                     SELECT tmpSendOnPrice.MovementItemId
                     FROM tmpSendOnPrice
                    )
         , tmpMIFloat AS (SELECT MovementItemFloat.*
                          FROM MovementItemFloat 
                          WHERE MovementItemFloat.MovementItemId IN (SELECT tmpMI.MovementItemId FROM tmpMI)
                          )                      
                          
         , tmpMILinkObject_GoodsKind AS (SELECT MovementItemLinkObject.*
                                         FROM MovementItemLinkObject
                                         WHERE MovementItemLinkObject.MovementItemId IN (SELECT tmpMI.MovementItemId FROM tmpMI)
                                           AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                         )
                                      
         , tmpMIAll AS
           (-- 1.1 Заявки
            SELECT Movement.OperDate                                AS OperDate
                 , Movement.UnitId                                  AS UnitId
                 , Movement.GoodsId                                 AS GoodsId
                 , CASE WHEN tmpGoods.isGoodsKind = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) END AS GoodsKindId

                 , SUM (CASE WHEN Movement.isUnit = FALSE AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN Movement.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountOrder
                 , SUM (CASE WHEN Movement.isUnit = FALSE AND COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN Movement.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountOrderPromo
                 , SUM (CASE WHEN Movement.isUnit = TRUE THEN Movement.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END)                                                          AS AmountOrderBranch                       
                 , 0                                                                        AS AmountSale
                 , 0                                                                        AS AmountSalePromo
                 , 0                                                                        AS AmountBranch
            FROM tmpOrder AS Movement 
                 INNER JOIN tmpGoods ON tmpGoods.GoodsId = Movement.GoodsId
                 LEFT JOIN tmpMILinkObject_GoodsKind AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = Movement.MovementItemId
                                                    AND tmpGoods.isGoodsKind = TRUE
                 LEFT JOIN tmpMIFloat AS MIFloat_AmountSecond
                                             ON MIFloat_AmountSecond.MovementItemId = Movement.MovementItemId
                                            AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
                                            
                 LEFT JOIN tmpMIFloat AS MIFloat_PromoMovementId
                                             ON MIFloat_PromoMovementId.MovementItemId = Movement.MovementItemId
                                            AND MIFloat_PromoMovementId.DescId         = zc_MIFloat_PromoMovementId()
            GROUP BY Movement.OperDate
                   , Movement.UnitId
                   , Movement.GoodsId 
                   , MILinkObject_GoodsKind.ObjectId
                   , tmpGoods.isGoodsKind
            HAVING SUM (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN Movement.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) <> 0
                OR SUM (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN Movement.Amount + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) <> 0

           UNION ALL
            -- 1.2 Продажи
            SELECT Movement.OperDate                                AS OperDate
                 , Movement.UnitId                                  AS UnitId
                 , Movement.GoodsId                                 AS GoodsId
                 , CASE WHEN tmpGoods.isGoodsKind = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) END AS GoodsKindId
                 , 0                                                   AS AmountOrder
                 , 0                                                   AS AmountOrderPromo
                 , 0                                                   AS AmountOrderBranch
                 , SUM (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS AmountSale
                 , SUM (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) AS AmountSalePromo
                 , 0                                                   AS AmountBranch
            FROM tmpSale AS Movement
                 INNER JOIN tmpGoods ON tmpGoods.GoodsId = Movement.GoodsId
 
                 LEFT JOIN tmpMILinkObject_GoodsKind AS MILinkObject_GoodsKind
                                                     ON MILinkObject_GoodsKind.MovementItemId = Movement.MovementItemId
                                                    AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                    AND tmpGoods.isGoodsKind = TRUE
                 LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                             ON MIFloat_AmountPartner.MovementItemId = Movement.MovementItemId
                                            AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                 
                 LEFT JOIN MovementItemFloat AS MIFloat_PromoMovementId
                                             ON MIFloat_PromoMovementId.MovementItemId = Movement.MovementItemId
                                            AND MIFloat_PromoMovementId.DescId         = zc_MIFloat_PromoMovementId()
                                                                       
            GROUP BY Movement.OperDate
                   , Movement.UnitId
                   , Movement.GoodsId 
                   , MILinkObject_GoodsKind.ObjectId
                   , tmpGoods.isGoodsKind
            HAVING SUM (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) = 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) <> 0  
                OR SUM (CASE WHEN COALESCE (MIFloat_PromoMovementId.ValueData, 0) > 0 THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END) <> 0  

           UNION ALL
            -- 1.3 Перемещение на филиал
            SELECT Movement.OperDate                                AS OperDate
                 , Movement.UnitId                                  AS UnitId
                 , Movement.GoodsId                                 AS GoodsId
                 , CASE WHEN tmpGoods.isGoodsKind = TRUE THEN COALESCE (MILinkObject_GoodsKind.ObjectId, zc_GoodsKind_Basis()) END AS GoodsKindId
                 , 0                                                AS AmountOrder
                 , 0                                                AS AmountOrderPromo
                 , 0                                                AS AmountOrderBranch
                 , 0                                                AS AmountSale
                 , 0                                                AS AmountSalePromo
                 , SUM (COALESCE (Movement.Amount, 0))              AS AmountBranch
            FROM tmpSendOnPrice AS Movement
                 INNER JOIN tmpGoods ON tmpGoods.GoodsId = Movement.GoodsId
 
                 LEFT JOIN tmpMILinkObject_GoodsKind AS MILinkObject_GoodsKind
                                                  ON MILinkObject_GoodsKind.MovementItemId = Movement.MovementItemId
                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                                 AND tmpGoods.isGoodsKind = TRUE
            GROUP BY Movement.OperDate
                   , Movement.UnitId
                   , Movement.GoodsId 
                   , MILinkObject_GoodsKind.ObjectId
                   , tmpGoods.isGoodsKind
            HAVING SUM (COALESCE (Movement.Amount, 0)) <> 0   
           )

    INSERT INTO tmpAll (NumberDay, UnitId, GoodsId, GoodsKindId, AmountOrder, AmountOrderPromo, AmountOrderBranch, AmountSale, AmountSalePromo, AmountBranch)
            SELECT tmpDayOfWeek.Number
                 , tmpMIAll.UnitId
                 , tmpMIAll.GoodsId
                 , tmpMIAll.GoodsKindId
                 , SUM (tmpMIAll.AmountOrder       ) AS AmountOrder
                 , SUM (tmpMIAll.AmountOrderPromo  ) AS AmountOrderPromo
                 , SUM (tmpMIAll.AmountOrderBranch ) AS AmountOrderBranch
                 , SUM (tmpMIAll.AmountSale        ) AS AmountSale
                 , SUM (tmpMIAll.AmountSalePromo   ) AS AmountSalePromo
                 , SUM (tmpMIAll.AmountBranch      ) AS AmountBranch
            FROM tmpMIAll
                 LEFT JOIN zfCalc_DayOfWeekName(tmpMIAll.OperDate) AS tmpDayOfWeek ON 1=1
            GROUP BY tmpDayOfWeek.Number
                   , tmpMIAll.UnitId
                   , tmpMIAll.GoodsId
                   , tmpMIAll.GoodsKindId
   ;

   -- удалить все из zc_Object_GoodsReportSale, сначала сссылки, потом объекты
   -- 
   DELETE FROM ObjectFloat WHERE ObjectId IN ( select Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsReportSale());
   DELETE FROM ObjectLink  WHERE ObjectId IN ( select Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsReportSale());
   DELETE FROM ObjectLink  WHERE ChildObjectId IN ( select Object.Id FROM Object WHERE Object.DescId = zc_Object_GoodsReportSale());
   DELETE FROM Object      WHERE Object.DescId = zc_Object_GoodsReportSale();

   
   -- сохранить новые данные

       -- сохранили
       PERFORM lpInsertUpdate_Object_GoodsReportSale(inId           := 0               ::Integer       -- ключ объекта <> 
                                                   , inUnitId       := tmpAll.UnitId 
                                                   , inGoodsId      := tmpAll.GoodsId    
                                                   , inGoodsKindId  := tmpAll.GoodsKindId
                                                   
                                                   , inAmount1      :=  tmpAll.Amount1   :: TFloat
                                                   , inAmount2      :=  tmpAll.Amount2   :: TFloat
                                                   , inAmount3      :=  tmpAll.Amount3   :: TFloat
                                                   , inAmount4      :=  tmpAll.Amount4   :: TFloat
                                                   , inAmount5      :=  tmpAll.Amount5   :: TFloat
                                                   , inAmount6      :=  tmpAll.Amount6   :: TFloat
                                                   , inAmount7      :=  tmpAll.Amount7   :: TFloat
                                                                                                         
                                                   , inPromo1       :=  tmpAll.Promo1    :: TFloat
                                                   , inPromo2       :=  tmpAll.Promo2    :: TFloat    
                                                   , inPromo3       :=  tmpAll.Promo3    :: TFloat    
                                                   , inPromo4       :=  tmpAll.Promo4    :: TFloat    
                                                   , inPromo5       :=  tmpAll.Promo5    :: TFloat    
                                                   , inPromo6       :=  tmpAll.Promo6    :: TFloat    
                                                   , inPromo7       :=  tmpAll.Promo7    :: TFloat    
                                                                                             
                                                   , inBranch1      :=  tmpAll.AmountBranch1 :: TFloat
                                                   , inBranch2      :=  tmpAll.AmountBranch2 :: TFloat
                                                   , inBranch3      :=  tmpAll.AmountBranch3 :: TFloat
                                                   , inBranch4      :=  tmpAll.AmountBranch4 :: TFloat
                                                   , inBranch5      :=  tmpAll.AmountBranch5 :: TFloat
                                                   , inBranch6      :=  tmpAll.AmountBranch6 :: TFloat
                                                   , inBranch7      :=  tmpAll.AmountBranch7 :: TFloat
                                                                                             
                                                   , inOrder1       :=  tmpAll.Order1        :: TFloat
                                                   , inOrder2       :=  tmpAll.Order2        :: TFloat
                                                   , inOrder3       :=  tmpAll.Order3        :: TFloat
                                                   , inOrder4       :=  tmpAll.Order4        :: TFloat
                                                   , inOrder5       :=  tmpAll.Order5        :: TFloat
                                                   , inOrder6       :=  tmpAll.Order6        :: TFloat
                                                   , inOrder7       :=  tmpAll.Order7        :: TFloat
                                                                                             
                                                   , inOrderPromo1  :=  tmpAll.OrderPromo1   :: TFloat
                                                   , inOrderPromo2  :=  tmpAll.OrderPromo2   :: TFloat
                                                   , inOrderPromo3  :=  tmpAll.OrderPromo3   :: TFloat
                                                   , inOrderPromo4  :=  tmpAll.OrderPromo4   :: TFloat
                                                   , inOrderPromo5  :=  tmpAll.OrderPromo5   :: TFloat
                                                   , inOrderPromo6  :=  tmpAll.OrderPromo6   :: TFloat
                                                   , inOrderPromo7  :=  tmpAll.OrderPromo7   :: TFloat
                                                     
                                                   , inOrderBranch1 := tmpAll.OrderBranch1 :: TFloat
                                                   , inOrderBranch2 := tmpAll.OrderBranch2 :: TFloat
                                                   , inOrderBranch3 := tmpAll.OrderBranch3 :: TFloat
                                                   , inOrderBranch4 := tmpAll.OrderBranch4 :: TFloat
                                                   , inOrderBranch5 := tmpAll.OrderBranch5 :: TFloat
                                                   , inOrderBranch6 := tmpAll.OrderBranch6 :: TFloat
                                                   , inOrderBranch7 := tmpAll.OrderBranch7 :: TFloat
                                                   
                                                   , inPromoPlan1       :=  0    :: TFloat
                                                   , inPromoPlan2       :=  0    :: TFloat    
                                                   , inPromoPlan3       :=  0    :: TFloat    
                                                   , inPromoPlan4       :=  0    :: TFloat    
                                                   , inPromoPlan5       :=  0    :: TFloat    
                                                   , inPromoPlan6       :=  0    :: TFloat    
                                                   , inPromoPlan7       :=  0    :: TFloat    
                                                                                             
                                                   , inPromoBranchPlan1      :=  0   :: TFloat
                                                   , inPromoBranchPlan2      :=  0   :: TFloat
                                                   , inPromoBranchPlan3      :=  0   :: TFloat
                                                   , inPromoBranchPlan4      :=  0   :: TFloat
                                                   , inPromoBranchPlan5      :=  0   :: TFloat
                                                   , inPromoBranchPlan6      :=  0   :: TFloat
                                                   , inPromoBranchPlan7      :=  0   :: TFloat
                                                   
                                                   , inUserId       := vbUserId
                                                    )
       FROM (SELECT tmpAll.UnitId
                  , tmpAll.GoodsId
                  , tmpAll.GoodsKindId

                  , SUM (CASE WHEN tmpAll.NumberDay = 1 THEN tmpAll.AmountSale ELSE 0 END) AS Amount1
                  , SUM (CASE WHEN tmpAll.NumberDay = 2 THEN tmpAll.AmountSale ELSE 0 END) AS Amount2
                  , SUM (CASE WHEN tmpAll.NumberDay = 3 THEN tmpAll.AmountSale ELSE 0 END) AS Amount3
                  , SUM (CASE WHEN tmpAll.NumberDay = 4 THEN tmpAll.AmountSale ELSE 0 END) AS Amount4
                  , SUM (CASE WHEN tmpAll.NumberDay = 5 THEN tmpAll.AmountSale ELSE 0 END) AS Amount5
                  , SUM (CASE WHEN tmpAll.NumberDay = 6 THEN tmpAll.AmountSale ELSE 0 END) AS Amount6
                  , SUM (CASE WHEN tmpAll.NumberDay = 7 THEN tmpAll.AmountSale ELSE 0 END) AS Amount7
                  
                  , SUM (CASE WHEN tmpAll.NumberDay = 1 THEN tmpAll.AmountSalePromo ELSE 0 END) AS Promo1
                  , SUM (CASE WHEN tmpAll.NumberDay = 2 THEN tmpAll.AmountSalePromo ELSE 0 END) AS Promo2
                  , SUM (CASE WHEN tmpAll.NumberDay = 3 THEN tmpAll.AmountSalePromo ELSE 0 END) AS Promo3
                  , SUM (CASE WHEN tmpAll.NumberDay = 4 THEN tmpAll.AmountSalePromo ELSE 0 END) AS Promo4
                  , SUM (CASE WHEN tmpAll.NumberDay = 5 THEN tmpAll.AmountSalePromo ELSE 0 END) AS Promo5
                  , SUM (CASE WHEN tmpAll.NumberDay = 6 THEN tmpAll.AmountSalePromo ELSE 0 END) AS Promo6
                  , SUM (CASE WHEN tmpAll.NumberDay = 7 THEN tmpAll.AmountSalePromo ELSE 0 END) AS Promo7
                  
                  , SUM (CASE WHEN tmpAll.NumberDay = 1 THEN tmpAll.AmountBranch ELSE 0 END) AS AmountBranch1
                  , SUM (CASE WHEN tmpAll.NumberDay = 2 THEN tmpAll.AmountBranch ELSE 0 END) AS AmountBranch2
                  , SUM (CASE WHEN tmpAll.NumberDay = 3 THEN tmpAll.AmountBranch ELSE 0 END) AS AmountBranch3
                  , SUM (CASE WHEN tmpAll.NumberDay = 4 THEN tmpAll.AmountBranch ELSE 0 END) AS AmountBranch4
                  , SUM (CASE WHEN tmpAll.NumberDay = 5 THEN tmpAll.AmountBranch ELSE 0 END) AS AmountBranch5
                  , SUM (CASE WHEN tmpAll.NumberDay = 6 THEN tmpAll.AmountBranch ELSE 0 END) AS AmountBranch6
                  , SUM (CASE WHEN tmpAll.NumberDay = 7 THEN tmpAll.AmountBranch ELSE 0 END) AS AmountBranch7

                  , SUM (CASE WHEN tmpAll.NumberDay = 1 THEN tmpAll.AmountOrder ELSE 0 END) AS Order1
                  , SUM (CASE WHEN tmpAll.NumberDay = 2 THEN tmpAll.AmountOrder ELSE 0 END) AS Order2
                  , SUM (CASE WHEN tmpAll.NumberDay = 3 THEN tmpAll.AmountOrder ELSE 0 END) AS Order3
                  , SUM (CASE WHEN tmpAll.NumberDay = 4 THEN tmpAll.AmountOrder ELSE 0 END) AS Order4
                  , SUM (CASE WHEN tmpAll.NumberDay = 5 THEN tmpAll.AmountOrder ELSE 0 END) AS Order5
                  , SUM (CASE WHEN tmpAll.NumberDay = 6 THEN tmpAll.AmountOrder ELSE 0 END) AS Order6
                  , SUM (CASE WHEN tmpAll.NumberDay = 7 THEN tmpAll.AmountOrder ELSE 0 END) AS Order7

                  , SUM (CASE WHEN tmpAll.NumberDay = 1 THEN tmpAll.AmountOrderPromo ELSE 0 END) AS OrderPromo1
                  , SUM (CASE WHEN tmpAll.NumberDay = 2 THEN tmpAll.AmountOrderPromo ELSE 0 END) AS OrderPromo2
                  , SUM (CASE WHEN tmpAll.NumberDay = 3 THEN tmpAll.AmountOrderPromo ELSE 0 END) AS OrderPromo3
                  , SUM (CASE WHEN tmpAll.NumberDay = 4 THEN tmpAll.AmountOrderPromo ELSE 0 END) AS OrderPromo4
                  , SUM (CASE WHEN tmpAll.NumberDay = 5 THEN tmpAll.AmountOrderPromo ELSE 0 END) AS OrderPromo5
                  , SUM (CASE WHEN tmpAll.NumberDay = 6 THEN tmpAll.AmountOrderPromo ELSE 0 END) AS OrderPromo6
                  , SUM (CASE WHEN tmpAll.NumberDay = 7 THEN tmpAll.AmountOrderPromo ELSE 0 END) AS OrderPromo7

                  , SUM (CASE WHEN tmpAll.NumberDay = 1 THEN tmpAll.AmountOrderBranch ELSE 0 END) AS OrderBranch1
                  , SUM (CASE WHEN tmpAll.NumberDay = 2 THEN tmpAll.AmountOrderBranch ELSE 0 END) AS OrderBranch2
                  , SUM (CASE WHEN tmpAll.NumberDay = 3 THEN tmpAll.AmountOrderBranch ELSE 0 END) AS OrderBranch3
                  , SUM (CASE WHEN tmpAll.NumberDay = 4 THEN tmpAll.AmountOrderBranch ELSE 0 END) AS OrderBranch4
                  , SUM (CASE WHEN tmpAll.NumberDay = 5 THEN tmpAll.AmountOrderBranch ELSE 0 END) AS OrderBranch5
                  , SUM (CASE WHEN tmpAll.NumberDay = 6 THEN tmpAll.AmountOrderBranch ELSE 0 END) AS OrderBranch6
                  , SUM (CASE WHEN tmpAll.NumberDay = 7 THEN tmpAll.AmountOrderBranch ELSE 0 END) AS OrderBranch7
                  
             FROM tmpAll
             GROUP BY tmpAll.UnitId
                    , tmpAll.GoodsId
                    , tmpAll.GoodsKindId) AS tmpAll

      ;
                                

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.11.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_GoodsReportSale (inSession:= zfCalc_UserAdmin())
