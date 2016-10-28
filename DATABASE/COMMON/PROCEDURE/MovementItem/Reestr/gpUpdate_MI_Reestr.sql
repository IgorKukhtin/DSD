-- Function: gpUpdate_MI_Reestr()

DROP FUNCTION IF EXISTS gpUpdate_MI_Reestr (TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Reestr(
    IN inBarCode              TVarChar  , -- �������� ��������� ������� 
    IN inReestrKindId         Integer   , -- ��� ��������� �� �������
    IN inMemberId             Integer   , -- ���������� ����(��������/����������) ��� ���� �������� ��� ����
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMIId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Reestr());
     
    IF COALESCE (inBarCode, '') = '' THEN 
	Return;
    END IF;

    -- ���� ������ ������� � ����� ��� �������
    vbMIId:= (SELECT MF_MovementItemId.ValueData ::integer AS Id
              FROM MovementFloat AS MF_MovementItemId 
              WHERE MF_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                AND MF_MovementItemId.MovementId = CAST (inBarCode AS integer) --saleid
              );

    IF inReestrKindId = zc_Enum_ReestrKind_PartnerIn() THEN 
       -- ��������� <����� ������������ ���� "�������� �� �������">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartnerIn(), vbMIId, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ���� "�������� �� �������">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartnerInTo(), vbMIId, vbUserId);
       -- ��������� ����� � <��� ���� �������� ��� ���� "�������� �� �������">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartnerInFrom(), vbMIId, inMemberId);

       -- �������� <��������� �� �������> � ��������� �������
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), CAST (inBarCode AS integer), inReestrKindId);
    END IF;
  
    IF inReestrKindId = zc_Enum_ReestrKind_RemakeIn() THEN 
       -- ��������� <����� ������������ ���� "�������� ��� ���������">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_RemakeIn(), vbMIId, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ���� "�������� ��� ���������">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RemakeInTo(), vbMIId, vbUserId);
       -- ��������� ����� � <��� ���� �������� ��� ���� "�������� ��� ���������">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RemakeInFrom(), vbMIId, inMemberId);

       -- �������� <��������� �� �������> � ��������� �������
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), CAST (inBarCode AS integer), inReestrKindId);
    END IF;
    
    IF inReestrKindId = zc_Enum_ReestrKind_RemakeBuh() THEN 
       -- ��������� <����� ������������ ���� "���������� ��� �����������">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_RemakeBuh(), vbMIId, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ���� "���������� ��� �����������">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_RemakeBuh(), vbMIId, vbUserId);

       -- �������� <��������� �� �������> � ��������� �������
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), CAST (inBarCode AS integer), inReestrKindId);
    END IF;

    IF inReestrKindId = zc_Enum_ReestrKind_Remake() THEN 
       -- ��������� <����� ������������ ���� "�������� ���������">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Remake(), vbMIId, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ���� "�������� ���������">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Remake(), vbMIId, vbUserId);

       -- �������� <��������� �� �������> � ��������� �������
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), CAST (inBarCode AS integer), inReestrKindId);
    END IF;

    IF inReestrKindId = zc_Enum_ReestrKind_Buh() THEN 
       -- ��������� <����� ������������ ���� "�����������">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Buh(), vbMIId, CURRENT_TIMESTAMP);
       -- ��������� ����� � <��� ����������� ���� "�����������">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Buh(), vbMIId, vbUserId);

       -- �������� <��������� �� �������> � ��������� �������
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), CAST (inBarCode AS integer), inReestrKindId);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 23.10.16         *
*/

-- ����
----RAISE EXCEPTION '������.%, %', outId, vbMIId;
--select * from gpUpdate_MI_Reestr(inBarCode := '4323306' , inOperDate := ('23.10.2016')::TDateTime , inCarId := 340655 , inPersonalDriverId := 0 , inMemberId := 0 , inDocumentId_Transport := 2298218 ,  inSession := '5');