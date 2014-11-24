-- Function: gpReport_Account ()

DROP FUNCTION IF EXISTS gpReport_AccountExternal (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_AccountExternal (
    IN inStartDate              TDateTime ,  
    IN inEndDate                TDateTime ,
    IN inAccountId              Integer ,
    IN inSession                TVarChar    -- ������ ������������
)
RETURNS TABLE  (InvNumber Integer, OperDate TDateTime
              , CLIENTCODE Integer, CLIENTINN TVarChar, CLIENTOKPO TVarChar, CLIENTNAME TVarChar
              , SUMA TFloat, PDV TFloat, SUMAPDV TFloat
              , OperDatePartner TDateTime, InvNumberPartner TVarChar, Comment TVarChar
              )  
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Report_Account());
     vbUserId:= lpGetUserBySession (inSession);
  
    RETURN QUERY

    SELECT Report_Account.InvNumber, Report_Account.OperDate  
         , Report_Account.ObjectCode_Direction, ObjectHistory_JuridicalDetails_ViewByDate.INN
         , ObjectHistory_JuridicalDetails_ViewByDate.OKPO, Report_Account.ObjectName_Direction
         , (Report_Account.SummOut/1.2)::TFloat, (Report_Account.SummOut - Report_Account.SummOut/1.2)::TFloat, Report_Account.SummOut

         , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
         , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
         , MIString_Comment.ValueData                AS Comment

    FROM 
      lpReport_Account(inStartDate := inStartDate, inEndDate := inEndDate
                     , inAccountGroupId := 0, inAccountDirectionId := 0, inInfoMoneyId := 0
                     , inAccountId := 9179, inBusinessId := 0, inProfitLossGroupId := 0, inProfitLossDirectionId := 0
                     , inProfitLossId := 0, inBranchId := 0,  inUserId := vbUserId, inIsMovement := TRUE) AS Report_Account
             JOIN ObjectHistory_JuridicalDetails_ViewByDate ON ObjectHistory_JuridicalDetails_ViewByDate.JuridicalId = Report_Account.ObjectId_Direction
              AND ObjectHistory_JuridicalDetails_ViewByDate.EndDate = zc_DateEnd()

            LEFT JOIN MovementItem ON MovementItem.MovementId = Report_Account.MovementId

            LEFT JOIN MovementItemString AS MIString_Comment 
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Report_Account.MovementId
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Report_Account.MovementId
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

    WHERE COALESCE(Report_Account.SummOut, 0) <> 0;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_AccountExternal (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 15.09.14                          * 
*/

-- ����
-- SELECT * FROM gpReport_AccountExternal (inStartDate:= '01.09.2014', inEndDate:= '30.09.2014', inAccountId:= 0, inSession:= zfCalc_UserAdmin());
