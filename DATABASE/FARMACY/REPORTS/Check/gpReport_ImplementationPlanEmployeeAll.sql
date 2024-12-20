-- Function: gpReport_ImplementationPlanEmployeeAll()

DROP FUNCTION IF EXISTS gpReport_ImplementationPlanEmployeeAll (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ImplementationPlanEmployeeAll(
    IN inStartDate     TDateTime , -- Дата в месяце
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  Orders                  Integer,

  UserID                  Integer,
  UserName                TVarChar,
  UnitID                  Integer,
  UnitName                TVarChar,
  UnitCategoryName        TVarChar,
  NormOfManDays           Integer,
  FactOfManDays           Integer,
  TotalExecutionLine      TFloat,
  TotalExecutionFixed     TFloat,
  AmountTheFineTab        TFloat,
  BonusAmountTab          TFloat,
  Total                   TFloat,
  DaysWorked              Integer,
  PositionName            TVarChar,
  isReleasedMarketingPlan Boolean,
  CountAmount             Integer,
  CountConsider           Integer,
  CountRecord             Integer,
  FixedPercent            TFloat,
  AddBonusPercentTab      TFloat,
  AddBonusPercentSum      TFloat
)
AS
$BODY$
   DECLARE vbDateStart TDateTime;
   DECLARE vbDateEnd TDateTime;
   DECLARE vbQueryText Text;
   DECLARE curUnit CURSOR FOR SELECT UnitID FROM tmpImplementation GROUP BY UnitCategoryId, UnitID ORDER BY UnitCategoryId, UnitID;
   DECLARE vbUnitID Integer;
   DECLARE vbFixedPercentA TFloat;
   DECLARE vbFixedPercentB TFloat;
   DECLARE vbFixedPercentC TFloat;
   DECLARE vbFixedPercentD TFloat;
   DECLARE vbAddBonusPercent TFloat;
   DECLARE vbisAdmin Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());

    vbDateStart := date_trunc('month', inStartDate);
    vbDateEnd := date_trunc('month', vbDateStart + INTERVAL '1 month');
    
    SELECT History_CashSettings.FixedPercent 
         , History_CashSettings.FixedPercentB 
         , History_CashSettings.FixedPercentC 
         , History_CashSettings.FixedPercentD 
    INTO vbFixedPercentA, vbFixedPercentB, vbFixedPercentC, vbFixedPercentD   
    FROM gpSelect_ObjectHistory_CashSettings (0, inSession) AS History_CashSettings
    WHERE History_CashSettings.StartDate <= vbDateStart
      AND History_CashSettings.EndDate > vbDateStart;
      
    vbFixedPercentA := COALESCE (vbFixedPercentA, 0);
    vbFixedPercentB := COALESCE (vbFixedPercentB, 0); 
    vbFixedPercentC := COALESCE (vbFixedPercentC, 0);
    vbFixedPercentD := COALESCE (vbFixedPercentD, 0);
    
    vbAddBonusPercent := 3;
    vbisAdmin := EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE ObjectLink_UserRole_View.UserId = inSession::Integer 
                                                                   AND ObjectLink_UserRole_View.RoleId = zc_Enum_Role_Admin()) 
                 OR inSession::Integer = 298786;
                                   
      -- Отработано по календарю
    CREATE TEMP TABLE tmpUserUnitDayTable (
            UserID             Integer,
            UnitID             Integer,

            NormOfManDays      Integer,
            FactOfManDays      Integer,
            Ord                Integer,
            PercentAttendance  TFloat

      ) ON COMMIT DROP;

      -- Заполнение отработано по календарю
    INSERT INTO tmpUserUnitDayTable (
            UserID,
            UnitID,

            FactOfManDays,
            Ord)

    WITH tmpUserUnitDay AS (SELECT
             MovementLinkObject_Insert.ObjectId                   AS UserId
           , MovementLinkObject_Unit.ObjectId                     AS UnitId
           , date_trunc('day', MovementDate_Insert.ValueData)     AS OperDate
           , Count(*)                                             AS CountCheck
     FROM Movement


        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()


        INNER JOIN MovementLinkObject AS MovementLinkObject_Insert
                                      ON MovementLinkObject_Insert.MovementId = Movement.Id
                                     AND MovementLinkObject_Insert.DescId = zc_movementlinkobject_insert()

        INNER JOIN MovementDate AS MovementDate_Insert
                                ON MovementDate_Insert.MovementId = Movement.Id
                               AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

     WHERE MovementDate_Insert.ValueData >= vbDateStart
       AND MovementDate_Insert.ValueData < vbDateEnd
       AND Movement.DescId = zc_Movement_Check()
       AND Movement.StatusId <> zc_Enum_Status_Erased()
       AND MovementLinkObject_Insert.ObjectId is Not Null
     GROUP BY MovementLinkObject_Insert.ObjectId
            , MovementLinkObject_Unit.ObjectId
            , date_trunc('day', MovementDate_Insert.ValueData))

    SELECT
        tmpUserUnitDay.UserID,
        tmpUserUnitDay.UnitID,
        Count(*) as FactOfManDays,
        ROW_NUMBER() OVER (PARTITION BY tmpUserUnitDay.UserID ORDER BY Count(*) DESC, Sum(tmpUserUnitDay.CountCheck) DESC) AS Ord
    FROM tmpUserUnitDay
    WHERE tmpUserUnitDay.CountCheck >= 10 OR tmpUserUnitDay.CountCheck >= 5 AND vbDateStart < '01.10.2023'
    GROUP BY tmpUserUnitDay.UserID, tmpUserUnitDay.UnitID
    ORDER BY tmpUserUnitDay.UserID, tmpUserUnitDay.UnitID; 
    
    ANALYSE tmpUserUnitDayTable;           
    
      -- Заполнение: Норма человекодней
    UPDATE tmpUserUnitDayTable SET
        NormOfManDays = UnitNormOfManDays.NormOfManDays,
        PercentAttendance = CASE WHEN UnitNormOfManDays.NormOfManDays = 0 THEN 0.0 ELSE
            CASE WHEN tmpUserUnitDayTable.FactOfManDays >= UnitNormOfManDays.NormOfManDays THEN 100.0 ELSE
            ROUND(1.0 * tmpUserUnitDayTable.FactOfManDays / UnitNormOfManDays.NormOfManDays * 100.0, 2) END END
    FROM (SELECT
            Object_Unit.Id                                            AS UnitId,
            COALESCE(ObjectFloat_NormOfManDays.ValueData, 0)::Integer AS NormOfManDays
       FROM Object AS Object_Unit

           INNER JOIN ObjectFloat AS ObjectFloat_NormOfManDays
                                  ON ObjectFloat_NormOfManDays.ObjectId = Object_Unit.Id
                                 AND ObjectFloat_NormOfManDays.DescId = zc_ObjectFloat_Unit_NormOfManDays()

       WHERE Object_Unit.DescId = zc_Object_Unit()
         AND Object_Unit.isErased = False) AS UnitNormOfManDays

    WHERE tmpUserUnitDayTable.UnitId = UnitNormOfManDays.UnitId;
    
    ANALYSE tmpUserUnitDayTable;

      -- Проверка заполнения нормы человекодней
