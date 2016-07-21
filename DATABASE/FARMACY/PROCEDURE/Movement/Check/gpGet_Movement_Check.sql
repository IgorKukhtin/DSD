-- Function: gpGet_Movement_Check()

DROP FUNCTION IF EXISTS gpGet_Movement_Check (Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpGet_Movement_Check(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat, TotalSumm TFloat
             , UnitName TVarChar, CashRegisterName TVarChar, PaidKindName TVarChar, PaidTypeName TVarChar
             , CashMember TVarChar, Bayer TVarChar, FiscalCheckNumber TVarChar, NotMCS Boolean
             , DiscountCardName TVarChar
)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Check());
     vbUserId := inSession;

     RETURN QUERY
         SELECT       
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , Movement_Check.StatusCode
           , Movement_Check.StatusName
           , Movement_Check.TotalCount
           , Movement_Check.TotalSumm
           , Movement_Check.UnitName
           , Movement_Check.CashRegisterName
           , Movement_Check.PaidKindName
           , Movement_Check.PaidTypeName
           , Movement_Check.CashMember
           , Movement_Check.Bayer
           , Movement_Check.FiscalCheckNumber
           , Movement_Check.NotMCS
           , Movement_Check.DiscountCardName
        FROM Movement_Check_View AS Movement_Check
       WHERE Movement_Check.Id =  inMovementId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_Check (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.07.16         *
 23.05.15                         *                 
*/

-- ����
-- SELECT * FROM gpGet_Movement_Check (inMovementId:= 1, inSession:= '9818')