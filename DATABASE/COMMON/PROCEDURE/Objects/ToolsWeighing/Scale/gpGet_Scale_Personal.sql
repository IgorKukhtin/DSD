-- Function: gpGet_Scale_Personal()

DROP FUNCTION IF EXISTS gpGet_Scale_Personal (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Scale_Personal(
    IN inPersonalCode   Integer     ,
    IN inOperDate       TDateTime    ,
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (PersonalId     Integer
             , PersonalCode   Integer
             , PersonalName   TVarChar
             , PositionId     Integer
             , PositionCode   Integer
             , PositionName   TVarChar
              )
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpGetUserBySession (inSession);


    -- ���������
    RETURN QUERY

       SELECT tmp.PersonalId
            , tmp.PersonalCode
            , tmp.PersonalName
            , tmp.PositionId
            , tmp.PositionCode
            , tmp.PositionName
       FROM gpSelect_Scale_Personal (inSession:= inSession) AS tmp
       WHERE tmp.PersonalCode = inPersonalCode
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Scale_Personal (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.05.15                                        *
*/

-- ����
-- SELECT * FROM gpGet_Scale_Personal (inPersonalCode:= 1, inOperDate:= NULL, inSession:= zfCalc_UserAdmin())
