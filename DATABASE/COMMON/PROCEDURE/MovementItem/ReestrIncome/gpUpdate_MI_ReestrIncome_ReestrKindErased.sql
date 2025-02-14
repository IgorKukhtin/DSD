-- Function: gpUpdate_MI_ReestrIncome_ReestrKindErased()

DROP FUNCTION IF EXISTS gpUpdate_MI_ReestrIncome_ReestrKindErased (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ReestrIncome_ReestrKindErased(
    IN inId                   Integer   , -- �� ������ �������
    IN inReestrKindId         Integer   , -- ��� ��������� �� �������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbReestrKindId Integer;
   DECLARE vbId_miIncome Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ReestrIncome());
     

    -- ���� ������ ������� � ����� ��� �������
    vbId_miIncome:= (SELECT MF_MovementItemId.MovementId AS MIID_Income
                     FROM MovementFloat AS MF_MovementItemId 
                     WHERE MF_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                       AND MF_MovementItemId.ValueData ::integer = inId
                    );

    IF inReestrKindId = zc_Enum_ReestrKind_EconomIn() THEN 
       -- ��������� <����� ������������ ���� ����������(� ������)">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_EconomIn(), inId, Null);
       -- ��������� ����� � <��� ����������� ���� "����������(� ������)"">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_EconomIn(), inId, Null);
    END IF;

    IF inReestrKindId = zc_Enum_ReestrKind_EconomOut() THEN 
       -- ��������� <����� ������������ ���� "����������(��� ���������)">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_EconomOut(), inId, Null);
       -- ��������� ����� � <��� ����������� ���� "����������(��� ���������)">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_EconomOut(), inId, Null);
    END IF;

    IF inReestrKindId = zc_Enum_ReestrKind_Snab() THEN 
       -- ��������� <����� ������������ ���� "��������� (� ������)">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Snab(), inId, Null);
       -- ��������� ����� � <��� ����������� ���� "��������� (� ������)">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Snab(), inId, Null);
    END IF;
    
    IF inReestrKindId = zc_Enum_ReestrKind_SnabRe() THEN 
       -- ��������� <����� ������������ ���� "��������� (��� ���������)">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_SnabRe(), inId, Null);
       -- ��������� ����� � <��� ����������� ���� "��������� (��� ���������)">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_SnabRe(), inId, Null);
    END IF;

    IF inReestrKindId = zc_Enum_ReestrKind_Remake() THEN 
       -- ��������� <����� ������������ ���� "�������� ���������">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Remake(), inId, Null);
       -- ��������� ����� � <��� ����������� ���� "�������� ���������">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Remake(), inId, Null);
    END IF;

    IF inReestrKindId = zc_Enum_ReestrKind_Econom() THEN 
       -- ��������� <����� ������������ ���� "����������">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Econom(), inId, Null);
       -- ��������� ����� � <��� ����������� ���� "����������">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Econom(), inId, Null);
    END IF;

    IF inReestrKindId = zc_Enum_ReestrKind_Buh() THEN 
       -- ��������� <����� ������������ ���� "�����������">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Buh(), inId, Null);
       -- ��������� ����� � <��� ����������� ���� "�����������">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Buh(), inId, Null);
    END IF;

    IF inReestrKindId = zc_Enum_ReestrKind_inBuh() THEN 
       -- ��������� <����� ������������ ���� "����������� � ������">   
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_inBuh(), inId, Null);
       -- ��������� ����� � <��� ����������� ���� "����������� � ������">
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_inBuh(), inId, Null);
    END IF;
    
    -- ������� ���������� �������� <��������� �� �������> ��������� �������
    vbReestrKindId := (SELECT CASE WHEN tmp.DescId = zc_MIDate_EconomIn()    THEN zc_Enum_ReestrKind_EconomIn()
                                   WHEN tmp.DescId = zc_MIDate_EconomOut()   THEN zc_Enum_ReestrKind_EconomOut()
                                   WHEN tmp.DescId = zc_MIDate_Snab()        THEN zc_Enum_ReestrKind_Snab()
                                   WHEN tmp.DescId = zc_MIDate_SnabRe()      THEN zc_Enum_ReestrKind_SnabRe()
                                   WHEN tmp.DescId = zc_MIDate_Remake()      THEN zc_Enum_ReestrKind_Remake()
                                   WHEN tmp.DescId = zc_MIDate_Econom()      THEN zc_Enum_ReestrKind_Econom()
                                   WHEN tmp.DescId = zc_MIDate_Buh()         THEN zc_Enum_ReestrKind_Buh()
                                   WHEN tmp.DescId = zc_MIDate_inBuh()       THEN zc_Enum_ReestrKind_inBuh()
                              END 
                       FROM (SELECT ROW_NUMBER() OVER(ORDER BY MID.ValueData desc) AS Num, MID.DescId 
                             FROM MovementItemDate AS MID
                             WHERE MID.MovementItemId = inId
                               AND MID.DescId IN (zc_MIDate_EconomIn(), zc_MIDate_EconomOut(), zc_MIDate_Snab(), zc_MIDate_SnabRe(), zc_MIDate_Econom()
                                                , zc_MIDate_Remake(), zc_MIDate_inBuh(), zc_MIDate_Buh())
                               AND MID.ValueData IS NOT NULL
                       ) AS tmp
                       WHERE tmp.Num = 1);


    -- �������� <��������� �� �������> � ��������� ������� �� ����������
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReestrKind(), vbId_miIncome, COALESCE (vbReestrKindId, zc_Enum_ReestrKind_PartnerIn()));

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.02.25         *
 02.12.20         * ReestrIncome
 17.11.20         * _Log
 20.07.17         *
 29.11.16         *
 24.10.16         *
*/

-- ����
-- SELECT * FROM gpUpdate_MI_Reestr_ReestrKindErased (inBarCode := '4323306' , inOperDate := ('23.10.2016')::TDateTime , inCarId := 340655 , inPersonalDriverId := 0 , inMemberId := 0 , inDocumentId_Transport := 2298218 ,  inSession := '5');
