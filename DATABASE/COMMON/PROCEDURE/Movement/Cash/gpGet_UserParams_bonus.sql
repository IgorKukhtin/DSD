-- Function: gpGet_UserParams_bonus()

DROP FUNCTION IF EXISTS gpGet_UserParams_bonus (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_UserParams_bonus(
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE(CashId integer, CashName TVarChar
            , BranchId integer, BranchName TVarChar)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCashId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���� ����� ��� ��������
     vbCashId := 14462;

     RETURN QUERY
     SELECT Object_Cash.Id          AS CashId
          , Object_Cash.ValueData   AS CashName
          , Object_Branch.Id        AS BranchId
          , Object_Branch.ValueData AS BranchName 
     FROM Object AS Object_Cash
          LEFT JOIN ObjectLink AS OL_Cash_Branch
                               ON OL_Cash_Branch.ObjectId = Object_Cash.Id
                              AND OL_Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
          LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = OL_Cash_Branch.ChildObjectId
     WHERE Object_Cash.Id = vbCashId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.08.20         *

*/

-- ����
-- SELECT * FROM gpGet_UserParams_bonus (inSession:= '2'::TVarChar)