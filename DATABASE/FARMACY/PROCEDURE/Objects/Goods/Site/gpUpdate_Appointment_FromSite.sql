-- Function: gpUpdate_Appointment_FromSite()

DROP FUNCTION IF EXISTS gpUpdate_Appointment_FromSite (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Appointment_FromSite(
    IN inAppointmentCode     Integer   ,    -- ���������� ���������
    IN inAppointmentName     TVarChar  ,    -- ���������� ���������
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbApoitmentId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);


    -- ��� ����������� ����
    IF inAppointmentCode <> 0
    THEN
        -- ����� �� ����
        vbApoitmentId:= (SELECT Id FROM Object WHERE DescId = zc_Object_Appointment() AND ObjectCode = inAppointmentCode);
        -- ��������/�������� - ������
        vbApoitmentId:= lpInsertUpdate_Object (vbApoitmentId, zc_Object_Appointment(), inAppointmentCode, inAppointmentName);

        -- ��������� ��������
        PERFORM lpInsert_ObjectProtocol (vbApoitmentId, vbUserId);

    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 07.04.16                                        *
*/