/*    IF EXISTS(SELECT FROM tmpUserUnitDayTable WHERE NormOfManDays IS NULL) THEN
      RAISE EXCEPTION 'По аптеке <%> не заполнены нормы человекодней ',
        (SELECT Object_Unit.ValueData FROM tmpUserUnitDayTable
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUserUnitDayTable.UnitId
         WHERE NormOfManDays IS NULL LIMIT 1);
    END IF; */

      -- Результирующая таблица
    CREATE TEMP TABLE tmpResult (
            Id                 SERIAL    NOT NULL PRIMARY KEY,

            UserID             Integer,
            UserName           TVarChar,
            isNewUser          Boolean,
            isCashier        Boolean,

            UnitID             Integer,
            UnitName           TVarChar,
            
            UnitCategoryCode   Integer,

            NormOfManDays      Integer,
            FactOfManDays      Integer,

            TotalExecutionLine TFloat,
            TotalExecutionFixed TFloat,
            AmountTheFineTab   TFloat,
            BonusAmountTab     TFloat,
            Total              TFloat,
            
            CountAmount        Integer,
            CountConsider      Integer,
            CountRecord        Integer,
            
            FixedPercent       TFloat,
            AddBonusPercentTab TFloat,
            AddBonusPercentSum TFloat
      ) ON COMMIT DROP;

    CREATE TEMP TABLE tmpUser ON COMMIT DROP AS
    SELECT MIMaster.ObjectId                                                                     AS UserId
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
    GROUP BY MIMaster.ObjectId;
                      
    ANALYSE tmpUser;
                      
    CREATE TEMP TABLE tmPersonal_View  ON COMMIT DROP AS
    SELECT ROW_NUMBER() OVER (PARTITION BY Object_User.Id ORDER BY Object_Member.IsErased) AS Ord
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
			
    WHERE Object_User.DescId = zc_Object_User();
                              
    ANALYSE tmPersonal_View;
                      
      -- Заполнение шапки результирующей таблицы
    INSERT INTO tmpResult (
             UserID,
             UserName,
             isNewUser,
             isCashier,
             UnitID,
             UnitName,
             UnitCategoryCode,
             TotalExecutionLine,
             TotalExecutionFixed,
             AmountTheFineTab,
             BonusAmountTab,
             Total)

    SELECT DISTINCT
       tmpUserUnitDayTable.UserId,
       Object_Member.ValueData,
       date_part('day', vbDateStart - tmpUser.DateIn)::INTEGER <= 90,
       COALESCE(Personal_View.PositionCode, 1) = 1,
       tmpUserUnitDayTable.UnitId,
       Object_Unit.ValueData,
       COALESCE (Object_UnitCategory.ObjectCode, 0),
       0, 0, 0, 0, 0
    FROM tmpUserUnitDayTable

       LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpUserUnitDayTable.UnitId

       LEFT JOIN ObjectLink AS ObjectLink_Unit_Category
                            ON ObjectLink_Unit_Category.ObjectId = Object_Unit.Id 
                           AND ObjectLink_Unit_Category.DescId = zc_ObjectLink_Unit_Category()
       LEFT JOIN Object AS Object_UnitCategory ON Object_UnitCategory.Id = ObjectLink_Unit_Category.ChildObjectId

       LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = tmpUserUnitDayTable.UserId
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

       LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.childobjectid

       LEFT JOIN tmpUser ON tmpUser.UserID = tmpUserUnitDayTable.UserId

       LEFT JOIN tmPersonal_View AS Personal_View 
                                 ON Personal_View.UserID = tmpUserUnitDayTable.UserId
                                AND Personal_View.Ord = 1  
       
    WHERE tmpUserUnitDayTable.Ord = 1

    ORDER BY Object_Member.ValueData;
    
    ANALYSE tmpResult;

    CREATE TEMP TABLE tmpImplementation (
            UserId Integer,
            UnitCategoryId Integer,
            UnitID Integer,
            GoodsId Integer,
            Amount TFloat,
            Price TFloat,
            Koeff TFloat,
            isFixedPercent boolean,
            AddBonusPercent TFloat,

            AmountPlan TFloat,
            AmountPlanMax TFloat,

            AmountPlanTab TFloat,
            AmountPlanMaxTab TFloat,

            AmountTheFineTab TFloat,
            BonusAmountTab TFloat,
            AddBonusPercentTab TFloat,
            AddBonusPercentSum TFloat
      ) ON COMMIT DROP;

      -- Заполняем данные по продажам
    IF vbDateStart >= '01.04.2022' --AND vbDateStart <= '01.05.2022'
       AND (SELECT count(*)
            FROM Movement AS Movement_PromoUnit
            WHERE Movement_PromoUnit.StatusId = zc_Enum_Status_Complete()
              AND Movement_PromoUnit.DescId = zc_Movement_PromoUnit()
              AND Movement_PromoUnit.OperDate >= vbDateStart
              AND Movement_PromoUnit.OperDate < vbDateEnd) = 1
    THEN

      INSERT INTO tmpImplementation (
              UserId,
              UnitCategoryId,
              UnitID,
              GoodsId,
              Amount,
              Price,
              Koeff,
              isFixedPercent,
              AddBonusPercent,
              AmountPlan,
              AmountPlanMax)
      WITH tmpPromoUnit AS (SELECT
                       MovementLinkObject_UnitCategory.ObjectId              AS UnitCategoryID
                     , MI_PromoUnit.ObjectId                                 AS GoodsId
                     , MIFloat_Price.ValueData                               AS Price
                     , MI_PromoUnit.Amount                                   AS AmountPlan
                     , MIFloat_AmountPlanMax.ValueData::TFloat               AS AmountPlanMax
                     , MIFloat_Koeff.ValueData::TFloat                       AS Koeff
                     , COALESCE (MIBoolean_FixedPercent.ValueData, FALSE)    AS isFixedPercent
                     , MIFloat_AddBonusPercent.ValueData::TFloat             AS AddBonusPercent
           FROM Movement AS Movement_PromoUnit

                INNER JOIN MovementLinkObject AS MovementLinkObject_UnitCategory
                                             ON MovementLinkObject_UnitCategory.MovementId = Movement_PromoUnit.Id
                                            AND MovementLinkObject_UnitCategory.DescId = zc_MovementLinkObject_UnitCategory()

                INNER JOIN MovementItem AS MI_PromoUnit ON MI_PromoUnit.MovementId = Movement_PromoUnit.Id
                                       AND MI_PromoUnit.DescId = zc_MI_Master()
                                       AND MI_PromoUnit.isErased = FALSE

                INNER JOIN MovementItemFloat AS MIFloat_Price  ON MIFloat_Price.MovementItemId = MI_PromoUnit.Id
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
         AND Movement_PromoUnit.OperDate < vbDateEnd),

       tmpGoods AS (SELECT DISTINCT tmpPromoUnit.GoodsId  AS GoodsId
                    FROM tmpPromoUnit),

       tmpMovementAll AS (SELECT MovementItemContainer.MovementId
                               , MovementItemContainer.OperDate                            
                               , MovementItemContainer.WhereObjectId_analyzer                 AS UnitId
                               , MovementItemContainer.ObjectId_analyzer                      AS GoodsId
                               , MovementItemContainer.Price                                  AS Price
                               , - MovementItemContainer.Amount                               AS Amount
                          FROM MovementItemContainer

                          WHERE MovementItemContainer.OperDate >= vbDateStart
                            AND MovementItemContainer.OperDate < vbDateEnd
                            AND MovementItemContainer.DescId = zc_MIContainer_Count()
                            AND MovementItemContainer.MovementDescId = zc_Movement_Check()),

       tmpMLO AS (SELECT *
                  FROM MovementLinkObject
                  WHERE MovementLinkObject.DescId in (zc_MovementLinkObject_Insert(), zc_MovementLinkObject_UserConfirmedKind())
                    AND MovementLinkObject.MovementId >= (SELECT MIN(tmpMovementAll.MovementId) FROM tmpMovementAll)),

       tmpMovementDate AS (SELECT
                                   Movement.MovementId
                                 , Movement.OperDate
                                 , COALESCE (MovementLinkObject_Insert.ObjectId,
                                             MovementLinkObject_UserConfirmedKind.ObjectId)     AS UserId
                                 , Movement.UnitId
                                 , Object_Goods.Id                                              AS GoodsId
                                 , Movement.Price
                                 , Movement.Amount
                             FROM tmpMovementAll AS Movement

                                INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = Movement.GoodsId
                                INNER JOIN Object_Goods_Retail AS Object_Goods
                                                               ON Object_Goods.GoodsMainId = Object_Goods_Retail.GoodsMainId
                                                              AND Object_Goods.RetailId = 4

                                LEFT JOIN tmpMLO AS MovementLinkObject_Insert
                                                             ON MovementLinkObject_Insert.MovementId = Movement.MovementId
                                                            AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()

                                LEFT JOIN tmpMLO AS MovementLinkObject_UserConfirmedKind
                                                             ON MovementLinkObject_UserConfirmedKind.MovementId = Movement.MovementId
                                                            AND MovementLinkObject_UserConfirmedKind.DescId = zc_MovementLinkObject_UserConfirmedKind()

                                        ),
       tmpMovement AS (SELECT
                               Movement.MovementId
                             , Movement.UserId                                   AS UserId
                             , Movement.UnitId
                             , Movement.GoodsId                                  AS GoodsId
                             , Movement.Price
                             , Movement.Amount
                         FROM tmpMovementDate AS Movement
                         WHERE Movement.OperDate >= vbDateStart
                           AND Movement.OperDate < vbDateEnd),
      tmpMI AS (SELECT
                 Movement.UserId                                              AS UserId
               , Movement.GoodsId                                             AS GoodsId
               , Sum(Movement.Amount)::TFloat                                 AS Amount
               , ROUND(Sum(Movement.Price *
                 Movement.Amount) / Sum(Movement.Amount), 2)::TFloat          AS Price
           FROM tmpMovement AS Movement

           GROUP BY Movement.UserId
                  , Movement.GoodsId
           HAVING Sum(Movement.Amount)::TFloat > 0)

       SELECT
             UserUnitDayTable.UserID                               AS UserID
           , PromoUnit.UnitCategoryId                              AS UnitCategoryId
           , UserUnitDayTable.UnitID                               AS UnitID
           , Goods.GoodsId                                         AS GoodsId
           , COALESCE(tmpMI.Amount, 0)                             AS Amount
           , PromoUnit.Price                                       AS Price
           , NULLIF(PromoUnit.Koeff, 0)                            AS Koeff
           , COALESCE(PromoUnit.isFixedPercent, FALSE)             AS isFixedPercent
           , PromoUnit.AddBonusPercent                             AS AddBonusPercent
           , PromoUnit.AmountPlan                                  AS AmountPlan
           , PromoUnit.AmountPlanMax                               AS AmountPlanMax
       FROM tmpUserUnitDayTable AS UserUnitDayTable

            LEFT JOIN tmpGoods AS Goods ON 1 = 1
       
            LEFT JOIN tmpPromoUnit AS PromoUnit 
                                   ON PromoUnit.GoodsId = Goods.GoodsId 

            LEFT JOIN tmpMI AS tmpMI 
                            ON tmpMI.UserID = UserUnitDayTable.UserID
                           AND tmpMI.GoodsId = Goods.GoodsId 
                           
       WHERE UserUnitDayTable.Ord = 1
       ORDER BY UserUnitDayTable.UserID, UserUnitDayTable.UnitID, Goods.GoodsId;
    
    ELSE

      INSERT INTO tmpImplementation (
              UserId,
              UnitCategoryId,
              UnitID,
              GoodsId,
              Amount,
              Price,
              Koeff,
              isFixedPercent,
              AddBonusPercent,
              AmountPlan,
              AmountPlanMax)
      WITH tmpPromoUnit AS (SELECT
                       MovementLinkObject_UnitCategory.ObjectId              AS UnitCategoryID
                     , MI_PromoUnit.ObjectId                                 AS GoodsId
                     , MIFloat_Price.ValueData                               AS Price
                     , MI_PromoUnit.Amount                                   AS AmountPlan
                     , MIFloat_AmountPlanMax.ValueData::TFloat               AS AmountPlanMax
                     , MIFloat_Koeff.ValueData::TFloat                       AS Koeff
                     , COALESCE (MIBoolean_FixedPercent.ValueData, FALSE)    AS isFixedPercent
                     , MIFloat_AddBonusPercent.ValueData::TFloat             AS AddBonusPercent
           FROM Movement AS Movement_PromoUnit

                INNER JOIN MovementLinkObject AS MovementLinkObject_UnitCategory
                                             ON MovementLinkObject_UnitCategory.MovementId = Movement_PromoUnit.Id
                                            AND MovementLinkObject_UnitCategory.DescId = zc_MovementLinkObject_UnitCategory()

                INNER JOIN MovementItem AS MI_PromoUnit ON MI_PromoUnit.MovementId = Movement_PromoUnit.Id
                                       AND MI_PromoUnit.DescId = zc_MI_Master()
                                       AND MI_PromoUnit.isErased = FALSE

                INNER JOIN MovementItemFloat AS MIFloat_Price  ON MIFloat_Price.MovementItemId = MI_PromoUnit.Id
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
         --AND COALESCE(MIFloat_AmountPlanMax.ValueData, 0) > 0
         AND Movement_PromoUnit.OperDate >= vbDateStart
         AND Movement_PromoUnit.OperDate < vbDateEnd),

       tmpGoods AS (SELECT DISTINCT tmpPromoUnit.GoodsId  AS GoodsId
                    FROM tmpPromoUnit),

       tmpMovementAll AS (SELECT MovementItemContainer.MovementId
                               , MovementItemContainer.OperDate                            
                               , MovementItemContainer.WhereObjectId_analyzer                 AS UnitId
                               , MovementItemContainer.ObjectId_analyzer                      AS GoodsId
                               , MovementItemContainer.Price                                  AS Price
                               , - MovementItemContainer.Amount                               AS Amount
                          FROM MovementItemContainer

                          WHERE MovementItemContainer.OperDate >= vbDateStart
                            AND MovementItemContainer.OperDate < vbDateEnd
                            AND MovementItemContainer.DescId = zc_MIContainer_Count()
                            AND MovementItemContainer.MovementDescId = zc_Movement_Check()),

       tmpMLO AS (SELECT *
                  FROM MovementLinkObject
                  WHERE MovementLinkObject.DescId in (zc_MovementLinkObject_Insert(), zc_MovementLinkObject_UserConfirmedKind())
                    AND MovementLinkObject.MovementId >= (SELECT MIN(tmpMovementAll.MovementId) FROM tmpMovementAll)),

       tmpMovementDate AS (SELECT
                                   Movement.MovementId
                                 , Movement.OperDate
                                 , COALESCE (MovementLinkObject_Insert.ObjectId,
                                             MovementLinkObject_UserConfirmedKind.ObjectId)     AS UserId
                                 , Movement.UnitId
                                 , Object_Goods.Id                                              AS GoodsId
                                 , Movement.Price
                                 , Movement.Amount
                             FROM tmpMovementAll AS Movement

                                INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = Movement.GoodsId
                                INNER JOIN Object_Goods_Retail AS Object_Goods
                                                               ON Object_Goods.GoodsMainId = Object_Goods_Retail.GoodsMainId
                                                              AND Object_Goods.RetailId = 4

                                LEFT JOIN tmpMLO AS MovementLinkObject_Insert
                                                             ON MovementLinkObject_Insert.MovementId = Movement.MovementId
                                                            AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()

                                LEFT JOIN tmpMLO AS MovementLinkObject_UserConfirmedKind
                                                             ON MovementLinkObject_UserConfirmedKind.MovementId = Movement.MovementId
                                                            AND MovementLinkObject_UserConfirmedKind.DescId = zc_MovementLinkObject_UserConfirmedKind()

                                        ),
       tmpMovement AS (SELECT
                               Movement.MovementId
                             , Movement.UserId                                   AS UserId
                             , Movement.UnitId
                             , Movement.GoodsId                                  AS GoodsId
                             , Movement.Price
                             , Movement.Amount
                         FROM tmpMovementDate AS Movement
                         WHERE Movement.OperDate >= vbDateStart
                           AND Movement.OperDate < vbDateEnd),
      tmpMI AS (SELECT
                 Movement.UserId                                              AS UserId
               , Movement.UnitId                                              AS UnitId
               , Movement.GoodsId                                             AS GoodsId
               , Sum(Movement.Amount)::TFloat                                 AS Amount
               , ROUND(Sum(Movement.Price *
                 Movement.Amount) / Sum(Movement.Amount), 2)::TFloat          AS Price
           FROM tmpMovement AS Movement

           GROUP BY Movement.UserId
                  , Movement.UnitId
                  , Movement.GoodsId
           HAVING Sum(Movement.Amount)::TFloat > 0)

       SELECT
             UserUnitDayTable.UserID                               AS UserID
           , ObjectLink_Unit_Category.ChildObjectId                AS UnitCategoryId
           , UserUnitDayTable.UnitID                               AS UnitID
           , Goods.GoodsId                                         AS GoodsId
           , COALESCE(tmpMI.Amount, 0)                             AS Amount
           , COALESCE(tmpMI.Price, PromoUnit.Price)                AS Price
           , NULLIF(PromoUnit.Koeff, 0)                            AS Koeff
           , COALESCE(PromoUnit.isFixedPercent, FALSE)             AS isFixedPercent
           , PromoUnit.AddBonusPercent                             AS AddBonusPercent
           , PromoUnit.AmountPlan                                  AS AmountPlan
           , PromoUnit.AmountPlanMax                               AS AmountPlanMax
       FROM tmpUserUnitDayTable AS UserUnitDayTable

            INNER JOIN ObjectLink AS ObjectLink_Unit_Category
                                  ON ObjectLink_Unit_Category.ObjectId = UserUnitDayTable.UnitID 
                                 AND ObjectLink_Unit_Category.DescId = zc_ObjectLink_Unit_Category()

            LEFT JOIN tmpGoods AS Goods ON 1 = 1
       
            LEFT JOIN tmpPromoUnit AS PromoUnit 
                                   ON PromoUnit.GoodsId = Goods.GoodsId 
                                  AND PromoUnit.UnitCategoryId = ObjectLink_Unit_Category.ChildObjectId

            LEFT JOIN tmpMI AS tmpMI 
                            ON tmpMI.UnitId = UserUnitDayTable.UnitId
                           AND tmpMI.UserID = UserUnitDayTable.UserID
                           AND tmpMI.GoodsId = Goods.GoodsId 

       ORDER BY UserUnitDayTable.UserID, UserUnitDayTable.UnitID, Goods.GoodsId;
    END IF;    
    
    ANALYSE tmpImplementation;

      -- Расчет суммы плана с учетом табеля
     UPDATE tmpImplementation SET AmountPlanTab = 1.0 * AmountPlan * tmpUserUnitDayTable.PercentAttendance / 100.0,
            AmountPlanMaxTab  = 1.0 * AmountPlanMax * tmpUserUnitDayTable.PercentAttendance / 100.0
     FROM tmpUserUnitDayTable
     WHERE tmpImplementation.UserID = tmpUserUnitDayTable.UserID
       AND tmpImplementation.UnitID = tmpUserUnitDayTable.UnitID;

      -- Собираем общее количество
     UPDATE tmpImplementation SET Amount = ImplementationAll.AmountAll
     FROM (SELECT
            Implementation.GoodsId                       AS GoodsId
          , Implementation.UserId                        AS UserId
          , SUM(Implementation.Amount)                   AS AmountAll
       FROM tmpImplementation AS Implementation
       GROUP BY Implementation.GoodsId, Implementation.UserId) AS ImplementationAll
     WHERE tmpImplementation.UserId = ImplementationAll.UserId
       AND tmpImplementation.GoodsId = ImplementationAll.GoodsId
       AND tmpImplementation.AmountPlan IS NOT NULL;

      -- Расчет суммы штрафа и премии
     UPDATE tmpImplementation SET AmountTheFineTab = CASE WHEN Amount < AmountPlanTab AND COALESCE(AmountPlan, 0) > 0 THEN
              1.0 * (AmountPlanTab - Amount) * Price * UnitCategory.PenaltyNonMinPlan / 100 ELSE 0 END,
            BonusAmountTab = CASE WHEN Amount >= AmountPlanMax AND COALESCE(AmountPlanMax, 0) > 0 AND vbDateStart >= '01.04.2022' AND vbDateStart <= '01.05.2022'
                                  THEN 1.0 * ROUND(AmountPlanMax * Price * 0.03, 2)
                                  WHEN Amount >= AmountPlanMaxTab AND COALESCE(AmountPlanMax, 0) > 0 AND vbDateStart <> '01.04.2022' AND vbDateStart <> '01.05.2022'
                                  THEN 1.0 * Amount * Price * (UnitCategory.PremiumImplPlan + COALESCE(AddBonusPercent, 0)) / 100 
                                  ELSE 0 END,
            AddBonusPercentTab = CASE WHEN Amount >= AmountPlanMaxTab AND COALESCE(AmountPlanMax, 0) > 0 AND COALESCE(AddBonusPercent, 0) <> 0 AND 
                                           vbDateStart <> '01.04.2022' AND vbDateStart <> '01.05.2022'
                                      THEN 1.0 * Amount * Price * COALESCE(AddBonusPercent, 0) / 100 END ,
            AddBonusPercentSum  = CASE WHEN Amount >= AmountPlanMaxTab AND COALESCE(AmountPlanMax, 0) > 0 AND COALESCE(AddBonusPercent, 0) <> 0 AND 
                                            vbDateStart >= '01.07.2023'
                                       THEN 1.0 * Amount * Price * (COALESCE(AddBonusPercent, 0) + COALESCE(vbAddBonusPercent, 0)) / 100 END 
     FROM (SELECT
            Object_UnitCategory.Id                       AS UnitCategoryId
          , ObjectFloat_PenaltyNonMinPlan.ValueData      AS PenaltyNonMinPlan
          , ObjectFloat_PremiumImplPlan.ValueData        AS PremiumImplPlan
       FROM Object AS Object_UnitCategory

           LEFT JOIN ObjectFloat AS ObjectFloat_PenaltyNonMinPlan
                                 ON ObjectFloat_PenaltyNonMinPlan.ObjectId = Object_UnitCategory.Id
                                AND ObjectFloat_PenaltyNonMinPlan.DescId = zc_ObjectFloat_UnitCategory_PenaltyNonMinPlan()

           LEFT JOIN ObjectFloat AS ObjectFloat_PremiumImplPlan
                                 ON ObjectFloat_PremiumImplPlan.ObjectId = Object_UnitCategory.Id
                                AND ObjectFloat_PremiumImplPlan.DescId = zc_ObjectFloat_UnitCategory_PremiumImplPlan()

       WHERE Object_UnitCategory.DescId = zc_Object_UnitCategory()
         AND Object_UnitCategory.isErased = False) AS UnitCategory
     WHERE tmpImplementation.UnitCategoryId = UnitCategory.UnitCategoryId;

       -- Заполняем Норма человекодней
     UPDATE tmpResult SET NormOfManDays = COALESCE(tmpUserUnitDayTable.NormOfManDays, 0)
     FROM tmpUserUnitDayTable
     WHERE tmpResult.UserID = tmpUserUnitDayTable.UserID
       AND tmpResult.UnitID = tmpUserUnitDayTable.UnitID;

       -- Заполняем Факт человекодней
     UPDATE tmpResult SET FactOfManDays = COALESCE(tmpUserUnitDayTable.FactOfManDays, 0)
     FROM (SELECT tmpUserUnitDayTable.UserID,
            SUM(tmpUserUnitDayTable.FactOfManDays) AS FactOfManDays
         FROM tmpUserUnitDayTable AS tmpUserUnitDayTable
         GROUP BY tmpUserUnitDayTable.UserID) AS tmpUserUnitDayTable
     WHERE tmpResult.UserID = tmpUserUnitDayTable.UserID;

      -- Выбираем итоговою сумму штрафа и премии
     UPDATE tmpResult SET
        AmountTheFineTab = COALESCE(Implementation.AmountTheFineTab, 0),
        BonusAmountTab = COALESCE(Implementation.BonusAmountTab, 0),
        AddBonusPercentTab = COALESCE(Implementation.AddBonusPercentTab, 0),
        AddBonusPercentSum = COALESCE(Implementation.AddBonusPercentSum, 0)
     FROM (SELECT Implementation.UserID,
            Implementation.UnitID,
            SUM(Implementation.AmountTheFineTab) AS AmountTheFineTab,
            SUM(Implementation.BonusAmountTab) AS BonusAmountTab,
            SUM(Implementation.AddBonusPercentTab) AS AddBonusPercentTab,
            SUM(Implementation.AddBonusPercentSum) AS AddBonusPercentSum
         FROM tmpImplementation AS Implementation
            INNER JOIN (SELECT tmpResult.UnitID, tmpResult.UserID FROM tmpResult) AS T1
                      ON Implementation.UserID = T1.UserID
                     AND Implementation.UnitID = T1.UnitID
         GROUP BY Implementation.UserID, Implementation.UnitID) AS Implementation
     WHERE tmpResult.UserID = Implementation.UserID
       AND tmpResult.UnitID = Implementation.UnitID;

       -- Собираем Общий % выполнения построчный:
     UPDATE tmpResult SET
          TotalExecutionLine = ROUND(CASE WHEN Implementation.CountConsider <> 0 
                                          THEN 1.0 * Implementation.CountAmount / Implementation.CountConsider * 100 + 
                                               COALESCE (Implementation.CountFixedPercent * CASE WHEN UnitCategoryCode = 2
                                                                                                 THEN vbFixedPercentA
                                                                                                 WHEN UnitCategoryCode = 3
                                                                                                 THEN vbFixedPercentB
                                                                                                 WHEN UnitCategoryCode = 5
                                                                                                 THEN vbFixedPercentC
                                                                                                 WHEN UnitCategoryCode = 8
                                                                                                 THEN vbFixedPercentD
                                                                                                 ELSE 0 END, 0)
                                          ELSE 0 END, 2)
        , TotalExecutionFixed = ROUND(CASE WHEN Implementation.CountConsiderFixed <> 0
                                           THEN 1.0 * Implementation.CountAmountFixed / Implementation.CountConsiderFixed * 100
                                           ELSE 0 END, 2)
        , CountAmount   = Implementation.CountAmount
        , CountConsider = Implementation.CountConsider
        , CountRecord   = Implementation.CountRecord
        , FixedPercent  = COALESCE (Implementation.CountFixedPercent * CASE WHEN UnitCategoryCode = 2
                                                                            THEN vbFixedPercentA
                                                                            WHEN UnitCategoryCode = 3
                                                                            THEN vbFixedPercentB
                                                                            WHEN UnitCategoryCode = 5
                                                                            THEN vbFixedPercentC
                                                                            WHEN UnitCategoryCode = 8
                                                                            THEN vbFixedPercentD
                                                                            ELSE 0 END, 0)
     FROM (SELECT Implementation.UserID  AS UserID,
             SUM(CASE WHEN Implementation.Amount > 0 AND Implementation.AmountPlanTab > 0 AND
                 Implementation.Amount >= Implementation.AmountPlanTab then 1 else 0 end)::Integer  AS CountAmount,
             SUM(CASE WHEN Implementation.AmountPlanTab >= 0.1 then 1 else 0 end)::Integer          AS CountConsider,
             SUM(CASE WHEN COALESCE(Implementation.isFixedPercent, False) = TRUE AND
                 Implementation.Amount > 0 AND Implementation.AmountPlanTab > 0 AND
                 Implementation.Amount >= Implementation.AmountPlanTab then 1 else 0 end)::Integer  AS CountFixedPercent,
             SUM(CASE WHEN Implementation.Amount > 0 AND Implementation.AmountPlanTab > 0 AND Implementation.isFixedPercent = True AND
                 Implementation.Amount >= Implementation.AmountPlanTab then 1 else 0 end)::Integer  AS CountAmountFixed,
             SUM(CASE WHEN Implementation.AmountPlanTab >= 0.1 AND Implementation.isFixedPercent = True then 1 else 0 end)::Integer AS CountConsiderFixed,
             Count(*)::Integer                                                                      AS CountRecord
           FROM
             (WITH tmpPromoUnitKoeff AS (SELECT MI_PromoUnit.ObjectId                             AS GoodsId
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
                                            
              SELECT Implementation.UserID AS UserID,
                     Sum(Implementation.Amount) AS Amount,
                     MAX(Implementation.AmountPlanTab) AS AmountPlanTab,
                     SUM(CASE WHEN COALESCE(Implementation.isFixedPercent, False) = TRUE then 1 else 0 end)::Integer > 0 AS isFixedPercent
              FROM tmpImplementation AS Implementation
                   INNER JOIN (SELECT tmpResult.UnitID, tmpResult.UserID FROM tmpResult) AS T1
                           ON Implementation.UserID = T1.UserID
                          AND Implementation.UnitID = T1.UnitID
                   LEFT JOIN tmpPromoUnitKoeff AS PromoUnitKoeff 
                                               ON PromoUnitKoeff.GoodsId = Implementation.GoodsId 
                GROUP BY Implementation.UserID, Implementation.GoodsId) AS Implementation
           GROUP BY Implementation.UserID) AS Implementation
     WHERE tmpResult.UserID = Implementation.UserID;
     
     IF inStartDate >= '01.09.2023'
     THEN
        -- Оставляем только 70 % бонуса
       UPDATE tmpResult SET BonusAmountTab = CASE WHEN tmpResult.BonusAmountTab - COALESCE(tmpResult.AddBonusPercentTab * 0.30, 0) > 0
                                                  THEN tmpResult.BonusAmountTab - COALESCE(tmpResult.AddBonusPercentTab * 0.30, 0) ELSE 0 END
                          , AddBonusPercentTab = tmpResult.AddBonusPercentTab * 0.7
                          , AddBonusPercentSum = tmpResult.AddBonusPercentSum * 0.7        
       WHERE tmpResult.FixedPercent < 45;

     END IF;
     
      -- Расчет итогов
--     UPDATE tmpResult SET Total = CASE WHEN tmpResult.TotalExecutionLine >= UnitCategory.MinLineByLineImplPlan THEN
--              tmpResult.BonusAmountTab - tmpResult.AmountTheFineTab ELSE 0 END
     UPDATE tmpResult SET Total = zfCalc_MarketingPlan_Scale (UnitCategory.ScaleCalcMarketingPlanID
                                                            , vbDateStart
                                                            , tmpResult.UnitId
                                                            , tmpResult.TotalExecutionLine
                                                            , tmpResult.TotalExecutionFixed
                                                            , tmpResult.AmountTheFineTab
                                                            , tmpResult.BonusAmountTab
                                                            , tmpResult.AddBonusPercentTab
                                                            , tmpResult.AddBonusPercentSum
                                                            , tmpResult.isNewUser
                                                            , tmpResult.isCashier
                                                            , vbisAdmin
                                                            ) 
     FROM (SELECT
            ObjectLink_Unit_Category.ObjectId                            AS UnitId
          , ObjectFloat_MinLineByLineImplPlan.ValueData                  AS MinLineByLineImplPlan
          , ObjectLink_UnitCategory_ScaleCalcMarketingPlan.ChildObjectId AS ScaleCalcMarketingPlanID
       FROM Object AS Object_UnitCategory

           INNER JOIN ObjectLink AS ObjectLink_Unit_Category
                                 ON ObjectLink_Unit_Category.ChildObjectId = Object_UnitCategory.Id
                                AND ObjectLink_Unit_Category.DescId = zc_ObjectLink_Unit_Category()

           LEFT JOIN ObjectLink AS ObjectLink_UnitCategory_ScaleCalcMarketingPlan
                                ON ObjectLink_UnitCategory_ScaleCalcMarketingPlan.ObjectId = Object_UnitCategory.Id
                               AND ObjectLink_UnitCategory_ScaleCalcMarketingPlan.DescId = zc_ObjectLink_UnitCategory_ScaleCalcMarketingPlan()

           LEFT JOIN ObjectFloat AS ObjectFloat_MinLineByLineImplPlan
                                 ON ObjectFloat_MinLineByLineImplPlan.ObjectId = Object_UnitCategory.Id
                                AND ObjectFloat_MinLineByLineImplPlan.DescId = zc_ObjectFloat_UnitCategory_MinLineByLineImplPlan()

       WHERE Object_UnitCategory.DescId = zc_Object_UnitCategory()
         AND Object_UnitCategory.isErased = False) AS UnitCategory         
     WHERE tmpResult.UnitId = UnitCategory.UnitId;

       -- Результат
     RETURN QUERY
     WITH tmpUnitCategory AS (SELECT ObjectLink_Unit_Category.ObjectId              AS UnitId
                                   , Object_UnitCategory.ValueData                  AS UnitCategoryName
                                 FROM Object AS Object_UnitCategory

                                     INNER JOIN ObjectLink AS ObjectLink_Unit_Category
                                                           ON ObjectLink_Unit_Category.ChildObjectId = Object_UnitCategory.Id
                                                          AND ObjectLink_Unit_Category.DescId = zc_ObjectLink_Unit_Category()

                                 WHERE Object_UnitCategory.DescId = zc_Object_UnitCategory()
                                   AND Object_UnitCategory.isErased = False)

     SELECT
        Result.ID::Integer,
        Result.UserID,
        Result.UserName,
        Result.UnitID,
        Result.UnitName,
        tmpUnitCategory.UnitCategoryName,
        Result.NormOfManDays,
        Result.FactOfManDays,
        Result.TotalExecutionLine,
        Result.TotalExecutionFixed,
        Result.AmountTheFineTab,
        Result.BonusAmountTab,
        Result.Total,
        CASE WHEN date_part('day', vbDateStart - tmpUser.DateIn)::INTEGER > 0 
             THEN date_part('day', vbDateStart - tmpUser.DateIn)::INTEGER 
             ELSE 0 END::INTEGER                                                                                                        AS DaysWorked,
        Personal_View.PositionName AS PositionName,
        Personal_View.isReleasedMarketingPlan,
        Result.CountAmount,
        Result.CountConsider,
        Result.CountRecord,
        Result.FixedPercent,
        Result.AddBonusPercentTab,
        Result.AddBonusPercentSum

     FROM tmpResult AS Result 

          LEFT JOIN tmpUser ON tmpUser.UserID = Result.UserID

          LEFT JOIN tmpUnitCategory ON tmpUnitCategory.UnitId = Result.UnitId
          
          LEFT JOIN tmPersonal_View AS Personal_View 
                                    ON Personal_View.UserID =  Result.UserId
                                   AND Personal_View.Ord = 1  
          
     ORDER BY Result.ID;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 15.10.19         *
 17.10.18         *
 13.10.18         *
 05.10.18         *
 05.09.18         *
 01.08.18         *
 15.07.18         *
 06.07.18         *
 01.06.18         *
*/

-- тест
-- select * from gpReport_ImplementationPlanEmployeeAll(inStartDate := ('21.09.2019')::TDateTime ,  inSession := '3');


select * from gpReport_ImplementationPlanEmployeeAll(inStartDate := ('01.10.2023')::TDateTime ,  inSession := '3');