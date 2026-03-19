-- Function: gpSelect_Object_EmployeesTT_effie

DROP FUNCTION IF EXISTS gpSelect_Object_EmployeesTT_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_EmployeesTT_effie(
    IN inSession              TVarChar    -- сессия пользователя
)

---zc_ObjectLink_Partner_Personal union zc_ObjectLink_Partner_PersonalTrade union zc_ObjectLink_Partner_PersonalMerch
--zc_Object_Member.Id - НЕ ВСЕ СОТРУДНИКИ!!! - только zc_ObjectBoolean_User_ProjectMobile = TRUE

RETURNS TABLE (employeeExtId    TVarChar   -- Идентификатор сотрудника
             , ttExtId          TVarChar   -- Идентификатор торговой точки
             , isDeleted        Integer    -- Признак активности
) AS

$BODY$
   DECLARE vbUserId Integer;
 BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);


     --
     RETURN QUERY
     WITH 
     tmpPartner AS (-- если vbPersonalId - Сотрудник (торговый)
                    SELECT OL.ObjectId AS PartnerId
                    FROM ObjectLink AS OL
                    WHERE OL.ChildObjectId > 0
                      AND OL.DescId        = zc_ObjectLink_Partner_PersonalTrade()
                   UNION
                    -- если vbPersonalId - Сотрудник (супервайзер)
                    SELECT OL.ObjectId AS PartnerId
                    FROM ObjectLink AS OL
                    WHERE OL.ChildObjectId > 0
                      AND OL.DescId        = zc_ObjectLink_Partner_Personal()
                   UNION
                    -- если vbPersonalId - Сотрудник (мерчандайзер)
                    SELECT OL.ObjectId AS PartnerId
                    FROM ObjectLink AS OL
                    WHERE OL.ChildObjectId > 0
                      AND OL.DescId        = zc_ObjectLink_Partner_PersonalMerch()
                    ) 
      --
   , tmpPartner_TT AS (SELECT DISTINCT
                              ObjectLink_Partner_Street.ChildObjectId                     AS StreetId
                            , COALESCE (ObjectString_HouseNumber.ValueData,'') ::TVarChar AS HouseNumber
                            , COALESCE (ObjectString_CaseNumber.ValueData,'')  ::TVarChar AS CaseNumber
                            , COALESCE (ObjectString_RoomNumber.ValueData,'')  ::TVarChar AS RoomNumber
                            
                            , ObjectLink_Partner_Personal.ObjectId                        AS PersonalId
                       FROM Object AS Object_Partner
                           INNER JOIN tmpPartner ON tmpPartner.PartnerId = Object_Partner.Id

                           LEFT JOIN ObjectLink AS ObjectLink_Partner_Street
                                                ON ObjectLink_Partner_Street.ObjectId = Object_Partner.Id
                                               AND ObjectLink_Partner_Street.DescId = zc_ObjectLink_Partner_Street()

                           LEFT JOIN ObjectString AS ObjectString_HouseNumber
                                                  ON ObjectString_HouseNumber.ObjectId = Object_Partner.Id
                                                 AND ObjectString_HouseNumber.DescId = zc_ObjectString_Partner_HouseNumber()          

                           LEFT JOIN ObjectString AS ObjectString_CaseNumber
                                                  ON ObjectString_CaseNumber.ObjectId = Object_Partner.Id
                                                 AND ObjectString_CaseNumber.DescId = zc_ObjectString_Partner_CaseNumber()

                           LEFT JOIN ObjectString AS ObjectString_RoomNumber
                                                  ON ObjectString_RoomNumber.ObjectId = Object_Partner.Id
                                                 AND ObjectString_RoomNumber.DescId = zc_ObjectString_Partner_RoomNumber()

                           LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                                                ON ObjectLink_Partner_Personal.ObjectId = Object_Partner.Id
                                               AND ObjectLink_Partner_Personal.DescId IN (zc_ObjectLink_Partner_Personal()
                                                                                        , zc_ObjectLink_Partner_PersonalTrade()
                                                                                        , zc_ObjectLink_Partner_PersonalMerch()
                                                                                         )

                           INNER JOIN ObjectLink AS ObjectLink_Personal_Member
                                                 ON ObjectLink_Personal_Member.ObjectId = ObjectLink_Partner_Personal.ChildObjectId
                                                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
                                                AND ObjectLink_Personal_Member.ChildObjectId  > 0
                           INNER JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_Personal_Member.ChildObjectId
                                                             AND Object_Member.isErased = FALSE

                           LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                                ON ObjectLink_User_Member.ChildObjectId = ObjectLink_Personal_Member.ChildObjectId
                                               AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()

                           INNER JOIN ObjectBoolean AS ObjectBoolean_ProjectMobile
                                                    ON ObjectBoolean_ProjectMobile.ObjectId = ObjectLink_User_Member.ObjectId
                                                   AND ObjectBoolean_ProjectMobile.DescId = zc_ObjectBoolean_User_ProjectMobile()
                                                   AND COALESCE (ObjectBoolean_ProjectMobile.ValueData, FALSE) = TRUE

                       WHERE Object_Partner.DescId   = zc_Object_Partner()
                        AND Object_Partner.isErased = FALSE
                       )
     --
     SELECT DISTINCT 
            tmpPartner_TT.PersonalId   ::TVarChar AS employeeExtId
          , Object_TT_effie.Id         ::TVarChar AS ttExtId
          , 0                          ::Integer  AS isDeleted
     FROM tmpPartner_TT
          INNER JOIN Object_TT_effie ON Object_TT_effie.StreetId   = tmpPartner_TT.StreetId
                                    AND Object_TT_effie.HouseNumber= tmpPartner_TT.HouseNumber
                                    AND Object_TT_effie.CaseNumber = tmpPartner_TT.CaseNumber 
                                    AND Object_TT_effie.RoomNumber = tmpPartner_TT.RoomNumber
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.03.26         *
 16.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_EmployeesTT_effie (zfCalc_UserAdmin()::TVarChar);