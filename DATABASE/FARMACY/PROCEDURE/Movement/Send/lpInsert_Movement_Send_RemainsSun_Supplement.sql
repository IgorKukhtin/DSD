-- Function: lpInsert_Movement_Send_RemainsSun_Supplement

DROP FUNCTION IF EXISTS lpInsert_Movement_Send_RemainsSun_Supplement (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsert_Movement_Send_RemainsSun_Supplement(
    IN inOperDate            TDateTime , -- Дата начала отчета
    IN inDriverId            Integer   , -- Водитель, распределяем только по аптекам этого
    IN inUserId              Integer     -- пользователь
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, isClose boolean
             , UnitId_From Integer, UnitName_From TVarChar

             , UnitId_To Integer, UnitName_To TVarChar
             , Amount TFloat
             
             , MinExpirationDate TDateTime

             , MCS TFloat
             , AmountRemains TFloat
             , AmountSalesDay TFloat
             , AverageSales TFloat
             , StockRatio TFloat

             , MCS_From TFloat
             , Layout_From TFloat
             , PromoUnit_From TFloat
             , Price_From TFloat
             , isCloseMCS_From boolean
             , AmountRemains_From TFloat
             , AmountSalesDey_From TFloat
             , AmountSalesMonth_From TFloat
             , AverageSalesMonth_From TFloat
             , Need_From TFloat
             , Delt_From TFloat

             , MCS_To TFloat
             , Price_To TFloat
             , isCloseMCS_To boolean
             , AmountRemains_To TFloat
             , AmountSalesDey_To TFloat
             , AmountSalesMonth_To TFloat
             , AverageSalesMonth_To TFloat
             , Need_To TFloat
             , Delta_To TFloat

             , AmountUse_To TFloat

             , InvNumberLayout TVarChar
             , LayoutName TVarChar
              )
AS
$BODY$
   DECLARE vbObjectId Integer;
   DECLARE vbDOW_curr   TVarChar;
   DECLARE vbDate_6     TDateTime;
   DECLARE vbDate_3     TDateTime;
   DECLARE vbDate_1     TDateTime;
   DECLARE vbDate_0     TDateTime;

   DECLARE curPartion_next refcursor;
   DECLARE curResult_next  refcursor;

   DECLARE vbUnitId_from Integer;
   DECLARE vbUnitId_To Integer;
   DECLARE vbGoodsId TFloat;
   DECLARE vbSurplus TFloat;
   DECLARE vbNeed TFloat;
   DECLARE vbKoeffSUN TFloat;
   DECLARE vbisEliminateColdSUN Boolean;
BEGIN
     --
     --
     vbObjectId := lpGet_DefaultValue ('zc_Object_Retail', inUserId);

     -- день недели
     vbDOW_curr:= (SELECT CASE WHEN tmp.RetV = 0 THEN 7 ELSE tmp.RetV END
                   FROM (SELECT EXTRACT(DOW FROM inOperDate) AS RetV) AS tmp
                  ) :: TVarChar;

     SELECT COALESCE(ObjectBoolean_CashSettings_EliminateColdSUN.ValueData, FALSE) 
     INTO vbisEliminateColdSUN
     FROM Object AS Object_CashSettings
          LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_EliminateColdSUN
                                  ON ObjectBoolean_CashSettings_EliminateColdSUN.ObjectId = Object_CashSettings.Id 
                                 AND ObjectBoolean_CashSettings_EliminateColdSUN.DescId = zc_ObjectBoolean_CashSettings_EliminateColdSUN()
     WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
     LIMIT 1;

     -- все Товары для схемы SUN Supplement
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_SUN_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpGoods_SUN_Supplement (GoodsId Integer, KoeffSUN TFloat, UnitOutId Integer, UnitOut2Id Integer, isSmudge Boolean, SupplementMin Integer, SupplementMinPP Integer) ON COMMIT DROP;
     END IF;

     -- все Подразделения для схемы SUN Supplement
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpUnit_SUN_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpUnit_SUN_Supplement (UnitId Integer, DeySupplSun1 Integer, MonthSupplSun1 Integer, isSUN_Supplement_in Boolean, isSUN_Supplement_out Boolean, isSUN_Supplement_Priority Boolean, SalesRatio TFloat) ON COMMIT DROP;
     END IF;

     -- Выкладки
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoodsLayout_SUN_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpGoodsLayout_SUN_Supplement (GoodsId Integer, UnitId Integer, Layout TFloat, isNotMoveRemainder6 boolean, MovementLayoutId Integer) ON COMMIT DROP;
     END IF;

     -- Маркетинговый план для точек
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_PromoUnit_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpGoods_PromoUnit_Supplement (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     END IF;

     -- Товары дисконтных проектов
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_DiscountExternal_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpGoods_DiscountExternal_Supplement  (UnitId Integer, GoodsId Integer) ON COMMIT DROP;
     END IF;

     -- Исключения по техническим переучетам по Аптекам - если есть в непроведенных ТП то исключаем из распределения
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_TP_exception_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpGoods_TP_exception_Supplement   (UnitId Integer, GoodsId Integer) ON COMMIT DROP;
     END IF;

     -- Уже использовано в текущем СУН
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpGoods_Sun_exception_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpGoods_Sun_exception_Supplement   (UnitId Integer, GoodsId Integer, Amount TFloat) ON COMMIT DROP;
     END IF;

     -- исключаем такие перемещения
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpUnit_SunExclusion_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpUnit_SunExclusion_Supplement (UnitId_from Integer, UnitId_to Integer) ON COMMIT DROP;
     END IF;

     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpRemains_all_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpRemains_all_Supplement   (UnitId Integer, GoodsId Integer, Price TFloat, MCS TFloat, Layout TFloat, AmountRemains TFloat, AmountNotSend TFloat, 
                                                       AmountSalesDay TFloat, AmountSalesMonth TFloat, AverageSalesMonth TFloat, Need TFloat, GiveAway TFloat, AmountUse TFloat, 
                                                       MinExpirationDate TDateTime, isCloseMCS boolean, SupplementMin Integer) ON COMMIT DROP;
     END IF;

     -- 2. все остатки, НТЗ, и коэф. товарного запаса
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpStockRatio_all_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpStockRatio_all_Supplement   (GoodsId Integer, MCS TFloat, AmountRemains TFloat, AmountSalesDay TFloat, AverageSales TFloat, StockRatio TFloat) ON COMMIT DROP;
     END IF;

     -- 3. распределяем-1 остатки - по всем аптекам
     IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpResult_Supplement'))
     THEN
       CREATE TEMP TABLE _tmpResult_Supplement   (UnitId_from Integer, UnitId_to Integer, GoodsId Integer, Amount TFloat, MovementId Integer, MovementItemId Integer) ON COMMIT DROP;
     END IF;

     -- все Товары для схемы SUN Supplement
     DELETE FROM _tmpGoods_SUN_Supplement;
     -- все Подразделения для схемы SUN
     DELETE FROM _tmpUnit_SUN_Supplement;
     -- Выкладки
     DELETE FROM _tmpGoodsLayout_SUN_Supplement;
     -- Маркетинговый план для точек
     DELETE FROM _tmpGoods_PromoUnit_Supplement;
     -- Товары дисконтных проектов
     DELETE FROM _tmpGoods_DiscountExternal_Supplement;
     -- Исключения по техническим переучетам по Аптекам - если есть в непроведенных ТП то исключаем из распределения
     DELETE FROM _tmpGoods_TP_exception_Supplement;
     -- Уже использовано в текущем СУН
     DELETE FROM _tmpGoods_Sun_exception_Supplement;
     -- 1. все остатки, НТЗ => получаем кол-ва автозаказа
     DELETE FROM _tmpRemains_all_Supplement;
     -- 2. все остатки, НТЗ, и коэф. товарного запаса
     DELETE FROM _tmpStockRatio_all_Supplement;
     -- 3. распределяем-1 остатки - по всем аптекам
     DELETE FROM _tmpResult_Supplement;
     DELETE FROM _tmpUnit_SunExclusion_Supplement;

     -- все Подразделения для схемы SUN
     INSERT INTO _tmpUnit_SUN_Supplement (UnitId, DeySupplSun1, MonthSupplSun1, isSUN_Supplement_in, isSUN_Supplement_out, isSUN_Supplement_Priority, SalesRatio)
        SELECT OB.ObjectId
             , COALESCE (NULLIF(OF_DeySupplSun1.ValueData, 0), 30)::Integer              AS DeySupplSun1
             , COALESCE (NULLIF(OF_MonthSupplSun1.ValueData, 0), 8)::Integer             AS MonthSupplSun1
             , COALESCE (ObjectBoolean_SUN_Supplement_in.ValueData, FALSE)  :: Boolean   AS isSUN_Supplement_in
             , COALESCE (ObjectBoolean_SUN_Supplement_out.ValueData, FALSE) :: Boolean   AS isSUN_Supplement_out             
             , COALESCE (ObjectBoolean_SUN_Supplement_Priority.ValueData, FALSE) :: Boolean   AS isSUN_Supplement_Priority             
             , CASE WHEN ObjectDate_FirstCheck.ValueData IS NOT NULL AND
                         (inOperDate::Date - ObjectDate_FirstCheck.ValueData::Date) <
                         (inOperDate::Date - (inOperDate::Date - (COALESCE (NULLIF(OF_MonthSupplSun1.ValueData, 0), 8)::Integer::TVarChar||' MONTH')::INTERVAL)::Date)
                    THEN (inOperDate::Date - (inOperDate::Date - (COALESCE (NULLIF(OF_MonthSupplSun1.ValueData, 0), 8)::Integer::TVarChar||' MONTH')::INTERVAL)::Date)::TFloat / (CURRENT_DATE - ObjectDate_FirstCheck.ValueData::Date)::TFloat
                    ELSE 1 END     
        FROM ObjectBoolean AS OB
             LEFT JOIN ObjectFloat   AS OF_DeySupplSun1  ON OF_DeySupplSun1.ObjectId  = OB.ObjectId AND OF_DeySupplSun1.DescId     = zc_ObjectFloat_Unit_DeySupplSun1()
             LEFT JOIN ObjectFloat   AS OF_MonthSupplSun1 ON OF_MonthSupplSun1.ObjectId = OB.ObjectId AND OF_MonthSupplSun1.DescId = zc_ObjectFloat_Unit_MonthSupplSun1()
             LEFT JOIN ObjectString  AS OS_ListDaySUN  ON OS_ListDaySUN.ObjectId  = OB.ObjectId AND OS_ListDaySUN.DescId  = zc_ObjectString_Unit_ListDaySUN()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_Supplement_in
                                     ON ObjectBoolean_SUN_Supplement_in.ObjectId = OB.ObjectId
                                    AND ObjectBoolean_SUN_Supplement_in.DescId = zc_ObjectBoolean_Unit_SUN_Supplement_in()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_Supplement_out
                                     ON ObjectBoolean_SUN_Supplement_out.ObjectId = OB.ObjectId
                                    AND ObjectBoolean_SUN_Supplement_out.DescId = zc_ObjectBoolean_Unit_SUN_Supplement_out()
             LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_Supplement_Priority
                                     ON ObjectBoolean_SUN_Supplement_Priority.ObjectId = OB.ObjectId
                                    AND ObjectBoolean_SUN_Supplement_Priority.DescId = zc_ObjectBoolean_Unit_SUN_Supplement_Priority()
             LEFT JOIN ObjectDate AS ObjectDate_FirstCheck
                                  ON ObjectDate_FirstCheck.ObjectId = OB.ObjectId
                                 AND ObjectDate_FirstCheck.DescId = zc_ObjectDate_Unit_FirstCheck()
                                    
             -- !!!только для этого водителя!!!
             /*INNER JOIN ObjectLink AS ObjectLink_Unit_Driver
                                   ON ObjectLink_Unit_Driver.ObjectId      = OB.ObjectId
                                  AND ObjectLink_Unit_Driver.DescId        = zc_ObjectLink_Unit_Driver()
                                  AND ObjectLink_Unit_Driver.ChildObjectId = inDriverId*/
        WHERE OB.ValueData = TRUE AND OB.DescId = zc_ObjectBoolean_Unit_SUN()
          -- если указан день недели - проверим его
          AND (OS_ListDaySUN.ValueData ILIKE '%' || vbDOW_curr || '%' OR COALESCE (OS_ListDaySUN.ValueData, '') = '')
          AND (COALESCE (ObjectBoolean_SUN_Supplement_in.ValueData, FALSE) = TRUE 
            OR COALESCE (ObjectBoolean_SUN_Supplement_out.ValueData, FALSE) = TRUE)         
       ;

     -- Товары дисконтных проектов
     
      WITH tmpUnitDiscount AS (SELECT ObjectLink_DiscountExternal.ChildObjectId     AS DiscountExternalId 
                                    , ObjectLink_Unit.ChildObjectId                 AS UnitId
                               FROM Object AS Object_DiscountExternalTools
                                     LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                                          ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalTools.Id
                                                         AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalTools_DiscountExternal()
                                     LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                          ON ObjectLink_Unit.ObjectId = Object_DiscountExternalTools.Id
                                                         AND ObjectLink_Unit.DescId = zc_ObjectLink_DiscountExternalTools_Unit()
                                WHERE Object_DiscountExternalTools.DescId = zc_Object_DiscountExternalTools()
                                  AND Object_DiscountExternalTools.isErased = False
                                )
      INSERT INTO _tmpGoods_DiscountExternal_Supplement
      SELECT 
             tmpUnitDiscount.UnitId  
           , ObjectLink_BarCode_Goods.ChildObjectId AS GoodsId
                                               
      FROM Object AS Object_BarCode
           LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                               AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                     
           LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                               AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
           LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId           

           LEFT JOIN tmpUnitDiscount ON tmpUnitDiscount.DiscountExternalId = ObjectLink_BarCode_Object.ChildObjectId 

      WHERE Object_BarCode.DescId = zc_Object_BarCode()
        AND Object_BarCode.isErased = False
        AND Object_Object.isErased = False
        AND COALESCE (tmpUnitDiscount.DiscountExternalId, 0) <> 0
      GROUP BY ObjectLink_BarCode_Goods.ChildObjectId
             , tmpUnitDiscount.UnitId;


     -- Исключения по техническим переучетам по Аптекам - если есть в непроведенных ТП то исключаем из распределения
     WITH
         tmpMovement AS (SELECT Movement.Id
                              , MovementLinkObject_Unit.ObjectId AS UnitId
                         FROM Movement

                              LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                         WHERE Movement.DescId = zc_Movement_TechnicalRediscount()
                            AND Movement.StatusId = zc_Enum_Status_UnComplete())
      , tmpGoods AS (SELECT Movement.UnitId
                          , MovementItem.ObjectId       AS GoodsId
                          , SUM(MovementItem.Amount)    AS Amount
                     FROM _tmpUnit_SUN_Supplement

                          INNER JOIN tmpMovement AS Movement ON Movement.UnitId = _tmpUnit_SUN_Supplement.UnitId

                          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                         AND MovementItem.DescId     = zc_MI_Master()
                                         AND MovementItem.isErased  = FALSE
                                         AND MovementItem.Amount < 0
                          INNER JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                                            ON MILinkObject_CommentTR.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()
                          INNER JOIN ObjectBoolean AS ObjectBoolean_CommentTR_BlockFormSUN
                                                   ON ObjectBoolean_CommentTR_BlockFormSUN.ObjectId = MILinkObject_CommentTR.ObjectId
                                                  AND ObjectBoolean_CommentTR_BlockFormSUN.DescId = zc_ObjectFloat_CommentTR_BlockFormSUN()
                                                  AND ObjectBoolean_CommentTR_BlockFormSUN.ValueData = True
                     GROUP BY Movement.UnitId
                            , MovementItem.ObjectId
                     )

     INSERT INTO _tmpGoods_TP_exception_Supplement   (UnitId, GoodsId)
     SELECT tmpGoods.UnitId, tmpGoods.GoodsId
     FROM tmpGoods;

     -- Уже использовано в текущем СУН
     WITH
          tmpSUN AS (SELECT MovementLinkObject_From.ObjectId AS UnitId
                          , MovementItem.ObjectId            AS GoodsId
                          , SUM (MovementItem.Amount)        AS Amount
                     FROM Movement
                          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                                       AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                          INNER JOIN MovementBoolean AS MovementBoolean_SUN
                                                     ON MovementBoolean_SUN.MovementId = Movement.Id
                                                    AND MovementBoolean_SUN.DescId     = zc_MovementBoolean_SUN()
                                                    AND MovementBoolean_SUN.ValueData  = TRUE
                          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                 AND MovementItem.isErased   = FALSE
                                                 AND MovementItem.Amount     > 0
                     WHERE Movement.OperDate = inOperDate
                       AND Movement.DescId   = zc_Movement_Send()
                       AND Movement.StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased())
                     GROUP BY MovementLinkObject_From.ObjectId
                            , MovementItem.ObjectId
                    )
     -- Результат-1
     INSERT INTO _tmpGoods_Sun_exception_Supplement (UnitId, GoodsId, Amount)
        SELECT tmpSUN.UnitId, tmpSUN.GoodsId, tmpSUN.Amount
        FROM tmpSUN;
     
     -- исключаем такие перемещения
     INSERT INTO _tmpUnit_SunExclusion_Supplement (UnitId_from, UnitId_to)
        SELECT COALESCE (ObjectLink_From.ChildObjectId, 0) AS UnitId_from
             , COALESCE (ObjectLink_To.ChildObjectId,   0) AS UnitId_to
        FROM Object
             INNER JOIN ObjectBoolean AS OB
                                      ON OB.ObjectId  = Object.Id
                                     AND OB.DescId    = zc_ObjectBoolean_SunExclusion_v1()
                                     AND OB.ValueData = TRUE
             LEFT JOIN ObjectLink AS ObjectLink_From
                                  ON ObjectLink_From.ObjectId = Object.Id
                                 AND ObjectLink_From.DescId   = zc_ObjectLink_SunExclusion_From()
             -- в этом случае возьмем всех
             LEFT JOIN _tmpUnit_SUN_Supplement AS _tmpUnit_SUN_From ON ObjectLink_From.ChildObjectId IS NULL

             LEFT JOIN ObjectLink AS ObjectLink_To
                                  ON ObjectLink_To.ObjectId = Object.Id
                                 AND ObjectLink_To.DescId   = zc_ObjectLink_SunExclusion_To()
             -- в этом случае возьмем всех
             LEFT JOIN _tmpUnit_SUN_Supplement AS _tmpUnit_SUN_To ON ObjectLink_To.ChildObjectId IS NULL

        WHERE Object.DescId   = zc_Object_SunExclusion()
          AND Object.isErased = FALSE
           ;
           
     -- Товар из перемещения
/*     IF inOperDate = '01.02.2021'
     THEN
     
       INSERT INTO _tmpGoods_SUN_Supplement (GoodsId, KoeffSUN, UnitOutId)
       SELECT MovementItem.ObjectId
            , Object_Goods_Retail.KoeffSUN_Supplementv1
            , MovementLinkObject_To.ObjectId
       FROM Movement

            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                   AND MovementItem.Amount > 0
                                   AND MovementItem.isErased = False
                                     
            INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItem.ObjectId

       WHERE Movement.DescId = zc_Movement_Send()
         AND Movement.InvNumber = '110120'
         AND Movement.StatusId = zc_Enum_Status_Complete();
       
     END IF;*/

     -- все Товары для схемы SUN Supplement
     INSERT INTO _tmpGoods_SUN_Supplement (GoodsId, KoeffSUN, UnitOutId, UnitOut2Id, isSmudge, SupplementMin, SupplementMinPP)
        SELECT Object_Goods_Retail.ID
             , Object_Goods_Retail.KoeffSUN_Supplementv1
             , Object_Goods_Main.UnitSupplementSUN1OutId
             , Object_Goods_Main.UnitSupplementSUN2OutId
             , Object_Goods_Main.isSupplementSmudge
             , Object_Goods_Main.SupplementMin
             , Object_Goods_Main.SupplementMinPP 
        FROM Object_Goods_Retail
             INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                         AND Object_Goods_Main.isSupplementSUN1 = TRUE
             LEFT JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = Object_Goods_Retail.ID
             LEFT JOIN ObjectBoolean AS ObjectBoolean_ColdSUN
                                     ON ObjectBoolean_ColdSUN.ObjectId = Object_Goods_Main.ConditionsKeepId
                                    AND ObjectBoolean_ColdSUN.DescId = zc_ObjectBoolean_ConditionsKeep_ColdSUN()
        WHERE Object_Goods_Retail.RetailID = vbObjectId
          AND COALESCE(_tmpGoods_SUN_Supplement.GoodsId, 0) = 0
          AND (COALESCE (ObjectBoolean_ColdSUN.ValueData, FALSE) = FALSE AND
               Object_Goods_Main.isColdSUN = FALSE OR vbisEliminateColdSUN = FALSE);

/*     INSERT INTO _tmpGoods_SUN_Supplement (GoodsId, KoeffSUN, UnitOutId, UnitOut2Id)
        SELECT Object_Goods_Retail.ID
             , Object_Goods_Retail.KoeffSUN_Supplementv1
             , Null
             , Null
        FROM Object_Goods_Retail
             INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
             INNER JOIN Container ON Container.ObjectId = Object_Goods_Retail.ID
                                 AND Container.Amount <> 0 
                                 AND Container.WhereObjectId in (SELECT OB.ObjectId
                                                                 FROM ObjectBoolean AS OB
                                                                 WHERE OB.ValueData = TRUE AND OB.DescId = zc_ObjectBoolean_Unit_SUN())
        WHERE Object_Goods_Retail.RetailID = vbObjectId
          AND Object_Goods_Retail.ID > 389398
        GROUP BY Object_Goods_Retail.ID
              , Object_Goods_Retail.KoeffSUN_Supplementv1;*/
              
     -- Выкладки
     WITH tmpLayoutMovement AS (SELECT Movement.Id                                                   AS Id
                                     , COALESCE(MovementBoolean_PharmacyItem.ValueData, FALSE)      AS isPharmacyItem
                                     , COALESCE(MovementBoolean_NotMoveRemainder6.ValueData, FALSE) AS isNotMoveRemainder6
                                FROM Movement
                                     LEFT JOIN MovementBoolean AS MovementBoolean_PharmacyItem
                                                               ON MovementBoolean_PharmacyItem.MovementId = Movement.Id
                                                              AND MovementBoolean_PharmacyItem.DescId = zc_MovementBoolean_PharmacyItem()
                                     LEFT JOIN MovementBoolean AS MovementBoolean_NotMoveRemainder6
                                                               ON MovementBoolean_NotMoveRemainder6.MovementId = Movement.Id
                                                              AND MovementBoolean_NotMoveRemainder6.DescId = zc_MovementBoolean_NotMoveRemainder6()
                                WHERE Movement.DescId = zc_Movement_Layout()
                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                               )
        , tmpLayout AS (SELECT Movement.ID                        AS Id
                             , MovementItem.ObjectId              AS GoodsId
                             , MovementItem.Amount                AS Amount
                             , Movement.isPharmacyItem            AS isPharmacyItem
                             , Movement.isNotMoveRemainder6       AS isNotMoveRemainder6
                        FROM tmpLayoutMovement AS Movement
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    AND MovementItem.isErased = FALSE
                                                    AND MovementItem.Amount > 0
                       )
        , tmpLayoutUnit AS (SELECT Movement.ID                        AS Id
                                 , MovementItem.ObjectId              AS UnitId
                                 , MovementItem.Amount                AS Amount
                            FROM tmpLayoutMovement AS Movement
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId = zc_MI_Child()
                                                        AND MovementItem.isErased = FALSE
                                                        AND MovementItem.Amount > 0
                           )
                               
        , tmpLayoutUnitCount AS (SELECT tmpLayoutUnit.ID                  AS Id
                                      , count(*)                          AS CountUnit
                                 FROM tmpLayoutUnit
                                 GROUP BY tmpLayoutUnit.ID
                                 )
        , tmpLayoutAll AS (SELECT tmpLayout.GoodsId                             AS GoodsId
                                , _tmpUnit_SUN_Supplement.UnitId                AS UnitId
                                , tmpLayout.Amount                              AS Amount
                                , tmpLayout.isNotMoveRemainder6                 AS isNotMoveRemainder6
                                , tmpLayout.ID                                  AS MovementLayoutId
                           FROM _tmpUnit_SUN_Supplement
                                
                                LEFT JOIN Object AS Object_Unit
                                                 ON Object_Unit.Id        = _tmpUnit_SUN_Supplement.UnitId
                                                AND Object_Unit.DescId    = zc_Object_Unit()
                                 
                                INNER JOIN tmpLayout ON 1 = 1 

                                LEFT JOIN tmpLayoutUnit ON tmpLayoutUnit.Id     = tmpLayout.Id
                                                       AND tmpLayoutUnit.UnitId = _tmpUnit_SUN_Supplement.UnitId

                                LEFT JOIN tmpLayoutUnitCount ON tmpLayoutUnitCount.Id     = tmpLayout.Id
                                 
                           WHERE (tmpLayoutUnit.UnitId = _tmpUnit_SUN_Supplement.UnitId OR COALESCE (tmpLayoutUnitCount.CountUnit, 0) = 0)
                             AND (Object_Unit.ValueData NOT ILIKE 'Апт. пункт %' OR tmpLayout.isPharmacyItem = True)
                           )
                                                              
     INSERT INTO  _tmpGoodsLayout_SUN_Supplement (GoodsId, UnitId, Layout, isNotMoveRemainder6, MovementLayoutId) 
     SELECT tmpLayoutAll.GoodsId                 AS GoodsId
          , tmpLayoutAll.UnitId                  AS UnitId
          , MAX (tmpLayoutAll.Amount):: TFloat   AS Amount
          , SUM (CASE WHEN tmpLayoutAll.isNotMoveRemainder6 = TRUE THEN 1 ELSE 0 END) > 0   AS isNotMoveRemainder6
          , MAX (tmpLayoutAll.MovementLayoutId)  AS MovementLayoutId
      FROM tmpLayoutAll      
      GROUP BY tmpLayoutAll.GoodsId
             , tmpLayoutAll.UnitId;
      
     -- Маркетинговый план для точек
      WITH tmpUserUnit AS (SELECT COALESCE(MILinkObject_Unit.ObjectId, ObjectLink_Member_Unit.ChildObjectId) AS UnitId
                                , Count(*)                                                                   AS CountUser
                           FROM Movement
                                  
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.id
                                                        AND MovementItem.DescId = zc_MI_Master()

                                 LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                      ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                                                     AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
   
                                 LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                                                      ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                                     AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

                                 LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                                      ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                                     AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()

                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                  ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                                                            
                           WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
                             AND Movement.OperDate = DATE_TRUNC ('MONTH', inOperDate)
                             AND ObjectLink_Member_Position.ChildObjectId = 1672498
                           GROUP BY COALESCE(MILinkObject_Unit.ObjectId, ObjectLink_Member_Unit.ChildObjectId))

      INSERT INTO _tmpGoods_PromoUnit_Supplement
      SELECT OL_UnitCategory.Objectid                AS UnitId
           , MI_Goods.Objectid                       AS GoodsId
           , COALESCE(NULLIF(MIFloat_AmountPlanMax.ValueData, 0), MI_Goods.Amount) * tmpUserUnit.CountUser AS Amount

      FROM Movement

           INNER JOIN MovementLinkObject AS MovementLinkObject_UnitCategory
                                         ON MovementLinkObject_UnitCategory.MovementId = Movement.Id
                                        AND MovementLinkObject_UnitCategory.DescId = zc_MovementLinkObject_UnitCategory()
           INNER JOIN ObjectLink AS OL_UnitCategory
                                 ON OL_UnitCategory.DescId = zc_ObjectLink_Unit_Category()
                                AND OL_UnitCategory.ChildObjectId = MovementLinkObject_UnitCategory.ObjectId
                                
           INNER JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = OL_UnitCategory.Objectid

           INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                              AND MI_Goods.DescId = zc_MI_Master()
                                              AND MI_Goods.isErased = FALSE
                                            
           LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                       ON MIFloat_AmountPlanMax.MovementItemId = MI_Goods.Id
                                      AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()
                                                          
           INNER JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = MI_Goods.Objectid 
                                                          
           INNER JOIN tmpUserUnit ON tmpUserUnit.UnitId = OL_UnitCategory.Objectid

      WHERE Movement.StatusId = zc_Enum_Status_Complete()
        AND Movement.DescId = zc_Movement_PromoUnit()
        AND Movement.OperDate = DATE_TRUNC ('MONTH', inOperDate)
        AND COALESCE(NULLIF(MIFloat_AmountPlanMax.ValueData, 0), MI_Goods.Amount) > 0;
      
 --raise notice 'Value 05: %', (select Count(*) from _tmpGoods_PromoUnit_Supplement);      

     -- 1. все остатки
     --
     WITH tmpRemainsPD AS (SELECT Container.ParentId
                                , Container.Amount
                                , COALESCE (ObjectDate_PartionGoods_Value.ValueData, zc_DateEnd())    AS ExpirationDate
                           FROM Container
                                -- !!!только для таких Аптек!!!
                                INNER JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = Container.ObjectId
                                INNER JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = Container.WhereObjectId
                                LEFT JOIN _tmpGoods_TP_exception_Supplement ON _tmpGoods_TP_exception_Supplement.GoodsId = Container.ObjectId
                                                                AND _tmpGoods_TP_exception_Supplement.UnitId = Container.WhereObjectId

                                LEFT JOIN ContainerLinkObject AS CLO_PartionGoods
                                                              ON CLO_PartionGoods.ContainerId = Container.Id
                                                             AND CLO_PartionGoods.DescId = zc_ContainerLinkObject_PartionGoods()
                                LEFT JOIN ObjectDate AS ObjectDate_PartionGoods_Value
                                                     ON ObjectDate_PartionGoods_Value.ObjectId = CLO_PartionGoods.ObjectId
                                                    AND ObjectDate_PartionGoods_Value.DescId   = zc_ObjectDate_PartionGoods_Value()
                           WHERE Container.DescId = zc_Container_CountPartionDate()
                             AND Container.Amount <> 0
                             AND COALESCE (_tmpGoods_TP_exception_Supplement.GoodsId, 0) = 0
                          )
        , tmpRemains AS (SELECT Container.WhereObjectId AS UnitId
                              , Container.ObjectId      AS GoodsId
                              , SUM (COALESCE (tmpRemainsPD.Amount, Container.Amount, 0))                              AS Amount
                              , SUM (CASE WHEN COALESCE (tmpRemainsPD.ExpirationDate, zc_DateEnd()) <= CURRENT_DATE + INTERVAL '30 DAY'
                                          THEN COALESCE (tmpRemainsPD.Amount, Container.Amount, 0)
                                          ELSE 0 END)                                                                         AS AmountNotSend
                              , SUM (CASE WHEN COALESCE (tmpRemainsPD.ExpirationDate, zc_DateEnd()) <= CURRENT_DATE + INTERVAL '6 MONTH'
                                          THEN COALESCE (tmpRemainsPD.Amount, Container.Amount, 0)
                                          ELSE 0 END)                                                                         AS Amount6Month
                              , MIN (CASE WHEN COALESCE (tmpRemainsPD.ExpirationDate, zc_DateEnd()) >= CURRENT_DATE + INTERVAL '30 DAY'
                                          THEN COALESCE (tmpRemainsPD.ExpirationDate, MIDate_ExpirationDate.ValueData, zc_DateEnd())
                                          ELSE zc_DateEnd() END)                                                              AS MinExpirationDate
                         FROM Container
                              -- !!!только для таких Аптек!!!
                              INNER JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = Container.ObjectId
                              INNER JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = Container.WhereObjectId
                              LEFT JOIN _tmpGoods_TP_exception_Supplement ON _tmpGoods_TP_exception_Supplement.GoodsId = Container.ObjectId
                                                              AND _tmpGoods_TP_exception_Supplement.UnitId = Container.WhereObjectId
                                                              
                              LEFT JOIN tmpRemainsPD ON tmpRemainsPD.ParentId = Container.Id
 
                              LEFT JOIN ContainerlinkObject AS ContainerLinkObject_MovementItem
                                                            ON ContainerLinkObject_MovementItem.Containerid = Container.Id
                                                           AND ContainerLinkObject_MovementItem.DescId = zc_ContainerLinkObject_PartionMovementItem()
                              LEFT OUTER JOIN Object AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = ContainerLinkObject_MovementItem.ObjectId
                              -- элемент прихода
                              LEFT JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode
                              -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                              LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                          ON MIFloat_MovementItem.MovementItemId = MI_Income.Id
                                                         AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                              -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                              LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id  = (MIFloat_MovementItem.ValueData :: Integer)

                              LEFT OUTER JOIN MovementItemDate AS MIDate_ExpirationDate
                                                               ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id, MI_Income.Id) 
                                                              AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

                         WHERE Container.DescId = zc_Container_Count()
                           AND Container.Amount <> 0
                           AND COALESCE (_tmpGoods_TP_exception_Supplement.GoodsId, 0) = 0
                           --AND COALESCE (tmpRemainsPD.ExpirationDate, zc_DateEnd()) > CURRENT_DATE + INTERVAL '30 DAY'
                         GROUP BY Container.WhereObjectId
                                , Container.ObjectId
                        )
          -- Продажи
        , tmpSalesDay AS (SELECT _tmpUnit_SUN_Supplement.UnitId
                               , _tmpGoods_SUN_Supplement.GoodsId
                               , SUM (COALESCE (AnalysisContainerItem.AmountCheck, 0)) AS AmountSalesDay
                          FROM  _tmpGoods_SUN_Supplement
                               INNER JOIN _tmpUnit_SUN_Supplement ON 1 = 1

                               INNER JOIN AnalysisContainerItem ON AnalysisContainerItem.GoodsId = _tmpGoods_SUN_Supplement.GoodsId
                                                               AND AnalysisContainerItem.UnitID = _tmpUnit_SUN_Supplement.UnitId
                          WHERE AnalysisContainerItem.OperDate >= CURRENT_DATE - (_tmpUnit_SUN_Supplement.DeySupplSun1::TVarChar ||' DAY') :: INTERVAL
                            AND AnalysisContainerItem.AmountCheck <> 0
                          GROUP BY _tmpUnit_SUN_Supplement.UnitId
                                 , _tmpGoods_SUN_Supplement.GoodsId
                      )
        , tmpSalesMonth AS (SELECT _tmpUnit_SUN_Supplement.UnitId
                                 , _tmpGoods_SUN_Supplement.GoodsId
                                 , SUM (COALESCE (AnalysisContainerItem.AmountCheck, 0)) * _tmpUnit_SUN_Supplement.SalesRatio AS AmountSalesMonth
                            FROM  _tmpGoods_SUN_Supplement
                                 INNER JOIN _tmpUnit_SUN_Supplement ON 1 = 1

                                 INNER JOIN AnalysisContainerItem ON AnalysisContainerItem.GoodsId = _tmpGoods_SUN_Supplement.GoodsId
                                                                 AND AnalysisContainerItem.UnitID = _tmpUnit_SUN_Supplement.UnitId
                            WHERE AnalysisContainerItem.OperDate >= CURRENT_DATE - (_tmpUnit_SUN_Supplement.MonthSupplSun1::TVarChar ||' MONTH') :: INTERVAL
                              AND AnalysisContainerItem.AmountCheck <> 0
                            GROUP BY _tmpUnit_SUN_Supplement.UnitId
                                   , _tmpGoods_SUN_Supplement.GoodsId
                                   , _tmpUnit_SUN_Supplement.SalesRatio
                        )
          -- цены
        , tmpPrice AS (SELECT OL_Price_Unit.ChildObjectId       AS UnitId
                            , OL_Price_Goods.ChildObjectId      AS GoodsId
                            , ROUND (Price_Value.ValueData, 2)  AS Price
                            , MCS_Value.ValueData               AS MCSValue
                            , CASE WHEN Price_MCSValueMin.ValueData IS NOT NULL
                                   THEN CASE WHEN COALESCE (Price_MCSValueMin.ValueData, 0) < COALESCE (MCS_Value.ValueData, 0) THEN COALESCE (Price_MCSValueMin.ValueData, 0) ELSE MCS_Value.ValueData END
                                   ELSE 0
                              END AS MCSValue_min
                            , COALESCE (MCS_isClose.ValueData, FALSE) AS isCloseMCS
                       FROM ObjectLink AS OL_Price_Unit
                            -- !!!только для таких Аптек!!!
                            INNER JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = OL_Price_Unit.ChildObjectId
                            INNER JOIN ObjectLink AS OL_Price_Goods
                                                  ON OL_Price_Goods.ObjectId = OL_Price_Unit.ObjectId
                                                 AND OL_Price_Goods.DescId   = zc_ObjectLink_Price_Goods()
                            INNER JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = OL_Price_Goods.ChildObjectId
                            INNER JOIN Object AS Object_Goods
                                              ON Object_Goods.Id       = OL_Price_Goods.ChildObjectId
                                            -- AND Object_Goods.isErased = FALSE
                            LEFT JOIN ObjectBoolean AS MCS_isClose
                                                    ON MCS_isClose.ObjectId  = OL_Price_Unit.ObjectId
                                                   AND MCS_isClose.DescId    = zc_ObjectBoolean_Price_MCSIsClose()
                            LEFT JOIN ObjectFloat AS Price_Value
                                                  ON Price_Value.ObjectId = OL_Price_Unit.ObjectId
                                                 AND Price_Value.DescId = zc_ObjectFloat_Price_Value()
                            LEFT JOIN ObjectFloat AS MCS_Value
                                                  ON MCS_Value.ObjectId = OL_Price_Unit.ObjectId
                                                 AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()
                            LEFT JOIN ObjectFloat AS Price_MCSValueMin
                                                  ON Price_MCSValueMin.ObjectId = OL_Price_Unit.ObjectId
                                                 AND Price_MCSValueMin.DescId = zc_ObjectFloat_Price_MCSValueMin()
                       WHERE OL_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                       --  AND COALESCE(MCS_isClose.ValueData, FALSE) = TRUE
                      )
          -- данные из ассорт. матрицы
        , tmpGoodsCategory AS (SELECT ObjectLink_GoodsCategory_Unit.ChildObjectId AS UnitId
                                    , ObjectLink_Child_retail.ChildObjectId       AS GoodsId
                                    , ObjectFloat_Value.ValueData                 AS Value
                               FROM Object AS Object_GoodsCategory
                                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Unit
                                                         ON ObjectLink_GoodsCategory_Unit.ObjectId = Object_GoodsCategory.Id
                                                        AND ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
                                   -- !!!только для таких Аптек!!!
                                   INNER JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = ObjectLink_GoodsCategory_Unit.ChildObjectId

                                   INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Goods
                                                         ON ObjectLink_GoodsCategory_Goods.ObjectId = Object_GoodsCategory.Id
                                                        AND ObjectLink_GoodsCategory_Goods.DescId = zc_ObjectLink_GoodsCategory_Goods()
                                   INNER JOIN ObjectFloat AS ObjectFloat_Value
                                                          ON ObjectFloat_Value.ObjectId = Object_GoodsCategory.Id
                                                         AND ObjectFloat_Value.DescId = zc_ObjectFloat_GoodsCategory_Value()
                                                         AND COALESCE (ObjectFloat_Value.ValueData,0) <> 0
                                   -- выходим на товар сети
                                   INNER JOIN ObjectLink AS ObjectLink_Main_retail
                                                         ON ObjectLink_Main_retail.ChildObjectId = ObjectLink_GoodsCategory_Goods.ChildObjectId
                                                        AND ObjectLink_Main_retail.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                   INNER JOIN ObjectLink AS ObjectLink_Child_retail
                                                         ON ObjectLink_Child_retail.ObjectId = ObjectLink_Main_retail.ObjectId
                                                        AND ObjectLink_Child_retail.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                   INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                         ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_retail.ChildObjectId
                                                        AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                        AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                               --    INNER JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = ObjectLink_Child_retail.ChildObjectId
                               WHERE Object_GoodsCategory.DescId   = zc_Object_GoodsCategory()
                                 AND Object_GoodsCategory.isErased = FALSE
                               )
          -- подменяем НТЗ на значение из ассорт. матрицы, если в ассотр. матрице значение больше
        , tmpObject_Price AS (SELECT COALESCE (tmpPrice.UnitId,  tmpGoodsCategory.UnitId)  AS UnitId
                                   , COALESCE (tmpPrice.GoodsId, tmpGoodsCategory.GoodsId) AS GoodsId
                                   , COALESCE (tmpPrice.Price, 0)                :: TFloat AS Price
                                   , CASE WHEN COALESCE (tmpGoodsCategory.Value, 0.0) <= COALESCE (tmpPrice.MCSValue, 0.0)
                                          THEN COALESCE (tmpPrice.MCSValue, 0.0)
                                          ELSE tmpGoodsCategory.Value
                                     END                                         :: TFloat AS MCSValue
                                   , COALESCE (tmpPrice.MCSValue_min, 0.0)       :: TFloat AS MCSValue_min
                                   , COALESCE (tmpPrice.isCloseMCS, FALSE)                 AS isCloseMCS
                              FROM tmpPrice
                                   FULL JOIN tmpGoodsCategory ON tmpGoodsCategory.GoodsId = tmpPrice.GoodsId
                                                             AND tmpGoodsCategory.UnitId  = tmpPrice.UnitId
                              WHERE COALESCE (tmpGoodsCategory.Value, 0) <> 0
                                 OR COALESCE (tmpPrice.MCSValue, 0) <> 0
                                 OR COALESCE (tmpPrice.Price, 0) <> 0
                             )
     -- 1. Результат: все остатки, НТЗ => получаем кол-ва автозаказа: от колонки Остаток отнять Данные по отложенным чекам - получится реальный остаток на точке
     INSERT INTO  _tmpRemains_all_Supplement (UnitId, GoodsId, Price, MCS, Layout, AmountRemains, AmountNotSend, AmountSalesDay, AmountSalesMonth, 
                                              MinExpirationDate, isCloseMCS, SupplementMin)
        SELECT tmpObject_Price.UnitId
             , tmpObject_Price.GoodsId
             , tmpObject_Price.Price
             , tmpObject_Price.MCSValue
             
             , _tmpGoodsLayout_SUN_Supplement.Layout

             /*, CASE WHEN _tmpGoodsLayout_SUN_Supplement.isNotMoveRemainder6 = TRUE
                      OR (COALESCE (tmpRemains.Amount, 0) - COALESCE (_tmpGoods_Sun_exception_Supplement.Amount, 0) - 
                          COALESCE(tmpRemains.Amount6Month, 0))  > _tmpGoodsLayout_SUN_Supplement.Layout
                      OR COALESCE(tmpRemains.Amount6Month, 0) = 0
                    THEN _tmpGoodsLayout_SUN_Supplement.Layout
                    WHEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (_tmpGoods_Sun_exception_Supplement.Amount, 0) - 
                                                            COALESCE(tmpRemains.Amount6Month, 0)) >= 0
                    THEN (COALESCE (tmpRemains.Amount, 0) - COALESCE (_tmpGoods_Sun_exception_Supplement.Amount, 0) - 
                                                            COALESCE(tmpRemains.Amount6Month, 0)) 
                    ELSE 0  END  AS Layout*/

               -- остаток
             , CASE WHEN COALESCE (tmpRemains.Amount - COALESCE (_tmpGoods_Sun_exception_Supplement.Amount, 0), 0) > 0
                    THEN COALESCE (tmpRemains.Amount - COALESCE (_tmpGoods_Sun_exception_Supplement.Amount, 0), 0) ELSE 0 END AS AmountRemains
             , COALESCE (tmpRemains.AmountNotSend, 0)                                                                         AS AmountNotSend
               -- реализация
             , COALESCE (tmpSalesDay.AmountSalesDay, 0)      AS AmountSalesDay
             , COALESCE (tmpSalesMonth.AmountSalesMonth, 0)  AS AmountSalesMonth
             , tmpRemains.MinExpirationDate
             , COALESCE (tmpObject_Price.isCloseMCS, FALSE)  AS isCloseMCS
             , CASE WHEN Object_Unit.ValueData LIKE 'Апт. пункт %' THEN _tmpGoods_SUN_Supplement.SupplementMinPP ELSE _tmpGoods_SUN_Supplement.SupplementMin END
             
        FROM tmpPrice AS tmpObject_Price

             LEFT JOIN tmpRemains AS tmpRemains
                                  ON tmpRemains.UnitId  = tmpObject_Price.UnitId
                                 AND tmpRemains.GoodsId = tmpObject_Price.GoodsId
                                 
             LEFT JOIN tmpSalesDay AS tmpSalesDay
                                   ON tmpSalesDay.UnitId  = tmpObject_Price.UnitId
                                  AND tmpSalesDay.GoodsId = tmpObject_Price.GoodsId

             LEFT JOIN tmpSalesMonth AS tmpSalesMonth
                                     ON tmpSalesMonth.UnitId  = tmpObject_Price.UnitId
                                    AND tmpSalesMonth.GoodsId = tmpObject_Price.GoodsId

             LEFT JOIN _tmpGoods_Sun_exception_Supplement ON _tmpGoods_Sun_exception_Supplement.UnitId  = tmpObject_Price.UnitId
                                              AND _tmpGoods_Sun_exception_Supplement.GoodsId = tmpObject_Price.GoodsId
                                              
             LEFT JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId =  tmpObject_Price.GoodsId

             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id =  tmpObject_Price.UnitId

             LEFT JOIN _tmpGoodsLayout_SUN_Supplement ON _tmpGoodsLayout_SUN_Supplement.GoodsID = COALESCE(tmpRemains.GoodsId, tmpSalesDay.GoodsId)
                                                     AND _tmpGoodsLayout_SUN_Supplement.UnitId = COALESCE(tmpRemains.UnitId, tmpSalesDay.UnitId)
       ;
              
     
     IF EXISTS (SELECT 1
                FROM _tmpGoods_SUN_Supplement 
                WHERE _tmpGoods_SUN_Supplement.isSmudge = True
                  AND (COALESCE(_tmpGoods_SUN_Supplement.UnitOutId, 0) <> 0 OR
                       COALESCE(_tmpGoods_SUN_Supplement.UnitOut2Id, 0) <> 0))
     THEN

       UPDATE _tmpRemains_all_Supplement SET GiveAway = (SELECT FLOOR(SUM(tmpRemains.AmountRemains - tmpRemains.MCS
                                                            - CASE WHEN tmpRemains.AmountNotSend > 
                                                                       COALESCE(tmpRemains.Layout, 0) 
                                                                       + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) 
                                                                   THEN tmpRemains.AmountNotSend
                                                                   ELSE COALESCE(tmpRemains.Layout, 0) 
                                                                      + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) END))
                                                         FROM _tmpRemains_all_Supplement AS tmpRemains 
                                                         
                                                              LEFT JOIN _tmpGoods_PromoUnit_Supplement ON _tmpGoods_PromoUnit_Supplement.GoodsID = tmpRemains.GoodsId
                                                                                                      AND _tmpGoods_PromoUnit_Supplement.UnitId = tmpRemains.UnitId  
                                                                                                      
                                                         WHERE tmpRemains.GoodsId = _tmpRemains_all_Supplement.GoodsId
                                                           AND (tmpRemains.AmountRemains - COALESCE(tmpRemains.AmountNotSend, 0)) > 0
                                                           AND tmpRemains.UnitId = _tmpRemains_all_Supplement.UnitId)
       FROM (SELECT _tmpGoods_SUN_Supplement.GoodsId
                  , _tmpGoods_SUN_Supplement.UnitOutId
                  , _tmpGoods_SUN_Supplement.UnitOut2Id
             FROM _tmpGoods_SUN_Supplement 
             WHERE _tmpGoods_SUN_Supplement.isSmudge = True
               AND (COALESCE(_tmpGoods_SUN_Supplement.UnitOutId, 0) <> 0 OR
                    COALESCE(_tmpGoods_SUN_Supplement.UnitOut2Id, 0) <> 0)) AS _tmpGoods_SUN_Supplement 
       WHERE _tmpGoods_SUN_Supplement.GoodsId = _tmpRemains_all_Supplement.GoodsId
         AND (COALESCE(_tmpGoods_SUN_Supplement.UnitOutId, 0)  = _tmpRemains_all_Supplement.UnitId OR
              COALESCE(_tmpGoods_SUN_Supplement.UnitOut2Id, 0) = _tmpRemains_all_Supplement.UnitId);
                                                             
       
       UPDATE _tmpRemains_all_Supplement SET GiveAway = - CEIL((SELECT SUM(tmpRemains.AmountRemains 
                                                                           - COALESCE(tmpRemains.AmountNotSend, 0)) 
                                                                FROM _tmpRemains_all_Supplement AS tmpRemains
                                                                WHERE tmpRemains.GoodsId = _tmpRemains_all_Supplement.GoodsId
                                                                  AND (tmpRemains.AmountRemains - COALESCE(tmpRemains.AmountNotSend, 0)) > 0
                                                                  AND (tmpRemains.UnitId = COALESCE(_tmpGoods_SUN_Supplement.UnitOutId, 0) OR
                                                                       tmpRemains.UnitId = COALESCE(_tmpGoods_SUN_Supplement.UnitOut2Id, 0))) / 
                                                               (SELECT count(*) 
                                                                FROM _tmpRemains_all_Supplement AS Remains_all
                                                                WHERE Remains_all.GoodsId = _tmpRemains_all_Supplement.GoodsId
                                                                  AND Remains_all.UnitId <> COALESCE(_tmpGoods_SUN_Supplement.UnitOutId, 0)
                                                                  AND Remains_all.UnitId <> COALESCE(_tmpGoods_SUN_Supplement.UnitOut2Id, 0)))
       FROM (SELECT _tmpGoods_SUN_Supplement.GoodsId
                  , _tmpGoods_SUN_Supplement.UnitOutId
                  , _tmpGoods_SUN_Supplement.UnitOut2Id
             FROM _tmpGoods_SUN_Supplement 
             WHERE _tmpGoods_SUN_Supplement.isSmudge = True
               AND (COALESCE(_tmpGoods_SUN_Supplement.UnitOutId, 0) <> 0 OR
                    COALESCE(_tmpGoods_SUN_Supplement.UnitOut2Id, 0) <> 0)) AS _tmpGoods_SUN_Supplement 
       WHERE _tmpGoods_SUN_Supplement.GoodsId = _tmpRemains_all_Supplement.GoodsId
         AND COALESCE(_tmpGoods_SUN_Supplement.UnitOutId, 0)  <> _tmpRemains_all_Supplement.UnitId 
         AND COALESCE(_tmpGoods_SUN_Supplement.UnitOut2Id, 0) <> _tmpRemains_all_Supplement.UnitId;
     
     END IF;
       
