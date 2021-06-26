-- Function: gpSelect_Movement_Loss_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Loss_Print (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Loss_Print(
    IN inMovementId                 Integer  , -- ���� ���������
    IN inSession                    TVarChar    -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Loss());
    vbUserId:= inSession;

OPEN Cursor1 FOR

        SELECT 
            Movement_Loss.Id         AS Id
          , Movement_Loss.InvNumber  AS InvNumber
          , Movement_Loss.OperDate   AS OperDate
          , Object_From.Id           AS FromId
          , Object_From.ValueData    AS FromName
          , Object_To.Id             AS ToId      
          , Object_To.ValueData      AS ToName
          , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment

        FROM Movement AS Movement_Loss 
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement_Loss.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId 

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement_Loss.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement_Loss.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

        WHERE Movement_Loss.Id = inMovementId
          AND Movement_Loss.DescId = zc_Movement_Loss();

    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR
      SELECT
             MovementItem.*
       FROM MovementItem
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.isErased   = false;

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.06.21         *
*/
-- ����
--select * from gpSelect_Movement_Loss_Print(inMovementId := 3897397 ,  inSession := '3');
