-- Function: gpSelect_MovementItem_IncomeHouseholdInventory()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_IncomeHouseholdInventory (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_IncomeHouseholdInventory(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, HouseholdInventoryId Integer, HouseholdInventoryCode Integer, HouseholdInventoryName TVarChar
             , InvNumber Integer, Amount TFloat, CountForPrice TFloat, Summa TFloat
             , Comment TVarChar
             , isErased Boolean)
 AS
$BODY$
    DECLARE vbUserId   Integer;
    DECLARE vbUnitId   Integer;
    DECLARE vbRetailId Integer;

BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_IncomeHouseholdInventory());
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
                   MI_Master AS (SELECT MovementItem.Id                           AS Id
                                      , MovementItem.ObjectId                     AS HouseholdInventoryId
                                      , MovementItem.Amount                       AS Amount
                                      , MIFloat_InvNumber.ValueData::Integer      AS InvNumber
                                      , MIFloat_CountForPrice.ValueData           AS CountForPrice
                                      , MIString_Comment.ValueData                AS Comment
                                      , MovementItem.isErased                     AS isErased
                                 FROM MovementItem
                                     LEFT JOIN MovementItemFloat AS MIFloat_InvNumber
                                                                 ON MIFloat_InvNumber.MovementItemId = MovementItem.Id
                                                                AND MIFloat_InvNumber.DescId = zc_MIFloat_InvNumber()

                                     LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                                 ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                                AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                                     LEFT JOIN MovementItemString AS MIString_Comment
                                                                  ON MIString_Comment.MovementItemId = MovementItem.Id
                                                                 AND MIString_Comment.DescId = zc_MIString_Comment()

                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                 ),
                   tmpData AS (SELECT MI_Master.Id                                      AS Id
                                    , MI_Master.HouseholdInventoryId                    AS HouseholdInventoryId
                                    , MI_Master.InvNumber                               AS InvNumber
                                    , MI_Master.Amount                                  AS Amount
                                    , MI_Master.CountForPrice                           AS CountForPrice
                                    , MI_Master.Comment                                 AS Comment
                                    , MI_Master.IsErased                                AS isErased
                               FROM MI_Master
                               UNION ALL
                               SELECT NULL
                                    , Object_HouseholdInventory.Id                 AS HouseholdInventoryId
                                    , NULL                                         AS InvNumber
                                    , NULL::TFloat                                 AS Amount
                                    , NULL::TFloat                                 AS CountForPrice
                                    , NULL::TVarChar                               AS Comment
                                    , Object_HouseholdInventory.isErased           AS isErased
                               FROM Object AS Object_HouseholdInventory
                               WHERE Object_HouseholdInventory.DescId = zc_Object_HouseholdInventory()
                                 AND Object_HouseholdInventory.isErased = False),
                   tmpObjectFloat AS (SELECT ObjectFloat.ObjectID
                                           , ObjectFloat.ValueData::Integer AS MovementItemId
                                      FROM ObjectFloat 
                                      WHERE ObjectFloat.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()
                                     ), 
                   tmpInvNumber AS (SELECT tmpObjectFloat.MovementItemId
                                         , Object.ObjectCode                    AS InvNumber 
                                    FROM MI_Master
                                         INNER JOIN tmpObjectFloat ON tmpObjectFloat.MovementItemId = MI_Master.ID
                                         INNER JOIN Object ON Object.ID = tmpObjectFloat.ObjectID      
                                                          AND Object.ValueData = '1'
                                   )



               SELECT MI_Master.Id                                      AS Id
                    , MI_Master.HouseholdInventoryId                    AS HouseholdInventoryId
                    , Object_HouseholdInventory.ObjectCode              AS HouseholdInventoryCode
                    , Object_HouseholdInventory.ValueData               AS HouseholdInventoryName
                    , tmpInvNumber.InvNumber                            AS InvNumber
                    , MI_Master.Amount                                  AS Amount
                    , MI_Master.CountForPrice                           AS CountForPrice
                    , Round(MI_Master.Amount * MI_Master.CountForPrice, 2)::TFloat  AS Summa 
                    , MI_Master.Comment                                 AS Comment
                    , COALESCE(MI_Master.IsErased, False)               AS isErased
               FROM tmpData AS MI_Master

                   LEFT JOIN Object AS Object_HouseholdInventory ON Object_HouseholdInventory.Id = MI_Master.HouseholdInventoryId
                   
                   LEFT JOIN tmpInvNumber ON tmpInvNumber.MovementItemId = MI_Master.Id                    

               ORDER BY MI_Master.HouseholdInventoryId, MI_Master.InvNumber
               ;

    ELSE

        -- Результат такой
        RETURN QUERY
               WITH
                   MI_Master AS (SELECT MovementItem.Id                           AS Id
                                      , MovementItem.ObjectId                     AS HouseholdInventoryId
                                      , MovementItem.Amount                       AS Amount
                                      , MIFloat_InvNumber.ValueData::Integer      AS InvNumber
                                      , MIFloat_CountForPrice.ValueData           AS CountForPrice
                                      , MIString_Comment.ValueData                AS Comment
                                      , MovementItem.isErased                     AS isErased
                                 FROM MovementItem
                                     LEFT JOIN MovementItemFloat AS MIFloat_InvNumber
                                                                 ON MIFloat_InvNumber.MovementItemId = MovementItem.Id
                                                                AND MIFloat_InvNumber.DescId = zc_MIFloat_InvNumber()

                                     LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                                 ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                                AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                                     LEFT JOIN MovementItemString AS MIString_Comment
                                                                  ON MIString_Comment.MovementItemId = MovementItem.Id
                                                                 AND MIString_Comment.DescId = zc_MIString_Comment()

                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND (MovementItem.isErased = False OR inIsErased = True)
                                 ),
                   tmpObjectFloat AS (SELECT ObjectFloat.ObjectID
                                           , ObjectFloat.ValueData::Integer AS MovementItemId
                                      FROM ObjectFloat 
                                      WHERE ObjectFloat.DescId = zc_ObjectFloat_PartionHouseholdInventory_MovementItemId()
                                   ), 
                   tmpInvNumber AS (SELECT tmpObjectFloat.MovementItemId
                                         , Object.ObjectCode                    AS InvNumber 
                                    FROM MI_Master
                                         INNER JOIN tmpObjectFloat ON tmpObjectFloat.MovementItemId = MI_Master.ID
                                         INNER JOIN Object ON Object.ID = tmpObjectFloat.ObjectID      
                                                          AND Object.ValueData = '1'
                                   )


               SELECT MI_Master.Id                                      AS Id
                    , MI_Master.HouseholdInventoryId                    AS HouseholdInventoryId
                    , Object_HouseholdInventory.ObjectCode              AS HouseholdInventoryCode
                    , Object_HouseholdInventory.ValueData               AS HouseholdInventoryName
                    , tmpInvNumber.InvNumber                            AS InvNumber
                    , MI_Master.Amount                                  AS Amount
                    , MI_Master.CountForPrice                           AS CountForPrice
                    , Round(MI_Master.Amount * MI_Master.CountForPrice, 2)::TFloat  AS Summa 
                    , MI_Master.Comment                                 AS Comment
                    , MI_Master.IsErased                                AS isErased
               FROM MI_Master

                   LEFT JOIN Object AS Object_HouseholdInventory ON Object_HouseholdInventory.Id = MI_Master.HouseholdInventoryId
                   
                   LEFT JOIN tmpInvNumber ON tmpInvNumber.MovementItemId = MI_Master.Id 

               ORDER BY MI_Master.HouseholdInventoryId, MI_Master.InvNumber

                   ;
    END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 30.07.20                                                                      *
 09.07.20                                                      *
*/
--
