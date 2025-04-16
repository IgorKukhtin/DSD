-- Function: zfCalc_StatusCode_next()

DROP FUNCTION IF EXISTS zfCalc_StatusCode_next (Integer, Integer);

CREATE OR REPLACE FUNCTION zfCalc_StatusCode_next (inStatusId Integer, inStatusId_next Integer)
RETURNS Integer
AS
$BODY$
BEGIN

   IF inStatusId = zc_Enum_Status_Complete() AND inStatusId_next = zc_Enum_Status_UnComplete()
   THEN
       RETURN 1;
   ELSE
       RETURN CASE inStatusId
                   WHEN zc_Enum_Status_Complete()   THEN 2
                   WHEN zc_Enum_Status_UnComplete() THEN 4 -- 4 or 1 
                   WHEN zc_Enum_Status_Erased()     THEN 3
                   ELSE 1
              END
             ;
   END IF;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.03.25                                        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Status('2')
-- SELECT zfCalc_StatusCode_next (zc_Enum_Status_UnComplete(), zc_Enum_Status_UnComplete())
-- select zfCalc_StatusCode_next (StatusId, StatusId_next), zfCalc_StatusName_next (Object_Status.ValueData, Movement.StatusId, Movement.StatusId_next), * from Movement LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId where Movement .Id = 30990114 
