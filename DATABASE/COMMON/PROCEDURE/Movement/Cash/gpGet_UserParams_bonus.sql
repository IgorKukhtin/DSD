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
   DECLARE vbCashId_Dnepr Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
     vbUserId:= lpGetUserBySession (inSession);

     -- �� ��������� �����
     vbCashId_Dnepr := 14462;

     RETURN QUERY
     
     WITH tmpPersonal AS (SELECT View_Personal.MemberId
                               , MAX (View_Personal.BranchId)   AS BranchId
                          FROM Object_Personal_View AS View_Personal
                          WHERE View_Personal.isErased = FALSE
                          GROUP BY View_Personal.MemberId
                         )

          SELECT Object_Cash.Id          AS CashId
               , Object_Cash.ValueData   AS CashName
               , Object_Branch.Id        AS BranchId
               , Object_Branch.ValueData AS BranchName
          FROM ObjectLink AS ObjectLink_User_Member
               LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
              
               LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = COALESCE (tmpPersonal.BranchId, zc_Branch_Basis())

               LEFT JOIN ObjectLink AS Cash_Branch
                                    ON Cash_Branch.ChildObjectId = Object_Branch.Id
                                   AND Cash_Branch.DescId = zc_ObjectLink_Cash_Branch()
               LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = CASE WHEN COALESCE (tmpPersonal.BranchId,0) = 0 THEN vbCashId_Dnepr ELSE Cash_Branch.ObjectId END
          
          WHERE ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
            AND ObjectLink_User_Member.ObjectId = vbUserId
          LIMIT 1 --  
     ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.08.20         *

*/

-- ����
-- SELECT * FROM gpGet_UserParams_bonus (inSession:= '5567897'::TVarChar)