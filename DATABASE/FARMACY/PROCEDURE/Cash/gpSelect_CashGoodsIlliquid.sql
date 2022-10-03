-- Function: gpSelect_CashGoodsIlliquid()

DROP FUNCTION IF EXISTS gpSelect_CashGoodsIlliquid (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CashGoodsIlliquid(
    IN inSession        TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer,
               GoodsCode Integer,
               GoodsName TVarChar,
               ExpirationDate TDateTime,
               PartionDateKindId Integer,
               PartionDateKindName  TVarChar,
               Price TFloat,
               AmountReserve TFloat,
               DeferredSend TFloat,
               Remains TFloat,
               AmountCheck TFloat,
               SummaCheck TFloat,
               DivisionPartiesId Integer,
               DivisionPartiesName  TVarChar,
               DiscountExternalID Integer,
               DiscountExternalName  TVarChar,
               NDSKindId  Integer,
               AccommodationName TVarChar,
               CheckList TVarChar
               )

AS
$BODY$
  DECLARE vbUserId      Integer;
  DECLARE vbObjectId    Integer;
  DECLARE vbUnitId      Integer;
  DECLARE vbUnitIdStr   TVarChar;

  DECLARE vbDate_6 TDateTime;
  DECLARE vbDate_3 TDateTime;
  DECLARE vbDate_1 TDateTime;
  DECLARE vbDate_0 TDateTime;
  DECLARE vbDiscountExternal    boolean;
  DECLARE vbIlliquidUnitId Integer;
  DECLARE vbLanguage TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PriceList());
     vbUserId := inSession;
     vbObjectId := COALESCE (lpGet_DefaultValue ('zc_Object_Retail', vbUserId), '0');
     vbUnitIdStr := COALESCE (lpGet_DefaultValue ('zc_Object_Unit', vbUserId), '0');
     IF vbUnitIdStr <> '' THEN
        vbUnitId := vbUnitIdStr;
     ELSE
     	vbUnitId := 0;
     END IF;

    IF  zfGet_Unit_DiscountExternal (13216391, vbUnitId, vbUserId) = 13216391
    THEN
      vbDiscountExternal := True;
    ELSE
      vbDiscountExternal := False;
    END IF;

    -- значения для разделения по срокам
    SELECT Date_6, Date_3, Date_1, Date_0
    INTO vbDate_6, vbDate_3, vbDate_1, vbDate_0
    FROM lpSelect_PartionDateKind_SetDate ();

    SELECT COALESCE (ObjectString_Language.ValueData, 'RU')::TVarChar                AS Language
    INTO vbLanguage
    FROM Object AS Object_User
                 
         LEFT JOIN ObjectString AS ObjectString_Language
                ON ObjectString_Language.ObjectId = Object_User.Id
               AND ObjectString_Language.DescId = zc_ObjectString_User_Language()
              
    WHERE Object_User.Id = vbUserId;    

    -- Текущий документ Неликвиды по подразделениям
    IF EXISTS(SELECT 1
              FROM Movement

                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                AND MovementLinkObject_Unit.ObjectId = vbUnitId

              WHERE Movement.OperDate >= date_trunc('month', CURRENT_DATE)
                AND Movement.OperDate < date_trunc('month', CURRENT_DATE) + INTERVAL '1 MONTH'
                AND Movement.DescId = zc_Movement_IlliquidUnit()
                AND Movement.StatusId = zc_Enum_Status_Complete())
    THEN
       SELECT Movement.ID
       INTO vbIlliquidUnitId
       FROM Movement

            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                         AND MovementLinkObject_Unit.ObjectId = vbUnitId

       WHERE Movement.OperDate >= date_trunc('month', CURRENT_DATE)
         AND Movement.OperDate < date_trunc('month', CURRENT_DATE) + INTERVAL '1 MONTH'
         AND Movement.DescId = zc_Movement_IlliquidUnit()
         AND Movement.StatusId = zc_Enum_Status_Complete()
       LIMIT 1;

    ELSE
       RAISE EXCEPTION 'Зафиксированные неликвиды по подразделениям не найдены.';
    END IF;

    RETURN QUERY
    WITH
         tmpGoods AS (SELECT MovementItem.ObjectId    AS GoodsId
                           , MovementItem.Amount      AS Amount
                      FROM MovementItem
                      WHERE MovementItem.MovementId = vbIlliquidUnitId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND MovementItem.Amount     > 0
                        AND MovementItem.isErased   = FALSE)
       , tmpGoodsRemains AS (SELECT  Container.*
                             FROM gpSelect_CashRemains_CashSession (inSession) AS Container
                                  
                                  INNER JOIN tmpGoods ON tmpGoods.GoodsId = Container.GoodsId
                            )
         -- Отложенные чеки
       , tmpMovementCheck AS (SELECT Movement.Id
                                   , Movement.InvNumber
                                   , Movement.OperDate
                              FROM Movement
                              WHERE Movement.DescId = zc_Movement_Check()
                                AND Movement.StatusId = zc_Enum_Status_UnComplete())
       , tmpMovReserveAll AS (
                             SELECT Movement.Id
                                  , Movement.InvNumber
                                  , Movement.OperDate
                             FROM MovementBoolean AS MovementBoolean_Deferred
                                  INNER JOIN tmpMovementCheck AS Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                             WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                               AND MovementBoolean_Deferred.ValueData = TRUE
                             UNION ALL
                             SELECT Movement.Id
                                  , Movement.InvNumber
                                  , Movement.OperDate
                             FROM MovementString AS MovementString_CommentError
                                  INNER JOIN tmpMovementCheck AS Movement ON Movement.Id     = MovementString_CommentError.MovementId
                             WHERE MovementString_CommentError.DescId = zc_MovementString_CommentError()
                               AND MovementString_CommentError.ValueData <> ''
                             )
       , tmpMIReserve AS (SELECT Movement.Id
                               , Movement.InvNumber
                               , Movement.OperDate
                               , MovementItemMaster.Id             AS MovementItemId
                               , MovementItemMaster.ObjectId
                               , MovementItemMaster.Amount
                               , Object_Goods_Main.NDSKindId
                          FROM tmpMovReserveAll AS Movement

                               INNER JOIN MovementItem AS MovementItemMaster
                                                       ON MovementItemMaster.MovementId = Movement.Id
                                                      AND MovementItemMaster.DescId     = zc_MI_Master()
                                                      AND MovementItemMaster.isErased   = FALSE

                               LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItemMaster.ObjectId
                               LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                               )

       , tmpMovementItemLinkObject AS (SELECT * 
                                       FROM MovementItemLinkObject 
                                       WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMIReserve.MovementItemId FROM tmpMIReserve)
                                         AND MovementItemLinkObject.DescId = zc_MILinkObject_NDSKind())


       , tmpReserve AS (SELECT Movement.ObjectId                                                     AS GoodsId
                             , COALESCE (MILinkObject_NDSKind.ObjectId, Movement.NDSKindId)          AS NDSKindId
                             , COALESCE(MILinkObject_DiscountExternal.ObjectId, 0)                   AS DiscountExternalId
                             , COALESCE(MILinkObject_DivisionParties.ObjectId, 0)                    AS DivisionPartiesId
                             , COALESCE(MILinkObject_PartionDateKind.ObjectId, 0)                    AS PartionDateKindId
                             , SUM(Movement.Amount)                                                  AS Amount
                             , STRING_AGG(Movement.InvNumber||' от '||zfConvert_DateShortToString(Movement.OperDate), ',') AS CheckList
                        FROM tmpMIReserve AS Movement

                             LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_NDSKind
                                                                 ON MILinkObject_NDSKind.MovementItemId = Movement.MovementItemId
                                                                AND MILinkObject_NDSKind.DescId = zc_MILinkObject_NDSKind()

                             LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_DiscountExternal
                                                                 ON MILinkObject_DiscountExternal.MovementItemId =  Movement.MovementItemId
                                                                AND MILinkObject_DiscountExternal.DescId         = zc_MILinkObject_DiscountExternal()

                             LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_DivisionParties
                                                                 ON MILinkObject_DivisionParties.MovementItemId =  Movement.MovementItemId
                                                                AND MILinkObject_DivisionParties.DescId         = zc_MILinkObject_DivisionParties()

                             LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_PartionDateKind
                                                                 ON MILinkObject_PartionDateKind.MovementItemId =  Movement.MovementItemId
                                                                AND MILinkObject_PartionDateKind.DescId         = zc_MILinkObject_PartionDateKind()

                        GROUP BY Movement.ObjectId
                               , COALESCE (MILinkObject_NDSKind.ObjectId, Movement.NDSKindId)
                               , MILinkObject_DiscountExternal.ObjectId
                               , MILinkObject_DivisionParties.ObjectId
                               , MILinkObject_PartionDateKind.ObjectId
                        )

    SELECT GoodsRemains.GoodsId                                              AS Id
         , Object_Goods_Main.ObjectCode
         , CASE WHEN vbLanguage = 'UA' AND COALESCE(Object_Goods_Main.NameUkr, '') <> ''
                THEN Object_Goods_Main.NameUkr
                ELSE Object_Goods_Main.Name END                              AS Name
         , GoodsRemains.MinExpirationDate
         , NULLIF(GoodsRemains.PartionDateKindId, 0)                         AS PartionDateKindId
         , Object_PartionDateKind.ValueData                                  AS PartionDateKindName
         , GoodsRemains.Price                                                AS Price
         , GoodsRemains.Reserved                                             AS AmountReserve
         , GoodsRemains.DeferredSend                                         AS DeferredSend
         , GoodsRemains.Remains                                              AS Remains
         , 0::TFloat                                                         AS AmountCheck
         , 0::TFloat                                                         AS SummaCheck
         , NULLIF(GoodsRemains.DivisionPartiesId, 0)                         AS DivisionPartiesId
         , Object_DivisionParties.ValueData                                  AS DivisionPartiesName
         , NULLIF(GoodsRemains.DiscountExternalID, 0)                        AS DiscountExternalID
         , Object_DiscountExternal.ValueData                                 AS DiscountExternalName
         , NULLIF(GoodsRemains.NDSKindId, 0)                                 AS NDSKindId 
         , Object_Accommodation.ValueData                                    AS AccommodationName
         , tmpReserve.CheckList::TVarChar                                    AS CheckList
    FROM  tmpGoodsRemains AS GoodsRemains 

        LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = GoodsRemains.GoodsId
        LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
        
        LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = GoodsRemains.PartionDateKindId 
        LEFT JOIN Object AS Object_DivisionParties ON Object_DivisionParties.Id = GoodsRemains.DivisionPartiesId
        LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = GoodsRemains.DiscountExternalID

        LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = GoodsRemains.AccommodationId
                
        LEFT JOIN tmpReserve ON tmpReserve.GoodsId = GoodsRemains.GoodsId
                            AND tmpReserve.PartionDateKindId = COALESCE(GoodsRemains.PartionDateKindId, 0)  
                            AND tmpReserve.DivisionPartiesId = COALESCE(GoodsRemains.DivisionPartiesId, 0) 
                            AND tmpReserve.DiscountExternalID = COALESCE(GoodsRemains.DiscountExternalID, 0) 
                            AND tmpReserve.NDSKindId = GoodsRemains.NDSKindId  
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.04.21                                                       * 
*/

-- тест 
SELECT * FROM gpSelect_CashGoodsIlliquid('3');