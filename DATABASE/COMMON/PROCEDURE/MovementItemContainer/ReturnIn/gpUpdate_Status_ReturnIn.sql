-- Function: gpUpdate_Status_ReturnIn()

-- DROP FUNCTION IF EXISTS gpUpdate_Status_ReturnIn (Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Status_ReturnIn (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_ReturnIn(
    IN inMovementId          Integer   , -- ���� ������� <��������>
 INOUT ioStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
    IN inStartDateSale       TDateTime , --
   OUT outMessageText        Text      ,
   OUT outMemberExpName      TVarChar  , -- ���������� �� ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
BEGIN

     CASE ioStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_ReturnIn (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            outMessageText:= (SELECT tmp.outMessageText FROM gpComplete_Movement_ReturnIn (inMovementId     := inMovementId
                                                                                         , inStartDateSale  := inStartDateSale
                                                                                         , inIsLastComplete := FALSE
                                                                                         , inSession        := inSession
                                                                                          ) AS tmp);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_ReturnIn (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', ioStatusCode;
     END CASE;

     -- ������� ������ (����� �� �� ���������)
     ioStatusCode:= (SELECT Object.ObjectCode FROM Movement INNER JOIN Object ON Object.Id = Movement.StatusId WHERE Movement.Id = inMovementId);

     -- ������� "���������� �� ������ ��������"
     outMemberExpName := COALESCE((SELECT Object_MemberExp.ValueData AS MemberExpName
                                  FROM MovementLinkObject AS MovementLinkObject_MemberExp
                                       LEFT JOIN Object AS Object_MemberExp ON Object_MemberExp.Id = MovementLinkObject_MemberExp.ObjectId
                                  WHERE MovementLinkObject_MemberExp.MovementId = inMovementId
                                    AND MovementLinkObject_MemberExp.DescId = zc_MovementLinkObject_MemberExp()
                                  ), '') :: TVarChar;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.01.14                                        	        *

*/

-- ����
-- SELECT * FROM gpUpdate_Status_ReturnIn (ioId:= 0, inSession:= zfCalc_UserAdmin())