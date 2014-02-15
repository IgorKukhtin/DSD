-- Function: gpSelect_Movement_ExchangeCurrency()

-- DROP FUNCTION gpSelect_Movement_ExchangeCurrency (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ExchangeCurrency(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountFrom TFloat, AmountTo TFloat
             , FromId Integer, FromName TVarChar
             , ToId Integer, ToName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
              )
AS
$BODY$
BEGIN

-- inStartDate:= '01.01.2013';
-- inEndDate:= '01.01.2100';

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ExchangeCurrency());

     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
           
           , MovementFloat_AmountFrom.ValueData AS AmountFrom
           , MovementFloat_AmountTo.ValueData   AS AmountTo

           , Object_From.Id               AS FromId
           , Object_From.ValueData        AS FromName
           , Object_To.Id                 AS ToId
           , Object_To.ValueData          AS ToName

           , Object_InfoMoney.Id          AS InfoMoneyId
           , Object_InfoMoney.ValueData   AS InfoMoneyName
           
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId


            LEFT JOIN MovementFloat AS MovementFloat_AmountFrom
                                    ON MovementFloat_AmountFrom.MovementId =  Movement.Id
                                   AND MovementFloat_AmountFrom.DescId = zc_MovementFloat_AmountFrom()

            LEFT JOIN MovementFloat AS MovementFloat_AmountTo
                                    ON MovementFloat_AmountTo.MovementId =  Movement.Id
                                   AND MovementFloat_AmountTo.DescId = zc_MovementFloat_AmountTo()
                                   
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent ON ObjectLink_Unit_Parent.ObjectId = Object_To.Id AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_InfoMoney
                                         ON MovementLinkObject_InfoMoney.MovementId = Movement.Id
                                        AND MovementLinkObject_InfoMoney.DescId = zc_MovementLinkObject_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = MovementLinkObject_InfoMoney.ObjectId
            
       WHERE Movement.DescId = zc_Movement_ExchangeCurrency()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate;
  
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_ExchangeCurrency (TDateTime, TDateTime, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
               
 12.08.13         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_ExchangeCurrency (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= '2')
