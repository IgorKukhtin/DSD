-- Function: gpGet_OlapSoldReportBusiness (TVarChar)

DROP FUNCTION IF EXISTS gpGet_OlapSoldReportBusiness (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OlapSoldReportBusiness(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (BusinessId Integer, BusinessName TVarChar)
AS
$BODY$
  DECLARE vbUserId     Integer;
  DECLARE vbBusinessId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);
     
     IF vbUserId = 1058530 -- ����� �.�.
        --OR vbUserId = 5
     THEN
         vbBusinessId:= 8371; -- ����
     END IF;


     -- ���������
     RETURN QUERY 
       SELECT Object_Business.Id        AS BusinessId
            , Object_Business.ValueData AS BusinessName
       FROM Object AS Object_Business
       WHERE Object_Business.Id = vbBusinessId;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.04.22                                        * all
*/

-- ����
-- SELECT * FROM gpGet_OlapSoldReportBusiness (zfCalc_UserAdmin())
-- SELECT * FROM gpGet_OlapSoldReportBusiness ('1058530')
