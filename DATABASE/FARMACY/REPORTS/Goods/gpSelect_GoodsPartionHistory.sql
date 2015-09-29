DROP FUNCTION IF EXISTS gpSelect_GoodsPartionHistory (Integer, Integer, Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_GoodsPartionHistory(
    IN inPartyId          Integer  ,  -- Партия
    IN inGoodsId          Integer  ,  -- Товар
    IN inUnitId           Integer  ,  -- Подразделение
    IN inStartDate        TDateTime,  -- Дата начала периода
    IN inEndDate          TDateTime,  -- Дата окончания периода
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE ( 
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
    AmountIn         TFloat,    --Кол-во приход
    AmountOut        TFloat,    --Кол-во расход
    AmountInvent     TFloat,    --Кол-во переучет
    Saldo            TFloat,    --Остаток после операции
    MCSValue         TFloat     --НТЗ
  )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbRemainsStart TFloat;
   DECLARE vbRemainsEnd TFloat;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);
    SELECT
      SUM(AmountStart)::TFloat,
      SUM(AmountEnd)::TFloat
    INTO
      vbRemainsStart,
      vbRemainsEnd
    FROM(
            SELECT
              Container.Amount - COALESCE(SUM(MovementItemContainer.Amount),0) AS AmountStart,
              Container.Amount - COALESCE(SUM(CASE WHEN date_trunc('day',MovementItemContainer.OperDate) > inEndDate THEN MovementItemContainer.Amount ELSE 0 END),0) AS AmountEnd
              
            FROM
                Container
                INNER JOIN ContainerLinkObject AS CLO_Unit
                                               ON CLO_Unit.ContainerId = Container.Id
                                              AND CLO_Unit.DescId = zc_ContainerLinkObject_Unit()
                                              AND CLO_Unit.ObjectId = inUnitId
                LEFT OUTER JOIN ContainerLinkObject AS CLO_Party
                                                    ON CLO_Party.containerid = container.id 
                                                   AND CLO_Party.descid = zc_ContainerLinkObject_PartionMovementItem()
                LEFT OUTER JOIN MovementItemContainer ON MovementItemContainer.ContainerId = Container.Id
                                                     AND date_trunc('day',MovementItemContainer.OperDate) >= inStartDate
            WHERE
                Container.DescId = zc_Container_Count()
                AND
                Container.ObjectId = inGoodsId
                AND
                (
                  CLO_Party.ObjectId = inPartyId
                  or 
                  COALESCE(inPartyId,0) = 0
                )
            GROUP BY
                Container.Amount,
                Container.Id
        ) AS Remains;
    -- Результат
    RETURN QUERY
        WITH RES AS
        (
            SELECT
                Movement.Id                                           AS MovementId,   --ИД накдалдной
                MovementItemContainer.OperDate                        AS OperDate, --Дата документа
                Movement.InvNumber                                    AS InvNumber,  --№ документа
                MovementDesc.Id                                       AS MovementDescId,   --Тип накладной
                MovementDesc.ItemName                                 AS MovementDescName,  --Название типа накладной
                COALESCE(Object_From.Id,Object_Unit.ID)               AS FromId,   --От кого
                COALESCE(Object_From.ValueData,Object_Unit.ValueData) AS FromName,  --От кого (Название)
                COALESCE(Object_To.Id,Object_Unit.ID)                 AS ToId,   -- Кому
                COALESCE(Object_To.ValueData,Object_Unit.ValueData)   AS ToName,  -- Кому (Название)
                NULL::TFloat                                          AS Price,    --Цена в документе
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
                END::TFloat                                           AS AmountInvent,    --Кол-во переучет
                Object_Price_View.MCSValue                            AS MCSValue,     --НТЗ
                ROW_NUMBER() OVER(ORDER BY MovementItemContainer.OperDate, 
                                           CASE WHEN MovementDesc.Id = zc_Movement_Inventory() THEN 1 else 0 end, 
                                           MovementItemContainer.MovementId,MovementItemContainer.MovementItemId) AS OrdNum,
                (SUM(MovementItemContainer.Amount)OVER(ORDER BY MovementItemContainer.OperDate, 
                                                                CASE WHEN MovementDesc.Id = zc_Movement_Inventory() THEN 1 else 0 end, 
                                                                MovementItemContainer.MovementId,MovementItemContainer.MovementItemId))+vbRemainsStart AS Saldo
            FROM
                MovementItemContainer
                INNER JOIN Movement ON MovementItemContainer.MovementId = Movement.Id
                INNER JOIN MovementDesc ON Movement.DescId = MovementDesc.Id
                INNER JOIN Container ON MovementItemContainer.ContainerId = Container.Id
                INNER JOIN ContainerLinkObject ON ContainerLinkObject.ContainerId = Container.Id
                                              AND ContainerLinkObject.DescId = zc_ContainerLinkObject_Unit()
                                              AND ContainerLinkObject.ObjectId = inUnitId
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
                
                LEFT OUTER JOIN Object_Price_View ON Object_Price_View.UnitId = inUnitId
                                                 AND Object_Price_View.GoodsId = inGoodsId 
            WHERE
                date_trunc('day', MovementItemContainer.OperDate) BETWEEN inStartDate AND inEndDate
                AND
                MovementItemContainer.DescId = zc_MIContainer_Count()
                AND
                Container.ObjectId = inGoodsId
                AND
                (
                  CLO_Party.ObjectID = inPartyId 
                  OR
                  inPartyId = 0
                )
            UNION ALL
            SELECT
                NULL                       AS MovementId,   --ИД накдалдной
                inStartDate                AS OperDate, --Дата документа
                NULL                       AS InvNumber,  --№ документа
                NULL                       AS MovementDescId,   --Тип накладной
                'Остаток на начало'        AS MovementDescName,  --Название типа накладной
                NULL                       AS FromId,   --От кого
                NULL                       AS FromName,  --От кого (Название)
                NULL                       AS ToId,   -- Кому
                NULL                       AS ToName,  -- Кому (Название)
                NULL::TFloat               AS Price,    --Цена в документе
                NULL                       AS AmountIn,    --Кол-во приход
                NULL                       AS AmountOut,    --Кол-во расход
                NULL                       AS AmountInvent,    --Кол-во переучет
                Object_Price_View.MCSValue AS MCSValue,     --НТЗ
                0                          AS OrdNum,
                vbRemainsStart             AS Saldo
            FROM
                Object AS Object_Goods
                LEFT OUTER JOIN Object_Price_View ON Object_Price_View.UnitId = inUnitId
                                                 AND Object_Price_View.GoodsId = Object_Goods.Id
            WHERE
                Object_Goods.Id = inGoodsId
            UNION ALL
            SELECT
                NULL                       AS MovementId,   --ИД накдалдной
                inEndDate                  AS OperDate, --Дата документа
                NULL                       AS InvNumber,  --№ документа
                NULL                       AS MovementDescId,   --Тип накладной
                'Остаток на конец'         AS MovementDescName,  --Название типа накладной
                NULL                       AS FromId,   --От кого
                NULL                       AS FromName,  --От кого (Название)
                NULL                       AS ToId,   -- Кому
                NULL                       AS ToName,  -- Кому (Название)
                NULL::TFloat               AS Price,    --Цена в документе
                NULL                       AS AmountIn,    --Кол-во приход
                NULL                       AS AmountOut,    --Кол-во расход
                NULL                       AS AmountInvent,    --Кол-во переучет
                Object_Price_View.MCSValue AS MCSValue,     --НТЗ
                999999999                  AS OrdNum,
                vbRemainsEnd               AS Saldo 
            FROM
                Object AS Object_Goods
                LEFT OUTER JOIN Object_Price_View ON Object_Price_View.UnitId = inUnitId
                                                 AND Object_Price_View.GoodsId = Object_Goods.Id
            WHERE
                Object_Goods.Id = inGoodsId
        )
        SELECT
            Res.MovementId::Integer,   --ИД накдалдной
            Res.OperDate::TDateTime, --Дата документа
            Res.InvNumber::TVarChar,  --№ документа
            Res.MovementDescId::Integer,   --Тип накладной
            Res.MovementDescName::TVarChar,  --Название типа накладной
            Res.FromId::Integer,   --От кого
            Res.FromName::TVarChar,  --От кого (Название)
            Res.ToId::Integer,   -- Кому
            Res.ToName::TVarChar,  -- Кому (Название)
            Res.Price::TFloat,    --Цена в документе
            NULLIF(Res.AmountIn,0)::TFloat,    --Кол-во приход
            NULLIF(Res.AmountOut,0)::TFloat,    --Кол-во расход
            NULLIF(Res.AmountInvent,0)::TFloat,    --Кол-во переучет
            Res.Saldo::TFloat, --Остаток после операции
            Res.MCSValue::TFloat     --НТЗ
        FROM Res 
        ORDER BY 
            Res.OrdNum;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_GoodsPartionHistory (Integer, Integer, Integer, TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 26.08.15                                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_GoodsPartionHistory (inPartyId := 0,inGoodsId := 0,inUnitId := 0,inStartDate := '20150801',inEndDate := '20150830', inSession := '3')