-- Function: gpSelect_MovementItem_WriteOffHouseholdInventory()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_WriteOffHouseholdInventory (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_WriteOffHouseholdInventory(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, PartionHouseholdInventoryId Integer
             , HouseholdInventoryId Integer, HouseholdInventoryCode Integer, HouseholdInventoryName TVarChar
             , InvNumber Integer, Remains TFloat, Amount TFloat, CountForPrice TFloat
             , Comment TVarChar
             , isErased Boolean)
 AS
$BODY$
    DECLARE vbUserId   Integer;
    DECLARE vbUnitId   Integer;
    DECLARE vbRetailId Integer;

BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_WriteOffHouseholdInventory());
    vbUserId:= lpGetUserBySession (inSession);

    vbUnitId := (SELECT MovementLinkObject_Unit.ObjectId
                 FROM MovementLinkObject AS MovementLinkObject_Unit
                 WHERE MovementLinkObject_Unit.MovementId = inMovementId
                   AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                );


    vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                   FROM ObjectLink AS ObjectLink_Unit_Juridical
                        INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                              ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                             AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                   WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                     AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());

    IF inShowAll = TRUE
    THEN

        -- Результат такой
        -- Результат такой
        RETURN QUERY
               WITH
                   MI_Master AS (SELECT MovementItem.Id                             AS Id
                                      , MovementItem.ObjectId                       AS PartionHouseholdInventoryId
                                      , MI_Income.ObjectId                          AS HouseholdInventoryId
                                      , MovementItem.Amount                         AS Amount
                                      , Object_PartionHouseholdInventory.ObjectCode AS InvNumber
                                      , MIFloat_CountForPrice.ValueData             AS CountForPrice
                                      , MIString_Comment.ValueData                  AS Comment
                                      , MovementItem.isErased                       AS isErased
                                 FROM MovementItem

                                      LEFT JOIN Object AS Object_PartionHouseholdInventory ON Object_PartionHouseholdInventory.Id = MovementItem.ObjectId

                                      LEFT JOIN ObjectFloat AS PHI_MovementItemId
                                                            ON PHI_MovementItemId.ObjectId = MovementItem.ObjectId
                                                           AND PHI_MovementItemId.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()

                                      LEFT JOIN MovementItem AS MI_Income ON MI_Income.ID = PHI_MovementItemId.ValueData::Integer

                                      LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                                  ON MIFloat_CountForPrice.MovementItemId = MI_Income.ID
                                                                 AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                                      LEFT JOIN MovementItemString AS MIString_Comment
                                                                   ON MIString_Comment.MovementItemId = MovementItem.Id
                                                                  AND MIString_Comment.DescId = zc_MIString_Comment()

                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                 ),
                   tmpRemains AS (SELECT Object_PHI.Id                          AS Id
                                       , Object_PHI.ObjectCode                  AS InvNumber

                                       , PHI_MovementItemId.ValueData::Integer  AS MovementItemId
                                       , ObjectLink_PHI_Unit.ChildObjectId      AS UnitID

                                       , MovementItem.ObjectId                  AS HouseholdInventoryId
                                       , MovementItem.Amount                    AS Amount
                                       , MovementItem.MovementID                AS MovementID
                                       , MIFloat_CountForPrice.ValueData        AS CountForPrice

                                       , Object_PHI.isErased                    AS isErased

                                  FROM Object AS Object_PHI

                                       LEFT JOIN ObjectFloat AS PHI_MovementItemId
                                                             ON PHI_MovementItemId.ObjectId = Object_PHI.Id
                                                            AND PHI_MovementItemId.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()

                                       LEFT JOIN ObjectLink AS ObjectLink_PHI_Unit
                                                            ON ObjectLink_PHI_Unit.ObjectId = Object_PHI.Id
                                                           AND ObjectLink_PHI_Unit.DescId = zc_ObjectLink_PartionHouseholdInventory_Unit()

                                       LEFT JOIN MovementItem ON MovementItem.Id = PHI_MovementItemId.ValueData::Integer

                                       LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                                   ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                                  AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                                  WHERE Object_PHI.DescId = zc_Object_PartionHouseholdInventory()
                                    AND COALESCE (PHI_MovementItemId.ValueData, 0) <> 0
                                    AND ObjectLink_PHI_Unit.ChildObjectId = vbUnitId
                                    AND MovementItem.Amount > 0)


               SELECT MI_Master.Id                                                                AS Id
                    , COALESCE(tmpRemains.Id, MI_Master.PartionHouseholdInventoryId)              AS PartionHouseholdInventoryId
                    , COALESCE(tmpRemains.HouseholdInventoryId, MI_Master.HouseholdInventoryId)   AS HouseholdInventoryId
                    , Object_HouseholdInventory.ObjectCode                                        AS HouseholdInventoryCode
                    , Object_HouseholdInventory.ValueData                                         AS HouseholdInventoryName
                    , COALESCE(tmpRemains.InvNumber, MI_Master.InvNumber)                         AS InvNumber
                    , tmpRemains.Amount                                                           AS Remains
                    , MI_Master.Amount                                                            AS Amount
                    , COALESCE(tmpRemains.CountForPrice, MI_Master.CountForPrice)                 AS CountForPrice
                    , MI_Master.Comment                                                           AS Comment
                    , COALESCE(MI_Master.IsErased, False)                                         AS isErased
               FROM tmpRemains

                    FULL JOIN MI_Master ON MI_Master.InvNumber = tmpRemains.InvNumber

                    LEFT JOIN Object AS Object_HouseholdInventory ON Object_HouseholdInventory.Id = COALESCE(tmpRemains.HouseholdInventoryId, MI_Master.HouseholdInventoryId)

               ORDER BY MI_Master.HouseholdInventoryId, MI_Master.InvNumber
               ;

    ELSE

        -- Результат такой
        RETURN QUERY
               WITH
                   MI_Master AS (SELECT MovementItem.Id                             AS Id
                                      , MovementItem.ObjectId                       AS PartionHouseholdInventoryId
                                      , MI_Income.ObjectId                          AS HouseholdInventoryId
                                      , MovementItem.Amount                         AS Amount
                                      , Object_PartionHouseholdInventory.ObjectCode AS InvNumber
                                      , MIFloat_CountForPrice.ValueData             AS CountForPrice
                                      , MIString_Comment.ValueData                  AS Comment
                                      , MovementItem.isErased                       AS isErased
                                 FROM MovementItem

                                      LEFT JOIN Object AS Object_PartionHouseholdInventory ON Object_PartionHouseholdInventory.Id = MovementItem.ObjectId

                                      LEFT JOIN ObjectFloat AS PHI_MovementItemId
                                                            ON PHI_MovementItemId.ObjectId = MovementItem.ObjectId
                                                           AND PHI_MovementItemId.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()

                                      LEFT JOIN MovementItem AS MI_Income ON MI_Income.ID = PHI_MovementItemId.ValueData::Integer

                                      LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                                  ON MIFloat_CountForPrice.MovementItemId = MI_Income.ID
                                                                 AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                                      LEFT JOIN MovementItemString AS MIString_Comment
                                                                   ON MIString_Comment.MovementItemId = MovementItem.Id
                                                                  AND MIString_Comment.DescId = zc_MIString_Comment()

                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND (MovementItem.isErased = False OR inIsErased = True)
                                 ),
                   tmpRemains AS (SELECT Object_PHI.Id                          AS Id
                                       , Object_PHI.ObjectCode                  AS InvNumber

                                       , PHI_MovementItemId.ValueData::Integer  AS MovementItemId
                                       , ObjectLink_PHI_Unit.ChildObjectId      AS UnitID

                                       , MovementItem.ObjectId                  AS HouseholdInventoryId
                                       , MovementItem.Amount                    AS Amount
                                       , MovementItem.MovementID                AS MovementID
                                       , MIFloat_CountForPrice.ValueData        AS CountForPrice

                                       , Object_PHI.isErased                    AS isErased

                                  FROM Object AS Object_PHI

                                       LEFT JOIN ObjectFloat AS PHI_MovementItemId
                                                             ON PHI_MovementItemId.ObjectId = Object_PHI.Id
                                                            AND PHI_MovementItemId.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()

                                       LEFT JOIN ObjectLink AS ObjectLink_PHI_Unit
                                                            ON ObjectLink_PHI_Unit.ObjectId = Object_PHI.Id
                                                           AND ObjectLink_PHI_Unit.DescId = zc_ObjectLink_PartionHouseholdInventory_Unit()

                                       LEFT JOIN MovementItem ON MovementItem.Id = PHI_MovementItemId.ValueData::Integer

                                       LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                                   ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                                  AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                                  WHERE Object_PHI.DescId = zc_Object_PartionHouseholdInventory()
                                    AND COALESCE (PHI_MovementItemId.ValueData, 0) <> 0
                                    AND ObjectLink_PHI_Unit.ChildObjectId = vbUnitId
                                    AND MovementItem.Amount > 0)

               SELECT MI_Master.Id                                      AS Id
                    , MI_Master.PartionHouseholdInventoryId             AS PartionHouseholdInventoryId
                    , MI_Master.HouseholdInventoryId                    AS HouseholdInventoryId
                    , Object_HouseholdInventory.ObjectCode              AS HouseholdInventoryCode
                    , Object_HouseholdInventory.ValueData               AS HouseholdInventoryName
                    , MI_Master.InvNumber                               AS InvNumber
                    , tmpRemains.Amount                                 AS Remains
                    , MI_Master.Amount                                  AS Amount
                    , MI_Master.CountForPrice                           AS CountForPrice
                    , MI_Master.Comment                                 AS Comment
                    , MI_Master.IsErased                                AS isErased
               FROM MI_Master

                   LEFT JOIN Object AS Object_HouseholdInventory ON Object_HouseholdInventory.Id = MI_Master.HouseholdInventoryId

                   LEFT JOIN tmpRemains ON MI_Master.InvNumber = tmpRemains.InvNumber

               ORDER BY MI_Master.HouseholdInventoryId, MI_Master.InvNumber

                   ;
    END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 09.07.20                                                      *
*/
-- select * from gpSelect_MovementItem_WriteOffHouseholdInventory(inMovementId := 19480115 , inShowAll := 'TRUE' , inIsErased := 'False' ,  inSession := '3');
