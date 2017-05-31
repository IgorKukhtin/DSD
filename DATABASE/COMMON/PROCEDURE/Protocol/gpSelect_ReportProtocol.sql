-- Function: gpSelect_ReportProtocol

DROP FUNCTION IF EXISTS gpSelect_ReportProtocol (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ReportProtocol (
    IN inStartDate     TDateTime , -- 
    IN inEndDate       TDateTime , --
    IN inUserId        Integer,    -- ������������  
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer
             , UserId       Integer
             , UserName     TVarChar
             , OperDate     TDateTime
             , ProtocolData TBlob
              )
AS
$BODY$
BEGIN
      RETURN QUERY
        SELECT ReportProtocol.Id
             , ReportProtocol.UserId
             , Object.ValueData AS UserName
             , ReportProtocol.OperDate
             , ReportProtocol.ProtocolData
        FROM ReportProtocol
             LEFT JOIN Object ON Object.Id = ReportProtocol.UserId
        WHERE ReportProtocol.OperDate BETWEEN inStartDate AND inEndDate
          AND (COALESCE (inUserId, 0) = 0 OR ReportProtocol.UserId = inUserId)
        ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 31.05.17                                                        * 
*/

-- ����
-- SELECT * FROM gpSelect_ReportProtocol (inStartDate:= CURRENT_DATE, inEndDate:= CURRENT_TIMESTAMP, inUserId:= lpGetUserBySession(zfCalc_UserAdmin()), inSession:= zfCalc_UserAdmin()); 
