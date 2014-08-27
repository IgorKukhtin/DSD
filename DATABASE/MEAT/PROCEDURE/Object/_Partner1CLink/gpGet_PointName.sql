-- Function: gpGet_PointName()

DROP FUNCTION IF EXISTS gpGet_PointName (Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_PointName(
    IN    inCode          Integer  , -- ���� ���������    
    INOUT ioName          TVarChar , -- 
    IN    inBranchId      INTEGER  , 
    IN    inSession          TVarChar   -- ������ ������������
)
RETURNS TVarChar
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_Cash());
     vbUserId := lpGetUserBySession (inSession);
 
     IF ioName = '' THEN 
     	SELECT MIN(ClientName) INTO ioName 
     	       FROM Sale1C 
     	      WHERE Sale1C.ClientCode = inCode AND zfGetBranchLinkFromBranchPaidKind(zfGetBranchFromUnitId (Sale1C.UnitId), zfGetPaidKindFrom1CType(Sale1C.VidDoc)) = inBranchId;
     END IF;

  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_PointName (Integer, TVarChar, Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 20.08.14                        * 
 15.04.14                        * 
*/

-- ����
-- SELECT * FROM gpGet_Movement_Cash (inMovementId:= 1, inSession:= zfCalc_UserAdmin());
