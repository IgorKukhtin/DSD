-- Function: gpUpdate_ScaleCeh_Movement_Status()

DROP FUNCTION IF EXISTS gpUpdate_ScaleCeh_Movement_Status (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_ScaleCeh_Movement_Status(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inStatusId            Integer   , --
    IN inBranchCode          Integer   , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement_check());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� <�����������> �� ������.';
     END IF;

     -- ��������
     IF inBranchCode <> 101 OR NOT EXISTS (SELECT 1 FROM Object_Unit_Scale_upak_View)
     THEN
         RAISE EXCEPTION '������.��� ���� % �������� <%>.<%>'
                        , CASE WHEN inStatusId = zc_Enum_Status_Complete() THEN '���������' ELSE '������������' END
                        , (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId)
                        , inBranchCode
         ;
     END IF;
     -- ��������
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Send())
     THEN
         RAISE EXCEPTION '������.��� ���� % �������� <%>.'
                        , CASE WHEN inStatusId = zc_Enum_Status_Complete() THEN '���������' ELSE '������������' END
                        , (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId)
         ;
     END IF;
     -- ��������
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.OperDate >= CURRENT_DATE - INTERVAL '1 DAY')
     THEN
         RAISE EXCEPTION '������.��� ���� % �������� �� <%>.'
                        , CASE WHEN inStatusId = zc_Enum_Status_Complete() THEN '���������' ELSE '������������' END
                        , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
         ;
     END IF;
     -- ��������
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = inStatusId)
     THEN
         RAISE EXCEPTION '������.�������� ��� � ������� <%>.'
                        , lfGet_Object_ValueData_sh (inStatusId)
         ;
     END IF;
     -- ��������
     IF NOT EXISTS (SELECT 1
                    FROM Movement
                         INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                                      AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                                      AND MovementLinkObject_From.ObjectId   = 8459 -- ����������� ��������

                         INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                                      AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                      AND MovementLinkObject_To.ObjectId   = 8451 -- ��� ��������
                    WHERE Movement.Id = inMovementId
                   )
     THEN
         RAISE EXCEPTION '������.��� ���� % �������� <%> �� ���� = <%> ���� = <%>.'
                        , CASE WHEN inStatusId = zc_Enum_Status_Complete() THEN '���������' ELSE '������������' END
                        , (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId)
                        , (SELECT Object_From.ValueData
                           FROM Movement
                                INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                              ON MovementLinkObject_From.MovementId = Movement.Id
                                                             AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                           WHERE Movement.Id = inMovementId
                          )
                        , (SELECT Object_To.ValueData
                           FROM Movement
                                INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = Movement.Id
                                                             AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
                           WHERE Movement.Id = inMovementId
                          )
         ;
     END IF;


     -- ���������
     IF inStatusId = zc_Enum_Status_Complete()
     THEN
         -- �������� ��������
         PERFORM gpComplete_Movement_Send (inMovementId     := inMovementId
                                         , inIsLastComplete := NULL
                                         , inSession        := inSession
                                          );
     ELSE
         -- ����������� �������� !!!������������!!!
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId
                                       );
     END IF;

     -- ��������
     IF 1=1 AND vbUserId = 5
     THEN
         RAISE EXCEPTION '������.Test Admin - ok.';
     END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 26.06.18                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_ScaleCeh_Movement_Status (inMovementId:= 1, inStatusId:=zc_Enum_Status_Complete(), inBranchCode:= 101, inSession:= '5')
