-- Function: gpSelect_MovementItem_ContractGoods()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ContractGoods (Integer, Boolean, Boolean, TVarChar); 
 
CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ContractGoods(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar             
             , MeasureName TVarChar
             , GoodsKindId Integer, GoodsKindName TVarChar
             , Price           TFloat
             , Price_curr      TFloat
             , ChangePrice     TFloat
             , ChangePercent   TFloat
             , CountForAmount  TFloat
             , CountForPrice   TFloat
             , Comment TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isSave Boolean, isBonusNo Boolean
             , isSale Boolean                    --есть в продаже
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId          Integer;
  DECLARE vbPriceWithVAT    Boolean;
  DECLARE vbContractId      Integer;
  DECLARE vbPriceListId     Integer;
  DECLARE vbOperDate        TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_ContractGoods());
     vbUserId:= lpGetUserBySession (inSession);

     -- Данные документа
     SELECT Movement.OperDate
          , COALESCE (MovementLinkObject_Contract.ObjectId, 0) AS ContractId
            INTO vbOperDate, vbContractId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
     WHERE Movement.Id = inMovementId
       AND Movement.DescId = zc_Movement_ContractGoods();

     vbPriceListId := (SELECT ObjectLink_ContractPriceList_PriceList.ChildObjectId AS PriceListId
                                FROM (SELECT vbContractId AS ContractId) AS tmp
                                 
                                      INNER JOIN ObjectLink AS ObjectLink_ContractPriceList_Contract
                                                            ON ObjectLink_ContractPriceList_Contract.ChildObjectId = tmp.ContractId
                                                           AND ObjectLink_ContractPriceList_Contract.DescId = zc_ObjectLink_ContractPriceList_Contract()
                            
                                      INNER JOIN Object AS Object_ContractPriceList
                                                        ON Object_ContractPriceList.Id = ObjectLink_ContractPriceList_Contract.ObjectId
                                                       AND Object_ContractPriceList.DescId = zc_Object_ContractPriceList()
                                                       AND Object_ContractPriceList.isErased = FALSE

                                      INNER JOIN ObjectDate AS ObjectDate_StartDate
                                                            ON ObjectDate_StartDate.ObjectId = ObjectLink_ContractPriceList_Contract.ObjectId
                                                           AND ObjectDate_StartDate.DescId = zc_ObjectDate_ContractPriceList_StartDate()
                                                           AND ObjectDate_StartDate.ValueData <= vbOperDate
                                      INNER JOIN ObjectDate AS ObjectDate_EndDate
                                                            ON ObjectDate_EndDate.ObjectId = ObjectLink_ContractPriceList_Contract.ObjectId
                                                           AND ObjectDate_EndDate.DescId = zc_ObjectDate_ContractPriceList_EndDate()
                                                           AND ObjectDate_EndDate.ValueData >= vbOperDate

                                      LEFT JOIN ObjectLink AS ObjectLink_ContractPriceList_PriceList
                                                           ON ObjectLink_ContractPriceList_PriceList.ObjectId = ObjectLink_ContractPriceList_Contract.ObjectId
                                                          AND ObjectLink_ContractPriceList_PriceList.DescId = zc_ObjectLink_ContractPriceList_PriceList()
                       );                           


     -- Цены с НДС
     vbPriceWithVAT:= (SELECT MB.ValueData FROM ObjectBoolean AS MB WHERE MB.ObjectId = vbPriceListId AND MB.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT());
     
     -- Результат
     IF inShowAll THEN
     RETURN QUERY
       WITH 
       -- Цены из прайса
       tmpPriceList AS (SELECT lfSelect.GoodsId     AS GoodsId
                             , lfSelect.GoodsKindId AS GoodsKindId
                             , lfSelect.ValuePrice  AS Price_PriceList
                        FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= vbOperDate) AS lfSelect 
                       )

       -- Цены из прайса на тек. дату
     , tmpPriceList_curr AS (SELECT lfSelect.GoodsId     AS GoodsId
                                  , lfSelect.GoodsKindId AS GoodsKindId
                                  , lfSelect.ValuePrice  AS Price_PriceList
                             FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= CURRENT_DATE) AS lfSelect 
                            )
  /*     -- Ограничение для ГП - какие товары показать
     , tmpGoodsByGoodsKind AS (SELECT Object_GoodsByGoodsKind_View.GoodsId
                                    , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0) AS GoodsKindId
                               FROM ObjectBoolean AS ObjectBoolean_Order
                                    LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.Id = ObjectBoolean_Order.ObjectId

                                    LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                                         ON ObjectLink_Goods_InfoMoney.ObjectId = Object_GoodsByGoodsKind_View.GoodsId
                                                        AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                                                       -- AND vbUnitId = 8459 --"Склад Реализации"

                                    LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Goods_InfoMoney.ChildObjectId

                               WHERE ObjectBoolean_Order.ValueData = TRUE
                                 AND ObjectBoolean_Order.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                 /*AND  (Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_30100() -- Готовая продукция
                                                                                      , zc_Enum_InfoMoneyDestination_30200() -- Тушенка
                                                                                                             ) 
                                       )*/
                              )
