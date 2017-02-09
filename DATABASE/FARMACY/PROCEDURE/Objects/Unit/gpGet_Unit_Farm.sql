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
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ ��������!!!
     IF inIsFarm = TRUE THEN inUnitId:= zfConvert_StringToNumber (COALESCE (lpGet_DefaultValue ('zc_Object_Unit', vbUserId), ''));
     END IF;

     SELECT Id, ValueData INTO outUnitId, outUnitName FROM Object WHERE Id = inUnitId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.02.17                        *
*/

-- ����
-- SELECT * FROM gpGet_Unit_Farm (inUnitId:= 0, inIsFarm:= TRUE, inSession:= '3')
