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
    MCSValue         TFloat,     --НТЗ
    CheckMember      TVarChar,  --Менеджер
    Bayer            TVarChar,  --Покупатель
    PartyId          Integer,
    PartionInvNumber TVarChar,  --№ документа партии
    PartionOperDate  TDateTime, --Дата документа партии
    PartionDescName  TVarChar,  --вид документа партии
    PartionPrice     TFloat,    --цена партии
    InsertName       TVarChar,  --Пользователь(созд.) 
    InsertDate       TDateTime  --Дата(созд.)
  )
AS
$BODY$
   DECLARE vbUserId Integer;
--   DECLARE vbRemainsStart TFloat;
--   DECLARE vbRemainsEnd TFloat;
   DECLARE vbObjectId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);


    -- определяется <Торговая сеть>
    IF vbUserId = 3 THEN vbObjectId:= 0;
    ELSE vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);
    END IF;


    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    INSERT INTO _tmpGoods (GoodsId)
       -- !!!временно захардкодил, будут все сети!!!!
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
         AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods();


    CREATE TEMP TABLE _tmpRem (ContainerId Integer, RemainsStart TFloat, RemainsEnd TFloat) ON COMMIT DROP;

    INSERT INTO _tmpRem (ContainerId, RemainsStart, RemainsEnd)
         WITH
         tmpRemains_All AS (SELECT Container.Id       AS ContainerId
                                 , Container.ObjectId AS GoodsId
                                 , Container.Amount - COALESCE(SUM(MovementItemContainer.Amount),0) AS AmountStart
                                 , Container.Amount - COALESCE(SUM(CASE WHEN DATE_TRUNC ('DAY', MovementItemContainer.OperDate) > inEndDate THEN MovementItemContainer.Amount ELSE 0 END),0) AS AmountEnd
                            FROM _tmpGoods AS tmp
                                INNER JOIN Container ON Container.DescId   = zc_Container_Count()
                                                    AND Container.ObjectId = tmp.GoodsId
                                INNER JOIN ContainerLinkObject AS CLO_Unit
                                                               ON CLO_Unit.ContainerId = Container.Id
                                                              AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                                              AND CLO_Unit.ObjectId = inUnitId
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
    --
    SELECT tmp.ContainerId
         , tmp.RemainsStart
         , tmp.RemainsEnd
    FROM tmpRemains_ord AS tmp
    WHERE tmp.RemainsStart <> 0 OR tmp.RemainsEnd <> 0 OR tmp.num = 1
    ;

    -- Результат
    RETURN QUERY
        WITH 
        
        tmpPrice (SELECT ObjectLink_Price_Unit.ChildObjectId    AS UnitId
                     , Price_Goods.ChildObjectId                AS GoodsId     
                     , MCS_Value.ValueData                      AS MCSValue
                  FROM ObjectLink AS ObjectLink_Price_Unit
                     LEFT JOIN ObjectLink AS Price_Goods
                                          ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                         AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()

                     INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = Price_Goods.ChildObjectId

                     LEFT JOIN ObjectFloat AS MCS_Value
                                           ON MCS_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                          AND MCS_Value.DescId = zc_ObjectFloat_Price_MCSValue()                                          

                 WHERE ObjectLink_Price_Unit.ChildObjectId = inUnitId
                   AND ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()   
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
                            , tmpPrice.MCSValue
                            , CLO_Party.ObjectID   AS PartyId
                            , _tmpRem.RemainsStart
                            , _tmpRem.RemainsEnd
                       FROM _tmpRem
                           LEFT JOIN tmpContainer_Rem ON tmpContainer_Rem.Id = _tmpRem.ContainerId
                           LEFT OUTER JOIN tmpPrice ON tmpPrice.GoodsId = COALESCE (tmpContainer_Rem.ObjectId, inGoodsId)
                           LEFT OUTER JOIN tmpCLO_Party_Rem AS CLO_Party ON CLO_Party.containerid = tmpContainer_Rem.Id 
                       )

      ----
      , tmpContainer AS (SELECT Container.Id
                         FROM _tmpGoods AS tmp
                               INNER JOIN Container ON Container.ObjectId = tmp.GoodsId
                                                   AND Container.DescId = zc_Container_Count()
                               INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                                             AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                                                             AND ContainerLinkObject.ObjectId = inUnitId
                        )

      , tmpCLO_Party AS (SELECT CLO_Party.*
                         FROM ContainerLinkObject AS CLO_Party
                         WHERE CLO_Party.ContainerId IN (SELECT DISTINCT tmpContainer.Id FROM tmpContainer)
                           AND CLO_Party.descid = zc_ContainerLinkObject_PartionMovementItem() 
                         )

      , tmpMIContainer AS (SELECT tmpContainer.Id                AS ContainerId
                                , MovementItemContainer.OperDate
                                , MovementItemContainer.MovementId
                                , MovementItemContainer.MovementItemId
                                , MovementItemContainer.Amount
                           FROM tmpContainer
                                INNER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = tmpContainer.Id
                                                                AND MovementItemContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate) 
                                                                AND MovementItemContainer.OperDate <  DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                           )

      , tmpMovement AS (SELECT Movement.*
                        FROM Movement
                        WHERE Movement.Id IN (SELECT DISTINCT tmpMIContainer.MovementId FROM tmpMIContainer)
                        )

      , tmpMLO AS (SELECT MovementLinkObject.*
                   FROM MovementLinkObject
                   WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                     AND MovementLinkObject.DescId IN (zc_MovementLinkObject_From()
                                                     , zc_MovementLinkObject_To()
                                                     , zc_MovementLinkObject_Unit()
                                                     , zc_MovementLinkObject_CheckMember()
                                                     , zc_MovementLinkObject_Insert() )
                   )

      , tmpObject AS (SELECT Object.*
                      FROM Object
                      WHERE Object.Id IN (SELECT DISTINCT tmpMLO.ObjectId FROM tmpMLO)
                       )

      , tmpMovementDate AS (SELECT MovementDate_Insert.*
                            FROM MovementDate AS MovementDate_Insert
                            WHERE MovementDate_Insert.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                           )

      , tmpMovementString AS (SELECT MovementString_Bayer.*
                              FROM  MovementString AS MovementString_Bayer
                              WHERE MovementString_Bayer.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
                              )

      , tmpMIFloat AS (SELECT MIFloat_Price.*
                       FROM MovementItemFloat AS MIFloat_Price 
                       WHERE MIFloat_Price.MovementItemId IN (SELECT DISTINCT tmpMIContainer.MovementItemId FROM tmpMIContainer)
                         AND MIFloat_Price.DescId = zc_MIFloat_Price()
                       )

      , tmpData AS (SELECT MovementItemContainer.ContainerId                     AS ContainerId
                         , Movement.Id                                           AS MovementId        --ИД накдалдной
                         , MovementItemContainer.OperDate                        AS OperDate          --Дата документа
                         , Movement.InvNumber                                    AS InvNumber         --№ документа
                         , MovementDesc.Id                                       AS MovementDescId    --Тип накладной
                         , MovementDesc.ItemName                                 AS MovementDescName  --Название типа накладной
                         , COALESCE(Object_From.Id,Object_Unit.ID)               AS FromId            --От кого
                         , COALESCE(Object_From.ValueData,Object_Unit.ValueData) AS FromName          --От кого (Название)
                         , COALESCE(Object_To.Id,Object_Unit.ID)                 AS ToId              -- Кому
                         , COALESCE(Object_To.ValueData,Object_Unit.ValueData)   AS ToName            -- Кому (Название)
                         , MIFloat_Price.ValueData                               AS Price             --Цена в документе
                         , ABS(MIFloat_Price.ValueData * MovementItemContainer.Amount) AS Summa       --Сумма в документе
                         , CASE WHEN MovementItemContainer.Amount > 0 
                                     AND 
                                     Movement.DescId <> zc_Movement_Inventory() 
                                  THEN MovementItemContainer.Amount 
                              ELSE 0.0 END  ::TFloat                             AS AmountIn    --Кол-во приход
                         , CASE WHEN MovementItemContainer.Amount < 0 
                                  AND 
                                  Movement.DescId <> zc_Movement_Inventory() 
                                THEN ABS(MovementItemContainer.Amount) 
                           ELSE 0.0 
                           END::TFloat                                           AS AmountOut    --Кол-во расход
                         , CASE WHEN Movement.DescId = zc_Movement_Inventory()
                               THEN MovementItemContainer.Amount 
                           ELSE 0.0 
                           END::TFloat                                           AS AmountInvent --Кол-во переучет
                         , tmpPrice.MCSValue                                     AS MCSValue     --НТЗ
                         , Object_CheckMember.ValueData                          AS CheckMember  --Менеджер
                         , MovementString_Bayer.ValueData                        AS Bayer        --Покупатель
                         , CLO_Party.ObjectID                                    AS PartyId      --# партии
                        
                         , ROW_NUMBER() OVER(ORDER BY MovementItemContainer.OperDate, 
                                                      CASE WHEN MovementDesc.Id = zc_Movement_Inventory() THEN 1 else 0 end, 
                                                      CASE WHEN MovementItemContainer.Amount > 0 THEN 0 ELSE 0 END,
                                                      MovementItemContainer.MovementId,MovementItemContainer.MovementItemId,CLO_Party.ObjectID) AS OrdNum
                                                   
                         , (SUM(MovementItemContainer.Amount)OVER(ORDER BY MovementItemContainer.OperDate, 
                                                                        CASE WHEN MovementDesc.Id = zc_Movement_Inventory() THEN 1 else 0 end, 
                                                                        CASE WHEN MovementItemContainer.Amount > 0 THEN 0 ELSE 0 END,
                                                                        MovementItemContainer.MovementId,MovementItemContainer.MovementItemId,CLO_Party.ObjectID)) + _tmpRem.RemainsStart AS Saldo
                         , Object_Insert.ValueData              AS InsertName
                         , MovementDate_Insert.ValueData        AS InsertDate
                       
                    FROM tmpMIContainer AS MovementItemContainer
                         LEFT JOIN _tmpRem ON _tmpRem.ContainerId = MovementItemContainer.ContainerId OR _tmpRem.ContainerId = 0
                         LEFT JOIN tmpPrice ON tmpPrice.GoodsId = inGoodsId
                         INNER JOIN tmpMovement AS Movement ON Movement.Id = MovementItemContainer.MovementId
                         INNER JOIN MovementDesc ON Movement.DescId = MovementDesc.Id
     
                         INNER OUTER JOIN tmpCLO_Party AS CLO_Party
                                                       ON CLO_Party.ContainerId = MovementItemContainer.ContainerId
                                                      AND (CLO_Party.ObjectID = inPartyId OR inPartyId = 0)
                                                       -- AND CLO_Party.descid = zc_ContainerLinkObject_PartionMovementItem()                              
                     
                         LEFT OUTER JOIN tmpMLO AS MovementLinkObject_From
                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                         LEFT OUTER JOIN tmpObject AS Object_From ON MovementLinkObject_From.ObjectId = Object_From.Id
         
                         LEFT OUTER JOIN tmpMLO AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                         LEFT OUTER JOIN tmpObject AS Object_To ON MovementLinkObject_To.ObjectId = Object_To.Id
                         
                         LEFT OUTER JOIN tmpMLO AS MovementLinkObject_Unit
                                                ON MovementLinkObject_Unit.MovementId = Movement.Id
                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                         LEFT OUTER JOIN tmpObject AS Object_Unit ON MovementLinkObject_Unit.ObjectId = Object_Unit.Id
         
                         LEFT JOIN tmpMLO AS MovementLinkObject_CheckMember
                                          ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                         AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
                         LEFT JOIN tmpObject AS Object_CheckMember ON Object_CheckMember.Id = MovementLinkObject_CheckMember.ObjectId
         
                         LEFT JOIN tmpMovementString AS MovementString_Bayer
                                                     ON MovementString_Bayer.MovementId = Movement.Id
         
                         -- Пользователь(созд.) + Дата(созд.)  
                         LEFT JOIN tmpMovementDate AS MovementDate_Insert
                                                   ON MovementDate_Insert.MovementId = Movement.Id
         
                         LEFT JOIN tmpMLO AS MLO_Insert
                                          ON MLO_Insert.MovementId = Movement.Id
                                         AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
                         LEFT JOIN tmpObject AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId  
         
                         LEFT OUTER JOIN tmpMIFloat AS MIFloat_Price 
                                                    ON MIFloat_Price.MovementItemId = MovementItemContainer.MovementItemId
                    )
      , RES AS (SELECT tmpData.ContainerId
                     , tmpData.MovementId
                     , tmpData.OperDate
                     , tmpData.InvNumber
                     , tmpData.MovementDescId
                     , tmpData.MovementDescName
                     , tmpData.FromId
                     , tmpData.FromName
                     , tmpData.ToId
                     , tmpData.ToName
                     , tmpData.Price
                     , tmpData.Summa
                     , tmpData.AmountIn
                     , tmpData.AmountOut
                     , tmpData.AmountInvent
                     , tmpData.MCSValue
                     , tmpData.CheckMember
                     , tmpData.Bayer
                     , tmpData.PartyId
                     , tmpData.OrdNum
                     , tmpData.Saldo
                     , tmpData.InsertName
                     , tmpData.InsertDate
                FROM tmpData
                UNION ALL
                SELECT
                    tmpRem_All.ContainerId     AS ContainerId,
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
                    NULL                       AS InsertDate
                FROM tmpRem_All
               UNION ALL
                SELECT
                    tmpRem_All.ContainerId     AS ContainerId,
                    NULL                       AS MovementId,   --ИД накдалдной
                    inEndDate                  AS OperDate,     --Дата документа
                    NULL                       AS InvNumber,    --№ документа
                    NULL                       AS MovementDescId,    --Тип накладной
                    'Остаток на конец'         AS MovementDescName,  --Название типа накладной
                    NULL                       AS FromId,       --От кого
                    NULL                       AS FromName,     --От кого (Название)
                    NULL                       AS ToId,         -- Кому
                    NULL                       AS ToName,       -- Кому (Название)
                    NULL::TFloat               AS Price,        --Цена в документе
                    NULL::TFloat               AS Summa,        --Сума в документе
                    NULL                       AS AmountIn,     --Кол-во приход
                    NULL                       AS AmountOut,    --Кол-во расход
                    NULL                       AS AmountInvent, --Кол-во переучет
                    tmpRem_All.MCSValue        AS MCSValue,     --НТЗ
                    NULL                       AS CheckMember,  --Менеджер
                    NULL                       AS Bayer,        --Покупатель
                    tmpRem_All.PartyId         AS PartyId,      --# партии
                    999999999                  AS OrdNum,
                    tmpRem_All.RemainsEnd      AS Saldo,
                    NULL                       AS InsertName,
                    NULL                       AS InsertDate 
                FROM tmpRem_All
                )
      ---
      , tmpObject_Party AS (SELECT Object_PartionMovementItem.ObjectCode :: Integer AS ObjectCode
                            FROM Object AS Object_PartionMovementItem
                            WHERE Object_PartionMovementItem.Id IN (SELECT DISTINCT Res.PartyId FROM Res)
                              AND inIsPartion = True
                           )
      , tmpMI_Party AS (SELECT MovementItem.*
                        FROM MovementItem
                        WHERE MovementItem.Id IN (SELECT DISTINCT tmpObject_Party.ObjectCode FROM tmpObject_Party)
                        )
      , tmpMovement_Party AS (SELECT 
                              FROM Movement
                              WHERE Movement.Id IN (SELECT DISTINCT tmpMI_Party.MovementId FROM tmpMI_Party)
                              )
      , tmpMIFloat_Party AS (SELECT MIFloat_Price.*
                             FROM MovementItemFloat AS MIFloat_Price
                             WHERE MIFloat_Price.MovementItemId IN  (SELECT DISTINCT tmpMI_Party.Id FROM tmpMI_Party)
                               AND MIFloat_Price.DescId = zc_MIFloat_Price()
                             )
        -- результат
        SELECT
            Res.ContainerId,
            Res.MovementId::Integer,            --ИД накдалдной
            Res.OperDate::TDateTime,            --Дата документа
            Res.InvNumber::TVarChar,            --№ документа
            Res.MovementDescId::Integer,        --Тип накладной
            Res.MovementDescName::TVarChar,     --Название типа накладной
            Res.FromId::Integer,                --От кого
            Res.FromName::TVarChar,             --От кого (Название)
            Res.ToId::Integer,                  -- Кому
            Res.ToName::TVarChar,               -- Кому (Название)
            Res.Price::TFloat,                  --Цена в документе
            Res.Summa::TFloat,                  --Сумма в документе
            NULLIF(Res.AmountIn,0)::TFloat,     --Кол-во приход
            NULLIF(Res.AmountOut,0)::TFloat,    --Кол-во расход
            NULLIF(Res.AmountInvent,0)::TFloat, --Кол-во переучет
            Res.Saldo::TFloat,                  --Остаток после операции
            Res.MCSValue::TFloat,               --НТЗ
            Res.CheckMember::TVarChar,          --Менеджер
            Res.Bayer::TVarChar,                --Покупатель
            Res.PartyId ,                       --# партии
            COALESCE(Movement_Party.InvNumber, NULL) ::TVarChar  AS PartionInvNumber,  -- № док.партии
            COALESCE(Movement_Party.OperDate, NULL)  ::TDateTime AS PartionOperDate,   -- Дата док.партии
            COALESCE(MovementDesc.ItemName, NULL)    ::TVarChar  AS PartionDescName,
            COALESCE(MIFloat_Price.ValueData, NULL)  ::TFloat    AS PartionPrice,
            Res.InsertName  ::TVarChar,         --Пользователь(созд.) 
            Res.InsertDate  ::TDateTime         --Дата(созд.)
        FROM Res
           LEFT JOIN tmpObject_Party AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = Res.PartyId

           LEFT JOIN tmpMI_Party ON MovementItem.Id = Object_PartionMovementItem.ObjectCode

           LEFT JOIN tmpMovement_Party AS Movement_Party ON Movement_Party.Id = MovementItem.MovementId 

           LEFT JOIN MovementDesc ON MovementDesc.Id = Movement_Party.DescId

           LEFT OUTER JOIN tmpMIFloat_Party AS MIFloat_Price ON MIFloat_Price.MovementItemId = MovementItem.Id
          
        ORDER BY Res.OrdNum;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 21.05.18         *
 07.01.17         *
 01.07.16         * add inIsPartion
 26.08.15                                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_GoodsPartionHistory (inPartyId := 0,inGoodsId := 0,inUnitId := 0,inStartDate := '20150801',inEndDate := '20150830', inIsPartion = true, inSession := '3')
--select * from gpSelect_GoodsPartionHistory(inPartyId := 0 , inGoodsId := 18253 , inUnitId := 183292 , inStartDate := ('01.10.2015')::TDateTime , inEndDate := ('26.11.2016')::TDateTime , inIsPartion := 'False' ,  inSession := '3');