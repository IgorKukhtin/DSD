-- Function: gpSelect_MovementItem_ComputerAccessoriesRegister()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ComputerAccessoriesRegister (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ComputerAccessoriesRegister(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ComputerAccessoriesId Integer, ComputerAccessoriesCode Integer, ComputerAccessoriesName TVarChar
             , InvNumber Integer, Amount TFloat, ReplacementDate TDateTime
             , Comment TVarChar
             , Color_calc Integer
             , isErased Boolean)
 AS
$BODY$
    DECLARE vbUserId   Integer;
    DECLARE vbUnitId   Integer;
    DECLARE vbRetailId Integer;

BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_ComputerAccessoriesRegister());
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
                                      , MovementItem.ObjectId                     AS ComputerAccessoriesId
                                      , MovementItem.Amount                       AS Amount
                                      , MIFloat_InvNumber.ValueData::Integer      AS InvNumber
                                      , MIDate_ReplacementDate.ValueData          AS ReplacementDate
                                      , MIString_Comment.ValueData                AS Comment
                                      , CASE WHEN MIDate_ReplacementDate.ValueData < (CURRENT_DATE + INTERVAL '1 YEAR') THEN zc_Color_Red() ELSE zc_Color_Greenl() END                         AS Color_calc
                                      , MovementItem.isErased                     AS isErased
                                 FROM MovementItem
                                     LEFT JOIN MovementItemFloat AS MIFloat_InvNumber
                                                                 ON MIFloat_InvNumber.MovementItemId = MovementItem.Id
                                                                AND MIFloat_InvNumber.DescId = zc_MIFloat_InvNumber()

                                     LEFT JOIN MovementItemDate AS MIDate_ReplacementDate
                                                                ON MIDate_ReplacementDate.MovementItemId = MovementItem.Id
                                                               AND MIDate_ReplacementDate.DescId = zc_MIDate_ReplacementDate()

                                     LEFT JOIN MovementItemString AS MIString_Comment
                                                                  ON MIString_Comment.MovementItemId = MovementItem.Id
                                                                 AND MIString_Comment.DescId = zc_MIString_Comment()

                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                 ),
                   tmpData AS (SELECT MI_Master.Id                                      AS Id
                                    , MI_Master.ComputerAccessoriesId                   AS ComputerAccessoriesId
                                    , MI_Master.InvNumber                               AS InvNumber
                                    , MI_Master.Amount                                  AS Amount
                                    , MI_Master.ReplacementDate                         AS ReplacementDate
                                    , MI_Master.Comment                                 AS Comment
                                    , MI_Master.Color_calc                              AS Color_calc
                                    , MI_Master.IsErased                                AS isErased
                               FROM MI_Master
                               UNION ALL
                               SELECT NULL
                                    , Object_ComputerAccessories.Id                AS ComputerAccessoriesId
                                    , NULL                                         AS InvNumber
                                    , NULL::TFloat                                 AS Amount
                                    , NULL::TDateTime                              AS ReplacementDate
                                    , NULL::TVarChar                               AS Comment
                                    , zc_Color_White()                             AS Color_calc
                                    , Object_ComputerAccessories.isErased          AS isErased
                               FROM Object AS Object_ComputerAccessories
                               WHERE Object_ComputerAccessories.DescId = zc_Object_ComputerAccessories()
                                 AND Object_ComputerAccessories.isErased = False)


               SELECT MI_Master.Id                                      AS Id
                    , MI_Master.ComputerAccessoriesId                   AS ComputerAccessoriesId
                    , Object_ComputerAccessories.ObjectCode             AS ComputerAccessoriesCode
                    , Object_ComputerAccessories.ValueData              AS ComputerAccessoriesName
                    , MI_Master.InvNumber                               AS InvNumber
                    , MI_Master.Amount                                  AS Amount
                    , MI_Master.ReplacementDate                         AS ReplacementDate
                    , MI_Master.Comment                                 AS Comment
                    , MI_Master.Color_calc                              AS Color_calc
                    , COALESCE(MI_Master.IsErased, False)               AS isErased
               FROM tmpData AS MI_Master

                   LEFT JOIN Object AS Object_ComputerAccessories ON Object_ComputerAccessories.Id = MI_Master.ComputerAccessoriesId

               ORDER BY MI_Master.ComputerAccessoriesId, MI_Master.InvNumber
               ;

    ELSE

        -- Результат такой
        RETURN QUERY
               WITH
                   MI_Master AS (SELECT MovementItem.Id                           AS Id
                                      , MovementItem.ObjectId                     AS ComputerAccessoriesId
                                      , MovementItem.Amount                       AS Amount
                                      , MIFloat_InvNumber.ValueData::Integer      AS InvNumber
                                      , MIDate_ReplacementDate.ValueData          AS ReplacementDate
                                      , MIString_Comment.ValueData                AS Comment
                                      , CASE WHEN MIDate_ReplacementDate.ValueData < (CURRENT_DATE + INTERVAL '1 YEAR') THEN zc_Color_Red() ELSE zc_Color_Greenl() END                         AS Color_calc
                                      , MovementItem.isErased                     AS isErased
                                 FROM MovementItem
                                     LEFT JOIN MovementItemFloat AS MIFloat_InvNumber
                                                                 ON MIFloat_InvNumber.MovementItemId = MovementItem.Id
                                                                AND MIFloat_InvNumber.DescId = zc_MIFloat_InvNumber()

                                     LEFT JOIN MovementItemDate AS MIDate_ReplacementDate
                                                                ON MIDate_ReplacementDate.MovementItemId = MovementItem.Id
                                                               AND MIDate_ReplacementDate.DescId = zc_MIDate_ReplacementDate()

                                     LEFT JOIN MovementItemString AS MIString_Comment
                                                                  ON MIString_Comment.MovementItemId = MovementItem.Id
                                                                 AND MIString_Comment.DescId = zc_MIString_Comment()

                                 WHERE MovementItem.MovementId = inMovementId
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND (MovementItem.isErased = False OR inIsErased = True)
                                 )


               SELECT MI_Master.Id                                      AS Id
                    , MI_Master.ComputerAccessoriesId                   AS ComputerAccessoriesId
                    , Object_ComputerAccessories.ObjectCode             AS ComputerAccessoriesCode
                    , Object_ComputerAccessories.ValueData              AS ComputerAccessoriesName
                    , MI_Master.InvNumber                               AS InvNumber
                    , MI_Master.Amount                                  AS Amount
                    , MI_Master.ReplacementDate                         AS ReplacementDate
                    , MI_Master.Comment                                 AS Comment
                    , MI_Master.Color_calc                              AS Color_calc
                    , MI_Master.IsErased                                AS isErased
               FROM MI_Master

                   LEFT JOIN Object AS Object_ComputerAccessories ON Object_ComputerAccessories.Id = MI_Master.ComputerAccessoriesId

               ORDER BY MI_Master.ComputerAccessoriesId, MI_Master.InvNumber

                   ;
    END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 14.07.20                                                      *
*/
--
select * from gpSelect_MovementItem_ComputerAccessoriesRegister(inMovementId := 19530660 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');