*/
     -- на показать все тольтко товары из GoodsListSale
     , tmpGoodsListSale AS (SELECT DISTINCT tmp.GoodsId
                                 , COALESCE (tmp.GoodsKindId, 0) AS GoodsKindId
                            FROM gpSelect_Object_GoodsListSale(inRetailId    := 0            ::Integer , -- торговая сеть
                                                               inContractId  := vbContractId ::Integer , -- договор
                                                               inJuridicalId := 0            ::Integer , -- юр. лицо
                                                               inGoodsId     := 0            ::Integer , -- Товар
                                                               inShowAll     := FALSE        ::Boolean , -- показать удаленные Да/нет
                                                               inSession     := inSession    ::TVarChar  -- сессия пользователя
                                                               ) AS tmp
                           )

       -- Существующие MovementItem
     , tmpMI_G AS (SELECT MovementItem.Id
                        , MovementItem.ObjectId   AS GoodsId
                        , MovementItem.Amount     AS Amount
                        , MovementItem.isErased
                   FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                        INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                               AND MovementItem.DescId     = zc_MI_Master()
                                               AND MovementItem.isErased   = tmpIsErased.isErased
                   )

     , tmpMILO AS (SELECT MovementItemLinkObject.*
                   FROM MovementItemLinkObject
                   WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_G.Id FROM tmpMI_G)
                     AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind())
                  )
     , tmpMI_String AS (SELECT MovementItemString.*
                        FROM MovementItemString
                        WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI_G.Id FROM tmpMI_G)
                          AND MovementItemString.DescId IN (zc_MIString_Comment())
                       )

     , tmpMI_Float AS (SELECT MovementItemFloat.*
                        FROM MovementItemFloat
                        WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_G.Id FROM tmpMI_G)
                          AND MovementItemFloat.DescId IN (zc_MIFloat_Price()
                                                         , zc_MIFloat_ChangePrice()
                                                         , zc_MIFloat_ChangePercent()
                                                         , zc_MIFloat_CountForAmount()
                                                         , zc_MIFloat_CountForPrice()
                                                          )
                       )
     , tmpMI_Boolean AS (SELECT MovementItemBoolean.*
                         FROM MovementItemBoolean
                         WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI_G.Id FROM tmpMI_G)
                           AND MovementItemBoolean.DescId IN (zc_MIBoolean_BonusNo())
                        )

     , tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                      , MovementItem.GoodsId                          AS GoodsId
                      , MILinkObject_GoodsKind.ObjectId               AS GoodsKindId
                      , MovementItem.Amount                           AS Amount
                      , COALESCE (MIFloat_Price.ValueData, 0)         AS Price
                      , COALESCE (MIFloat_ChangePrice.ValueData, 0)   AS ChangePrice
                      , COALESCE (MIFloat_ChangePercent.ValueData, 0) AS ChangePercent
                      , COALESCE (MIFloat_CountForAmount.ValueData,1) AS CountForAmount
                      , COALESCE (MIFloat_CountForPrice.ValueData,1)  AS CountForPrice
                      , MIString_Comment.ValueData        :: TVarChar AS Comment
                      , COALESCE (MIBoolean_BonusNo.ValueData, FALSE) ::Boolean AS isBonusNo
                      , MovementItem.isErased
                 FROM tmpMI_G AS MovementItem
                      LEFT JOIN tmpMI_Float AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()

                      LEFT JOIN tmpMI_Float AS MIFloat_ChangePrice
                                            ON MIFloat_ChangePrice.MovementItemId = MovementItem.Id
                                           AND MIFloat_ChangePrice.DescId = zc_MIFloat_ChangePrice()
                      LEFT JOIN tmpMI_Float AS MIFloat_ChangePercent
                                            ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                           AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                      LEFT JOIN tmpMI_Float AS MIFloat_CountForAmount
                                            ON MIFloat_CountForAmount.MovementItemId = MovementItem.Id
                                           AND MIFloat_CountForAmount.DescId = zc_MIFloat_CountForAmount()
                      LEFT JOIN tmpMI_Float AS MIFloat_CountForPrice
                                            ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                           AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                      LEFT JOIN tmpMI_String AS MIString_Comment
                                             ON MIString_Comment.MovementItemId = MovementItem.Id
                                            AND MIString_Comment.DescId = zc_MIString_Comment()
                      LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                                        ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                       AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      LEFT JOIN tmpMI_Boolean AS MIBoolean_BonusNo
                                              ON MIBoolean_BonusNo.MovementItemId = MovementItem.Id
                                             AND MIBoolean_BonusNo.DescId = zc_MIBoolean_BonusNo()
                 )

       --
       SELECT
             0 :: Integer               AS Id
           , Object_Goods.Id          		AS GoodsId
           , Object_Goods.ObjectCode  		AS GoodsCode
           , Object_Goods.ValueData   		AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

           , Object_Measure.ValueData           AS MeasureName

           , Object_GoodsKind.Id                AS GoodsKindId
           , Object_GoodsKind.ValueData         AS GoodsKindName

           , COALESCE (tmpPriceList_Kind.Price_Pricelist, tmpPriceList.Price_Pricelist) :: TFloat AS Price
           , COALESCE (tmpPriceList_Kind_curr.Price_Pricelist, tmpPriceList_curr.Price_Pricelist) :: TFloat AS Price_curr 
           , 0                :: TFloat    AS ChangePrice
           , 0                :: TFloat    AS ChangePercent
           , 1                :: TFloat    AS CountForAmount
           , 1                :: TFloat    AS CountForPrice
           , ''               :: TVarChar  AS Comment

           , ''           ::TVarChar       AS InsertName
           , ''           ::TVarChar       AS UpdateName
           , CURRENT_TIMESTAMP ::TDateTime AS InsertDate
           , NULL           ::TDateTime    AS UpdateDate
           
           , FALSE AS isSave
           , FALSE AS isBonusNo
           , CASE WHEN tmpSale.GoodsId IS NULL THEN FALSE ELSE TRUE END ::Boolean AS isSale
           
           , FALSE AS isErased
       FROM tmpGoodsListSale AS tmpGoods

            LEFT JOIN tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                           AND COALESCE (tmpMI.GoodsKindId,0) = COALESCE (tmpGoods.GoodsKindId,0)

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId

            -- привязываем 2 раза по виду товара и без
            LEFT JOIN tmpPriceList AS tmpPriceList_Kind 
                                   ON tmpPriceList_Kind.GoodsId                   = tmpGoods.GoodsId
                                  AND COALESCE (tmpPriceList_Kind.GoodsKindId, 0) = COALESCE (tmpGoods.GoodsKindId, 0)
            LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId     = tmpGoods.GoodsId
                                  AND tmpPriceList.GoodsKindId IS NULL

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            -- привязываем 2 раза по виду товара и без  --на тек дату
            LEFT JOIN tmpPriceList_curr AS tmpPriceList_Kind_curr 
                                        ON tmpPriceList_Kind_curr.GoodsId                   = tmpGoods.GoodsId
                                       AND COALESCE (tmpPriceList_Kind_curr.GoodsKindId, 0) = COALESCE (tmpGoods.GoodsKindId, 0)
            LEFT JOIN tmpPriceList_curr ON tmpPriceList_curr.GoodsId     = tmpGoods.GoodsId
                                       AND tmpPriceList_curr.GoodsKindId IS NULL

            LEFT JOIN (SELECT DISTINCT tmpGoodsListSale.GoodsId FROM tmpGoodsListSale) AS tmpSale ON tmpSale.GoodsId = tmpGoods.GoodsId
                                      --AND tmpGoodsListSale.GoodsKindId = COALESCE(tmpGoods.GoodsKindId, 0)
       WHERE tmpMI.GoodsId IS NULL
      UNION ALL
        SELECT
             tmpMI.MovementItemId    :: Integer  AS Id
           , Object_Goods.Id          		 AS GoodsId
           , Object_Goods.ObjectCode  		 AS GoodsCode
           , Object_Goods.ValueData   		 AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData            AS MeasureName

           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName

           , tmpMI.Price             ::TFloat    AS Price 
           , COALESCE (tmpPriceList_Kind_curr.Price_Pricelist, tmpPriceList_curr.Price_Pricelist) :: TFloat AS Price_curr
           , tmpMI.ChangePrice       :: TFloat AS ChangePrice
           , tmpMI.ChangePercent     :: TFloat AS ChangePercent 
           , tmpMI.CountForAmount    :: TFloat AS CountForAmount
           , tmpMI.CountForPrice     :: TFloat AS CountForPrice

           , tmpMI.Comment           :: TVarChar AS Comment

           , Object_Insert.ValueData    AS InsertName
           , Object_Update.ValueData    AS UpdateName
           , MIDate_Insert.ValueData    AS InsertDate
           , MIDate_Update.ValueData    AS UpdateDate
           
           , CASE WHEN COALESCE (tmpMI.isErased, TRUE) = FALSE THEN TRUE ELSE FALSE END ::Boolean AS isSave
           , tmpMI.isBonusNo            AS isBonusNo
           
           , CASE WHEN tmpSale.GoodsId IS NULL THEN FALSE ELSE TRUE END ::Boolean AS isSale

           , tmpMI.isErased             AS isErased

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

            LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                              ON MILinkObject_GoodsKind.MovementItemId = tmpMI.MovementItemId
                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN MovementItemDate AS MIDate_Insert
                                       ON MIDate_Insert.MovementItemId = tmpMI.MovementItemId
                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
            LEFT JOIN MovementItemDate AS MIDate_Update
                                       ON MIDate_Update.MovementItemId = tmpMI.MovementItemId
                                      AND MIDate_Update.DescId = zc_MIDate_Update()

            LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                             ON MILO_Insert.MovementItemId = tmpMI.MovementItemId
                                            AND MILO_Insert.DescId = zc_MILinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILO_Update
                                             ON MILO_Update.MovementItemId = tmpMI.MovementItemId
                                            AND MILO_Update.DescId = zc_MILinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId

            -- привязываем 2 раза по виду товара и без  --на тек дату
            LEFT JOIN tmpPriceList_curr AS tmpPriceList_Kind_curr 
                                        ON tmpPriceList_Kind_curr.GoodsId                   = tmpMI.GoodsId
                                       AND COALESCE (tmpPriceList_Kind_curr.GoodsKindId, 0) = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
            LEFT JOIN tmpPriceList_curr ON tmpPriceList_curr.GoodsId     = tmpMI.GoodsId
                                       AND tmpPriceList_curr.GoodsKindId IS NULL

            LEFT JOIN (SELECT DISTINCT tmpGoodsListSale.GoodsId FROM tmpGoodsListSale) AS tmpSale ON tmpSale.GoodsId = tmpMI.GoodsId
                                      --AND tmpSale.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
    ;
     ELSE

     -- Результат другой
     RETURN QUERY

       WITH 
           tmpMI AS (SELECT MovementItem.Id                               AS MovementItemId
                          , MovementItem.Amount                           AS Amount
                          , MovementItem.ObjectId                         AS GoodsId
                          , MovementItem.isErased                         AS isErased
                     FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                          INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                 AND MovementItem.DescId     = zc_MI_Master()
                                                 AND MovementItem.isErased   = tmpIsErased.isErased
                     )

     , tmpMILO AS (SELECT MovementItemLinkObject.*
                   FROM MovementItemLinkObject
                   WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                     AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind())
                  )
     , tmpMI_String AS (SELECT MovementItemString.*
                        FROM MovementItemString
                        WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                          AND MovementItemString.DescId IN (zc_MIString_Comment())
                       )

     , tmpMI_Float AS (SELECT MovementItemFloat.*
                        FROM MovementItemFloat
                        WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                          AND MovementItemFloat.DescId IN (zc_MIFloat_Price()
                                                         , zc_MIFloat_ChangePrice()
                                                         , zc_MIFloat_ChangePercent() 
                                                         , zc_MIFloat_CountForAmount()
                                                         , zc_MIFloat_CountForPrice()
                                                          )
                       )

     , tmpMI_Boolean AS (SELECT MovementItemBoolean.*
                         FROM MovementItemBoolean
                         WHERE MovementItemBoolean.MovementItemId IN (SELECT DISTINCT tmpMI.MovementItemId FROM tmpMI)
                           AND MovementItemBoolean.DescId IN (zc_MIBoolean_BonusNo())
                        )

       -- Цены из прайса на тек. дату
     , tmpPriceList_curr AS (SELECT lfSelect.GoodsId     AS GoodsId
                                  , lfSelect.GoodsKindId AS GoodsKindId
                                  , lfSelect.ValuePrice  AS Price_PriceList
                             FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= CURRENT_DATE) AS lfSelect 
                            )

     , tmpGoodsListSale AS (SELECT DISTINCT tmp.GoodsId
                                 --, COALESCE (tmp.GoodsKindId, 0) AS GoodsKindId
                            FROM gpSelect_Object_GoodsListSale(inRetailId    := 0            ::Integer , -- торговая сеть
                                                               inContractId  := vbContractId ::Integer , -- договор
                                                               inJuridicalId := 0            ::Integer , -- юр. лицо
                                                               inGoodsId     := 0            ::Integer , -- Товар
                                                               inShowAll     := FALSE        ::Boolean , -- показать удаленные Да/нет
                                                               inSession     := inSession    ::TVarChar  -- сессия пользователя
                                                               ) AS tmp
                           )

        SELECT
             tmpMI.MovementItemId    :: Integer AS Id
           , Object_Goods.Id          		AS GoodsId
           , Object_Goods.ObjectCode  		AS GoodsCode
           , Object_Goods.ValueData   		AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData           AS MeasureName

           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName


           , MIFloat_Price.ValueData   ::TFloat AS Price
           , COALESCE (tmpPriceList_Kind_curr.Price_Pricelist, tmpPriceList_curr.Price_Pricelist) :: TFloat AS Price_curr

           , COALESCE (MIFloat_ChangePrice.ValueData, 0)   :: TFloat AS ChangePrice
           , COALESCE (MIFloat_ChangePercent.ValueData, 0) :: TFloat AS ChangePercent 
           , COALESCE (MIFloat_CountForAmount.ValueData,1) :: TFloat AS CountForAmount
           , COALESCE (MIFloat_CountForPrice.ValueData,1)  :: TFloat AS CountForPrice

           , MIString_Comment.ValueData                       :: TVarChar AS Comment

           , Object_Insert.ValueData    AS InsertName
           , Object_Update.ValueData    AS UpdateName
           , MIDate_Insert.ValueData    AS InsertDate
           , MIDate_Update.ValueData    AS UpdateDate
           
           , CASE WHEN COALESCE (tmpMI.isErased, TRUE) = FALSE THEN TRUE ELSE FALSE END ::Boolean AS isSave
           , COALESCE (MIBoolean_BonusNo.ValueData, FALSE) ::Boolean AS isBonusNo
           , CASE WHEN tmpGoodsListSale.GoodsId IS NULL THEN FALSE ELSE TRUE END ::Boolean AS isSale

           , tmpMI.isErased             AS isErased

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId

            LEFT JOIN tmpMILO AS MILinkObject_GoodsKind
                              ON MILinkObject_GoodsKind.MovementItemId = tmpMI.MovementItemId
                             AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN tmpMI_Float AS MIFloat_Price
                                  ON MIFloat_Price.MovementItemId = tmpMI.MovementItemId
                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()

            LEFT JOIN tmpMI_Float AS MIFloat_ChangePrice
                                  ON MIFloat_ChangePrice.MovementItemId = tmpMI.MovementItemId
                                 AND MIFloat_ChangePrice.DescId = zc_MIFloat_ChangePrice()
            LEFT JOIN tmpMI_Float AS MIFloat_ChangePercent
                                  ON MIFloat_ChangePercent.MovementItemId = tmpMI.MovementItemId
                                 AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
            LEFT JOIN tmpMI_Float AS MIFloat_CountForAmount
                                  ON MIFloat_CountForAmount.MovementItemId = tmpMI.MovementItemId
                                 AND MIFloat_CountForAmount.DescId = zc_MIFloat_CountForAmount()
            LEFT JOIN tmpMI_Float AS MIFloat_CountForPrice
                                  ON MIFloat_CountForPrice.MovementItemId = tmpMI.MovementItemId
                                 AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpMI.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN tmpMI_String AS MIString_Comment
                                   ON MIString_Comment.MovementItemId = tmpMI.MovementItemId
                                  AND MIString_Comment.DescId = zc_MIString_Comment()
 
            LEFT JOIN tmpMI_Boolean AS MIBoolean_BonusNo
                                    ON MIBoolean_BonusNo.MovementItemId = tmpMI.MovementItemId
                                   AND MIBoolean_BonusNo.DescId = zc_MIBoolean_BonusNo()

            LEFT JOIN MovementItemDate AS MIDate_Insert
                                       ON MIDate_Insert.MovementItemId = tmpMI.MovementItemId
                                      AND MIDate_Insert.DescId = zc_MIDate_Insert()
            LEFT JOIN MovementItemDate AS MIDate_Update
                                       ON MIDate_Update.MovementItemId = tmpMI.MovementItemId
                                      AND MIDate_Update.DescId = zc_MIDate_Update()
 
            LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                             ON MILO_Insert.MovementItemId = tmpMI.MovementItemId
                                            AND MILO_Insert.DescId = zc_MILinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId
 
            LEFT JOIN MovementItemLinkObject AS MILO_Update
                                             ON MILO_Update.MovementItemId = tmpMI.MovementItemId
                                            AND MILO_Update.DescId = zc_MILinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId

            -- привязываем 2 раза по виду товара и без  --на тек дату
            LEFT JOIN tmpPriceList_curr AS tmpPriceList_Kind_curr 
                                        ON tmpPriceList_Kind_curr.GoodsId                   = tmpMI.GoodsId
                                       AND COALESCE (tmpPriceList_Kind_curr.GoodsKindId, 0) = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
            LEFT JOIN tmpPriceList_curr ON tmpPriceList_curr.GoodsId     = tmpMI.GoodsId
                                       AND tmpPriceList_curr.GoodsKindId IS NULL

            LEFT JOIN tmpGoodsListSale ON tmpGoodsListSale.GoodsId     = tmpMI.GoodsId
                                      --AND tmpGoodsListSale.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
           ;

     END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.11.24         *
 28.07.22         *
 28.08.21         * isSale
 25.08.21         * isBonusNo
 05.07.21         *
*/

-- тест
-- select * from gpSelect_MovementItem_ContractGoods(inMovementId := 20779487 , inShowAll:= false, inIsErased := 'False' ,  inSession := '5')
-- select * from gpSelect_MovementItem_ContractGoods(inMovementId := 20779487 , inShowAll:= true, inIsErased := 'False' ,  inSession := '5')