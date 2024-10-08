-- Function: gpUpdate_MI_ParamFloat()

--��� MIFloatEditForm , �������� ����   MovementItemFloat , �����, � �������� 

DROP FUNCTION IF EXISTS gpUpdate_MI_ParamFloat (Integer, TVarChar, TVarChar, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_MI_ParamFloat(
    IN inId              Integer  , -- ���� ������    
    IN inDescCode        TVarChar ,
    IN inDescProcess     TVarChar ,
    IN inValue           TFloat   ,
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession
                             , (SELECT ObjectId AS Id 
                                FROM ObjectString 
                                WHERE ValueData = inDescProcess
                                 AND DescId = zc_ObjectString_Enum()));

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemFloat ((SELECT MovementItemFloatDesc.Id
                                                FROM MovementItemFloatDesc
                                                WHERE MovementItemFloatDesc.Code = inDescCode)
                                             , inId
                                             , inValue);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.10.24         *
*/

-- ����
--