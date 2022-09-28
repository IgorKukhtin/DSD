-- Function: gpGet_Object_User_InternshipCompleted()

DROP FUNCTION IF EXISTS gpGet_Object_User_InternshipCompleted (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_User_InternshipCompleted(
   OUT isInternshipConfirmation Boolean  ,     -- ���������� �������������
    IN inSession                TVarChar       -- ������ ������������
)
RETURNS Boolean AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   IF EXISTS (SELECT * FROM ObjectBoolean AS ObjectBoolean_InternshipCompleted
              WHERE ObjectBoolean_InternshipCompleted.ObjectId = vbUserId
                AND ObjectBoolean_InternshipCompleted.DescId = zc_ObjectBoolean_User_InternshipCompleted()
                AND ObjectBoolean_InternshipCompleted.ValueData = TRUE)
      AND
      COALESCE ((SELECT ObjectFloat_InternshipConfirmation.ValueData
                 FROM ObjectFloat AS ObjectFloat_InternshipConfirmation
                 WHERE ObjectFloat_InternshipConfirmation.ObjectId = vbUserId
                   AND ObjectFloat_InternshipConfirmation.DescId = zc_ObjectFloat_User_InternshipConfirmation()), 0) = 0
   THEN
     isInternshipConfirmation := True;
   ELSE
     isInternshipConfirmation := False;   
   END IF;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_User (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.09.22                                                       *
*/

-- ����
-- 
select * from gpGet_Object_User_InternshipCompleted(inSession := '3');