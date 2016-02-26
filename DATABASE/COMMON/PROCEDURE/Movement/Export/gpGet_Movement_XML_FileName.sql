-- Function: gpGet_Movement_XML_FileName()

DROP FUNCTION IF EXISTS gpGet_Movement_XML_FileName (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_XML_FileName(
   OUT outFileName            TVarChar  ,
    IN inMovementId           Integer   ,
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_XML_Mida());
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     outFileName:=
    (SELECT 'Alan'
          || '_' || COALESCE (ObjectString_GLNCode.ValueData, '')
          || '_' || REPLACE (zfConvert_DateShortToString (MovementDate_OperDatePartner.ValueData), '.', '')
          || '_' || Movement.InvNumber
     FROM Movement
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN ObjectString AS ObjectString_GLNCode
                                 ON ObjectString_GLNCode.ObjectId = MovementLinkObject_To.ObjectId
                                AND ObjectString_GLNCode.DescId = zc_ObjectString_Partner_GLNCode()
     WHERE Movement.Id = inMovementId)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.02.16                                        *
*/

-- ����
-- SELECT * FROM gpGet_Movement_XML_FileName (inMovementId:= 3229861, inSession:= zfCalc_UserAdmin())
