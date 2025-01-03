-- Function: gpSelect_Protocol()

DROP FUNCTION IF EXISTS gpSelect_MovementItemProtocol (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItemProtocol(
    IN inStartDate           TDateTime , --
    IN inEndDate             TDateTime , --
    IN inUserId              Integer,    -- ������������
    IN inMovementItemId      Integer,    -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TABLE (OperDate TDateTime, ProtocolData Text, UserName TVarChar, MovementItemId Integer)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItemProtocol());
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������
     IF COALESCE (inMovementItemId, 0) = 0 THEN
        --RAISE EXCEPTION '������.�������� ��������� ����������.';
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.�������� ��������� ����������.' :: TVarChar
                                              , inProcedureName := 'gpSelect_Protocol' :: TVarChar
                                              , inUserId        := inUserId
                                              );
     END IF;

     IF lpGetUnit_byUser (vbUserId) > 0 THEN
        --RAISE EXCEPTION '������.�������� ��������� ����������.';
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.�������� ��������� ����������.' :: TVarChar
                                              , inProcedureName := 'gpSelect_Protocol' :: TVarChar
                                              , inUserId        := inUserId
                                              );
     END IF;


     IF inMovementItemId <> 0
     THEN
          -- ���������
          RETURN QUERY
            -- real-1
            SELECT
               MovementItemProtocol.OperDate,
               MovementItemProtocol.ProtocolData::Text,
               Object_User.ValueData AS UserName,
               MovementItemProtocol.MovementItemId
            FROM MovementItemProtocol
                 JOIN Object AS Object_User ON Object_User.Id = MovementItemProtocol.UserId
            WHERE MovementItemProtocol.MovementItemId = inMovementItemId
           ;
     ELSE
         --RAISE EXCEPTION '������.�������� ��������� ����������.';
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������.�������� ��������� ����������.' :: TVarChar
                                              , inProcedureName := 'gpSelect_Protocol' :: TVarChar
                                              , inUserId        := inUserId
                                              );
     END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.01.15         *
 14.02.14                         *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItemProtocol (inStartDate:= NULL, inEndDate:= NULL, inUserId:= NULL, inMovementItemId:= 1, inSession:= '5');
