DROP FUNCTION IF EXISTS gpReport_PriceList_BestPrice(TDateTime,TDateTime,TBlob,TFloat,TVarChar);

CREATE OR REPLACE FUNCTION gpReport_PriceList_BestPrice(
    IN inStartDate           TDateTime,  -- Дата начала
    IN inEndDate             TDateTime,  -- Дата окончания
    IN inJuridicalList       TBlob    ,  -- Юр. лица
    IN inProcent             TFloat   ,  -- % отклонение
    IN inSession             TVarChar    -- сессия пользователя
)
  RETURNS TABLE (ContractId Integer, ContractCode Integer, ContractName TVarChar
               , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
               , Price TFloat, PriceMin TFloat, PercChange TFloat, DatePriceMin TDateTime
               , MakerPromoName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());



    -- из JSON в таблицу
    CREATE TEMP TABLE tblDataJSON
    (
       Id           Integer,
       isSelect     Boolean
    ) ON COMMIT DROP;

    INSERT INTO tblDataJSON
    SELECT *
    FROM json_populate_recordset(null::tblDataJSON, replace(replace(replace(inJuridicalList, '&quot;', '\"'), CHR(9),''), CHR(10),'')::json);
    
    ANALYSE tblDataJSON;

    DELETE FROM tblDataJSON WHERE isSelect = False;

    CREATE TEMP TABLE _tmpResult (ContractId integer, GoodsId integer, Price TFloat, PriceMin TFloat, DatePriceMin TDateTime) ON COMMIT DROP;

    CREATE TEMP TABLE _tmpPriceList ON COMMIT DROP AS
     SELECT DISTINCT
            Movement.Id
          , DATE_TRUNC ('DAY', Movement.OperDate)    AS OperDate
          , MovementLinkObject_Contract.ObjectId     AS ContractId
          , MovementItem.ObjectId                    AS GoodsId   
          , MovementItem.Amount                      AS Price

     FROM Movement
          INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                        ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                       AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Area
                                       ON MovementLinkObject_Area.MovementId = Movement.Id
                                      AND MovementLinkObject_Area.DescId     = zc_MovementLinkObject_Area()
                                       
          INNER JOIN tblDataJSON ON tblDataJSON.Id = MovementLinkObject_Juridical.ObjectId 
          
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN ObjectFloat AS ObjectFloat_Deferment 
                                ON ObjectFloat_Deferment.ObjectId = MovementLinkObject_Contract.ObjectId
                               AND ObjectFloat_Deferment.DescId = zc_ObjectFloat_Contract_Deferment()

          INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = False
                                 AND COALESCE (MovementItem.ObjectId, 0) <> 0
                                 
          LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                     ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                    AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()
                                    
      WHERE Movement.DescId = zc_Movement_PriceList() 
        AND Movement.OperDate >= inStartDate AND Movement.OperDate < inEndDate + interval '1 day'
        AND (MIDate_PartionGoods.ValueData IS NULL OR MIDate_PartionGoods.ValueData > Movement.OperDate + interval '199 day')
        AND date_part('isodow', Movement.OperDate)::Integer in (1, 2, 3, 4, 5)
        AND (MovementLinkObject_Juridical.ObjectId  NOT IN (59610, 59611) OR COALESCE(ObjectFloat_Deferment.ValueData, 0) > 0)
        AND COALESCE (MovementLinkObject_Area.ObjectId, zc_Area_Basis()) = zc_Area_Basis();        
        
    ANALYSE _tmpPriceList;
    
    raise notice 'Value 1: % %', CLOCK_TIMESTAMP(), (( WITH tmpLast AS (SELECT _tmpPriceList.GoodsId
                          , Min(_tmpPriceList.Id)::Integer  AS ID
                     FROM _tmpPriceList
                     GROUP BY _tmpPriceList.GoodsId)
                     
                     select Count(*) FROM tmpLast));
    
    WITH tmpLast AS (SELECT _tmpPriceList.GoodsId
                          , _tmpPriceList.Id
                          , ROW_NUMBER() OVER (PARTITION BY _tmpPriceList.GoodsId 
                                              ORDER BY _tmpPriceList.OperDate DESC, _tmpPriceList.Price) AS Ord
                     FROM _tmpPriceList),
         tmpMin AS (SELECT _tmpPriceList.OperDate
                         , _tmpPriceList.ContractId
                         , _tmpPriceList.GoodsId 
                         , _tmpPriceList.Price
                         , ROW_NUMBER() OVER (PARTITION BY _tmpPriceList.GoodsId  
                                              ORDER BY _tmpPriceList.Price) AS Ord
                    FROM _tmpPriceList
                    
                         LEFT JOIN tmpLast ON tmpLast.GoodsId = _tmpPriceList.GoodsId
                                          AND tmpLast.Id = _tmpPriceList.Id 
                                          AND tmpLast.Ord = 1
                                          
                    WHERE COALESCE(tmpLast.Id, 0) = 0)
                     
    INSERT INTO _tmpResult (ContractId, GoodsId, Price, PriceMin, DatePriceMin)
    SELECT _tmpPriceList.ContractId
         , _tmpPriceList.GoodsId
         , _tmpPriceList.Price
         , tmpMin.Price
         , tmpMin.OperDate
    FROM tmpLast 
    
         INNER JOIN _tmpPriceList ON _tmpPriceList.ID      = tmpLast.Id
                                 AND _tmpPriceList.GoodsId = tmpLast.GoodsId 

         INNER JOIN tmpMin ON tmpMin.GoodsId = tmpLast.GoodsId
                          AND tmpMin.Ord = 1
                          
    WHERE tmpLast.Ord = 1;
         
    ANALYSE _tmpResult;

    raise notice 'Value 2: % %', CLOCK_TIMESTAMP(), (select Count(*) FROM _tmpResult);

    RETURN QUERY 
    WITH GoodsPromoAll AS (SELECT Object_Goods_Retail.GoodsMainId AS GoodsId  -- главный товар
                                , Object_Maker.ValueData          AS MakerPromoName
                                , tmp.GoodsGroupPromoName
                                , ROW_NUMBER() OVER (PARTITION BY Object_Goods_Retail.GoodsMainId ORDER BY tmp.MovementId DESC) AS Ord
                           FROM lpSelect_MovementItem_Promo_onDate (inOperDate:= CURRENT_DATE) AS tmp   --CURRENT_DATE
                                INNER JOIN Object_Goods_Retail AS Object_Goods_Retail
                                                               ON Object_Goods_Retail.Id = tmp.GoodsId
                                INNER JOIN Object AS Object_Maker
                                                  ON Object_Maker.Id = tmp.MakerId
                           )

    SELECT _tmpResult.ContractId 
         , Object_Contract.ObjectCode
         , Object_Contract.ValueData
         , _tmpResult.GoodsId 
         , Object_Goods.ObjectCode
         , Object_Goods.ValueData
         , _tmpResult.Price 
         , _tmpResult.PriceMin
         , (_tmpResult.PriceMin / _tmpResult.Price * 100 - 100)::TFloat  AS PercChange
         , _tmpResult.DatePriceMin
         , GoodsPromoAll.MakerPromoName
    FROM _tmpResult 
    
         LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = _tmpResult.ContractId 

         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = _tmpResult.GoodsId 
         
         LEFT JOIN GoodsPromoAll ON GoodsPromoAll.GoodsId = _tmpResult.GoodsId 
                                AND GoodsPromoAll.Ord = 1
           
    WHERE _tmpResult.PriceMin <= round(_tmpResult.Price * (100 + inProcent) / 100, 2)
      AND _tmpResult.Price > 0
      AND _tmpResult.PriceMin > _tmpResult.Price
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

