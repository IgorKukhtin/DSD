-- Function: gpReport_Goods_LeftTheMarket()

DROP FUNCTION IF EXISTS gpReport_Goods_LeftTheMarket(TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Goods_LeftTheMarket(
    IN inDateStart        TDateTime,  -- Дата начала
    IN inDateFinal        TDateTime,  -- Дата окончания
    IN inSession          TVarChar    -- сессия пользователя
)
  RETURNS SETOF refcursor 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE cur1 refcursor; 
  DECLARE cur2 refcursor; 
  DECLARE curDate refcursor;
  DECLARE vbDate TDateTime;
  DECLARE vbID Integer;

  DECLARE vbQueryText Text;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     
     IF inDateStart < '12.08.2022'
     THEN
        RAISE EXCEPTION 'Ошибка. Дата начало должна быть больше 11.08.2022.';    
     END IF;

     -- 
     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
        SELECT GENERATE_SERIES (DATE_TRUNC ('DAY', inDateStart), DATE_TRUNC ('DAY', inDateFinal), '1 DAY' :: INTERVAL) AS OperDate;
     
     -- все потанциальные товары
     CREATE TEMP TABLE tmpGoods ON COMMIT DROP AS
       SELECT Object_Goods_Main.Id 
            , Object_Goods_Main.ObjectCode
            , Object_Goods_Main.Name
            , Object_Goods_Main.DateLeftTheMarket
            , Object_Goods_Main.DateAddToOrder
       FROM Object_Goods_Main
       WHERE Object_Goods_Main.DateLeftTheMarket is not Null;
       
       -- Протокол
     CREATE TEMP TABLE tmpProtocol ON COMMIT DROP AS (
        WITH tmpProtocolAll AS (SELECT ObjectProtocol.ObjectId          AS GoodsId
                                     , ObjectProtocol.OperDate          AS OperDate
                                     , ObjectProtocol.ProtocolData ILIKE '%Ушел с рынка" FieldValue = "true%'  AS isLeftTheMarket
                                     , ROW_NUMBER() OVER (PARTITION BY ObjectProtocol.ObjectId ORDER BY ObjectProtocol.OperDate) AS Ord
                                FROM tmpGoods 
                               
                                     INNER JOIN  ObjectProtocol ON ObjectProtocol.ObjectId = tmpGoods.Id
                                                               AND ObjectProtocol.OperDate >= '11.08.2022'
                                                              
                                )
                                
        SELECT ObjectProtocol.GoodsId           AS GoodsId
             , ObjectProtocol.OperDate          AS OperDate
             , COALESCE(tmpProtocolAllNext.OperDate, zc_dateend())      AS DateEnd
             , ObjectProtocol.isLeftTheMarket   AS isLeftTheMarket
        FROM tmpProtocolAll AS ObjectProtocol
                               
             LEFT JOIN tmpProtocolAll AS tmpProtocolAllNext 
                                      ON tmpProtocolAllNext.GoodsId = ObjectProtocol.GoodsId
                                     AND tmpProtocolAllNext.Ord = ObjectProtocol.Ord + 1);
       
     -- Результат
     CREATE TEMP TABLE tmpData ON COMMIT DROP AS
       SELECT tmpProtocol.GoodsId 
            , tmpGoods.ObjectCode   AS GoodsCode
            , tmpGoods.Name         AS GoodsName
       FROM tmpProtocol
       
            INNER JOIN tmpGoods ON tmpGoods.Id = tmpProtocol.GoodsId
       
       GROUP BY tmpProtocol.GoodsId 
              , tmpGoods.ObjectCode
              , tmpGoods.Name
       HAVING MIN(CASE WHEN tmpProtocol.isLeftTheMarket = TRUE THEN 1 ELSE 0 END) <> MAX(CASE WHEN tmpProtocol.isLeftTheMarket = TRUE THEN 1 ELSE 0 END);

     vbID := 1;
     OPEN curDate FOR SELECT tmpOperDate.OperDate FROM tmpOperDate 
                      ORDER BY tmpOperDate.OperDate;
     LOOP
        FETCH curDate INTO vbDate;
        IF NOT FOUND THEN EXIT; END IF;

        vbQueryText := 'ALTER TABLE tmpData ADD COLUMN Value' || COALESCE (vbID, 0)::Text || ' BOOLEAN NOT NULL DEFAULT FALSE ' ||
                                        ' , ADD COLUMN Color_Calc' || COALESCE (vbID, 0)::Text || ' Integer NOT NULL DEFAULT zc_Color_Greenl()';
        EXECUTE vbQueryText;
        
        vbQueryText := 'UPDATE tmpData SET Value' || COALESCE (vbID, 0)::Text || ' = tmpProtocol.isLeftTheMarket ' ||
                                       ' , Color_Calc' || COALESCE (vbID, 0)::Text || ' = CASE WHEN tmpProtocol.isLeftTheMarket = TRUE THEN zc_Color_Red() ELSE zc_Color_Greenl() END '||
                       'FROM tmpProtocol '||   
                       'WHERE tmpData.GoodsId = tmpProtocol. GoodsId AND tmpProtocol.OperDate <= '''||zfConvert_DateToString(vbDate)||''' '||           
                         'AND tmpProtocol.DateEnd > '''||zfConvert_DateToString(vbDate)||'''';
        EXECUTE vbQueryText;

        vbID := vbID + 1;
     END LOOP;
     CLOSE curDate;   

     --raise notice 'Value 05: %', (select Count(*) from tmpData);   

     -- возвращаем заголовки столбцов и даты
     OPEN cur1 FOR SELECT zfConvert_DateToString(tmpOperDate.OperDate) AS ValueField
               FROM tmpOperDate 
               ORDER BY tmpOperDate.OperDate;  
     RETURN NEXT cur1;

     OPEN cur2 FOR SELECT * FROM tmpData;  
     RETURN NEXT cur2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_SheetWorkTime (TDateTime, Integer, Boolean, TVarChar) OWNER TO postgres;


/*   
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.08.22                                                       * 
*/

-- тест
-- 
select * from gpReport_Goods_LeftTheMarket(inDateStart := ('12.08.2022')::TDateTime , inDateFinal := ('17.08.2022')::TDateTime ,  inSession := '3');