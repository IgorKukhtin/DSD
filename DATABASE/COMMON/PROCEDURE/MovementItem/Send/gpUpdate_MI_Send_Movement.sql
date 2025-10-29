-- Function: gpUpdate_MI_Send_Movement()

DROP FUNCTION IF EXISTS gpUpdate_MI_Send_Movement (Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_MI_Send_Movement(
    IN inId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inMovementId_new        Integer   , -- ���� ������� <��������>
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbProtocolXML TBlob;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());

     --�������������� �������� � ���������
     UPDATE MovementItem SET MovementId = inMovementId_new
     WHERE MovementItem.Id = inId
     ;


    -- ��������� ��������
   -- �������������� XML ��� ������ � ��������
   SELECT '<XML>' || STRING_AGG (D.FieldXML, '') || '</XML>' INTO vbProtocolXML
   FROM
    (SELECT D.FieldXML
     FROM
    (SELECT '<Field FieldName = "���� �������" FieldValue = "' || Movement.Id || '"/>'
         || '<Field FieldName = "������" FieldValue = " ����� � ���� ����������� ���������"/>'                               --|| zfStrToXmlStr (COALESCE (Movement.Invnumber, 'NULL')) ||
         || '<Field FieldName = "��������" FieldValue = " � ��� ' || Movement.Invnumber || ' �� ' || zfConvert_DateToString (Movement.OperDate) ||' "/>'
         || CASE WHEN MovementItem.ParentId <> 0 THEN '<Field FieldName = "ParentId" FieldValue = "' || MovementItem.ParentId || '"/>' ELSE '' END
         || '<Field FieldName = "������" FieldValue = "' || MovementItem.isErased || '"/>'
            AS FieldXML
          , 1 AS GroupId
          , MovementItem.DescId
     FROM MovementItem
          LEFT JOIN Movement ON Movement.Id = inMovementId
     WHERE MovementItem.Id = inId
    ) AS D
     ORDER BY D.GroupId, D.DescId
    ) AS D
   ;
   -- ���������
   INSERT INTO MovementItemProtocol (MovementItemId, OperDate, UserId, ProtocolData, isInsert)
                             VALUES (inId, current_timestamp, vbUserId, vbProtocolXML, FALSE);
    


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.10.25         *
*/

-- ����
--