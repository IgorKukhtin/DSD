-- Function: gpSelect_Movement_ByPartionGoods()

DROP FUNCTION IF EXISTS gpSelect_Movement_ByPartionGoods(TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ByPartionGoods(TVarChar, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ByPartionGoods(
    IN inPartionGoods    TVarChar   , -- Партии товара
    IN inOnlyComplete    boolean    , -- Только проведенные документы
    IN inOnlyHaveRemains boolean    , -- Только с остатком
    IN inSession         TVarChar       -- сессия пользователя
)
RETURNS TABLE (PartionGoods  TVarChar,
    MovementId Integer, InvNumber TVarChar, OperDate TDateTime, StatusName TVarChar,
    IncomeUnitName TVarChar, JuridicalName TVarChar,
    GoodsId Integer, GoodsCode Integer, GoodsName TVarChar,
    IncomeAmount TFloat, Remains TFloat, RemainsUnitName TVarChar)
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbPartionGoods TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;

    IF inPartionGoods = ''
    THEN
        RETURN QUERY
            SELECT
                NULL::TVarChar   AS PartionGoods
               ,NULL::Integer    AS MovementId
               ,NULL::TVarChar   AS InvNumber
               ,NULL::TDateTime  AS OperDate
               ,NULL::TVarChar   AS StatusName
               ,NULL::TVarChar   AS IncomeUnitName
               ,NULL::TVarChar   AS JuridicalName
               ,NULL::Integer    AS GoodsId
               ,NULL::Integer    AS GoodsCode
               ,NULL::TVarChar   AS GoodsName
               ,NULL::TFloat     AS IncomeAmount
               ,NULL::TFloat     AS Remains
               ,NULL::TVarChar   AS RemainsUnitName
            WHERE
                1 = 0;
    ELSE
        --создаем таблицу, в которую разворачиваем строку с номерами серии
        CREATE TEMP TABLE _PartionGoods(PartionGoodsValue TVarChar, MovementItemId Integer) ON COMMIT DROP;
        --заполняем таблицу номерами партий
        IF position(Chr(10) in inPartionGoods) > 0 THEN
            inPartionGoods := REPLACE(inPartionGoods,Chr(10),'|');
        END IF;
        IF position(Chr(13) in inPartionGoods) > 0 THEN
            inPartionGoods := REPLACE(inPartionGoods,Chr(13),'|');
        END IF;
        IF position('||' in inPartionGoods) > 0 THEN
            inPartionGoods := REPLACE(inPartionGoods,'||','|');
        END IF;
        
        WHILE inPartionGoods <> '' LOOP
            IF position('|' in inPartionGoods) = 0
            THEN
                vbPartionGoods := inPartionGoods;
                inPartionGoods := '';
            ELSE
                vbPartionGoods := LEFT(inPartionGoods,position('|' in inPartionGoods)-1);
                inPartionGoods := SUBSTRING(inPartionGoods,position('|' in inPartionGoods)+1,char_length(inPartionGoods));
            END IF;
            IF LTRIM(vbPartionGoods) <> ''
            THEN
                INSERT INTO _PartionGoods(PartionGoodsValue,MovementItemId)
                Select MIString_PartionGoods.ValueData, MIString_PartionGoods.MovementItemId
                FROM MovementItemString AS MIString_PartionGoods
                WHERE MIString_PartionGoods.ValueData = LTRIM(vbPartionGoods);
            END IF;
        END LOOP;
        
        RETURN QUERY
            SELECT
                _PartionGoods.PartionGoodsValue  AS PartionGoods
               ,Movement_Income.Id               AS MovementId
               ,Movement_Income.InvNumber        AS InvNumber
               ,Movement_Income.OperDate         AS OperDate
               ,Object_Status.ValueData          AS StatusName
               ,Object_To.ValueData              AS IncomeUnitName
               ,Object_From.ValueData            AS JuridicalName
               ,Object_Goods.Id                  AS GoodsId
               ,Object_Goods.ObjectCode::Integer AS GoodsCode
               ,Object_Goods.ValueData           AS GoodsName
               ,MI_Income.Amount                 AS IncomeAmount
               ,Container.Amount                 AS Remains
               ,Object_Unit.ValueData            AS RemainsUnitName
            FROM
                _PartionGoods
                JOIN MovementItem AS MI_Income
                                  ON MI_Income.Id = _PartionGoods.MovementItemId
                JOIN Object AS Object_Goods
                            ON Object_Goods.Id = MI_Income.ObjectId
                JOIN Movement AS Movement_Income
                              ON Movement_Income.Id = MI_Income.MovementId
                             AND Movement_Income.DescId = zc_Movement_Income()
                JOIN Object AS Object_Status 
                            ON Object_Status.Id = Movement_Income.StatusId
                
                JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = Movement_Income.Id
                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                JOIN Object AS Object_From 
                            ON Object_From.Id = MovementLinkObject_From.ObjectId

                JOIN MovementLinkObject AS MovementLinkObject_To
                                        ON MovementLinkObject_To.MovementId = Movement_Income.Id
                                       AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                JOIN Object AS Object_To
                            ON Object_To.Id = MovementLinkObject_To.ObjectId
                
                
                LEFT JOIN Object AS Object_PartionMovementItem 
                                 ON Object_PartionMovementItem.ObjectCode::Integer = MI_Income.Id
                                AND Object_PartionMovementItem.DescId = zc_Object_PartionMovementItem()
                LEFT JOIN ContainerLinkObject AS CLO_MI 
                                              ON CLO_MI.ObjectId = Object_PartionMovementItem.Id
                                             AND CLO_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                LEFT JOIN Container ON CLO_MI.ContainerId = Container.Id
                                   AND Container.DescId = zc_Container_Count()
                LEFT JOIN Object AS Object_Unit
                                 ON Container.WhereObjectId = Object_Unit.Id
            WHERE
                (
                    inOnlyComplete = FALSE 
                    OR
                    Movement_Income.StatusId = zc_Enum_Status_Complete()
                )
                AND
                (
                    inOnlyHaveRemains = FALSE
                    OR
                    COALESCE(Container.Amount,0) > 0
                )
            ORDER BY
                _PartionGoods.PartionGoodsValue
               ,Movement_Income.OperDate
               ,Object_From.ValueData
               ,Object_Goods.ValueData;
    END IF;       
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_ByPartionGoods (TVarChar, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 18.10.15                                                                        *              
*/

-- тест
/* SELECT * FROM gpSelect_Movement_ByPartionGoods (inPartionGoods:= 'F101B0513
432556A', FALSE, FALSE, inSession:= '3');*/