/*     IF CURRENT_DATE <= '20.10.2021'
     THEN

       ---------
       UPDATE _tmpRemains_all_Supplement SET GiveAway = (SELECT FLOOR(SUM(Container.Amount)) FROM Container WHERE Container.ID in (26661170, 26987077))
       WHERE _tmpRemains_all_Supplement.UnitId = 9951517
         AND _tmpRemains_all_Supplement.GoodsId = 880570 ;
       
       UPDATE _tmpRemains_all_Supplement SET GiveAway = - CEIL((SELECT FLOOR(SUM(Container.Amount)) FROM Container WHERE Container.ID in (26661170, 26987077)) / 
                                                               (SELECT count(*) FROM _tmpRemains_all_Supplement
                                                                WHERE _tmpRemains_all_Supplement.UnitId <> 9951517
                                                                  AND _tmpRemains_all_Supplement.GoodsId = 880570 ))
       WHERE _tmpRemains_all_Supplement.UnitId <> 9951517
         AND _tmpRemains_all_Supplement.GoodsId = 880570 ;
         
        
       ---------
       UPDATE _tmpRemains_all_Supplement SET GiveAway = (SELECT FLOOR(SUM(Container.Amount)) FROM Container WHERE Container.ID in (28561767))
       WHERE _tmpRemains_all_Supplement.UnitId = 11152911
         AND _tmpRemains_all_Supplement.GoodsId = 2485 ;
       
       UPDATE _tmpRemains_all_Supplement SET GiveAway = - CEIL((SELECT FLOOR(SUM(Container.Amount)) FROM Container WHERE Container.ID in (28561767)) / 
                                                               (SELECT count(*) FROM _tmpRemains_all_Supplement
                                                                WHERE _tmpRemains_all_Supplement.UnitId <> 11152911
                                                                  AND _tmpRemains_all_Supplement.GoodsId = 2485 ))
       WHERE _tmpRemains_all_Supplement.UnitId <> 11152911
         AND _tmpRemains_all_Supplement.GoodsId = 2485 ;

       ---------
       UPDATE _tmpRemains_all_Supplement SET GiveAway = (SELECT FLOOR(SUM(Container.Amount)) FROM Container WHERE Container.ID in (28942901, 28958572))
       WHERE _tmpRemains_all_Supplement.UnitId = 8156016
         AND _tmpRemains_all_Supplement.GoodsId = 25516 ;
       
       UPDATE _tmpRemains_all_Supplement SET GiveAway = - CEIL((SELECT FLOOR(SUM(Container.Amount)) FROM Container WHERE Container.ID in (28942901, 28958572)) / 
                                                               (SELECT count(*) FROM _tmpRemains_all_Supplement
                                                                WHERE _tmpRemains_all_Supplement.UnitId <> 8156016
                                                                  AND _tmpRemains_all_Supplement.GoodsId = 25516 ))
       WHERE _tmpRemains_all_Supplement.UnitId <> 8156016
         AND _tmpRemains_all_Supplement.GoodsId = 25516 ;

     END IF;*/

     -- 2. все остатки, НТЗ, и коэф. товарного запаса
     --
     WITH tmpResult AS (SELECT _tmpRemains_all_Supplement.GoodsId                               AS GoodsId
                             , SUM(_tmpRemains_all_Supplement.MCS)                              AS MCS

                               -- остаток
                             , SUM(COALESCE (_tmpRemains_all_Supplement.AmountRemains, 0))      AS AmountRemains
                               -- реализация
                             , SUM(COALESCE (_tmpRemains_all_Supplement.AmountSalesDay, 0))     AS AmountSalesDay

                        FROM _tmpRemains_all_Supplement
                        GROUP BY _tmpRemains_all_Supplement.GoodsId
                        )
        , tmpUnit AS (SELECT max(_tmpUnit_SUN_Supplement.DeySupplSun1)  AS DeySupplSun1
                      FROM _tmpUnit_SUN_Supplement
                      )

     -- 2. Результат: все остатки, все остатки, НТЗ, и коэф. товарного запаса
     INSERT INTO  _tmpStockRatio_all_Supplement (GoodsId, MCS, AmountRemains, AmountSalesDay, AverageSales, StockRatio)
        SELECT tmpResult.GoodsId
             , tmpResult.MCS

               -- остаток
             , tmpResult.AmountRemains
               -- реализация
             , tmpResult.AmountSalesDay

             , CASE WHEN tmpResult.AmountSalesDay > 0
                    THEN (tmpResult.AmountRemains - tmpResult.MCS)/ tmpResult.AmountSalesDay
                    ELSE 0 END ::TFloat AS  AverageSales
             , CASE WHEN tmpResult.AmountSalesDay > 0
                    THEN (tmpResult.AmountRemains - tmpResult.MCS)/ tmpResult.AmountSalesDay * tmpUnit.DeySupplSun1
                    ELSE 0 END ::TFloat AS  StockRatio

        FROM tmpResult

             LEFT JOIN tmpUnit ON 1 = 1

       ;

     -- 2.1. Результат: все остатки, НТЗ => получаем кол-ва автозаказа: от колонки Остаток отнять Данные по отложенным чекам - получится реальный остаток на точке
     UPDATE _tmpRemains_all_Supplement SET AverageSalesMonth =(COALESCE (_tmpRemains_all_Supplement.AmountSalesMonth, 0) / extract('DAY' from CURRENT_DATE -
                                                              (CURRENT_DATE - (T1.MonthSupplSun1::TVarChar ||' MONTH') :: INTERVAL)))
                                         , Need = CASE WHEN _tmpRemains_all_Supplement.AmountSalesMonth = 0 THEN - _tmpRemains_all_Supplement.AmountRemains
                                                  ELSE (_tmpRemains_all_Supplement.AmountSalesMonth / extract('DAY' from CURRENT_DATE -
                                                       (CURRENT_DATE - (T1.MonthSupplSun1::TVarChar ||' MONTH') :: INTERVAL))) *
                                                       T1.StockRatio END
                                         , AmountUse = 0
     FROM (SELECT _tmpStockRatio_all_Supplement.GoodsId
                , _tmpUnit_SUN_Supplement.UnitId
                , _tmpStockRatio_all_Supplement.StockRatio
                , _tmpUnit_SUN_Supplement.MonthSupplSun1
           FROM _tmpStockRatio_all_Supplement
                LEFT JOIN _tmpUnit_SUN_Supplement ON 1 = 1
                LEFT JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsId = _tmpStockRatio_all_Supplement.GoodsId
                ) AS T1
     WHERE _tmpRemains_all_Supplement.GoodsId = T1.GoodsId
       AND _tmpRemains_all_Supplement.UnitId = T1.UnitId;
       
     -- 2.2. Подправили места по размазке не менее
     IF EXISTS(SELECT 1 FROM _tmpRemains_all_Supplement WHERE COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) > 0)
     THEN
       UPDATE _tmpRemains_all_Supplement SET Need = ceil(COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) + _tmpRemains_all_Supplement.AmountRemains)
       WHERE COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) > 0
         AND _tmpRemains_all_Supplement.AmountRemains < COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0)
         AND _tmpRemains_all_Supplement.Need < ceil(COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) + _tmpRemains_all_Supplement.AmountRemains)
         AND _tmpRemains_all_Supplement.UnitId IN (SELECT _tmpUnit_SUN_Supplement.UnitId FROM _tmpUnit_SUN_Supplement WHERE _tmpUnit_SUN_Supplement.isSUN_Supplement_in = TRUE);

        UPDATE _tmpRemains_all_Supplement SET Need = CASE WHEN Need - T1.Amount < 0 THEN 0 ELSE Need - T1.Amount END
        FROM (WITH tmpNeedSum AS (SELECT _tmpRemains_all_Supplement.GoodsId
                                       , SUM(_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains)  AS NeedSum
                                  FROM _tmpRemains_all_Supplement
                                  WHERE _tmpRemains_all_Supplement.GoodsId in (SELECT DISTINCT _tmpRemains_all_Supplement.GoodsId 
                                                                               FROM _tmpRemains_all_Supplement 
                                                                               WHERE COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) > 0)
                                  GROUP BY _tmpRemains_all_Supplement.GoodsId
                                  HAVING SUM(_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains) > 0)
                 , tmpNeedCount AS (SELECT _tmpRemains_all_Supplement.GoodsId
                                         , COUNT (*)                             AS CountNeed 
                                    FROM _tmpRemains_all_Supplement
                                    WHERE COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) > 0
                                      AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) * 1.2 < (_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains)
                                    GROUP BY _tmpRemains_all_Supplement.GoodsId
                                    HAVING COUNT (*) > 0
                                    )
   
              SELECT _tmpRemains_all_Supplement.GoodsId
                   , _tmpRemains_all_Supplement.UnitId
                   , ceil(tmpNeedSum.NeedSum / tmpNeedCount.CountNeed) AS Amount
              FROM _tmpRemains_all_Supplement
                   INNER JOIN tmpNeedSum ON tmpNeedSum.GoodsId = _tmpRemains_all_Supplement.GoodsId
                   INNER JOIN tmpNeedCount ON tmpNeedCount.GoodsId = _tmpRemains_all_Supplement.GoodsId
              WHERE COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) > 0
                AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) <= (_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains) - ceil(tmpNeedSum.NeedSum / tmpNeedCount.CountNeed)
              ) AS T1
        WHERE _tmpRemains_all_Supplement.GoodsId = T1.GoodsId
          AND _tmpRemains_all_Supplement.UnitId = T1.UnitId
          AND _tmpRemains_all_Supplement.Need > 0;

     END IF;
              

