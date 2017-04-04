-- Function: gpUpdateMobile_Object_Partner_GPS

DROP FUNCTION IF EXISTS gpUpdateMobile_Object_Partner_GPS (Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMobile_Object_Partner_GPS (
    IN inId      Integer  , -- ������������� �����������
    IN inGPSN    TFloat   , -- GPS ���������� ����� �������� (������)
    IN inGPSE    TFloat   , -- GPS ���������� ����� �������� (�������)
    IN inSession TVarChar   -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- ����� ����������� ��������� ��������� ������� �����������
      IF EXISTS (SELECT 1 FROM Object AS Object_Partner WHERE Object_Partner.Id = inId AND Object_Partner.DescId = zc_Object_Partner())
      THEN
           -- ��������� �������� <GPS ���������� ����� �������� (������)>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Partner_GPSN(), inId, inGPSN);
           -- ��������� �������� <GPS ���������� ����� �������� (�������)>
           PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Partner_GPSE(), inId, inGPSE);
           -- ��������� ��������
           PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
      END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 04.04.17                                                         *
*/

-- ����
-- SELECT * FROM gpUpdateMobile_Object_Partner_GPS (inId:= 261129, inGPSN:= 56, inGPSE:= 58, inSession:= zfCalc_UserAdmin())
