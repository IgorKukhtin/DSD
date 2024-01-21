-- Function: zfCalc_InvNumber_two_isErased (TVarChar, TVarChar, TVarChar, TDateTime, Integer)

DROP FUNCTION IF EXISTS zfCalc_InvNumber_two_isErased (TVarChar, TVarChar, TVarChar, TDateTime, Integer);

CREATE OR REPLACE FUNCTION zfCalc_InvNumber_two_isErased (inDescName TVarChar, inInvNumber TVarChar, inInvNumber_two TVarChar, inOperDate TDateTime, inStatusId Integer)
RETURNS TVarChar
AS
$BODY$
BEGIN
      RETURN (CASE WHEN inDescName <> '' THEN '' ||inDescName||' ' ELSE '' END
           || '№ '
           || CASE WHEN inStatusId = zc_Enum_Status_UnComplete() THEN zc_InvNumber_Status_UnComlete()
                   WHEN inStatusId = zc_Enum_Status_Erased()     THEN zc_InvNumber_Status_Erased()
                   ELSE ''
              END
           ||''
           || CASE WHEN inInvNumber_two <> '' THEN inInvNumber_two ELSE '*' || COALESCE (inInvNumber, '') END
           || ' от ' || zfConvert_DateToString (inOperDate)
           || CASE WHEN inInvNumber_two <> '' THEN ' (*' || inInvNumber || ')' ELSE '' END
             );

      --RETURN (CASE WHEN inInvNumber_two <> '' THEN '(*' || inInvNumber_two || ') ' ELSE '' END
      --     || zfCalc_InvNumber_isErased (inDescName, inInvNumber, inOperDate, inStatusId)
      --       );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.05.21                                        *
*/

-- тест
-- SELECT zfCalc_InvNumber_two_isErased ('', '123', '1234', CURRENT_DATE, zc_Enum_Status_UnComplete())
