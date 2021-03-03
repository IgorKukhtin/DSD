-- Function: gpSelect_Farmak_CRMPharmacy()

DROP FUNCTION IF EXISTS gpSelect_Farmak_CRMPharmacy(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Farmak_CRMPharmacy(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (PharmacyId Integer, CompanyId TVarChar, PharmacyName TVarChar, PharmacyAddress TVarChar
             , PharmacistId Integer, PharmacistName TVarChar) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());

   RETURN QUERY
   WITH tmpUser AS (SELECT DISTINCT MovementItem.ObjectId   AS UserID
                                  , MILinkObject_Unit.ObjectId AS UnitID
                    FROM  MovementItem
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                           ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                    WHERE MovementItem.MovementId = (SELECT MAX(Movement.Id)
                                                     FROM Movement
                                                     WHERE Movement.OperDate < date_trunc('month', CURRENT_DATE)
                                                       AND Movement.DescId = zc_Movement_Wages())
                      AND MovementItem.DescId = zc_MI_Master()
                      AND MovementItem.isErased = False)
   
      , tmpMember AS (SELECT DISTINCT COALESCE(tmpUser.UnitID, Member.UnitID) AS UnitID, Member.Code, Member.Name
                      FROM gpSelect_Object_Member(inIsShowAll := 'False', inSession := inSession) AS Member

                           INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                 ON ObjectLink_User_Member.ChildObjectId = Member.Id
                                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

                           INNER JOIN ObjectBoolean AS ObjectBoolean_Site
                                                    ON ObjectBoolean_Site.ObjectId = ObjectLink_User_Member.ObjectId
                                                   AND ObjectBoolean_Site.DescId = zc_ObjectBoolean_User_Site()
                                                   AND ObjectBoolean_Site.ValueData = True
                           INNER JOIN Object AS Object_User ON Object_User.Id = ObjectLink_User_Member.ObjectId
                                                           AND Object_User.isErased = False
                           INNER JOIN tmpUser ON tmpUser.UserID = Object_User.Id)

       SELECT
             Object_Unit_View.Code
           , ''::TVarChar AS CompanyId
           , Object_Unit_View.Name
           , ObjectString_Unit_Address.ValueData
           , tmpMember.Code
           , tmpMember.Name
       FROM Object_Unit_View
            INNER JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit_View.Id
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
            INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                  ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                 AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                 AND ObjectLink_Juridical_Retail.ChildObjectId = 4
            INNER JOIN ObjectString AS ObjectString_Unit_Address
                                    ON ObjectString_Unit_Address.ObjectId  = Object_Unit_View.Id
                                   AND ObjectString_Unit_Address.DescId = zc_ObjectString_Unit_Address()

            LEFT JOIN tmpMember ON tmpMember.UnitID = Object_Unit_View.Id


       WHERE Object_Unit_View.isErased = False
         AND Object_Unit_View.Name NOT ILIKE '%закрыта%'
         AND COALESCE (ObjectString_Unit_Address.ValueData, '') <> ''
         AND Object_Unit_View.Id <> 11460971
       ORDER BY Object_Unit_View.Id;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.03.21                                                       *
*/

-- тест
-- 154
SELECT * FROM gpSelect_Farmak_CRMPharmacy ('3')