/* raise notice 'Value 05: % %', 
    (SELECT Count(*) FROM _tmpRemains_all_Supplement WHERE COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) < 0), 
    (SELECT Count(*) FROM _tmpRemains_all_Supplement WHERE COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) = 50);*/
             
     -- 2.2. Подправили места где передача после округление больше чем остаток
     UPDATE _tmpRemains_all_Supplement SET Need = - floor(_tmpRemains_all_Supplement.AmountRemains)
     WHERE (_tmpRemains_all_Supplement.AmountRemains + _tmpRemains_all_Supplement.Need) < 0;

     /*raise notice 'Value 05: %',
                 (SELECT COUNT(*)
                  FROM _tmpRemains_all_Supplement WHERE _tmpRemains_all_Supplement.GoodsId = 35755 AND _tmpRemains_all_Supplement.GiveAway < 0);*/
                  
/*     raise notice 'Value 05: %',
                 (SELECT COALESCE(_tmpRemains_all_Supplement.AmountRemains, 0)::TVArChar||'  '||
                         COALESCE(_tmpRemains_all_Supplement.Need, 0)::TVArChar||'  '||
                         COALESCE(_tmpRemains_all_Supplement.GiveAway, 0)::TVArChar 
                  FROM _tmpRemains_all_Supplement WHERE _tmpRemains_all_Supplement.GoodsId = 5215530 AND _tmpRemains_all_Supplement.UnitId = 9951517);*/

     -- 3. распределяем
     --
     -- курсор1 - все что можно распределить
     OPEN curPartion_next FOR
        SELECT _tmpRemains_all_Supplement.UnitId
             , _tmpRemains_all_Supplement.GoodsId
             , CASE WHEN COALESCE (GiveAway, 0) > 0 THEN COALESCE (GiveAway, 0) ELSE 
               - CASE WHEN COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0) = 0 THEN
                 CASE WHEN (_tmpRemains_all_Supplement.AmountSalesMonth = 0 OR _tmpUnit_SUN_Supplement.isSUN_Supplement_Priority = True) AND 
                           COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) <= 0
                      THEN CASE WHEN TRUNC(_tmpRemains_all_Supplement.AmountRemains - COALESCE(_tmpRemains_all_Supplement.Layout, 0)) > 0 
                                THEN - TRUNC(_tmpRemains_all_Supplement.AmountRemains - COALESCE(_tmpRemains_all_Supplement.Layout, 0))
                                ELSE 0 END
                      ELSE TRUNC(_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains 
                                                            + CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > 
                                                                       COALESCE(_tmpRemains_all_Supplement.Layout, 0) 
                                                                       + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) 
                                                                   THEN _tmpRemains_all_Supplement.AmountNotSend
                                                                   ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) 
                                                                      + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) END)
                      END
                 ELSE
                 TRUNC (CASE WHEN (_tmpRemains_all_Supplement.AmountSalesMonth = 0 OR _tmpUnit_SUN_Supplement.isSUN_Supplement_Priority = True) AND 
                           COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) <= 0
                             THEN CASE WHEN TRUNC(_tmpRemains_all_Supplement.AmountRemains - COALESCE(_tmpRemains_all_Supplement.Layout, 0)) > 0 
                                       THEN - TRUNC(_tmpRemains_all_Supplement.AmountRemains - COALESCE(_tmpRemains_all_Supplement.Layout, 0))
                                       ELSE 0 END
                             ELSE FLOOR(_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains 
                                                                   + CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > 
                                                                              COALESCE(_tmpRemains_all_Supplement.Layout, 0) 
                                                                              + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) 
                                                                          THEN _tmpRemains_all_Supplement.AmountNotSend
                                                                          ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) 
                                                                             + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) END)
                             END / COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0)) * COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0)
                 END END AS Need
             , COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0)
       FROM _tmpRemains_all_Supplement

            LEFT JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsID = _tmpRemains_all_Supplement.GoodsId

            LEFT JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = _tmpRemains_all_Supplement.UnitId
            
            LEFT JOIN _tmpGoods_PromoUnit_Supplement ON _tmpGoods_PromoUnit_Supplement.GoodsID = _tmpRemains_all_Supplement.GoodsId
                                                    AND _tmpGoods_PromoUnit_Supplement.UnitId = _tmpRemains_all_Supplement.UnitId  
                                                                            
            -- найдем дисконтній товар
            LEFT JOIN _tmpGoods_DiscountExternal_Supplement AS _tmpGoods_DiscountExternal
                                                            ON _tmpGoods_DiscountExternal.UnitId  = _tmpRemains_all_Supplement.UnitId
                                                           AND _tmpGoods_DiscountExternal.GoodsId = _tmpRemains_all_Supplement.GoodsId

       WHERE CASE WHEN COALESCE (GiveAway, 0) > 0 THEN COALESCE (GiveAway, 0) ELSE 
               - CASE WHEN COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0) = 0 THEN
                 CASE WHEN (_tmpRemains_all_Supplement.AmountSalesMonth = 0 OR _tmpUnit_SUN_Supplement.isSUN_Supplement_Priority = True) AND 
                           COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) <= 0
                      THEN CASE WHEN TRUNC(_tmpRemains_all_Supplement.AmountRemains - COALESCE(_tmpRemains_all_Supplement.Layout, 0)) > 0 
                                THEN - TRUNC(_tmpRemains_all_Supplement.AmountRemains - COALESCE(_tmpRemains_all_Supplement.Layout, 0))
                                ELSE 0 END
                      ELSE TRUNC(_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains 
                                                            + CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > 
                                                                       COALESCE(_tmpRemains_all_Supplement.Layout, 0) 
                                                                       + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) 
                                                                   THEN _tmpRemains_all_Supplement.AmountNotSend
                                                                   ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) 
                                                                      + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) END)
                      END
                 ELSE
                 TRUNC (CASE WHEN (_tmpRemains_all_Supplement.AmountSalesMonth = 0 OR _tmpUnit_SUN_Supplement.isSUN_Supplement_Priority = True) AND 
                                   COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) <= 0
                             THEN CASE WHEN TRUNC(_tmpRemains_all_Supplement.AmountRemains - COALESCE(_tmpRemains_all_Supplement.Layout, 0)) > 0 
                                       THEN - TRUNC(_tmpRemains_all_Supplement.AmountRemains - COALESCE(_tmpRemains_all_Supplement.Layout, 0))
                                       ELSE 0 END
                             ELSE FLOOR(_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains 
                                                                   + CASE WHEN _tmpRemains_all_Supplement.AmountNotSend > 
                                                                              COALESCE(_tmpRemains_all_Supplement.Layout, 0) 
                                                                              + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) 
                                                                          THEN _tmpRemains_all_Supplement.AmountNotSend
                                                                          ELSE COALESCE(_tmpRemains_all_Supplement.Layout, 0) 
                                                                             + COALESCE(_tmpGoods_PromoUnit_Supplement.Amount, 0) END)
                             END / COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0)) * COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0)
                 END END > 0
                 
         AND _tmpUnit_SUN_Supplement.isSUN_Supplement_out = True
         AND (COALESCE(_tmpGoods_SUN_Supplement.UnitOutId, 0) = 0 AND COALESCE(_tmpGoods_SUN_Supplement.UnitOut2Id, 0) = 0 
           OR COALESCE(_tmpGoods_SUN_Supplement.UnitOutId, 0) = _tmpRemains_all_Supplement.UnitId 
           OR COALESCE(_tmpGoods_SUN_Supplement.UnitOut2Id, 0) = _tmpRemains_all_Supplement.UnitId)
         AND COALESCE(_tmpGoods_DiscountExternal.GoodsId, 0) = 0
       ORDER BY _tmpUnit_SUN_Supplement.isSUN_Supplement_Priority DESC
              , CASE WHEN _tmpRemains_all_Supplement.AmountSalesMonth = 0
                      THEN - _tmpRemains_all_Supplement.AmountRemains
                      ELSE (_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains)::Integer
                      END
              , _tmpRemains_all_Supplement.UnitId
              , _tmpRemains_all_Supplement.GoodsId
       ;
     -- начало цикла по курсору1
     LOOP
         -- данные по курсору1
         FETCH curPartion_next INTO vbUnitId_from, vbGoodsId, vbSurplus, vbKoeffSUN;
         -- если данные закончились, тогда выход
         IF NOT FOUND THEN EXIT; END IF;

