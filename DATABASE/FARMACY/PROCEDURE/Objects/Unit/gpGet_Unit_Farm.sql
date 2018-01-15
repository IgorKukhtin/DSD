-- Function: gpGet_Unit_Farm()

DROP FUNCTION IF EXISTS gpGet_Unit_Farm (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Unit_Farm(
    IN inUnitId        Integer  ,  -- �������������
    IN inIsFarm        Boolean,    -- 
   OUT outUnitId       Integer  ,  -- �������������
   OUT outUnitName     TVarChar ,  -- �������������
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ ��������!!!
     IF inIsFarm = TRUE THEN vbUnitId:= zfConvert_StringToNumber (COALESCE (lpGet_DefaultValue ('zc_Object_Unit', vbUserId), ''));
     END IF;
     
     IF COALESCE (vbUnitId, 0) = 0 THEN vbUnitId:= inUnitId; END IF;

     SELECT Id, ValueData INTO outUnitId, outUnitName FROM Object WHERE Id = COALESCE (vbUnitId, inUnitId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.01.17         *
 09.02.17                        *
*/

-- ����
-- SELECT * FROM gpGet_Unit_Farm (inUnitId:= 0, inIsFarm:= TRUE, inSession:= '3')
--select * from gpGet_Unit_Farm(inUnitId := 472116 , inIsFarm := 'True' ,  inSession := '183242');