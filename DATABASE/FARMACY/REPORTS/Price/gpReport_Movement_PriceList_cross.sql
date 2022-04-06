DROP FUNCTION IF EXISTS gpReport_Movement_PriceList_cross(TDateTime,TDateTime,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_PriceList_cross(
    IN inStartDate           TDateTime,  -- Дата начала
    IN inEndDate             TDateTime,  -- Дата окончания
    IN inJuridicalId_1       Integer , --
    IN inJuridicalId_2       Integer , --
    IN inJuridicalId_3       Integer , --
    IN inContractId_1        Integer , --
    IN inContractId_2        Integer , --
    IN inContractId_3        Integer , --
    IN inSession             TVarChar    -- сессия пользователя
)
  RETURNS SETOF refcursor 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE cur1 refcursor; 
          cur2 refcursor; 
          curDate refcursor; 
          vbIndex Integer;
          vbOperDate TDateTime;
          vbQueryText Text;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());

    inStartDate := date_trunc('day', inStartDate);
    inEndDate := date_trunc('day', inEndDate); 
    --inEndDate := date_trunc('month', inEndDate) + interval '1 month' - 1 ; 

     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
        SELECT GENERATE_SERIES ( inStartDate, inEndDate, '1 DAY' :: INTERVAL) AS OperDate;

  -- определяем список товаров
  CREATE TEMP TABLE _tmpGoods (GoodsMainId integer, GoodsId integer) ON COMMIT DROP;
     INSERT INTO _tmpGoods (GoodsMainId, GoodsId)
            WITH tmpGoods AS (
                              SELECT DISTINCT ObjectLink_LinkGoods_GoodsMain.ChildObjectId AS GoodsMainId
                                   , ObjectLink_Goods_Object.ObjectId                      AS GoodsId 
                              FROM ObjectLink AS ObjectLink_Goods_Object
                                    INNER JOIN Object AS Object_Goods 
                                            ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId 
                                           AND Object_Goods.isErased = False
                                           AND Object_Goods.DescId = zc_Object_Goods() 
                                    LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_Goods
                                           ON ObjectLink_LinkGoods_Goods.DescId = zc_ObjectLink_LinkGoods_Goods()
                                          AND ObjectLink_LinkGoods_Goods.ChildObjectId = Object_Goods.Id
                                    LEFT JOIN ObjectLink AS ObjectLink_LinkGoods_GoodsMain 
                                           ON ObjectLink_LinkGoods_GoodsMain.ObjectId = ObjectLink_LinkGoods_Goods.ObjectId 
                                          AND ObjectLink_LinkGoods_GoodsMain.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
                              WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object() 
                               -- AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId < 500
                             )

            SELECT DISTINCT tmpGoods.GoodsMainId
                          , ObjectLink_Child_Jurid.ChildObjectId AS GoodsId
            FROM (SELECT DISTINCT tmpGoods.GoodsMainId FROM tmpGoods) AS tmpGoods
                 INNER JOIN ObjectLink AS ObjectLink_Main_Jurid 
                                       ON ObjectLink_Main_Jurid.ChildObjectId = tmpGoods.GoodsMainId
                                      AND ObjectLink_Main_Jurid.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                 INNER JOIN ObjectLink AS ObjectLink_Child_Jurid 
                                       ON ObjectLink_Child_Jurid.ObjectId = ObjectLink_Main_Jurid.ObjectId
                                      AND ObjectLink_Child_Jurid.DescId   = zc_ObjectLink_LinkGoods_Goods()
                 INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                       ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_Jurid.ChildObjectId
                                      AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                      AND ObjectLink_Goods_Object.ChildObjectId in (inJuridicalId_3, inJuridicalId_2, inJuridicalId_1);
  
  CREATE TEMP TABLE _tmpPriceList (OperDate TDateTime, GoodsMainId integer, Price_1 TFloat, Price_2 TFloat, Price_3 TFloat) ON COMMIT DROP; 
     INSERT INTO _tmpPriceList (OperDate, GoodsMainId, Price_1, Price_2, Price_3)
        SELECT tmp.OperDate, tmp.GoodsMainId
             , MAX(tmp.Price_1)  AS Price_1
             , MAX(tmp.Price_2)  AS Price_2
             , MAX(tmp.Price_3)  AS Price_3
        FROM (
             SELECT DISTINCT
                    DATE_TRUNC ('DAY', Movement.OperDate) AS OperDate, tmpGoodsAll.GoodsMainId
                  , CASE WHEN MovementLinkObject_Juridical.ObjectId = inJuridicalId_1 THEN MovementItem.Amount  ELSE 0 END ::TFloat AS Price_1   -- оптима
                  , CASE WHEN MovementLinkObject_Juridical.ObjectId = inJuridicalId_2 THEN MovementItem.Amount  ELSE 0 END ::TFloat AS Price_2   -- бадм
                  , CASE WHEN MovementLinkObject_Juridical.ObjectId = inJuridicalId_3 THEN MovementItem.Amount  ELSE 0 END ::TFloat AS Price_3   -- вента
             FROM Movement
                  INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                               AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                               AND MovementLinkObject_Juridical.ObjectId IN ( inJuridicalId_3,inJuridicalId_2,inJuridicalId_1)
                  INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                               ON MovementLinkObject_Contract.MovementId = Movement.Id
                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                              AND MovementLinkObject_Contract.ObjectId IN (inContractId_1, inContractId_2, inContractId_3) --(183275,183338,183378)              --бадм, оптима, вента
                  JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                   AND MovementItem.DescId     = zc_MI_Master()
                                   AND MovementItem.isErased   = False
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Goods
                                                   ON MILinkObject_Goods.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Goods.DescId = zc_MILinkObject_Goods()
                  INNER JOIN _tmpGoods AS tmpGoodsAll ON tmpGoodsAll.GoodsMainId = MovementItem.ObjectId
                                                     AND tmpGoodsAll.GoodsId     = MILinkObject_Goods.ObjectId
                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId =  MovementItem.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
              WHERE Movement.DescId = zc_Movement_PriceList() 
                AND DATE_TRUNC ('DAY', Movement.OperDate) >= inStartDate AND DATE_TRUNC ('DAY', Movement.OperDate) < inEndDate + interval '1 day' 
                ) AS tmp
        GROUP BY tmp.OperDate, tmp.GoodsMainId;

            
     CREATE TEMP TABLE _tmpGoodsReport (ObjectCode integer, GoodsMainId integer, GoodsName TVarChar) ON COMMIT DROP;
     INSERT INTO _tmpGoodsReport (ObjectCode, GoodsMainId, GoodsName)
                SELECT DISTINCT Object_Goods.ObjectCode
                     , _tmpGoods.GoodsMainId
                     , Object_Goods.ValueData  AS GoodsName
                FROM _tmpGoods
                     INNER JOIN _tmpPriceList ON _tmpPriceList.GoodsMainId = _tmpGoods.GoodsMainId
                     LEFT JOIN Object AS Object_Goods 
                                      ON Object_Goods.Id = _tmpGoods.GoodsMainId
                                     AND Object_Goods.DescId = zc_Object_Goods() ;

    vbIndex := 1;
    -- Данные 
    OPEN curDate FOR
        SELECT tmpOperDate.OperDate 
        FROM tmpOperDate
        ORDER BY tmpOperDate.OperDate;
                  
     -- начало цикла по курсору1
     LOOP
        -- данные по курсору1
        FETCH curDate INTO vbOperDate;
        -- если данные закончились, тогда выход
        IF NOT FOUND THEN EXIT; END IF;

        vbQueryText := 'ALTER TABLE _tmpGoodsReport ADD COLUMN Value1p'||vbIndex::TVarChar || ' TFloat, ADD COLUMN Value2p'||vbIndex::TVarChar || ' TFloat, ADD COLUMN Value3p'||vbIndex::TVarChar || ' TFloat';
        EXECUTE vbQueryText;

        vbQueryText := 'UPDATE _tmpGoodsReport SET Value1p'||vbIndex::Text||' = _tmpPriceList.Price_1
                                                 , Value2p'||vbIndex::Text||' = _tmpPriceList.Price_2
                                                 , Value3p'||vbIndex::Text||' = _tmpPriceList.Price_3
           FROM _tmpPriceList
           WHERE _tmpGoodsReport.GoodsMainId = _tmpPriceList.GoodsMainId
             AND _tmpPriceList.OperDate = '''|| zfConvert_DateShortToString(vbOperDate) ||'''';
             
        EXECUTE vbQueryText;
        
        vbIndex := vbIndex + 1;

    END LOOP; -- финиш цикла по курсору1
    CLOSE curDate; -- закрыли курсор1 
     
     -- Вывод данных
     

     OPEN cur1 FOR SELECT tmpOperDate.OperDate::TDateTime, 
                          ((zfConvert_DateShortToString(tmpOperDate.OperDate))||case when tmpCalendar.Working = False then ' *' else ' ' END||tmpWeekDay.DayOfWeekName) ::TVarChar AS ValueBandName,
                          'Пост. 1' ::TVarChar AS ValueName1,
                          'Пост. 2' ::TVarChar AS ValueName2,
                          'Пост. 3' ::TVarChar AS ValueName3
                   FROM tmpOperDate
                        LEFT JOIN zfCalc_DayOfWeekName (tmpOperDate.OperDate) AS tmpWeekDay ON 1=1
                        LEFT JOIN gpSelect_Object_Calendar(tmpOperDate.OperDate,tmpOperDate.OperDate,inSession) tmpCalendar ON 1=1 
                   ORDER BY tmpOperDate.OperDate;

     RETURN NEXT cur1;


     OPEN cur2 FOR SELECT * FROM _tmpGoodsReport
                   ORDER BY _tmpGoodsReport.GoodsName;  
     RETURN NEXT cur2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpReport_Movement_PriceList_cross (TDateTime, Integer, Boolean, TVarChar) OWNER TO postgres;


/*   
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.04.22                                                       *
 27.04.17         * 
*/

select * from gpReport_Movement_PriceList_cross(inStartDate := ('28.03.2022')::TDateTime , inEndDate := ('03.04.2022')::TDateTime , inJuridicalId_1 := 59611 , inJuridicalId_2 := 59610 , inJuridicalId_3 := 59612 , inContractId_1 := 183338 , inContractId_2 := 183275 , inContractId_3 := 183378 ,  inSession := '3');
