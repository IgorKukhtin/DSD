-- Function: gpGet_Movement

DROP FUNCTION IF EXISTS gpGet_Movement (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement(
    IN inMovementId        Integer  , -- ���� ���������
   OUT outMovementId       Integer  , -- 
   OUT outDocumentKindId   Integer  , -- 
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ZakazInternal());

       SELECT Movement.Id
            , COALESCE (MovementLinkObject_DocumentKind.ObjectId, 0) AS DocumentKindId
              INTO outMovementId, outDocumentKindId
       FROM (SELECT inMovementId AS Id) AS Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_DocumentKind
                                         ON MovementLinkObject_DocumentKind.MovementId = Movement.Id
                                        AND MovementLinkObject_DocumentKind.DescId = zc_MovementLinkObject_DocumentKind();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement (Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.06.16                                        * 
*/

-- ����
-- SELECT * FROM gpGet_Movement (inMovementId:= 1, inSession:= '2')
