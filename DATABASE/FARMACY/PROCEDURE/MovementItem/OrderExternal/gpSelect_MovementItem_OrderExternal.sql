-- Function: gpSelect_MovementItem_OrderExternal()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_OrderExternal (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_OrderExternal(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , CommonCode Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , PartnerGoodsId Integer, PartnerGoodsCode TVarChar, PartnerGoodsName TVarChar
             , RetailName TVarChar, AreaName TVarChar
             , NDS_PriceList TVarChar
             , Amount TFloat, Price TFloat, Summ TFloat
             , PartionGoodsDate TDateTime
             , Comment TVarChar, isErased Boolean
             , isSP     Boolean
             , isClose  Boolean
             , isFirst  Boolean
             , isSecond Boolean
             , isTOP    Boolean
             , isResolution_224 Boolean
             , PartionGoodsDateColor Integer
             , OrderShedule_Color    Integer
              )
AS
$BODY$
  DECLARE vbUserId    Integer;
  DECLARE vbPartnerId Integer;
  DECLARE vbUnitId    Integer;
  DECLARE vbDate180   TDateTime;
  DECLARE vbOperDate  TDateTime;
  DECLARE vbStatusId Integer;
  DECLARE vbJuridicalId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_OrderExternal());
     vbUserId := inSession;
     
     --Код Мориона нужен только для Венты
     vbPartnerId := (SELECT MovementLinkObject_From.ObjectId
                     FROM MovementLinkObject AS MovementLinkObject_From
                     WHERE MovementLinkObject_From.MovementId = inMovementId
                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                    );

    SELECT Date_TRUNC('DAY', Movement.OperDate)
         , Movement.StatusId
         , MovementLinkObject_From.ObjectId
    INTO vbOperDate, vbStatusId, vbJuridicalId
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
    WHERE Movement.Id =inMovementId;

     -- + пол года к текущей для определения сроков годности
     vbDate180 := CURRENT_DATE + zc_Interval_ExpirationDate()+ zc_Interval_ExpirationDate(); --+ INTERVAL '180 DAY';  -- нужен 1 год (функция =6 мес.)
   
     -- ПАРАМЕТРЫ
     SELECT MovementLinkObject.ObjectId AS UnitId
            INTO vbUnitId
     FROM MovementLinkObject
     
     WHERE MovementLinkObject.MovementId = inMovementId
       AND MovementLinkObject.DescId = zc_MovementLinkObject_To();

     RETURN QUERY
     WITH
     -- Список товары ТОП
     GoodsPrice AS (SELECT Price_Goods.ChildObjectId           AS GoodsId
                         , COALESCE(Price_Top.ValueData,FALSE) AS isTop
                    FROM ObjectLink AS ObjectLink_Price_Unit
                         INNER JOIN ObjectBoolean AS Price_Top
                                                  ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                 AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                                                 AND Price_Top.ValueData = TRUE
                         LEFT JOIN ObjectLink AS Price_Goods
                                              ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                             AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                    WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                      AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                   )
   , tmpGoods AS (SELECT Object_Goods.Id          AS GoodsId
                       , Object_Goods.ObjectCode  AS GoodsCode
                       , Object_Goods.ValueData   AS GoodsName
                  FROM Object AS Object_Goods
                  WHERE Object_Goods.DescId = zc_Object_Goods() 
                    AND inShowAll = TRUE
                    AND Object_Goods.isErased = FALSE
                 )
   --
   , tmpMI AS (SELECT MovementItem.Id 
                    , MovementItem.PartnerGoodsCode
                    , MovementItem.PartnerGoodsId
                    , MovementItem.GoodsCode
                    , MovementItem.GoodsName
                    , MovementItem.Amount
                    , MovementItem.Price
                    , MovementItem.Summ
                    , MovementItem.isErased
                    , MovementItem.GoodsId
                    , MovementItem.PartionGoodsDate
                    , MovementItem.Comment
                    
               FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                     JOIN MovementItem_OrderExternal_View AS MovementItem 
                                                          ON MovementItem.MovementId = inMovementId
                                                         AND MovementItem.isErased   = tmpIsErased.isErased
              )
   , tmpData AS (SELECT tmpMI.Id            AS Id
                      , COALESCE(tmpMI.GoodsId, tmpGoods.GoodsId)     AS GoodsId
                      , COALESCE(tmpMI.GoodsCode, tmpGoods.GoodsCode) AS GoodsCode
                      , COALESCE(tmpMI.GoodsName, tmpGoods.GoodsName) AS GoodsName
                      , tmpMI.PartnerGoodsId                          AS PartnerGoodsId 
                      , tmpMI.PartnerGoodsCode                        AS PartnerGoodsCode
                      , tmpMI.Amount                                  AS Amount
                      , tmpMI.Price                                   AS Price
                      , tmpMI.Summ::TFloat                            AS Summ
                      , tmpMI.PartionGoodsDate                        AS PartionGoodsDate
                      , tmpMI.Comment                                 AS Comment
                      , FALSE                                         AS isErased
                 FROM tmpGoods
                      FULL JOIN tmpMI ON tmpMI.GoodsId = tmpGoods.GoodsId
                 )

    -- Товары соц-проект (документ)
   , tmpGoodsSP AS (SELECT DISTINCT tmp.GoodsId, TRUE AS isSP
                   FROM lpSelect_MovementItem_GoodsSP_onDate (inStartDate:= vbOperDate, inEndDate:= vbOperDate) AS tmp
                   )

   , tmpGoodsParam AS (SELECT ObjectBoolean.*
                       FROM ObjectBoolean
                       WHERE ObjectBoolean.ObjectId IN (SELECT DISTINCT tmpData.GoodsId FROM tmpData)
                         AND ObjectBoolean.DescId IN (zc_ObjectBoolean_Goods_Close()
                                                    , zc_ObjectBoolean_Goods_TOP()
                                                    , zc_ObjectBoolean_Goods_First()
                                                    , zc_ObjectBoolean_Goods_Second())
                      )
   -- торговая сеть
   , tmpObjectLink_Object AS (SELECT ObjectLink.*
                              FROM ObjectLink
                              WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpData.GoodsId FROM tmpData)
                                AND ObjectLink.DescId = zc_ObjectLink_Goods_Object()            
                             )
    , tmpObjectLink_Area AS (SELECT ObjectLink.*
                             FROM ObjectLink 
                             WHERE ObjectLink.ObjectId IN (SELECT DISTINCT tmpData.PartnerGoodsId FROM tmpData)
                               AND ObjectLink.DescId = zc_ObjectLink_Goods_Area()
                            )
                                    
   , tmpMainParam AS (SELECT ObjectLink_Child.ChildObjectId                        AS GoodsId
                           , COALESCE (tmpGoodsSP.isSP, False)           ::Boolean AS isSP
                           , COALESCE (ObjectBoolean_Resolution_224.ValueData, FALSE) :: Boolean AS isResolution_224
                           , COALESCE(Object_LinkGoods_View.GoodsCode, Object_LinkGoods_View.GoodsCodeInt::TVarChar) ::Integer AS CommonCode
                      FROM ObjectLink AS ObjectLink_Child 
                           LEFT JOIN  ObjectLink AS ObjectLink_Main 
                                                 ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
           
                           LEFT JOIN  tmpGoodsSP ON tmpGoodsSP.GoodsId = ObjectLink_Main.ChildObjectId 

                           /*LEFT JOIN  ObjectBoolean AS ObjectBoolean_Goods_SP 
                                                    ON ObjectBoolean_Goods_SP.ObjectId = ObjectLink_Main.ChildObjectId 
                                                   AND ObjectBoolean_Goods_SP.DescId = zc_ObjectBoolean_Goods_SP()  */
                                                   
                           LEFT JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsmainId = ObjectLink_Main.ChildObjectId
                                                          AND Object_LinkGoods_View.ObjectId = zc_Enum_GlobalConst_Marion()
                                                          AND vbPartnerId = 59612 -- Вента
                                                          AND 1=0 -- 17.01.2018 - во внешних заказах по поставщику вента   убрать  задвоение позиции  из-за разных кодов Мориона.   Так как у них идет загрузка  наших заказов по их коду  (мы грузим их прайсы межгорода) - отпала необходимость в кодировке Мориона.

                           LEFT JOIN ObjectBoolean AS ObjectBoolean_Resolution_224
                                                   ON ObjectBoolean_Resolution_224.ObjectId = ObjectLink_Main.ChildObjectId
                                                  AND ObjectBoolean_Resolution_224.DescId = zc_ObjectBoolean_Goods_Resolution_224()

                      WHERE ObjectLink_Child.ChildObjectId IN (SELECT DISTINCT tmpData.GoodsId FROM tmpData)
                        AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
                      )

   -- НДС из прайс-листа поставщика (LoadPriceList )
   , tmpLoadPriceList AS (SELECT *
                          FROM (SELECT LoadPriceListItem.CommonCode
                                     , LoadPriceListItem.GoodsName
                                     , LoadPriceListItem.GoodsNDS
                                     , LoadPriceListItem.GoodsId
                                     , LoadPriceListItem.ProducerName
                                     , PartnerGoods.Id AS PartnerGoodsId
                                     , ROW_NUMBER() OVER (PARTITION BY PartnerGoods.Id ORDER BY LoadPriceList.OperDate DESC, LoadPriceListItem.Id DESC) AS ORD
                                FROM LoadPriceList
                                     LEFT JOIN LoadPriceListItem ON LoadPriceListItem.LoadPriceListId = LoadPriceList.Id
                         
                                     LEFT JOIN Object_Goods_Juridical AS PartnerGoods ON PartnerGoods.JuridicalId  = LoadPriceList.JuridicalId
                                                                                     AND PartnerGoods.Code = LoadPriceListItem.GoodsCode
                                                                                    --AND COALESCE(PartnerGoods.AreaId, 0) = vbAreaId
                                WHERE LoadPriceList.JuridicalId = vbPartnerId
                                ) AS tmp
                          WHERE tmp.ORD = 1
                          )


       SELECT
             tmpMI.Id
           , tmpMainParam.CommonCode
           , tmpMI.GoodsId
           , tmpMI.GoodsCode
           , tmpMI.GoodsName
           , tmpMI.PartnerGoodsId
           , COALESCE(MIString_GoodsCode.ValueData, tmpMI.PartnerGoodsCode)        AS PartnerGoodsCode
           , COALESCE(MIString_GoodsName.ValueData, Object_PartnerGoods.ValueData) AS PartnerGoodsName
           , Object_Retail.ValueData    AS RetailName
           , Object_Area.ValueData      AS AreaName
           , CASE WHEN COALESCE (tmpLoadPriceList.GoodsNDS,'0') <> '0' THEN COALESCE (tmpLoadPriceList.GoodsNDS,'') ELSE '' END  :: TVarChar  AS NDS_PriceList                                                               -- НДС из прайса поставщика
           , tmpMI.Amount               AS Amount
           , tmpMI.Price                AS Price
           , tmpMI.Summ ::TFloat        AS Summ
           
           , tmpMI.PartionGoodsDate     AS PartionGoodsDate
           , tmpMI.Comment              AS Comment
           , FALSE                      AS isErased
           , COALESCE (tmpMainParam.isSP, FALSE)           ::Boolean AS isSP
           , COALESCE (GoodsParam_Close.ValueData, FALSE)  ::Boolean AS isClose
           , COALESCE (GoodsParam_First.ValueData, FALSE)  ::Boolean AS isFirst
           , COALESCE (GoodsParam_Second.ValueData, FALSE) ::Boolean AS isSecond
           , COALESCE (GoodsPrice.isTop, GoodsParam_TOP.ValueData, FALSE) ::Boolean AS isTOP
           , COALESCE (tmpMainParam.isResolution_224, FALSE) :: Boolean AS isResolution_224

           , CASE WHEN tmpMainParam.isSP = TRUE THEN 25088                                                          -- товар соц.проекта
               WHEN tmpMI.PartionGoodsDate < vbDate180 THEN zc_Color_Red()                                          -- если срок годности менее 6 мес.
               WHEN COALESCE (GoodsPrice.isTop, GoodsParam_TOP.ValueData, FALSE) = TRUE THEN zc_Color_Blue()        --15993821 -- 16440317    -- для топ голубой
               ELSE 0
             END                                                 AS PartionGoodsDateColor
           , CASE
                  WHEN COALESCE(MIString_GoodsName.ValueData, Object_PartnerGoods.ValueData) ILIKE '%А+%' AND vbJuridicalId = 410822 
                    OR (COALESCE(MIString_GoodsName.ValueData, Object_PartnerGoods.ValueData) ILIKE '%СТМ%' 
                     OR COALESCE(MIString_GoodsName.ValueData, Object_PartnerGoods.ValueData) ILIKE '%PL/%') AND vbJuridicalId = 59612  THEN zc_Color_Red()    --красный заказывать нельзя
                  ELSE zc_Color_White()
             END  AS OrderShedule_Color
      
       FROM tmpData AS tmpMI
            -- торговая сеть
            LEFT JOIN  tmpObjectLink_Object AS ObjectLink_Object 
                                            ON ObjectLink_Object.ObjectId = tmpMI.GoodsId
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Object.ChildObjectId
            -- регион
            LEFT JOIN tmpObjectLink_Area AS ObjectLink_Goods_Area
                                         ON ObjectLink_Goods_Area.ObjectId = tmpMI.PartnerGoodsId
            LEFT JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Goods_Area.ChildObjectId
            --
            LEFT JOIN tmpMainParam ON tmpMainParam.GoodsId = tmpMI.GoodsId
            
            LEFT JOIN GoodsPrice ON GoodsPrice.GoodsId = tmpMI.GoodsId
            
            LEFT JOIN tmpGoodsParam AS GoodsParam_Close 
                                    ON GoodsParam_Close.ObjectId = tmpMI.GoodsId
                                   AND GoodsParam_Close.DescId = zc_ObjectBoolean_Goods_Close()
            LEFT JOIN tmpGoodsParam AS GoodsParam_First 
                                    ON GoodsParam_First.ObjectId = tmpMI.GoodsId
                                   AND GoodsParam_First.DescId = zc_ObjectBoolean_Goods_First()
            LEFT JOIN tmpGoodsParam AS GoodsParam_Second
                                    ON GoodsParam_Second.ObjectId = tmpMI.GoodsId
                                   AND GoodsParam_Second.DescId = zc_ObjectBoolean_Goods_Second()
            LEFT JOIN tmpGoodsParam AS GoodsParam_TOP
                                    ON GoodsParam_TOP.ObjectId = tmpMI.GoodsId
                                   AND GoodsParam_TOP.DescId = zc_ObjectBoolean_Goods_TOP()
           
            LEFT JOIN tmpLoadPriceList ON tmpLoadPriceList.PartnerGoodsId = tmpMI.PartnerGoodsId
            LEFT JOIN Object AS Object_PartnerGoods ON Object_PartnerGoods.Id = tmpMI.PartnerGoodsId

            LEFT JOIN MovementItemString AS MIString_GoodsCode 
                                         ON MIString_GoodsCode.MovementItemId = tmpMI.Id
                                        AND MIString_GoodsCode.DescId = zc_MIString_GoodsCode()     
                                        AND vbStatusId = zc_Enum_Status_Complete()                              
            LEFT JOIN MovementItemString AS MIString_GoodsName 
                                         ON MIString_GoodsName.MovementItemId = tmpMI.Id
                                        AND MIString_GoodsName.DescId = zc_MIString_GoodsName()                                  
                                        AND vbStatusId = zc_Enum_Status_Complete() 
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 22.04.20         * isResolution_224
 22.04.20         * tmpLoadPriceList.GoodsNDS
 11.02.19         * признак Товары соц-проект берем и документа
 08.11.18         *
 21.10.17         * add AreaName
 25.09.17         *
 06.04.17         * add isSp
 12.12.14                         *
 06.11.14                         *
 20.10.14                         *
 15.07.14                                                       *
 01.07.14                                                       *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_OrderExternal (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_OrderExternal (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
--select * from gpSelect_MovementItem_OrderExternal22(inMovementId := 11528384 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');