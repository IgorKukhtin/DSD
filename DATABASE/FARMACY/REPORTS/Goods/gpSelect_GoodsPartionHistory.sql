-- Function: gpSelect_GoodsPartionHistory()

DROP FUNCTION IF EXISTS gpSelect_GoodsPartionHistory (Integer, Integer, Integer, TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsPartionHistory(
    IN inPartyId          Integer  ,  -- Партия
    IN inGoodsId          Integer  ,  -- Товар
    IN inUnitId           Integer  ,  -- Подразделение
    IN inStartDate        TDateTime,  -- Дата начала периода
    IN inEndDate          TDateTime,  -- Дата окончания периода
    IN inIsPartion        Boolean  ,  -- оказать партию да/нет
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (
    ContainerId      Integer,   --ИД
    MovementId       Integer,   --ИД накдалдной
    OperDate         TDateTime, --Дата документа
    InvNumber        TVarChar,  --№ документа
    MovementDescId   Integer,   --Тип накладной
    MovementDescName TVarChar,  --Название типа накладной
    FromId           Integer,   --От кого
    FromName         TVarChar,  --От кого (Название)
    ToId             Integer,   -- Кому
    ToName           TVarChar,  -- Кому (Название)
    Price            TFloat,    --Цена в документе
    Summa            TFloat,    --Сумма в документе
    AmountIn         TFloat,    --Кол-во приход
    AmountOut        TFloat,    --Кол-во расход
    AmountInvent     TFloat,    --Кол-во переучет
    Saldo            TFloat,    --Остаток после операции
    MCSValue         TFloat,    --НТЗ
    MCS_GoodsCategory TFloat,   -- НТЗ из ассортиментной матрицы
    CheckMember      TVarChar,  --Менеджер
    Bayer            TVarChar,  --Покупатель
    PartyId          Integer,
    PartionInvNumber TVarChar,  --№ документа партии
    PartionOperDate  TDateTime, --Дата документа партии
    PartionDescName  TVarChar,  --вид документа партии
    PartionPrice     TFloat,    --цена партии
    PartionGoods     TVarChar,  --Серия
    InsertName       TVarChar,  --Пользователь(созд.)
    InsertDate       TDateTime, --Дата(созд.)
    ExpirationDate   TDateTime,  -- срок годности
    PartionDateKindName TVarChar, -- категория срока годности
    isSUN            Boolean,
    isDefSUN         Boolean
  )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;

   DECLARE vbDay_0    Integer;
   DECLARE vbDay_1    Integer;
   DECLARE vbDay_6    Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbDate180  TDateTime;
   DECLARE vbDate30   TDateTime;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    -- Контролшь использования подразделения
    inUnitId := gpGet_CheckingUser_Unit(inUnitId, inSession);

    -- определяется <Торговая сеть>
    IF vbUserId = 3 AND COALESCE (inUnitId, 0) <> 0 THEN vbObjectId:= 0;
    ELSE vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);
    END IF;


    vbDay_0 := (SELECT COALESCE(ObjectFloat_Day.ValueData, 0)::Integer
                FROM Object  AS Object_PartionDateKind
                     LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                           ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                          AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_0());
    vbDay_1 := (SELECT ObjectFloat_Day.ValueData::Integer
                FROM Object  AS Object_PartionDateKind
                     LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                           ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                          AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_1());
    vbDay_6 := (SELECT ObjectFloat_Day.ValueData::Integer
                FROM Object  AS Object_PartionDateKind
                     LEFT JOIN ObjectFloat AS ObjectFloat_Day
                                           ON ObjectFloat_Day.ObjectId = Object_PartionDateKind.Id
                                          AND ObjectFloat_Day.DescId = zc_ObjectFloat_PartionDateKind_Day()
                WHERE Object_PartionDateKind.Id = zc_Enum_PartionDateKind_6());

    -- даты + 6 месяцев, + 1 месяц
    vbDate180 := CURRENT_DATE + (vbDay_6||' DAY' ) ::INTERVAL;
    vbDate30  := CURRENT_DATE + (vbDay_1||' DAY' ) ::INTERVAL;
    vbOperDate:= CURRENT_DATE + (vbDay_0||' DAY' ) ::INTERVAL;

    -- Результат
    RETURN QUERY
        WITH
        _tmpUnit AS (-- !!!Все подразделения сети!!!!
                     SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitID
                     FROM ObjectLink AS ObjectLink_Unit_Juridical

                          INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                               AND (ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId OR vbObjectId = 0)

                     WHERE ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                       AND (ObjectLink_Unit_Juridical.ObjectId = inUnitId OR inUnitId = 0
                            AND EXISTS(SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin()))
                     )
      ---
      , _tmpGoods AS (-- !!!временно захардкодил, будут все сети!!!!
                      SELECT ObjectLink_Child_ALL.ChildObjectId AS GoodsId
                      FROM ObjectLink AS ObjectLink_Child
                                        INNER JOIN  ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                                 AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                                        INNER JOIN ObjectLink AS ObjectLink_Main_ALL ON ObjectLink_Main_ALL.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                                    AND ObjectLink_Main_ALL.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                                        INNER JOIN ObjectLink AS ObjectLink_Child_ALL ON ObjectLink_Child_ALL.ObjectId = ObjectLink_Main_ALL.ObjectId
                                                                                     AND ObjectLink_Child_ALL.DescId   = zc_ObjectLink_LinkGoods_Goods()
                                        INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                                              ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_ALL.ChildObjectId
                                                             AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                                             AND (ObjectLink_Goods_Object.ChildObjectId = vbObjectId OR vbObjectId = 0)
                                        INNER JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Goods_Object.ChildObjectId
                                                                          AND Object_Retail.DescId = zc_Object_Retail()
                      WHERE ObjectLink_Child.ChildObjectId = inGoodsId
                        AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                     )
      ---
      , tmpRemains_All AS (SELECT Container.Id       AS ContainerId
                                , Container.ObjectId AS GoodsId
                                , Container.Amount - COALESCE(SUM(MovementItemContainer.Amount),0) AS AmountStart
                                , Container.Amount - COALESCE(SUM(CASE WHEN DATE_TRUNC ('DAY', MovementItemContainer.OperDate) > inEndDate THEN MovementItemContainer.Amount ELSE 0 END),0) AS AmountEnd
                           FROM _tmpGoods AS tmp
                               INNER JOIN _tmpUnit ON 1 = 1
                               INNER JOIN Container ON Container.DescId   = zc_Container_Count()
                                                   AND Container.ObjectId = tmp.GoodsId
                                                   AND Container.WhereObjectId = _tmpUnit.UnitId
                               LEFT OUTER JOIN ContainerLinkObject AS CLO_Party
                                                                   ON CLO_Party.containerid = container.id
                                                                  AND CLO_Party.descid = zc_ContainerLinkObject_PartionMovementItem()
                               LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                                    -- AND DATE_TRUNC ('DAY', MovementItemContainer.OperDate) >= inStartDate
                                                                    AND MovementItemContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                           WHERE (CLO_Party.ObjectId = inPartyId
                               OR COALESCE (inPartyId, 0) = 0
                                  )
                           GROUP BY Container.Amount
                                  , Container.Id
                                  , Container.ObjectId
                           )

      , tmpRemains AS (SELECT CASE WHEN inIsPartion = TRUE THEN Remains.ContainerId ELSE 0 END AS ContainerId
                            , SUM (Remains.AmountStart) AS RemainsStart
                            , SUM (Remains.AmountEnd)   AS RemainsEnd
                       FROM tmpRemains_All AS Remains
                       GROUP BY CASE WHEN inIsPartion = TRUE THEN Remains.ContainerId ELSE 0 END
                       )

      , tmpRemains_ord AS (SELECT *
                                , ROW_NUMBER() OVER(ORDER BY ABS (tmp.RemainsStart) DESC, tmp.ContainerId DESC) AS num
                           FROM tmpRemains AS tmp
                           )

      , _tmpRem AS (SELECT tmp.ContainerId
                         , tmp.RemainsStart
                         , tmp.RemainsEnd
                    FROM tmpRemains_ord AS tmp
                    WHERE tmp.RemainsStart <> 0 OR tmp.RemainsEnd <> 0 OR tmp.num = 1
                    )
      ---

      , tmpPrice AS (SELECT ObjectLink_Price_Unit.ChildObjectId    AS UnitId
                        , Price_Goods.ChildObjectId                AS GoodsId
                        , MCS_Value.ValueData                      AS MCSValue
                     FROM ObjectLink AS ObjectLink_Price_Unit

                        INNER JOIN _tmpUnit ON _tmpUnit.UnitId = ObjectLink_Price_Unit.ChildObjectId

                        INNER JOIN ObjectLink AS Price_Goods
                                              ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                             AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()

                        INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = Price_Goods.ChildObjectId


                        LEFT JOIN ObjectFloat AS MCS_Value
                                              ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                             AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()

                    WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                    )

      , tmpContainer_Rem AS (SELECT Container.*
                             FROM Container
                             WHERE Container.Id IN (SELECT DISTINCT _tmpRem.ContainerId FROM _tmpRem)
                             )
      , tmpCLO_Party_Rem AS (SELECT CLO_Party.*
                         FROM ContainerLinkObject AS CLO_Party
                         WHERE CLO_Party.ContainerId IN (SELECT DISTINCT tmpContainer_Rem.Id FROM tmpContainer_Rem)
                           AND CLO_Party.descid = zc_ContainerLinkObject_PartionMovementItem()
                         )
      , tmpRem_All AS (SELECT _tmpRem.ContainerId
                            , CASE WHEN COALESCE(inUnitId, 0) <> 0 THEN Max(tmpPrice.MCSValue) ELSE Null END AS MCSValue
                            , CLO_Party.ObjectId   AS PartyId
                            , SUM(_tmpRem.RemainsStart) AS RemainsStart
                            , SUM(_tmpRem.RemainsEnd)   AS RemainsEnd
                       FROM _tmpRem
                           LEFT JOIN tmpContainer_Rem ON tmpContainer_Rem.Id = _tmpRem.ContainerId
                           LEFT OUTER JOIN tmpPrice ON tmpPrice.GoodsId = COALESCE (tmpContainer_Rem.ObjectId, inGoodsId)
                           LEFT OUTER JOIN tmpCLO_Party_Rem AS CLO_Party ON CLO_Party.containerid = tmpContainer_Rem.Id
                       GROUP BY _tmpRem.ContainerId
                              , CLO_Party.ObjectId
                       )

      , tmpRES AS (
            SELECT MovementItemContainer.ContainerId                     AS ContainerId,
                   Movement.Id                                           AS MovementId,   --ИД накдалдной
                   MovementItemContainer.OperDate                        AS OperDate,     --Дата документа
                   Movement.InvNumber                                    AS InvNumber,    --№ документа
                   MovementDesc.Id                                       AS MovementDescId,    --Тип накладной
                   MovementDesc.ItemName                                 AS MovementDescName,  --Название типа накладной
                   COALESCE(Object_From.Id,Object_Unit.ID)               AS FromId,       --От кого
                   COALESCE(Object_From.ValueData,Object_Unit.ValueData) AS FromName,     --От кого (Название)
                   COALESCE(Object_To.Id,Object_Unit.ID)                 AS ToId,         -- Кому
                   COALESCE(Object_To.ValueData,Object_Unit.ValueData)   AS ToName,       -- Кому (Название)
                   MIFloat_Price.ValueData                               AS Price,        -- Цена в документе
                   ABS(MIFloat_Price.ValueData * MovementItemContainer.Amount) AS Summa,  -- Сумма в документе
                   CASE
                     WHEN MovementItemContainer.Amount > 0
                          AND
                          Movement.DescId <> zc_Movement_Inventory()
                       THEN MovementItemContainer.Amount
                   ELSE 0.0 END::TFloat                                  AS AmountIn,    --Кол-во приход
                   CASE
                     WHEN MovementItemContainer.Amount < 0
                          AND
                          Movement.DescId <> zc_Movement_Inventory()
                       THEN ABS(MovementItemContainer.Amount)
                   ELSE 0.0
                   END::TFloat                                           AS AmountOut,    --Кол-во расход
                   CASE
                     WHEN Movement.DescId = zc_Movement_Inventory()
                       THEN MovementItemContainer.Amount
                   ELSE 0.0
                   END::TFloat                                           AS AmountInvent, --Кол-во переучет
                   Object_Price_View.MCSValue                            AS MCSValue,     --НТЗ
                   Object_CheckMember.ValueData                          AS CheckMember,  --Менеджер
                   COALESCE(Object_BuyerForSite.ValueData,
                            MovementString_Bayer.ValueData)              AS Bayer,        --Покупатель
                   CLO_Party.ObjectID                                    AS PartyId,      --# партии
                   ROW_NUMBER() OVER(ORDER BY MovementItemContainer.OperDate,
                                              CASE WHEN MovementDesc.Id = zc_Movement_Inventory() THEN 1 else 0 end,
                                              CASE WHEN MovementItemContainer.Amount > 0 THEN 0 ELSE 0 END,
                                              MovementItemContainer.MovementId,MovementItemContainer.MovementItemId,CLO_Party.ObjectID) AS OrdNum,
                   (SUM(MovementItemContainer.Amount)OVER(ORDER BY MovementItemContainer.OperDate,
                                                                   CASE WHEN MovementDesc.Id = zc_Movement_Inventory() THEN 1 else 0 end,
                                                                   CASE WHEN MovementItemContainer.Amount > 0 THEN 0 ELSE 0 END,
                                                                   MovementItemContainer.MovementId,MovementItemContainer.MovementItemId,CLO_Party.ObjectID)) + _tmpRem.RemainsStart AS Saldo,
                   Object_Insert.ValueData                               AS InsertName,
                   MovementDate_Insert.ValueData                         AS InsertDate,
                   COALESCE (MovementBoolean_SUN.ValueData, FALSE)      ::Boolean  AS isSUN,
                   COALESCE (MovementBoolean_DefSUN.ValueData, FALSE)   ::Boolean  AS isDefSUN
            FROM _tmpGoods AS tmp
                INNER JOIN _tmpUnit ON 1 = 1
                INNER JOIN Container ON Container.ObjectId = tmp.GoodsId
                                    AND Container.DescId = zc_Container_Count()
                                    AND Container.WhereObjectId = _tmpUnit.UnitId
                LEFT JOIN _tmpRem ON _tmpRem.ContainerId = Container.Id OR _tmpRem.ContainerId = 0

                INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                AND MovementItemContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate) AND MovementItemContainer.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'

                INNER JOIN Movement ON MovementItemContainer.MovementId = Movement.Id
                INNER JOIN MovementDesc ON Movement.DescId = MovementDesc.Id

                LEFT OUTER JOIN ContainerLinkObject AS CLO_Party
                                                    ON CLO_Party.containerid = container.id
                                                   AND CLO_Party.descid = zc_ContainerLinkObject_PartionMovementItem()

                LEFT OUTER JOIN MovementLinkObject AS MovementLinkObject_From
                                                   ON MovementLinkObject_From.MovementId = Movement.Id
                                                  AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT OUTER JOIN Object AS Object_From
                                       ON MovementLinkObject_From.ObjectId = Object_From.Id

                LEFT OUTER JOIN MovementLinkObject AS MovementLinkObject_To
                                                   ON MovementLinkObject_To.MovementId = Movement.Id
                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT OUTER JOIN Object AS Object_To
                                       ON MovementLinkObject_To.ObjectId = Object_To.Id

                LEFT OUTER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                   ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                LEFT OUTER JOIN Object AS Object_Unit
                                       ON MovementLinkObject_Unit.ObjectId = Object_Unit.Id

                LEFT OUTER JOIN tmpPrice AS Object_Price_View
                                         ON Object_Price_View.UnitId = _tmpUnit.UnitId
                                        AND Object_Price_View.GoodsId = inGoodsId

                LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MovementItemContainer.MovementItemId
                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()

                LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                             ON MovementLinkObject_CheckMember.MovementId = MovementItemContainer.MovementId
                                            AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
                LEFT JOIN Object AS Object_CheckMember ON Object_CheckMember.Id = MovementLinkObject_CheckMember.ObjectId
                LEFT JOIN MovementString AS MovementString_Bayer
                                         ON MovementString_Bayer.MovementId = Movement.Id
                                        AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
                LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
                                             ON MovementLinkObject_BuyerForSite.MovementId = Movement.Id
                                            AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
                LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
                -- Пользователь(созд.) + Дата(созд.)
                LEFT JOIN MovementDate AS MovementDate_Insert
                                       ON MovementDate_Insert.MovementId = Movement.Id
                                      AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

                LEFT JOIN MovementLinkObject AS MLO_Insert
                                             ON MLO_Insert.MovementId = Movement.Id
                                            AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
                LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

                LEFT JOIN MovementBoolean AS MovementBoolean_SUN
                                          ON MovementBoolean_SUN.MovementId = Movement.Id
                                         AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN()
                                         AND Movement.DescId = zc_Movement_Send()
                LEFT JOIN MovementBoolean AS MovementBoolean_DefSUN
                                          ON MovementBoolean_DefSUN.MovementId = Movement.Id
                                         AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN()
                                         AND Movement.DescId = zc_Movement_Send()
            WHERE (CLO_Party.ObjectID = inPartyId OR inPartyId = 0))
      , RES AS
           (
            SELECT tmpRES.ContainerId,
                   tmpRES.MovementId,        --ИД накдалдной
                   tmpRES.OperDate,          --Дата документа
                   tmpRES.InvNumber,         --№ документа
                   tmpRES.MovementDescId,    --Тип накладной
                   tmpRES.MovementDescName,  --Название типа накладной
                   tmpRES.FromId,            --От кого
                   tmpRES.FromName,          --От кого (Название)
                   tmpRES.ToId,              -- Кому
                   tmpRES.ToName,            -- Кому (Название)
                   tmpRES.Price,             -- Цена в документе
                   tmpRES.Summa,             -- Сумма в документе
                   tmpRES.AmountIn,          --Кол-во приход
                   tmpRES.AmountOut,         --Кол-во расход
                   tmpRES.AmountInvent,      --Кол-во переучет
                   tmpRES.MCSValue,          --НТЗ
                   tmpRES.CheckMember,       --Менеджер
                   tmpRES.Bayer,             --Покупатель
                   tmpRES.PartyId,           --# партии
                   tmpRES.OrdNum,
                   tmpRES.Saldo,
                   tmpRES.InsertName,
                   tmpRES.InsertDate,
                   tmpRES.isSUN,
                   tmpRES.isDefSUN
            FROM tmpRES
          UNION ALL
            SELECT tmpRem_All.ContainerId     AS ContainerId,
                   NULL                       AS MovementId,    --ИД накдалдной
                   inStartDate                AS OperDate,      --Дата документа
                   NULL                       AS InvNumber,     --№ документа
                   NULL                       AS MovementDescId,    --Тип накладной
                   'Остаток на начало'        AS MovementDescName,  --Название типа накладной
                   NULL                       AS FromId,        --От кого
                   NULL                       AS FromName,      --От кого (Название)
                   NULL                       AS ToId,          -- Кому
                   NULL                       AS ToName,        -- Кому (Название)
                   NULL::TFloat               AS Price,         --Цена в документе
                   NULL::TFloat               AS Summa,         --Сума в документе
                   NULL                       AS AmountIn,      --Кол-во приход
                   NULL                       AS AmountOut,     --Кол-во расход
                   NULL                       AS AmountInvent,  --Кол-во переучет
                   tmpRem_All.MCSValue        AS MCSValue,      --НТЗ
                   NULL                       AS CheckMember,   --Менеджер
                   NULL                       AS Bayer,         --Покупатель
                   tmpRem_All.PartyId         AS PartyId,       --# партии
                   0                          AS OrdNum,
                   tmpRem_All.RemainsStart    AS Saldo,
                   NULL                       AS InsertName,
                   NULL                       AS InsertDate,
                   FALSE           ::Boolean  AS isSUN,
                   FALSE           ::Boolean  AS isDefSUN
            FROM tmpRem_All
          UNION ALL
            SELECT tmpRem_All.ContainerId     AS ContainerId,
                   NULL                       AS MovementId,   --ИД накдалдной
                   DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY' - INTERVAL '1 second' AS OperDate,     --Дата документа
                   NULL                       AS InvNumber,    --№ документа
                   NULL                       AS MovementDescId,    --Тип накладной
                   'Остаток на конец'         AS MovementDescName,  --Название типа накладной
                   NULL                       AS FromId,       --От кого
                   NULL                       AS FromName,     --От кого (Название)
                   NULL                       AS ToId,         -- Кому
                   NULL                       AS ToName,       -- Кому (Название)
                   NULL::TFloat               AS Price,        --Цена в документе
                   NULL::TFloat               AS Summa,        --Сума в документе
--                   tmpAmount.AmountIn         AS AmountIn,     --Кол-во приход
--                   tmpAmount.AmountOut        AS AmountOut,    --Кол-во расход
--                   tmpAmount.AmountInvent     AS AmountInvent, --Кол-во переучет
                   NULL::TFloat               AS AmountIn,     --Кол-во приход
                   NULL::TFloat               AS AmountOut,    --Кол-во расход
                   NULL::TFloat               AS AmountInvent, --Кол-во переучет
                   tmpRem_All.MCSValue        AS MCSValue,     --НТЗ
                   NULL                       AS CheckMember,  --Менеджер
                   NULL                       AS Bayer,        --Покупатель
                   tmpRem_All.PartyId         AS PartyId,      --# партии
                   999999999                  AS OrdNum,
                   tmpRem_All.RemainsEnd      AS Saldo,
                   NULL                       AS InsertName,
                   NULL                       AS InsertDate,
                   FALSE           ::Boolean  AS isSUN,
                   FALSE           ::Boolean  AS isDefSUN
            FROM tmpRem_All
                 LEFT JOIN (SELECT Sum(tmpRES.AmountIn) AS AmountIn,          --Кол-во приход
                                   Sum(tmpRES.AmountOut) AS AmountOut,        --Кол-во расход
                                   Sum(tmpRES.AmountInvent) AS AmountInvent   --Кол-во переучет
                            FROM tmpRES) AS tmpAmount ON 1 = 1
           )


        -- данные из ассорт. матрицы
      , tmpGoodsCategory AS (SELECT ObjectLink_Child_retail.ChildObjectId       AS GoodsId
                                  , ObjectLink_GoodsCategory_Unit.ChildObjectId AS UnitId
                                  , ObjectFloat_Value.ValueData                 AS Value
                             FROM Object AS Object_GoodsCategory
                                 INNER JOIN ObjectLink AS ObjectLink_GoodsCategory_Unit
                                                       ON ObjectLink_GoodsCategory_Unit.ObjectId = Object_GoodsCategory.Id
                                                      AND ObjectLink_GoodsCategory_Unit.DescId = zc_ObjectLink_GoodsCategory_Unit()
                                 INNER JOIN _tmpUnit ON _tmpUnit.UnitId = ObjectLink_GoodsCategory_Unit.ChildObjectId
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
                                 INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = ObjectLink_Child_retail.ChildObjectId
                             WHERE Object_GoodsCategory.DescId = zc_Object_GoodsCategory()
                               AND Object_GoodsCategory.isErased = FALSE
                             )

      , tmpData AS (SELECT Res.*
                         , COALESCE(Movement_Party.InvNumber, NULL) ::TVarChar  AS PartionInvNumber  -- № док.партии
                         , COALESCE(Movement_Party.OperDate, NULL)  ::TDateTime AS PartionOperDate   -- Дата док.партии
                         , COALESCE(MovementDesc.ItemName, NULL)    ::TVarChar  AS PartionDescName
                         , COALESCE(MIFloat_Price.ValueData, NULL)  ::TFloat    AS PartionPrice
                         , COALESCE(MIString_PartionGoods.ValueData, NULL)  ::TVarChar    AS PartionGoods
                         , CASE WHEN inIsPartion = True THEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) ELSE NULL END ::TDateTime  AS ExpirationDate
                         , CASE WHEN inIsPartion = TRUE
                                THEN CASE WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbOperDate THEN zc_Enum_PartionDateKind_0()
                                          WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) > vbOperDate AND COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate30 THEN zc_Enum_PartionDateKind_1()
                                          WHEN COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) > vbDate30   AND COALESCE (MIDate_ExpirationDate.ValueData, zc_DateEnd()) <= vbDate180 THEN zc_Enum_PartionDateKind_6()
                                          ELSE 0
                                     END
                                ELSE 0
                           END                                                        AS PartionDateKindId
                       FROM Res
                          LEFT JOIN Object AS Object_PartionMovementItem
                                           ON Object_PartionMovementItem.Id = Res.PartyId --CLI_MI.ObjectId
                                           AND inIsPartion = True
                          -- элемент прихода
                          LEFT JOIN MovementItem ON MovementItem.Id = Object_PartionMovementItem.ObjectCode :: Integer

                          LEFT JOIN Movement AS Movement_Party ON Movement_Party.Id = MovementItem.MovementId
                                                        --     AND inIsPartion = True
                          LEFT JOIN MovementDesc ON MovementDesc.Id = Movement_Party.DescId

                          -- если это партия, которая была создана инвентаризацией - в этом свойстве будет "найденный" ближайший приход от поставщика
                          LEFT JOIN MovementItemFloat AS MIFloat_MovementItem
                                                      ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                                     AND MIFloat_MovementItem.DescId = zc_MIFloat_MovementItemId()
                          -- элемента прихода от поставщика (если это партия, которая была создана инвентаризацией)
                          LEFT JOIN MovementItem AS MI_Income_find ON MI_Income_find.Id = (MIFloat_MovementItem.ValueData :: Integer)

                          LEFT OUTER JOIN MovementItemDate  AS MIDate_ExpirationDate
                                                            ON MIDate_ExpirationDate.MovementItemId = COALESCE (MI_Income_find.Id,MovementItem.Id)  --Object_PartionMovementItem.ObjectCode
                                                           AND MIDate_ExpirationDate.DescId = zc_MIDate_PartionGoods()

                          LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                                            ON MIFloat_Price.MovementItemId = COALESCE (MI_Income_find.Id,MovementItem.Id)
                                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()

                          LEFT OUTER JOIN MovementItemString AS MIString_PartionGoods
                                                             ON MIString_PartionGoods.MovementItemId = COALESCE (MI_Income_find.Id,MovementItem.Id)
                                                            AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()
                    )

        -- результат
        SELECT
            Res.ContainerId,
            Res.MovementId            ::Integer,           --ИД накдалдной
            Res.OperDate              ::TDateTime,         --Дата документа
            Res.InvNumber             ::TVarChar,          --№ документа
            Res.MovementDescId        ::Integer,           --Тип накладной
            Res.MovementDescName      ::TVarChar,          --Название типа накладной
            Res.FromId                ::Integer,           --От кого
            Res.FromName              ::TVarChar,          --От кого (Название)
            Res.ToId                  ::Integer,           -- Кому
            Res.ToName                ::TVarChar,          -- Кому (Название)
            Res.Price                 ::TFloat,            --Цена в документе
            Res.Summa                 ::TFloat,            --Сумма в документе
            NULLIF(Res.AmountIn,0)    ::TFloat,            --Кол-во приход
            NULLIF(Res.AmountOut,0)   ::TFloat,            --Кол-во расход
            NULLIF(Res.AmountInvent,0)::TFloat,            --Кол-во переучет
            Res.Saldo::TFloat,                             --Остаток после операции
            Res.MCSValue::TFloat,                          --НТЗ
            tmpGoodsCategory.Value    ::TFloat AS MCS_GoodsCategory,  --НТЗ  из ассортиментной матрица
            Res.CheckMember           ::TVarChar,          --Менеджер
            Res.Bayer                 ::TVarChar,          --Покупатель
            Res.PartyId ,                                  --# партии
            Res.PartionInvNumber      ::TVarChar,          -- № док.партии
            Res.PartionOperDate       ::TDateTime,         -- Дата док.партии
            Res.PartionDescName       ::TVarChar,
            Res.PartionPrice          ::TFloat,
            Res.PartionGoods          ::TVarChar,          --Серия
            Res.InsertName            ::TVarChar,          --Пользователь(созд.)
            Res.InsertDate            ::TDateTime,         --Дата(созд.)

            Res.ExpirationDate        ::TDateTime,
            Object_PartionDateKind.ValueData :: TVarChar AS PartionDateKindName,
            Res.isSUN                 ::Boolean,
            Res.isDefSUN              ::Boolean
        FROM tmpData AS Res

           LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = Res.PartionDateKindId

           LEFT JOIN tmpGoodsCategory ON tmpGoodsCategory.UnitId = Res.FromId

        ORDER BY Res.OrdNum;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.   Шаблий О.В.
 21.04.21                                                                                     * add BuyerForSite
 23.08.19         * isSUN,isDefSUN
 19.08.19         * add PartionDateKindName
 08.04.19         * add ExpirationDate
 24.05.18         * оптимизация
 07.01.17         *
 01.07.16         * add inIsPartion
 26.08.15                                                                       *
*/

-- тест
--select * from gpSelect_GoodsPartionHistory(inPartyId := 0 , inGoodsId := 18253 , inUnitId := 183292 , inStartDate := ('01.10.2015')::TDateTime , inEndDate := ('26.11.2016')::TDateTime , inIsPartion := 'False' ,  inSession := '3');
--select * from gpSelect_GoodsPartionHistory(inPartyId := 0 , inGoodsId := 59173 , inUnitId := 183292 , inStartDate := ('01.01.2018')::TDateTime , inEndDate := ('31.05.2018')::TDateTime , inIsPartion := 'False' ,  inSession := '3');
--select * from gpSelect_GoodsPartionHistory(inPartyId := 0 , inGoodsId := 59173 , inUnitId := 183292 , inStartDate := ('24.05.2018')::TDateTime , inEndDate := ('31.05.2018')::TDateTime , inIsPartion := 'False' ,  inSession := '3');


select * from gpSelect_GoodsPartionHistory(inPartyId := 0 , inGoodsId := 16790452 , inUnitId := 5120968 , inStartDate := ('01.12.2019')::TDateTime , inEndDate := ('08.04.2022')::TDateTime , inIsPartion := 'True' ,  inSession := '3');
