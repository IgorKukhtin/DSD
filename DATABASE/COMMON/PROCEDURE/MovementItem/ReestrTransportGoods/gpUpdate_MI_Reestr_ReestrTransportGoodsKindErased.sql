-- Function: gpUpdate_MI_Reestr_ReestrTransportGoodsKindErased()

DROP FUNCTION IF EXISTS gpUpdate_MI_ReestrTransportGoods_ReestrKindErased (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ReestrTransportGoods_ReestrKindErased(
    IN inId                   Integer   , -- �� ������ �������
    IN inReestrKindId         Integer   , -- ��� ��������� �� �������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbReestrKindId Integer;
   DECLARE vbId_miReturn Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReestrTransportGoods());
     

    -- ���� ������ ������� � ����� ��� �������
    vbId_miReturn:= (SELECT MF_MovementItemId.MovementId AS MIID_Return
                   FROM MovementFloat AS MF_MovementItemId 
                   WHERE MF_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                     AND MF_MovementItemId.ValueData ::integer = inId
                   );

    IF inReestrKindId = zc_Enum_ReestrKind_TransferIn() THEN 
       -- ��������� <����� ������������ ���� "�������� �� ������">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_TransferIn(), inId, Null);
    END IF;
  
    IF inReestrKindId = zc_Enum_ReestrKind_PartnerIn() THEN 
       -- ��������� <����� ������������ ���� "�������� �� �������">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_PartnerIn(), inId, Null);
       -- ��������� ����� � <��� ����������� ���� "�������� �� �������">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartnerInTo(), inId, Null);
    END IF;

    IF inReestrKindId = zc_Enum_ReestrKind_Buh() THEN 
       -- ��������� <����� ������������ ���� "�����������">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Buh(), inId, Null);
       -- ��������� ����� � <��� ����������� ���� "�����������">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Buh(), inId, Null);
    END IF;

    -- ������� ���������� �������� <��������� �� �������> ��������� �������
    vbReestrKindId := (SELECT CASE WHEN tmp.DescId = zc_MIDate_PartnerIn() THEN zc_Enum_ReestrKind_PartnerIn()
                                   WHEN tmp.DescId = zc_MIDate_TransferIn() THEN zc_Enum_ReestrKind_TransferIn()
                                   WHEN tmp.DescId = zc_MIDate_Buh()       THEN zc_Enum_ReestrKind_Buh()
                              END 
                       FROM (SELECT ROW_NUMBER() OVER(ORDER BY MID.ValueData desc) AS Num, MID.DescId 
                             FROM MovementItemDate AS MID
                             WHERE MID.MovementItemId = inId
                               AND MID.DescId IN (zc_MIDate_TransferIn(), zc_MIDate_PartnerIn(), zc_MIDate_Buh())
                               AND MID.ValueData IS NOT NULL
                       ) AS tmp
                       WHERE tmp.Num = 1);


    -- �������� <��������� �� �������> � ��������� �������� �� ����������
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbId_miReturn, COALESCE (vbReestrKindId, zc_Enum_ReestrKind_TransferIn()));

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.02.20         *
*/

-- ����
-- SELECT * FROM gpUpdate_MI_Reestr_ReestrKindErased (inBarCode := '4323306' , inOperDate := ('23.10.2016')::TDateTime , inCarId := 340655 , inPersonalDriverId := 0 , inMemberId := 0 , inDocumentId_Transport := 2298218 ,  inSession := '5');
