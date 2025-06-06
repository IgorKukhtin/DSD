-- Function: gpReport_ImplementationPlanEmployeeCash()

DROP FUNCTION IF EXISTS gpReport_ImplementationPlanEmployeeCash (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ImplementationPlanEmployeeCash(
    IN inStartDate     TDateTime , -- Дата в месяце
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE cur1 refcursor;
   DECLARE cur2 refcursor;
   DECLARE cur3 refcursor;
   DECLARE cur4 refcursor;
   DECLARE cur5 refcursor;
   DECLARE vbDateStart TDateTime;
   DECLARE vbDateEnd TDateTime;
   DECLARE vbQueryText Text;
   DECLARE curUnit CURSOR FOR SELECT UnitID FROM tmpImplementation GROUP BY UnitCategoryId, UnitID ORDER BY UnitCategoryId, UnitID;
   DECLARE vbUnitID Integer;
   DECLARE vbUnitCalck Integer;
   DECLARE vbUnitCategoryCode Integer;
   DECLARE vbUnitCategoryId Integer;
   DECLARE vbFixedPercent TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

    vbDateStart := date_trunc('month', inStartDate);
    vbDateEnd := date_trunc('month', vbDateStart + INTERVAL '1 month');
    
    IF (SELECT count(*)
        FROM Movement AS Movement_PromoUnit
        WHERE Movement_PromoUnit.StatusId = zc_Enum_Status_Complete()
          AND Movement_PromoUnit.DescId = zc_Movement_PromoUnit()
          AND Movement_PromoUnit.OperDate >= vbDateStart
          AND Movement_PromoUnit.OperDate < vbDateEnd) = 1 
    THEN
      SELECT MovementLinkObject_UnitCategory.ObjectId          AS UnitCategoryId
      INTO vbUnitCategoryId
      FROM Movement AS Movement_PromoUnit

           INNER JOIN MovementLinkObject AS MovementLinkObject_UnitCategory
                                         ON MovementLinkObject_UnitCategory.MovementId = Movement_PromoUnit.Id
                                        AND MovementLinkObject_UnitCategory.DescId = zc_MovementLinkObject_UnitCategory()

      WHERE Movement_PromoUnit.StatusId = zc_Enum_Status_Complete()
        AND Movement_PromoUnit.DescId = zc_Movement_PromoUnit()
        AND Movement_PromoUnit.OperDate >= vbDateStart
        AND Movement_PromoUnit.OperDate < vbDateEnd;
    ELSE
    
      vbUnitCategoryId := Null;
    END IF;
    
    vbUserId := lpGetUserBySession (inSession);
    
    IF inSession = '3'
    THEN
      vbUserId := 16456639;
    END IF;
    
      -- Мовементы по сотруднику
      -- Мовементы по сотруднику
    CREATE TEMP TABLE tmpMovement (
            MovementID         Integer,

            OperDate           TDateTime,
            UnitID             Integer

      ) ON COMMIT DROP;

      -- Добовляем простые продажи
    WITH tmpMovement AS (SELECT Movement.ID                                      AS ID
                              , date_trunc('day', Movement.OperDate)             AS OperDate
                              , MovementLinkObject_Unit.ObjectId                 AS UnitId
                         FROM Movement

                               INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()


                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                                            ON MovementLinkObject_Insert.MovementId = Movement.Id
                                                           AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_UserConfirmedKind
                                                            ON MovementLinkObject_UserConfirmedKind.MovementId = Movement.Id
                                                           AND MovementLinkObject_UserConfirmedKind.DescId = zc_MovementLinkObject_UserConfirmedKind()

                          WHERE Movement.OperDate >= vbDateStart
                            AND Movement.OperDate < vbDateEnd
                            AND COALESCE(MovementLinkObject_Insert.ObjectId, MovementLinkObject_UserConfirmedKind.ObjectId) = vbUserId
                            AND Movement.DescId = zc_Movement_Check()
                            AND Movement.StatusId = zc_Enum_Status_Complete())
        
    INSERT INTO tmpMovement
    SELECT
           Movement.ID                                      AS ID
         , Movement.OperDate                                AS OperDate
         , Movement.UnitId                                  AS UnitId
    FROM tmpMovement AS Movement;
    
    ANALYSE tmpMovement;
    
    IF NOT EXISTS(SELECT * FROM tmpMovement)
    THEN
         RAISE EXCEPTION 'По вам ненайдены чеки.';
    END IF;

    CREATE TEMP TABLE tmpImplementation (
             UnitCategoryId Integer,
             UnitCategoryName TVarChar,
             UnitID Integer,
             UnitName TVarChar,
             GroupName TVarChar,
             GoodsId Integer,
             GoodsCode Integer,
             GoodsName TVarChar,
             Amount TFloat,
             Price TFloat,
             Koeff TFloat,

             AmountPlan TFloat,
             AmountPlanMax TFloat,
             isFixedPercent Boolean,
             AddBonusPercent TFloat
      ) ON COMMIT DROP;


    IF vbDateStart >= '01.04.2022' --AND vbDateStart <= '01.05.2022'
       AND (SELECT count(*)
            FROM Movement AS Movement_PromoUnit
            WHERE Movement_PromoUnit.StatusId = zc_Enum_Status_Complete()
              AND Movement_PromoUnit.DescId = zc_Movement_PromoUnit()
              AND Movement_PromoUnit.OperDate >= vbDateStart
              AND Movement_PromoUnit.OperDate < vbDateEnd) = 1
    THEN
      WITH tmpMov AS (SELECT Movement.UnitId  
                           , COUNT(*)           AS CountUnit
                      FROM tmpMovement AS Movement
                      GROUP BY Movement.UnitId)
                      
      SELECT tmpMov.UnitId
      INTO vbUnitId
      FROM tmpMov
      ORDER BY tmpMov.CountUnit DESC
      LIMIT 1;
    
      -- Заполняем данные по продажам
      INSERT INTO tmpImplementation
        WITH tmpPromoUnit AS (SELECT MovementLinkObject_UnitCategory.ObjectId            AS UnitCategoryId
                                   , MI_PromoUnit.ObjectId                               AS GoodsId
                                   , MI_PromoUnit.Amount                                 AS AmountPlan
                                   , MIFloat_AmountPlanMax.ValueData::TFloat             AS AmountPlanMax
                                   , MIFloat_Price.ValueData::TFloat                     AS Price
                                   , MIFloat_Koeff.ValueData::TFloat                     AS Koeff
                                   , COALESCE (MIBoolean_FixedPercent.ValueData, FALSE)  AS isFixedPercent
                                   , MIFloat_AddBonusPercent.ValueData::TFloat           AS AddBonusPercent
                              FROM Movement AS Movement_PromoUnit

                                   INNER JOIN MovementLinkObject AS MovementLinkObject_UnitCategory
                                                                 ON MovementLinkObject_UnitCategory.MovementId = Movement_PromoUnit.Id
                                                                AND MovementLinkObject_UnitCategory.DescId = zc_MovementLinkObject_UnitCategory()

                                   LEFT JOIN MovementItem AS MI_PromoUnit ON MI_PromoUnit.MovementId = Movement_PromoUnit.Id
                                                         AND MI_PromoUnit.DescId = zc_MI_Master()
                                                         AND MI_PromoUnit.isErased = FALSE

                                   LEFT JOIN MovementItemFloat AS MIFloat_Price  ON MIFloat_Price.MovementItemId = MI_PromoUnit.Id
                                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()

                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                                               ON MIFloat_AmountPlanMax.MovementItemId = MI_PromoUnit.Id
                                                              AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()

                                   LEFT JOIN MovementItemFloat AS MIFloat_Koeff
                                                               ON MIFloat_Koeff.MovementItemId = MI_PromoUnit.Id
                                                              AND MIFloat_Koeff.DescId = zc_MIFloat_Koeff()

                                   LEFT JOIN MovementItemFloat AS MIFloat_AddBonusPercent
                                                               ON MIFloat_AddBonusPercent.MovementItemId = MI_PromoUnit.Id
                                                              AND MIFloat_AddBonusPercent.DescId = zc_MIFloat_AddBonusPercent()

                                   LEFT JOIN MovementItemBoolean AS MIBoolean_FixedPercent
                                                                 ON MIBoolean_FixedPercent.MovementItemId = MI_PromoUnit.Id
                                                                AND MIBoolean_FixedPercent.DescId = zc_MIBoolean_FixedPercent()

                              WHERE Movement_PromoUnit.StatusId = zc_Enum_Status_Complete()
                                AND Movement_PromoUnit.DescId = zc_Movement_PromoUnit()
                                AND Movement_PromoUnit.OperDate >= vbDateStart
                                AND Movement_PromoUnit.OperDate < vbDateEnd
                              ),
        
             tmpGoods AS (SELECT DISTINCT tmpPromoUnit.GoodsId  AS GoodsId
                          FROM tmpPromoUnit),
        
        
             tmpMI AS (SELECT vbUnitId                                                    AS UnitID
                            , Object_Goods.Id                                             AS GoodsId
                            , Sum(MovementItem.Amount)::TFloat                            AS Amount
                            , ROUND(Sum(COALESCE (MIFloat_Price.ValueData, 0)::TFloat *
                              MovementItem.Amount) / Sum(MovementItem.Amount), 2)::TFloat AS Price
                        FROM tmpMovement 
                             INNER JOIN Movement ON Movement.ID = tmpMovement.MovementID

                             INNER JOIN MovementItem AS MovementItem
                                                     ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.isErased   = FALSE
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                                
                             INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId
                             INNER JOIN Object_Goods_Retail AS Object_Goods
                                                            ON Object_Goods.GoodsMainId = Object_Goods_Retail.GoodsMainId
                                                           AND Object_Goods.RetailId = 4

                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()

                        GROUP BY Object_Goods.Id 
                        HAVING Sum(MovementItem.Amount)::TFloat > 0)

      SELECT
             Object_UnitCategory.ObjectCode                        AS UnitCategoryId
           , Object_UnitCategory.ValueData                         AS UnitCategoryName
           , Object_Unit.ObjectCode                                AS UnitID
           , Object_Unit.ValueData                                 AS UnitName
           , Object_GoodsGroup.ValueData                           AS GroupName
           , Object_Goods.Id                                       AS GoodsId
           , Object_Goods_Main.ObjectCode                          AS GoodsCode
           , Object_Goods_Main.Name                                AS GoodsName
           , tmpMI.Amount                                          AS Amount
           , Movement_PromoUnit.Price                              AS Price
           , NULLIF(Movement_PromoUnit.Koeff, 0)                   AS Koeff
           , Movement_PromoUnit.AmountPlan                         AS AmountPlan
           , Movement_PromoUnit.AmountPlanMax                      AS AmountPlanMax
           , Movement_PromoUnit.isFixedPercent                     AS isFixedPercent
           , Movement_PromoUnit.AddBonusPercent                    AS AddBonusPercent
       FROM (SELECT DISTINCT Movement.UnitId FROM tmpMovement AS Movement) as Unit
       
            LEFT JOIN tmpGoods AS Goods ON 1 = 1
       
            LEFT JOIN tmpPromoUnit AS Movement_PromoUnit 
                                   ON Movement_PromoUnit.GoodsId = Goods.GoodsId 

            LEFT JOIN tmpMI AS tmpMI 
                            ON tmpMI.UnitId = Unit.UnitId
                           AND tmpMI.GoodsId = Goods.GoodsId 

            LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = Goods.GoodsId
            LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId
                
            INNER JOIN ObjectLink AS ObjectLink_Unit_Category
                                  ON ObjectLink_Unit_Category.ObjectId = Unit.UnitID 
                                 AND ObjectLink_Unit_Category.DescId = zc_ObjectLink_Unit_Category()

            LEFT JOIN Object AS Object_UnitCategory ON Object_UnitCategory.Id = ObjectLink_Unit_Category.ChildObjectId 
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Unit.UnitID
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = Object_Goods_Main.GoodsGroupId

       ORDER BY Object_Unit.ObjectCode, Object_Goods_Main.ObjectCode;
    
    ELSE  
        -- Заполняем данные по продажам
      INSERT INTO tmpImplementation
        WITH tmpPromoUnit AS (SELECT MovementLinkObject_UnitCategory.ObjectId          AS UnitCategoryId
                                   , MI_PromoUnit.ObjectId                             AS GoodsId
                                   , MI_PromoUnit.Amount                               AS AmountPlan
                                   , MIFloat_AmountPlanMax.ValueData::TFloat           AS AmountPlanMax
                                   , MIFloat_Price.ValueData::TFloat                   AS Price
                                   , MIFloat_Koeff.ValueData::TFloat                   AS Koeff
                                   , COALESCE (MIBoolean_FixedPercent.ValueData, FALSE)  AS isFixedPercent
                                   , MIFloat_AddBonusPercent.ValueData::TFloat           AS AddBonusPercent
                              FROM Movement AS Movement_PromoUnit

                                   INNER JOIN MovementLinkObject AS MovementLinkObject_UnitCategory
                                                                 ON MovementLinkObject_UnitCategory.MovementId = Movement_PromoUnit.Id
                                                                AND MovementLinkObject_UnitCategory.DescId = zc_MovementLinkObject_UnitCategory()

                                   INNER JOIN ObjectLink AS ObjectLink_Unit_Category
                                                         ON ObjectLink_Unit_Category.ChildObjectId = MovementLinkObject_UnitCategory.ObjectId 
                                                        AND ObjectLink_Unit_Category.DescId = zc_ObjectLink_Unit_Category()


                                   LEFT JOIN MovementItem AS MI_PromoUnit ON MI_PromoUnit.MovementId = Movement_PromoUnit.Id
                                                         AND MI_PromoUnit.DescId = zc_MI_Master()
                                                         AND MI_PromoUnit.isErased = FALSE

                                   LEFT JOIN MovementItemFloat AS MIFloat_Price  ON MIFloat_Price.MovementItemId = MI_PromoUnit.Id
                                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()

                                   LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                                               ON MIFloat_AmountPlanMax.MovementItemId = MI_PromoUnit.Id
                                                              AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()

                                   LEFT JOIN MovementItemFloat AS MIFloat_Koeff
                                                               ON MIFloat_Koeff.MovementItemId = MI_PromoUnit.Id
                                                              AND MIFloat_Koeff.DescId = zc_MIFloat_Koeff()

                                   LEFT JOIN MovementItemFloat AS MIFloat_AddBonusPercent
                                                               ON MIFloat_AddBonusPercent.MovementItemId = MI_PromoUnit.Id
                                                              AND MIFloat_AddBonusPercent.DescId = zc_MIFloat_AddBonusPercent()

                                   LEFT JOIN MovementItemBoolean AS MIBoolean_FixedPercent
                                                                 ON MIBoolean_FixedPercent.MovementItemId = MI_PromoUnit.Id
                                                                AND MIBoolean_FixedPercent.DescId = zc_MIBoolean_FixedPercent()

                              WHERE Movement_PromoUnit.StatusId = zc_Enum_Status_Complete()
                                AND Movement_PromoUnit.DescId = zc_Movement_PromoUnit()
                                AND Movement_PromoUnit.OperDate >= vbDateStart
                                AND Movement_PromoUnit.OperDate < vbDateEnd
                                AND ObjectLink_Unit_Category.ObjectId in (SELECT DISTINCT Movement.UnitId FROM tmpMovement AS Movement)),
        
        
             tmpGoods AS (SELECT DISTINCT tmpPromoUnit.GoodsId  AS GoodsId
                          FROM tmpPromoUnit),
        
        
             tmpMI AS (SELECT tmpMovement.UnitID                                          AS UnitID
                            , Object_Goods.Id                                             AS GoodsId
                            , Sum(MovementItem.Amount)::TFloat                            AS Amount
                            , ROUND(Sum(COALESCE (MIFloat_Price.ValueData, 0)::TFloat *
                              MovementItem.Amount) / Sum(MovementItem.Amount), 2)::TFloat AS Price
                        FROM tmpMovement 
                             INNER JOIN Movement ON Movement.ID = tmpMovement.MovementID

                             INNER JOIN MovementItem AS MovementItem
                                                     ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.isErased   = FALSE
                                                    AND MovementItem.DescId     = zc_MI_Master()
                                                                
                             INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId
                             INNER JOIN Object_Goods_Retail AS Object_Goods
                                                            ON Object_Goods.GoodsMainId = Object_Goods_Retail.GoodsMainId
                                                           AND Object_Goods.RetailId = 4

                             LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                         ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                        AND MIFloat_Price.DescId = zc_MIFloat_Price()

                        GROUP BY tmpMovement.UnitID
                               , Object_Goods.Id 
                        HAVING Sum(MovementItem.Amount)::TFloat > 0)

      SELECT
             Object_UnitCategory.ObjectCode                        AS UnitCategoryId
           , Object_UnitCategory.ValueData                         AS UnitCategoryName
           , Object_Unit.ObjectCode                                AS UnitID
           , Object_Unit.ValueData                                 AS UnitName
           , Object_GoodsGroup.ValueData                           AS GroupName
           , Object_Goods.Id                                       AS GoodsId
           , Object_Goods_Main.ObjectCode                          AS GoodsCode
           , Object_Goods_Main.Name                                AS GoodsName
           , tmpMI.Amount                                          AS Amount
           , COALESCE(tmpMI.Price, Movement_PromoUnit.Price)       AS Price
           , NULLIF(Movement_PromoUnit.Koeff, 0)                   AS Koeff
           , Movement_PromoUnit.AmountPlan                         AS AmountPlan
           , Movement_PromoUnit.AmountPlanMax                      AS AmountPlanMax
           , Movement_PromoUnit.isFixedPercent                     AS isFixedPercent
           , Movement_PromoUnit.AddBonusPercent                    AS AddBonusPercent
       FROM (SELECT DISTINCT Movement.UnitId FROM tmpMovement AS Movement) as Unit
       
            INNER JOIN ObjectLink AS ObjectLink_Unit_Category
                                  ON ObjectLink_Unit_Category.ObjectId = Unit.UnitID 
                                 AND ObjectLink_Unit_Category.DescId = zc_ObjectLink_Unit_Category()

            LEFT JOIN tmpGoods AS Goods ON 1 = 1
       
            LEFT JOIN tmpPromoUnit AS Movement_PromoUnit 
                                   ON Movement_PromoUnit.GoodsId = Goods.GoodsId 
                                  AND Movement_PromoUnit.UnitCategoryId = ObjectLink_Unit_Category.ChildObjectId 

            LEFT JOIN tmpMI AS tmpMI 
                            ON tmpMI.UnitId = Unit.UnitId
                           AND tmpMI.GoodsId = Goods.GoodsId 

            LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = Goods.GoodsId
            LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId
                
            LEFT JOIN Object AS Object_UnitCategory ON Object_UnitCategory.Id = ObjectLink_Unit_Category.ChildObjectId 
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Unit.UnitID
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = Object_Goods_Main.GoodsGroupId

       ORDER BY Object_Unit.ObjectCode, Object_Goods_Main.ObjectCode;
       
     END IF;

     IF NOT EXISTS(SELECT 1 FROM tmpImplementation)
     THEN
         RAISE EXCEPTION 'Не заполнен "План по маркетингу для точек".';
     END IF;
     
     SELECT Object_UnitCategory.ObjectCode 
     INTO vbUnitCategoryCode
     FROM Object AS Object_Unit
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Category
                               ON ObjectLink_Unit_Category.ObjectId = Object_Unit.Id 
                              AND ObjectLink_Unit_Category.DescId = zc_ObjectLink_Unit_Category()
          LEFT JOIN Object AS Object_UnitCategory ON Object_UnitCategory.Id = ObjectLink_Unit_Category.ChildObjectId
     WHERE Object_Unit.Id        = vbUnitID
       AND Object_Unit.DescId    = zc_Object_Unit();
     
     vbFixedPercent := COALESCE ((SELECT CASE WHEN vbUnitCategoryCode = 2
                                              THEN History_CashSettings.FixedPercent 
                                              WHEN vbUnitCategoryCode = 3
                                              THEN History_CashSettings.FixedPercentB 
                                              WHEN vbUnitCategoryCode = 5
                                              THEN History_CashSettings.FixedPercentC 
                                              WHEN vbUnitCategoryCode = 8
                                              THEN History_CashSettings.FixedPercentD 
                                              ELSE 0 END
                                  FROM gpSelect_ObjectHistory_CashSettings (0, inSession) AS History_CashSettings
                                  WHERE History_CashSettings.StartDate <= vbDateStart
                                    AND History_CashSettings.EndDate > vbDateStart), 0);

       -- Вывод результата
     OPEN cur1 FOR SELECT DISTINCT
             UnitCategoryId,
             UnitCategoryName,
             UnitID,
             UnitName FROM tmpImplementation
             ORDER BY UnitCategoryId, UnitID;
     RETURN NEXT cur1;

     CREATE TEMP TABLE tmpResult (
             GroupName TVarChar,
             GoodsCode Integer,
             GoodsName TVarChar,
             Consider TVarChar,
             AmountCash TFloat NOT NULL DEFAULT 0,
             AmountPlanCash TFloat NOT NULL DEFAULT 0,
             AmountPlanAwardCash TFloat NOT NULL DEFAULT 0,
             Koeff TFloat NOT NULL DEFAULT 1,
             AddBonusPercentAdd TFloat NOT NULL DEFAULT 3,
             isFixedPercent Boolean NOT NULL DEFAULT False  
      ) ON COMMIT DROP;

      WITH tmpPromoUnitKoeff AS (SELECT MI_PromoUnit.ObjectId                             AS GoodsId
                                      , MIFloat_Koeff.ValueData::TFloat                   AS Koeff
                                 FROM Movement AS Movement_PromoUnit

                                      INNER JOIN MovementLinkObject AS MovementLinkObject_UnitCategory
                                                                    ON MovementLinkObject_UnitCategory.MovementId = Movement_PromoUnit.Id
                                                                   AND MovementLinkObject_UnitCategory.DescId = zc_MovementLinkObject_UnitCategory()

                                       LEFT JOIN MovementItem AS MI_PromoUnit ON MI_PromoUnit.MovementId = Movement_PromoUnit.Id
                                                             AND MI_PromoUnit.DescId = zc_MI_Master()
                                                             AND MI_PromoUnit.isErased = FALSE

                                       LEFT JOIN MovementItemFloat AS MIFloat_Koeff
                                                                   ON MIFloat_Koeff.MovementItemId = MI_PromoUnit.Id
                                                                  AND MIFloat_Koeff.DescId = zc_MIFloat_Koeff()

                                  WHERE Movement_PromoUnit.StatusId = zc_Enum_Status_Complete()
                                    AND Movement_PromoUnit.DescId = zc_Movement_PromoUnit()
                                    AND Movement_PromoUnit.OperDate >= vbDateStart
                                    AND Movement_PromoUnit.OperDate < vbDateEnd
                                    AND MovementLinkObject_UnitCategory.ObjectId = 7779481)
                                    
     INSERT INTO tmpResult (GroupName, GoodsCode, GoodsName, Koeff, isFixedPercent)
     SELECT GroupName,
            GoodsCode,
            GoodsName,
            COALESCE(NULLIF(PromoUnitKoeff.Koeff, 0), 1) AS Koeff,
            isFixedPercent
     FROM tmpImplementation

          LEFT JOIN tmpPromoUnitKoeff AS PromoUnitKoeff 
                                      ON PromoUnitKoeff.GoodsId = tmpImplementation.GoodsId 

     GROUP BY GroupName, GoodsCode, GoodsName, COALESCE(NULLIF(PromoUnitKoeff.Koeff, 0), 1), isFixedPercent
     ORDER BY GroupName, GoodsCode;
                  
     WITH
       tmpUnitDate AS (SELECT MovementLinkObject_Unit.ObjectId                     AS UnitId
                            , date_trunc('day', MovementDate_Insert.ValueData)     AS OperDate
                            , Count(*)                                             AS CountCheck
                       FROM Movement


                          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()


                          INNER JOIN MovementLinkObject AS MovementLinkObject_Insert
                                                        ON MovementLinkObject_Insert.MovementId = Movement.Id
                                                       AND MovementLinkObject_Insert.DescId = zc_movementlinkobject_insert()
                                                       AND MovementLinkObject_Insert.ObjectId = vbUserId

                          INNER JOIN MovementDate AS MovementDate_Insert
                                                  ON MovementDate_Insert.MovementId = Movement.Id
                                                 AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

                       WHERE MovementDate_Insert.ValueData >= vbDateStart
                         AND MovementDate_Insert.ValueData < vbDateEnd
                         AND Movement.DescId = zc_Movement_Check()
                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                         AND MovementLinkObject_Insert.ObjectId is Not Null
                       GROUP BY MovementLinkObject_Unit.ObjectId
                              , date_trunc('day', MovementDate_Insert.ValueData)),
       tmpFactOfManDaysActual AS (SELECT
                                         tmpUnitDate.UnitId                                    AS UnitId
                                       , COUNT(*)::Integer                                     AS FactOfManDays
                                   FROM tmpUnitDate
                                   WHERE CountCheck >= 10 OR CountCheck >= 5 AND vbDateStart < '01.10.2023'
                                   GROUP BY UnitId)
         
     SELECT Object.ObjectCode
     INTO vbUnitCalck
     FROM tmpFactOfManDaysActual
          INNER JOIN Object ON Object.ID = tmpFactOfManDaysActual.UnitId
     ORDER BY tmpFactOfManDaysActual.FactOfManDays DESC
     LIMIT 1;
     
      OPEN curUnit;
      LOOP
          FETCH curUnit INTO vbUnitID;
          IF NOT FOUND THEN EXIT; END IF;

          vbQueryText := 'ALTER TABLE tmpResult ADD COLUMN Price' || COALESCE (vbUnitID, 0)::Text || ' TFloat NOT NULL DEFAULT 0 ' ||
            ' , ADD COLUMN Amount' || COALESCE (vbUnitID, 0)::Text || ' TFloat NOT NULL DEFAULT 0 ' ||
            ' , ADD COLUMN AmountPlan' || COALESCE (vbUnitID, 0)::Text || ' TFloat NOT NULL DEFAULT 0 ' ||
            ' , ADD COLUMN AmountPlanAward' || COALESCE (vbUnitID, 0)::Text || ' TFloat NOT NULL DEFAULT 0 '||
            ' , ADD COLUMN isFixedPercent' || COALESCE (vbUnitID, 0)::Text || ' Boolean NOT NULL DEFAULT False '||
            ' , ADD COLUMN AddBonusPercent' || COALESCE (vbUnitID, 0)::Text || ' TFloat NOT NULL DEFAULT 0 '||
            ' , ADD COLUMN Koeff' || COALESCE (vbUnitID, 0)::Text || ' TFloat ';
          EXECUTE vbQueryText;

          vbQueryText := 'UPDATE tmpResult set Price' || COALESCE (vbUnitID, 0)::Text || ' = COALESCE (T1.T_Price, 0)' ||
            ', AmountCash  = AmountCash + COALESCE (T1.T_Amount, 0)' ||
            ', Amount' || COALESCE (vbUnitID, 0)::Text || ' = COALESCE (T1.T_Amount, 0)' ||
            ', AmountPlan' || COALESCE (vbUnitID, 0)::Text || ' = COALESCE (T_AmountPlan, 0)' ||
            ', AmountPlanAward' || COALESCE (vbUnitID, 0)::Text || ' = COALESCE (T_AmountPlanMax, 0)' ||
            ', isFixedPercent' || COALESCE (vbUnitID, 0)::Text || ' = COALESCE (T_isFixedPercent, False)' ||
            ', AddBonusPercent' || COALESCE (vbUnitID, 0)::Text || ' = COALESCE (T_AddBonusPercent, 0)' ||
            ', Koeff' || COALESCE (vbUnitID, 0)::Text || ' = T_Koeff' ||
            CASE WHEN COALESCE (vbUnitCalck, 0) = vbUnitID THEN 
                ', AmountPlanCash = COALESCE (T_AmountPlan, 0)' ||
                ', AmountPlanAwardCash = COALESCE (T_AmountPlanMax, 0)' 
            ELSE '' END||
            ' FROM (SELECT
               GoodsCode AS GoodsID,
               tmpImplementation.Price AS T_Price,
               tmpImplementation.Amount AS T_Amount,
               tmpImplementation.AmountPlan AS T_AmountPlan,
               tmpImplementation.AmountPlanMax AS T_AmountPlanMax,
               tmpImplementation.AddBonusPercent AS T_AddBonusPercent,
               tmpImplementation.isFixedPercent AS T_isFixedPercent,
               COALESCE (tmpImplementation.Koeff, 1) AS T_Koeff
             FROM tmpImplementation
             WHERE tmpImplementation.UnitID = ' || COALESCE (vbUnitID, 0)::Text || ') AS T1
             WHERE GoodsCode = T1.GoodsID';
          EXECUTE vbQueryText;

      END LOOP;
      CLOSE curUnit;

     OPEN cur2 FOR SELECT * FROM tmpResult ORDER BY GroupName, GoodsCode LIMIT 1;
     RETURN NEXT cur2;

     OPEN cur3 FOR SELECT
            Object_UnitCategory.Id                       AS UnitCategoryId
          , Object_UnitCategory.ObjectCode               AS UnitCategoryCode
          , Object_UnitCategory.ValueData                AS UnitCategoryName
          , ObjectFloat_PenaltyNonMinPlan.ValueData      AS PenaltyNonMinPlan
          , ObjectFloat_PremiumImplPlan.ValueData        AS PremiumImplPlan
          , ObjectFloat_MinLineByLineImplPlan.ValueData  AS MinLineByLineImplPlan
       FROM Object AS Object_UnitCategory

           LEFT JOIN ObjectFloat AS ObjectFloat_PenaltyNonMinPlan
                                 ON ObjectFloat_PenaltyNonMinPlan.ObjectId = Object_UnitCategory.Id
                                AND ObjectFloat_PenaltyNonMinPlan.DescId = zc_ObjectFloat_UnitCategory_PenaltyNonMinPlan()

           LEFT JOIN ObjectFloat AS ObjectFloat_PremiumImplPlan
                                 ON ObjectFloat_PremiumImplPlan.ObjectId = Object_UnitCategory.Id
                                AND ObjectFloat_PremiumImplPlan.DescId = zc_ObjectFloat_UnitCategory_PremiumImplPlan()

           LEFT JOIN ObjectFloat AS ObjectFloat_MinLineByLineImplPlan
                                 ON ObjectFloat_MinLineByLineImplPlan.ObjectId = Object_UnitCategory.Id
                                AND ObjectFloat_MinLineByLineImplPlan.DescId = zc_ObjectFloat_UnitCategory_MinLineByLineImplPlan()

       WHERE Object_UnitCategory.DescId = zc_Object_UnitCategory()
         AND Object_UnitCategory.isErased = False
         AND Object_UnitCategory.ObjectCode IN (SELECT DISTINCT UnitCategoryId FROM tmpImplementation) 
       ORDER BY Object_UnitCategory.ObjectCode;
     RETURN NEXT cur3;

     OPEN cur4 FOR  WITH
       tmpUnitDate AS (SELECT MovementLinkObject_Unit.ObjectId                     AS UnitId
                            , date_trunc('day', MovementDate_Insert.ValueData)     AS OperDate
                            , Count(*)                                             AS CountCheck
                       FROM Movement


                          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()


                          INNER JOIN MovementLinkObject AS MovementLinkObject_Insert
                                                        ON MovementLinkObject_Insert.MovementId = Movement.Id
                                                       AND MovementLinkObject_Insert.DescId = zc_movementlinkobject_insert()
                                                       AND MovementLinkObject_Insert.ObjectId = vbUserId

                          INNER JOIN MovementDate AS MovementDate_Insert
                                                  ON MovementDate_Insert.MovementId = Movement.Id
                                                 AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

                       WHERE MovementDate_Insert.ValueData >= vbDateStart
                         AND MovementDate_Insert.ValueData < vbDateEnd
                         AND Movement.DescId = zc_Movement_Check()
                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                         AND MovementLinkObject_Insert.ObjectId is Not Null
                       GROUP BY MovementLinkObject_Unit.ObjectId
                              , date_trunc('day', MovementDate_Insert.ValueData)),
       tmpFactOfManDaysActual AS (SELECT
               tmpUnitDate.UnitId                                    AS UnitId
             , COUNT(*)::Integer                                     AS FactOfManDays
         FROM tmpUnitDate
         WHERE CountCheck >= 5 OR CountCheck >= 10 AND vbDateStart >= '01.10.2023'
         GROUP BY tmpUnitDate.UnitId),
       tmpFactOfManDays AS (SELECT
               tmpFactOfManDaysActual.UnitId                         AS UnitId
             , tmpFactOfManDaysActual.FactOfManDays                  AS FactOfManDays
/*             , CASE WHEN (SELECT ObjectId FROM tmpFactOfManDaysActual ORDER BY FactOfManDays DESC LIMIT 1) = ObjectId
                    THEN (SELECT SUM(FactOfManDays) FROM tmpFactOfManDaysActual)
                    ELSE FactOfManDays END::INTEGER                           AS FactOfManDays */
         FROM tmpFactOfManDaysActual),
       tmpUser AS (SELECT MIMaster.ObjectId                                                                     AS UserId
                            , MIN(Movement.OperDate + ((MIChild.Amount - 1)::Integer::tvarchar||' DAY')::INTERVAL)  AS DateIn
                       FROM Movement
                                          
                            INNER JOIN MovementItem AS MIMaster
                                                    ON MIMaster.MovementId = Movement.ID
                                                   AND MIMaster.DescId = zc_MI_Master()
                                               
                            INNER JOIN MovementItem AS MIChild
                                                    ON MIChild.MovementId = Movement.ID
                                                   AND MIChild.ParentId = MIMaster.ID
                                                   AND MIChild.DescId = zc_MI_Child()
                                                                       
                       WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
                       GROUP BY MIMaster.ObjectId),
           tmPersonal_View  AS (SELECT ROW_NUMBER() OVER (PARTITION BY Object_User.Id ORDER BY Object_Member.IsErased) AS Ord
                                     , Object_User.Id              AS UserID
                                     , Object_Position.ObjectCode  AS PositionCode
                                     , Object_Position.ValueData   AS PositionName
                                     , COALESCE (ObjectBoolean_ReleasedMarketingPlan.ValueData, False)  AS isReleasedMarketingPlan
                                FROM Object AS Object_User

                                     INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                           ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                                          AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                     LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

                                     LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                                          ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                                         AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
                                     LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId

                                     LEFT JOIN ObjectBoolean AS ObjectBoolean_ReleasedMarketingPlan
                                                             ON ObjectBoolean_ReleasedMarketingPlan.ObjectId = Object_Member.Id
                                                            AND ObjectBoolean_ReleasedMarketingPlan.DescId = zc_ObjectBoolean_Member_ReleasedMarketingPlan()
                            			
                                WHERE Object_User.DescId = zc_Object_User())

       SELECT
            Object_Unit.Id                                       AS UnitId
          , Object_Unit.ObjectCode                               AS UnitCode
          , Object_Unit.ValueData                                AS UnitName
          , Object_UnitCategory.ObjectCode                       AS UnitCategoryId
          , ObjectFloat_NormOfManDays.ValueData::Integer         AS NormOfManDays
          , FactOfManDays_Unit.FactOfManDays                     AS FactOfManDays
          , CASE WHEN ObjectFloat_NormOfManDays.ValueData::Integer = 0 THEN 0.0 ELSE
            CASE WHEN FactOfManDays_Unit.FactOfManDays >= ObjectFloat_NormOfManDays.ValueData THEN 100.0 ELSE
            ROUND(1.0 * FactOfManDays_Unit.FactOfManDays /
            ObjectFloat_NormOfManDays.ValueData * 100.0, 2) END END  AS PercentAttendance
          , vbFixedPercent                                       AS FixedPercent 
          , date_part('day', vbDateStart - tmpUser.DateIn)::INTEGER <= 90 AS isNewUser
          , COALESCE(Personal_View.PositionCode, 1) = 1 AS isCashier
       FROM Object AS Object_Unit

           LEFT JOIN ObjectLink AS ObjectLink_Unit_Category
                               ON ObjectLink_Unit_Category.ObjectId = Object_Unit.Id
                               AND ObjectLink_Unit_Category.DescId = zc_ObjectLink_Unit_Category()

           LEFT JOIN Object AS Object_UnitCategory ON Object_UnitCategory.Id = ObjectLink_Unit_Category.ChildObjectId

           LEFT JOIN ObjectFloat AS ObjectFloat_NormOfManDays
                                 ON ObjectFloat_NormOfManDays.ObjectId = Object_Unit.Id
                                AND ObjectFloat_NormOfManDays.DescId = zc_ObjectFloat_Unit_NormOfManDays()

           LEFT JOIN tmpFactOfManDays AS FactOfManDays_Unit
                                      ON FactOfManDays_Unit.UnitId = Object_Unit.Id

           LEFT JOIN tmpUser ON tmpUser.UserID = vbUserId

           LEFT JOIN tmPersonal_View AS Personal_View 
                                     ON Personal_View.UserID = tmpUser.UserID
                                    AND Personal_View.Ord = 1  

       WHERE Object_Unit.DescId = zc_Object_Unit()
         AND Object_Unit.isErased = False
         AND Object_Unit.ObjectCode IN (SELECT DISTINCT UnitID FROM tmpImplementation)
       ORDER BY Object_UnitCategory.ObjectCode, Object_Unit.ObjectCode;
     RETURN NEXT cur4;


     OPEN cur5 FOR SELECT * FROM tmpResult ORDER BY GroupName, GoodsCode;
     RETURN NEXT cur5;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 04.12.19         *
*/

-- тест
-- 
select * from gpReport_ImplementationPlanEmployeeCash(inStartDate := ('17.05.2022')::TDateTime ,  inSession := '4085760');