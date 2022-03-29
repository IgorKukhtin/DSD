-- Function: gpUpdate_Movement_ProductionUnion_Pack (TDateTime, TDateTime, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Movement_ProductionUnion_Pack (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ProductionUnion_Pack(
    IN inStartDate    TDateTime , --
    IN inEndDate      TDateTime , --
    IN inUnitId       Integer,    -- 
    IN inSession      TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_ProductionUnion_Pack());

   IF DATE_TRUNC ('MONTH', inStartDate) < DATE_TRUNC ('MONTH', CURRENT_DATE)
      AND (EXTRACT (DAY FROM inStartDate)  / 2 - FLOOR (EXTRACT (DAY FROM inStartDate)  / 2)
        <> EXTRACT (DAY FROM CURRENT_DATE) / 2 - FLOOR (EXTRACT (DAY FROM CURRENT_DATE) / 2)
      --OR EXTRACT (DAY FROM inStartDate) < 14
          )
    --AND 1=0
   THEN
       RETURN;
   END IF;
   
/*IF inUnitId NOT IN (8451, 951601)
THEN
    RAISE EXCEPTION '������.<%>', lfGet_Object_ValueData_sh (inUnitId);
ELSE
    RETURN;
END IF;*/

   -- 
   IF EXISTS (SELECT 1
              FROM Movement
                   JOIN MovementBoolean AS MB ON MB.MovementId = Movement.Id AND MB.DescId = zc_MovementBoolean_Closed() AND MB.ValueData =  TRUE
                   INNER JOIN MovementLinkObject AS MLO_From
                                                 ON MLO_From.MovementId = Movement.Id
                                                AND MLO_From.DescId     = zc_MovementLinkObject_From()
                                                AND MLO_From.ObjectId   = inUnitId
                   INNER JOIN MovementLinkObject AS MLO_To
                                                 ON MLO_To.MovementId = Movement.Id
                                                AND MLO_To.DescId     = zc_MovementLinkObject_To()
                                                AND MLO_To.ObjectId   = inUnitId

              WHERE Movement.OperDate = inStartDate
                AND Movement.DescId   = zc_Movement_ProductionUnion()
                AND Movement.StatusId = zc_Enum_Status_UnComplete()
             )
   THEN
       RETURN;
   END IF;

   -- ��������
   PERFORM lpUpdate_Movement_ProductionUnion_Pack (inIsUpdate  := TRUE
                                                 , inStartDate := inStartDate
                                                 , inEndDate   := inEndDate
                                                 , inUnitId    := inUnitId
                                                 , inUserId    := zc_Enum_Process_Auto_Pack() -- vbUserId
                                                 );

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.07.15                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_ProductionUnion_Pack (inStartDate:= '01.10.2016', inEndDate:= '01.10.2016', inUnitId:= 8451, inSession:= zc_Enum_Process_Auto_PrimeCost() :: TVarChar) -- ��� ��������
