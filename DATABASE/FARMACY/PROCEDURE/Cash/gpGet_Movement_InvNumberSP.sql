DROP FUNCTION IF EXISTS gpGet_Movement_InvNumberSP (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_InvNumberSP(
    IN inSPKindId      Integer,   -- ID ����������
    IN inInvNumberSP   TVarChar,  -- ����� ����
   OUT outIsExists     Boolean,   -- ��� �����������
    IN inSession       TVarChar   -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
  vbUserId:= lpGetUserBySession (inSession);

  IF EXISTS(SELECT 1
            FROM Movement 

                 INNER JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                               ON MovementLinkObject_SPKind.MovementId = Movement.Id
                                              AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
                                              AND MovementLinkObject_SPKind.ObjectId = inSPKindId
                                              
                 INNER JOIN MovementString AS MovementString_InvNumberSP
                                           ON MovementString_InvNumberSP.MovementId = Movement.Id
                                          AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP() 
                                          AND MovementString_InvNumberSP.ValueData = inInvNumberSP

            WHERE Movement.OperDate >= DATE_TRUNC ('YEAR', CURRENT_DATE) 
              AND Movement.OperDate < DATE_TRUNC ('YEAR', CURRENT_DATE) + INTERVAL '1 YEAR'
              AND Movement.DescId = zc_Movement_Check()
            LIMIT 1)
  THEN
    outIsExists := True;  
  ELSE
    outIsExists := False;
  END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_InvNumberSP (Integer, TVarChar, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ������ �.�.
 18.04.19                                                                     * 

*/

-- ����
-- select * from gpGet_Movement_InvNumberSP(inSPKindId := 4823009 , inInvNumberSP := '0000-2M30-3K6P-481E' ,  inSession := '3');