select * from gpReport_PriceList_BestPrice(inStartDate := ('01.07.2023')::TDateTime , inEndDate := ('19.07.2023')::TDateTime , inJuridicalList := '[{"id":59610,"isselect":"True"},{"id":59611,"isselect":"True"},{"id":59612,"isselect":"True"},{"id":183317,"isselect":"False"},{"id":183319,"isselect":"False"},{"id":183321,"isselect":"False"},{"id":183325,"isselect":"False"},{"id":183331,"isselect":"False"},{"id":183332,"isselect":"False"},{"id":183340,"isselect":"False"},{"id":183343,"isselect":"False"},{"id":183344,"isselect":"False"},{"id":183345,"isselect":"False"},{"id":183349,"isselect":"False"},{"id":183351,"isselect":"False"},{"id":183353,"isselect":"False"},{"id":410822,"isselect":"False"},{"id":800577,"isselect":"False"},{"id":829191,"isselect":"False"},{"id":2304062,"isselect":"False"},{"id":3403870,"isselect":"False"},{"id":4783099,"isselect":"False"},{"id":5000875,"isselect":"False"},{"id":6530478,"isselect":"False"},{"id":6916162,"isselect":"False"},{"id":9008423,"isselect":"False"},{"id":9526799,"isselect":"False"},{"id":9624250,"isselect":"False"},{"id":11310208,"isselect":"False"},{"id":12225793,"isselect":"False"},{"id":14374718,"isselect":"False"},{"id":15033411,"isselect":"False"},{"id":15379290,"isselect":"False"},{"id":15702720,"isselect":"False"},{"id":17434172,"isselect":"False"},{"id":18915010,"isselect":"False"},{"id":18926945,"isselect":"False"},{"id":19672350,"isselect":"False"},{"id":20972477,"isselect":"False"},{"id":21067339,"isselect":"False"},{"id":22128896,"isselect":"False"}]' , inProcent := 10 ,  inSession := '3');