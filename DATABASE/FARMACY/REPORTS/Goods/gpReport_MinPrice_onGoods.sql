-- Function: gpReport_MinPrice_onGoods()

DROP FUNCTION IF EXISTS gpReport_MinPrice_onGoods (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MinPrice_onGoods(
    IN inStartDate     TDateTime ,
    IN inEndDate       TDateTime ,
    IN inGoodsId       Integer   , -- Товар
    IN inSession       TVarChar    -- сессия пользователя
)

RETURNS TABLE (
    OperDate           TDateTime,
    JuridicalName      TVarChar,  -- поставщик
    ContractName       TVarChar,  -- договор
    AreaName           TVarChar,  -- регион
    Price              TFloat,    -- мин цена
    MidPrice           TFloat,    -- средняя цена
    CountPriceList     TFloat,    --количество прайс-листов
    isOne              Boolean    --один прайс-лист       
)
AS
$BODY$
  DECLARE vbMainJuridicalId Integer;
BEGIN

    -- Результат
    RETURN QUERY
    WITH
    -- список договоров участвующих в отчете
    tmpContractList AS (SELECT ObjectBoolean_Report.ObjectId AS ContractId
                        FROM ObjectBoolean AS ObjectBoolean_Report
                        WHERE ObjectBoolean_Report.DescId = zc_ObjectBoolean_Contract_Report()
                          AND ObjectBoolean_Report.ValueData = TRUE
                        )
   -- прайс-листы за дату, по выбранным договорам
   , Movement_PriceList AS (SELECT Movement.OperDate
                                 , Movement.Id                             AS MovementId
                                 , MovementLinkObject_Juridical.ObjectId   AS JuridicalId
                                 , MovementLinkObject_Contract.ObjectId    AS ContractId
                                 , MovementLinkObject_Area.ObjectId        AS AreaId
                            FROM Movement
                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                        ON MovementLinkObject_Contract.MovementId = Movement.Id
                                       AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                 INNER JOIN tmpContractList ON tmpContractList.ContractId = MovementLinkObject_Contract.ObjectId

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                        ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                       AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical() 

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_Area
                                        ON MovementLinkObject_Area.MovementId = Movement.Id
                                       AND MovementLinkObject_Area.DescId = zc_MovementLinkObject_Area()
            
                            WHERE Movement.DescId = zc_Movement_PriceList()
                              AND Movement.OperDate >= inStartDate AND Movement.OperDate < inEndDate+ interval '1 day'
                              AND Movement.StatusId <> zc_Enum_Status_Erased() 
                            )

    -- находим мин цену товара, кол-во прайс-листов
   , MI_PriceList AS ( SELECT tmp.OperDate
                            , tmp.JuridicalId
                            , tmp.ContractId
                            , tmp.AreaId
                            , tmp.Price  
                            , tmp.MidPrice
                            , tmp.OrdCount AS CountPriceList
                       FROM (SELECT Movement_PriceList.OperDate
                                  , Movement_PriceList.JuridicalId
                                  , Movement_PriceList.ContractId
                                  , Movement_PriceList.AreaId
                                  , MovementItem.Amount              AS Price
                                  , ROW_NUMBER() OVER (PARTITION BY Movement_PriceList.OperDate ORDER BY Movement_PriceList.OperDate, MovementItem.Amount) AS Ord
                                  , COUNT(Movement_PriceList.MovementId) OVER (PARTITION BY Movement_PriceList.OperDate) AS OrdCount
                                  , AVG(MovementItem.Amount) OVER (PARTITION BY Movement_PriceList.OperDate) AS MidPrice
                             FROM Movement_PriceList
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement_PriceList.MovementId
                                         AND (MovementItem.ObjectId = inGoodsId OR inGoodsId = 0)
                             ) as tmp
                       WHERE tmp.Ord = 1
                       )

    -- Результат
    SELECT MI_PriceList.OperDate
         , Object_Juridical.ValueData  AS JuridicalName
         , Object_Contract.ValueData   AS ContractName
         , Object_Area.ValueData       AS AreaName
         , MI_PriceList.Price          :: TFloat
         , MI_PriceList.MidPrice       :: TFloat
         , MI_PriceList.CountPriceList :: TFloat AS isTop
         , CASE WHEN MI_PriceList.CountPriceList > 1 THEN FALSE ELSE TRUE END ::Boolean AS isOne
    FROM MI_PriceList
         LEFT JOIN Object AS Object_Contract  ON Object_Contract.Id  = MI_PriceList.ContractId
         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MI_PriceList.JuridicalId
         LEFT JOIN Object AS Object_Area      ON Object_Area.Id      = MI_PriceList.AreaId
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 21.11.17         * add AreaName
 11.01.17         * 
*/

-- тест
-- SELECT * FROM gpReport_MinPrice_onGoods ('30.06.2016' ::TDateTime , 183292 , 4, 3) WHERE GoodsCode = 4797 --  unit 183292
--select * from gpReport_MinPrice_onGoods(inStartDate := ('01.12.2016')::TDateTime , inEndDate := ('31.12.2016')::TDateTime , inGoodsId := 40008 ,  inSession := '3');