/*             IF vbGoodsId = 5215530
             THEN
               raise notice 'Value 05: % % % % % % %', vbUnitId_from, vbUnitId_to, vbGoodsId, vbNeed, vbSurplus, CASE WHEN vbSurplus > vbNeed THEN vbNeed ELSE vbSurplus END,
                 (SELECT _tmpRemains_all_Supplement.AmountRemains::TVArChar||'  '||_tmpRemains_all_Supplement.Need::TVArChar||'  '||_tmpRemains_all_Supplement.GiveAway::TVArChar 
                  FROM _tmpRemains_all_Supplement WHERE _tmpRemains_all_Supplement.UnitId = vbUnitId_from AND _tmpRemains_all_Supplement.GoodsId = vbGoodsId);
             END IF;
*/
         -- курсор2. - Потребность для vbGoodsId
         OPEN curResult_next FOR
             SELECT _tmpRemains_all_Supplement.UnitId
                  , FLOOR(CASE WHEN COALESCE (GiveAway, 0) < 0 THEN - COALESCE (GiveAway, 0) ELSE 
                          CASE WHEN COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0) = 0 THEN
                          CASE WHEN _tmpRemains_all_Supplement.AmountSalesMonth = 0 AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) <= 0
                               THEN - _tmpRemains_all_Supplement.AmountRemains
                               ELSE (_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains)::Integer
                               END  - _tmpRemains_all_Supplement.AmountUse
                          ELSE
                          FLOOR ((CASE WHEN _tmpRemains_all_Supplement.AmountSalesMonth = 0 AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0)<= 0
                                       THEN - _tmpRemains_all_Supplement.AmountRemains
                                       ELSE (_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains)::Integer
                                       END  - _tmpRemains_all_Supplement.AmountUse) / COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0)) * COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0)

                          END END)
             FROM _tmpRemains_all_Supplement

                  LEFT JOIN _tmpGoods_SUN_Supplement ON _tmpGoods_SUN_Supplement.GoodsID = _tmpRemains_all_Supplement.GoodsId

                  LEFT JOIN _tmpUnit_SUN_Supplement ON _tmpUnit_SUN_Supplement.UnitId = _tmpRemains_all_Supplement.UnitId

                  -- найдем дисконтній товар
                  LEFT JOIN _tmpGoods_DiscountExternal_Supplement AS _tmpGoods_DiscountExternal
                                                                 ON _tmpGoods_DiscountExternal.UnitId  = _tmpRemains_all_Supplement.UnitId
                                                                AND _tmpGoods_DiscountExternal.GoodsId = _tmpRemains_all_Supplement.GoodsId

                  -- отбросили !!исключения!!
                  LEFT JOIN _tmpUnit_SunExclusion_Supplement ON _tmpUnit_SunExclusion_Supplement.UnitId_from = vbUnitId_from
                                                            AND _tmpUnit_SunExclusion_Supplement.UnitId_to   = _tmpRemains_all_Supplement.UnitId

                  -- отключена Получать товар который отдавался
                  LEFT JOIN _tmpGoods_Sun_exception_Supplement AS _tmpGoods_Sun_exception_Supplement
                                                               ON _tmpGoods_Sun_exception_Supplement.UnitId  = _tmpRemains_all_Supplement.UnitId
                                                              AND _tmpGoods_Sun_exception_Supplement.GoodsId = _tmpRemains_all_Supplement.GoodsId

             WHERE FLOOR(CASE WHEN COALESCE (GiveAway, 0) < 0 THEN - COALESCE (GiveAway, 0) ELSE 
                              CASE WHEN COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0) = 0 THEN
                              CASE WHEN _tmpRemains_all_Supplement.AmountSalesMonth = 0 AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) <= 0
                                   THEN - _tmpRemains_all_Supplement.AmountRemains
                                   ELSE (_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains)::Integer
                                   END  - _tmpRemains_all_Supplement.AmountUse
                              ELSE
                              FLOOR ((CASE WHEN _tmpRemains_all_Supplement.AmountSalesMonth = 0 AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) <= 0
                                           THEN - _tmpRemains_all_Supplement.AmountRemains
                                           ELSE (_tmpRemains_all_Supplement.Need - _tmpRemains_all_Supplement.AmountRemains)::Integer
                                           END  - _tmpRemains_all_Supplement.AmountUse) / COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0)) * COALESCE (_tmpGoods_SUN_Supplement.KoeffSUN, 0)

                              END END) > 0
               AND _tmpUnit_SUN_Supplement.isSUN_Supplement_Priority = False
               AND _tmpRemains_all_Supplement.UnitId <> vbUnitId_from
               AND _tmpRemains_all_Supplement.GoodsId = vbGoodsId
               AND _tmpUnit_SUN_Supplement.isSUN_Supplement_in = True
               AND (COALESCE(_tmpGoods_SUN_Supplement.UnitOutId, 0) = 0 AND COALESCE(_tmpGoods_SUN_Supplement.UnitOut2Id, 0) = 0 
                 OR COALESCE(_tmpGoods_SUN_Supplement.UnitOutId, 0) <> _tmpRemains_all_Supplement.UnitId 
                 AND COALESCE(_tmpGoods_SUN_Supplement.UnitOut2Id, 0) <> _tmpRemains_all_Supplement.UnitId)
               AND COALESCE(_tmpGoods_DiscountExternal.GoodsId, 0) = 0
               AND COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) >= 0
               AND _tmpUnit_SunExclusion_Supplement.UnitId_to IS NULL
               AND  COALESCE(_tmpGoods_Sun_exception_Supplement.Amount, 0) = 0
             ORDER BY CASE WHEN COALESCE(_tmpRemains_all_Supplement.SupplementMin, 0) = 0 THEN 1000000 
                           ELSE (CASE WHEN _tmpRemains_all_Supplement.AmountSalesMonth = 0
                                 THEN - _tmpRemains_all_Supplement.AmountRemains
                                 ELSE (_tmpRemains_all_Supplement.Need  -_tmpRemains_all_Supplement.AmountRemains)::Integer
                                 END - _tmpRemains_all_Supplement.AmountUse) END
                    , (CASE WHEN _tmpRemains_all_Supplement.AmountSalesMonth = 0
                            THEN - _tmpRemains_all_Supplement.AmountRemains
                            ELSE (_tmpRemains_all_Supplement.Need  -_tmpRemains_all_Supplement.AmountRemains)::Integer
                            END - _tmpRemains_all_Supplement.AmountUse) DESC
                    , _tmpRemains_all_Supplement.UnitId
                    , _tmpRemains_all_Supplement.GoodsId;
         -- начало цикла по курсору2 - остаток сроковых - под него надо найти Автозаказ
         LOOP
             -- данные по Автозаказ
             FETCH curResult_next INTO vbUnitId_to, vbNeed;
             -- если данные закончились, или все кол-во найдено тогда выход
             IF NOT FOUND OR (vbSurplus) <= 0 THEN EXIT; END IF;

             -- если данные закончились, или все кол-во найдено тогда выход
             IF NOT FOUND OR FLOOR (vbSurplus) <= 0 THEN EXIT; END IF;
             

