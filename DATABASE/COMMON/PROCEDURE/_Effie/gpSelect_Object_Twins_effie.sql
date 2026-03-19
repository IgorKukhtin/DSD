-- Function: gpSelect_Object_Twins_effie

DROP FUNCTION IF EXISTS gpSelect_Object_Twins_effie ( TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Twins_effie(
    IN inSession              TVarChar    -- сессия пользователя
)

RETURNS TABLE (ttExtId          TVarChar   -- Идентификатор торговой точки
             , clientExtId      TVarChar   -- Идентификатор контрагента.
             , IsDefaultClient  Boolean    -- Контрагент по умолчанию
             , isDeleted        Boolean    -- Признак активности
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
   , tmpPartner_TT AS (SELECT Object_Partner.Id                                           AS PartnerId
                            , ObjectLink_Partner_Street.ChildObjectId                     AS StreetId
                            , COALESCE (ObjectString_HouseNumber.ValueData,'') ::TVarChar AS HouseNumber
                            , COALESCE (ObjectString_CaseNumber.ValueData,'')  ::TVarChar AS CaseNumber
                            , COALESCE (ObjectString_RoomNumber.ValueData,'')  ::TVarChar AS RoomNumber

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

                       WHERE Object_Partner.DescId   = zc_Object_Partner()
                        AND Object_Partner.isErased = FALSE
                       )
   --
   SELECT tmp.ttExtId     ::TVarChar AS ttExtId
        , tmp.PartnerId   ::TVarChar AS clientExtId
        , CASE WHEN tmp.Ord = 1 THEN TRUE ELSE FALSE END ::Boolean AS IsDefaultClient
        , FALSE           ::Boolean AS isDeleted
   FROM (SELECT tmpPartner_TT.PartnerId  AS PartnerId
              , Object_TT_effie.Id       AS ttExtId
              , ROW_NUMBER() OVER (PARTITION BY Object_TT_effie.Id ORDER BY tmpPartner_TT.PartnerId DESC) AS Ord
         FROM tmpPartner_TT
              LEFT JOIN Object_TT_effie ON Object_TT_effie.StreetId   = tmpPartner_TT.StreetId
                                       AND Object_TT_effie.HouseNumber= tmpPartner_TT.HouseNumber
                                       AND Object_TT_effie.CaseNumber = tmpPartner_TT.CaseNumber 
                                       AND Object_TT_effie.RoomNumber = tmpPartner_TT.RoomNumber
         ) AS tmp
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.03.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Twins_effie (zfCalc_UserAdmin()::TVarChar);