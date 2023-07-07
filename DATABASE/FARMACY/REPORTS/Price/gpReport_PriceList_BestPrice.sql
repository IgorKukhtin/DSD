DROP FUNCTION IF EXISTS gpReport_PriceList_BestPrice(TDateTime,TDateTime,Integer,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PriceList_BestPrice(
    IN inStartDate           TDateTime,  -- Дата начала
    IN inEndDate             TDateTime,  -- Дата окончания
    IN inJuridicalId         Integer  ,  -- Юр. лицо
    IN inProcent             TFloat   ,  -- % отклонение
    IN inSession             TVarChar    -- сессия пользователя
)
  RETURNS TABLE (ContractId Integer, ContractCode Integer, ContractName TVarChar
               , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
               , Price TFloat, PriceMin TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());


    CREATE TEMP TABLE _tmpResult (ContractId integer, GoodsId integer, Price TFloat, PriceMin TFloat) ON COMMIT DROP;

    CREATE TEMP TABLE _tmpPriceList ON COMMIT DROP AS
     SELECT Movement.Id
          , DATE_TRUNC ('DAY', Movement.OperDate)    AS OperDate
          , MovementLinkObject_Contract.ObjectId     AS ContractId
          , MovementItem.ObjectId                    AS GoodsId   
          , MovementItem.Amount                      AS Price

     FROM Movement
          INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                        ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                       AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                       AND MovementLinkObject_Juridical.ObjectId = inJuridicalId
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = False
                                 AND COALESCE (MovementItem.ObjectId, 0) <> 0
                                 
          LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                     ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                    AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                    
      WHERE Movement.DescId = zc_Movement_PriceList() 
        AND Movement.OperDate >= inStartDate AND Movement.OperDate < inEndDate + interval '1 day'
        AND (MIDate_PartionGoods.ValueData IS NULL OR MIDate_PartionGoods.ValueData > Movement.OperDate + interval '199 day');        
        
    ANALYSE _tmpPriceList;
    
    raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), (select Count(*) FROM _tmpPriceList);
    
    WITH tmpLast AS (SELECT _tmpPriceList.ContractId
                          , Max(_tmpPriceList.Id)::Integer  AS ID
                     FROM _tmpPriceList
                     GROUP BY _tmpPriceList.ContractId),
         tmpMin AS (SELECT _tmpPriceList.ContractId
                         , _tmpPriceList.GoodsId 
                         , Min(_tmpPriceList.Price)::TFloat  AS Price
                    FROM _tmpPriceList
                    GROUP BY _tmpPriceList.ContractId
                           , _tmpPriceList.GoodsId )
                     
    INSERT INTO _tmpResult (ContractId, GoodsId, Price, PriceMin)
    SELECT _tmpPriceList.ContractId
         , _tmpPriceList.GoodsId
         , _tmpPriceList.Price
         , tmpMin.Price
    FROM tmpLast 
    
         INNER JOIN _tmpPriceList ON _tmpPriceList.ID = tmpLast.Id

         INNER JOIN tmpMin ON tmpMin.ContractId = _tmpPriceList.ContractId
                          AND tmpMin.GoodsId = _tmpPriceList.GoodsId;
         
    ANALYSE _tmpResult;


    RETURN QUERY 
    SELECT _tmpResult.ContractId 
         , Object_Contract.ObjectCode
         , Object_Contract.ValueData
         , _tmpResult.GoodsId 
         , Object_Goods.ObjectCode
         , Object_Goods.ValueData
         , _tmpResult.Price 
         , _tmpResult.PriceMin
    FROM _tmpResult 
    
         LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = _tmpResult.ContractId 

         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpResult.GoodsId 
           
    WHERE _tmpResult.Price >= _tmpResult.PriceMin * (100 + inProcent) / 100
    ORDER BY  Object_Goods.ObjectCode;    
    

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpReport_Movement_PriceList (TDateTime, Integer, Boolean, TVarChar) OWNER TO postgres;


/*   
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Шаблий О.В.
 06.07.23                                                        * 
*/

select * from gpReport_PriceList_BestPrice(inStartDate := ('01.06.2023')::TDateTime , inEndDate := ('06.07.2023')::TDateTime , inJuridicalId := 59610, inProcent := 10 ,  inSession := '3');


