-- Function: gpGet_Movement_TechnicalRediscount_Cash_Id()

DROP FUNCTION IF EXISTS gpGet_Movement_TechnicalRediscount_Cash_Id (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_TechnicalRediscount_Cash_Id(
   OUT outMovementId       Integer  , -- ���� ���������
    IN inSession           TVarChar   -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbOperDate TDateTime;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;
   outMovementId := 0;
   
   IF vbUnitId = 0
   THEN
     RETURN;
   END IF;

   IF date_part('DAY',  CURRENT_DATE)::Integer <= 15
   THEN
       vbOperDate := date_trunc('month', CURRENT_DATE);
   ELSE
       vbOperDate := date_trunc('month', CURRENT_DATE) + INTERVAL '15 DAY';   
   END IF;

   IF EXISTS(SELECT Movement.Id
             FROM Movement 
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
             WHERE Movement.OperDate = vbOperDate
               AND Movement.DescId = zc_Movement_TechnicalRediscount()   
               AND MovementLinkObject_Unit.ObjectId = vbUnitId)
   THEN
      SELECT Movement.Id
      INTO outMovementId
      FROM Movement 
           LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
      WHERE Movement.OperDate = vbOperDate
        AND Movement.DescId = zc_Movement_TechnicalRediscount()  
        AND MovementLinkObject_Unit.ObjectId = vbUnitId;  
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TechnicalRediscount (Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.02.20                                                       *
 */

-- ����
-- SELECT * FROM gpGet_Movement_TechnicalRediscount_Cash_Id (inSession:= '3')
