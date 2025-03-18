-- Function: gpGet_Object_Box_NPP - 

DROP FUNCTION IF EXISTS gpGet_Object_Box_NPP (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Box_NPP(
    IN inSession            TVarChar       -- сессия пользователя
)
RETURNS TABLE (BoxId_1   Integer
             , BoxId_2   Integer
             , BoxId_3   Integer
             , BoxId_4   Integer
             , BoxId_5   Integer
             , BoxId_6   Integer
             , BoxId_7   Integer
             , BoxId_8   Integer
             , BoxId_9   Integer
             , BoxId_10  Integer 
             , BoxName_1   TVarChar
             , BoxName_2   TVarChar
             , BoxName_3   TVarChar
             , BoxName_4   TVarChar
             , BoxName_5   TVarChar
             , BoxName_6   TVarChar
             , BoxName_7   TVarChar
             , BoxName_8   TVarChar
             , BoxName_9   TVarChar
             , BoxName_10  TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH
   --данные по таре в строку
     tmpBox AS (SELECT MAX (tmp.BoxId_1) AS BoxId_1, MAX (tmp.BoxName_1) AS BoxName_1
                     , MAX (tmp.BoxId_2) AS BoxId_2, MAX (tmp.BoxName_2) AS BoxName_2
                     , MAX (tmp.BoxId_3) AS BoxId_3, MAX (tmp.BoxName_3) AS BoxName_3
                     , MAX (tmp.BoxId_4) AS BoxId_4, MAX (tmp.BoxName_4) AS BoxName_4
                     , MAX (tmp.BoxId_5) AS BoxId_5, MAX (tmp.BoxName_5) AS BoxName_5
                     , MAX (tmp.BoxId_6) AS BoxId_6, MAX (tmp.BoxName_6) AS BoxName_6
                     , MAX (tmp.BoxId_7) AS BoxId_7, MAX (tmp.BoxName_7) AS BoxName_7
                     , MAX (tmp.BoxId_8) AS BoxId_8, MAX (tmp.BoxName_8) AS BoxName_8
                     , MAX (tmp.BoxId_9) AS BoxId_9, MAX (tmp.BoxName_9) AS BoxName_9
                     , MAX (tmp.BoxId_10) AS BoxId_10, MAX (tmp.BoxName_10) AS BoxName_10
                FROM (
                      SELECT CASE WHEN spSelect.NPP = 1 THEN spSelect.Id ELSE 0 END    AS BoxId_1
                           , CASE WHEN spSelect.NPP = 1 THEN (spSelect.Name|| CASE WHEN COALESCE (spSelect.BoxWeight,0)<>0 THEN ' ('||zfConvert_FloatToString (spSelect.BoxWeight)||' кг.)' ELSE '' END) ELSE '' END AS BoxName_1
                           , CASE WHEN spSelect.NPP = 2 THEN spSelect.Id ELSE 0 END    AS BoxId_2
                           , CASE WHEN spSelect.NPP = 2 THEN (spSelect.Name|| CASE WHEN COALESCE (spSelect.BoxWeight,0)<>0 THEN ' ('||zfConvert_FloatToString (spSelect.BoxWeight)||' кг.)' ELSE '' END) ELSE '' END AS BoxName_2
                           , CASE WHEN spSelect.NPP = 3 THEN spSelect.Id ELSE 0 END    AS BoxId_3
                           , CASE WHEN spSelect.NPP = 3 THEN (spSelect.Name||' ('||zfConvert_FloatToString (spSelect.BoxWeight)||' кг.)') ELSE '' END AS BoxName_3
                           , CASE WHEN spSelect.NPP = 4 THEN spSelect.Id ELSE 0 END    AS BoxId_4
                           , CASE WHEN spSelect.NPP = 4 THEN (spSelect.Name||' ('||zfConvert_FloatToString (spSelect.BoxWeight)||' кг.)') ELSE '' END AS BoxName_4
                           , CASE WHEN spSelect.NPP = 5 THEN spSelect.Id ELSE 0 END    AS BoxId_5
                           , CASE WHEN spSelect.NPP = 5 THEN (spSelect.Name||' ('||zfConvert_FloatToString (spSelect.BoxWeight)||' кг.)') ELSE '' END AS BoxName_5
                           , CASE WHEN spSelect.NPP = 6 THEN spSelect.Id ELSE 0 END    AS BoxId_6
                           , CASE WHEN spSelect.NPP = 6 THEN (spSelect.Name||' ('||zfConvert_FloatToString (spSelect.BoxWeight)||' кг.)') ELSE '' END AS BoxName_6
                           , CASE WHEN spSelect.NPP = 7 THEN spSelect.Id ELSE 0 END    AS BoxId_7
                           , CASE WHEN spSelect.NPP = 7 THEN (spSelect.Name||' ('||zfConvert_FloatToString (spSelect.BoxWeight)||' кг.)') ELSE '' END AS BoxName_7
                           , CASE WHEN spSelect.NPP = 8 THEN spSelect.Id ELSE 0 END    AS BoxId_8
                           , CASE WHEN spSelect.NPP = 8 THEN (spSelect.Name||' ('||zfConvert_FloatToString (spSelect.BoxWeight)||' кг.)') ELSE '' END AS BoxName_8
                           , CASE WHEN spSelect.NPP = 9 THEN spSelect.Id ELSE 0 END    AS BoxId_9
                           , CASE WHEN spSelect.NPP = 9 THEN (spSelect.Name||' ('||zfConvert_FloatToString (spSelect.BoxWeight)||' кг.)') ELSE '' END AS BoxName_9
                           , CASE WHEN spSelect.NPP = 10 THEN spSelect.Id ELSE 0 END    AS BoxId_10
                           , CASE WHEN spSelect.NPP = 10 THEN (spSelect.Name||' ('||zfConvert_FloatToString (spSelect.BoxWeight)||' кг.)') ELSE '' END AS BoxName_10

                      FROM gpSelect_Object_Box (inSession) AS spSelect
                      ) AS tmp
                )

          --РЕЗУЛЬТАТ
          SELECT tmpBox.BoxId_1     ::Integer
               , tmpBox.BoxId_2     ::Integer
               , tmpBox.BoxId_3     ::Integer
               , tmpBox.BoxId_4     ::Integer
               , tmpBox.BoxId_5     ::Integer
               , tmpBox.BoxId_6     ::Integer
               , tmpBox.BoxId_7     ::Integer
               , tmpBox.BoxId_8     ::Integer
               , tmpBox.BoxId_9     ::Integer
               , tmpBox.BoxId_10    ::Integer

               , tmpBox.BoxName_1 ::TVarChar, tmpBox.BoxName_2 ::TVarChar, tmpBox.BoxName_3 ::TVarChar, tmpBox.BoxName_4 ::TVarChar, tmpBox.BoxName_5 ::TVarChar
               , tmpBox.BoxName_6 ::TVarChar, tmpBox.BoxName_7 ::TVarChar, tmpBox.BoxName_8 ::TVarChar, tmpBox.BoxName_9 ::TVarChar, tmpBox.BoxName_10 ::TVarChar

          FROM tmpBox
          ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.02.25         *
*/

-- тест
-- SELECT * FROM gpGet_Object_Box_NPP (inSession := '5');
