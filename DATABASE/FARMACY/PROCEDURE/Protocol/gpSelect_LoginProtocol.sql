-- Function: gpSelect_LoginProtocol()

DROP FUNCTION IF EXISTS gpSelect_LoginProtocol (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_LoginProtocol(
    IN inStartDate     TDateTime , -- 
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (OperDate TDateTime
             , UserId Integer, UserCode Integer, UserName TVarChar
             )
AS
$BODY$
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

  RETURN QUERY 
  SELECT LoginProtocol.OperDate,  LoginProtocol.UserId, Object_User.ObjectCode, Object_User.ValueData
  FROM LoginProtocol 

       LEFT JOIN Object AS Object_User ON Object_User.ID = LoginProtocol.UserId

  WHERE LoginProtocol.OperDate >= inStartDate 
    AND LoginProtocol.OperDate < inEndDate + INTERVAL '1 DAY'
    AND LoginProtocol.ProtocolData ILIKE '%FieldValue = "Farmacy"%'
  ORDER BY LoginProtocol.OperDate;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_LoginProtocol (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.03.22                                                       *
*/

-- ����
-- 
SELECT * FROM gpSelect_LoginProtocol (inStartDate:= '23.03.2022', inEndDate:= '23.03.2022', inSession:= '3'); 