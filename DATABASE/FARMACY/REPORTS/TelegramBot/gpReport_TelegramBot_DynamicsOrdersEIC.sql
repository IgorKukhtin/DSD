-- Function: gpReport_TelegramBot_DynamicsOrdersEIC()

DROP FUNCTION IF EXISTS gpReport_TelegramBot_DynamicsOrdersEIC (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TelegramBot_DynamicsOrdersEIC(
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (OperDate TDateTime
             , CountNeBoley Integer
             , CountNeBoleyMobile Integer
             , CountTabletki Integer
             , CountLiki24 Integer
             , CountAll Integer
             , StartDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);
     
     -- ���������
     RETURN QUERY
      SELECT *
           , '09.06.2021'::TDateTime  AS StartDate
      FROM gpReport_Movement_DynamicsOrdersEIC(inStartDate := '09.06.2021', inEndDate := CURRENT_DATE - INTERVAL '1 DAY', inSession := inSession);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.06.21                                                       * 
*/

-- ����

select * FROM gpReport_TelegramBot_DynamicsOrdersEIC(inSession := '3');