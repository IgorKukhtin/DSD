-- Function: gpSelect_MovementItem_Tax()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Tax (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Tax(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, LineNum Integer, GoodsId Integer, GoodsCode Integer, GoodsCodeUKTZED TVarChar, GoodsName TVarChar
             , GoodsName_its TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , Amount TFloat
             , Price TFloat, CountForPrice TFloat
             , GoodsKindId Integer, GoodsKindName  TVarChar
             , AmountSumm TFloat
             , isName_new Boolean
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbOperDate     TDateTime;
  DECLARE vbOperDate_rus TDateTime;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Tax());

     -- inShowAll:= TRUE;


     -- определили
     vbOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     -- определили
     vbOperDate_rus:= (SELECT CASE WHEN MovementString_InvNumberRegistered.ValueData <> '' THEN COALESCE (MovementDate_DateRegistered.ValueData, Movement.OperDate) ELSE CURRENT_DATE END
                       FROM Movement
                            LEFT JOIN MovementString AS MovementString_InvNumberRegistered
                                                     ON MovementString_InvNumberRegistered.MovementId = Movement.Id
                                                    AND MovementString_InvNumberRegistered.DescId     = zc_MovementString_InvNumberRegistered()
                            LEFT JOIN MovementDate AS MovementDate_DateRegistered
                                                   ON MovementDate_DateRegistered.MovementId = Movement.Id
                                                  AND MovementDate_DateRegistered.DescId     = zc_MovementDate_DateRegistered()
                       WHERE Movement.Id = inMovementId
                      );


     IF inShowAll = TRUE THEN

     RETURN QUERY
       WITH
       tmpPrice AS (SELECT tmp.GoodsId
                         , tmp.GoodsKindId
                         , tmp.ValuePrice 
                    FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis(), inOperDate:= vbOperDate) AS tmp
                    )

       SELECT
             0                                      AS Id
           , 0                                      AS LineNum
           , tmpGoods.GoodsId                       AS GoodsId
           , tmpGoods.GoodsCode                     AS GoodsCode

           , CASE -- на дату у товара
                  WHEN ObjectString_Goods_UKTZED_new.ValueData <> '' AND ObjectDate_Goods_UKTZED_new.ValueData <=  vbOperDate
                       THEN ObjectString_Goods_UKTZED_new.ValueData
                  -- у товара
                  ELSE COALESCE (ObjectString_Goods_UKTZED.ValueData,'')
             END :: TVarChar AS GoodsCodeUKTZED

           , tmpGoods.GoodsName                     AS GoodsName
           , CAST (NULL AS TVarChar)                AS GoodsName_its
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , CAST (NULL AS TFloat)                  AS Amount
           , CAST (COALESCE (tmpPrice_kind.ValuePrice, tmpPrice.ValuePrice) AS TFloat) AS Price
           , CAST (1 AS TFloat)                     AS CountForPrice
           , Object_GoodsKind.Id                    AS GoodsKindId
           , Object_GoodsKind.ValueData             AS GoodsKindName
           , CAST (NULL AS TFloat)                  AS AmountSumm
           , FALSE                                  AS isName_new
           , FALSE                                  AS isErased

       FROM (SELECT Object_Goods.Id                                                   AS GoodsId
                  , Object_Goods.ObjectCode                                           AS GoodsCode
                  , Object_Goods.ValueData                                            AS GoodsName
                  , CASE WHEN ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) THEN zc_Enum_GoodsKind_Main() ELSE 0 END AS GoodsKindId -- Ирна + Готовая продукция + Доходы Мясное сырье
             FROM Object_InfoMoney_View
                  JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                             AND Object_Goods.isErased = FALSE
             WHERE Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_10100(), zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_21000(), zc_Enum_InfoMoneyDestination_21100(), zc_Enum_InfoMoneyDestination_30100())
            ) AS tmpGoods
            LEFT JOIN (SELECT MovementItem.ObjectId                         AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      ) AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                                AND tmpMI.GoodsKindId = tmpGoods.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId

            -- приязываем 2 раза по виду товара и без
            LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpGoods.GoodsId
                              AND tmpPrice.GoodsKindId IS NULL
            LEFT JOIN tmpPrice AS tmpPrice_kind 
                               ON tmpPrice_kind.GoodsId = tmpGoods.GoodsId
                              AND COALESCE (tmpPrice_kind.GoodsKindId,0) = COALESCE (tmpGoods.GoodsKindId,0)
                                

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED
                                   ON ObjectString_Goods_UKTZED.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_UKTZED.DescId = zc_ObjectString_Goods_UKTZED()
            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED_new
                                   ON ObjectString_Goods_UKTZED_new.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_UKTZED_new.DescId = zc_ObjectString_Goods_UKTZED_new()
            LEFT JOIN ObjectDate AS ObjectDate_Goods_UKTZED_new
                                 ON ObjectDate_Goods_UKTZED_new.ObjectId = tmpGoods.GoodsId
                                AND ObjectDate_Goods_UKTZED_new.DescId = zc_ObjectDate_Goods_UKTZED_new()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

       WHERE tmpMI.GoodsId IS NULL

      UNION ALL
       SELECT
             MovementItem.Id                        AS Id
           , CASE WHEN vbOperDate < '01.03.2016' AND 1=1
                       THEN ROW_NUMBER() OVER (ORDER BY MovementItem.Id)
                  ELSE ROW_NUMBER() OVER (ORDER BY CASE WHEN vbOperDate_rus < zc_DateEnd_GoodsRus() AND ObjectString_Goods_RUS.ValueData <> ''
                                                             THEN ObjectString_Goods_RUS.ValueData
                                                        ELSE /*CASE WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData ELSE Object_Goods.ValueData END*/
                                                             CASE WHEN ObjectString_Goods_BUH.ValueData <> '' AND vbOperDate >= ObjectDate_BUH.ValueData THEN Object_Goods.ValueData
                                                                  WHEN MIBoolean_Goods_Name_new.ValueData = TRUE THEN Object_Goods.ValueData 
                                                                  WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData
                                                                  ELSE Object_Goods.ValueData END
                                                   END
                                                 , Object_GoodsKind.ValueData
                                                 , MovementItem.Id
                                         )
             END :: Integer AS LineNum
           , Object_Goods.Id                        AS GoodsId
           , Object_Goods.ObjectCode                AS GoodsCode

           , CASE -- на дату у товара
                  WHEN ObjectString_Goods_UKTZED_new.ValueData <> '' AND ObjectDate_Goods_UKTZED_new.ValueData <= vbOperDate
                       THEN ObjectString_Goods_UKTZED_new.ValueData
                  -- у товара
                  ELSE COALESCE (ObjectString_Goods_UKTZED.ValueData,'')
             END :: TVarChar AS GoodsCodeUKTZED

           , CASE WHEN vbOperDate_rus < zc_DateEnd_GoodsRus() AND ObjectString_Goods_RUS.ValueData <> ''
                       THEN ObjectString_Goods_RUS.ValueData
                  ELSE /*CASE WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData ELSE Object_Goods.ValueData END*/
                       CASE WHEN ObjectString_Goods_BUH.ValueData <> '' AND vbOperDate >= ObjectDate_BUH.ValueData THEN Object_Goods.ValueData
                            WHEN MIBoolean_Goods_Name_new.ValueData = TRUE THEN Object_Goods.ValueData
                            WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData
                            ELSE Object_Goods.ValueData
                       END
             END :: TVarChar                             AS GoodsName
           , MIString_GoodsName.ValueData                AS GoodsName_its
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , MovementItem.Amount                    AS Amount
           , MIFloat_Price.ValueData                AS Price
           , MIFloat_CountForPrice.ValueData        AS CountForPrice
           , Object_GoodsKind.Id                    AS GoodsKindId
           , Object_GoodsKind.ValueData             AS GoodsKindName

           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                           ELSE CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat)                   AS AmountSumm
                   
           , COALESCE (MIBoolean_Goods_Name_new.ValueData, FALSE) ::Boolean AS isName_new
           , MovementItem.isErased                  AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
            LEFT JOIN ObjectString AS ObjectString_Goods_RUS
                                   ON ObjectString_Goods_RUS.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_RUS.DescId = zc_ObjectString_Goods_RUS()
            LEFT JOIN ObjectString AS ObjectString_Goods_BUH
                                   ON ObjectString_Goods_BUH.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_BUH.DescId = zc_ObjectString_Goods_BUH()
            LEFT JOIN ObjectDate AS ObjectDate_BUH
                                 ON ObjectDate_BUH.ObjectId = Object_Goods.Id
                                AND ObjectDate_BUH.DescId = zc_ObjectDate_Goods_BUH()                                  

            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED
                                   ON ObjectString_Goods_UKTZED.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_UKTZED.DescId = zc_ObjectString_Goods_UKTZED()
            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED_new
                                   ON ObjectString_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_UKTZED_new.DescId = zc_ObjectString_Goods_UKTZED_new()
            LEFT JOIN ObjectDate AS ObjectDate_Goods_UKTZED_new
                                 ON ObjectDate_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                                AND ObjectDate_Goods_UKTZED_new.DescId = zc_ObjectDate_Goods_UKTZED_new()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN MovementItemBoolean AS MIBoolean_Goods_Name_new
                                          ON MIBoolean_Goods_Name_new.MovementItemId = MovementItem.Id
                                         AND MIBoolean_Goods_Name_new.DescId = zc_MIBoolean_Goods_Name_new()

            LEFT JOIN MovementItemString AS MIString_GoodsName
                                         ON MIString_GoodsName.MovementItemId = MovementItem.Id
                                        AND MIString_GoodsName.DescId = zc_MIString_GoodsName()
            ;
     ELSE

     RETURN QUERY
       SELECT
             MovementItem.Id
           , CASE WHEN MIFloat_NPP.ValueData <> 0
                       THEN MIFloat_NPP.ValueData
                  WHEN vbOperDate < '01.03.2016' AND 1=1
                       THEN -1 * ROW_NUMBER() OVER (ORDER BY MovementItem.Id)
                  ELSE -1 * ROW_NUMBER() OVER (ORDER BY CASE WHEN vbOperDate_rus < zc_DateEnd_GoodsRus() AND ObjectString_Goods_RUS.ValueData <> ''
                                                             THEN ObjectString_Goods_RUS.ValueData
                                                        ELSE /*CASE WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData ELSE Object_Goods.ValueData END*/
                                                             CASE WHEN ObjectString_Goods_BUH.ValueData <> '' AND vbOperDate >= ObjectDate_BUH.ValueData THEN Object_Goods.ValueData
                                                                  WHEN COALESCE (MIBoolean_Goods_Name_new.ValueData, FALSE) = TRUE THEN Object_Goods.ValueData
                                                                  WHEN ObjectString_Goods_BUH.ValueData <> ''  THEN ObjectString_Goods_BUH.ValueData
                                                                  ELSE Object_Goods.ValueData END
                                                   END
                                                 , Object_GoodsKind.ValueData
                                                 , MovementItem.Id
                                              )
             END :: Integer AS LineNum
           , Object_Goods.Id                        AS GoodsId
           , Object_Goods.ObjectCode                AS GoodsCode

           , CASE -- на дату у товара
                  WHEN ObjectString_Goods_UKTZED_new.ValueData <> '' AND ObjectDate_Goods_UKTZED_new.ValueData <= vbOperDate
                       THEN ObjectString_Goods_UKTZED_new.ValueData
                  -- у товара
                  ELSE COALESCE (ObjectString_Goods_UKTZED.ValueData,'')
             END :: TVarChar AS GoodsCodeUKTZED

           , CASE WHEN vbOperDate_rus < zc_DateEnd_GoodsRus() AND ObjectString_Goods_RUS.ValueData <> ''
                       THEN ObjectString_Goods_RUS.ValueData
                  ELSE /*CASE WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData ELSE Object_Goods.ValueData END*/
                         CASE WHEN ObjectString_Goods_BUH.ValueData <> '' AND vbOperDate >= ObjectDate_BUH.ValueData THEN Object_Goods.ValueData
                              WHEN COALESCE (MIBoolean_Goods_Name_new.ValueData, FALSE) = TRUE THEN Object_Goods.ValueData
                              WHEN ObjectString_Goods_BUH.ValueData <> '' THEN ObjectString_Goods_BUH.ValueData
                              ELSE Object_Goods.ValueData END
             END :: TVarChar                             AS GoodsName 

           , MIString_GoodsName.ValueData                AS GoodsName_its
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , MovementItem.Amount                    AS Amount
           , MIFloat_Price.ValueData                AS Price
           , MIFloat_CountForPrice.ValueData        AS CountForPrice
           , Object_GoodsKind.Id                    AS GoodsKindId
           , Object_GoodsKind.ValueData             AS GoodsKindName
           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                           ELSE CAST ( (COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat)                   AS AmountSumm

           , COALESCE (MIBoolean_Goods_Name_new.ValueData, FALSE) ::Boolean AS isName_new
           , MovementItem.isErased                  AS isErased

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_RUS
                                   ON ObjectString_Goods_RUS.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_RUS.DescId = zc_ObjectString_Goods_RUS()
            LEFT JOIN ObjectString AS ObjectString_Goods_BUH
                                   ON ObjectString_Goods_BUH.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_BUH.DescId = zc_ObjectString_Goods_BUH()
            LEFT JOIN ObjectDate AS ObjectDate_BUH
                                 ON ObjectDate_BUH.ObjectId = Object_Goods.Id
                                AND ObjectDate_BUH.DescId = zc_ObjectDate_Goods_BUH()

            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED
                                   ON ObjectString_Goods_UKTZED.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_UKTZED.DescId = zc_ObjectString_Goods_UKTZED()
            LEFT JOIN ObjectString AS ObjectString_Goods_UKTZED_new
                                   ON ObjectString_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_UKTZED_new.DescId = zc_ObjectString_Goods_UKTZED_new()
            LEFT JOIN ObjectDate AS ObjectDate_Goods_UKTZED_new
                                 ON ObjectDate_Goods_UKTZED_new.ObjectId = Object_Goods.Id
                                AND ObjectDate_Goods_UKTZED_new.DescId = zc_ObjectDate_Goods_UKTZED_new()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
            LEFT JOIN MovementItemFloat AS MIFloat_NPP
                                        ON MIFloat_NPP.MovementItemId = MovementItem.Id
                                       AND MIFloat_NPP.DescId = zc_MIFloat_NPP()           


            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN MovementItemBoolean AS MIBoolean_Goods_Name_new
                                          ON MIBoolean_Goods_Name_new.MovementItemId = MovementItem.Id
                                         AND MIBoolean_Goods_Name_new.DescId = zc_MIBoolean_Goods_Name_new()

            LEFT JOIN MovementItemString AS MIString_GoodsName
                                         ON MIString_GoodsName.MovementItemId = MovementItem.Id
                                        AND MIString_GoodsName.DescId = zc_MIString_GoodsName()
            ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_MovementItem_Tax (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 12.06.24         * GoodsName_its
 08.08.21         * isName_new
 06.12.19         *
 06.01.17         *
 25.03.16         * add LineNum
 31.03.15         * 
 08.04.14                                        * add zc_Enum_InfoMoneyDestination_30100
 10.02.14                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Tax (inMovementId:= 4229, inShowAll:= TRUE, inisErased:= TRUE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItem_Tax (inMovementId:= 4229, inShowAll:= FALSE, inisErased:= FALSE, inSession:= zfCalc_UserAdmin())
