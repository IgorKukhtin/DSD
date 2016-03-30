-- Function: gpUpdate_Status_TaxCorrective()

DROP FUNCTION IF EXISTS gpUpdate_Status_TaxCorrective (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Status_TaxCorrective(
    IN inMovementId          Integer   , -- ���� ������� <��������>
 INOUT ioStatusCode          Integer   , -- ������ ���������. ������������ ������� ������ ����
   OUT outMessageText        Text      ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
BEGIN
     CASE ioStatusCode
         WHEN zc_Enum_StatusCode_UnComplete() THEN
            PERFORM gpUnComplete_Movement_TaxCorrective (inMovementId, inSession);
         WHEN zc_Enum_StatusCode_Complete() THEN
            outMessageText:= (SELECT tmp.outMessageText FROM gpComplete_Movement_TaxCorrective (inMovementId, inSession) AS tmp);
         WHEN zc_Enum_StatusCode_Erased() THEN
            PERFORM gpSetErased_Movement_TaxCorrective (inMovementId, inSession);
         ELSE
            RAISE EXCEPTION '��� ������� � ����� <%>', ioStatusCode;
     END CASE;

     -- ������� ������ (����� �� �� ���������)
     ioStatusCode:= (SELECT Object.ObjectCode FROM Movement INNER JOIN Object ON Object.Id = Movement.StatusId WHERE Movement.Id = inMovementId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 14.02.14                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_Status_TaxCorrective (ioId:= 0, inSession:= zfCalc_UserAdmin())
