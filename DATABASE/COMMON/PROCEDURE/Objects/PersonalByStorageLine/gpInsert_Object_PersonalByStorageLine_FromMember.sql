-- Function: gpInsert_Object_PersonalByStorageLine_FromMember(TVarChar)

DROP FUNCTION IF EXISTS gpInsert_Object_PersonalByStorageLine_FromMember (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsert_Object_PersonalByStorageLine_FromMember(
    IN inMemberId            Integer ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   --
   PERFORM gpInsertUpdate_Object_PersonalByStorageLine (0::Integer, tmp.PersonalId::Integer, tmp.StorageLineId::Integer, inSession::TVarChar)
   FROM (
         WITH
         tmpPersonal AS (SELECT *
                              , ROW_NUMBER() OVER (PARTITION BY tmp.MemberId, tmp.PositionId, COALESCE (tmp.PositionLevelId,0), tmp.UnitId/*, tmp.DateIn*/ ORDER BY tmp.isMain DESC, tmp.DateIn, tmp.PersonalId ASC) AS Ord
                         FROM Object_Personal_View AS tmp
                         WHERE tmp.isErased = FALSE
                           AND (tmp.MemberId = inMemberId OR COALESCE (inMemberId,0) = 0)
                         ) 
       --для главного находим все линии производстрва
       , tmpGroup AS (SELECT tmpPersonal.PersonalId
                           , tmpPersonal_two.StorageLineId
                      FROm tmpPersonal
                           LEFT JOIN tmpPersonal AS tmpPersonal_two 
                                                 ON tmpPersonal_two.MemberId = tmpPersonal.MemberId 
                                                AND tmpPersonal_two.PositionId = tmpPersonal.PositionId
                                                AND COALESCE (tmpPersonal_two.PositionLevelId,0) = COALESCE (tmpPersonal.PositionLevelId,0)
                                                AND tmpPersonal_two.UnitId = tmpPersonal.UnitId
                                                AND tmpPersonal_two.DateIn = tmpPersonal.DateIn
                                                AND COALESCE (tmpPersonal_two.StorageLineId,0) <> 0
       
                      WHERE tmpPersonal.Ord = 1
                      )

       --уже сохраненные линии производства
       , tmpSave AS (SELECT tmp.*
                     FROM gpSelect_Object_PersonalByStorageLine (False, inSession) AS tmp
                     )

         SELECT tmpGroup.PersonalId
              , tmpGroup.StorageLineId
         FROM tmpGroup
              LEFT JOIN tmpSave ON tmpSave.PersonalId = tmpGroup.PersonalId
                               AND tmpSave.StorageLineId = tmpGroup.StorageLineId
         WHERE COALESCE (tmpGroup.StorageLineId,0) <> 0 
           AND tmpSave.PersonalId IS NULL
        ) AS tmp
        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.10.25         * 
*/