/*             IF vbGoodsId = 17140
             THEN
               raise notice 'Value 05: % % % % % % %', vbUnitId_from, vbUnitId_to, vbGoodsId, vbNeed, vbSurplus, CASE WHEN vbSurplus > vbNeed THEN vbNeed ELSE vbSurplus END,
                 (SELECT _tmpRemains_all_Supplement.AmountRemains::TVArChar||'  '||_tmpRemains_all_Supplement.Need::TVArChar||'  '||_tmpRemains_all_Supplement.GiveAway::TVArChar 
                  FROM _tmpRemains_all_Supplement WHERE _tmpRemains_all_Supplement.UnitId = vbUnitId_from AND _tmpRemains_all_Supplement.GoodsId = vbGoodsId);
             END IF;
*/
             INSERT INTO _tmpResult_Supplement (UnitId_from, UnitId_to, GoodsId, Amount)
               VALUES (vbUnitId_from, vbUnitId_to, vbGoodsId, CASE WHEN FLOOR (vbSurplus) > vbNeed THEN vbNeed ELSE FLOOR (vbSurplus) END);

             UPDATE _tmpRemains_all_Supplement SET AmountUse = AmountUse + CASE WHEN FLOOR (vbSurplus) > vbNeed THEN vbNeed ELSE FLOOR (vbSurplus) END
             WHERE _tmpRemains_all_Supplement.UnitId = vbUnitId_to
               AND _tmpRemains_all_Supplement.GoodsId = vbGoodsId;

             vbSurplus := vbSurplus - CASE WHEN FLOOR (vbSurplus) > vbNeed THEN vbNeed ELSE FLOOR (vbSurplus) END;

         END LOOP; -- финиш цикла по курсору2
         CLOSE curResult_next; -- закрыли курсор2.

     END LOOP; -- финиш цикла по курсору1
     CLOSE curPartion_next; -- закрыли курсор1



     -- Результат
     RETURN QUERY
       SELECT Object_Goods.Id                            AS GoodsId
            , Object_Goods_Main.ObjectCode               AS GoodsCode
            , Object_Goods_Main.Name                     AS GoodsName
            , Object_Goods_Main.isClose                  AS isClose

            , Object_Unit_From.Id                        AS UnitId_From
            , Object_Unit_From.ValueData                 AS UnitName_From

            , Object_Unit_To.Id                          AS UnitId_To
            , Object_Unit_To.ValueData                   AS UnitName_To

            , _tmpResult_Supplement.Amount               AS Amount

            , tmpRemains_all_From.MinExpirationDate

            , _tmpStockRatio_all_Supplement.MCS
            , _tmpStockRatio_all_Supplement.AmountRemains
            , _tmpStockRatio_all_Supplement.AmountSalesDay
            , _tmpStockRatio_all_Supplement.AverageSales
            , _tmpStockRatio_all_Supplement.StockRatio

            , tmpRemains_all_From.MCS                    AS MCS_From
            , _tmpGoodsLayout_SUN_Supplement.Layout      AS Layout_From
            , _tmpGoods_PromoUnit_Supplement.Amount      AS PromoUnit_From
            
            , tmpRemains_all_From.Price                  AS Price_From
            , tmpRemains_all_From.isCloseMCS             AS isCloseMCS_From
            , tmpRemains_all_From.AmountRemains          AS AmountRemains_From
            , tmpRemains_all_From.AmountSalesDay         AS AmountSalesDay_From
            , tmpRemains_all_From.AmountSalesMonth       AS AmountSalesMonth_From

            , tmpRemains_all_From.AverageSalesMonth      AS AverageSalesMonth_From
            , tmpRemains_all_From.Need                   AS Surplus_From
            , CASE WHEN tmpRemains_all_From.AmountSalesMonth = 0
                   THEN - tmpRemains_all_From.AmountRemains
                   ELSE (tmpRemains_all_From.Need -tmpRemains_all_From.AmountRemains)::Integer
              END::TFloat                                       AS Delta_From

            , tmpRemains_all_To.MCS                      AS MCS_To
            , tmpRemains_all_To.Price                    AS Price_To
            , tmpRemains_all_To.isCloseMCS               AS isCloseMCS_To
            , tmpRemains_all_To.AmountRemains            AS AmountRemains_To
            , tmpRemains_all_To.AmountSalesDay           AS AmountSalesDay_To
            , tmpRemains_all_To.AmountSalesMonth         AS AmountSalesMonth_To

            , tmpRemains_all_To.AverageSalesMonth        AS AverageSalesMonth_To
            , tmpRemains_all_To.Need                     AS Surplus_To
            , CASE WHEN tmpRemains_all_To.AmountSalesMonth = 0
                   THEN - tmpRemains_all_To.AmountRemains
                   ELSE (tmpRemains_all_To.Need -tmpRemains_all_To.AmountRemains)::Integer
              END::TFloat                                       AS Delta_To
            , tmpRemains_all_To.AmountUse                       AS AmountUse_To

            , Movement_Layout.InvNumber                  AS InvNumberLayout
            , Object_Layout.ValueData                    AS LayoutName

       FROM _tmpResult_Supplement

            INNER JOIN _tmpStockRatio_all_Supplement ON _tmpStockRatio_all_Supplement.GoodsId = _tmpResult_Supplement.GoodsId

            LEFT JOIN _tmpRemains_all_Supplement AS tmpRemains_all_From
                                                 ON tmpRemains_all_From.UnitId  = _tmpResult_Supplement.UnitId_from
                                                AND tmpRemains_all_From.GoodsId = _tmpResult_Supplement.GoodsId
            LEFT JOIN Object AS Object_Unit_From  ON Object_Unit_From.Id  = tmpRemains_all_From.UnitId


            LEFT JOIN _tmpRemains_all_Supplement AS tmpRemains_all_To
                                                 ON tmpRemains_all_To.UnitId  = _tmpResult_Supplement.UnitId_to
                                                AND tmpRemains_all_To.GoodsId = _tmpResult_Supplement.GoodsId
            LEFT JOIN Object AS Object_Unit_To  ON Object_Unit_To.Id  = tmpRemains_all_To.UnitId

            LEFT JOIN _tmpGoodsLayout_SUN_Supplement ON _tmpGoodsLayout_SUN_Supplement.GoodsID = _tmpResult_Supplement.GoodsId
                                                    AND _tmpGoodsLayout_SUN_Supplement.UnitId = _tmpResult_Supplement.UnitId_from

            LEFT JOIN _tmpGoods_PromoUnit_Supplement ON _tmpGoods_PromoUnit_Supplement.GoodsID = _tmpResult_Supplement.GoodsId
                                                    AND _tmpGoods_PromoUnit_Supplement.UnitId = _tmpResult_Supplement.UnitId_from 

            LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = tmpRemains_all_To.GoodsId
            LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

            LEFT JOIN Movement AS Movement_Layout ON Movement_Layout.Id = _tmpGoodsLayout_SUN_Supplement.MovementLayoutId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_Layout
                                         ON MovementLinkObject_Layout.MovementId = Movement_Layout.Id
                                        AND MovementLinkObject_Layout.DescId = zc_MovementLinkObject_Layout()
            LEFT JOIN Object AS Object_Layout ON Object_Layout.Id = MovementLinkObject_Layout.ObjectId
            
       ORDER BY Object_Goods.Id
              , Object_Unit_From.ValueData
              , Object_Unit_To.ValueData
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий 0.В.
 10.06.20                                                     *
*/

-- select * from gpReport_Movement_Send_RemainsSun_Supplement(inOperDate := ('16.11.2021')::TDateTime ,  inSession := '3');

SELECT * FROM lpInsert_Movement_Send_RemainsSun_Supplement (inOperDate:= CURRENT_DATE + INTERVAL '4 DAY', inDriverId:= 0, inUserId:= 3);