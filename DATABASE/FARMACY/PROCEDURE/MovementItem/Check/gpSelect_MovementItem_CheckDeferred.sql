-- Function: gpSelect_MovementItem_CheckDeferred()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_CheckDeferred (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_CheckDeferred(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, MovementId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount_remains TFloat
             , Amount TFloat
             , Price TFloat
             , Summ TFloat
             , NDS TFloat
             , PriceSale TFloat
             , ChangePercent TFloat
             , SummChangePercent TFloat
             , AmountOrder TFloat
             , List_UID TVarChar
             , isErased Boolean
             , Color_Calc Integer
             , Color_CalcError Integer
             , PartionDateKindId Integer
             , PartionDateKindName TVarChar
             , PricePartionDate TFloat
             , PartionDateDiscount TFloat
             , AmountMonth TFloat
             , TypeDiscount Integer
             , PriceDiscount TFloat
             , NDSKindId Integer
             , DiscountExternalID Integer
             , DiscountExternalName TVarChar
             , UKTZED TVarChar
             , GoodsPairSunId Integer
             , isGoodsPairSun boolean
             , GoodsPairSunMainId Integer
             , GoodsPairSunAmount TFloat
             , DivisionPartiesId Integer
             , DivisionPartiesName TVarChar
             , isPresent Boolean
             , MultiplicitySale TFloat
             , isMultiplicityError boolean
             , JuridicalId Integer
             , JuridicalName TVarChar
             , GoodsDiscountProcent TFloat
             , PriceSaleDiscount TFloat
             , isPriceDiscount boolean
             , GoodsPresentID Integer
             , isGoodsPresent boolean
             , PriceLoad TFloat
             , isAsinoMain boolean, isAsinoPresent boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitId Integer;
  DECLARE vbUnitKey TVarChar;
  DECLARE vbLanguage TVarChar;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := inSession;
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
        vbUnitKey := '0';
    END IF;
    vbUnitId := CASE WHEN vbUserId = 3 THEN 0 ELSE vbUnitKey::Integer END;

    SELECT COALESCE (ObjectString_Language.ValueData, 'RU')::TVarChar                AS Language
    INTO vbLanguage
    FROM Object AS Object_User
                 
         LEFT JOIN ObjectString AS ObjectString_Language
                ON ObjectString_Language.ObjectId = Object_User.Id
               AND ObjectString_Language.DescId = zc_ObjectString_User_Language()
              
    WHERE Object_User.Id = vbUserId;    

    CREATE TEMP TABLE tmpAsinoPharmaSP ON COMMIT DROP AS 
    SELECT * FROM gpSelect_AsinoPharmaSPAllGoods_Cash(inSession := '3');

    ANALYZE tmpAsinoPharmaSP;

    RETURN QUERY
        WITH
            tmpMovementCheck AS (SELECT Movement.Id
                                 FROM Movement
                                 WHERE Movement.DescId = zc_Movement_Check()
                                   AND Movement.StatusId = zc_Enum_Status_UnComplete())
          , tmpMovReserveId AS (
                             SELECT Movement.Id
                                  , COALESCE(MovementBoolean_Deferred.ValueData, FALSE) AS  isDeferred
                                  ,  MovementString_CommentError.ValueData              AS  CommentError
                             FROM tmpMovementCheck AS Movement
                                  LEFT JOIN MovementBoolean AS MovementBoolean_Deferred ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                            AND MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                                  LEFT JOIN MovementString AS MovementString_CommentError ON Movement.Id     = MovementString_CommentError.MovementId
                                                          AND MovementString_CommentError.DescId = zc_MovementString_CommentError()
                                                          AND MovementString_CommentError.ValueData <> ''                             )

          , tmpMovementLinkObject AS (SELECT * FROM MovementLinkObject 
                                      WHERE MovementLinkObject.MovementId in (select tmpMovReserveId.ID from tmpMovReserveId))

          , tmpMov AS (
                             SELECT Movement.Id
                                  , Movement.isDeferred
                                  , Movement.CommentError
                                  , MovementLinkObject_Unit.ObjectId            AS UnitId
                                  , MovementLinkObject_ConfirmedKind.ObjectId   AS ConfirmedKindId
                             FROM tmpMovReserveId AS Movement
                                  INNER JOIN tmpMovementLinkObject AS MovementLinkObject_Unit
                                                                   ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                                  AND (MovementLinkObject_Unit.ObjectId = vbUnitId  OR vbUnitId  = 0)
                                  LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                                  ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                                 AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                             WHERE isDeferred = TRUE OR COALESCE(CommentError, '') <> '')
          , tmpGoodsPairSunMain AS (SELECT Object_Goods_Retail.GoodsPairSunId                          AS ID
                                         , Min(Object_Goods_Retail.Id)::Integer                        AS MainID
                                    FROM Object_Goods_Retail
                                    WHERE COALESCE (Object_Goods_Retail.GoodsPairSunId, 0) <> 0
                                      AND Object_Goods_Retail.RetailId = 4
                                    GROUP BY Object_Goods_Retail.GoodsPairSunId)
          , tmpGoodsPairSun AS (SELECT Object_Goods_Retail.Id
                                     , Object_Goods_Retail.GoodsPairSunId
                                     , COALESCE(Object_Goods_Retail.PairSunAmount, 1)::TFloat AS GoodsPairSunAmount
                                FROM Object_Goods_Retail
                                WHERE COALESCE (Object_Goods_Retail.GoodsPairSunId, 0) <> 0
                                  AND Object_Goods_Retail.RetailId = 4)
          , tmpMI_all AS (SELECT MovementItem.Id, MovementItem.Amount, MovementItem.ObjectId, MovementItem.MovementId
                               , Object_Goods_PairSun_Main.MainID                       AS GoodsPairSunId
                               , COALESCE(Object_Goods_PairSun_Main.MainID, 0) <> 0     AS isGoodsPairSun
                               , Object_Goods_PairSun.GoodsPairSunID                    AS GoodsPairSunMainId
                               , Object_Goods_PairSun.GoodsPairSunAmount                AS GoodsPairSunAmount
                               , COALESCE (MIBoolean_Present.ValueData, False)          AS isPresent                               
                          FROM MovementItem
                               LEFT JOIN tmpGoodsPairSun AS Object_Goods_PairSun
                                                         ON Object_Goods_PairSun.Id = MovementItem.ObjectId
                               LEFT JOIN tmpGoodsPairSunMain AS Object_Goods_PairSun_Main
                                                             ON Object_Goods_PairSun_Main.Id = MovementItem.ObjectId
                               LEFT JOIN MovementItemBoolean AS MIBoolean_Present
                                                             ON MIBoolean_Present.MovementItemId = MovementItem.Id
                                                            AND MIBoolean_Present.DescId         = zc_MIBoolean_Present()
                          WHERE MovementItem.MovementId in (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                     )
          , tmpMI AS (SELECT tmpMov.UnitId, tmpMI_all.ObjectId AS GoodsId, SUM (tmpMI_all.Amount) AS Amount
                      FROM tmpMI_all
                           INNER JOIN tmpMov ON tmpMov.ID = tmpMI_all.MovementId
                      WHERE tmpMov.CommentError <> '' OR tmpMov.ConfirmedKindId = zc_Enum_ConfirmedKind_UnComplete()
                      GROUP BY tmpMov.UnitId, tmpMI_all.ObjectId
                     )
          , tmpRemains AS (SELECT tmpMI.GoodsId
                                , tmpMI.UnitId
                                , tmpMI.Amount           AS Amount_mi
                                , COALESCE (SUM (Container.Amount), 0) AS Amount_remains
                           FROM tmpMI
                                LEFT JOIN Container ON Container.DescId = zc_Container_Count()
                                                   AND Container.ObjectId = tmpMI.GoodsId
                                                   AND Container.WhereObjectId = tmpMI.UnitId
                                                   AND Container.Amount <> 0
                           GROUP BY tmpMI.GoodsId
                                  , tmpMI.UnitId
                                  , tmpMI.Amount
                           HAVING COALESCE (SUM (Container.Amount), 0) < tmpMI.Amount
                          )
          , tmpMovementBoolean AS (SELECT * FROM MovementBoolean WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMI_all.MovementId FROM tmpMI_all)
                          )
          , tmpMIFloat AS (SELECT * FROM MovementItemFloat WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                          )
          , tmpMIString AS (SELECT * FROM MovementItemString WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                          )
          , tmpOF_NDSKind_NDS AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId, ObjectFloat_NDSKind_NDS.valuedata FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                                  WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                          )
          , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                                , ObjectFloat_NDSKind_NDS.ValueData
                          FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                          WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                         )
           , tmpMovSendPartion AS (SELECT
                                          Movement.Id                               AS Id
                                        , MovementFloat_ChangePercent.ValueData     AS ChangePercent
                                        , MovementFloat_ChangePercentMin.ValueData  AS ChangePercentMin
                                   FROM Movement

                                        LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                                ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                                               AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

                                        LEFT JOIN MovementFloat AS MovementFloat_ChangePercentMin
                                                                ON MovementFloat_ChangePercentMin.MovementId =  Movement.Id
                                                               AND MovementFloat_ChangePercentMin.DescId = zc_MovementFloat_ChangePercentMin()

                                        LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                                   WHERE Movement.DescId = zc_Movement_SendPartionDate()
                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                                     AND MovementLinkObject_Unit.ObjectId = vbUnitKey::Integer
                                   ORDER BY Movement.OperDate
                                   LIMIT 1
                                  )
           , tmpMovItemSendPartion AS (SELECT
                                              MovementItem.ObjectId    AS GoodsId
                                            , MIFloat_ChangePercent.ValueData    AS ChangePercent
                                            , MIFloat_ChangePercentMin.ValueData AS ChangePercentMin

                                       FROM MovementItem

                                            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                                        ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                                            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentMin
                                                                        ON MIFloat_ChangePercentMin.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_ChangePercentMin.DescId = zc_MIFloat_ChangePercentMin()

                                       WHERE MovementItem.MovementId = (select tmpMovSendPartion.Id from tmpMovSendPartion)
                                         AND MovementItem.DescId = zc_MI_Master()
                                         AND (MIFloat_ChangePercent.ValueData is not Null OR MIFloat_ChangePercentMin.ValueData is not Null)
                                       )
           , tmpMI_Sum AS (SELECT  MovementItem.*
                                 , MIFloat_Price.ValueData             AS Price
                                 , MIFloat_PriceSale.ValueData         AS PriceSale
                                 , MIFloat_ChangePercent.ValueData     AS ChangePercent
                                 , MIFloat_SummChangePercent.ValueData AS SummChangePercent
                                 , MIFloat_AmountOrder.ValueData       AS AmountOrder
                                 , MIFloat_MovementItem.ValueData      AS PricePartionDate
                                 , zfCalc_SummaCheck(COALESCE (MovementItem.Amount, 0) * MIFloat_Price.ValueData
                                                   , COALESCE (MB_RoundingDown.ValueData, True)
                                                   , COALESCE (MB_RoundingTo10.ValueData, True)
                                                   , COALESCE (MB_RoundingTo50.ValueData, False)) AS AmountSumm
                                 , MIString_UID.ValueData              AS List_UID
                                 , MIFloat_PriceLoad.ValueData         AS PriceLoad
                             FROM tmpMI_all AS MovementItem

                                LEFT JOIN tmpMIFloat AS MIFloat_AmountOrder
                                                            ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
                                LEFT JOIN tmpMIFloat AS MIFloat_Price
                                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                LEFT JOIN tmpMIFloat AS MIFloat_PriceSale
                                                            ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                                           AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                                LEFT JOIN MovementItemFloat AS MIFloat_PriceLoad
                                                            ON MIFloat_PriceLoad.MovementItemId = MovementItem.Id
                                                           AND MIFloat_PriceLoad.DescId = zc_MIFloat_PriceLoad()
                                LEFT JOIN tmpMIFloat AS MIFloat_ChangePercent
                                                            ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                           AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                                LEFT JOIN tmpMIFloat AS MIFloat_SummChangePercent
                                                            ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                           AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()
                                LEFT JOIN tmpMIFloat AS MIFloat_MovementItem
                                                            ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                                           AND MIFloat_MovementItem.DescId = zc_MIFloat_PricePartionDate()
                                LEFT JOIN tmpMovementBoolean AS MB_RoundingTo10
                                                          ON MB_RoundingTo10.MovementId = MovementItem.MovementId
                                                         AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()
                                LEFT JOIN tmpMovementBoolean AS MB_RoundingDown
                                                          ON MB_RoundingDown.MovementId = MovementItem.MovementId
                                                         AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()
                                LEFT JOIN tmpMovementBoolean AS MB_RoundingTo50
                                                             ON MB_RoundingTo50.MovementId = MovementItem.MovementId
                                                            AND MB_RoundingTo50.DescId = zc_MovementBoolean_RoundingTo50()
                                LEFT JOIN tmpMIString AS MIString_UID
                                                             ON MIString_UID.MovementItemId = MovementItem.Id
                                                            AND MIString_UID.DescId = zc_MIString_UID()

                                                           )
           , tmpMILinkObject AS (SELECT * FROM MovementItemLinkObject 
                                 WHERE MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all))
           , tmpGoodsDiscount AS (SELECT Object_Goods_Retail.GoodsMainId                           AS GoodsMainId
                                       , Object_Object.Id                                          AS GoodsDiscountId
                                       , Object_Object.ValueData                                   AS GoodsDiscountName
                                       , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False)  AS isGoodsForProject
                                       , MAX(COALESCE(ObjectFloat_MaxPrice.ValueData, 0))::TFloat  AS MaxPrice 
                                       , MAX(ObjectFloat_DiscountProcent.ValueData)::TFloat        AS DiscountProcent 
                                    FROM Object AS Object_BarCode
                                        INNER JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                              ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                             AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                        INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = ObjectLink_BarCode_Goods.ChildObjectId

                                        LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                             ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                            AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                        LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId

                                        LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsForProject
                                                                ON ObjectBoolean_GoodsForProject.ObjectId = Object_Object.Id 
                                                               AND ObjectBoolean_GoodsForProject.DescId = zc_ObjectBoolean_DiscountExternal_GoodsForProject()

                                        LEFT JOIN ObjectFloat AS ObjectFloat_MaxPrice
                                                              ON ObjectFloat_MaxPrice.ObjectId = Object_BarCode.Id
                                                             AND ObjectFloat_MaxPrice.DescId = zc_ObjectFloat_BarCode_MaxPrice()
                                        LEFT JOIN ObjectFloat AS ObjectFloat_DiscountProcent
                                                              ON ObjectFloat_DiscountProcent.ObjectId = Object_BarCode.Id
                                                             AND ObjectFloat_DiscountProcent.DescId = zc_ObjectFloat_BarCode_DiscountProcent()

                                    WHERE Object_BarCode.DescId = zc_Object_BarCode()
                                      AND Object_BarCode.isErased = False
                                    GROUP BY Object_Goods_Retail.GoodsMainId
                                           , Object_Object.Id
                                           , Object_Object.ValueData
                                           , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False)
                                    HAVING MAX(ObjectFloat_DiscountProcent.ValueData) > 0)
           , tmpGoodsDiscountPrice AS (SELECT MovementItem.Id
                                            , CASE WHEN Object_Goods.isTop = TRUE
                                                    AND Object_Goods.Price > 0
                                                   THEN Object_Goods.Price
                                                   ELSE ObjectFloat_Price_Value.ValueData
                                                   END AS Price
                                            , tmpGoodsDiscount.DiscountProcent
                                            , tmpGoodsDiscount.MaxPrice
                                       FROM tmpGoodsDiscount
                                            
                                            INNER JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.GoodsMainId = tmpGoodsDiscount.GoodsMainId
                                            
                                            INNER JOIN tmpMI_Sum AS MovementItem ON MovementItem.ObjectId = Object_Goods.Id

                                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                         ON MovementLinkObject_Unit.MovementId = MovementItem.MovementId
                                                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
                        
                                            INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                                  ON ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                                                 AND ObjectLink_Price_Unit.ChildObjectId = MovementLinkObject_Unit.ObjectId 
                                            INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                                                  ON ObjectLink_Price_Goods.ObjectId      = ObjectLink_Price_Unit.ObjectId
                                                                 AND ObjectLink_Price_Goods.ChildObjectId = Object_Goods.Id 
                                                                 AND ObjectLink_Price_Goods.DescId        = zc_ObjectLink_Price_Goods()
                                            LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                                                  ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                                 AND ObjectFloat_Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                            LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                                                    ON ObjectBoolean_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                                   AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_Price_Top()
                                       WHERE COALESCE(tmpGoodsDiscount.DiscountProcent, 0) > 0                                        
                                       )


       -- Результат
       SELECT
             MovementItem.Id          AS Id,
             MovementItem.MovementId  AS MovementId
           , MovementItem.ObjectId    AS GoodsId
           , Object_Goods_Main.ObjectCode  AS GoodsCode
           , CASE WHEN vbLanguage = 'UA' AND COALESCE(Object_Goods_Main.NameUkr, '') <> ''
                  THEN Object_Goods_Main.NameUkr
                  ELSE Object_Goods_Main.Name END AS GoodsName
           , tmpRemains.Amount_remains :: TFloat AS Amount_remains
           , MovementItem.Amount      AS Amount
           , MovementItem.Price       AS Price
           , MovementItem.AmountSumm
           , COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)::TFloat  AS NDS
           , MovementItem.PriceSale              AS PriceSale
           , MovementItem.ChangePercent          AS ChangePercent
           , MovementItem.SummChangePercent      AS SummChangePercent
           , MovementItem.AmountOrder            AS AmountOrder
           , MovementItem.List_UID               AS List_UID
           , False                               AS isErased

           , CASE WHEN Movement.ConfirmedKindId = zc_Enum_ConfirmedKind_UnComplete() AND tmpRemains.GoodsId > 0 THEN 16440317 -- бледно крассный / розовый
                  -- WHEN tmpMov.ConfirmedKindId = zc_Enum_ConfirmedKind_UnComplete() AND tmpRemains.GoodsId IS NULL THEN zc_Color_Yelow() -- желтый
                  ELSE zc_Color_White()
             END  AS Color_Calc

           , CASE WHEN tmpRemains.GoodsId > 0 THEN zc_Color_Red()
                  ELSE zc_Color_Black()
             END  AS Color_CalcError
           , Object_PartionDateKind.Id                                           AS PartionDateKindId
           , Object_PartionDateKind.ValueData                                    AS PartionDateKindName
           , MovementItem.PricePartionDate                                       AS PricePartionDate
           , Null::TFloat                                                        AS PartionDateDiscount
           , COALESCE (ObjectFloat_Month.ValueData, 0) :: TFLoat AS AmountMonth
           , 0::Integer                                                          AS TypeDiscount
           , COALESCE(MovementItem.PricePartionDate, MovementItem.PriceSale)     AS PriceDiscount
           , COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods_Main.NDSKindId) AS  NDSKindId
           , Object_DiscountExternal.ID                                          AS DiscountCardId
           , Object_DiscountExternal.ValueData                                   AS DiscountCardName
           , REPLACE(REPLACE(REPLACE(Object_Goods_Main.CodeUKTZED, ' ', ''), '.', ''), Chr(160), '')::TVarChar  AS UKTZED
           , MovementItem.GoodsPairSunId                                         AS GoodsPairSunId     
           , MovementItem.isGoodsPairSun                                         AS isGoodsPairSun
           , MovementItem.GoodsPairSunMainId                                     AS GoodsPairSunMainId
           , MovementItem.GoodsPairSunAmount                                     AS GoodsPairSunAmount
           , Object_DivisionParties.Id                                           AS DivisionPartiesId 
           , Object_DivisionParties.ValueData                                    AS DivisionPartiesName 
           , MovementItem.isPresent                                              AS isPresent
           , Object_Goods_Main.Multiplicity                                      AS MultiplicitySale
           , Object_Goods_Main.isMultiplicityError                               AS isMultiplicityError
           , MILinkObject_Juridical.ObjectId                                     AS JuridicalId 
           , Object_Juridical.ValueData                                          AS JuridicalName
           , tmpGoodsDiscountPrice.DiscountProcent                               AS GoodsDiscountProcent
           , CASE WHEN COALESCE (tmpGoodsDiscountPrice.DiscountProcent, 0) = 0 OR COALESCE(tmpGoodsDiscountPrice.Price, 0) = 0
                  THEN NULL
                  WHEN COALESCE(tmpGoodsDiscountPrice.MaxPrice, 0) = 0 OR tmpGoodsDiscountPrice.Price < tmpGoodsDiscountPrice.MaxPrice
                  THEN tmpGoodsDiscountPrice.Price 
                  ELSE tmpGoodsDiscountPrice.MaxPrice END :: TFLoat              AS PriceSaleDiscount
           , CASE WHEN COALESCE (tmpGoodsDiscountPrice.DiscountProcent, 0) = 0 OR COALESCE(tmpGoodsDiscountPrice.Price, 0) = 0
                  THEN FALSE
                  WHEN COALESCE (tmpGoodsDiscountPrice.DiscountProcent, 0) = 100 AND COALESCE (MovementItem.Price, 0) = 0
                  THEN TRUE
                  ELSE MovementItem.Price <
                      CASE WHEN COALESCE(tmpGoodsDiscountPrice.MaxPrice, 0) = 0 OR tmpGoodsDiscountPrice.Price < tmpGoodsDiscountPrice.MaxPrice
                           THEN tmpGoodsDiscountPrice.Price ELSE tmpGoodsDiscountPrice.MaxPrice END * 98 / 100
                  END :: BOOLEAN                                                 AS isPriceDiscount
           , COALESCE (MILinkObject_GoodsPresent.ObjectId, 0)                    AS GoodsPresentID
           , COALESCE (MIBoolean_GoodsPresent.ValueData, False)                  AS isGoodsPresent
           , MovementItem.PriceLoad
           , COALESCE (tmpAsinoPharmaSP.IsAsinoMain , FALSE)                       AS IsAsinoMain
           , COALESCE (tmpAsinoPharmaSP.IsAsinoPresent , FALSE)                    AS IsAsinoPresent

       FROM tmpMI_Sum AS MovementItem

          INNER JOIN tmpMov AS Movement ON Movement.ID = MovementItem.MovementId

          LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
          LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

          LEFT JOIN tmpMILinkObject AS MILinkObject_NDSKind
                                           ON MILinkObject_NDSKind.MovementItemId = MovementItem.Id
                                          AND MILinkObject_NDSKind.DescId = zc_MILinkObject_NDSKind()
                                          AND COALESCE (MILinkObject_NDSKind.ObjectId, 0) <> 13937605

          LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                               ON ObjectFloat_NDSKind_NDS.ObjectId = COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods_Main.NDSKindId)

          LEFT JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem.ObjectId
                              AND tmpRemains.UnitId  = Movement.UnitId

          --Типы срок/не срок
          LEFT JOIN tmpMILinkObject AS MI_PartionDateKind
                                           ON MI_PartionDateKind.MovementItemId = MovementItem.Id
                                          AND MI_PartionDateKind.DescId = zc_MILinkObject_PartionDateKind()
          LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MI_PartionDateKind.ObjectId
                                                    AND Object_PartionDateKind.DescId = zc_Object_PartionDateKind()

          LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                               AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()

          LEFT JOIN tmpMILinkObject AS MILinkObject_DiscountExternal
                                           ON MILinkObject_DiscountExternal.MovementItemId = MovementItem.Id
                                          AND MILinkObject_DiscountExternal.DescId         = zc_MILinkObject_DiscountExternal()
          LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = MILinkObject_DiscountExternal.ObjectId

          LEFT JOIN tmpMILinkObject AS MILinkObject_DivisionParties
                                           ON MILinkObject_DivisionParties.MovementItemId = MovementItem.Id
                                          AND MILinkObject_DivisionParties.DescId         = zc_MILinkObject_DivisionParties()
          LEFT JOIN Object AS Object_DivisionParties ON Object_DivisionParties.Id = MILinkObject_DivisionParties.ObjectId

          LEFT JOIN tmpMILinkObject AS MILinkObject_Juridical
                                           ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Juridical.DescId         = zc_MILinkObject_Juridical()
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MILinkObject_Juridical.ObjectId

          LEFT JOIN tmpGoodsDiscountPrice ON tmpGoodsDiscountPrice.Id = MovementItem.Id

          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsPresent
                                           ON MILinkObject_GoodsPresent.MovementItemId = MovementItem.Id
                                          AND MILinkObject_GoodsPresent.DescId = zc_MILinkObject_GoodsPresent()
          LEFT JOIN MovementItemBoolean AS MIBoolean_GoodsPresent
                                        ON MIBoolean_GoodsPresent.MovementItemId = MovementItem.Id
                                       AND MIBoolean_GoodsPresent.DescId         = zc_MIBoolean_GoodsPresent()

          LEFT JOIN tmpAsinoPharmaSP ON tmpAsinoPharmaSP.GoodsId = MovementItem.ObjectId 
         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_CheckDeferred (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А. Воробкало А.А   Шаблий О.В.
 23.09.19                                                                                   * оптимизация
 24.06.19                                                                                   *
 02.04.19                                                                                   *
 30.10.16         * add Color_Calc
 10.08.16                                                                     * MIString_UID.ValueData AS List_UID + оптимизация
 08.04.16         *
 03.07.15                                                                       *
 25.05.15                         *

*/

-- тест
-- 
-- 
-- SELECT * FROM gpSelect_MovementItem_CheckDeferred ('3')
-- SELECT * FROM gpSelect_MovementItem_CheckDeferred ('11124506')

-- 
select * from gpSelect_MovementItem_CheckDeferred( inSession := '3')
--where GoodsId = 5925154;4;