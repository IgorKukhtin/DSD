DROP FUNCTION IF EXISTS gpReport_Movement_PriceList_cross(TDateTime,TDateTime,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_PriceList_cross(
    IN inStartDate           TDateTime,  -- Дата начала
    IN inEndDate             TDateTime,  -- Дата окончания
    IN inJuridicalId_Optima  Integer , --
    IN inJuridicalId_BADM    Integer , --
    IN inJuridicalId_Venta   Integer , --
    IN inContractId_Optima   Integer , --
    IN inContractId_BADM     Integer , --
    IN inContractId_Venta    Integer , --
    IN inSession             TVarChar    -- сессия пользователя
)
  RETURNS SETOF refcursor 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE cur1 refcursor; 
          cur2 refcursor; 
          vbIndex Integer;
          vbCount Integer;
          vbCrossString Text;
          vbQueryText Text;
          vbFieldNameText Text;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());

    inStartDate := date_trunc('month', inStartDate);
    inEndDate := date_trunc('month', inEndDate); 
    --inEndDate := date_trunc('month', inEndDate) + interval '1 month' - 1 ; 

     CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
        SELECT GENERATE_SERIES ( inStartDate, inEndDate, '1 DAY' :: INTERVAL) AS OperDate;

  -- определяем список товаров
  CREATE TEMP TABLE _tmpGoods (CommonCode integer, GoodsMainId integer, GoodsId integer) ON COMMIT DROP;
     INSERT INTO _tmpGoods (CommonCode, GoodsMainId, GoodsId)
            WITH tmpGoods AS (
                              SELECT DISTINCT COALESCE(Object_LinkGoods_View.GoodsCode, Object_LinkGoods_View.GoodsCodeInt::TVarChar) ::Integer AS CommonCode
                                   , ObjectLink_LinkGoods_GoodsMain.ChildObjectId     AS GoodsMainId
                                   , ObjectLink_Goods_Object.ObjectId                 AS GoodsId 
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
                                    LEFT JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsmainId = ObjectLink_LinkGoods_Goodsmain.ChildObjectId
                                         AND Object_LinkGoods_View.ObjectId = zc_Enum_GlobalConst_Marion()
                              WHERE ObjectLink_Goods_Object.ChildObjectId  = 59611 --inObjectId  --in ( 59612,59610,59611) --
                                AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object() 
                                AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = 324
                             )

            SELECT DISTINCT tmpGoods.CommonCode, tmpGoods.GoodsMainId
                 , ObjectLink_Child_Jurid.ChildObjectId AS GoodsId
            FROM (SELECT DISTINCT tmpGoods.GoodsMainId, tmpGoods.CommonCode FROM tmpGoods) AS tmpGoods
                 INNER JOIN ObjectLink AS ObjectLink_Main_Jurid 
                                       ON ObjectLink_Main_Jurid.ChildObjectId = tmpGoods.GoodsMainId --ObjectLink_Main.ChildObjectId
                                      AND ObjectLink_Main_Jurid.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                 INNER JOIN ObjectLink AS ObjectLink_Child_Jurid 
                                       ON ObjectLink_Child_Jurid.ObjectId = ObjectLink_Main_Jurid.ObjectId
                                      AND ObjectLink_Child_Jurid.DescId   = zc_ObjectLink_LinkGoods_Goods()
                 INNER JOIN ObjectLink AS ObjectLink_Goods_Object
                                       ON ObjectLink_Goods_Object.ObjectId = ObjectLink_Child_Jurid.ChildObjectId
                                      AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                                      AND ObjectLink_Goods_Object.ChildObjectId in ( 59612,59610,59611) --vbObjectId
            WHERE GoodsMainId = 324;
  
  CREATE TEMP TABLE _tmpPriceList (OperDate TDateTime, GoodsMainId integer, Price_Badm TFloat, Price_Opt TFloat, Price_Venta TFloat) ON COMMIT DROP; /*tmpMI */
     INSERT INTO _tmpPriceList (OperDate, GoodsMainId, Price_Badm, Price_Opt, Price_Venta)
        SELECT tmp.OperDate, tmp.GoodsMainId
             , MAX(tmp.Price_Badm)  AS Price_Badm
             , MAX(tmp.Price_Opt)   AS Price_Opt
             , MAX(tmp.Price_Venta) AS Price_Venta
        FROM (
             SELECT DISTINCT
                    DATE_TRUNC ('DAY', Movement.OperDate) AS OperDate, tmpGoodsAll.GoodsMainId
                  , CASE WHEN MovementLinkObject_Juridical.ObjectId = 59610 THEN MovementItem.Amount  ELSE 0 END ::TFloat AS Price_Badm   -- бадм
                  , CASE WHEN MovementLinkObject_Juridical.ObjectId = 59611 THEN MovementItem.Amount  ELSE 0 END ::TFloat AS Price_Opt   -- оптима
                  , CASE WHEN MovementLinkObject_Juridical.ObjectId = 59612 THEN MovementItem.Amount  ELSE 0 END ::TFloat AS Price_Venta   -- вента
             FROM Movement
                  INNER JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                                ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                               AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
                                               AND MovementLinkObject_Juridical.ObjectId IN ( 59612,59610,59611)
                  INNER JOIN MovementLinkObject AS MovementLinkObject_Contract
                                               ON MovementLinkObject_Contract.MovementId = Movement.Id
                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                              AND MovementLinkObject_Contract.ObjectId IN (183275,183338,183378)              --бадм, оптима, вента
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
              WHERE --Movement.Id = 3924465
                    Movement.DescId = zc_Movement_PriceList() 
                AND DATE_TRUNC ('DAY', Movement.OperDate) >= '01.12.2016' --BETWEEN inStartDate AND inEndDate  
                and MovementItem.ObjectId = 324
                ) AS tmp
        GROUP BY tmp.OperDate, tmp.GoodsMainId;

            
  CREATE TEMP TABLE _tmpGoodsReport (CommonCode integer, GoodsMainId integer, GoodsName TVarChar) ON COMMIT DROP;
     INSERT INTO _tmpGoodsReport (CommonCode, GoodsMainId, GoodsName)
                SELECT DISTINCT _tmpGoods.CommonCode
                     , _tmpGoods.GoodsMainId
                     , Object_Goods.ValueData  AS GoodsName
                FROM _tmpGoods
                     LEFT JOIN Object AS Object_Goods 
                                      ON Object_Goods.Id = _tmpGoods.GoodsMainId
                                     AND Object_Goods.isErased = False
                                     AND Object_Goods.DescId = zc_Object_Goods() ;


     -- все данные  
     CREATE TEMP TABLE tmpMI ON COMMIT DROP AS
           SELECT tmpOperDate.OperDate
                , _tmpGoodsReport.GoodsMainId
                , _tmpPriceList.Price_Badm
                , _tmpPriceList.Price_Opt
                , _tmpPriceList.Price_Venta
           FROM tmpOperDate
                LEFT JOIN _tmpGoodsReport ON 1 = 1
                LEFT JOIN _tmpPriceList ON _tmpPriceList.OperDate = tmpOperDate.OperDate
                                       AND _tmpPriceList.GoodsMainId = _tmpGoodsReport.GoodsMainId           
           ;

     vbIndex := 0;
     -- кол-во категорий наценок 
     vbCount := (SELECT COUNT(*) FROM tmpOperDate);


     vbCrossString := 'Key Integer[]';
     vbFieldNameText := '';
     -- строим строчку для кросса
     WHILE (vbIndex < vbCount) LOOP
       vbIndex := vbIndex + 1;
       vbCrossString := vbCrossString || ', DAY' || vbIndex || ' VarChar[]'; 
       vbFieldNameText := vbFieldNameText || ', DAY' || vbIndex || '[1] :: TFloat AS Value'||vbIndex||'  '||
                                             ', DAY' || vbIndex || '[2]::Integer  AS GoodsMainId'||vbIndex||' ';
     END LOOP;

     OPEN cur1 FOR SELECT tmpOperDate.OperDate::TDateTime, 
                          ((EXTRACT(DAY FROM tmpOperDate.OperDate))||case when tmpCalendar.Working = False then ' *' else ' ' END||tmpWeekDay.DayOfWeekName) ::TVarChar AS ValueField
                   FROM tmpOperDate
                        LEFT JOIN zfCalc_DayOfWeekName (tmpOperDate.OperDate) AS tmpWeekDay ON 1=1
                        LEFT JOIN gpSelect_Object_Calendar(tmpOperDate.OperDate,tmpOperDate.OperDate,inSession) tmpCalendar ON 1=1 
     ; 

     RETURN NEXT cur1;

     vbQueryText := '
          SELECT _tmpGoodsReport.GoodsMainId
               , _tmpGoodsReport.GoodsName
               '|| vbFieldNameText ||'
          FROM
         (SELECT * FROM CROSSTAB (''
                                    SELECT ARRAY[COALESCE (Movement_Data.GoodsMainId, Object_Data.GoodsMainId)           -- AS GoodsId
                                                ] :: Integer[]
                                         , COALESCE (Movement_Data.OperDate, Object_Data.OperDate) AS OperDate
                                         , ARRAY[ COALESCE(Movement_Data.Amount,0) :: VarChar
                                                ] :: TVarChar
                                    FROM (SELECT * FROM tmpMI) AS Movement_Data
                                        FULL JOIN  
                                         (SELECT tmpOperDate.operdate, 0, 
                                                 COALESCE(_tmpGoodsReport.GoodsMainId, 0) AS GoodsMainId 
                                            FROM tmpOperDate, _tmpGoodsReport 
                                        ) AS Object_Data
                                           ON Object_Data.OperDate = Movement_Data.OperDate
                                          AND Object_Data.GoodsMainId = Movement_Data.GoodsMainId
                                  order by 1,2''
                                , ''SELECT OperDate FROM tmpOperDate order by 1
                                  '') AS CT (' || vbCrossString || ')
         ) AS D
         LEFT JOIN _tmpGoodsReport ON _tmpGoodsReport.GoodsMainId = D.Key[1]
        ORDER BY _tmpGoodsReport.GoodsName
        ';


     OPEN cur2 FOR EXECUTE vbQueryText;  
     RETURN NEXT cur2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpReport_Movement_PriceList_cross (TDateTime, Integer, Boolean, TVarChar) OWNER TO postgres;


/*   
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.01.16         * 
*/