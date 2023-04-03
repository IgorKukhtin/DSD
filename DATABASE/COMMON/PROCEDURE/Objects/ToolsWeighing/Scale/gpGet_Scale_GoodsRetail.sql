-- Function: gpGet_Scale_GoodsRetail()

DROP FUNCTION IF EXISTS gpGet_Scale_GoodsRetail (TVarChar, Integer, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Scale_GoodsRetail (TVarChar, Integer, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_GoodsRetail(
    IN inBarCode               TVarChar,
    IN inGoodsPropertyId       Integer,
    IN inOperDate              TDateTime,
    IN inOrderExternalId       Integer,
    IN inPriceListId           Integer,
    IN inBranchCode            Integer,      -- 
    IN inSession               TVarChar      -- сессия пользователя
)
RETURNS TABLE (GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsKindId Integer, GoodsKindCode Integer, GoodsKindName TVarChar
             , MeasureId Integer, MeasureName TVarChar
             , RealWeight TFloat
             , ChangePercentAmount TFloat
             , CountTare TFloat
             , WeightTare TFloat
             , Price TFloat
             , CountForPrice TFloat
             , Price_Return TFloat
             , CountForPrice_Return TFloat
             , MovementId_Promo Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate_Begin1 TDateTime;
BEGIN
     -- сразу запомнили время начала выполнения Проц.
     vbOperDate_Begin1:= CLOCK_TIMESTAMP();

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpGetUserBySession (inSession); убрал, что б быстрее... :)
     vbUserId:= lpGetUserBySession (inSession);


    -- IF vbUserId = 5
    -- THEN
    --     RAISE EXCEPTION '<%>', lfGet_Object_ValueData (inGoodsPropertyId);
    -- END IF;


    -- !!!меняется параметр!!!
    IF inOrderExternalId <> 0 AND COALESCE (inGoodsPropertyId, 0) = 0
    THEN
        inGoodsPropertyId:= (SELECT zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId, ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_Partner.ObjectId) AS GoodsPropertyId
                             FROM MovementLinkObject AS MovementLinkObject_Partner
                                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                               ON MovementLinkObject_Contract.MovementId = MovementLinkObject_Partner.MovementId
                                                              AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                  LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                       ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_Partner.ObjectId
                                                      AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                             WHERE MovementLinkObject_Partner.MovementId IN (SELECT inOrderExternalId
                                                                            UNION
                                                                             SELECT MLM_Order.MovementChildId FROM MovementLinkMovement AS MLM_Order WHERE MLM_Order.MovementId = inOrderExternalId AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
                                                                            )
                               AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                            );
    END IF;
    -- !!!меняется параметр!!!
    IF COALESCE (inGoodsPropertyId, 0) = 0
    THEN
        -- inGoodsPropertyId:= 0;
        inGoodsPropertyId:= 713462; -- Фоззи
        -- inGoodsPropertyId:= 83956; -- Фора
        -- inGoodsPropertyId:= 83963; -- Ашан
    END IF;


    -- Результат - по заявке
    RETURN QUERY
       WITH tmpGoodsProperty AS (SELECT tmp.GoodsPropertyId
                                      , tmp.StartPosInt
                                      , tmp.EndPosInt
                                      , tmp.StartPosFrac
                                      , tmp.EndPosFrac
                                      , zfFormat_BarCodeShort (inBarCode)  AS BarCodeShort_sht
                                      , zfFormat_BarCodeShort (SUBSTRING (inBarCode FROM tmp.StartPosIdent :: Integer FOR (1 + tmp.EndPosIdent - tmp.StartPosIdent) :: Integer)) AS BarCodeShort
                                 FROM (SELECT Object_GoodsProperty.Id            AS GoodsPropertyId
                                            , CASE WHEN inGoodsPropertyId = 83955 -- Алан
                                                    AND SUBSTRING (inBarCode FROM 1 FOR 3) = '220'
                                                        THEN ObjectFloat_StartPosInt.ValueData + 1 - 1 --***
                                                   ELSE ObjectFloat_StartPosInt.ValueData
                                              END AS StartPosInt
                                            , ObjectFloat_EndPosInt.ValueData    AS EndPosInt
                                            , ObjectFloat_StartPosFrac.ValueData AS StartPosFrac
                                            , ObjectFloat_EndPosFrac.ValueData   AS EndPosFrac
                                            , CASE WHEN ObjectFloat_StartPosIdent.ValueData > 0
                                                        THEN ObjectFloat_StartPosIdent.ValueData
                                                   ELSE 1
                                              END AS StartPosIdent
                                            , CASE WHEN ObjectFloat_EndPosIdent.ValueData > 0
                                                        THEN ObjectFloat_EndPosIdent.ValueData
                                                   ELSE CASE WHEN inGoodsPropertyId = 83955 -- Алан
                                                              AND SUBSTRING (inBarCode FROM 1 FOR 3) = '220'
                                                                  THEN ObjectFloat_StartPosInt.ValueData + 0 - 1 --***
                                                             ELSE ObjectFloat_StartPosInt.ValueData - 1
                                                        END
                                              END AS EndPosIdent
                                       FROM Object AS Object_GoodsProperty
                                            LEFT JOIN ObjectFloat AS ObjectFloat_StartPosIdent 
                                                                  ON ObjectFloat_StartPosIdent.ObjectId = Object_GoodsProperty.Id 
                                                                 AND ObjectFloat_StartPosIdent.DescId = zc_ObjectFloat_GoodsProperty_StartPosIdent()
                                            LEFT JOIN ObjectFloat AS ObjectFloat_EndPosIdent 
                                                                  ON ObjectFloat_EndPosIdent.ObjectId = Object_GoodsProperty.Id 
                                                                 AND ObjectFloat_EndPosIdent.DescId = zc_ObjectFloat_GoodsProperty_EndPosIdent()

                                            LEFT JOIN ObjectFloat AS ObjectFloat_StartPosInt
                                                                  ON ObjectFloat_StartPosInt.ObjectId = Object_GoodsProperty.Id
                                                                 AND ObjectFloat_StartPosInt.DescId = zc_ObjectFloat_GoodsProperty_StartPosInt()
                                            LEFT JOIN ObjectFloat AS ObjectFloat_EndPosInt
                                                                  ON ObjectFloat_EndPosInt.ObjectId = Object_GoodsProperty.Id
                                                                 AND ObjectFloat_EndPosInt.DescId = zc_ObjectFloat_GoodsProperty_EndPosInt()
                                            LEFT JOIN ObjectFloat AS ObjectFloat_StartPosFrac
                                                                  ON ObjectFloat_StartPosFrac.ObjectId = Object_GoodsProperty.Id
                                                                 AND ObjectFloat_StartPosFrac.DescId = zc_ObjectFloat_GoodsProperty_StartPosFrac()
                                            LEFT JOIN ObjectFloat AS ObjectFloat_EndPosFrac
                                                                  ON ObjectFloat_EndPosFrac.ObjectId = Object_GoodsProperty.Id
                                                                 AND ObjectFloat_EndPosFrac.DescId = zc_ObjectFloat_GoodsProperty_EndPosFrac()
                                       WHERE Object_GoodsProperty.Id = inGoodsPropertyId
                                         AND Object_GoodsProperty.DescId = zc_Object_GoodsProperty()
                                         AND ObjectFloat_StartPosInt.ValueData > 1
                                      ) AS tmp
                                 WHERE 1 + tmp.EndPosIdent - tmp.StartPosIdent > 0
                                )
       , tmpGoodsPropertyValue_sht AS (SELECT tmpGoodsProperty.StartPosInt
                                            , tmpGoodsProperty.EndPosInt
                                            , tmpGoodsProperty.StartPosFrac
                                            , tmpGoodsProperty.EndPosFrac
                                            , ObjectString_BarCodeShort.ObjectId AS Id
                                       FROM tmpGoodsProperty
                                            INNER JOIN ObjectString AS ObjectString_BarCodeShort
                                                                    ON ObjectString_BarCodeShort.ValueData = tmpGoodsProperty.BarCodeShort_sht
                                                                   AND ObjectString_BarCodeShort.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeShort()
                                            INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                                  ON ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId = ObjectString_BarCodeShort.ObjectId
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                       LIMIT 1
                                      )
        , tmpGoodsPropertyValue_kg AS (SELECT tmpGoodsProperty.StartPosInt
                                            , tmpGoodsProperty.EndPosInt
                                            , tmpGoodsProperty.StartPosFrac
                                            , tmpGoodsProperty.EndPosFrac
                                            , ObjectString_BarCodeShort.ObjectId AS Id
                                       FROM tmpGoodsProperty
                                            INNER JOIN ObjectString AS ObjectString_BarCodeShort
                                                                    ON ObjectString_BarCodeShort.ValueData = tmpGoodsProperty.BarCodeShort
                                                                   AND ObjectString_BarCodeShort.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeShort()
                                            INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                                  ON ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId = ObjectString_BarCodeShort.ObjectId
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                       WHERE NOT EXISTS (SELECT 1 FROM tmpGoodsPropertyValue_sht)
                                       LIMIT 1
                                      )
           , tmpGoodsPropertyValue AS (SELECT tmpGoodsPropertyValue_sht.StartPosInt
                                            , tmpGoodsPropertyValue_sht.EndPosInt
                                            , tmpGoodsPropertyValue_sht.StartPosFrac
                                            , tmpGoodsPropertyValue_sht.EndPosFrac
                                            , tmpGoodsPropertyValue_sht.Id
                                            , ObjectLink_Goods.ChildObjectId         AS GoodsId
                                            , ObjectLink_Goods_Measure.ChildObjectId AS MeasureId
                                       FROM tmpGoodsPropertyValue_sht
                                            LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                                 ON ObjectLink_Goods.ObjectId = tmpGoodsPropertyValue_sht.Id
                                                                AND ObjectLink_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                                 ON ObjectLink_Goods_Measure.ObjectId = ObjectLink_Goods.ChildObjectId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                       WHERE ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                      UNION ALL
                                       SELECT tmpGoodsPropertyValue_kg.StartPosInt
                                            , tmpGoodsPropertyValue_kg.EndPosInt
                                            , tmpGoodsPropertyValue_kg.StartPosFrac
                                            , tmpGoodsPropertyValue_kg.EndPosFrac
                                            , tmpGoodsPropertyValue_kg.Id
                                            , ObjectLink_Goods.ChildObjectId         AS GoodsId
                                            , ObjectLink_Goods_Measure.ChildObjectId AS MeasureId
                                       FROM tmpGoodsPropertyValue_kg
                                            LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                                 ON ObjectLink_Goods.ObjectId = tmpGoodsPropertyValue_kg.Id
                                                                AND ObjectLink_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                                 ON ObjectLink_Goods_Measure.ObjectId = ObjectLink_Goods.ChildObjectId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                       WHERE COALESCE (ObjectLink_Goods_Measure.ChildObjectId, 0) <> zc_Measure_Sh()
                                      )

           , tmpGoods AS (SELECT tmpGoodsPropertyValue.GoodsId
                               , tmpGoodsPropertyValue.MeasureId
                               , COALESCE (ObjectLink_GoodsKind.ChildObjectId, 0) AS GoodsKindId
                               , CASE WHEN tmpGoodsPropertyValue.MeasureId = zc_Measure_Sh()
                                           THEN ObjectFloat_Amount.ValueData :: TVarChar
                                      ELSE SUBSTRING (inBarCode FROM tmpGoodsPropertyValue.StartPosInt :: Integer FOR (1 + tmpGoodsPropertyValue.EndPosInt - tmpGoodsPropertyValue.StartPosInt) :: Integer)
                                        || '.'
                                        || SUBSTRING (inBarCode FROM tmpGoodsPropertyValue.StartPosFrac :: Integer FOR (1 + tmpGoodsPropertyValue.EndPosFrac - tmpGoodsPropertyValue.StartPosFrac) :: Integer)
                                 END AS RealWeight_str
                          FROM tmpGoodsPropertyValue
                               LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                                     ON ObjectFloat_Amount.ObjectId = tmpGoodsPropertyValue.Id
                                                    AND ObjectFloat_Amount.DescId = zc_ObjectFloat_GoodsPropertyValue_Amount()
                               LEFT JOIN ObjectLink AS ObjectLink_GoodsKind
                                                    ON ObjectLink_GoodsKind.ObjectId = tmpGoodsPropertyValue.Id
                                                   AND ObjectLink_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                         )

          , tmpMI_Order AS (SELECT MovementItem.ObjectId                                                                         AS GoodsId
                                 , COALESCE (MIFloat_Price.ValueData, 0)                                                         AS Price
                                 , CASE WHEN MIFloat_CountForPrice.ValueData > 0 THEN MIFloat_CountForPrice.ValueData ELSE 1 END AS CountForPrice
                                 , COALESCE (MIFloat_PromoMovement.ValueData, 0)                                                 AS MovementId_Promo
                            FROM MovementItem
                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                  ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                 AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                 INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
                                                    AND tmpGoods.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                 LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                             ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                 LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                             ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                            AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                 LEFT JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                             ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                                                            AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                            WHERE MovementItem.MovementId = inOrderExternalId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
                            LIMIT 1
                           )
             , tmpPrice AS (SELECT tmp.GoodsId
                                 , tmp.GoodsKindId
                                 , tmp.ValuePrice AS Price
                                 , 1              AS CountForPrice
                            FROM lpGet_ObjectHistory_PriceListItem (inOperDate    := inOperDate
                                                                  , inPriceListId := inPriceListId
                                                                  , inGoodsId     := (SELECT tmpGoods.GoodsId     FROM tmpGoods LEFT JOIN tmpMI_Order ON tmpMI_Order.GoodsId = tmpGoods.GoodsId WHERE tmpMI_Order.GoodsId IS NULL)
                                                                  , inGoodsKindId := (SELECT tmpGoods.GoodsKindId FROM tmpGoods LEFT JOIN tmpMI_Order ON tmpMI_Order.GoodsId = tmpGoods.GoodsId WHERE tmpMI_Order.GoodsId IS NULL)
                                                                   ) AS tmp
                           )
       -- Результат - по заявке
       SELECT Object_Goods.Id                   AS GoodsId
            , Object_Goods.ObjectCode           AS GoodsCode
            , Object_Goods.ValueData            AS GoodsName
            , Object_GoodsKind.Id               AS GoodsKindId
            , Object_GoodsKind.ObjectCode       AS GoodsKindCode
            , Object_GoodsKind.ValueData        AS GoodsKindName
            , Object_Measure.Id                 AS MeasureId
            , Object_Measure.ValueData          AS MeasureName
            , tmpGoods.RealWeight_str :: TFloat AS RealWeight
            , 0 :: TFloat                       AS ChangePercentAmount
            , 0 :: TFloat                       AS CountTare
            , 0 :: TFloat                       AS WeightTare
            , COALESCE (tmpMI_Order.Price, COALESCE (tmpPrice_Kind.Price, tmpPrice.Price))                         :: TFloat AS Price
            , COALESCE (tmpMI_Order.CountForPrice, COALESCE (tmpPrice_Kind.CountForPrice, tmpPrice.CountForPrice)) :: TFloat AS CountForPrice
            , 0 :: TFloat                       AS Price_Return
            , 0 :: TFloat                       AS CountForPrice_Return
            , tmpMI_Order.MovementId_Promo :: Integer AS MovementId_Promo
       FROM tmpGoods
            LEFT JOIN tmpMI_Order ON tmpMI_Order.GoodsId = tmpGoods.GoodsId
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpGoods.MeasureId
            -- привязываем цены 2 раза по виду товара и без
            LEFT JOIN tmpPrice AS tmpPrice_Kind
                               ON tmpPrice_Kind.GoodsId                   = tmpGoods.GoodsId
                              AND COALESCE (tmpPrice_Kind.GoodsKindId, 0) = COALESCE (tmpGoods.GoodsKindId, 0)
            LEFT JOIN tmpPrice ON tmpPrice.GoodsId     = tmpGoods.GoodsId
                              AND tmpPrice.GoodsKindId IS NULL
      ;

     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
   /*INSERT INTO ResourseProtocol (UserId
                                 , OperDate
                                 , Value1
                                 , Value2
                                 , Value3
                                 , Value4
                                 , Value5
                                 , Time1
                                 , Time2
                                 , Time3
                                 , Time4
                                 , Time5
                                 , ProcName
                                 , ProtocolData
                                  )
        WITH tmp_pg AS (SELECT * FROM pg_stat_activity WHERE state = 'active')
        SELECT vbUserId
               -- во сколько началась
             , CURRENT_TIMESTAMP
             , (SELECT COUNT (*) FROM tmp_pg)                                                    AS Value1
             , (SELECT COUNT (*) FROM tmp_pg WHERE position( 'autovacuum: VACUUM' in query) = 1) AS Value2
             , NULL AS Value3
             , NULL AS Value4
             , NULL AS Value5
               -- сколько всего выполнялась проц
             , (CLOCK_TIMESTAMP() - vbOperDate_Begin1) :: INTERVAL AS Time1
               -- сколько всего выполнялась проц ДО lpSelectMinPrice_List
             , NULL AS Time2
               -- сколько всего выполнялась проц lpSelectMinPrice_List
             , NULL AS Time3
               -- сколько всего выполнялась проц ПОСЛЕ lpSelectMinPrice_List
             , NULL AS Time4
               -- во сколько закончилась
             , CLOCK_TIMESTAMP() AS Time5
               -- ProcName
             , 'gpGet_Scale_GoodsRetail'
               -- ProtocolData
             , inBarCode
    || ', ' || inGoodsPropertyId       :: TVarChar
    || ', ' || zfConvert_DateToString (inOperDate)
    || ', ' || inOrderExternalId       :: TVarChar
    || ', ' || inPriceListId           :: TVarChar
    || ', ' || inSession
              ;*/

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 16.05.15                                        *
*/

-- тест
-- 2852923001644
-- SELECT * FROM gpGet_Scale_GoodsRetail (inBarCode:= '4823036501978', inGoodsPropertyId:=83956 , inOperDate:= '01.01.2015', inOrderExternalId:=0, inPriceListId:= zc_PriceList_Basis(), inBranchCode:= 1, inSession:=zfCalc_UserAdmin())
-- SELECT * FROM gpGet_Scale_GoodsRetail (inBarCode:= '4823036502289', inGoodsPropertyId:=83956 , inOperDate:= '01.01.2015', inOrderExternalId:=0, inPriceListId:= zc_PriceList_Basis(), inBranchCode:= 1, inSession:=zfCalc_UserAdmin())
