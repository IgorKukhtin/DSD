DROP FUNCTION IF EXISTS gpReport_Movement_PriceList(TDateTime,TDateTime,Integer,Integer,Integer,Integer,Integer,Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_PriceList(
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
  DECLARE Cursor1 refcursor; 
          cur2 refcursor; 
          vbIndex Integer;
          vbCount Integer;
          vbQueryText Text;
          vbFieldNameText Text;
  DECLARE vbEndDate TDateTime; 

BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());

    inStartDate := date_trunc('day', inStartDate);
    vbEndDate := date_trunc('month', inStartDate) + interval '1 month' - interval '1 day' ; 
    inEndDate := CASE WHEN date_trunc('day', inEndDate) > vbEndDate THEN vbEndDate ELSE date_trunc('day', inEndDate) END ; 

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
                              WHERE ObjectLink_Goods_Object.ChildObjectId  = inJuridicalId_1 --59611 --inObjectId  --in ( 59612,59610,59611) -- оптима
                                AND ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object() 
                             --   AND ObjectLink_LinkGoods_GoodsMain.ChildObjectId = 324
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
                                      AND ObjectLink_Goods_Object.ChildObjectId in ( inJuridicalId_3,inJuridicalId_2,inJuridicalId_1) --vbObjectId
--            WHERE GoodsMainId = 324
;
  
  CREATE TEMP TABLE _tmpPriceList (OperDate TDateTime, GoodsMainId integer, Price_1 TFloat, Price_2 TFloat, Price_3 TFloat) ON COMMIT DROP; /*tmpMI */
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
                AND DATE_TRUNC ('DAY', Movement.OperDate) >= inStartDate AND DATE_TRUNC ('DAY', Movement.OperDate) < inEndDate + interval '1 day'  -- '01.12.2016' --
              --  and MovementItem.ObjectId = 324
                ) AS tmp
        GROUP BY tmp.OperDate, tmp.GoodsMainId;

            
  CREATE TEMP TABLE _tmpGoodsReport (CommonCode integer, GoodsMainId integer, GoodsCode integer, GoodsName TVarChar) ON COMMIT DROP;
     INSERT INTO _tmpGoodsReport (CommonCode, GoodsMainId, GoodsCode, GoodsName)
                SELECT DISTINCT _tmpGoods.CommonCode
                     , _tmpGoods.GoodsMainId
                     , Object_Goods.ObjectCode AS GoodsCode
                     , Object_Goods.ValueData  AS GoodsName
                FROM _tmpGoods
                     LEFT JOIN Object AS Object_Goods 
                                      ON Object_Goods.Id = _tmpGoods.GoodsMainId
                                     AND Object_Goods.isErased = False
                                     AND Object_Goods.DescId = zc_Object_Goods() ;


     -- все данные  
     CREATE TEMP TABLE tmpMI ON COMMIT DROP AS
           SELECT tmpOperDate.OperDate
                , EXTRACT(DAY FROM tmpOperDate.OperDate) AS NumDay
                , _tmpGoodsReport.GoodsMainId
                , _tmpGoodsReport.CommonCode
                , _tmpGoodsReport.GoodsCode
                , _tmpGoodsReport.GoodsName
                , _tmpPriceList.Price_1
                , _tmpPriceList.Price_2
                , _tmpPriceList.Price_3
           FROM tmpOperDate
                LEFT JOIN _tmpGoodsReport ON 1 = 1
                LEFT JOIN _tmpPriceList ON _tmpPriceList.OperDate = tmpOperDate.OperDate
                                       AND _tmpPriceList.GoodsMainId = _tmpGoodsReport.GoodsMainId           
           ;

     vbIndex := 0;
     -- кол-во категорий наценок 
     vbCount := (SELECT COUNT(*) FROM tmpOperDate);

    OPEN Cursor1 FOR
     SELECT tmp.GoodsMainId
          , tmp.CommonCode
          , tmp.GoodsCode
          , tmp.GoodsName
          , SUM(tmp.Price_1_1) ::TFloat AS Price_1_1, SUM(tmp.Price_2_1) ::TFloat AS Price_2_1, SUM(tmp.Price_3_1) ::TFloat AS Price_3_1
          , SUM(tmp.Price_1_2) ::TFloat AS Price_1_2, SUM(tmp.Price_2_2) ::TFloat AS Price_2_2, SUM(tmp.Price_3_2) ::TFloat AS Price_3_2
          , SUM(tmp.Price_1_3) ::TFloat AS Price_1_3, SUM(tmp.Price_2_3) ::TFloat AS Price_2_3, SUM(tmp.Price_3_3) ::TFloat AS Price_3_3
          , SUM(tmp.Price_1_4) ::TFloat AS Price_1_4, SUM(tmp.Price_2_4) ::TFloat AS Price_2_4, SUM(tmp.Price_3_4) ::TFloat AS Price_3_4
          , SUM(tmp.Price_1_5) ::TFloat AS Price_1_5, SUM(tmp.Price_2_5) ::TFloat AS Price_2_5, SUM(tmp.Price_3_5) ::TFloat AS Price_3_5
          , SUM(tmp.Price_1_6) ::TFloat AS Price_1_6, SUM(tmp.Price_2_6) ::TFloat AS Price_2_6, SUM(tmp.Price_3_6) ::TFloat AS Price_3_6
          , SUM(tmp.Price_1_7) ::TFloat AS Price_1_7, SUM(tmp.Price_2_7) ::TFloat AS Price_2_7, SUM(tmp.Price_3_7) ::TFloat AS Price_3_7
          , SUM(tmp.Price_1_8) ::TFloat AS Price_1_8, SUM(tmp.Price_2_8) ::TFloat AS Price_2_8, SUM(tmp.Price_3_8) ::TFloat AS Price_3_8
          , SUM(tmp.Price_1_9) ::TFloat AS Price_1_9, SUM(tmp.Price_2_9) ::TFloat AS Price_2_9, SUM(tmp.Price_3_9) ::TFloat AS Price_3_9
          , SUM(tmp.Price_1_10) ::TFloat AS Price_1_10, SUM(tmp.Price_2_10) ::TFloat AS Price_1_10,SUM(tmp.Price_3_10) ::TFloat AS Price_3_10
          , SUM(tmp.Price_1_11) ::TFloat AS Price_1_11, SUM(tmp.Price_2_11) ::TFloat AS Price_2_11, SUM(tmp.Price_3_11) ::TFloat AS Price_3_11
          , SUM(tmp.Price_1_12) ::TFloat AS Price_1_12, SUM(tmp.Price_2_12) ::TFloat AS Price_2_12, SUM(tmp.Price_3_12) ::TFloat AS Price_3_12
          , SUM(tmp.Price_1_13) ::TFloat AS Price_1_13, SUM(tmp.Price_2_13) ::TFloat AS Price_1_13, SUM(tmp.Price_3_13) ::TFloat AS Price_3_13
          , SUM(tmp.Price_1_14) ::TFloat AS Price_1_14, SUM(tmp.Price_2_14) ::TFloat AS Price_2_14, SUM(tmp.Price_3_14) ::TFloat AS Price_3_14
          , SUM(tmp.Price_1_15) ::TFloat AS Price_1_15, SUM(tmp.Price_2_15) ::TFloat AS Price_2_15, SUM(tmp.Price_3_15) ::TFloat AS Price_3_15
          , SUM(tmp.Price_1_16) ::TFloat AS Price_1_16, SUM(tmp.Price_2_16) ::TFloat AS Price_2_16, SUM(tmp.Price_3_16) ::TFloat AS Price_3_16
          , SUM(tmp.Price_1_17) ::TFloat AS Price_1_17, SUM(tmp.Price_2_17) ::TFloat AS Price_2_17, SUM(tmp.Price_3_17) ::TFloat AS Price_3_17
          , SUM(tmp.Price_1_18) ::TFloat AS Price_1_18, SUM(tmp.Price_2_18) ::TFloat AS Price_2_18, SUM(tmp.Price_3_18) ::TFloat AS Price_3_18
          , SUM(tmp.Price_1_19) ::TFloat AS Price_1_19, SUM(tmp.Price_2_19) ::TFloat AS Price_2_19, SUM(tmp.Price_3_19) ::TFloat AS Price_3_19
          , SUM(tmp.Price_1_20) ::TFloat AS Price_1_20, SUM(tmp.Price_2_20) ::TFloat AS Price_2_20, SUM(tmp.Price_3_20) ::TFloat AS Price_3_20
          , SUM(tmp.Price_1_21) ::TFloat AS Price_1_21, SUM(tmp.Price_2_21) ::TFloat AS Price_2_21, SUM(tmp.Price_3_21) ::TFloat AS Price_3_21
          , SUM(tmp.Price_1_22) ::TFloat AS Price_1_22, SUM(tmp.Price_2_22) ::TFloat AS Price_2_22, SUM(tmp.Price_3_22) ::TFloat AS Price_3_22
          , SUM(tmp.Price_1_23) ::TFloat AS Price_1_23, SUM(tmp.Price_2_23) ::TFloat AS Price_2_23, SUM(tmp.Price_3_23) ::TFloat AS Price_3_23
          , SUM(tmp.Price_1_24) ::TFloat AS Price_1_24, SUM(tmp.Price_2_24) ::TFloat AS Price_2_24, SUM(tmp.Price_3_24) ::TFloat AS Price_3_24
          , SUM(tmp.Price_1_25) ::TFloat AS Price_1_25, SUM(tmp.Price_2_25) ::TFloat AS Price_2_25, SUM(tmp.Price_3_25) ::TFloat AS Price_3_25
          , SUM(tmp.Price_1_26) ::TFloat AS Price_1_26, SUM(tmp.Price_2_26) ::TFloat AS Price_2_26, SUM(tmp.Price_3_26) ::TFloat AS Price_3_26
          , SUM(tmp.Price_1_27) ::TFloat AS Price_1_27, SUM(tmp.Price_2_27) ::TFloat AS Price_2_27, SUM(tmp.Price_3_27) ::TFloat AS Price_3_26
          , SUM(tmp.Price_1_28) ::TFloat AS Price_1_28, SUM(tmp.Price_2_28) ::TFloat AS Price_2_28, SUM(tmp.Price_3_28) ::TFloat AS Price_3_28
          , SUM(tmp.Price_1_29) ::TFloat AS Price_1_29, SUM(tmp.Price_2_29) ::TFloat AS Price_2_29, SUM(tmp.Price_3_29) ::TFloat AS Price_3_29
          , SUM(tmp.Price_1_30) ::TFloat AS Price_1_30, SUM(tmp.Price_2_30) ::TFloat AS Price_2_30, SUM(tmp.Price_3_30) ::TFloat AS Price_3_30
          , SUM(tmp.Price_1_31) ::TFloat AS Price_1_31, SUM(tmp.Price_2_31) ::TFloat AS Price_2_31, SUM(tmp.Price_3_31) ::TFloat AS Price_3_31
          , zc_Color_Aqua() AS Color1
          , zc_Color_White()  AS Color2
     FROM (SELECT tmpMI.GoodsMainId
                , tmpMI.CommonCode
                , tmpMI.GoodsCode
                , tmpMI.GoodsName
                , CASE WHEN tmpMI.NumDay = 1 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_1
                , CASE WHEN tmpMI.NumDay = 1 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_1
                , CASE WHEN tmpMI.NumDay = 1 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_1

                , CASE WHEN tmpMI.NumDay = 2 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_2
                , CASE WHEN tmpMI.NumDay = 2 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_2
                , CASE WHEN tmpMI.NumDay = 2 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_2

                , CASE WHEN tmpMI.NumDay = 3 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_3
                , CASE WHEN tmpMI.NumDay = 3 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_3
                , CASE WHEN tmpMI.NumDay = 3 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_3

                , CASE WHEN tmpMI.NumDay = 4 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_4
                , CASE WHEN tmpMI.NumDay = 4 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_4
                , CASE WHEN tmpMI.NumDay = 4 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_4

                , CASE WHEN tmpMI.NumDay = 5 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_5
                , CASE WHEN tmpMI.NumDay = 5 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_5
                , CASE WHEN tmpMI.NumDay = 5 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_5

                , CASE WHEN tmpMI.NumDay = 6 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_6
                , CASE WHEN tmpMI.NumDay = 6 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_6
                , CASE WHEN tmpMI.NumDay = 6 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_6

                , CASE WHEN tmpMI.NumDay = 7 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_7
                , CASE WHEN tmpMI.NumDay = 7 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_7
                , CASE WHEN tmpMI.NumDay = 7 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_7

                , CASE WHEN tmpMI.NumDay = 8 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_8
                , CASE WHEN tmpMI.NumDay = 8 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_8
                , CASE WHEN tmpMI.NumDay = 8 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_8

                , CASE WHEN tmpMI.NumDay = 9 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_9
                , CASE WHEN tmpMI.NumDay = 9 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_9
                , CASE WHEN tmpMI.NumDay = 9 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_9

                , CASE WHEN tmpMI.NumDay = 10 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_10
                , CASE WHEN tmpMI.NumDay = 10 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_10
                , CASE WHEN tmpMI.NumDay = 10 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_10

                , CASE WHEN tmpMI.NumDay = 11 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_11
                , CASE WHEN tmpMI.NumDay = 11 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_11
                , CASE WHEN tmpMI.NumDay = 11 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_11

                , CASE WHEN tmpMI.NumDay = 12 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_12
                , CASE WHEN tmpMI.NumDay = 12 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_12
                , CASE WHEN tmpMI.NumDay = 12 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_12

                , CASE WHEN tmpMI.NumDay = 13 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_13
                , CASE WHEN tmpMI.NumDay = 13 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_13
                , CASE WHEN tmpMI.NumDay = 13 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_13

                , CASE WHEN tmpMI.NumDay = 14 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_14
                , CASE WHEN tmpMI.NumDay = 14 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_14
                , CASE WHEN tmpMI.NumDay = 14 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_14

                , CASE WHEN tmpMI.NumDay = 15 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_15
                , CASE WHEN tmpMI.NumDay = 15 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_15
                , CASE WHEN tmpMI.NumDay = 15 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_15

                , CASE WHEN tmpMI.NumDay = 16 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_16
                , CASE WHEN tmpMI.NumDay = 16 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_16
                , CASE WHEN tmpMI.NumDay = 16 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_16

                , CASE WHEN tmpMI.NumDay = 17 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_17
                , CASE WHEN tmpMI.NumDay = 17 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_17
                , CASE WHEN tmpMI.NumDay = 17 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_17

                , CASE WHEN tmpMI.NumDay = 18 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_18
                , CASE WHEN tmpMI.NumDay = 18 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_18
                , CASE WHEN tmpMI.NumDay = 18 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_18

                , CASE WHEN tmpMI.NumDay = 19 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_19
                , CASE WHEN tmpMI.NumDay = 19 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_19
                , CASE WHEN tmpMI.NumDay = 19 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_19

                , CASE WHEN tmpMI.NumDay = 20 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_20
                , CASE WHEN tmpMI.NumDay = 20 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_20
                , CASE WHEN tmpMI.NumDay = 20 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_20

                , CASE WHEN tmpMI.NumDay = 21 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_21
                , CASE WHEN tmpMI.NumDay = 21 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_21
                , CASE WHEN tmpMI.NumDay = 21 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_21
                
                , CASE WHEN tmpMI.NumDay = 22 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_22
                , CASE WHEN tmpMI.NumDay = 22 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_22
                , CASE WHEN tmpMI.NumDay = 22 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_22

                , CASE WHEN tmpMI.NumDay = 23 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_23
                , CASE WHEN tmpMI.NumDay = 23 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_23
                , CASE WHEN tmpMI.NumDay = 23 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_23

                , CASE WHEN tmpMI.NumDay = 24 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_24
                , CASE WHEN tmpMI.NumDay = 24 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_24
                , CASE WHEN tmpMI.NumDay = 24 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_24

                , CASE WHEN tmpMI.NumDay = 25 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_25
                , CASE WHEN tmpMI.NumDay = 25 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_25
                , CASE WHEN tmpMI.NumDay = 25 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_25

                , CASE WHEN tmpMI.NumDay = 26 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_26
                , CASE WHEN tmpMI.NumDay = 26 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_26
                , CASE WHEN tmpMI.NumDay = 26 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_26

                , CASE WHEN tmpMI.NumDay = 27 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_27
                , CASE WHEN tmpMI.NumDay = 27 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_27
                , CASE WHEN tmpMI.NumDay = 27 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_27

                , CASE WHEN tmpMI.NumDay = 28 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_28
                , CASE WHEN tmpMI.NumDay = 28 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_28
                , CASE WHEN tmpMI.NumDay = 28 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_28

                , CASE WHEN tmpMI.NumDay = 29 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_29
                , CASE WHEN tmpMI.NumDay = 29 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_29
                , CASE WHEN tmpMI.NumDay = 29 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_29

                , CASE WHEN tmpMI.NumDay = 30 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_30
                , CASE WHEN tmpMI.NumDay = 30 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_30
                , CASE WHEN tmpMI.NumDay = 30 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_30

                , CASE WHEN tmpMI.NumDay = 31 THEN tmpMI.Price_1 ELSE 0 END AS Price_1_31
                , CASE WHEN tmpMI.NumDay = 31 THEN tmpMI.Price_2 ELSE 0 END AS Price_2_31
                , CASE WHEN tmpMI.NumDay = 31 THEN tmpMI.Price_3 ELSE 0 END AS Price_3_31
           FROM tmpMI) AS tmp
        GROUP BY tmp.GoodsMainId
               , tmp.CommonCode
               , tmp.GoodsCode
               , tmp.GoodsName

   ;
  RETURN NEXT Cursor1;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpReport_Movement_PriceList (TDateTime, Integer, Boolean, TVarChar) OWNER TO postgres;


/*   
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
04.05.17         * 
*/
--select * from gpReport_Movement_PriceList(inStartDate := ('01.12.2016')::TDateTime , inEndDate := ('13.12.2016')::TDateTime , inJuridicalId_1 := 59611 , inJuridicalId_2 := 59610 , inJuridicalId_3 := 59612 , inContractId_1 := 183338 , inContractId_2 := 183275 , inContractId_3 := 183378 ,  inSession := '3');
 --FETCH ALL "<unnamed portal 5>";