-- Function: gpGet_Movement_OrderClient_NPP()

DROP FUNCTION IF EXISTS gpGet_Movement_OrderClient_NPP (TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderClient_NPP(
 INOUT ioNPP           TVarChar  , -- 
 INOUT ioOperDate      TDateTime ,
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbNPP TFloat;
BEGIN

    IF zfConvert_StringToNumber (COALESCE (ioNPP, '')) = 0
    THEN
         --
         ioNPP:= (1 + COALESCE ((SELECT MAX (COALESCE (MovementFloat.ValueData, 0))
                                 FROM MovementFloat
                                      INNER JOIN Movement ON Movement.Id     = MovementFloat.MovementId
                                                         AND Movement.DescId = zc_Movement_OrderClient()
                                                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                                 WHERE MovementFloat.DescId = zc_MovementFloat_NPP()
                                ), 0) :: Integer) :: TVarChar;
         --
         ioOperDate:= CURRENT_DATE + INTERVAL '3 MONTH';
    END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.05.23                                        *
*/

-- ����
-- SELECT * FROM gpGet_Movement_OrderClient_NPP (ioNPP:= '', ioOperDate := CURRENT_DATE, inSession:= '5')
