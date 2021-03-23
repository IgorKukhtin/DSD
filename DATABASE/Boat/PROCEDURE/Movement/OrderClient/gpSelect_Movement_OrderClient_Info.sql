-- Function: gpSelect_Movement_OrderClient_Info()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderClient_Info (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderClient_Info(
    IN inMovementId        Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , CodeInfo Integer, Text_Info TBlob
             
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderClient());
     vbUserId := inSession;

     
      RETURN QUERY

        SELECT 
            Movement_OrderClient.Id
          , Movement_OrderClient.InvNumber
          , 1 ::Integer AS CodeInfo
          , COALESCE (MovementBlob_Info.ValueData,'') :: TBlob AS Text_Info

        FROM Movement AS Movement_OrderClient 
            LEFT JOIN MovementBlob AS MovementBlob_Info
                                   ON MovementBlob_Info.MovementId = Movement_OrderClient.Id
                                  AND MovementBlob_Info.DescId = zc_MovementBlob_Info1()
        WHERE Movement_OrderClient.Id = inMovementId
          AND Movement_OrderClient.DescId = zc_Movement_OrderClient()
          --AND COALESCE (MovementBlob_Info.ValueData,'') <> ''
      UNION 
        SELECT 
            Movement_OrderClient.Id
          , Movement_OrderClient.InvNumber
          , 2 ::Integer AS CodeInfo
          , COALESCE (MovementBlob_Info.ValueData,'') :: TBlob AS Text_Info

        FROM Movement AS Movement_OrderClient 
            LEFT JOIN MovementBlob AS MovementBlob_Info
                                   ON MovementBlob_Info.MovementId = Movement_OrderClient.Id
                                  AND MovementBlob_Info.DescId = zc_MovementBlob_Info2()
        WHERE Movement_OrderClient.Id = inMovementId
          AND Movement_OrderClient.DescId = zc_Movement_OrderClient()
          --AND COALESCE (MovementBlob_Info.ValueData,'') <> ''
      UNION 
        SELECT 
            Movement_OrderClient.Id
          , Movement_OrderClient.InvNumber
          , 3 ::Integer AS CodeInfo
          , COALESCE (MovementBlob_Info.ValueData,'') :: TBlob AS Text_Info

        FROM Movement AS Movement_OrderClient 
            LEFT JOIN MovementBlob AS MovementBlob_Info
                                   ON MovementBlob_Info.MovementId = Movement_OrderClient.Id
                                  AND MovementBlob_Info.DescId = zc_MovementBlob_Info3()
        WHERE Movement_OrderClient.Id = inMovementId
          AND Movement_OrderClient.DescId = zc_Movement_OrderClient()
          --AND COALESCE (MovementBlob_Info.ValueData,'') <> ''

          ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.02.21         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_OrderClient_Info (inMovementId:= 75, inSession:= '5')